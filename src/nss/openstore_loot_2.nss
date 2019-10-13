void main()
{
    object oStore = GetObjectByTag("NEW_MAGICSHOP_3");
    if (GetObjectType(oStore) == OBJECT_TYPE_STORE) OpenStore(oStore, GetPCSpeaker());
    else ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}


