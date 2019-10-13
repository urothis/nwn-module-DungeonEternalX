//::///////////////////////////////////////////////
//:: FileName merc_elf_2
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 15-1-2004 16:41:02
//:://////////////////////////////////////////////
void main()
{

	// Either open the store with that tag or let the user know that no store exists.
	object oStore = GetNearestObjectByTag("Armor 6");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		OpenStore(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
