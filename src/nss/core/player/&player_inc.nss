// MIT License
// (c) 2019 urothis
#include "&core_db_inc"
//////////////////////////////////////////////////////
// character specific values
//////////////////////////////////////////////////////
// Add value to the core player hash
void playerSet(object oPC, string sKey, string sValue);
void playerSet(object oPC, string sKey, string sValue) { HMSET(dbLocationObject(oPC),sKey,sValue); }
// Remove value from the core player hash
void playerRemove(object oPC, string sKey);
void playerRemove(object oPC, string sKey) { HDEL(dbLocationObject(oPC),sKey); }
// Get string from the core player hash
string playerGetString(object oPC, string sKey);
string playerGetString(object oPC, string sKey) { return HashString(dbLocationObject(oPC),sKey)); }
// Get int from the core player hash
int playerGetInt(object oPC, string sKey);
int playerGetInt(object oPC, string sKey) { return HashInt(dbLocationObject(oPC),sKey); }
// Get float from the core player hash
float playerGetFloat(object oPC, string sKey);
float playerGetFloat(object oPC, string sKey) { return HashFloat(dbLocationObject(oPC),sKey);

// new account
void newCDKEY() {

}

// new character
void newCharacter() {

}

// player account tracking
void trackAccount(object oPC)  {
  string sCD = GetPCPublicCDKey(oPC);
  string sIP = GetPCIPAddress(oPC);

  // first login data
  if (!EXISTS(playerGetValueString(oPC,"first_seen")) {
    
  }

  // every login
  // if different cdkey
  if ( sCD != playerGetValueInt(oPC,"CDKEY")) { 
    // TODO cd key change  
    SendMessageToPC(oPC,"Your CD-KEY has changed."); 
  }
  // if different ip
  if (IP != playerGetValueInt(oPC,"IP")) { 
    // TODO ip change
    SendMessageToPC(oPC,"Your IP address has changed."); 
  }
}

// this will be triggered via chat command
void requestAddDiscordToCharacter(object oPC) {
  string sPin = IntToString(Random(10000));  
  PUBLISH("discord.register",sPin); 
  HMSET(dbLocationObject(GetModule()+"discord:"+sPin),"uuid",GetObjectUUID(oObject));
  HMSET(dbLocationObject(GetModule()+"discord:"+sPin),"name",GetName(oPC));  

  FloatingTextStringOnCreature(oPC, "Please message the DungeonEternalX discord bot with your pin code.");
  FloatingTextStringOnCreature(oPC, "This will link your discord account to this character.");
}

// this will be triggered via pubsub upon completion
void addDiscordToCharacter(string sUUID) {
  object oPC = GetObjectByUUID(sUUID);
  string sDiscordName = playerGetValue(oPC, "discord_account");
  FloatingTextStringOnCreature(oPC, "You're character is now linked with discord user " + sDiscordName);
}

// call all tracking from here
void mainPlayerTrackingStart(object oPC) {
  trackPlaytime(oPC,1);
  trackAccount(oPC);
}

void mainPlayerTrackingStop(object oPC) {
  trackPlaytime(oPC,0);

}