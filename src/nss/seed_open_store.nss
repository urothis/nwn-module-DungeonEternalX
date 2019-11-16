void main()
{
    object oStore = GetObjectByTag("STORE_" + GetStringUpperCase(GetTag(OBJECT_SELF)));
    object oPC = GetPCSpeaker();
    if (oPC==OBJECT_INVALID) oPC = GetLastSpeaker();
    OpenStore(oStore, oPC);
}
