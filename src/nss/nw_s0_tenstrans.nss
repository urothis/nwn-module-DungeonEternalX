///////////////////////////////////////////////////////////////////////////
//
// DeX Spell Change: Tensers Transformation (Tensers Transonic Wave)
//
// The caster amplitudes subsonic waves around him and cause damage to all
// creatures and weapons around him.
//
// All Enemies receive penalties to Attack, Damage and Will saving throws.
// All creatures close to caster take sonic damage and are deafened.
// In addition, they must make a reflex save or be confused.
// Allready deafened creatures before this spell
// are immune to the damage and confusion effect.
//
///////////////////////////////////////////////////////////////////////////

#include "inc_draw"
#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    object oCaster   = OBJECT_SELF;
    location lCaster = GetLocation(oCaster);
    int nCasterLvl   = nPureLevel;

    float fRadius  = 8.0 + IntToFloat(nPureBonus)*1.5; // First effects Radius (Penalties)
    float fRadius2 = 6.0; // Second effects Radius (Damage, Deaf, Confusion)
    int nDur1 = 2 + nPureBonus; // First effects Duration
    int nDur2 = 1 + nPureBonus/8; // Secound effects Duration
    int nDecrease = 1 + nPureBonus/8; // Amount of penalty recieved by first effects. (Damage decrease is doubled)

    int nDamage;
    float fDelay;
    effect eDam2;
    effect eLink2;
    effect eVis;
    effect eVis1 = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    effect eVis2 = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eVis3 = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDeaf = EffectDeaf();
    effect eConf = EffectConfused();

    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDur1 = nDur1*2;
        nDur2 = nDur2*2;
    }
    // Special visual effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, OBJECT_SELF);
    DrawCircle(1, VFX_IMP_SONIC, lCaster, fRadius/3, 1.0, 5, 1.0, 0.5, 0.0, "z");
    DelayCommand(0.1, DrawCircle(1, VFX_IMP_SONIC, lCaster, fRadius/2, 1.0, 5+FloatToInt(fRadius/10), 1.0, 0.5, 0.0, "z"));
    DelayCommand(0.2, DrawCircle(1, VFX_IMP_SONIC, lCaster, fRadius/1.5, 1.0, 5+FloatToInt(fRadius/5), 1.0, 0.5, 0.0, "z"));
    DelayCommand(0.3, DrawCircle(1, VFX_IMP_SONIC, lCaster, fRadius, 1.0, 5+FloatToInt(fRadius), 1.0, 0.5, 0.0, "z"));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lCaster, TRUE);

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget != oCaster)
        {
            fDelay = GetDistanceBetweenLocations(lCaster, GetLocation(oTarget))/20;
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_TENSERS_TRANSFORMATION));
            if (!MyResistSpell(oCaster, oTarget, fDelay))
            {
                if (GetIsEnemy(oTarget))
                {
                    effect eDam1  = EffectSavingThrowDecrease(SAVING_THROW_WILL, nDecrease);
                    effect eLink1 = EffectLinkEffects(eDam1, EffectAttackDecrease(nDecrease));
                    eLink1 = EffectLinkEffects(eLink1, EffectDamageDecrease(nDecrease*2, DAMAGE_TYPE_PIERCING));
                    eLink1 = EffectLinkEffects(eLink1, EffectDamageDecrease(nDecrease*2, DAMAGE_TYPE_SLASHING));
                    eLink1 = EffectLinkEffects(eLink1, EffectDamageDecrease(nDecrease*2, DAMAGE_TYPE_BLUDGEONING));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, RoundsToSeconds(nDur1)));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
                }
                if (!GetHasEffect(EFFECT_TYPE_DEAF, oTarget) && GetDistanceBetween(oCaster, oTarget) <= fRadius2)
                {
                    nDamage = d6(nCasterLvl/3);
                    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLvl/3;
                    else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += nDamage/3;

                    eLink2 = eDeaf; //Link Effects
                    if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_TYPE_SONIC, OBJECT_SELF, fDelay))
                    {  // Add more effects to Link2 if Will save failed.
                        eLink2 = EffectLinkEffects(eLink2, eConf);
                        eLink2 = EffectLinkEffects(eLink2, eMind);
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                    }
                    eDam2 = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDur2)));
                    eLink2 = eDeaf; // Reset eLink2
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lCaster);
    }
}
