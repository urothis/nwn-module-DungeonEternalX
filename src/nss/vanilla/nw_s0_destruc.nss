//::///////////////////////////////////////////////
//:: Destruction
//:: NW_S0_Destruc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target creature is destroyed if it fails a
    Fort save, otherwise it takes 10d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pure_caster_inc"

void main()
{
    if (!X2PreSpellCastCode()) return;


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDeath = EffectDeath();
    effect eDam;
    effect eVis = EffectVisualEffect(234);

    int nSpamLimit = 2;
    if (GetHasFeat(FEAT_EVIL_DOMAIN_POWER)) nSpamLimit += 1;
    if (GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER)) nSpamLimit += 1;
    if (GetHasFeat(FEAT_DEATH_DOMAIN_POWER)) nSpamLimit += 1;

    int nDoDeath = CheckDeathSpam(OBJECT_SELF, oTarget, nSpamLimit);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DESTRUCTION));
        //Make SR check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Make a saving throw check
            if (nDoDeath && !MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
                //Apply the VFX impact and effects
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
            }
            else
            {
                nDamage = d6(10);
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 60;//Damage is at max
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            }
            //Apply VFX impact
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}
