//:://////////////////////////////////////////////
//:: Script Name: salv_attacks
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Mizzajl@Hotmail.com
//:: Created On: 2018-01-26
//:://////////////////////////////////////////////
/*

Include file for Attacks and weapon/unarmed damage.



*/
//:://////////////////////////////////////////////

//#include "x2_inc_itemprop"
#include "x2_i0_spells"
//#include "r4s_spells"

// Make an attack roll vs target
// sHand: "Left", "Right", "Unarmed", "DoubleMainhand", "DoubleOffhand"
int DoAttackRoll(object oTarget, string sHand, object oSelf = OBJECT_SELF, int bFeedback = FALSE);
// Returns the base damage with the specified weapon
// sReturn:
//  "Roll" returns the damage roll
//  "Min" returns the min damage
//  "Max" returns the max damage
int GetWeaponBaseDamage(object oWeapon, string sReturn = "");
// Returns the weapons crit range
int GetWeaponBaseCritRange(object oWeapon);
// Returns the weapons Crit Multiplier
int GetWeaponBaseCritMultiplier(object oWeapon);
// nFeat: 1=DevCrit, 2=OverWhelmCrit, 3=EpicFocus, 4=EpicSpec, 5=WeaponChoice, 6=ImpCrit, 7=Focus, 8=Spec
// sHand: "Left", "Right", "Unarmed", "DoubleMainhand", "DoubleOffhand"
int GetHasWeaponFeat(object oTarget, string sHand, int nFeat);
// Returns the unarmed damage
int GetUnarmedDamage(object oTarget);
// Returns true if the target is weilding a weapon in each hand
int GetIsDualWielding(object oTarget);
// Returns the size of oWeapon
int GetWeaponSize(object oWeapon);
// Returns TRUE if oTarget is Medium Size and using a Double-Sided Weapon
int GetUsingDoubleSidedWeapon(object oTarget);
// Returns TRUE if oTaget can use Weapon Finesse with weapon in sHand
// sHand: "Left", "Right", "Unarmed", "DoubleMainhand", "DoubleOffhand"
int GetFinessable(object oTarget, string sHand);
// Returns the weapon or gloves attack bonus item property
int IPGetWeaponAttackBonus(object oWeapon, int nAttackBonusType = ITEM_PROPERTY_ATTACK_BONUS);
// Returns the attack bonus of all effects on the target
int GetEffectAttackBonus(object oTarget, int nEffectType = EFFECT_TYPE_ATTACK_INCREASE);
// Returns the attack bonus/penalty of Combat Modes
int GetCombatModeAttackBonus(object oTarget);
// Returns the damage bonus/penalty of Combat Modes
int GetCombatModeDamageBonus(object oTarget);
// Returns the item property damage bonus of an item
int IPGetWeaponDamageBonus(object oWeapon, int nDamageType);
// Returns the damage bonus of all effects on the target
int GetEffectDamageBonus(object oTarget, int nDamageType);
// ----------------------------------------------------------------------------
// reverse IPGetDamageBonusConstantFromNumber
// sReturn:
//  "Min" returns min damage
//  "Max" returns max damage
//  else return the roll
// ----------------------------------------------------------------------------
int IPGetDamageBonusFromConstantValue(int nNumber, string sReturn = "");
// Perform a Devastating Critical
void SalvDevastatingCritical(object oTarget, object oPC, int nDamage);
// Deal the Devastating Critical Bleed Damage
void SalvDevastatingCriticalBleed(object oTarget, object oCaster, int nDamage, float fDuration);






