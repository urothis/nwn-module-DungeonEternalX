#include "mk_inc_generic"

#include "mk_inc_body"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nAction = MK_GenericDialog_GetAction();
    //GetLocalInt(OBJECT_SELF, "MK_ACTION");

    switch (MK_GetBodyPartToBeModified(oPC))
    {
    case MK_CRAFTBODY_ERROR:
        if ((nAction>0) && (nAction<=MK_CRAFTBODY_NUMBER_OF_BODYPARTS))
        {
            MK_SetBodyPartToBeModified(oPC, nAction);
            MK_SaveBodyPart(oPC);

            switch (nAction)
            {
            case MK_CRAFTBODY_PORTRAIT:
                {
                    int nMaxCustomId = MK_GetMaxPortraitId(TRUE);
                    MK_GenericDialog_SetCondition(3,nMaxCustomId>0);
                    MK_GenericDialog_SetCondition(4,nMaxCustomId>0);
                }
                break;
            case MK_CRAFTBODY_BODY:
                {
                    int nBodyPart;
                    for (nBodyPart=0; nBodyPart<=17; nBodyPart++)
                    {
                        int nMaxBodyPartID = MK_GetMaxBodyPartID(nBodyPart);
                        MK_GenericDialog_SetCondition(nBodyPart, nMaxBodyPartID>0);
                    }
                }
                break;
            }
        }
        else if (nAction==MK_CRAFTBODY_SAVERESTORE)
        {
            MK_SetBodyPartToBeModified(oPC, nAction);
            MK_SaveBody(oPC, 0);
        }
        break;
    case MK_CRAFTBODY_PORTRAIT:
        if ((nAction>=1) && (nAction<=4))
        {
            MK_NewPortrait(oPC, nAction);
            ClearAllActions();
            // So we have the proper portrait in the dialog as well
            ActionPauseConversation();
            ActionWait(GetLocalFloat(OBJECT_SELF, "MK_PORTRAIT_DELAY"));
            ActionResumeConversation();
        }
        break;
    case MK_CRAFTBODY_BODY:
        MK_SetSubPartToBeModified(oPC,
            GetLocalInt(OBJECT_SELF,"X2_TAILOR_CURRENT_PART"));
        break;
    case MK_CRAFTBODY_SAVERESTORE:
        if ((nAction>=1) && (nAction<=10))
        {
            // Save Body
            MK_SaveBody(oPC, nAction);
        }
        else if ((nAction>=11) && (nAction<=20))
        {
            // Restore Body
            MK_RestoreBody(oPC, nAction-10);
        }
        break;
    }

    if (MK_GetBodyPartToBeModified(oPC)==MK_CRAFTBODY_SAVERESTORE)
    {
        int bUsedAny=FALSE;
        int nSlot;
        for (nSlot=1; nSlot<=MK_CRAFTBODY_NUMBER_OF_SLOTS; nSlot++)
        {
            int bUsed = MK_GetIsUsedSaveBodySlot(oPC, nSlot);
            bUsedAny = bUsedAny || bUsed;
            MK_GenericDialog_SetCondition(nSlot, !bUsed);
            MK_GenericDialog_SetCondition(10+nSlot, bUsed);
        }
        MK_GenericDialog_SetCondition(0, bUsedAny);
    }
    else
    {
        MK_SetBodyPartTokens(oPC);
    }

    MK_GenericDialog_SetCondition(21,
        (MK_GetIsBodyModified(oPC) ? 1 : 0) );

    return TRUE;
}
