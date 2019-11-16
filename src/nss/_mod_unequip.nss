#include "x2_inc_switches"
#include "inc_wep_ac_bon"
#include "nw_i0_spells"

void main()
{
    //ExecuteScript("cursed_unequip",OBJECT_SELF); //Cursed Items
    object oItem = GetPCItemLastUnequipped();
    object oPC   = GetPCItemLastUnequippedBy();

    int nCurrAction = GetCurrentAction(oPC);

    DeleteLocalInt(oPC, "TumbleAcBonus"); // Cory - Clears bonus ac availability from non-tumble class
    SetLocalInt(oPC, "HasWmAc", 0); // Cory - Allows for WM ac to re-apply, since it gets removed on un-equip
    int nTumAcCheck = GetLocalInt(oPC, "TumbleAcBonus");

    RemoveWeaponAcBonus(oPC);
    if (nCurrAction == ACTION_CASTSPELL || nCurrAction == ACTION_COUNTERSPELL)
    {
        AssignCommand(oPC, ClearAllActions());
    }
    int nRemoveWeaponAc;

    if (MatchMeleeWeapon(oItem))
    {
        RemoveEffectsFromSpell(oPC, SPELL_HOLY_SWORD);
        RemoveWeaponAcBonus(oPC);
    }
    else if (MatchCrossbow(oItem) || MatchNormalBow(oItem))
    {
        RemoveWeaponAcBonus(oPC);
    }
    else if (GetStringLeft(GetTag(oItem), 14) == "EPICITEM_VAASA")
    {
        RemoveEffectsFromSpell(oPC, 695);
    }
}




