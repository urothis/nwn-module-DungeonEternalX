//::///////////////////////////////////////////////
//:: Bigby's Clenched Fist
//:: [x0_s0_bigby4]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_i0_spells"
#include "pure_caster_inc"

int nSpellID = 462;

void RunHandImpact(object oTarget, object oCaster, int nMeta, int nPureBonus) {
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)) return;

       //int nDam  = MaximizeOrEmpower(4, 4+nPureBonus, nMeta, 12);
       int nDam = d8(2)+20;
       effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
       effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
       int nCasterRoll = GetMin(20, d20()+nPureBonus);
       int nCasterLvl = GetCasterLevel(OBJECT_SELF);
       int nBaseDC = GetCasterAbilityModifier(OBJECT_SELF)-7;
       if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION)) nBaseDC += 6;
       else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION)) nBaseDC += 4;
       else if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION))  nBaseDC += 2;
       int nFinalDC = nCasterRoll + nCasterLvl + nBaseDC;

       int nTargetRanks = GetSkillRank(SKILL_DISCIPLINE,oTarget);
       int nTargetRoll = d20();
       int nTargetD = 0;
       if (GetHasFeat(FEAT_ARCANE_DEFENSE_EVOCATION,oTarget)) nTargetD = 2;
       int nFinalRoll = nTargetRanks + nTargetRoll + nTargetD;

       string sMessage = "";
       // * bullrush succesful, knockdown target for duration of spell
       sMessage = IntToString(nTargetRoll) + " + " + IntToString(nTargetRanks) + " + " + IntToString(nTargetD) + " = " + IntToString(nFinalRoll)
                  + " vs DC " + IntToString(nFinalDC);


       if ((nFinalDC >= nFinalRoll || nTargetRoll == 1) && nTargetRoll != 20) {
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(1));
           sMessage = "Stun Success! " + sMessage;
       }
       else {
           sMessage = "Stun Failed. " + sMessage;
       }

       if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)) {
            SendMessageToPC(OBJECT_SELF, sMessage);
            SendMessageToPC(oTarget, sMessage);
       }
       DelayCommand(6.0, RunHandImpact(oTarget, oCaster, nMeta, nPureBonus));
}

void RunNibelungenFist(object oTarget, object oItemUser, int nDC)
{
    if (GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oItemUser)) return;

    int nTargetRanks  = GetSkillRank(SKILL_DISCIPLINE, oTarget) - GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    int nTargetRoll = d20();

    string sMessage = "Discipline check: " + IntToString(nTargetRanks) + " + " +
                      IntToString(nTargetRoll) + " = " + IntToString(nTargetRanks+nTargetRoll) +
                      " vs. DC " + IntToString(nDC);

    if (nDC > nTargetRanks + nTargetRoll)
    {
        effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
        effect eKnockdown = EffectCutsceneParalyze();
        effect eKnockdown2 = EffectKnockdown();
        effect eLink = EffectLinkEffects(eKnockdown, eKnockdown2);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(1));
        sMessage += ": failure";
    }
    else sMessage += ": success";
    SendMessageToPC(oItemUser, sMessage);
    SendMessageToPC(oTarget, sMessage);
    DelayCommand(6.0, RunNibelungenFist(oTarget, oItemUser, nDC));
}


#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

    int nPureBonus  = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
    int nPureLevel  = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
    int nPureDC     = GetSpellSaveDC() + nPureBonus;

    int nNibelungen = FALSE;;
    int nDuration   = 5;
    int nMetaMagic  = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
    object oTarget  = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(463,oTarget))
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }
    //--------------------------------------------------------------------------
    // Fist of Nibelungen
    //--------------------------------------------------------------------------
    object oItem   = GetSpellCastItem();
    object oItemUser;
    if (GetIsObjectValid(oItem) && GetTag(oItem) == "FIST_OF_NIBELUNGEN")
    {

        nNibelungen = TRUE;
        oItemUser = GetItemPossessor(oItem);
    }

    //--------------------------------------------------------------------------

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, TRUE));

        effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST);

        if(!MyResistSpell(OBJECT_SELF, oTarget) && !nNibelungen)
        {
            int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            int nCasterRoll = d20();
            int nTargetRoll = GetAC(oTarget);
            string sMessage = IntToString(nCasterRoll) + " + " +
                              IntToString(nCasterModifier) + " + " +
                              IntToString(nPureLevel) + " = " +
                              IntToString(nCasterRoll + nCasterModifier + nPureLevel) + " vs AC " +
                              IntToString(nTargetRoll);
            if ((nCasterRoll + nCasterModifier + nPureLevel >= nTargetRoll || nCasterRoll == 20) && nCasterRoll != 1)
            {
                sMessage += " HIT";
                SendMessageToPC(OBJECT_SELF, sMessage);
                SendMessageToPC(oTarget, sMessage);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHand, oTarget, RoundsToSeconds(nDuration));
                //----------------------------------------------------------
                // GZ: 2003-Oct-15
                // Save the current save DC on the character because
                // GetSpellSaveDC won't work when delayed
                //----------------------------------------------------------
                SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID), GetCasterAbilityModifier(OBJECT_SELF)+9);
                RunHandImpact(oTarget, OBJECT_SELF, nMetaMagic, nPureBonus);
            }
            else
            {
                sMessage += " MISS";
                SendMessageToPC(OBJECT_SELF, sMessage);
                SendMessageToPC(oTarget, sMessage);
            }
        }
        else if (nNibelungen)
        {
            int nSTR = GetAbilityScore(oItemUser, ABILITY_STRENGTH);
            int nTargetMonk = GetLevelByClass(CLASS_TYPE_MONK, oTarget);
            int nCasterMonk = GetLevelByClass(CLASS_TYPE_MONK, oItemUser);
            int nMonkDifference = nTargetMonk - nCasterMonk;
            if (nMonkDifference < 3)
            {
                FloatingTextStringOnCreature("Works only against faster creatures", oItemUser);
                return;
            }
            int nDC = nSTR + nMonkDifference;
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHand, oTarget, RoundsToSeconds(nDuration));
            SetLocalInt(oTarget, "XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID), nDC);
            RunNibelungenFist(oTarget, oItemUser, nDC);
        }
    }
}

