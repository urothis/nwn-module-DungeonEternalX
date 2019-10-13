#include "give_custom_exp"

void main()
{
    // Add custom content here, such as magical effects.
    // This is the only location that objects can be placed in the creature's
    // inventory, and expect them to appear after death.
    //int nCount = GetLocalInt(GetModule(), "MONSTERCOUNT");
    //SetLocalInt(GetModule(), "MONSTERCOUNT", --nCount);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_DEATH_L), GetLocation(OBJECT_SELF),0.0f);

    if( !GetIsPC( OBJECT_SELF ) )
      DEXRewardXP(GetLastKiller(), OBJECT_SELF);

        if (GetLastKiller() != OBJECT_SELF)
    {
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(9000, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), OBJECT_SELF);
    return;
    }
     if (GetLastKiller() == OBJECT_SELF)
        return;
}

