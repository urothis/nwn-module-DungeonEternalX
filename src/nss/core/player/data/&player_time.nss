// MIT License
// (c) 2019 urothis
#include "&player_inc"
// track character playtime
void trackPlaytime(object oPC, int nON) {
  string DB = dbLocationObject(oPC);
  if (nON) {
    playerSetValueInt(oPC, "session_starttime",NWNX_Time_GetTimeStamp()); 
  } else {
    int nTotalPlaytime = (NWNX_Time_GetTimeStamp() - playerGetValueInt(oPC,"session_starttime")) + playerGetValueInt(oPC,"total_playtime");
    playerSetValue(oPC, "total_playtime", IntToString(nTotalPlaytime));
    playerRemoveValue(oPC, "session_starttime");
  }
  BGSAVE();
}