// Make an attack roll vs target
// sHand: "Left", "Right", "Unarmed", "DoubleMainhand", "DoubleOffhand"
int DoAttackRoll(object oTarget, string sHand, object oSelf = OBJECT_SELF, int bFeedback = FALSE)
{
    object oWeapon;
    if (sHand == "Right")
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    }
    else if (sHand == "Left")
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    }
    else if (sHand == "Unarmed")
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS);
    }

    int nBab = GetBaseAttackBonus(oSelf);
    int nStr = GetAbilityModifier(ABILITY_STRENGTH, oSelf);
    int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oSelf);
    int nWis = GetAbilityModifier(ABILITY_WISDOM, oSelf);
    int nAttackRoll = d20();
    int nThreatRoll;
    int nAbilityMod;

    int nBaseCritRange;
    int nCritRange;
    int nBaseCritRange2;
    int nCritRange2;
    int nCritRoll;
    int nCritRoll2;

    object oMH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSelf);
    object oOH;

    int bFinesse = GetFinessable(oSelf, sHand);
    int bZenArchery = GetHasFeat(FEAT_ZEN_ARCHERY, oSelf);

    if (bZenArchery && GetWeaponRanged(oWeapon) && nWis > nDex)
    {
        nAbilityMod = nWis;
    }
    else if (bFinesse && nDex > nStr)
    {
        nAbilityMod = nDex;
    }
    else if (GetWeaponRanged(oWeapon))
    {
        nAbilityMod = nDex;
    }
    else
    {
        nAbilityMod = nStr;
    }

    int nFeatMod;
    if (GetHasWeaponFeat(oSelf, sHand, 7)) nFeatMod += 1;
    if (GetHasWeaponFeat(oSelf, sHand, 3)) nFeatMod += 2;
    if (GetHasFeat(FEAT_EPIC_PROWESS, oSelf)) nFeatMod += 1;


    // Dual Wielding Feats
    int nDualWieldPen;
    if (GetIsDualWielding(oSelf))
    {
        if (sHand == "Right")
        {
            nDualWieldPen = -6;
            if (GetWeaponSize(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSelf)) < GetCreatureSize(oSelf) || GetUsingDoubleSidedWeapon(oSelf) ) nFeatMod += 2;
            if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oSelf)) nFeatMod += 2;
        }
        if (sHand == "Left")
        {
            nDualWieldPen = -10;
            if (GetWeaponSize(oWeapon) < GetCreatureSize(oSelf) || GetUsingDoubleSidedWeapon(oSelf)) nFeatMod += 2;
            if (GetHasFeat(FEAT_AMBIDEXTERITY, oSelf)) nFeatMod += 4;
            if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oSelf)) nFeatMod += 2;
        }
    }

    // Weapon Master Attack Bonus
    if (GetHasWeaponFeat(oSelf, sHand, 5) && GetHasFeat(FEAT_SUPERIOR_WEAPON_FOCUS, oSelf)) nFeatMod += 1;
    if (GetHasWeaponFeat(oSelf, sHand, 5) && GetHasFeat(FEAT_EPIC_SUPERIOR_WEAPON_FOCUS, oSelf))
    {
        int nWM = GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oSelf);
        nFeatMod += (nWM - 10) / 3;
    }

    // Arcane Archer Attack Bonus
    int nAA = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER);
    if ( nAA && GetWeaponRanged(oWeapon) && MatchNormalBow(oWeapon)) nFeatMod += (nAA + 1) / 2;


    // Item Property Attack Bonus or Enhancement Bonus
    int nItemMod;
    int nWAB = IPGetWeaponAttackBonus(oWeapon);
    //SendMessageToPC(oSelf, "Item Attack Bonus: "+IntToString(nWAB));
    int nEnh = IPGetWeaponEnhancementBonus(oWeapon);
    //SendMessageToPC(oSelf, "Item Enhancement Bonus: "+IntToString(nEnh));

    if (nWAB > nEnh) nItemMod = nWAB;
    else nItemMod = nEnh;


    // Effect Attack Bonus
    int nEffectAB = GetEffectAttackBonus(oSelf);


    // Combat Mode Attack Bonus
    int nModeAB = GetCombatModeAttackBonus(oSelf);
    //SendMessageToPC(oSelf, "Combat Mode Attack: "+IntToString(nModeAB));




    // Get Crit Range
    if (GetIsObjectValid(oMH))
    {
        // got a wapon
        if (IPGetIsMeleeWeapon(oMH))
        {
            // is melee
            nBaseCritRange = GetWeaponBaseCritRange(oMH);
            nCritRange = nBaseCritRange;

            // Improved Critical
            if ( GetHasWeaponFeat(oSelf, "Right", 6) ) nCritRange += nBaseCritRange;

            // Ki Critical
            if ( GetHasFeat(FEAT_KI_CRITICAL) && GetHasWeaponFeat(oSelf, "Right", 5) ) nCritRange += 2;

            // add keen here
            if (GetItemHasItemProperty(oMH, ITEM_PROPERTY_KEEN)) nCritRange += nBaseCritRange;

            // Check if double sided
            if (GetUsingDoubleSidedWeapon(oSelf))
            {
                nBaseCritRange2 = GetWeaponBaseCritRange(oMH);
                nCritRange2 = nBaseCritRange2;

                // Improved Critical
                if ( GetHasWeaponFeat(oSelf, "Right", 6) ) nCritRange2 += nBaseCritRange2;

                // Ki Critical
                if ( GetHasFeat(FEAT_KI_CRITICAL, oSelf) && GetHasWeaponFeat(oSelf, "Right", 5) ) nCritRange2 += 2;

                // add keen here
                if (GetItemHasItemProperty(oMH, ITEM_PROPERTY_KEEN)) nCritRange += nBaseCritRange;
            }


        }
        oOH = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSelf);
        if (GetIsObjectValid(oOH))
        {
            //got offhand item
            if (IPGetIsMeleeWeapon(oOH))
            {
                //offhand is melee
                nBaseCritRange2 = GetWeaponBaseCritRange(oOH);
                nCritRange2 = nBaseCritRange2;

                // Improved Critical
                if ( GetHasWeaponFeat(oSelf, "Left", 6) ) nCritRange2 += nBaseCritRange2;

                // Ki Critical
                if ( GetHasFeat(FEAT_KI_CRITICAL, oSelf) && GetHasWeaponFeat(oSelf, "Left", 5) ) nCritRange2 += 2;

                // add keen here
                if (GetItemHasItemProperty(oOH, ITEM_PROPERTY_KEEN)) nCritRange += nBaseCritRange;

            }
        }
    }
    else //no weapon, unarmed
    {
        SendMessageToPC(oSelf, "Im Unarmed!");
        nBaseCritRange = 1;
        nCritRange = nBaseCritRange;
        // Improved Critical
        if ( GetHasWeaponFeat(oSelf, "Unarmed", 6) )
        {
            SendMessageToPC(oSelf, "Got Improved Crit!");
            nCritRange += nBaseCritRange;
        }
        oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oSelf);
        if (GetIsObjectValid(oWeapon))
        {
            // add keen here
            if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_KEEN)) nCritRange += nBaseCritRange;
        }

    }


    // Reverse the range
    nCritRange = 21 - nCritRange;
    nCritRange2 = 21 - nCritRange2;

    int nAC = GetAC(oTarget);
    int nAttack = nBab + nAbilityMod + nFeatMod + nItemMod + nEffectAB + nModeAB + nDualWieldPen;

    int nReturn;
    string sHit;
    string sAttack;
    string sCalc;
    string sThreat;
    string sEnd;

    //Hit
    if (nAttack + nAttackRoll >= nAC || nAttackRoll == 20)
    {
        if (nAttackRoll >= nCritRange)
        {
            nThreatRoll = d20();
            sThreat = " : Threat Roll: "
                +IntToString(nThreatRoll)
                +" + "
                + IntToString(nAttack)
                + " = "
                + IntToString(nThreatRoll+nAttack);

            if (nAttack + nThreatRoll >= nAC)
            {
                sHit = " *Critical Hit* : ";
                nReturn = 2;
            }
            else
            {
                sHit = " *Hit* : ";
                nReturn = 1;
            }

        }
        else
        {
            sHit = " *Hit* : ";
            sThreat = "";
            nReturn = 1;
        }
    }
    //Miss
    else if ( nAttack + nAttackRoll < nAC || nAttackRoll == 1)
    {
        sHit = " *Miss* : ";
        sThreat = "";
        nReturn = 0;
    }

    // Feedback
    if (bFeedback)
    {
        string sAttacker = GetName(oSelf);
        string sAttackee = GetName(oTarget);

        sAttack =
            sAttacker
            + " attacks "
            + sAttackee
            + sHit;
        sCalc =
            IntToString(nAttackRoll)
            +" + "
            + IntToString(nAttack)
            + " = "
            + IntToString(nAttackRoll+nAttack);
        sEnd = " ) ";

        SendMessageToPC(oSelf, sAttack+sCalc+sThreat+sEnd);

    }

    return nReturn;

}

/*
effect TempCritThing(object oWeapon, int bCrit, object oSelf, object oTarget)
{
    if ( bCrit ) nDamage *= nCritMulti;
    if ( bCrit && bOWCrit ) nDamage += (d6(nCritMulti));
    if ( bCrit && bDevCrit )
    {
        int nDC = 10 + (nLevel / 2) + nStr;
        if (!FortitudeSave(oTarget, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF))
        {
            effect eDeath = EffectDeath(TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
        }
    }

    effect eDamage = EffectDamage(nDamage, nDamageType);
    return eDamage;
} */


