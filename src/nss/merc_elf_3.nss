//::///////////////////////////////////////////////
//:: FileName merc_elf_3
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 15-1-2004 16:49:13
//:://////////////////////////////////////////////
void main()
{

	// Either open the store with that tag or let the user know that no store exists.
	object oStore = GetNearestObjectByTag("Weapon 6");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		OpenStore(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
