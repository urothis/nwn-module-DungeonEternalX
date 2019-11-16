#include "nw_i0_generic"
#include "healer_include"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iMenuPos = GetLocalInt(OBJECT_SELF, MENUPOSITION);
    SetLocalInt(OBJECT_SELF, MENUPOSITION, ++iMenuPos);
    switch(--iMenuPos)
    {
        case 0:
            return (GetCurrentHitPoints(oPC) < GetMaxHitPoints(oPC));
        case 1:
            return (GetHasEffect(EFFECT_TYPE_NEGATIVELEVEL, oPC));
        case 2:
            return (GetHasEffect(EFFECT_TYPE_ABILITY_DECREASE, oPC));
        case 3:
            return (GetHasEffect(EFFECT_TYPE_DISEASE, oPC));
        case 4:
            return (GetHasEffect(EFFECT_TYPE_DEAF, oPC) || GetHasEffect(EFFECT_TYPE_BLINDNESS, oPC));
        case 5:
            return (GetHasEffect(EFFECT_TYPE_POISON, oPC));
        case 6:
            SetLocalInt(OBJECT_SELF, MENUPOSITION, 0);
            return (GetHasEffect(EFFECT_TYPE_CURSE, oPC));
    }
    return FALSE;
}