// Returns the base damage with the specified weapon
// sReturn:
//  "Roll" returns the damage roll
//  "Min" returns the min damage
//  "Max" returns the max damage
int GetWeaponBaseDamage(object oWeapon, string sReturn = "")
{
    int nDamage, nMin, nMax;
    int nWeapon = GetBaseItemType(oWeapon);
    switch ( nWeapon )
    {
        case BASE_ITEM_BASTARDSWORD:    nDamage = d10();    nMin = 1; nMax = 10;    break;
        case BASE_ITEM_BATTLEAXE:       nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_CLUB:            nDamage = d6();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_DAGGER:          nDamage = d4();     nMin = 1; nMax = 4;    break;
        case BASE_ITEM_DIREMACE:        nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_DOUBLEAXE:       nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_DWARVENWARAXE:   nDamage = d10();    nMin = 1; nMax = 10;    break;
        case BASE_ITEM_GREATAXE:        nDamage = d12();    nMin = 1; nMax = 12;    break;
        case BASE_ITEM_GREATSWORD:      nDamage = d6(2);    nMin = 2; nMax = 12;    break;
        case BASE_ITEM_HALBERD:         nDamage = d10();    nMin = 1; nMax = 10;    break;
        case BASE_ITEM_HANDAXE:         nDamage = d6();     nMin = 1; nMax = 6;    break;
        case BASE_ITEM_HEAVYFLAIL:      nDamage = d10();    nMin = 1; nMax = 10;    break;
        case BASE_ITEM_KAMA:            nDamage = d6();     nMin = 1; nMax = 6;    break;
        case BASE_ITEM_KATANA:          nDamage = d10();    nMin = 1; nMax = 10;    break;
        case BASE_ITEM_KUKRI:           nDamage = d4();     nMin = 1; nMax = 4;    break;
        case BASE_ITEM_LIGHTFLAIL:      nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_LIGHTHAMMER:     nDamage = d4();     nMin = 1; nMax = 4;    break;
        case BASE_ITEM_LIGHTMACE:       nDamage = d6();     nMin = 1; nMax = 6;    break;
        case BASE_ITEM_LONGSWORD:       nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_MAGICSTAFF:      nDamage = d6();     nMin = 1; nMax = 6;    break;
        case BASE_ITEM_MORNINGSTAR:     nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_QUARTERSTAFF:    nDamage = d6();     nMin = 1; nMax = 6;    break;
        case BASE_ITEM_RAPIER:          nDamage = d6();     nMin = 1; nMax = 6;    break;
        case BASE_ITEM_SCIMITAR:        nDamage = d6();     nMin = 1; nMax = 6;    break;
        case BASE_ITEM_SCYTHE:          nDamage = d4(2);    nMin = 2; nMax = 8;    break;
        case BASE_ITEM_SHORTSPEAR:      nDamage = d8();     nMin = 1; nMax = 8;     break;
        case BASE_ITEM_SHORTSWORD:      nDamage = d6();     nMin = 1; nMax = 6;    break;
        case BASE_ITEM_SICKLE:          nDamage = d6();     nMin = 1; nMax = 6;    break;
        case BASE_ITEM_TRIDENT:         nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_TWOBLADEDSWORD:  nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_WARHAMMER:       nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_WHIP:            nDamage = d2();     nMin = 1; nMax = 2;    break;

        case BASE_ITEM_HEAVYCROSSBOW:   nDamage = d10();    nMin = 1; nMax = 10;    break;
        case BASE_ITEM_LIGHTCROSSBOW:   nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_LONGBOW:         nDamage = d8();     nMin = 1; nMax = 8;    break;
        case BASE_ITEM_SHORTBOW:        nDamage = d6();     nMin = 1; nMax = 6;    break;
        case BASE_ITEM_DART:            nDamage = d4();     nMin = 1; nMax = 4;    break;
        case BASE_ITEM_SHURIKEN:        nDamage = d3();     nMin = 1; nMax = 3;    break;
        case BASE_ITEM_SLING:           nDamage = d4();     nMin = 1; nMax = 4;    break;
        case BASE_ITEM_THROWINGAXE:     nDamage = d6();     nMin = 1; nMax = 6;    break;

        case BASE_ITEM_GLOVES:          nDamage = d3();     nMin = 1; nMax = 10;    break;
        case BASE_ITEM_INVALID:         nDamage = d3();     nMin = 1; nMax = 10;    break;
        default:                        nDamage = d3();     nMin = 1; nMax = 10;    break;
    }

    if (sReturn == "Min") return nMin;
    else if (sReturn == "Max") return nMax;
    else return nDamage;
}

// Returns the weapons crit range
int GetWeaponBaseCritRange(object oWeapon)
{
    int nWeapon = GetBaseItemType(oWeapon);
    int nRange;
    switch ( nWeapon )
    {
        case BASE_ITEM_BASTARDSWORD:    nRange = 2;     break;
        case BASE_ITEM_DAGGER:          nRange = 2;     break;
        case BASE_ITEM_GREATSWORD:      nRange = 2;     break;
        case BASE_ITEM_HEAVYFLAIL:      nRange = 2;     break;
        case BASE_ITEM_KATANA:          nRange = 2;     break;
        case BASE_ITEM_KUKRI:           nRange = 3;     break;
        case BASE_ITEM_LONGSWORD:       nRange = 2;     break;
        case BASE_ITEM_RAPIER:          nRange = 3;     break;
        case BASE_ITEM_SCIMITAR:        nRange = 3;     break;
        case BASE_ITEM_SHORTSWORD:      nRange = 2;     break;
        case BASE_ITEM_TWOBLADEDSWORD:  nRange = 2;     break;
        case BASE_ITEM_HEAVYCROSSBOW:   nRange = 2;     break;
        case BASE_ITEM_LIGHTCROSSBOW:   nRange = 2;     break;
        default:                        nRange = 1;     break;
    }
    return nRange;
}

// Returns the weapons Crit Multiplier
int GetWeaponBaseCritMultiplier(object oWeapon)
{
    int nWeapon = GetBaseItemType(oWeapon);
    int nMultiplier;
    switch ( nWeapon )
    {
        case BASE_ITEM_BATTLEAXE:       nMultiplier = 3;    break;
        case BASE_ITEM_WARHAMMER:       nMultiplier = 3;    break;
        case BASE_ITEM_LONGBOW:         nMultiplier = 3;    break;
        case BASE_ITEM_HALBERD:         nMultiplier = 3;    break;
        case BASE_ITEM_SHORTBOW:        nMultiplier = 3;    break;
        case BASE_ITEM_GREATAXE:        nMultiplier = 3;    break;
        case BASE_ITEM_DOUBLEAXE:       nMultiplier = 3;    break;
        case BASE_ITEM_HANDAXE:         nMultiplier = 3;    break;
        case BASE_ITEM_SHORTSPEAR:      nMultiplier = 3;    break;
        case BASE_ITEM_DWARVENWARAXE:   nMultiplier = 3;    break;
        case BASE_ITEM_SCYTHE:          nMultiplier = 4;    break;
        default:                        nMultiplier = 2;    break;
    }
    return nMultiplier;
}

