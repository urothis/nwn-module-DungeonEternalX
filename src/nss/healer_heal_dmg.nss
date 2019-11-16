#include "healer_include"

void main()
{
    int nGold = HEALER_COST_HEAL;
    object oPC = GetPCSpeaker();
    if (GetGold(oPC)>=nGold)
    {
        TakeGoldFromCreature(nGold, oPC);
        ActionPauseConversation();
        ActionCastFakeSpellAtObject(SPELL_HEAL,oPC);
        effect eEffect = EffectHeal(GetMaxHitPoints(oPC) - GetCurrentHitPoints(oPC));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oPC);
        ActionResumeConversation();
    }
    else
    ActionSpeakString("Sorry, you cannot afford my services!");

}
