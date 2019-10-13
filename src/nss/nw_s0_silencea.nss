//::///////////////////////////////////////////////
//:: Silence: On Enter
//:: NW_S0_SilenceA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
    Modified By: Rabidness
    Modified On: August 05, 2004
        - It's an area of silence, so you should auto succeed move silently checks.
            +50 to Move Silently
        - If the target already has the effect, then do not give them another.
            This is to prevent incorrect loss of effects.
            An example: Mage A and Mage B, both have this AoE on them.
                Mage B enters Mage A's AoE, so normally it would give him Mage A's
                AoE effects, even if Mage B already had said effects.
                This is fine, but when Mage B leaves Mage A's AoE, the effects
                will be dispelled and will be kept off untill their AoE refreshes...
                when clearly Mage B has his own AoE of the same type.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{

    //Declare major variables including Area of Effect Object
    effect eDur1       = EffectVisualEffect(VFX_IMP_SILENCE);
    effect eSilence    = EffectSilence();
    //Move silently +50
    effect eMoveSilent = EffectSkillIncrease( SKILL_MOVE_SILENTLY , 50 );
    effect eImmune     = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);

    //Link the effects
    effect eLink = EffectLinkEffects(eImmune, eSilence);
    eLink = EffectLinkEffects(eLink, eMoveSilent);

    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
          int bHostile;
          if(!MyResistSpell(oCaster,oTarget))
          {
            //VvVvV Rabidness addition, this if block VvVvV
            //IF they are the creator of an identical effect do not give it to them,
            //this is to prevent overlapping in effects and incorrect loss of them.
            //Let the creator of THIS spell/AoE get the effect.
            if(GetHasSpellEffect(SPELL_SILENCE, oTarget) && (GetLocalInt(oTarget, "nSilenceSource" )!= 1))
            {
                return;
            }
            bHostile = GetIsEnemy(oTarget);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE,bHostile));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
          }
     }

}
