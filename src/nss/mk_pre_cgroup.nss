#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
//    MK_init();

    object oPC = GetPCSpeaker();

//    if (GetLocalInt(OBJECT_SELF, "MK_SET_MATERIAL")==1)
    if (MK_GenericDialog_IsInState(MK_STATE_MATERIAL,TRUE))
    {
        int nMaterial = MK_GenericDialog_GetAction();
//        GetLocalInt(OBJECT_SELF, "MK_ACTION");
        if ((nMaterial>=0) && (nMaterial<ITEM_APPR_ARMOR_NUM_COLORS))
        {
            SetLocalInt(oPC, "MK_MaterialToDye", nMaterial);
            MK_SetTokenColorGroup(nMaterial);
        }
//        SetLocalInt(OBJECT_SELF, "MK_SET_MATERIAL", 0);
    }

    object oItem = CIGetCurrentModItem(oPC);

    MK_SetColorToken(oItem, GetLocalInt(oPC, "MK_MaterialToDye"));

    MK_GenericDialog_SetState(MK_STATE_CGROUP);
//    SetLocalInt(OBJECT_SELF, "MK_SET_CGROUP", 1);

    return TRUE;
}
