// --- Adds new and interesting effects to the Assassin's spells --- //

#include "x2_i0_spells"

// Alters the assassin spell "invisibility"
void AssnInvis(object oTarget);

// Alters the assassin spell "improved invisibility"
void AssnImpInvis(object oTarget);

// Alters the assassin spell "darkness"
void AssnDarkness (location lTarget);

// Alters the assassin spell "ghostly visage"
void AssnVisage(object oTarget);

/////////////// Darkness Cooldown ///////////////
// Increment Darkness uses if player has not rested

void DarknessCooldown(object oPC)
{
    if (!(GetHasSpell(606, oPC)) && !(GetLocalInt(oPC, "DarknessReset")))
    {
        IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_DARKNESS);
    }
    SetLocalInt(OBJECT_SELF, "DarknessReset", 1);
    DelayCommand(60.0, DeleteLocalInt(oPC, "DarknessReset"));
}

///////////////////////////////////////////////////////


int nAssn = GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF);

  // ----------------- Invisibility (Mark Target)----------------- //
  // Lowers targets AC (decrease = assassin/6), deals damage after delay (damage = assassin+15)
void AssnInvis(object oTarget)
{
    // Target must be hostile
    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    {
        FloatingTextStringOnCreature("Target marked for death", OBJECT_SELF);

        int nImpSneak = 0;
        int nCheck = 835; // Value for Imp sneak attack II

        // Check if player has epic imroved sneak attack feat
        if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1, OBJECT_SELF))
        {
             nImpSneak = 1;
             // Find out number of improved sneak attack feats taken
             while ((GetHasFeat(nCheck, OBJECT_SELF)) && (nCheck < 844))
             {
                  nImpSneak += 1;
                  nCheck += 1;
             }
        }

        int nDmg = nAssn + 15 + (6*nImpSneak); // Damage increased by epic sneak feats
        int nAcPen = nAssn/6;

        effect eAcPen = EffectACDecrease(nAcPen);
        effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);

        eAcPen = ExtraordinaryEffect(eAcPen);
        float fImpSneak = IntToFloat(nImpSneak);
        float fCooldown = (40.0 - (2.0*fImpSneak));

        effect eLoop = GetFirstEffect(oTarget);// Check if target already has the effect, avoid stacking
        while (GetIsEffectValid(eLoop))
        {
            if (GetEffectType(eLoop) == GetEffectType(eAcPen)) // if Target already has this effect, don't stack it
            {
                RemoveEffect(oTarget, eLoop);
            }
            eLoop = GetNextEffect(oTarget);
        }

        // Apply VFX and ac penalty to target
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAcPen, oTarget, 18.0); // 3 round duration
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), oTarget);


        // After the delay, ability is refreshed and usable. Bonus damage and VFX triggered on target.
        DelayCommand(fCooldown, IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PRESTIGE_INVISIBILITY_1)); // Add cooldown
        DelayCommand(18.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,  EffectVisualEffect(122), oTarget));
        DelayCommand(18.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget));
    }
    else // Ability not used on hostile; cancel usage
    {
        FloatingTextStringOnCreature("Target Must Be Hostile", OBJECT_SELF);
        IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PRESTIGE_INVISIBILITY_1);
        return;
    }
}


  // ----------------- Improved Invisibility (Assassinate) ----------------- //
  // Deals Damage, lowers fortitude by 2 for 60 seconds
void AssnImpInvis(object oTarget)
{
    // Target must be hostile
    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    {
        FloatingTextStringOnCreature("Attempting assassination...", OBJECT_SELF);

        int nImpSneak = 0;
        int nCheck = 835; // Value for Imp sneak attack II

        // Check if player has epic imroved sneak attack feat
        if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1, OBJECT_SELF))
        {
             nImpSneak = 1;
             // Find out number of improved sneak attack feats taken
             while ((GetHasFeat(nCheck, OBJECT_SELF)) && (nCheck < 844))
             {
                  nImpSneak += 1;
                  nCheck += 1;
             }
        }

        int nDmg =(2*nAssn) + 20 + (8*nImpSneak); // Damage dealt by the

        effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
        effect eFort = EffectSavingThrowDecrease(SAVING_THROW_FORT, 2, SAVING_THROW_TYPE_ALL);

        effect eLink = EffectLinkEffects(eDmg, eFort);

        float fImpSneak = IntToFloat(nImpSneak);
        float fCooldown = (60.0 - (4.0*fImpSneak)); // Cooldown reduced by epic sneak feats

        effect eLoop = GetFirstEffect(oTarget);// Check if target already has the effect, avoid stacking
        while (GetIsEffectValid(eLoop))
        {
            if (GetEffectType(eLoop) == GetEffectType(eFort)) // if Target already has save decrease effect, don't stack it
            {
                FloatingTextStringOnCreature("Target has survived a recent assassination attempt.", OBJECT_SELF);
                RemoveEffect(oTarget, eLoop);
            }
            eLoop = GetNextEffect(oTarget);
        }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 60.0);   // Duration of save decrease
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(122), oTarget);

        DelayCommand(fCooldown , IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PRESTIGE_INVISIBILITY_2));// Add cooldown
    }
    else  // Target wasn't hostile
    {
        FloatingTextStringOnCreature("Target Must Be Hostile", OBJECT_SELF);
        IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PRESTIGE_INVISIBILITY_2);
        return;
    }
}



  // ------------------------- Darkness -------------------------//
    // Similar to PWkill, deals damage to survivors

