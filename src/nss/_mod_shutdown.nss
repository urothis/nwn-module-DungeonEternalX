#include "inc_server"
#include "db_inc"
#include "_webhook"

void main() {
    BootAllPC();
    // end db session
    dbSessionEnd();

    // send out the webhook
    ModDownWebhook();

    // write to log
    WriteTimestampedLogEntry("*****SERVER RESTART*****");
}
