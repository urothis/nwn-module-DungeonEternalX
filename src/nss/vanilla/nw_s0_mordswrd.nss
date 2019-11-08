//::///////////////////////////////////////////////
//:: Mordenkainen's Sword
//:: NW_S0_MordSwrd.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Summons a Helmed Horror to battle for the caster
*/
#include "x2_i0_spells"
#include "pure_caster_inc"
#include "nwnx_creature"
#include "inc_summons"

void ApplyHaste(object oPC)
{
    object oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectHaste()), oSum);
}

//Pick the sword that helmed horror is equipped with.
void PickSword (object oCaster, float fDuration, int nClass)
{
    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);  //Calculate pure bonus
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
    object oWeapon;
    string sResRef;

    //specific function to decide sword
    if (GetIsObjectValid(oSummon))
    {
      if      (nPureBonus  == 1) sResRef = "mordenkainang001";
      else if (nPureBonus  == 2) sResRef = "mordenkainang002";
      else if (nPureBonus  == 3) sResRef = "mordenkainang002";
      else if (nPureBonus  == 4) sResRef = "mordenkainang003";
      else if (nPureBonus  == 5) sResRef = "mordenkainang003";
      else if (nPureBonus  == 6) sResRef = "mordenkainang004";
      else if (nPureBonus  == 7) sResRef = "mordenkainang004";
      else if ((nPureBonus == 8)) sResRef = "mordenkainanguar";
    }

    oWeapon = CreateItemOnObject(sResRef, oSummon);
    SetDroppableFlag(oWeapon, FALSE);
    AssignCommand(oSummon, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));

    //Applies damage bonus
    if      (nPureBonus==1) nPureBonus = DAMAGE_BONUS_1;
    else if (nPureBonus==2) nPureBonus = DAMAGE_BONUS_2;
    else if (nPureBonus==3) nPureBonus = DAMAGE_BONUS_3;
    else if (nPureBonus==4) nPureBonus = DAMAGE_BONUS_4;
    else if (nPureBonus==5) nPureBonus = DAMAGE_BONUS_5;
    else if (nPureBonus==6) nPureBonus = DAMAGE_BONUS_6;
    else if (nPureBonus==7) nPureBonus = DAMAGE_BONUS_7;
    else if (nPureBonus==8) nPureBonus = DAMAGE_BONUS_8;


    if (nPureBonus)  //Wizard
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, nPureBonus), oWeapon);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, nPureBonus), oWeapon);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oWeapon);

        SetSummonBaseAttackBonus(oSummon, GetSummonBaseAttackBonus(oCaster, CLASS_TYPE_WIZARD, SPELL_SCHOOL_TRANSMUTATION, 7, TRUE));
        SetSummonBaseAC(oSummon, GetSummonBaseAC(oCaster, oSummon, nClass, SPELL_SCHOOL_TRANSMUTATION, TRUE));
    }
    else if (nClass == CLASS_TYPE_SORCERER)
    {
        SetSummonBaseAttackBonus(oSummon, GetSummonBaseAttackBonus(oCaster, nClass, SPELL_SCHOOL_TRANSMUTATION, 7, TRUE, FALSE, TRUE));
        SetSummonBaseAC(oSummon, GetSummonBaseAC(oCaster, oSummon, nClass, SPELL_SCHOOL_TRANSMUTATION, TRUE));
    }
}

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nCastingClass = GetLastSpellCastClass();

   if (nCastingClass == CLASS_TYPE_INVALID)
       return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = nPureLevel + nPureDC;
   effect eSummon = EffectSummonCreature("mordsword");
   effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
   //Make metamagic check for extend
   if (nMetaMagic==METAMAGIC_EXTEND) nDuration *= 2;    //Doubles the duration

   //Apply the VFX impact and summon effect
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));
   object oSelf = OBJECT_SELF;
   DelayCommand(1.0, PickSword(oSelf, TurnsToSeconds(nDuration), nCastingClass));
}
