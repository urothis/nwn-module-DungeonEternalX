//::///////////////////////////////////////////////
//:: Ghoul Touch
//:: NW_S0_GhoulTch.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The caster attempts a touch attack on a target
   creature.  If successful creature must save
   or be paralyzed. Target exudes a stench that
   causes all enemies to save or be stricken with
   -2 Attack, Damage, Saves and Skill Checks for
   1d6+2 rounds.
*/

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    object oTarget = GetSpellTargetObject();
    if (GetIsReactionTypeFriendly(oTarget)) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGGHOUL);
    effect eParal = EffectParalyze();
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);

    effect eLink = EffectLinkEffects(eDur2, eParal);

    int nDuration = 1 + nPureLevel/10 + nPureBonus;
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDuration = 5 + nPureBonus;
    else if (nMetaMagic == METAMAGIC_EMPOWER) nDuration += (nDuration/2); //Damage/Healing is +50%
    else if(nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOUL_TOUCH));
    //Make a touch attack to afflict target

    // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
    if (TouchAttackMelee(oTarget,GetSpellCastItem() == OBJECT_INVALID)>0)
    {
        //SR and Saves
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_NEGATIVE))
            {
                //Create an instance of the AOE Object using the Apply Effect function
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(oTarget), RoundsToSeconds(nDuration));
            }
        }
    }

}

