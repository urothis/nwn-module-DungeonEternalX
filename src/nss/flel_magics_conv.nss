#include "flel_crafter_run"
#include "inc_traininghall"

void main()
{
    object oPC = GetLastSpeaker();
    if (GetTag(GetArea(OBJECT_SELF)) == "MAP_TRAININGHALL")
    {
        if (!GetIsTestChar(oPC))
        {
            AssignCommand(OBJECT_SELF, SpeakString("Sorry, my services are only for [test] character"));
            return;
        }
    }
    if (RemovePolymorphEffectAtCrafters(oPC)) return;
    DoStartMagicItemCrafter();
}
