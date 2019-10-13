#include "inc_traininghall"
#include "gen_inc_color"
#include "_functions"
#include "db_inc"

//////////////////////////////////////////////////////
//
// See file "inc_traininghall" for more informations
//
//////////////////////////////////////////////////////


void main()
{

    object oTarget = GetItemActivatedTarget();
    object oItem = GetItemActivated();
    if (!GetLocalInt(GetItemActivated(), "CERTIFIED"))
    {
        Insured_Destroy(oItem);
        FloatingTextStringOnCreature("The training session token was not certified.", oTarget);
        return;
    }

    if (!dbCheckDatabase())
    {
        SendMessageToPC(oTarget, "Sorry, the Training Hall is closed today [Database Error]");
        return;
    }

    // object oPC = GetItemActivator();
    string sTRUEID = IntToString(dbGetTRUEID(oTarget));
    int nSession = GetTrainingSessions(oTarget, sTRUEID);

    if (GetIsPC(oTarget))
    {
        Insured_Destroy(oItem);
        SetTrainingSessions(oTarget, sTRUEID , nSession+1);
        FloatingTextStringOnCreature(GetRGB(11,9,11) + GetName(oTarget) + " has gained 1 free training session", oTarget);
    }
}
