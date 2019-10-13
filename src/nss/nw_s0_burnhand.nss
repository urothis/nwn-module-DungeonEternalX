//::///////////////////////////////////////////////
//:: Burning Hands
//:: NW_S0_BurnHand
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A thin sheet of searing flame shoots from your
// outspread fingertips. You must hold your hands
// with your thumbs touching and your fingers spread
// The sheet of flame is about as thick as your thumbs.
// Any creature in the area of the flames suffers
// 1d4 points of fire damage per your caster level
// (maximum 5d4).
*/

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
    int nPureDC   = GetSpellSaveDC() + nPureBonus;

    //Declare major variables
    float fDist;
    int nCasterLevel = nPureLevel;
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    object oTarget;
    effect eFire;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    //Limit Maximum caster level to keep damage to spell specifications.
    if (nCasterLevel > 5 + nPureBonus) nCasterLevel = 5 + nPureBonus;

    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BURNING_HANDS));
            fDist = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                if (oTarget != OBJECT_SELF)
                {
                    nDamage = d4(nCasterLevel);
                    //Enter Metamagic conditions
                    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 4 * nCasterLevel;//Damage is at max
                    if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%
                    //Run the damage through the various reflex save and evasion feats
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE);
                    if (nDamage > 0)
                    {
                        eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                        // Apply effects to the currently selected target.
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
