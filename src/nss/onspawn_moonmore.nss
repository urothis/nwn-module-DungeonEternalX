#include "_inc_despawn"

void main()
{
    object oCreature = OBJECT_SELF;
    SetAILevel(oCreature, AI_LEVEL_NORMAL);
    AssignCommand(GetArea(oCreature), DelayCommand(600.0, Despawn(oCreature)));
}
