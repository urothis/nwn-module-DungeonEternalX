// MIT License
// (c) 2019 urothis
#include "nwnx_time"
#include "nwnx_redis_short"
#include "&core_const"
#include "&core_log"
// helper functions
// return hash entry as int
int HashInt(string sPath, string sKey);
int HashInt(string sPath, string sKey) { return NWNX_Redis_GetResultAsInt(HGET(sPath,sKey)); }
// return hash entry as float
float HashFloat(string sPath, string sKey);
float HashFloat(string sPath, string sKey) { return NWNX_Redis_GetResultAsFloat(HGET(sPath,sKey)); }
// return hash entry as string
string HashString(string sPath, string sKey);
string HashString(string sPath, string sKey) { return NWNX_Redis_GetResultAsString(HGET(sPath,sKey)); }

// convert object types to data type strings.
string objectTypeString(object oObject);
string objectTypeString(object oObject) {
  if (oObject == GetModule()) return "server"; // server
  switch(GetObjectType(oObject)) {
    case 1: { 
      if (GetIsPC(oObject))   return "player"; // player
                              return "creature"; }//creature     
    case 2:   {               return "item" } // item
    case 4:   {               return "trigger" } // trigger
    case 8:   {               return "door" } // door
    case 16:  {               return "aoe" } // AOE
    case 32:  {               return "waypoint" } // waypoint
    case 64:  {               return "placeable" } // placeable
    case 128: {               return "store" } // store
    default:  {               return "ERROR" } // something we shouldn't be handling
  }
}

// get db path for object
string dbLocationObject(object oObject);
string dbLocationObject(object oObject) { 
  string sType = objectTypeString(oObject);
  string sUUID = GetObjectUUID(oObject);
  Log("db", sType, sUUID,0);
  return MODULENAME + ":" + sType + ":"+ sUUID; 
}

// get the path to an object from a uuid
string dbLocationUUID(string sUUID);
string dbLocationUUID(string sUUID) {
  object oObject = GetObjectByUUID(sUUID);
  if (GetIsObjectValid(oObject)) {
    Log("db", objectTypeString(oObject),sUUID,0);
    return GetModuleName()+":"+objectTypeString(oObject)+":"+GetObjectUUID(oObject)+":";
  }
  Log("db", objectTypeString(oObject),sUUID,3);
  return "OBJECT_INVALID";
}

// get the path to a cd key
string dbLocationCDKEY(string cdKey);
string dbLocationCDKEY(string cdKey) { return GetModuleName()+":cd-key:"+cdKey; }