#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
    object oItem;
    object oPC = GetPCSpeaker();

    oItem = CIGetCurrentModItem(oPC);
    int nItemType = GetBaseItemType(oItem);

    int nPosition=0;
    oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        if (GetBaseItemType(oItem)==nItemType)
        {
            MK_GenericDialog_SetCondition(nPosition,1);
            MK_GenericDialog_SetObject(nPosition, oItem);
//            SetLocalInt(OBJECT_SELF, "MK_CONDITION_"+IntToString(nPosition),1);
//            SetLocalObject(OBJECT_SELF, "MK_OBJECT_"+IntToString(nPosition), oItem);
            SetCustomToken(MK_TOKEN_ITEMLIST+nPosition, GetName(oItem));
            nPosition++;
        }
        oItem = GetNextItemInInventory(oPC);
    }
    while (nPosition<21)
    {
        MK_GenericDialog_SetCondition(nPosition,0);

//        SetLocalInt(OBJECT_SELF, "MK_CONDITION_"+IntToString(nPosition),0);
        nPosition++;
    }

    MK_GenericDialog_SetState(MK_STATE_COPY);
//    SetLocalInt(OBJECT_SELF, "MK_SET_COPY", 1);

    return TRUE;
}