void AssnDarkness (location lTarget)
{
    int nHitpoints;
    int nMaxHP = 40 + (2*nAssn);
    int nImpSneak = 0;
    int nCheck = 835; // Value for Imp sneak attack II

    FloatingTextStringOnCreature("Deadly assassins strike in the darkness", OBJECT_SELF);

    // Check if player has epic imroved sneak attack feat
    if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1, OBJECT_SELF))
    {
         nImpSneak = 1;
         // Find out number of improved sneak attack feats taken
         while ((GetHasFeat(nCheck, OBJECT_SELF)) && (nCheck < 844))
         {
              nImpSneak += 1;
              nCheck += 1;
         }
    }

    effect eDeath  = EffectDeath();
    effect eVis    = EffectVisualEffect(VFX_IMP_DEATH);
    effect eDark   = EffectVisualEffect(VFX_DUR_DARKNESS);
    effect eDmg    = EffectDamage(nAssn+20, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    // Fire VFX at location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDark, GetSpellTargetLocation());

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            if (GetCurrentHitPoints(oTarget) <= nMaxHP)// Target has low hp
            {
               eDeath = EffectDamage(GetCurrentHitPoints(oTarget) + 500, DAMAGE_TYPE_MAGICAL);
               //Apply the death effect and the VFX impact
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
            else // Apply some damage
            {
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(122), oTarget);
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

    float fCooldown = 60.0;

    object oPC = OBJECT_SELF;
    DelayCommand(fCooldown , DarknessCooldown(oPC));// Add cooldown
}



  // -------------------- Ghostly Visage ------------------- //
  // Increase AB, Disc, and concealment
  void AssnVisage(object oTarget)
  {
    int nAB = 0;
    int nDisc = 0;
    int nAcSelf = 5;


    // Increase Disc and ab at levels 14, 20, 25
    if (nAssn >= 14)
    {
        nAB += 1;
        nDisc += 1;

        if (nAssn >= 20)
        {
            nAcSelf += 2;
            nAB += 2;
            nDisc += 2;
            if (nAssn >= 25)
            {
                nAB += 1;
                nDisc += 1;
            }
        }
    }
    if (GetLevelByClass(CLASS_TYPE_PALE_MASTER)>9)
    {
        nAcSelf = 0;
    }

    SendMessageToPC(oTarget, "Attack Bonus: " + IntToString(nAB));
    SendMessageToPC(oTarget, "Discipline Bonus: " + IntToString(nDisc));
    SendMessageToPC(oTarget, "Conceal Bonus: " + IntToString(nAssn+10));
    SendMessageToPC(oTarget, "Armor Bonus: " + IntToString(nAcSelf-5));

    effect eAC = EffectACIncrease(nAcSelf, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL);
    effect eConc = EffectConcealment(nAssn+10, MISS_CHANCE_TYPE_NORMAL);
    effect eAB = EffectAttackIncrease(nAB, ATTACK_BONUS_MISC);
    effect eDisc = EffectSkillIncrease(SKILL_DISCIPLINE, nDisc);
    effect eLink = EffectLinkEffects(eConc, eAB);
    eLink = EffectLinkEffects(eDisc, eLink);
    eLink = EffectLinkEffects(eAC, eLink);

    eLink = ExtraordinaryEffect(eLink); // Effect undispellable

    // Apply effects
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_PULSE_BLUE_BLACK), oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
  }
