//::///////////////////////////////////////////////
//:: Poison Weapon spellscript
//:: x2_s2_poisonwp
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spell allows to add temporary poison properties
    to a melee weapon or stack of arrows

    The exact details of the poison are loaded from
    a 2da defined in x2_inc_itemprop X2_IP_POSIONWEAPON_2DA
    taken from the row that matches the last three letters
    of GetTag(GetSpellCastItem())

    Example: if an item is given the poison weapon property
             and its tag ending on 004, the 4th row of the
             2da will be used (1d2IntDmg DC14 18 seconds)

             Rows 0 to 99 are bioware reserved

    Non Assassins have a chance of poisoning themselves
    when handling an item with this spell

    Restrictions
    ... only weapons and ammo can be poisoned
    ... restricted to piercing / slashing  damage

*/

#include "x2_inc_itemprop"
#include "X2_inc_switches"

int DoPoisonCheck(object oPC, int nApplyDC)
{
    int bHasFeat = GetHasFeat(FEAT_USE_POISON, oPC);
    if (!bHasFeat)
    { // without handle poison feat, do ability check
        AssignCommand(oPC, ClearAllActions(TRUE));  // * Force attacks of opportunity
        if (GetModuleSwitchValue(MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT) == TRUE)
        { // Poison restricted to assassins and blackguards only?
            FloatingTextStrRefOnCreature(84420, oPC); //"Failed"
            return FALSE;
        }
        int nCheck = d10(1) + 10 + GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        if (nCheck < nApplyDC)
        {
            FloatingTextStrRefOnCreature(83368, oPC); //"Failed"
            return FALSE;
        }
        else FloatingTextStrRefOnCreature(83370, oPC); //"Success"
    }
    else FloatingTextStrRefOnCreature(83369, oPC); //"Auto success"
    return TRUE;
}

int IsCustomPoison(string sTag, object oItem, object oPC, object oTarget)
{
    if (sTag == "POISON_NEG_DMG")
    {
        if (!DoPoisonCheck(oPC, 28)) return FALSE;
        if (GetHasFeat(FEAT_EPIC_BLACKGUARD, oPC) || GetHasFeat(FEAT_EPIC_ASSASSIN, oPC))
        {
            IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_3), TurnsToSeconds(10), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else
        {
            FloatingTextStringOnCreature("Epic Blackguard or Assassin only", oPC);
            return FALSE;
        }
    }
    FloatingTextStrRefOnCreature(83361, oPC); //"Weapon is coated with poison"
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_NATURE), oPC);
    return TRUE;
}

void main() {

    object oItem   = GetSpellCastItem();
    object oPC     = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    string sTag    = GetTag(oItem);

    if (oTarget == OBJECT_INVALID || GetObjectType(oTarget)!=OBJECT_TYPE_ITEM || GetItemPossessor(oTarget)!=oPC)
    {
        FloatingTextStrRefOnCreature(83359, oPC);         //"Invalid target "
        return;
    }
    int nType = GetBaseItemType(oTarget);
    if (!IPGetIsMeleeWeapon(oTarget) && !IPGetIsProjectile(oTarget) && nType != BASE_ITEM_SHURIKEN && nType != BASE_ITEM_DART && nType != BASE_ITEM_THROWINGAXE)
    {
        FloatingTextStrRefOnCreature(83359, oPC);         //"Invalid target "
        return;
    }
    if (IPGetIsBludgeoningWeapon(oTarget))
    {
        FloatingTextStrRefOnCreature(83367, oPC);         //"Weapon does not do slashing or piercing damage "
        return;
    }
    if (IPGetItemHasItemOnHitPropertySubType(oTarget, IP_CONST_ONHIT_ITEMPOISON))
    {
        FloatingTextStrRefOnCreature(83407, oPC); // weapon already poisoned
        return;
    }

    // check and do custom poison and return here
    if (IsCustomPoison(sTag, oItem, oPC, oTarget)) return;

    // Get the 2da row to lookup the poison from the last three letters of the tag
    int nRow = StringToInt(GetStringRight(sTag, 3));
    if (nRow == 0)
    {
        FloatingTextStrRefOnCreature(83360, oPC);         //"Nothing happens
        return;
    }

    int nSaveDC     =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA, "SaveDC", nRow));
    int nDuration   =  FloatToInt(TurnsToSeconds(GetHitDice(oPC))); // duration = 1 turn per level
    int nPoisonType =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA, "PoisonType", nRow)) ;
    int nApplyDC    =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA, "ApplyCheckDC", nRow)) ;

    if (!DoPoisonCheck(oPC, nApplyDC)) return;

    itemproperty ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, nSaveDC, nPoisonType);
    IPSafeAddItemProperty(oTarget, ip, IntToFloat(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);

    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
    //technically this is not 100% safe but since there is no way to retrieve the sub
    //properties of an item (i.e. itempoison), there is nothing we can do about it
    if (IPGetItemHasItemOnHitPropertySubType(oTarget, IP_CONST_ONHIT_ITEMPOISON))
    {
        FloatingTextStrRefOnCreature(83361, oPC);         //"Weapon is coated with poison"
        IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), IntToFloat(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    }
    else
    {
        FloatingTextStrRefOnCreature(83360, oPC);         //"Nothing happens
    }
}
