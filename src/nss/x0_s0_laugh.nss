//::///////////////////////////////////////////////
//:: Tasha's Hideous Laughter
//:: [x0_s0_laugh.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Target is held, laughing for the duration
   of the spell (1d3 rounds)

*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   if (HasVaasa(OBJECT_SELF)) nPureBonus = 8;
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();

   int nDamage = 0;
   int nCnt;
   effect eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);

   int nDuration = GetMax(nPureBonus, d6());

   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   // * creatures of different race find different things funny
   if (GetRacialType(oTarget) != GetRacialType(OBJECT_SELF)) nPureDC -= 4;
   if (nPureDC < 1) nPureDC = 1;
   if(!GetIsReactionTypeFriendly(oTarget))
   {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TASHAS_HIDEOUS_LAUGHTER));
        if (!spellsIsMindless(oTarget))
        {
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                if (!WillSave(oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                    {
                        effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                        float fDur = RoundsToSeconds(nDuration);
                        AssignCommand(oTarget, ClearAllActions());
                        AssignCommand(oTarget, PlayVoiceChat(VOICE_CHAT_LAUGH));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDur);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oTarget, fDur);
                        AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
                        DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 6.0));
                    }
                }
            }
        }
   }
}





