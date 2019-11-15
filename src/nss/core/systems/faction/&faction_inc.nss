// MIT License
// (c) 2019 urothis
#include "&player_inc"
//////////
// guild set locations
string guildsetDBLocation();
string guildsetDBLocation() { return MODULENAME + ":guild"; }
// guild db location
string guildDBLocation(string sGuildID);
string guildDBLocation(string sGuildID) { return MODULENAME + ":" +sGuildID; }
//////////
// helper functions
//////////
// Add value to the core guild hash
void guildSet(string sGuildID, string sKey, string sValue);
void guildSet(string sGuildID, string sKey, string sValue) { HMSET(guildDBLocation(sGuildID),sKey,sValue); }
// Remove value from the core guild hash
void guildRemove(string sGuildID, string sKey);
void guildRemove(string sGuildID, string sKey) { HDEL(guildDBLocation(sGuildID),sKey); }
// Get string from the core guild hash
string guildGetString(string sGuildID, string sKey);
string guildGetString(string sGuildID, string sKey) { return HashString(guildDBLocation(sGuildID),sKey)); }
// Get int from the core guild hash
int guildGetInt(string sGuildID, string sKey);
int guildGetInt(string sGuildID, string sKey) { return HashInt(guildDBLocation(sGuildID),sKey); }
// Get float from the core guild hash
float guildGetFloat(string sGuildID, string sKey);
float guildGetFloat(string sGuildID, string sKey) { return HashFloat(guildDBLocation(sGuildID),sKey);

//////////
// guild base functions
//////////
// sets
//////////
// add a guild to the set
void addGuild(string sGuildID);
void addGuild(string sGuildID) { SADD(guildsetDBLocation(),sGuildID); }
// how many guilds exist
int guildCount()
int guildCount() { return SCARD(guildsetDBLocation()); }

//////////
// sorted sets
//////////
// add or remove a value from the playercount
void modifyGuildMemberCount(string sGuildID, int nOffset);
void modifyGuildMemberCount(string sGuildID, int nOffset) { ZADD(guildsetDBLocation() + ":memberCount",sGuildID,nOffset); }
// return the guild member count
int getGuildMemberCount(string sGuildID);
int getGuildMemberCount(string sGuildID) { return ZSCORE(guildsetDBLocation() + ":memberCount",sGuildID); }
// get what ranking the guild is in member count
int getGuildMemberCountPosition(string sGuildID);
int getGuildMemberCountPosition(string sGuildID) { return ZRANK(guildsetDBLocation() + ":memberCount",sGuildID); }

//////////
// modify player
//////////
// get oPC guild id
string getGuild(object oPC);
string getGuild(object oPC) { return playerGetValue(oPC, "guild_id"); }
// get guild name
string getGuildName(string sGuildID);
string getGuildName(string sGuildID) { return guildGetString(sGuildID, "name")}
// set the players guild
void setGuild(object oPC, string sGuildID);
void setGuild(object oPC, string sGuildID) { 
  playerSetValue(oPC, "guild_id", sGuildID);
  modifyGuildMemberCount(sGuildID, 1);
}
// remove player from guild
void remGuild(object oPC) {
  playerSetValue(oPC, "", sGuildID);
  modifyGuildMemberCount(sGuildID, -1);  
}

//////////
// modify guild
//////////
// set guild name
void setGuildName(string sGuildID, string sNewName);
void setGuildName(string sGuildID, string sNewName) { guildSet(sGuildID,"name",sNewName); }
// get guild owner uuid
string getGuildOwner(string sGuildID);
string getGuildOwner(string sGuildID) { return guildGetString(sGuildID,"owner"); }
// is sUUID the guild owner
int isGuildOwner(string sUUID, string sGuildID);
int isGuildOwner(string sUUID, string sGuildID) { return sGuildID != sUUID }
// set the guild owner
void setGuildOwner(object oOldOwner, object oNewOwner);
void setGuildOwner(object oOldOwner, object oNewOwner) {
  string sGuildName = getGuildName(oOldOwner),
         sGuildDB = guildDBLocation(getGuild(oOldOwner));
  if(!isGuildOwner(oOldOwner)) {
    // alert those involved
    FloatingTextStringOnCreature(GetName(oOldOwner) + " is not the owner of " + sGuildName,oNewOwner);
    FloatingTextStringOnCreature("You are not the owner of " + sGuildName,oOldOwner); 
    // do nothing
    return;
  }
  // alert those involved
  FloatingTextStringOnCreature("You are now the owner of " + sGuildName,oNewOwner); 
  FloatingTextStringOnCreature("You have transferred ownership of " + sGuildName,oOldOwner);
  // set the new guild owner
  HMSET(sGuildDB,"owner",GetObjectUUID(oNewOwner));
}

//////////
// new guild 
//////////
// create a new guild with the given player as the owner
void newGuild(object oPC, string sName);
void newGuild(object oPC, string sName) {
  // new guild with a random uuid
  string sUUID = GetRandomUUID();
  string sGuildDB = guildDBLocation(sUUID);
  // set the guild id on the original member
  setGuild(oPC, sUUID);
  // add guild to set
  addGuild(sGuildID);
  // core values we want to store
  HMSET(sGuildDB,"name",sName);
  // the first owner
  HMSET(sGuildDB,"owner",GetObjectUUID(oPC));
  // date of birth
  HMSET(sGuildDB,"dob",NWNX_Time_GetSystemDate());
  // time of birth
  HMSET(sGuildDB,"tob",NWNX_Time_GetSystemTime());
}