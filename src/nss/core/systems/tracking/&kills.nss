// MIT License
// (c) 2019 urothis
#include "&player_inc"
//////////
// guild set locations
string killSetLocation();
string killSetLocation() { return MODULENAME + ":killstreak"; }
// guild db location
string killLocation(string sUUID);
string killLocation(string sUUID) { return MODULENAME + ":" +sUUID; }




void playerSet(object oPC, string sKey, string sValue);
void playerSet(object oPC, string sKey, string sValue) { HMSET(dbLocationObject(oPC),sKey,sValue); }

int playerGetInt(object oPC, string sKey);
int playerGetInt(object oPC, string sKey) { return HashInt(dbLocationObject(oPC),sKey); }

HMSET(dbLocationObject(oPC),sKey,sValue);

//////////
// helper functions
//////////
//

int getKillStreak(oPC) {

}

void killPerformed(object oKiller, object oKilled) {
    string sKillerPath = ,
           sKilledPath = ,
           sSetPath = ;
}



int getKillVS(object oPC, object oEnemy) {

}

string getKillVSPretty(object oPC, object oEnemy) {

}

// add a guild to the set
void addGuild(string sGuildID);
void addGuild(string sGuildID) { SADD(guildsetDBLocation(),sGuildID); }
// how many guilds exist
int guildCount()
int guildCount() { return SCARD(guildsetDBLocation()); }

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
