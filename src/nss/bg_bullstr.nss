// Buffs for Blackguard Bull strength
// Ab: +1 at lvl 3, +1 at lvl 10, +1 every 4 lvls after 10  (Max +7, +1 for fighter, +1 for epic fiend feat)
// AC: +1 ac every four ab granted. (Max +2)

#include "x2_i0_spells"

// Manages Cooldown for BG bull str
void BgBullCooldown (object oPC) {
    if (!(GetHasSpell(SPELLABILITY_BG_BULLS_STRENGTH, oPC)) && !(GetLocalInt(oPC, "BullStrReset"))) {
        IncrementRemainingFeatUses(oPC, FEAT_BULLS_STRENGTH);
    }
    SetLocalInt(OBJECT_SELF, "BullStrReset", 1);
    DelayCommand(60.0, DeleteLocalInt(oPC, "BullStrReset"));
}

void BlackGuardPulse(int nMaxAttack, object oPC, float fRadius, int nAttack) {
    if (!GetIsObjectValid(oPC)) return;

    int nAcInc = 0; // Fiendish servant ac buff

    // Epic fiendish servant feat increases BG ab by 1, +1 ac per 3 MAX ab
    if (GetHasFeat(FEAT_EPIC_EPIC_FIEND, oPC))  {
        nAttack += 1;
        nMaxAttack += 1;
        nAcInc = (nMaxAttack/4)+5;
    }

    // Duration = nMaxAttack rounds
    float fDur = IntToFloat(6*nMaxAttack);  
    float fCurrentHp, fMaxHp, fPercent;
    float fDelay = 0.2;

    effect eBeam = EffectBeam(VFX_BEAM_EVIL, oPC, BODY_NODE_CHEST);
    effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oPC));

    // Continue Loop until Max AB is reached or no Objects left.
    while(GetIsObjectValid(oTarget)) {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF)) {
            if (GetHasFeat(FEAT_EPIC_EPIC_FIEND, oPC)) {
                effect eDmg = EffectDamage(8*nMaxAttack, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            }

            // Calculate AB bonus based on enemies missing health
            fCurrentHp = IntToFloat(GetCurrentHitPoints(oTarget));
            fMaxHp = IntToFloat(GetMaxHitPoints(oTarget));
            fPercent = (fCurrentHp/fMaxHp)*100.0;
            if (fPercent < 20.0) nAttack += 1;
            if (fPercent < 60.0) nAttack += 1;
            if ((fPercent < 90.0) || (GetHasFeat(FEAT_EPIC_EPIC_FIEND, oPC))) {
                nAttack += 2;
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 2.0);
                fDelay += 0.2;
            }

            if (GetHasFeat(FEAT_EPIC_REPUTATION, oPC)) {// Epic reputation feat grants:                                                     
                nAttack += 1; //     -3 Skills, -2 Saves to Target (-1 saves self)

                effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
                effect eSkills = EffectSkillDecrease(SKILL_ALL_SKILLS, 3);
                effect eLinkEnemy = EffectLinkEffects(eSkills, eSaves); // Enemies also receive skills decrease

                eLinkEnemy = ExtraordinaryEffect(eLinkEnemy);

                effect eLoop = GetFirstEffect(oTarget);

                if (!GetLocalInt(oTarget, "BgRepPenalty")) // if Target already has this effect, don't stack it
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 2.0);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkEnemy, oTarget, fDur+24.0);
                    SetLocalInt(oTarget, "BgRepPenalty", 1);
                    DelayCommand(fDur, DeleteLocalInt(oTarget, "BgRepPenalty"));
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oPC));
    }
    if (nAttack > nMaxAttack) nAttack = nMaxAttack; // Max AB cap

    effect eAttack = EffectAttackIncrease(nAttack);
    effect eAcInc = EffectACIncrease(nAcInc, AC_ARMOUR_ENCHANTMENT_BONUS, AC_VS_DAMAGE_TYPE_ALL);
    effect eLinkSelf = EffectLinkEffects (eAttack, eAcInc);
    eAttack = ExtraordinaryEffect(eAttack);
    eAcInc = ExtraordinaryEffect(eAcInc);
    eLinkSelf = ExtraordinaryEffect(eLinkSelf);

    // Due to stacking problems, Duration has been reduced to one minute. The lines below are no longer ussed.
    if (GetLocalInt(oPC, "HasBgAb")) { // Alrdy has buff, decrease ab and increase to refresh Duration
        effect eAttDec = EffectAttackDecrease(GetLocalInt(oPC, "HasBgAb"));
        eAttDec = ExtraordinaryEffect(eAttDec);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttDec, oPC, 180.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkSelf, oPC, 180.0);
        DelayCommand(180.0, DeleteLocalInt(oPC, "HasBgAb"));
    } else {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkSelf, oPC, 180.0);
        SetLocalInt(oPC, "HasBgAb", nAttack);
        DelayCommand(180.0, DeleteLocalInt(oPC, "HasBgAb"));
    }

    // Apply save penalties for Epic Reputation
    if (GetHasFeat(FEAT_EPIC_REPUTATION, oPC)) // Self Penalty from epic reputation feat (-1 saves)
    {
        effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);

        eSaves = ExtraordinaryEffect(eSaves);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSaves, oPC, fDur+24.0);
    }

    // Display AB bonus
    if (nAttack > 1) FloatingTextStringOnCreature("Blackguard " + IntToString(nAttack) + " AB", oPC, FALSE);
}

void main()
{
    object oPC = OBJECT_SELF;

    int nBgLvl = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
    int nMaxAttack = nBgLvl/10 + 1; //+1 AB, and another +1 with 10 BG levels
    int nAttack = 1;

    if (nBgLvl >= 10) // Increase (minimum) attack bonus if 10+ BG
    {
        nAttack += 1;
    }

    if (nBgLvl > 10)
    {
        nMaxAttack = (nBgLvl-10)/4 + 2; // increase +1 AB every 4 levels after 10
    }
    float fRadius = IntToFloat(nBgLvl);
    effect eImpact = EffectVisualEffect(VFX_IMP_HARM);

    // Max AB Modifier
    if (GetLevelByClass(CLASS_TYPE_FIGHTER)) nMaxAttack += 1;
    if (GetLevelByClass(CLASS_TYPE_RANGER)) nMaxAttack -= 1;
    if (GetLevelByClass(CLASS_TYPE_DRUID)) nMaxAttack -= 2;
    if (GetLevelByClass(CLASS_TYPE_BARBARIAN)) nMaxAttack -= 3;
    if (GetLevelByClass(CLASS_TYPE_CLERIC)) nMaxAttack -= 5;
    if (GetLevelByClass(CLASS_TYPE_PALADIN)) nMaxAttack -= 5;
    if (nMaxAttack < 1) nMaxAttack = 1; // Allways at least +1 AB

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oPC);

    DelayCommand(0.2, BlackGuardPulse(nMaxAttack, oPC, fRadius, nAttack));

    // prob here
    float fCooldown = 60.0;
    DelayCommand(fCooldown , BgBullCooldown(oPC));// Add cooldown
}
