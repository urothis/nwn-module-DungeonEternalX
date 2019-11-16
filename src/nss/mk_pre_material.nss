#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
//    MK_init();

    object oPC = GetPCSpeaker();

    object oItem;

    switch (MK_GenericDialog_GetState(TRUE))
    {
    case MK_STATE_COLOR:
        {
            int nColor = MK_GenericDialog_GetAction();
//            GetLocalInt(OBJECT_SELF, "MK_ACTION");
            int nNumberOfColorsPerGroup = GetLocalInt(OBJECT_SELF, "MK_NUMBER_OF_COLORS_PER_GROUP");
            if ((nColor>=0) && (nColor<nNumberOfColorsPerGroup))
            {
                SetLocalInt(oPC, "MK_ColorToDye", nColor);
                ExecuteScript("mk_dyeitem", oPC);
            }
        }
        break;
    case MK_STATE_COPY:
        {
            int nItem = MK_GenericDialog_GetAction();
//            GetLocalInt(OBJECT_SELF, "MK_ACTION");
            if (nItem>=0)
            {
//                object oSourceItem = GetLocalObject(OBJECT_SELF, "MK_OBJECT_"+IntToString(nItem));
                object oSourceItem = MK_GenericDialog_GetObject(nItem);

                if (GetIsObjectValid(oSourceItem))
                {
                    oItem = CIGetCurrentModItem(oPC);

                    oItem = MK_CopyColor(oItem, oSourceItem);

                    CISetCurrentModItem(oPC,oItem);

                    int nInventorySlot = MK_GetCurrentInventorySlot(oPC);

                    AssignCommand(oPC, ActionEquipItem(oItem, nInventorySlot));
                }
            }
        }
        break;
    }

    oItem = CIGetCurrentModItem(oPC);

    MK_SetColorToken(oItem,-1);

    MK_GenericDialog_SetState(MK_STATE_MATERIAL);

    return TRUE;
}
