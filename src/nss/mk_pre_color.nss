#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if (MK_GenericDialog_IsInState(MK_STATE_CGROUP,TRUE))
    {
        int nAction = MK_GenericDialog_GetAction();
//        GetLocalInt(OBJECT_SELF, "MK_ACTION");
        int nNumberOfColorGroups = GetLocalInt(OBJECT_SELF, "MK_NUMBER_OF_COLOR_GROUPS");
        if ((nAction>=0) && (nAction<nNumberOfColorGroups))
        {
            SetLocalInt(oPC, "MK_ColorGroup", nAction);

            MK_SetTokenColorName(GetLocalInt(oPC, "MK_MaterialToDye"), nAction);
        }
    }

    object oItem = CIGetCurrentModItem(oPC);

    MK_SetColorToken(oItem, GetLocalInt(oPC, "MK_MaterialToDye"));

    MK_GenericDialog_SetState(MK_STATE_COLOR);

    return TRUE;
}