// nFeat: 1=DevCrit, 2=OverWhelmCrit, 3=EpicFocus, 4=EpicSpec, 5=WeaponChoice, 6=ImpCrit, 7=Focus, 8=Spec
// sHand: "Left", "Right", "Unarmed", "DoubleMainhand", "DoubleOffhand"
int GetHasWeaponFeat(object oTarget, string sHand, int nFeat)
{
    int nDev, nOWC, nEWF, nEWS, nWOC, nIC, nWF, nWS;
    int nWeapon;
    if (sHand == "Right")
    {
        nWeapon = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget));
    }
    else if (sHand == "Left")
    {
        nWeapon = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget));
    }
    else if (sHand == "Unarmed")
    {
        nWeapon = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget));
    }

    switch ( nWeapon )
    {
        case BASE_ITEM_SHORTSWORD:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD;
        nWOC = FEAT_WEAPON_OF_CHOICE_SHORTSWORD;

        nIC  = FEAT_IMPROVED_CRITICAL_SHORT_SWORD;
        nWF  = FEAT_WEAPON_FOCUS_SHORT_SWORD;
        nWS  = FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD;
        break;

        case BASE_ITEM_LONGSWORD:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_LONGSWORD;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD;
        nWOC = FEAT_WEAPON_OF_CHOICE_LONGSWORD;

        nIC  = FEAT_IMPROVED_CRITICAL_LONG_SWORD;
        nWF  = FEAT_WEAPON_FOCUS_LONG_SWORD;
        nWS  = FEAT_WEAPON_SPECIALIZATION_LONG_SWORD;
        break;

        case BASE_ITEM_BATTLEAXE:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE;
        nWOC = FEAT_WEAPON_OF_CHOICE_BATTLEAXE;

        nIC  = FEAT_IMPROVED_CRITICAL_BATTLE_AXE;
        nWF  = FEAT_WEAPON_FOCUS_BATTLE_AXE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE;
        break;

        case BASE_ITEM_BASTARDSWORD:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD;
        nWOC = FEAT_WEAPON_OF_CHOICE_BASTARDSWORD;

        nIC  = FEAT_IMPROVED_CRITICAL_BASTARD_SWORD;
        nWF  = FEAT_WEAPON_FOCUS_BASTARD_SWORD;
        nWS  = FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD;
        break;

        case BASE_ITEM_LIGHTFLAIL:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL;
        nWOC = FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL;

        nIC  = FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL;
        nWF  = FEAT_WEAPON_FOCUS_LIGHT_FLAIL;
        nWS  = FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL;
        break;

        case BASE_ITEM_WARHAMMER:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_WARHAMMER;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER;
        nWOC = FEAT_WEAPON_OF_CHOICE_WARHAMMER;

        nIC  = FEAT_IMPROVED_CRITICAL_WAR_HAMMER;
        nWF  = FEAT_WEAPON_FOCUS_WAR_HAMMER;
        nWS  = FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER;
        break;

        //shortsword
        //longsword
        //battleaxe
        //bastardsword
        //lightflail
        //warhammer
        //heavycrossbow
        case BASE_ITEM_HEAVYCROSSBOW:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYCROSSBOW;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYCROSSBOW;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_HEAVYCROSSBOW;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYCROSSBOW;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW;
        nWF  = FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW;
        nWS  = FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW;
        break;

        //lightcrossbow
        case BASE_ITEM_LIGHTCROSSBOW:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTCROSSBOW;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTCROSSBOW;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_LIGHTCROSSBOW;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTCROSSBOW;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW;
        nWF  = FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW;
        nWS  = FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW;
        break;

        //longbow
        case BASE_ITEM_LONGBOW:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_LONGBOW;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_LONGBOW;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_LONGBOW;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_LONGBOW;
        nWF  = FEAT_WEAPON_FOCUS_LONGBOW;
        nWS  = FEAT_WEAPON_SPECIALIZATION_LONGBOW;
        break;

        //lightmace
        case BASE_ITEM_LIGHTMACE:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE;
        nWOC = FEAT_WEAPON_OF_CHOICE_LIGHTMACE;

        nIC  = FEAT_IMPROVED_CRITICAL_LIGHT_MACE;
        nWF  = FEAT_WEAPON_FOCUS_LIGHT_MACE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE;
        break;

        //halberd
        case BASE_ITEM_HALBERD:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_HALBERD;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD;
        nWOC = FEAT_WEAPON_OF_CHOICE_HALBERD;

        nIC  = FEAT_IMPROVED_CRITICAL_HALBERD;
        nWF  = FEAT_WEAPON_FOCUS_HALBERD;
        nWS  = FEAT_WEAPON_SPECIALIZATION_HALBERD;
        break;

        //shortbow
        case BASE_ITEM_SHORTBOW:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_SHORTBOW;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTBOW;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_SHORTBOW;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_SHORTBOW;
        nWF  = FEAT_WEAPON_FOCUS_SHORTBOW;
        nWS  = FEAT_WEAPON_SPECIALIZATION_SHORTBOW;
        break;

        //twobladedsword
        case BASE_ITEM_TWOBLADEDSWORD:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD;
        nWOC = FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD;

        nIC  = FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD;
        nWF  = FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD;
        nWS  = FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD;
        break;

        //greatsword
        case BASE_ITEM_GREATSWORD:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_GREATSWORD;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD;
        nWOC = FEAT_WEAPON_OF_CHOICE_GREATSWORD;

        nIC  = FEAT_IMPROVED_CRITICAL_GREAT_SWORD;
        nWF  = FEAT_WEAPON_FOCUS_GREAT_SWORD;
        nWS  = FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD;
        break;

        //greataxe
        case BASE_ITEM_GREATAXE:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_GREATAXE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE;
        nWOC = FEAT_WEAPON_OF_CHOICE_GREATAXE;

        nIC  = FEAT_IMPROVED_CRITICAL_GREAT_AXE;
        nWF  = FEAT_WEAPON_FOCUS_GREAT_AXE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_GREAT_AXE;
        break;

        //dagger
        case BASE_ITEM_DAGGER:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_DAGGER;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
        nWOC = FEAT_WEAPON_OF_CHOICE_DAGGER;

        nIC  = FEAT_IMPROVED_CRITICAL_DAGGER;
        nWF  = FEAT_WEAPON_FOCUS_DAGGER;
        nWS  = FEAT_WEAPON_SPECIALIZATION_DAGGER;
        break;

        //club
        case BASE_ITEM_CLUB:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_CLUB;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_CLUB;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB;
        nWOC = FEAT_WEAPON_OF_CHOICE_CLUB;

        nIC  = FEAT_IMPROVED_CRITICAL_CLUB;
        nWF  = FEAT_WEAPON_OF_CHOICE_CLUB;
        nWS  = FEAT_WEAPON_SPECIALIZATION_CLUB;
        break;

        //dart
        case BASE_ITEM_DART:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_DART;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_DART;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_DART;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_DART;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_DART;
        nWF  = FEAT_WEAPON_FOCUS_DART;
        nWS  = FEAT_WEAPON_SPECIALIZATION_DART;
        break;

        //diremace
        case BASE_ITEM_DIREMACE:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_DIREMACE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE;
        nWOC = FEAT_WEAPON_OF_CHOICE_DIREMACE;

        nIC  = FEAT_IMPROVED_CRITICAL_DIRE_MACE;
        nWF  = FEAT_WEAPON_FOCUS_DIRE_MACE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_DIRE_MACE;
        break;

        //doubleaxe
        case BASE_ITEM_DOUBLEAXE:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE;
        nWOC = FEAT_WEAPON_OF_CHOICE_DOUBLEAXE;

        nIC  = FEAT_IMPROVED_CRITICAL_DOUBLE_AXE;
        nWF  = FEAT_WEAPON_FOCUS_DOUBLE_AXE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE;
        break;

        //heavyflail
        case BASE_ITEM_HEAVYFLAIL:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL;
        nWOC = FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL;

        nIC  = FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL;
        nWF  = FEAT_WEAPON_FOCUS_HEAVY_FLAIL;
        nWS  = FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL;
        break;

        //gloves
        case BASE_ITEM_GLOVES:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_UNARMED;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE;
        nWF  = FEAT_WEAPON_FOCUS_UNARMED_STRIKE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE;
        break;

        //lighthammer
        case BASE_ITEM_LIGHTHAMMER:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER;
        nWOC = FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER;

        nIC  = FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER;
        nWF  = FEAT_WEAPON_FOCUS_LIGHT_HAMMER;
        nWS  = FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER;
        break;

        //handaxe
        case BASE_ITEM_HANDAXE:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_HANDAXE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE;
        nWOC = FEAT_WEAPON_OF_CHOICE_HANDAXE;

        nIC  = FEAT_IMPROVED_CRITICAL_HAND_AXE;
        nWF  = FEAT_WEAPON_FOCUS_HAND_AXE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_HAND_AXE;
        break;

        //kama
        case BASE_ITEM_KAMA:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_KAMA;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_KAMA;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA;
        nWOC = FEAT_WEAPON_OF_CHOICE_KAMA;

        nIC  = FEAT_IMPROVED_CRITICAL_KAMA;
        nWF  = FEAT_WEAPON_FOCUS_KAMA;
        nWS  = FEAT_WEAPON_SPECIALIZATION_KAMA;
        break;

        //katana
        case BASE_ITEM_KATANA:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_KATANA;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_KATANA;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA;
        nWOC = FEAT_WEAPON_OF_CHOICE_KATANA;

        nIC  = FEAT_IMPROVED_CRITICAL_KATANA;
        nWF  = FEAT_WEAPON_FOCUS_KATANA;
        nWS  = FEAT_WEAPON_SPECIALIZATION_KATANA;
        break;

        //kukri
        case BASE_ITEM_KUKRI:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_KUKRI;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI;
        nWOC = FEAT_WEAPON_OF_CHOICE_KUKRI;

        nIC  = FEAT_IMPROVED_CRITICAL_KUKRI;
        nWF  = FEAT_WEAPON_FOCUS_KUKRI;
        nWS  = FEAT_WEAPON_SPECIALIZATION_KUKRI;
        break;

        //magicstaff
        case BASE_ITEM_MAGICSTAFF:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF;
        nWOC = FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF;

        nIC  = FEAT_IMPROVED_CRITICAL_STAFF;
        nWF  = FEAT_WEAPON_FOCUS_STAFF;
        nWS  = FEAT_WEAPON_SPECIALIZATION_STAFF;
        break;

        //morningstar
        case BASE_ITEM_MORNINGSTAR:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR;
        nWOC = FEAT_WEAPON_OF_CHOICE_MORNINGSTAR;

        nIC  = FEAT_IMPROVED_CRITICAL_MORNING_STAR;
        nWF  = FEAT_WEAPON_FOCUS_MORNING_STAR;
        nWS  = FEAT_WEAPON_SPECIALIZATION_MORNING_STAR;
        break;

        //quarterstaff
        case BASE_ITEM_QUARTERSTAFF:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF;
        nWOC = FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF;

        nIC  = FEAT_IMPROVED_CRITICAL_STAFF;
        nWF  = FEAT_WEAPON_FOCUS_STAFF;
        nWS  = FEAT_WEAPON_SPECIALIZATION_STAFF;
        break;

        //rapier
        case BASE_ITEM_RAPIER:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_RAPIER;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER;
        nWOC = FEAT_WEAPON_OF_CHOICE_RAPIER;

        nIC  = FEAT_IMPROVED_CRITICAL_RAPIER;
        nWF  = FEAT_WEAPON_FOCUS_RAPIER;
        nWS  = FEAT_WEAPON_SPECIALIZATION_RAPIER;
        break;

        //scimitar
        case BASE_ITEM_SCIMITAR:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_SCIMITAR;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR;
        nWOC = FEAT_WEAPON_OF_CHOICE_SCIMITAR;

        nIC  = FEAT_IMPROVED_CRITICAL_SCIMITAR;
        nWF  = FEAT_WEAPON_FOCUS_SCIMITAR;
        nWS  = FEAT_WEAPON_SPECIALIZATION_SCIMITAR;
        break;

        //scythe
        case BASE_ITEM_SCYTHE:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_SCYTHE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE;
        nWOC = FEAT_WEAPON_OF_CHOICE_SCYTHE;

        nIC  = FEAT_IMPROVED_CRITICAL_SCYTHE;
        nWF  = FEAT_WEAPON_FOCUS_SCYTHE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_SCYTHE;
        break;

        //shortspear
        case BASE_ITEM_SHORTSPEAR:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR;
        nWOC = FEAT_WEAPON_OF_CHOICE_SHORTSPEAR;

        nIC  = FEAT_IMPROVED_CRITICAL_SPEAR;
        nWF  = FEAT_WEAPON_FOCUS_SPEAR;
        nWS  = FEAT_WEAPON_SPECIALIZATION_SPEAR;
        break;

        //shuriken
        case BASE_ITEM_SHURIKEN:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_SHURIKEN;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_SHURIKEN;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_SHURIKEN;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_SHURIKEN;
        nWF  = FEAT_WEAPON_FOCUS_SHURIKEN;
        nWS  = FEAT_WEAPON_SPECIALIZATION_SHURIKEN;
        break;

        //sickle
        case BASE_ITEM_SICKLE:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_SICKLE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE;
        nWOC = FEAT_WEAPON_OF_CHOICE_SICKLE;

        nIC  = FEAT_IMPROVED_CRITICAL_SICKLE;
        nWF  = FEAT_WEAPON_FOCUS_SICKLE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_SICKLE;
        break;

        //sling
        case BASE_ITEM_SLING:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_SLING;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_SLING;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_SLING;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_SLING;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_SLING;
        nWF  = FEAT_WEAPON_FOCUS_SLING;
        nWS  = FEAT_WEAPON_SPECIALIZATION_SLING;
        break;

        //throwingaxe
        case BASE_ITEM_THROWINGAXE:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_THROWINGAXE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_THROWINGAXE;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_THROWING_AXE;
        nWF  = FEAT_WEAPON_FOCUS_THROWING_AXE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_THROWING_AXE;
        break;

        //cslashweapon
        //cpiercweapon
        //cbludgweapon
        //cslshprcweap
        case BASE_ITEM_CREATUREITEM:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_CREATURE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_CREATURE;
        nWF  = FEAT_WEAPON_FOCUS_CREATURE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_CREATURE;
        break;

        //Lance

        //trident
        case BASE_ITEM_TRIDENT:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_TRIDENT;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_TRIDENT;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_TRIDENT;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_TRIDENT;
        nWOC = FEAT_WEAPON_OF_CHOICE_TRIDENT;

        nIC  = FEAT_IMPROVED_CRITICAL_TRIDENT;
        nWF  = FEAT_WEAPON_FOCUS_TRIDENT;
        nWS  = FEAT_WEAPON_OF_CHOICE_TRIDENT;
        break;

        //dwarvenwaraxe
        case BASE_ITEM_DWARVENWARAXE:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_DWAXE;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE;
        nWOC = FEAT_WEAPON_OF_CHOICE_DWAXE;

        nIC  = FEAT_IMPROVED_CRITICAL_DWAXE;
        nWF  = FEAT_WEAPON_FOCUS_DWAXE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_DWAXE;
        break;

        //Whip
        case BASE_ITEM_WHIP:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_WHIP;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_WHIP;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP;
        nWOC = FEAT_WEAPON_SPECIALIZATION_WHIP;

        nIC  = FEAT_IMPROVED_CRITICAL_WHIP;
        nWF  = FEAT_WEAPON_FOCUS_WHIP;
        nWS  = FEAT_WEAPON_SPECIALIZATION_WHIP;
        break;

        default:
        nDev = FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED;
        nOWC = FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED;
        nEWF = FEAT_EPIC_WEAPON_FOCUS_UNARMED;
        nEWS = FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED;
        nWOC = 0;

        nIC  = FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE;
        nWF  = FEAT_WEAPON_FOCUS_UNARMED_STRIKE;
        nWS  = FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE;
        break;
    }

    int nWhich;
    switch ( nFeat )
    {
        case 1: nWhich = nDev; break;
        case 2: nWhich = nOWC; break;
        case 3: nWhich = nEWF; break;
        case 4: nWhich = nEWS; break;
        case 5: nWhich = nWOC; break;
        case 6: nWhich = nIC; break;
        case 7: nWhich = nWF; break;
        case 8: nWhich = nWS; break;
        default: nWhich = -1; break;
    }

    if ( GetHasFeat(nWhich, oTarget) )
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }

}

