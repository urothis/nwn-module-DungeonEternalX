//::///////////////////////////////////////////////
//:: Deathless Master Touch
//:: X2_S2_dthmsttch
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Pale Master may use their undead arm to
    kill their foes.

    -Requires melee Touch attack
    -Save vs DC 17 to resist

    Epic:
    -SaveDC raised by +1 for each 2 levels past 10th
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 24, 2003
//:://////////////////////////////////////////////

#include "pure_caster_inc"
#include "nw_i0_spells"

void main() {
   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nCasterLvl = GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF);

   int nDC = nCasterLvl + GetMax(GetAbilityModifier(ABILITY_CHARISMA), GetAbilityModifier(ABILITY_INTELLIGENCE));
   if (GetHasSpellSchool(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY)) nDC += 5;

    if (GetIsReactionTypeHostile(oTarget) == TRUE) {
       if (TouchAttackMelee(oTarget,TRUE)>0) {
          //Signal spell cast at event
          SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 624));
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);
          //Saving Throw
          if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH)) {
             //Apply effects to target and caster
             ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
             ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oTarget);
          }
          else
          {
             int nDamage;
             if (!BlockNegativeDamage(oTarget)) nDamage = RandomUpperHalf(nDC);
             ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
          }
       }
    }
}
