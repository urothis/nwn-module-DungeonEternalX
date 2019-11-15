// MIT License
// (c) 2019 urothis
//////////
#include "&player_inc"
//////////
// db location
string getPlaytimeDBLocation();
string getPlaytimeDBLocation() { return dbLocationCDKEY(oPC) + ":playtime"; }
//////////
// get what ranking the user is in playtime
int getPlaytimePosition(string sUUID);
int getPlaytimePosition(string sUUID) { return ZRANK(getPlaytimeDBLocation,sGuildID); }

// set the time in the variable so we can compare later
void startPlaytimeTracking(object oPC);
void startPlaytimeTracking(object oPC) { playerSetValueInt(oPC, "session_starttime",NWNX_Time_GetTimeStamp()); }

// stop the tracker and update all the data
void stopPlaytimeTracking(object oPC);
void stopPlaytimeTracking(object oPC) {
  int sTime = NWNX_Time_GetTimeStamp();
  string sUUID = playerGetValue(oPC, "guild_id");

  // seconds played this session
  int nSessionPlaytime = (NWNX_Time_GetTimeStamp() - playerGetValueInt(oPC,"session_starttime") + playerGetValueInt(oPC,"total_playtime");

  // per character tracking
  playerSetValue(oPC, "total_playtime", IntToString(nTotalPlaytime));
  playerRemoveValue(oPC, "session_starttime");

  // cdkey wide tracking
  ZADD(getPlaytimeDBLocation(oPC),nSessionPlaytime,sUUID);
}