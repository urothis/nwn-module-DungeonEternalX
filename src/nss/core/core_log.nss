// MIT License
// (c) 2019 urothis
#include "_webhook"
#include "nwnx_util"
/////////////
// conforming to github.com/sirupsen/logrus loglevels
/////////////
// 0 = debug
// debug info
// 1 = info
// info that might look cool
// 2 = warn
// warn level errors, nothing broke but something isn't right
// 3 = error
// a full error, but not world breaking
// 4 = fatal
// system breaking error.
// 5 = panic
// we shutdown the server, extremely bad errors we want to halt on
/////////////

string IntTologLevel(int nLogLevel) {
    string sLogLevel;
    switch(nLogLevel) {
        case 0: sLogLevel = "debug";
        case 1: sLogLevel = "info";
        case 2: sLogLevel = "warn";
        case 3: sLogLevel = "error";
        case 4: sLogLevel = "fatal";
        case 5: sLogLevel = "panic";
        default: sLogLevel ="dickbutt";
    }
    return sLogLevel;
}

string LogLevelColor(int nLogLevel) {
    string sLogLevel;
    switch(nLogLevel) {
        case 0: sLogLevel = "#002ef5";
        case 1: sLogLevel = "#18dd18";
        case 2: sLogLevel = "#ffd10a";
        case 3: sLogLevel = "#ff800a";
        case 4: sLogLevel = "#d83131";
        case 5: sLogLevel = "#b22222";
        default: sLogLevel ="#27cece";
    }
    return sLogLevel;
}

struct Log {
    string key;
    string value;
    string message;
    int levelInt;
    string levelString;
    string levelColor;
};

struct Log GetLogData(string sKey,string sValue,string sMessage,int nLogLevel) {
    struct Log logData;
    logData.key = sKey;
    logData.value = sValue;
    logData.message = sMessage;
    logData.levelInt = nLogLevel;
    logData.levelString = IntTologLevel(nLogLevel);
    logData.levelColor = LogLevelColor(nLogLevel);
    return logData;
}

void LogWebhook(string sKey, string sValue, string sMessage, int nLogLevel) {
  string sName = GetName(GetModule());
  // get the log data we need from struct
  struct Log logData = GetLogData(sKey, sValue, sMessage, nLogLevel);
  // construct webhook
  string sConstructedMsg;
  struct NWNX_WebHook_Message stMessage;
  ////////////////////////////////////////////////////////
  stMessage.sUsername =     "Log";
  stMessage.sColor =        logData.levelColor;
  stMessage.sDescription =  logData.message;
  stMessage.sField1Name =   logData.key;
  stMessage.sField1Value =  logData.value;
  stMessage.iField1Inline = TRUE;
  stMessage.sFooterText =   sName;
  stMessage.iTimestamp =    NWNX_Time_GetTimeStamp();
  ////////////////////////////////////////////////////////
  sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PUBLIC_CHANNEL"), stMessage);
  //send message
  NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PUBLIC_CHANNEL"), sConstructedMsg);
}

void Log(string sMessage = "", int nLogLevel = 0, string sKey = "", string sValue = "") {
    int nDesiredLog = StringToInt(NWNX_Util_GetEnvironmentVariable("our_custom_log__level_variable"));
    if (nLogLevel => nDesiredLog) LogWebhook(sKey,sValue,sMessage,nLogLevel); 
}