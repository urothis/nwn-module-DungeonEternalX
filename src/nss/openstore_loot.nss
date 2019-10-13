#include "random_loot_inc"

// stores are loaded in modload (random_loot_inc)

void main()
{
    object oHolder = LootGetVariableHolder();
    string sStore = GetLocalString(OBJECT_SELF, "MAGICSHOP");
    object oStore = GetLocalObject(oHolder, "MAGICSHOP_" + sStore);
    if (GetObjectType(oStore) == OBJECT_TYPE_STORE) OpenStore(oStore, GetPCSpeaker());
    else ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}


