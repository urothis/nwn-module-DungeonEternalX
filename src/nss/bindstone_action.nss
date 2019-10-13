//:://////////////////////////////////
//:: Action Taken - bind to location
//:: goes in Bindstone conversation
//:://////////////////////////////////

#include "_inc_port"
#include "quest_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oArea = GetArea(OBJECT_SELF);

    Q_BindStoneQuest(oPC, GetTag(oArea));

    string sBPName = GetName(oArea);
    object oWP = GetNearestObjectByTag("WP_BINDSTONE", OBJECT_SELF);

    SetBind(oPC, GetName(oWP));
    AssignCommand(oPC, PlayAnimation( ANIMATION_LOOPING_WORSHIP, 1.0, 5.0));
    DelayCommand(5.5, ActionFloatingTextStringOnCreature("You are now bound at " + sBPName, oPC, FALSE));
}
