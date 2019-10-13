#include "artifact_inc"
#include "zdlg_include_i"
#include "zdialog_inc"
#include "quest_inc"

void main()
{
    object oPC = GetLastUsedBy();
    if (!GetIsObjectValid(oPC)) return;
    if (!GetIsPC(oPC)) return;
    string sArtiFAID = Artifact_GetHeld(oPC); // FACTION ID WHO'S ARTIFACT I CARRY
    string sFAID = GetLocalString(GetArea(oPC), "FAID"); // THE FACTION ID OF THE ALTAR
    if (sArtiFAID != "")
    {
        Artifact_AltarOnUsed(oPC, sArtiFAID, sFAID);
        if (sArtiFAID != sFAID) Q_FactionAltar(oPC);
        return;
    }
    ActionStartConversation(oPC, "", TRUE, FALSE);
}
