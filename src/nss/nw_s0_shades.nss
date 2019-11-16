//::///////////////////////////////////////////////
//:: Shades
//:: NW_S0_Shades.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   If the opponent is clicked on Shadow Bolt is cast.
   If the caster clicks on himself he will cast
   Stoneskin and Mirror Image.  If they click on
   the ground they will summon a Shadow Lord.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"
#include "nw_i0_spells"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ILLUSION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ILLUSION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nMetaMagic = GetMetaMagicFeat();
   object oTarget = GetSpellTargetObject();
   int nCast;
   int nDuration  = nPureLevel;
   string sResRef;
   effect eVis;
   effect eClarity;
   effect eMind;
   effect eAC;
   effect eStone;
   effect eLink;
   effect eMirror;
   int nPower;

   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   if (GetIsObjectValid(oTarget))
   {
       if (oTarget==OBJECT_SELF) nCast = 1;
       else nCast = 1;
   }
   else
   {
       nCast = 3;
   }

   int nSpellID = GetSpellId();
   switch (nCast)
   {
      case 1:
         //eMirror = EffectVisualEffect(VFX_DUR_ANTI_LIGHT_10);
         eMirror = EffectVisualEffect(VFX_IMP_TORNADO);
         RemoveEffectsFromSpell(oTarget, nSpellID);

            if (nSpellID == SPELL_SHADOW_CONJURATION_MAGE_ARMOR) // SHADOW_CONJURATION - Mage Armor and Mirror Image
            {
               RemoveEffectsFromSpell(oTarget, SPELL_MAGE_ARMOR); // DON'T STACK AC
               RemoveEffectsFromSpell(oTarget, SPELL_SHADOW_CONJURATION_MAGE_ARMOR); // Remove stacking of mage armor
               eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

               if (GetLevelByClass(CLASS_TYPE_FIGHTER, oTarget)) // Check for Fighter natural AC
               {
                      if (GetHasFeat(FEAT_IMPROVED_PARRY, oTarget))
                      {
                            int nFtrAc = GetLevelByClass(CLASS_TYPE_FIGHTER, oTarget)/5;
                            eAC =  EffectACIncrease(nFtrAc + 5 + nPureBonus/4, AC_NATURAL_BONUS);
                      }
               }

               else // Target doesn't have fighter natural ac bonus
               {
                    eAC = EffectACIncrease(5 + nPureBonus/4, AC_NATURAL_BONUS);
               }

               effect eMageArmorDodgeAc = EffectACIncrease(1, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);

               eLink = EffectLinkEffects(eAC, eMirror);
               eLink = EffectLinkEffects(eLink, eVis);
               eLink = EffectLinkEffects(eMageArmorDodgeAc, eLink);

               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
            }
            //case 71:  // GREATER_SHADOW_CONJURATION - Clarity and Mirror Image
            // eClarity = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
            // eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
            // eLink = EffectLinkEffects(eMirror, eMind);
            // ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink,oTarget, RoundsToSeconds(nDuration));
            if (nSpellID == SPELL_SHADES_STONESKIN) // SHADES - Stoneskin and Mirror Image
            {
               RemoveEffectsFromSpell(oTarget, SPELL_STONESKIN);
               eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
               nPower = DAMAGE_POWER_PLUS_FIVE;
               if (nPureBonus==8) nPower = DAMAGE_POWER_PLUS_SIX;
               eStone = EffectDamageReduction(10+nPureBonus, nPower, nDuration * 10);
               eLink = EffectLinkEffects(eStone, eMirror);
               eLink = EffectLinkEffects(eLink, eVis);
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
            }

/*      case 2:
         if (!ResistSpell(OBJECT_SELF, oTarget))
         {
            int nDice = 2;                // SHADOW_CONJURATION
            if (nSpellID== 71) nDice = 3; // GREATER_SHADOW_CONJURATION
            if (nSpellID==158) nDice = 4; // SHADES
            int nDamage;
            int nBolts = nPureLevel/5;
            int nCnt;
            effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
            for (nCnt = 0; nCnt < nBolts; nCnt++)
            {
               int nDam = d6(nDice);
               //Enter Metamagic conditions
               if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nDice; //Damage is at max
               if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += nDamage/2; //Damage is +50%
               if (ReflexSave(oTarget, nPureDC)) nDamage = nDamage/2;
               if (BlockNegativeDamage(oTarget)) nDamage = 0;
               effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            }

         }
*/
/*      case 3:
         int nWiz = GetLevelByClass(CLASS_TYPE_WIZARD, OBJECT_SELF);
         switch (nSpellID)
         {
            case 159: // SHADOW_CONJURATION
               if ((nWiz > 9) && GetHasSpellSchool(OBJECT_SELF, SPELL_SCHOOL_ILLUSION)) sResRef = "sbio_shadow2";
               else sResRef = "sbio_shadow2";
            case 71:  // GREATER_SHADOW_CONJURATION
               if ((nWiz > 19) && GetHasSpellSchool(OBJECT_SELF, SPELL_SCHOOL_ILLUSION))sResRef = "sbio_shadfiend2";
               else sResRef = "sbio_shadassa";
            case 158: // SHADES
               if ((nWiz > 29) && GetHasSpellSchool(OBJECT_SELF, SPELL_SCHOOL_ILLUSION))sResRef = "sbio_shadlord2";
               else sResRef = "sbio_shadlord2";
         }
         eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
         effect eSummon = EffectSummonCreature(sResRef);
         ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
         */
   }
}