// Returns the unarmed damage
int GetUnarmedDamage(object oTarget)
{
    int nDamage;
    int nMonkLevel = GetLevelByClass(CLASS_TYPE_MONK, oTarget);
    int nSize = GetCreatureSize(oTarget);
    if (nSize <= CREATURE_SIZE_SMALL)
    {
        int n = nMonkLevel;
        if (n > 20) n = 20;
        switch (n)
        {
            case 20: nDamage = d6(2); break;
            case 19: nDamage = d6(2); break;
            case 18: nDamage = d6(2); break;
            case 17: nDamage = d6(2); break;
            case 16: nDamage = d6(2); break;
            case 15: nDamage = d10(); break;
            case 14: nDamage = d10(); break;
            case 13: nDamage = d10(); break;
            case 12: nDamage = d10(); break;
            case 11: nDamage = d8(); break;
            case 10: nDamage = d8(); break;
            case 9:  nDamage = d8(); break;
            case 8:  nDamage = d8(); break;
            case 7:  nDamage = d6(); break;
            case 6:  nDamage = d6(); break;
            case 5:  nDamage = d6(); break;
            case 4:  nDamage = d6(); break;
            case 3:  nDamage = d4(); break;
            case 2:  nDamage = d4(); break;
            case 1:  nDamage = d4(); break;
            case 0:  nDamage = d2(); break;
        }
    }
    else
    {
        int n = nMonkLevel;
        if (n > 20) n = 20;
        switch (n)
        {
            case 20: nDamage = d20(); break;
            case 19: nDamage = d20(); break;
            case 18: nDamage = d20(); break;
            case 17: nDamage = d20(); break;
            case 16: nDamage = d20(); break;
            case 15: nDamage = d12(); break;
            case 14: nDamage = d12(); break;
            case 13: nDamage = d12(); break;
            case 12: nDamage = d12(); break;
            case 11: nDamage = d10(); break;
            case 10: nDamage = d10(); break;
            case 9:  nDamage = d10(); break;
            case 8:  nDamage = d10(); break;
            case 7:  nDamage = d8(); break;
            case 6:  nDamage = d8(); break;
            case 5:  nDamage = d8(); break;
            case 4:  nDamage = d8(); break;
            case 3:  nDamage = d6(); break;
            case 2:  nDamage = d6(); break;
            case 1:  nDamage = d6(); break;
            case 0:  nDamage = d3(); break;
        }
    }
    if (GetHasWeaponFeat(oTarget, "Unarmed", 8)) nDamage += 2;
    if (GetHasWeaponFeat(oTarget, "Unarmed", 4)) nDamage += 4;
    return nDamage;
}

