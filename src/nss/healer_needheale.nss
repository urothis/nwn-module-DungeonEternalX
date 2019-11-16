#include "nw_i0_generic"
#include "healer_include"
void SetUpCustomTokens()
{
    SetCustomToken(142, IntToString(HEALER_COST_HEAL));
    SetCustomToken(143, IntToString(HEALER_COST_RESLVL));
    SetCustomToken(144, IntToString(HEALER_COST_RESAB));
    SetCustomToken(145, IntToString(HEALER_COST_DISEASE));
    SetCustomToken(146, IntToString(HEALER_COST_BLIND));
    SetCustomToken(147, IntToString(HEALER_COST_POISON));
    SetCustomToken(148, IntToString(HEALER_COST_CURSE));
}

int StartingConditional()
{
    SetUpCustomTokens();
    object oPC = GetPCSpeaker();
    return (GetHasEffect(EFFECT_TYPE_ABILITY_DECREASE, oPC) ||
            GetHasEffect(EFFECT_TYPE_NEGATIVELEVEL, oPC) ||
            GetHasEffect(EFFECT_TYPE_CURSE, oPC) ||
            GetHasEffect(EFFECT_TYPE_POISON, oPC) ||
            GetHasEffect(EFFECT_TYPE_BLINDNESS, oPC) ||
            GetHasEffect(EFFECT_TYPE_DEAF, oPC) ||
            GetHasEffect(EFFECT_TYPE_ABILITY_DECREASE, oPC) ||
            GetHasEffect(EFFECT_TYPE_ABILITY_DECREASE, oPC) ||
            GetHasEffect(EFFECT_TYPE_ABILITY_DECREASE, oPC) ||
            GetHasEffect(EFFECT_TYPE_ABILITY_DECREASE, oPC) ||
            GetCurrentHitPoints(oPC) < GetMaxHitPoints(oPC)
           );

//    iResult = GZHasNegativeEffects(GetPCSpeaker());
  //  return iResult;
}
