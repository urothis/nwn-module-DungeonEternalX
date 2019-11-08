//::///////////////////////////////////////////////
//:: Polymorph Self
//:: NW_S0_PolySelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The PC is able to changed their form to one of
   several forms.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"
#include "arres_inc"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nSpell     = GetSpellId();
   int nDuration  = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   int nPoly;

   if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2; //Duration is +100%

   // POLYMORPH SELF
   if      (nSpell == 387) nPoly = POLYMORPH_TYPE_GIANT_SPIDER;
   else if (nSpell == 388) nPoly = POLYMORPH_TYPE_TROLL;
   else if (nSpell == 389) nPoly = POLYMORPH_TYPE_UMBER_HULK;
   else if (nSpell == 390) nPoly = POLYMORPH_TYPE_PIXIE;
   else if (nSpell == 391) nPoly = POLYMORPH_TYPE_ZOMBIE;
   // SHAPECHANGE
   else if (nSpell == 392) nPoly = POLYMORPH_TYPE_RED_DRAGON;
   else if (nSpell == 393) nPoly = POLYMORPH_TYPE_FIRE_GIANT;
   else if (nSpell == 394) nPoly = POLYMORPH_TYPE_BALOR;
   else if (nSpell == 395) nPoly = POLYMORPH_TYPE_DEATH_SLAAD;
   else if (nSpell == 396) nPoly = POLYMORPH_TYPE_IRON_GOLEM;

   int bDoMerge = (nPureBonus >= 4);
   PolyWithMerge(OBJECT_SELF, nPoly, TurnsToSeconds(nDuration), bDoMerge);
}

