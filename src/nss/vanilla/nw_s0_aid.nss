//::///////////////////////////////////////////////
//:: Aid
//:: NW_S0_Aid.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature gains +1 to attack rolls and
    saves vs fear. Also gain +1d8 temporary HP.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 6, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "x2_inc_spellhook"

void main()
{

    if (!X2PreSpellCastCode()) return;

    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2; //Duration is +100%
    else if (GetTag(GetSpellCastItem()) == "POT_EXT_AID") nDuration *= 2;

    effect eAttack = EffectAttackIncrease(1);

    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

    effect eLink = EffectLinkEffects(eAttack, eSave);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_AID, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