// Returns true if the target is weilding a weapon in each hand
int GetIsDualWielding(object oTarget)
{
    object oMH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    object oOH = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
    if (GetIsObjectValid(oMH))
    {
        if( GetIsObjectValid(oOH) && IPGetIsMeleeWeapon(oOH) )
        {
            return TRUE;
        }
        else if (GetUsingDoubleSidedWeapon(oTarget))
        {
            return TRUE;
        }
    }
    return FALSE;
}

// Returns the size of oWeapon
int GetWeaponSize(object oWeapon)
{
    int oSize;
    int nWeapon = GetBaseItemType(oWeapon);
    switch ( nWeapon )
    {
        case BASE_ITEM_BASTARDSWORD:    oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_BATTLEAXE:       oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_CLUB:            oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_DAGGER:          oSize = CREATURE_SIZE_TINY;   break;
        case BASE_ITEM_DIREMACE:        oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_DOUBLEAXE:       oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_DWARVENWARAXE:   oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_GREATAXE:        oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_GREATSWORD:      oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_HALBERD:         oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_HANDAXE:         oSize = CREATURE_SIZE_SMALL;  break;
        case BASE_ITEM_HEAVYFLAIL:      oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_KAMA:            oSize = CREATURE_SIZE_SMALL;  break;
        case BASE_ITEM_KATANA:          oSize = CREATURE_SIZE_SMALL;  break;
        case BASE_ITEM_KUKRI:           oSize = CREATURE_SIZE_TINY;   break;
        case BASE_ITEM_LIGHTFLAIL:      oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_LIGHTHAMMER:     oSize = CREATURE_SIZE_SMALL;  break;
        case BASE_ITEM_LIGHTMACE:       oSize = CREATURE_SIZE_SMALL;  break;
        case BASE_ITEM_LONGSWORD:       oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_MAGICSTAFF:      oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_MORNINGSTAR:     oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_QUARTERSTAFF:    oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_RAPIER:          oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_SCIMITAR:        oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_SCYTHE:          oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_SHORTSPEAR:      oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_SHORTSWORD:      oSize = CREATURE_SIZE_SMALL;  break;
        case BASE_ITEM_SICKLE:          oSize = CREATURE_SIZE_SMALL;  break;
        case BASE_ITEM_TRIDENT:         oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_TWOBLADEDSWORD:  oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_WARHAMMER:       oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_WHIP:            oSize = CREATURE_SIZE_SMALL;  break;
        case BASE_ITEM_HEAVYCROSSBOW:   oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_LIGHTCROSSBOW:   oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_LONGBOW:         oSize = CREATURE_SIZE_LARGE;  break;
        case BASE_ITEM_SHORTBOW:        oSize = CREATURE_SIZE_MEDIUM; break;
        case BASE_ITEM_DART:            oSize = CREATURE_SIZE_SMALL;  break;
        case BASE_ITEM_SHURIKEN:        oSize = CREATURE_SIZE_TINY;   break;
        case BASE_ITEM_SLING:           oSize = CREATURE_SIZE_SMALL;  break;
        case BASE_ITEM_THROWINGAXE:     oSize = CREATURE_SIZE_SMALL;  break;
        default:                        oSize = CREATURE_SIZE_SMALL;  break;
    }
    return oSize;
}

