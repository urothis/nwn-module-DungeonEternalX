#include "mk_inc_generic"

#include "x2_inc_craft"

int IsVisibleAndEqual(int nCon1, int nCon2, object oItem, int nPart1, int nPart2)
{
    if (!MK_GenericDialog_GetCondition(nCon1))
    {
        return 0;
    }
    if (!MK_GenericDialog_GetCondition(nCon2))
    {
        return 0;
    }
    if (GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, nPart1) !=
        GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, nPart2))
    {
        return 0;
    }
    return 1;
}

int StartingConditional()
{
    // Sets MK_CONDITION_?? variables for changing left and right parts at the
    // same time.
    // To change both parts both parts have to be visible and their appearance
    // must be the same.

    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);

    // Thighs: MK_CONDITION_18
    MK_GenericDialog_SetCondition(18,
        IsVisibleAndEqual(4,5,oItem,
            ITEM_APPR_ARMOR_MODEL_LTHIGH,
            ITEM_APPR_ARMOR_MODEL_RTHIGH));
    // Shins: MK_CONDITION_19
    MK_GenericDialog_SetCondition(19,
        IsVisibleAndEqual(2,3,oItem,
            ITEM_APPR_ARMOR_MODEL_LSHIN,
            ITEM_APPR_ARMOR_MODEL_RSHIN));

    // Feet: MK_CONDITION_20
    MK_GenericDialog_SetCondition(20,
        IsVisibleAndEqual(0,1,oItem,
            ITEM_APPR_ARMOR_MODEL_LFOOT,
            ITEM_APPR_ARMOR_MODEL_RFOOT));

    return TRUE;
}
