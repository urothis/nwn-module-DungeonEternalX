#include "x0_i0_match"

int GetIsTwoHanded(int nBaseItemType, int nCreatureSize)
{
    string sWeaponSize = Get2DAString("baseitems", "WeaponSize", nBaseItemType);

    if (sWeaponSize == "1" || sWeaponSize == "2") return FALSE;
    if (sWeaponSize == "3") return (nCreatureSize <= CREATURE_SIZE_SMALL);
    if (sWeaponSize == "4") return TRUE;
    return FALSE;
}

effect eApr;
effect eAC;

void WeaponAcBonus(object oPC)
{
    object oRHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oLHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    if (GetHasFeat(FEAT_MONK_AC_BONUS, oPC)) return;

    int nCreatureSize = GetCreatureSize(oPC);
    if (nCreatureSize >= CREATURE_SIZE_LARGE) return;

    int nDoBonus;
    string sMsg;
    if (GetIsObjectValid(oLHand)) //we may have a dual wielder
    {
        if (MatchMeleeWeapon(oLHand))
        {
            if (GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 9)
            {
                sMsg = "(Ranger Dualwield Weapon)";
                nDoBonus = 3;
            }
            else
            {
                sMsg = "(Dualwield Weapon)";
                nDoBonus = 1;
            }
        }
    }
    else if (GetIsObjectValid(oRHand))
    {
        if (MatchCrossbow(oRHand) || MatchNormalBow(oRHand))
        {
            sMsg = "(Bow / Crossbow)";
            nDoBonus = 3;
        }
        else if (GetIsTwoHanded(GetBaseItemType(oRHand), nCreatureSize))
        {
            sMsg = "(Two-Handed Weapon)";
            nDoBonus = 1;

            if (GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 9)
            {
                nDoBonus = 3; // Cory - Increase two-handed ac for rangers

                if (MatchTwoSidedWeapon(oRHand))
                {
                    sMsg = "(Ranger Two-Sided Weapon)";
                    //nDoBonus = 3;
                }
            }
        }

    }
    if (!nDoBonus) return;

    int nLvl = GetHitDice(oPC);
    int nBaseStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);

    if (nLvl >= 40) nDoBonus += 1;

    if (nLvl >= 20) nDoBonus += 1;

    // Cory - Added +2 Apr and +2 ac (+7 max) for rangers with >22 str
    //     while using two-handed weapons or dual-wielding
    if (((nBaseStr >= 22) && (GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 8))) // Str Ranger
    {
        if (GetIsObjectValid(oLHand) || (MatchTwoSidedWeapon(oRHand))) // Dual wielder
        {
            if (MatchMeleeWeapon(oLHand) && GetLocalInt(oPC, "HasAprBonus")==0) // Make sure off-hand is melee wep
            {
                eApr  = EffectModifyAttacks(1);
                eApr = ExtraordinaryEffect(eApr);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApr, oPC);
                nDoBonus += 3;
                SetLocalInt(oPC, "HasAprBonus", 1);
            }
            else if (MatchTwoSidedWeapon(oRHand) && GetLocalInt(oPC, "HasAprBonus")==0)  // Two-sided weapon user
            {
                eApr  = EffectModifyAttacks(1);
                eApr = ExtraordinaryEffect(eApr);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApr, oPC);
                nDoBonus += 3;
                SetLocalInt(oPC, "HasAprBonus", 1);
            }
        }
        else if ((GetLocalInt(oPC, "HasAprBonus")==0))// Two-handed user
        {
            eApr = EffectModifyAttacks(1);
            eApr = ExtraordinaryEffect(eApr);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApr, oPC);
            nDoBonus += 2;
            SetLocalInt(oPC, "HasAprBonus", 1);
        }

    }
    // Cory - Added +1 apr and +1 ac for non-str rangers while dual-wielding (no bonus for kama)
    //GetBaseItemType
    else if (((GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 8)) && (GetLocalInt(oPC, "HasAprBonus")==0))//Dex ranger
    {
        eApr  = EffectModifyAttacks(1);
        eApr = ExtraordinaryEffect(eApr);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApr, oPC);
        nDoBonus += 1;
        SetLocalInt(oPC, "HasAprBonus", 1);
    }

    eAC = EffectACIncrease(nDoBonus, AC_SHIELD_ENCHANTMENT_BONUS);
    eAC = ExtraordinaryEffect(eAC);
    if (!(GetLevelByClass(CLASS_TYPE_MONK)))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
    }
    SendMessageToPC(oPC, "+" + IntToString(nDoBonus) + " Shield AC " + sMsg);
}

void RemoveWeaponAcBonus(object oPC, object oCreator = OBJECT_SELF)
{
    effect eLoop = GetFirstEffect(oPC);
    while (GetIsEffectValid(eLoop))
    {
        if ((GetEffectType(eLoop) == GetEffectType(eApr)) && GetLevelByClass(CLASS_TYPE_RANGER, oPC)>8)
        {
            RemoveEffect(oPC, eLoop);
        }


        if (GetEffectType(eLoop) == EFFECT_TYPE_AC_INCREASE)
        {
            if (GetEffectSubType(eLoop) == SUBTYPE_EXTRAORDINARY)
            {
                if (GetEffectCreator(eLoop) == oCreator)
                {
                    RemoveEffect(oPC, eLoop);
                }
            }
        }

        eLoop = GetNextEffect(oPC);
    }
    DeleteLocalInt(oPC, "HasAprBonus");
}
