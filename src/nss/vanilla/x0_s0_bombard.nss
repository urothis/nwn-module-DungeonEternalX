//::///////////////////////////////////////////////
//:: Bombardment
//:: X0_S0_Bombard
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Rocks fall from sky
// 1d8 damage/level to a max of 10d8
// Reflex save for half
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void AttackMordSword()
{
}

void GnollBossBombardement()
{
    int nDamage;
    float fDelay;
    effect eFX1 = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
    effect eFX2 = EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM);
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eDam;
    location lTarget = GetSpellTargetLocation();
    int nSpellID = GetSpellId();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFX1, lTarget);
    DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFX2, lTarget));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));

            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/10;
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                nDamage = d12(6);
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                eDam = EffectDamage(nDamage/2, DAMAGE_TYPE_BLUDGEONING);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    int nType = SPELL_TARGET_STANDARDHOSTILE;
    if (GetTag(OBJECT_SELF) == "BOSS_GNOLL")
    {
        nType = SPELL_TARGET_SELECTIVEHOSTILE;
        if (d3() != 1)
        {
            GnollBossBombardement();
            return;
        }
    }

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    if (nPureLevel > 10 + nPureBonus) nPureLevel = 10 + nPureBonus;

    object oCaster = OBJECT_SELF;
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    location lTarget = GetSpellTargetLocation();
    int nSpellID = GetSpellId();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, nType, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));

            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                nDamage = d8(nPureLevel);
                if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 8 * nPureLevel;//Damage is at max
                if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_ALL);

                if (nDamage > 0)
                {
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}



