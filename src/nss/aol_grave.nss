#include "seed_faction_inc"
#include "_vfx_"

void main()
{
    object oPC = GetPCSpeaker();
    string sName = GetName(oPC);

    if (GetStringLength(sName) >= 20) sName = GetStringLeft(sName, 20);
    object oGrave = GetLocalObject(GetModule(), "PC_GRAVE_" + sName);
    if (GetIsObjectValid(oGrave))
    {
        string sFAID = GetLocalString(GetArea(oGrave), "FAID");
        if (sFAID!= "" && sFAID != SDB_GetFAID(oPC))
        {
            SendMessageToPC(oPC, "Sorry, your grave is in another Faction's territory.");
            return;
        }
        location lDestLocation = GetLocation(oGrave);
        FXPortEthereal(oPC);
        DelayCommand(3.0, AssignCommand(oPC, JumpToLocation(lDestLocation)));
        int nHD = GetHitDice(oPC);
        int nPenalty = Random(75) * nHD;
        int nMin = ((nHD * (nHD - 1)) / 2) * 1000;
        int nNewXP = GetXP(oPC) - nPenalty;
        if (nNewXP < nMin) nNewXP = nMin;

        SetXP(oPC, nNewXP);
        DestroyObject(oGrave);
    }
    else FloatingTextStringOnCreature("You have no grave to return to.", oPC);
}
