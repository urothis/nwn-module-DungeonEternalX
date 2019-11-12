// MIT License
// (c) 2019 urothis
#include "&player_inc"
//////////
// guild db location
string guildDBLocation(string sGuildID);
string guildDBLocation(string sGuildID) { return MODULENAME + ":" +sGuildID; }

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
// get oPC guild id
string getGuild(object oPC);
string getGuild(object oPC) { return playerGetValue(oPC, "guild_id"); }

// get guild name
string getGuildName(string sGuildID);
string getGuildName(string sGuildID) { return guildGetString(sGuildID, "name")}

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
  } else {
    // alert those involved
    FloatingTextStringOnCreature("You are now the owner of " + sGuildName,oNewOwner); 
    FloatingTextStringOnCreature("You have transferred ownership of " + sGuildName,oOldOwner);
    // set the new guild owner
    HMSET(sGuildDB,"owner",GetObjectUUID(oNewOwner));
  }
}

// set the players guild
void setGuild(object oPC, string sGuildID);
void setGuild(object oPC, string sGuildID) { 
  playerSetValue(oPC, "guild_id", sGuildID);
  // TODO alot of things to set here
}

//////////
// new guild 
//////////
// create a new guild with the given player as the owner
void newGuild(object oPC, string sName);
void newGuild(object oPC, string sName) {
  // new guild with a random uuid
  string sGuildDB = guildDBLocation(GetRandomUUID());
  // set the guild id on the original member
  AddPlayerToGuild(object oPC, string sGuildID, 1);
  // core values we want to store
  HMSET(sGuildDB,"name",sName);
  // the first owner
  HMSET(sGuildDB,"owner",GetObjectUUID(oPC));
  // date of birth
  HMSET(sGuildDB,"dob",NWNX_Time_GetSystemDate());
  // time of birth
  HMSET(sGuildDB,"tob",NWNX_Time_GetSystemTime());
}