#include "nwnx_redis_short"

/////////////
// 0 = debug
// 1 = common
// 2 = idfk
/////////////

string IntTologLevel(int nLogLevel) {
    string sLogLevel;
    switch(nLogLevel) {
        case 0: sLogLevel = "debug";
        case 1: sLogLevel = "common";
        case 2: sLogLevel = "imLazy";
        default: sLogLevel = "howeven";
    }
    return sLogLevel;
}

void Log(string sObject = "", string sMessage = "", int nLogLevel = 0, float fTimeToExecute = 0.0f){
    PUBLISH("log:"+IntTologLevel(nLogLevel),sMessage + "|" + FloatToString(fTimeToExecute));
}
