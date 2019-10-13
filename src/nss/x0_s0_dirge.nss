//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    if (!X2PreSpellCastCode()) return;


    object oPC = OBJECT_SELF;
    int nDur   = GetCasterLevel(oPC);

    effect eNegVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);
    effect eCurse  = EffectCurse(2, 2, 0, 0, 0, 0);
    eCurse = SupernaturalEffect(eCurse);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC));
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) && oTarget != oPC)
        {
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_DIRGE));
            if(!GetHasSpellEffect(SPELL_DIRGE, oTarget))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eNegVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurse, oTarget, RoundsToSeconds(nDur));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC));
    }


/*
    //Declare major variables including Area of Effect Object
    //change from AOE_PER_FOGMIND to AOE_MOB_CIRCGOOD
    effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD, "x0_s0_dirgeEN", "x0_s0_dirgeHB", "x0_s0_dirgeEX");
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    effect eImpact = EffectVisualEffect(257);
    effect eCaster = EffectVisualEffect(VFX_DUR_BARD_SONG);

    effect eFNF = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    //Apply the FNF to the spell location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF, GetLocation(OBJECT_SELF));


    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(OBJECT_SELF));
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, RoundsToSeconds(nDuration));
*/
}
