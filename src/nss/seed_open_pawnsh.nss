#include "_functions"

void main()
{
    int iStore = GetLocalInt(OBJECT_SELF, "PAWNSHOP");
    object oPC = GetPCSpeaker();
    if (oPC == OBJECT_INVALID) oPC = GetLastSpeaker();
    if (iStore == 0)
    {
        SendMessageToPC(oPC, "Pawn don't got no sto'");
        return;
    }
    object oStore = DefGetObjectByTag("PAWNSHOP_" + IntToString(iStore));
    OpenStore(oStore, oPC);
}