// Returns TRUE if oTarget is Medium Size and using a Double-Sided Weapon
int GetUsingDoubleSidedWeapon(object oTarget)
{
    if (GetCreatureSize(oTarget) == CREATURE_SIZE_MEDIUM)
    {
        object oMH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        if (GetIsObjectValid(oMH))
        {
            if (GetBaseItemType(oMH) == BASE_ITEM_DOUBLEAXE
            || GetBaseItemType(oMH) == BASE_ITEM_TWOBLADEDSWORD
            || GetBaseItemType(oMH) == BASE_ITEM_DIREMACE
            || GetBaseItemType(oMH) == BASE_ITEM_QUARTERSTAFF)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}

// Returns TRUE if oTaget can use Weapon Finesse with weapon in sHand
// sHand: "Left", "Right", "Unarmed", "DoubleMainhand", "DoubleOffhand"
int GetFinessable(object oTarget, string sHand)
{

    int bFinesse = GetHasFeat(FEAT_WEAPON_FINESSE, oTarget);
    if (!bFinesse)
    {
        //SendMessageToPC(oTarget, "you dont have the weapon finesse feat");
        return FALSE;
    }

    object oWeapon;
    if (sHand == "Right")
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    }
    else if (sHand == "Left")
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    }
    else if (sHand == "Unarmed")
    {
        //SendMessageToPC(oTarget, "Unarmed Strike is Finessable");
        return TRUE;
    }


    if (!IPGetIsMeleeWeapon(oWeapon))
    {
        //SendMessageToPC(oTarget, GetName(oWeapon)+" is not a melee weapon");
        return FALSE;
    }
    else if (GetWeaponSize(oWeapon) == CREATURE_SIZE_SMALL)
    {
        //SendMessageToPC(oTarget, GetName(oWeapon)+" is Finessable");
        return TRUE;
    }
    else if (!GetSlashingWeapon(oWeapon) && !IPGetIsBludgeoningWeapon(oWeapon) && GetWeaponSize(oWeapon) <= GetCreatureSize(oTarget))
    {
        //SendMessageToPC(oTarget, GetName(oWeapon)+" is Finessable");
        return TRUE;
    }
    //SendMessageToPC(oTarget, GetName(oWeapon)+" is not finessable");
    return FALSE;
}

// Returns the weapon or gloves attack bonus item property
int IPGetWeaponAttackBonus(object oWeapon, int nAttackBonusType = ITEM_PROPERTY_ATTACK_BONUS)
{
    itemproperty ip = GetFirstItemProperty(oWeapon);
    int nFound = 0;
    int nFound2 = 0;
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == nAttackBonusType)
        {
            nFound = GetItemPropertyCostTableValue(ip);
            if (nFound > nFound2) nFound2 = nFound;
        }
        ip = GetNextItemProperty(oWeapon);
    }
    return nFound2;
}

// Returns the attack bonus of all effects on the target
int GetEffectAttackBonus(object oTarget, int nEffectType = EFFECT_TYPE_ATTACK_INCREASE)
{
    int nAB;
    string sTag;
    effect eAttack = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAttack))
    {
        if (GetEffectType(eAttack) == nEffectType)
        {
            sTag = GetEffectTag(eAttack)+"_AB";
            nAB += GetLocalInt(oTarget, sTag);
        }
        eAttack = GetNextEffect(oTarget);
    }
    if (nAB > 20) nAB = 20;
    //SendMessageToPC(oTarget, "Effect_AB: "+ IntToString(nAB));
    return nAB;
}


// Returns the attack bonus/penalty of Combat Modes
int GetCombatModeAttackBonus(object oTarget)
{
    int nAB;
    if (GetActionMode(oTarget, ACTION_MODE_EXPERTISE)) nAB = -5;
    else if (GetActionMode(oTarget, ACTION_MODE_FLURRY_OF_BLOWS)) nAB = -2;
    else if (GetActionMode(oTarget, ACTION_MODE_IMPROVED_EXPERTISE)) nAB = -10;
    else if (GetActionMode(oTarget, ACTION_MODE_IMPROVED_POWER_ATTACK)) nAB = -10;
    else if (GetActionMode(oTarget, ACTION_MODE_POWER_ATTACK)) nAB = -5;
    else if (GetActionMode(oTarget, ACTION_MODE_RAPID_SHOT)) nAB = -2;

    return nAB;
}

// Returns the damage bonus/penalty of Combat Modes
int GetCombatModeDamageBonus(object oTarget)
{
    int nDamage = 0;
    if (GetActionMode(oTarget, ACTION_MODE_DIRTY_FIGHTING)) nDamage = d6();
    else if (GetActionMode(oTarget, ACTION_MODE_IMPROVED_POWER_ATTACK)) nDamage = 10;
    else if (GetActionMode(oTarget, ACTION_MODE_POWER_ATTACK)) nDamage = 5;
    return nDamage;
}

