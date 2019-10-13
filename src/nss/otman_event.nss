// Handles the DM event for General Otman and his ring.
#include "_inc_death"


// Players can win the event by holding the ring for a certain amount of time.
void OtmanRingTimer(object oPC)
{
    // Make sure PC has ring still
    if (!HasItem(oPC, "GeneralOtmansRing"))
    {
        return;
    }

    // Check if PC has held ring 6 minutes
    if (GetLocalInt(oPC, "OtmanRingTime") >= 6)
    {
          ShoutMsg(GetName(oPC) + " has held General Otman's ring for six minutes! Congratulations!");
          DeleteLocalInt(oPC, "OtmanRingTime");
          object oItem = GetItemPossessedBy(oPC, "GeneralOtmansRing");
          //ActionTakeItem(oItem, oPC);
          DestroyObject(oItem);
    }
    else // Update Time every minute
    {
          ShoutMsg(GetName(oPC) + " has held General Otman's ring for " + IntToString(GetLocalInt(oPC, "OtmanRingTime")) + " minute(s).");
          int nTimer = GetLocalInt(oPC, "OtmanRingTime") + 1;
          SetLocalInt(oPC, "OtmanRingTime", nTimer);
          AssignCommand(oPC, DelayCommand(60.0, OtmanRingTimer(oPC)));
    }
}



void GeneralOtmanEvent(object oPC, object oKiller)
{
    object oItem = GetItemPossessedBy(oPC, "GeneralOtmansRing");
    DestroyObject(oItem);
    CreateItemOnObject("otmans_ring", oKiller);

    // Shout Killer/Location. Edit: location removed
    ShoutMsg(GetName(oKiller) + " has recovered General Otman's ring!");
    effect eVFX = EffectVisualEffect(219, FALSE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oKiller, 3.0);

/*    // Cory - Reduce stealth while holding event Ring; This may be restorable
    effect eHide = EffectSkillDecrease(SKILL_HIDE, 100);
    effect eMove = EffectSkillDecrease(SKILL_MOVE_SILENTLY, 100);
    effect eLink = EffectLinkEffects(eHide, eMove);
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oKiller);
*/
    // No fast runners holding the ring
    if  (GetHasFeat(FEAT_MONK_ENDURANCE, oKiller))
    {
         effect eMonkStop = EffectTimeStop();
         effect eMonkImmobile = EffectCutsceneImmobilize();
         eMonkStop = ExtraordinaryEffect(eMonkStop);
         eMonkImmobile = ExtraordinaryEffect(eMonkImmobile);

         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMonkStop, oKiller);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMonkImmobile, oKiller);
    }

    OtmanRingTimer(oKiller);// Begin timer for player holding ring
}


