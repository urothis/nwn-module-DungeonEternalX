            //::///////////////////////////////////////////////
//:: Contagion
//:: NW_S0_Contagion.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The target must save or be struck down with
   Blidning Sickness, Cackle Fever, Filth Fever
   Mind Fire, Red Ache, the Shakes or Slimy Doom.
*/

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   if (GetSpellId() == SPELLABILITY_BG_CONTAGION)
   {
        ExecuteScript("ez_bgcontagion", OBJECT_SELF);
        return;
   }

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   if (GetIsReactionTypeFriendly(oTarget)) return;
   if (MyResistSpell(OBJECT_SELF, oTarget)) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);

   int nRand = d6()+nPureBonus; // d6()+(1,2,3,4,6,8) = 14
   int nDisease;
   string sDisease;
   //Use a random seed to determine the disease that will be delivered.
        if (nRand==1)  { nDisease = DISEASE_FILTH_FEVER;        sDisease = "Filth Fever"; }
   else if (nRand==2)  { nDisease = DISEASE_MINDFIRE;           sDisease = "Mindfire"; }
   else if (nRand==3)  { nDisease = DISEASE_SHAKES;             sDisease = "Shakes"; }
   else if (nRand==4)  { nDisease = DISEASE_SLIMY_DOOM;         sDisease = "Slimy Doom"; }
   else if (nRand==5)  { nDisease = DISEASE_RED_ACHE;           sDisease = "Red Ache"; }
   else if (nRand==6)  { nDisease = DISEASE_ZOMBIE_CREEP;       sDisease = "Zombie Creep"; }
   // PURE BONUSES
   else if (nRand==7)  { nDisease = DISEASE_BLINDING_SICKNESS;  sDisease = "Blinding Sickness"; }
   else if (nRand==8)  { nDisease = DISEASE_CACKLE_FEVER;       sDisease = "Cackle Fever"; }
   else if (nRand==9)  { nDisease = DISEASE_RED_SLAAD_EGGS;     sDisease = "Red Slaad Eggs"; }
   else if (nRand==10) { nDisease = DISEASE_BURROW_MAGGOTS;     sDisease = "Burrow Maggots"; }
   else if (nRand==11) { nDisease = DISEASE_GHOUL_ROT;          sDisease = "Ghoul Rot"; }
   else if (nRand==12) { nDisease = DISEASE_DEMON_FEVER;        sDisease = "Demon Fever"; }
   else if (nRand==13) { nDisease = DISEASE_MUMMY_ROT;          sDisease = "Mummy Rot"; }
   else if (nRand==14) { nDisease = DISEASE_SOLDIER_SHAKES;     sDisease = "Soldier Shakes"; }

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTAGION));
   effect eDisease = EffectDisease(nDisease);
   //Make SR check
   //The effect is permament because the disease subsystem has its own internal resolution system in place.
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
   SendMessageToPC(OBJECT_SELF, "Infected " + GetName(oTarget) + " with " + sDisease);
   FloatingTextStringOnCreature("Infected with " + sDisease + "!", oTarget, TRUE);
}

