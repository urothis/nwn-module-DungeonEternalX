#include "X0_INC_HENAI"


void main()
{
    object oMaster = GetMaster();
    if(GetIsObjectValid(oMaster))
    {
        if (GetDistanceToObject(oMaster) > 7.0)
        {
            ActionForceFollowObject(oMaster, 6.0);
        }
        else if (GetCurrentAction(OBJECT_SELF) != ACTION_CASTSPELL)
        {
            int nMaxHP = GetMaxHitPoints(oMaster);
            int nCurHP = GetCurrentHitPoints(oMaster);
            if (nCurHP < (nMaxHP/100)*80)
            {
                ClearAllActions();
                ActionCastFakeSpellAtObject(SPELL_HEAL, oMaster);
                DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G), oMaster));
                DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetHitDice(oMaster)*2 + d20()), oMaster));
            }
        }
    }
}




