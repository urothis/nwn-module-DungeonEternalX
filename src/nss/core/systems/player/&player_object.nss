// MIT License
// (c) 2019 urothis
#include "_sys_plyr_inc"
//////////////////////////////////////////////////////
// persistent object system
//////////////////////////////////////////////////////
// db locations
string playerObjectDB(object oPC, string sSystem);
string playerObjectDB(object oPC, string sSystem) { return dbLocationObject(oPC) + ":system:" +sSystem; }

// a placeable will be created with the resref of "system_yoursystemnamehere"
// make sure to create this object in toolset
object createNewObject(object oPC, string sSystem, string sNewTag="");
object createNewObject(object oPC, string sSystem, string sNewTag="") {
  return CreateObject(OBJECT_TYPE_PLACEABLE, "system_" + sSystem, GetLocation(oPC), TRUE,sNewTag);
}

// return the relavent object to the system functions
object getPersistantPlayerObject(object oPC, string sSystem) {
  string sPath = playerObjectDB(oPC, sSystem);
  string sObject = HashString(sPath, sSystem);
  // if the object does exist already
  if (sObject != "(nil)") {
    object oObject = NWNX_Object_Deserialize(sObject);
    // check for object/uuid collision
    if (HashString(sPath, "object_uuid") != GetObjectUUID(oObject)) {
      NWNX_Object_Deserialize(sObject);
      // put the object in redis
      playerSet(sPath, "object", NWNX_Object_Serialize(sObject));
      // set object uuid in db so we can grab later
      playerSet(sPath, "object_uuid", GetObjectUUID(oObject));
    }
    return sObject;
  }
  // gotta make the object if it doesn't exist
  object sObject = createNewObject(oPC,sSystem);
  // put the object in redis
  playerSet(sPath, "object", NWNX_Object_Serialize(sObject));
  // set object uuid in db so we can grab later
  playerSet(sPath, "object_uuid", GetObjectUUID(oObject));
  return sObject;
}