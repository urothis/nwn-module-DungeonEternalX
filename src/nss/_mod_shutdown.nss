#include "inc_server"
#include "db_inc"
#include "_webhook"

void main() { 
    // end db session
    dbSessionEnd();
    // send out the webhook
    ModDownWebhook();
    // write to log
    WriteTimestampedLogEntry("*****SERVER RESTART*****")); 
    
    // testing out portal
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC)) {
        ActivatePortal(oPC, "157.245.241.56:5121", "", "", TRUE);
        oPC = GetNextPC();
    }    
}