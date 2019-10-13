#include "nw_i0_plot"

void main()
{
    object oStore = GetObjectByTag("zelda");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
//        gplotAppraiseOpenStore(oStore, GetPCSpeaker());
        OpenStore(oStore, GetPCSpeaker());
    else
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}


