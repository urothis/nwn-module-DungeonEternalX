//::///////////////////////////////////////////////
//:: Negative Energy Ray
//:: NW_S0_NegRay
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Fires a bolt of negative energy at the target
   doing 1d6 damage.  Does an additional 1d6
   damage for 2 levels after level 1 (3,5,7,9) to
   a maximum of 5d6 at level 9.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "_inc_sneakspells"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();

   int nMetaMagic = GetMetaMagicFeat();

   if (nPureLevel > 9 + nPureBonus) nPureLevel = 9 + nPureBonus;

   nPureLevel = (nPureLevel + 1) / 2;
   int nDamage = d6(nPureLevel);

   //Enter Metamagic conditions
   if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nPureLevel;
   else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%

   effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
   effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
   effect eRay;
   int nSneakBonus;
   if (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
   {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY));

            if (BlockNegativeDamage(oTarget)) nDamage = 0;
            else nDamage += getSneakDamageRanged(OBJECT_SELF, oTarget);

            eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Make a saving throw check
                if (nDamage > 0)
                {
                    if (MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_NEGATIVE)) nDamage /= 2;
                }
                effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                //Apply the VFX impact and effects
                //DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY, FALSE));
        eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
        effect eHeal = EffectHeal(nDamage);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}
