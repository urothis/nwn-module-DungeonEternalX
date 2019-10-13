#include "_functions"
#include "nw_i0_spells"
/*
   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;
*/

// GetPureCasterLevel - used to compute durations and damages and include PM levels for Necro Spells
int GetPureCasterLevel(object oCaster, int nSpellSchool);

// GetIsPureCaster - True/False returned if Pure Caster, Considers PM levels for Necro Spells
int GetIsPureCaster(object oCaster);

// GetPureCasterBonus - Returns bonus for DC  - values of 1,2,3,4,6,8 possible
int GetPureCasterBonus(object oCaster, int nSpellSchool, int noFloatingText = FALSE);

// Returns the highest stat modifier of the caster (int, cha, or wis).
int GetCasterModifier(object oCaster);

// Gets the slow rate. ??
int GetSlowRate(object oPC);

// No idea what this does... Arres must be weetoded.
int NoMonkSpeed(object oPC);

// Checks for nekro staff on the pc.
int HasNekrosis(object oPC);

void ReapplyPermaHaste(object oTarget, float fDelay = 0.1);
int HasVirtueHelm(object oPC);

int CheckDeathSpam(object oPC, object oTarget, int nSpamLimit);
int BlockNegativeDamage(object oTarget);

void ReapplyPermaHaste(object oTarget, float fDelay = 0.1)
{
    if (GetIsObjectValid(oTarget))
    {
        effect eHaste = ExtraordinaryEffect(EffectHaste());
        AssignCommand(oTarget, DelayCommand(fDelay, RemoveSpecificEffect(EFFECT_TYPE_HASTE, oTarget)));
        AssignCommand(oTarget, DelayCommand(fDelay+0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHaste, oTarget)));
    }
}

void IncDeathSpam(object oPC, int nInc, int nSpamLimit)
{
   int nCnt = GetMax(0, GetLocalInt(oPC, "DEATHSPAM") + nInc);
   SetLocalInt(oPC, "DEATHSPAM", nCnt);
   FloatingTextStringOnCreature("Death Spell Limit " + IntToString(nCnt) + " of " + IntToString(nSpamLimit), oPC, FALSE);
}

int BlockNegativeDamage(object oTarget)
{
    if (GetHasSpellEffect(SPELL_SHADOW_SHIELD, oTarget)) return TRUE;
    if (GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget)) return TRUE;
    if (GetHasSpellEffect(SPELL_UNDEATHS_ETERNAL_FOE, oTarget)) return TRUE;
    return FALSE;
}

int CheckDeathSpam(object oPC, object oTarget, int nSpamLimit)
{
    if (nSpamLimit >= 100) return TRUE; // unlimited

    int nSpam = GetLocalInt(oPC, "DEATHSPAM");
    if (nSpam >= nSpamLimit)
    {
        FloatingTextStringOnCreature("Your power is still strained from the previous spells...", oPC);
        return FALSE;
    }
    else
    {
        IncDeathSpam(oPC, 1, nSpamLimit);
        AssignCommand(oPC, DelayCommand(RoundsToSeconds(8), IncDeathSpam(oPC, -1, nSpamLimit)));
        return TRUE;
    }
}

int GetIsPureCaster(object oCaster)
{
    if (GetIsObjectValid(GetSpellCastItem())) return FALSE;

    int iDruid = GetLevelByClass(CLASS_TYPE_DRUID, oCaster);
    int iSorc  = GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
    int iPale  = GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster);
    int iWiz   = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
    int iHD    = GetHitDice(oCaster);

    //Checks for caster levels VS. character level (Hit Dice)
    if (iDruid==iHD)
    {
        return TRUE;
    }
    else if (iSorc)
    {
        if (iSorc==iHD) return TRUE;
        else if ((iSorc+iPale)==iHD) return TRUE;
    }
    else if (iWiz)
    {
        if (iWiz==iHD) return TRUE;
        else if ((iWiz+iPale)==iHD) return TRUE;
    }

    return FALSE;
}

int GetPureCasterLevel(object oCaster, int nSpellSchool)
{
    int nLevel = GetCasterLevel(oCaster);

    // Returns Debugging information for developers (set in client enter).
    //if (IsDev(oCaster)) FloatingTextStringOnCreature("GetCasterLevel returns " + IntToString(nLevel), oCaster, FALSE);

    // This handles the pure caster level if they have palemaster levels.
    if (GetIsPureCaster(oCaster) && GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) >= 0 && nSpellSchool == SPELL_SCHOOL_NECROMANCY) {
       nLevel += 2 * GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) / 3;
    }
    return nLevel;  // returns the final caster level.
}

int GetPureCasterBonus(object oCaster, int nSpellSchool, int noFloatingText = FALSE)
{
    int nPure = 0;
    if (GetIsPureCaster(oCaster))
    {
        if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) == 0 || nSpellSchool == SPELL_SCHOOL_NECROMANCY)
        {
            int nPureLevel = GetPureCasterLevel(oCaster, nSpellSchool);
            if (GetHasSpellSchool(oCaster, nSpellSchool)) nPure = nPureLevel / 5; // DOUBLE DC, MAX = 8
            else if (GetLevelByClass(CLASS_TYPE_SORCERER, oCaster)>0) nPure = (nPureLevel*3)/20;
            else nPure = nPureLevel / 10; // MAX = 4


            // Sends caster level information to the caster.
            if(!noFloatingText)
            {
                FloatingTextStringOnCreature("Pure Level " + IntToString(nPureLevel) + " / DC Bonus " + IntToString(nPure), oCaster, FALSE);
            }
        }
    }
    return nPure;
}

int GetCasterModifier(object oCaster)
{
   int nInt = 0;
   int nCha = 0;
   int nWis = 0;
   int nClass = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);

   if (nClass > 0) nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);

   nClass = GetLevelByClass(CLASS_TYPE_BARD, oCaster) + GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
   if (nClass > 0) nCha = GetAbilityModifier(ABILITY_CHARISMA, oCaster);

   nClass = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) + GetLevelByClass(CLASS_TYPE_DRUID, oCaster) +
            GetLevelByClass(CLASS_TYPE_PALADIN, oCaster) + GetLevelByClass(CLASS_TYPE_RANGER, oCaster);
   if (nClass > 0) nWis = GetAbilityModifier(ABILITY_WISDOM, oCaster);

   // GetMax just returns the largest of the modifiers.
   return GetMax(nInt, GetMax(nCha, nWis));
}

int NoMonkSpeed(object oPC)
{
    return TRUE;
    //return !GetHasFeat(FEAT_MONK_ENDURANCE, oPC);
}

int GetSlowRate(object oPC)
{
   int nSlow = 70 - GetAbilityScore(oPC, ABILITY_STRENGTH) * 2;
   return GetMax(10, GetMin(90, nSlow));
}

int HasNekrosis(object oPC)
{
   object oStaff = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
   return (GetResRef(oStaff) == "nekrosisstaff" && GetTag(oStaff) == "SEED_VALIDATED");
}

int HasVaasa(object oPC)
{
   object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
   return (GetStringLeft(GetTag(oShield), 14) == "EPICITEM_VAASA");
}

int HasVirtueHelm(object oPC)
{
   object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
   return (GetStringLeft(GetTag(oHelm), 15) == "EPICITEM_VIRTUE");
}
