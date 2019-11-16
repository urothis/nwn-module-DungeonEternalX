#include "x2_inc_switches"
#include "inc_wep_ac_bon"
#include "gen_inc_color"
#include "arres_inc"
#include "ness_pvp_db_inc"
#include "db_inc"
#include "x0_i0_match"
#include "no_tumble"
// Weapon master buffs for AB, AC, DMG

 // --------------- Damage --------------------------- //
void WeaponMasterDmg(object oPC, int nBonus)
{
    string sMsg;

    int nDamageB = 0;

    if (nBonus >6 )
    {
        nDamageB = DAMAGE_BONUS_7;
        sMsg = "7";
    }
    else if (nBonus >5 )
    {
        nDamageB = DAMAGE_BONUS_6;
        sMsg = "6";
    }
    else if (nBonus >4 )
    {
        nDamageB = DAMAGE_BONUS_5;
        sMsg = "5";
    }
    else if (nBonus >3)
    {
        nDamageB = DAMAGE_BONUS_4;
        sMsg = "4";
    }
    else if (nBonus >2)
    {
        nDamageB = DAMAGE_BONUS_3;
        sMsg = "3";
    }
    else if (nBonus >1)
    {
        nDamageB = DAMAGE_BONUS_2;
        sMsg = "2";
    }
    else if (nBonus >0)
    {
        nDamageB = DAMAGE_BONUS_1;
        sMsg = "1";
    }

    ActionSendMessageToPC(oPC, "Damage Bonus: " + sMsg);

    effect eDmg;
    eDmg = EffectDamageIncrease(nDamageB, DAMAGE_TYPE_SONIC);

    eDmg = ExtraordinaryEffect(eDmg);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmg, oPC);
}


    // --------------- AC ---------------------------------- //
    // Bonus ac equivalent to wm superior attack bonus, Dex based wm gets less ac but extra disc
void WeaponMasterAC(object oPC, int nBaseStr, int nBonus)
{

    //int nBaseStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    //int nBonus = 1; // Value will be equavalent to wm ab bonus.
    int nAC = nBonus;
    int nFighter = GetLevelByClass(CLASS_TYPE_FIGHTER, oPC);
    int nDisc = 0;

    if (nBonus > 2)  // Handle dexterity WM builds differnetly
    {
        nDisc = nBonus-2;
        if (nBaseStr < 22)
        {
            nAC = 2;
            FloatingTextStringOnCreature("Discipline Bonus: " + IntToString(nDisc), oPC);
        }
    }

    // No ac bonus given to builds with access to fighter dodge
    if (nFighter > 15)
    {
        nAC = 0;
    }

    ActionSendMessageToPC(oPC, "AC Bonus: " + IntToString(nAC));
    ActionSendMessageToPC(oPC, "Discipline Bonus: " + IntToString(nDisc));

    effect eDisc = EffectSkillIncrease(SKILL_DISCIPLINE, nDisc);
    effect eAC = EffectACIncrease(nAC, AC_DODGE_BONUS);
    effect eLink = EffectLinkEffects(eDisc, eAC);
    eLink = ExtraordinaryEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

    SetLocalInt(oPC, "HasWmAc", 1);
}

    // --------------- AB ---------------------------------- //
void WeaponMasterAB(object oPC, int nBonus)
{
    int nAB = 0;

    if (nBonus > 6 )// WM lvl 28+
    {
        nAB = 1;
    }

    ActionSendMessageToPC(oPC, "Attack Bonus: " + IntToString(nAB));

    effect eAB = EffectAttackIncrease(nAB);
    eAB = ExtraordinaryEffect(eAB);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAB, oPC);
}

void WeaponMasterBonus(object oPC)
{
    int nWM = GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC);
    int nBaseStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    int nBonus = 1; // Value will be equavalent to wm ab bonus.

    if (!nWM) // Check for WM
    {
        return;
    }

    if (nWM >= 13)
    {
        nBonus += (nWM-10)/3;
    }
    WeaponMasterDmg(oPC, nBonus);
    WeaponMasterAC(oPC, nBaseStr, nBonus);
    WeaponMasterAB(oPC, nBonus);
}

