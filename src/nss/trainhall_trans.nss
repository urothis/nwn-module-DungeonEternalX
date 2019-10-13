#include "inc_traininghall"
#include "gen_inc_color"

void main()
{
    object oPC = GetClickingObject();
    if (GetIsTestChar(oPC))
    {
        effect eEffect = EffectKnockdown();
        AssignCommand(GetObjectByTag("TRAINING_HALL_NPC"), ActionSpeakString(GetName(oPC) + ", you stay here!"));
        DelayCommand(0.3, AssignCommand(oPC, ActionSpeakString(GetRGB(9,9,9) + "Oh, crap!", TALKVOLUME_WHISPER)));
        DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 1.0));
        DelayCommand(2.5, AssignCommand(oPC, ActionSpeakString("Aye, Sir!")));
        return;
    }
    AssignCommand(oPC, JumpToLocation(GetLocation(GetWaypointByTag("WP_TAVERN_TO_TRAINING"))));
}
