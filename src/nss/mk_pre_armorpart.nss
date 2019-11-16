#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oItem;

    if (MK_GenericDialog_IsInState(MK_STATE_COPY, TRUE))
    {
        int nItem = MK_GenericDialog_GetAction();
        if (nItem>=0)
        {
            object oSourceItem = MK_GenericDialog_GetObject(nItem);

            if (GetIsObjectValid(oSourceItem))
            {
                oItem = CIGetCurrentModItem(oPC);

                oItem = MK_CopyAppearance(oItem, oSourceItem);

                CISetCurrentModItem(oPC,oItem);

                int nInventorySlot = MK_GetCurrentInventorySlot(oPC);

                AssignCommand(oPC, ActionEquipItem(oItem, nInventorySlot));
            }
        }
    }

    oItem = CIGetCurrentModItem(oPC);

    int nRobe = GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,ITEM_APPR_ARMOR_MODEL_ROBE);

    int iItemAppr;
    for (iItemAppr=0; iItemAppr<=17; iItemAppr++)
    {
        MK_GenericDialog_SetCondition(iItemAppr,
            ( (nRobe==0) || (MK_IsBodyPartVisible(nRobe, iItemAppr))));
    }

    MK_SetCurrentModParts(GetPCSpeaker(),-1, -1, 0, 0);

    return TRUE;
}
