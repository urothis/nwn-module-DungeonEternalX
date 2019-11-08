//::///////////////////////////////////////////////
//:: Haste
//:: NW_S0_Haste.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the targeted creature one extra partial
    action per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 29, 2001
//:://////////////////////////////////////////////
// Modified March 2003: Remove Expeditious Retreat effects

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "pure_caster_inc"

void main()
{

    if (!X2PreSpellCastCode()) return;

    //Declare major variables
    object oTarget = GetSpellTargetObject();

    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget))
    {
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(647, oTarget))
    {
        RemoveSpellEffects(647, OBJECT_SELF, oTarget); // epic blinding speed
    }

    RemoveSpecificEffect(EFFECT_TYPE_SLOW, oTarget);

    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));

    DelayCommand(0.1, ReapplyPermaHaste(oTarget));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}