// Returns the item property damage bonus of an item
int IPGetWeaponDamageBonus(object oWeapon, int nDamageType)
{
    itemproperty ip = GetFirstItemProperty(oWeapon);
    int nFound = 0;
    int nFound2 = 0;
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(ip) == nDamageType)
        {
            nFound = GetItemPropertyCostTableValue(ip);
            //SendMessageToPC(GetFirstPC(), "nDamageType: "+IntToString(nDamageType)+" nFound: "+IntToString(nFound));
            if (nFound > nFound2) nFound2 = nFound;
        }
        ip = GetNextItemProperty(oWeapon);
    }
    int nDamage = IPGetDamageBonusFromConstantValue(nFound2);
    return nDamage;
}

// Returns the damage bonus of all effects on the target
int GetEffectDamageBonus(object oTarget, int nDamageType)
{
    int nDamage, nConstValue;
    string sTag;
    string sTag2;
    switch (nDamageType)
    {
        case DAMAGE_TYPE_ACID:        sTag2 = "_Acid"; break;
        case DAMAGE_TYPE_BLUDGEONING: sTag2 = "_Blud"; break;
        case DAMAGE_TYPE_COLD:        sTag2 = "_Cold"; break;
        case DAMAGE_TYPE_DIVINE:      sTag2 = "_Divi"; break;
        case DAMAGE_TYPE_ELECTRICAL:  sTag2 = "_Elec"; break;
        case DAMAGE_TYPE_FIRE:        sTag2 = "_Fire"; break;
        case DAMAGE_TYPE_MAGICAL:     sTag2 = "_Magi"; break;
        case DAMAGE_TYPE_NEGATIVE:    sTag2 = "_Nega"; break;
        case DAMAGE_TYPE_PIERCING:    sTag2 = "_Pier"; break;
        case DAMAGE_TYPE_POSITIVE:    sTag2 = "_Posi"; break;
        case DAMAGE_TYPE_SLASHING:    sTag2 = "_Slas"; break;
        case DAMAGE_TYPE_SONIC:       sTag2 = "_Soni"; break;
    }
    effect eDamage = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eDamage))
    {
        if (GetEffectType(eDamage) == EFFECT_TYPE_DAMAGE_INCREASE)
        {
            sTag = GetEffectTag(eDamage)+"_DMG"+sTag2;
            nConstValue = GetLocalInt(oTarget, sTag);
            nDamage += IPGetDamageBonusFromConstantValue(nConstValue);
        }
        eDamage = GetNextEffect(oTarget);
    }

    //SendMessageToPC(oTarget, "Effect_DMG"+sTag2+" : "+ IntToString(nDamage));
    return nDamage;

}

// ----------------------------------------------------------------------------
// reverse IPGetDamageBonusConstantFromNumber
// sReturn:
//  "Min" returns min damage
//  "Max" returns max damage
//  else return the roll
// ----------------------------------------------------------------------------
int IPGetDamageBonusFromConstantValue(int nNumber, string sReturn = "")
{
    int nDamage, nMin, nMax;
    switch (nNumber)
    {
        case 1:  nDamage = 1;       break;
        case 2:  nDamage = 2;       break;
        case 3:  nDamage = 3;       break;
        case 4:  nDamage = 4;       break;
        case 5:  nDamage = 5;       break;
        case 6:  nDamage = d4();    nMin = 1;   nMax = 4;   break;
        case 7:  nDamage = d6();    nMin = 1;   nMax = 6;   break;
        case 8:  nDamage = d8();    nMin = 1;   nMax = 8;   break;
        case 9:  nDamage = d10();   nMin = 1;   nMax = 10;  break;
        case 10: nDamage = d6(2);   nMin = 2;   nMax = 12;  break;
        case 11: nDamage = d8(2);   nMin = 2;   nMax = 16;  break;
        case 12: nDamage = d4(2);   nMin = 2;   nMax = 8;   break;
        case 13: nDamage = d10(2);  nMin = 2;   nMax = 20;  break;
        case 14: nDamage = d12();   nMin = 1;   nMax = 12;  break;
        case 15: nDamage = d12(2);  nMin = 2;   nMax = 24;  break;
        case 16: nDamage = 6;       break;
        case 17: nDamage = 7;       break;
        case 18: nDamage = 8;       break;
        case 19: nDamage = 9;       break;
        case 20: nDamage = 10;      break;
        case 21: nDamage = 11;      break;
        case 22: nDamage = 12;      break;
        case 23: nDamage = 13;      break;
        case 24: nDamage = 14;      break;
        case 25: nDamage = 15;      break;
        case 26: nDamage = 16;      break;
        case 27: nDamage = 17;      break;
        case 28: nDamage = 18;      break;
        case 29: nDamage = 19;      break;
        case 30: nDamage = 20;      break;
    }
    if (nNumber >= 1 && nNumber <= 5)
    {
        nMin = nDamage;
        nMax = nDamage;
    }
    else if (nNumber >= 16 && nNumber <= 30)
    {
        nMin = nDamage;
        nMax = nDamage;
    }

    if (sReturn == "Min") return nMin;
    else if (sReturn == "Max") return nMax;
    return nDamage;
}

void SalvDevastatingCritical(object oTarget, object oPC, int nDamage)
{
    float fDuration = RoundsToSeconds(5);
    effect eDur = TagEffect(EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR), "DevastatingCriticalBleed");
    eDur = ExtraordinaryEffect(eDur);

    int nStr = GetAbilityModifier(ABILITY_STRENGTH);
    int nHD = GetHitDice(oPC);
    int nDC = 10 + nStr + (nHD / 2);

    //Make Forttude save
    if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
    {
        effect eSlow = TagEffect(EffectSlow(), "DevastatingCriticalSlow");
        eSlow = ExtraordinaryEffect(eSlow);
        //if (!GetHasTagEffect("DevastatingCriticalSlow", oTarget)){}
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, 6.0);
    }
    nDamage /= 5;

    FloatingTextStringOnCreature("*Devastating Critical*", oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);

    SalvDevastatingCriticalBleed(oTarget, oPC, nDamage, fDuration);

}

void SalvDevastatingCriticalBleed(object oTarget, object oCaster, int nDamage, float fDuration)
{
    if (!GetIsDead(oTarget) && fDuration >= 1.0)
    {

        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
        effect eVis = EffectVisualEffect(234);
        eDam = EffectLinkEffects(eVis, eDam);
        ApplyEffectToObject (DURATION_TYPE_INSTANT, eDam, oTarget);
        fDuration -= 6.0;
        DelayCommand(6.0f, SalvDevastatingCriticalBleed(oTarget, oCaster, nDamage, fDuration));

    }
}

//void main(){}

