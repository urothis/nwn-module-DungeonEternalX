#include "healer_include"

void main()
{
    int nGold = HEALER_COST_DISEASE;
    object oPC = GetPCSpeaker();
    if (GetGold(oPC)>=nGold)
    {
        TakeGoldFromCreature(nGold, oPC);
        ActionPauseConversation();
        ActionCastFakeSpellAtObject(SPELL_HEAL,oPC);
        effect eBad = GetFirstEffect(oPC);
        while(GetIsEffectValid(eBad))
        {
            if (GetEffectType(eBad) == EFFECT_TYPE_DISEASE)
            {
                RemoveEffect(oPC, eBad);
            }
            eBad = GetNextEffect(oPC);
        }
        ActionResumeConversation();
    }
    else
    ActionSpeakString("Sorry, you cannot afford my services!");
}
