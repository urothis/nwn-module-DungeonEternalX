#include "random_event"

void main()
{
    ClearAllActions();
    object oArea = GetArea(OBJECT_SELF);
    //Get the nearest creature to the affected creature

    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    if (GetArea(oPC) != oArea)
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    location lLoc = GetLocation(OBJECT_SELF);

    int nEncounter = CountEncounter(oArea, lLoc);

    if (!nEncounter)
    {
        DestroyObject(OBJECT_SELF);
        DeleteLocalInt(GetLocalObject(OBJECT_SELF, "OHNOS_AREA"), "OHNOS");
        return;
    }

    int nCall = GetLocalInt(OBJECT_SELF, "CALL");

    if (GetDistanceBetween(OBJECT_SELF, oPC) < 10.0)
    {
        ActionMoveAwayFromObject(oPC, TRUE);
        if (nCall == 1) PlayVoiceChat(VOICE_CHAT_FLEE, OBJECT_SELF);
        else if (nCall >= 2 || nCall == 0)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), OBJECT_SELF, 6.0);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(472), lLoc);
            if (nCall) PlayVoiceChat(VOICE_CHAT_GOODBYE, OBJECT_SELF);
            AssignCommand(OBJECT_SELF, DelayCommand(1.0, JumpToObject(GetNearestObject(OBJECT_TYPE_ENCOUNTER, OBJECT_SELF, nEncounter))));
            SetLocalInt(OBJECT_SELF, "CALL", 1);
            return;
        }
        SetLocalInt(OBJECT_SELF, "CALL", nCall + 1);
    }
}
