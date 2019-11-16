#include "inc_traininghall"

void main()
{
    object oPC = GetExitingObject();
    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;
    if (GetIsDMPossessed(oPC)) return;

    effect eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectType(eEffect) != EFFECT_TYPE_HASTE) RemoveEffect(oPC, eEffect);
        eEffect = GetNextEffect(oPC);
    }

    ExecuteScript("_mod_areaexit", OBJECT_SELF);
}
