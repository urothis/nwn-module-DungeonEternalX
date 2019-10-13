#include "_vfx_"
#include "_functions"

void main()
{
    object oPC = GetPCSpeaker();
    object oPoL = DefGetObjectByTag("mfxE_PillarOfLife");

    FXPortEthereal(oPC);
    DelayCommand(2.9, AssignCommand(oPC, ActionJumpToObject(oPoL)));
}
