#include "_inc_port"

void main()
{
    object oPC = GetExitingObject();
    DeleteLocalInt(oPC, "PORTS_DEACTIVATE");
    SetPortMode(oPC, FALSE);
    effect eFX = GetFirstEffect(oPC);
    while (GetIsEffectValid(eFX))
    {
        if (GetEffectType(eFX) == EFFECT_TYPE_SPELL_FAILURE)
        {
            RemoveEffect(oPC, eFX);
            break;
        }
        eFX = GetNextEffect(oPC);
    }
    int nHP = GetCurrentHitPoints(oPC);
    if(nHP > 10)
    {
        effect eDmg = EffectDamage(nHP-10, DAMAGE_TYPE_BLUDGEONING);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oPC);
    }
    ExecuteScript("_mod_areaenter", OBJECT_SELF);
}
