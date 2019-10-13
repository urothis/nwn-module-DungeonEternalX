#include "inc_tokenizer"

void main()
{
    object oPC = GetLastUsedBy();
    // testing new dropsystem
    if (GetPCPlayerName(oPC) != "Ezramun") return;
    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_STRENGTH, 20), oPC);
    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSlow(), oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectMovementSpeedDecrease(50), oPC);
}
