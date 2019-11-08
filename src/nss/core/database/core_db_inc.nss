#include "nwnx_time"
#include "nwnx_redis_short"
#include "core_log"

const string MODULENAME = DungeonEternalX;

// convert object types to data types.
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

// get db location for object
string dbLocationObject(object oObject) { 
  string sType = objectTypeString(oObject);
  string sUUID = GetObjectUUID(oObject);
  Log("db", sType, sUUID,0);
  return MODULENAME + ":" + sType + ":"+ sUUID + ":"; 
}

// this is super useful to grab a specific object for pubsub.
string dbLocationUUID(string sUUID) {
  object oObject = GetObjectByUUID(sUUID);
  return GetModuleName()+":"+objectTypeString(oObject)+":"+GetObjectUUID(oObject)+":";
}