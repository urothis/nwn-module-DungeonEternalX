#include "_inc_port"

void main()
{
    object oTrans   = OBJECT_SELF;
    object oPC      = GetClickingObject();
    object oTarget  = GetTransitionTarget(oTrans);
    string sAreaTag = GetTag(GetArea(oPC));

    if (!GetIsDM(oPC))
    {
        FloatingTextStringOnCreature("This room is for DMs only.", oPC);
        return;
    }

    AssignCommand(oPC, JumpToObject(oTarget));
    return;
}
