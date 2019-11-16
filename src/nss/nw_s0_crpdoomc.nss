//::///////////////////////////////////////////////
//:: Creeping Doom: Heartbeat
//:: NW_S0_CrpDoomC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creature caught in the swarm take an initial
   damage of 1d20, but there after they take
   1d6 per swarm counter on the AOE.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "pure_caster_inc"

void main() {
   object oCaster = GetAreaOfEffectCreator();
   if (!GetIsObjectValid(oCaster)) { // CASTER GONE, KILL AOE
      DestroyObject(OBJECT_SELF);
      return;
   }

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nDamage;
   effect eDam;
   effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
   object oTarget = GetEnteringObject();
   string sConstant1 = "NW_SPELL_CONSTANT_CREEPING_DOOM1" + ObjectToString(oCaster);
   string sConstant2 = "NW_SPELL_CONSTANT_CREEPING_DOOM2" + ObjectToString(oCaster);

   int nDamCount = GetLocalInt(OBJECT_SELF, sConstant2);
   int nSwarm = GetLocalInt(OBJECT_SELF, sConstant1);
   if (nSwarm < 1) nSwarm = nPureBonus + 1;
   float fDelay;

   int nDamMax = 1000 + 50 * nPureBonus;

   //Get first target in spell area
   oTarget = GetFirstInPersistentObject();
   while(GetIsObjectValid(oTarget) && nDamCount < nDamMax) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
         fDelay = GetRandomDelay(1.0, 2.2);
         SignalEvent(oTarget,EventSpellCastAt(oCaster, SPELL_CREEPING_DOOM));
        //Spell resistance check
        if (!MyResistSpell(oCaster, oTarget))
        {
            nDamage = d6(nSwarm);
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
            //Apply damage and visuals
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            nDamCount = nDamCount + nDamage;
        }
      }
      //Get next target in spell area
      oTarget = GetNextInPersistentObject();
   }
   if (nDamCount >= nDamMax) {
      DestroyObject(OBJECT_SELF, 1.0);
   } else {
      nSwarm++;
      SetLocalInt(OBJECT_SELF, sConstant1, nSwarm);
      SetLocalInt(OBJECT_SELF, sConstant2, nDamCount);
   }
}
