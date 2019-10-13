//:://////////////////////////////////////////////////
//   NW_C2_DEFAULT9
//
//   Default OnSpawn handler
//
//:://////////////////////////////////////////////////

#include "x0_i0_anims"
#include "_inc_despawn"
#include "x2_inc_switches"
#include "random_event"


void main()
{
    object oCreature = OBJECT_SELF;

    SetAILevel(oCreature, AI_LEVEL_LOW);

    if (GetIsEncounterCreature(oCreature))
    {
        object oArea = GetArea(oCreature);
        DoDynamicBuff(oCreature, oArea);
        CheckExtraSpawn(oCreature);
        AssignCommand(oArea, DelayCommand(60.0, Despawn(oCreature)));
    }
    if (GetTag(OBJECT_SELF) == "GENERALOTMAN")
    {
        ShoutMsg("New event started: General Otman");
        ShoutMsg("Claim General Otman's ring and return it to a DM for a reward! Those with monk speed cannot safely hold this ring.");
    }

    //SetListeningPatterns();
}
