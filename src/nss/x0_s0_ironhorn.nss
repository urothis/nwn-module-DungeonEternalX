//::///////////////////////////////////////////////
//::
//:: Balagarn's Iron Horn
//::
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   object oCaster   = OBJECT_SELF;
   int nPureBonus   = GetPureCasterBonus(oCaster, SPELL_SCHOOL_ENCHANTMENT);
   int nMetaMagic   = GetMetaMagicFeat();
   effect eExplode  = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
   effect eVis      = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
   effect eShake    = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);
   location lTarget = GetSpellTargetLocation();
   float nSize      = RADIUS_SIZE_COLOSSAL;
   float fDelay;

   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oCaster, RoundsToSeconds(d3()));
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, GetLocation(oCaster));

   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) && (oTarget != oCaster))
      {
         SignalEvent(oTarget, EventSpellCastAt(oCaster, 436));
         fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) / 20;
         if (!MyResistSpell(oCaster, oTarget, fDelay))
         {
            effect eTrip       = EffectKnockdown();
            int nCasterRoll    = d20()+nPureBonus/2;
            if (nCasterRoll > 20) nCasterRoll = 20;
            int nCasterSTR     = 20;
            int nTargetRoll    = d20();
            int nTargetSTR     = GetAbilityScore(oTarget, ABILITY_STRENGTH);
            int nTargetDEX     = GetAbilityScore(oTarget, ABILITY_DEXTERITY);

            if (!GetHasFeat(FEAT_MONK_ENDURANCE, oTarget) && GetLevelByClass(CLASS_TYPE_PALEMASTER, oTarget) < 10)
            {
                if (GetHasFeat(FEAT_WEAPON_FINESSE, oTarget))
                {
                    if (nTargetDEX > nTargetSTR) nTargetSTR = nTargetDEX;
                }
            }

            string sMessage = IntToString(nTargetSTR) + " + " + IntToString(nTargetRoll) + " = " + IntToString(nTargetRoll + nTargetSTR)
                              + " vs " + IntToString(nCasterSTR) + " + " + IntToString(nCasterRoll) + " = " + IntToString(nCasterRoll + nCasterSTR);
            if (nTargetRoll + nTargetSTR <= nCasterRoll + nCasterSTR)
            {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oTarget, 6.0));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
               sMessage = "Horn Success! " + sMessage;
            } else sMessage = "Horn Failed. " + sMessage;

            SendMessageToPC(oCaster, sMessage);
            SendMessageToPC(oTarget, sMessage);
         }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
   }
}
