//::///////////////////////////////////////////////
//:: Planar Ally
//:: X0_S0_Planar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an outsider dependant on alignment, or
    holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Modified from Planar binding
//:: Hold ability removed for cleric version of spell

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pc_inc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    location lTarget = GetSpellTargetLocation();
    object oItem = GetSpellCastItem();
    effect eSummon;
    int nDuration = 15;
    if (GetIsObjectValid(oItem) && GetResRef(oItem) == "item_summon_ally")
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
    }
    else
    {
        int nMetaMagic = GetMetaMagicFeat();
        int nCasterLevel = GetCasterLevel(OBJECT_SELF);
        int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);

        nDuration = GetCasterLevel(OBJECT_SELF);
        if (nDuration == 0) nDuration == 1;

        if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;

        switch (nAlign)
        {
            case ALIGNMENT_EVIL:
                eSummon = EffectSummonCreature("NW_S_SUCCUBUS",VFX_FNF_SUMMON_GATE, 3.0);
            break;
            case ALIGNMENT_GOOD:
                eSummon = EffectSummonCreature("NW_S_CHOUND", VFX_FNF_SUMMON_CELESTIAL, 3.0);
            break;
            case ALIGNMENT_NEUTRAL:
                eSummon = EffectSummonCreature("NW_S_SLAADGRN",VFX_FNF_SUMMON_MONSTER_3, 1.0);
            break;
        }
    }
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, HoursToSeconds(nDuration));
}

