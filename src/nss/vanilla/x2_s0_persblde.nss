//::///////////////////////////////////////////////
//:: Shelgarn's Persistent Blade
//:: X2_S0_PersBlde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Summons a dagger to battle for the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 26, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, Aug 2003

#include "x2_i0_spells"
#include "pure_caster_inc"
#include "pc_inc"

//Creates the weapon that the creature will be using.
void spellsCreateItemForSummoned(object oCaster, float fDuration, int nPureBonus) {
   //Declare major variables
   int nStat = GetMin(20, GetMax(1, GetCasterModifier(oCaster) / 2) + nPureBonus);
   object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
   object oWeapon;
   if (GetIsObjectValid(oSummon)) {
      //Create item on the creature, epuip it and add properties.
      oWeapon = CreateItemOnObject("NW_WSWDG001", oSummon);
      // GZ: Fix for weapon being dropped when killed
      SetDroppableFlag(oWeapon, FALSE);
      AssignCommand(oSummon, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
      // GZ: Check to prevent invalid item properties from being applies
      if (nStat) {
         AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(nStat), oWeapon, fDuration);
         if      (nPureBonus==1) nPureBonus = DAMAGE_BONUS_1d4;
         else if (nPureBonus==2) nPureBonus = DAMAGE_BONUS_1d6;
         else if (nPureBonus==3) nPureBonus = DAMAGE_BONUS_1d8;
         else if (nPureBonus==4) nPureBonus = DAMAGE_BONUS_1d10;
         else if (nPureBonus==5) nPureBonus = DAMAGE_BONUS_2d6;
         else if (nPureBonus==6) nPureBonus = DAMAGE_BONUS_2d8;
         else if (nPureBonus==7) nPureBonus = DAMAGE_BONUS_2d10;
         else if (nPureBonus==8) nPureBonus = DAMAGE_BONUS_2d12;
         if (nPureBonus) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, nPureBonus), oWeapon, fDuration);
      }
      AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, 5), oWeapon, fDuration);
   }
}

#include "x2_inc_spellhook"

void main() {
    if (!X2PreSpellCastCode()) return;

    location lTarget = GetSpellTargetLocation();
    object oItem = GetSpellCastItem();
    effect eSummon;
    int nDuration = 15;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

    if (GetIsObjectValid(oItem))
    {
        object oPC = GetItemPossessor(oItem);
        string sTag = GetTag(oItem);
        if (sTag == "HASHISHS_BGOLEM")
        {
            if (pcGetRealLevel(oPC) > 36)
            {
                object oGolem = CreateObject(OBJECT_TYPE_CREATURE, "NW_SKELDEVOUR", lTarget);
                SetPlotFlag(oGolem, TRUE);
                AssignCommand(oGolem, ActionAttack(oPC));
                DelayCommand(0.1, SetCommandable(FALSE, oGolem));
                DelayCommand(0.1, SetCommandable(FALSE, oPC));
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), lTarget);
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 6.0));
                DelayCommand(3.0, SpeakString("Frederick...!"));
                DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oGolem)));
                DelayCommand(3.5, DestroyObject(oGolem));
                DelayCommand(6.0, FloatingTextStringOnCreature("It seems the golem doesn't like high level masters", oPC, FALSE));
                DelayCommand(6.0, SetCommandable(TRUE, oPC));
                return;
            }
            eSummon = EffectSummonCreature("hashish_bgolem", VFX_FNF_SUMMON_MONSTER_3, 1.0);
        }
        else if (sTag == "DDAMMY")
        {
            eSummon = EffectSummonCreature("barakor", VFX_FNF_SUMMON_MONSTER_3, 1.0);
        }
    }
    else
    {
         int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
         int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
         int nPureDC    = GetSpellSaveDC() + nPureBonus;

         //Declare major variables
         int nMetaMagic = GetMetaMagicFeat();
         nDuration = GetMin(1, nPureLevel/2);
         eSummon = EffectSummonCreature("X2_S_FAERIE001");
         //Make metamagic check for extend
         if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
         //Apply the VFX impact and summon effect
         object oSelf = OBJECT_SELF;
         DelayCommand(1.0, spellsCreateItemForSummoned(oSelf, TurnsToSeconds(nDuration), nPureBonus));
    }
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, TurnsToSeconds(nDuration));
}

