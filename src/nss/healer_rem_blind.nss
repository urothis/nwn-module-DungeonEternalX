#include "healer_include"

void main()
{
    int nGold = HEALER_COST_BLIND;
    object oPC = GetPCSpeaker();
    if (GetGold(oPC)>=nGold)
    {
        TakeGoldFromCreature(nGold, oPC);
        ActionPauseConversation();
        ActionCastFakeSpellAtObject(SPELL_HEAL,oPC);
        effect eBad = GetFirstEffect(oPC);
        while(GetIsEffectValid(eBad))
        {
            if (GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS)
                RemoveEffect(oPC, eBad);
            else if (GetEffectType(eBad) == EFFECT_TYPE_DEAF)
                RemoveEffect(oPC, eBad);
            eBad = GetNextEffect(oPC);
        }
        ActionResumeConversation();
    }
    else
    ActionSpeakString("Sorry, you cannot afford my services!");
}
