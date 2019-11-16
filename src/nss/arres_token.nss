/*#include "x2_inc_switches"
#include "arres_inc"

void DoDragon(object oPC, float fDuration)
{
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nRDDLvl = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC);

    if(!GetIsObjectValid(oArmor)) return;

    itemproperty ipColdVun;

    if(nRDDLvl >= 26) {
        ipColdVun  = ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_COLD, 15);
    }
    if(nRDDLvl >= 30) {
        ipColdVun  = ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEVULNERABILITY_25_PERCENT);
    }

    if(GetIsItemPropertyValid(ipColdVun))  IPSafeAddItemProperty(oArmor, ipColdVun,  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}

void DoSpecialEffect(object oPC, int nClass) {
    if(nClass == CLASS_TYPE_DRAGONDISCIPLE) {
        DelayCommand(0.1, AssignCommand(oPC, ClearAllActions(TRUE)));
        DelayCommand(0.3, AssignCommand(oPC, PolyWithMerge(oPC, POLYMORPH_TYPE_RED_DRAGON, 5.0, TRUE)));
        DelayCommand(0.4, PlayVoiceChat(VOICE_CHAT_BATTLECRY1, oPC));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_STRIKE_HOLY), oPC));
        DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), oPC));
    }
}

void main() {
    int nEvent = GetUserDefinedItemEventNumber();

    int nResult = X2_EXECUTE_SCRIPT_CONTINUE;

    object oPC;

    int nLevel;
    int nStrength;
    int nDexterity;
    int nMonk;
    int iAB = 0;
    int iAC = 0;
    int iFort = 0;
    int iRefl = 0;
    int iWill = 0;
    int iHP = 0;
    int iDisc = 0;
    int nResist = 0;

    int highestClass;
    int nDragon = 0;

    float fDuration;

    effect eLink;
    effect eHP;   // for DD HP

    if (nEvent == X2_ITEM_EVENT_ACTIVATE) {
        oPC = GetItemActivator();

        if (GetLocalInt(oPC, "TOKEN")) {
             FloatingTextStringOnCreature("Bonuses do not stack!", oPC, FALSE);
             return;
        }

        if(GetIsPureFighter(oPC)) {
             FloatingTextStringOnCreature("Pure Fighters cannot use this item!", oPC, FALSE);
             return;
        }

        fDuration = RoundsToSeconds(GetHitDice(oPC))+200;

        SetLocalInt(oPC, "TOKEN", 1);

        DelayCommand(fDuration, DeleteLocalInt(oPC, "TOKEN"));

        nStrength = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
        nDexterity = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
        nMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC);

        nLevel = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
        if(nLevel) {
            if(nLevel >= 15) { iAB += 1; iAC += 1; iFort += 2; iRefl += 0; iWill += 0; }
            if(nLevel >= 20) { iAB += 1; iAC += 0; iFort += 0; iRefl += 0; iWill += 0; }
            if(nLevel >= 25) { iAB += 2; iAC += 1; iFort += 2; iRefl += 3; iWill += 0; }
            if(nLevel >= 30) { iAB += 0; iAC += 2; iFort += 2; iRefl += 2; iWill += 2; }
            if(nLevel >= 35) { iAB += 2; iAC += 2; iFort += 2; iRefl += 2; iWill += 2; }
            if(nLevel >= 40) { iAB += 2; iAC += 2; iFort += 2; iRefl += 2; iWill += 2; }
        }

        nLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
        if(nLevel) {
            if(nLevel >= 10) { iAB += 1; iAC += 0; iFort += 0; iRefl += 0; iWill += 0; }
            if(nLevel >= 14) { iAB += 1; iAC += 0; iFort += 1; iRefl += 1; iWill += 1; }
            if(nLevel >= 18) { iAB += 1; iAC += 1; iFort += 0; iRefl += 0; iWill += 0; }
            if(nLevel >= 22) { iAB += 1; iAC += 0; iFort += 1; iRefl += 1; iWill += 1; }
            if(nLevel >= 26) { iAB += 2; iAC += 0; iFort += 2; iRefl += 2; iWill += 2; }
            if(nLevel >= 30) { iAB += 2; iAC += 2; iFort += 0; iRefl += 0; iWill += 0; }
        }

        nLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
        if(nLevel) {
            if(nLevel >= 10) { iAB += 1; iAC += 0; }
            if(nLevel >= 15) { iAB += 1; iAC += 1; }
            if(nLevel >= 20) { iAB += 1; iAC += 1; }
            if(nLevel >= 25) { iAB += 1; iAC += 1; }
            if(nLevel >= 30) { iAB += 4; iAC += 5; }
        }

        nLevel = GetLevelByClass(CLASS_TYPE_DWARVENDEFENDER, oPC);
        if(nLevel) {
            if(nLevel >= 10) { iAB += 0; iAC += 1; nResist +=   0; iHP +=  10; }
            if(nLevel >= 14) { iAB += 0; iAC += 1; nResist +=   0; iHP +=  10; }
            if(nLevel >= 18) { iAB += 1; iAC += 1; nResist +=   0; iHP +=  10; }
            if(nLevel >= 22) { iAB += 1; iAC += 1; nResist +=  10; iHP +=  20; }
            if(nLevel >= 26) { iAB += 1; iAC += 2; nResist +=  10; iHP +=  50; }
            if(nLevel >= 30) { iAB += 2; iAC += 2; nResist +=  10; iHP += 100; }
        }

        nLevel = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC);
        if(nLevel) {
            if(nLevel >= 14) { iAB += 0; }
            if(nLevel >= 18) { iAB += 0; }
            if(nLevel >= 22) { iAB += 0; }
            if(nLevel >= 26) { iAB += 3; nDragon = 1; iWill += 2;}
            if(nLevel >= 30) { iAB += 4; nDragon = 1; iWill += 2;}
        }

        nLevel = GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC);
        if(nLevel) {
            if(nLevel >= 14) { iAB += 0; iAC += 0; iFort += 1; iDisc += 0; }
            if(nLevel >= 18) { iAB += 0; iAC += 1; iFort += 0; iDisc += 0; }
            if(nLevel >= 22) { iAB += 0; iAC += 1; iFort += 1; iDisc += 2; }
            if(nLevel >= 26) { iAB += 1; iAC += 2; iFort += 2; iDisc += 2; }
            if(nLevel >= 30) { iAB += 3; iAC += 3; iFort += 2; iDisc += 2; }
        }

        if(iAB + iAC + iFort + iRefl + iWill + iHP + iDisc + nResist == 0) {
            FloatingTextStringOnCreature("Class Token does not affect you.", oPC, FALSE);
            FloatingTextStringOnCreature("See the journal for more information.", oPC, FALSE);
            return;
        }

        eLink = EffectVisualEffect(VFX_DUR_GLOW_WHITE);

        highestClass = GetHighestClass(oPC);

        if(highestClass == CLASS_TYPE_RANGER) {
            eLink = EffectVisualEffect(VFX_DUR_AURA_PULSE_GREEN_YELLOW);
        }
        if(highestClass == CLASS_TYPE_ASSASSIN) {
            eLink = EffectVisualEffect(VFX_DUR_AURA_PULSE_MAGENTA_RED);
        }
        if(highestClass == CLASS_TYPE_BLACKGUARD) {
            eLink = EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_BLACK);
        }
        if(highestClass == CLASS_TYPE_DWARVENDEFENDER) {
            eLink = EffectVisualEffect(VFX_DUR_AURA_PULSE_YELLOW_ORANGE);
        }
        if(highestClass == CLASS_TYPE_DRAGONDISCIPLE) {
            eLink = EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_YELLOW);
            if(RandomChance(50, oPC) && !GetIsInCombat(oPC)) DoSpecialEffect(oPC, CLASS_TYPE_DRAGONDISCIPLE);
        }
        if(highestClass == CLASS_TYPE_WEAPON_MASTER) {
            eLink = EffectVisualEffect(VFX_DUR_AURA_PULSE_CYAN_GREEN);
        }

        if(iAB)   eLink = EffectLinkEffects(eLink, EffectAttackIncrease(iAB, EFFECT_TYPE_ATTACK_INCREASE));
        if(iAC)   eLink = EffectLinkEffects(eLink, EffectACIncrease(5 + iAC, AC_DEFLECTION_BONUS));
        if(iFort) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_FORT,   iFort));
        if(iRefl) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, iRefl));
        if(iWill) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL,   iWill));
        if(iHP && !GetLocalInt(oPC, "HP BONUS")) {
            eHP = EffectTemporaryHitpoints(iHP);
            SetLocalInt(oPC, "HP BONUS", 1);
        }
        if(iDisc) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_DISCIPLINE, iDisc));
        if(nResist) {
            eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID,       nResist));
            eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD,       nResist));
            eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist));
            eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE,       nResist));
            eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SONIC,      nResist));

            nLevel = GetLevelByClass(CLASS_TYPE_DWARVENDEFENDER, oPC);
            eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE,   nLevel/2));
            eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_MAGICAL,  nLevel/2));
            eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_POSITIVE, nLevel/2));
            eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_NEGATIVE, nLevel/2));
        }
        if(nDragon) DoDragon(oPC, fDuration);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oPC, fDuration);
        if(iHP) ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eHP), oPC);

        if(iAB)     FloatingTextStringOnCreature("AB +" + IntToString(iAB),                         oPC, FALSE);
        if(iAC)     FloatingTextStringOnCreature("AC +" + IntToString(iAC),                         oPC, FALSE);
        if(iFort)   FloatingTextStringOnCreature("Fort +" + IntToString(iFort),                     oPC, FALSE);
        if(iRefl)   FloatingTextStringOnCreature("Reflex +" + IntToString(iRefl),                   oPC, FALSE);
        if(iWill)   FloatingTextStringOnCreature("Will +" + IntToString(iWill),                     oPC, FALSE);
        if(iHP)     FloatingTextStringOnCreature("HP +" + IntToString(iHP),                         oPC, FALSE);
        if(iDisc)   FloatingTextStringOnCreature("Discipline +" + IntToString(iDisc),               oPC, FALSE);
        if(nResist) FloatingTextStringOnCreature("Elemental Resist " + IntToString(nResist) + "/-", oPC, FALSE);
    }
    SetExecutedScriptReturnValue(nResult);
}*/
