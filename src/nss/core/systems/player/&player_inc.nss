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
void newCDKEY(object oPC, string sOld, string sNew) {
  SendMessageToPC(oPC,"Your cdkey has changed.");
  // new cd key

}

// new character
void newCharacter() {
  // add character to account tracking
}

// player account tracking
void trackAccount(object oPC)  {
  string sCD = GetPCPublicCDKey(oPC);
  string sStoredCD = playerGetValueInt(oPC,"CDKEY");
  string sIP = GetPCIPAddress(oPC);

  // first login data
  if (!EXISTS(playerGetValueString(oPC,"first_seen")) {
    
  }

  // every login
  // if different cdkey
  if ( sCD != sStoredCD) { newCDKEY(oPC, sStoredCD, sCD); }

  // if different ip
  if (IP != playerGetValueInt(oPC,"IP")) { 
    // TODO ip change
     
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

// this will be triggered via pubsub upon link
void addDiscordToCharacter(string sUUID) {
  object oPC = GetObjectByUUID(sUUID);
  string sDiscordName = playerGetValue(oPC, "discord_account");
  FloatingTextStringOnCreature(oPC, "You're character is now linked with discord user " + sDiscordName);
}

// call all player tracking from here
void mainPlayerTrackingStart(object oPC) {
  trackPlaytime(oPC,1);
  trackAccount(oPC);
}

// stop all player tracking from here
void mainPlayerTrackingStop(object oPC) {
  trackPlaytime(oPC,0);

}