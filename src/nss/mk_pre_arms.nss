#include "mk_inc_generic"

#include "x2_inc_craft"

int IsVisibleAndEqual(int nCon1, int nCon2, object oItem, int nPart1, int nPart2)
{
//    if (GetLocalInt(OBJECT_SELF, "MK_CONDITION_"+IntToString(nCon1))==0)
    if (!MK_GenericDialog_GetCondition(nCon1))
    {
        return 0;
    }
//    if (GetLocalInt(OBJECT_SELF, "MK_CONDITION_"+IntToString(nCon2))==0)
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

    // Shoulders: MK_CONDITION_18

    MK_GenericDialog_SetCondition(18,
        IsVisibleAndEqual(14,15,oItem,
            ITEM_APPR_ARMOR_MODEL_LSHOULDER,
            ITEM_APPR_ARMOR_MODEL_RSHOULDER));
/*    SetLocalInt(OBJECT_SELF, "MK_CONDITION_18",
        IsVisibleAndEqual(14,15,oItem,
            ITEM_APPR_ARMOR_MODEL_LSHOULDER,
            ITEM_APPR_ARMOR_MODEL_RSHOULDER));*/

    // Biceps: MK_CONDITION_19
    MK_GenericDialog_SetCondition(19,
        IsVisibleAndEqual(12,13,oItem,
            ITEM_APPR_ARMOR_MODEL_LBICEP,
            ITEM_APPR_ARMOR_MODEL_RBICEP));
/*    SetLocalInt(OBJECT_SELF, "MK_CONDITION_19",
        IsVisibleAndEqual(12,13,oItem,
            ITEM_APPR_ARMOR_MODEL_LBICEP,
            ITEM_APPR_ARMOR_MODEL_RBICEP));*/

    // Forearms: MK_CONDITION_20
    MK_GenericDialog_SetCondition(20,
        IsVisibleAndEqual(10,11,oItem,
            ITEM_APPR_ARMOR_MODEL_LFOREARM,
            ITEM_APPR_ARMOR_MODEL_RFOREARM));
/*    SetLocalInt(OBJECT_SELF, "MK_CONDITION_20",
        IsVisibleAndEqual(10,11,oItem,
            ITEM_APPR_ARMOR_MODEL_LFOREARM,
            ITEM_APPR_ARMOR_MODEL_RFOREARM));*/

    // Gloves: MK_CONDITION_21
    MK_GenericDialog_SetCondition(21,
        IsVisibleAndEqual(16,17,oItem,
            ITEM_APPR_ARMOR_MODEL_LHAND,
            ITEM_APPR_ARMOR_MODEL_RHAND));
/*    SetLocalInt(OBJECT_SELF, "MK_CONDITION_21",
        IsVisibleAndEqual(16,17,oItem,
            ITEM_APPR_ARMOR_MODEL_LHAND,
            ITEM_APPR_ARMOR_MODEL_RHAND));*/

    return TRUE;
}
