//  PW Experience System  v1.4
//  By David Bills
//  OnDeath script - General Otman
#include "give_custom_exp"
#include "otman_event"
void main()
{
    //int nCount = GetLocalInt(GetArea(OBJECT_SELF), "TOTALCOUNT");
    //SetLocalInt(GetArea(OBJECT_SELF), "TOTALCOUNT", --nCount);
    DEXRewardXP(GetLastKiller(), OBJECT_SELF);

    // For DM events, this boss will create a ring item in the killers inventory,
    // in order to verify the kill with the DM properly. Additionally, this ring
    // will transfer to anyone who kills the current holder.
    object oKiller = GetLastKiller();
    object oArea    = GetArea(oKiller);

    CreateItemOnObject("otmans_ring", oKiller);
    ShoutMsg(GetName(oKiller) + " has recovered General Otman's ring!");
    effect eVFX = EffectVisualEffect(219, FALSE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oKiller, 3.0);


    // Cory - Reduce stealth while hold event Ring
    effect eHide = EffectSkillDecrease(SKILL_HIDE, 100);
    effect eMove = EffectSkillDecrease(SKILL_MOVE_SILENTLY, 100);
    effect eLink = EffectLinkEffects(eHide, eMove);
    eLink = ExtraordinaryEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oKiller);

    if  (GetHasFeat(FEAT_MONK_ENDURANCE, oKiller))
    {
          effect eMonkStop = EffectTimeStop();
          effect eMonkImmobile = EffectCutsceneImmobilize();
          eMonkStop = ExtraordinaryEffect(eMonkStop);
          eMonkImmobile = ExtraordinaryEffect(eMonkImmobile);

          ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMonkStop, oKiller);
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMonkImmobile, oKiller);
    }

    OtmanRingTimer(oKiller);
}
