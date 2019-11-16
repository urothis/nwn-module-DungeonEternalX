//::///////////////////////////////////////////////
//:: Elemental Shield
//:: NW_S0_FireShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 50% cold and fire immunity.  Also anyone
    who strikes the caster with melee attacks takes
    1d6 + 1 per caster level in damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Created On: Aug 28, 2003, GZ: Fixed stacking issue

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"
#include "_functions"

void main()
{
   if (!X2PreSpellCastCode()) return;

   if (HasShield(SPELL_MESTILS_ACID_SHEATH, "Acid", "Elemental")) return;
   if (HasShield(SPELL_DEATH_ARMOR, "Death Armor", "Elemental")) return;
   if (HasShield(SPELL_WOUNDING_WHISPERS, "Wounding Whispers", "Elemental")) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
   object oTarget = OBJECT_SELF;
   int nDamage = GetMin(15, nPureLevel / 2) + 2 * nPureBonus;
   int nDuration = nPureLevel;
   int nDice = DAMAGE_BONUS_1d6;
   if (nPureBonus) {
      nDuration *= 2;
      nDice = DAMAGE_BONUS_2d6;
   }

   if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

    effect eShield = EffectDamageShield(nDamage, nDice, DAMAGE_TYPE_COLD);
    effect eCold = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
    effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eCold);
    eLink = EffectLinkEffects(eLink, eFire);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ELEMENTAL_SHIELD, FALSE));

    //  *GZ: No longer stack this spell
    if (GetHasSpellEffect(GetSpellId(),oTarget)) RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}
