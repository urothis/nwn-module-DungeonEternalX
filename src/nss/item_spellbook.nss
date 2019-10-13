#include "x2_inc_switches"
#include "_functions"
#include "zdialog_inc"
#include "spellbook_inc"

void main()
{
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_CONTINUE;

    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC     = GetItemActivator();
        object oTarget = GetItemActivatedTarget();
        object oBook   = GetItemActivated();

        if (oTarget == oPC)
        {
            if (GetIsInCombat(oPC)) return;
            SetCurrentList(oBook, "SPELLBOOK");
            SetLocalObject(oPC, "SPELLBOOK", oBook);
            OpenNextDlg(oPC, oBook, "spellbook_conv", TRUE, FALSE);
            return;
        }

        if (!GetIsObjectValid(oTarget)) return;
        if (GetItemPossessor(oTarget) != oPC) return;

        if (GetBaseItemType(oTarget) != BASE_ITEM_SPELLSCROLL) return;

        int nScrollCnt = GetItemStackSize(oTarget);
        string sResRef = GetResRef(oTarget);
        if (sResRef == "") return;
        int nSwitch;
        int nScrollID = GetLocalInt(oBook, "SCROLL_ID_" + sResRef); // ID of the Scroll
        string sScrollID = IntToString(nScrollID);
        if (!nScrollID) // new scroll, pick free ID
        {
            nScrollID = 1; // switch IDs
            while (GetLocalString(oBook, "SCROLL_RES_" + IntToString(nScrollID)) != "")
            {
                nScrollID++;
                if (nScrollID > 20)
                {
                    AssignCommand(oPC, SpeakString("The Book is full"));
                    return;
                }
            }

            sScrollID = IntToString(nScrollID);
            SetLocalInt(oBook, "SCROLL_ID_" + sResRef, nScrollID); // Store ID by ResRef
            SetLocalString(oBook, "SCROLL_RES_" + sScrollID, sResRef); // Store ResRef by ID
            SetLocalString(oBook, "SCROLL_NAME_" + sScrollID, GetName(oTarget)); // Store Name by ID
        }

        nScrollCnt += GetLocalInt(oBook, "SCROLL_CNT_" + sScrollID); // Scrollcount by ID in Book
        SetLocalInt(oBook, "SCROLL_CNT_" + sScrollID, nScrollCnt); // store new count by ID
        string sScrollName = GetLocalString(oBook, "SCROLL_NAME_" + sScrollID);

        Insured_Destroy(oTarget);
        int nTotalCnt = nScrollCnt + GetLocalInt(oBook, "TOTAL_COUNT");
        SetLocalInt(oBook, "TOTAL_COUNT", nTotalCnt);

        SpellBookDoWeight(oBook, SpellBookDoDesc(oBook));
    }
    SetExecutedScriptReturnValue(nResult);
}
