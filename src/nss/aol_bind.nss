#include "_vfx_"
#include "_inc_port"

void main()
{
    object oPC = GetPCSpeaker();
    FXPortEthereal(oPC);
    DelayCommand(3.0, PortToBind(oPC));
}
