#include "_inc_port"

void main()
{
    object oTrans   = OBJECT_SELF;
    object oPC      = GetClickingObject();
    object oTarget  = GetTransitionTarget(oTrans);

    if (GetIsPC(oPC))
    {
        if (GetPortMode(oPC) == PORT_NOT_ALLOWED)
        {
            SendMessageToPC(oPC, "You can not transit at this time");
            return;
        }
        if (GetIsHostilePcNearby(oPC, GetArea(oTrans), 35.0, 5))
        {
            SendMessageToPC(oPC, "A worthy opponent blocks your path...");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTrueSeeing(), oPC, 1.0);
            SetPortMode(oPC, PORT_NOT_ALLOWED);
            DelayCommand(3.0, SetPortMode(oPC));
            return;
        }
    }
    AssignCommand(oPC, JumpToObject(oTarget));
}
