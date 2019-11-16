// Gets dmg done for sneak attack, and checks for ranged touch
// - oCaster: this is the object attack
// - oTarget: this is the target of the attack
//
// calculate this before sending event to target
int getSneakDamageRanged(object oCaster, object oTarget);

// Gets dmg done for sneak attack
// - oCaster: this is the object attack
// - oTarget: this is the target of the attack
//
// calculate this before sending event to target
int getSneakDamage(object oCaster, object oTarget);

//nice job leaving these out of the toolset guys :(
const int FEAT_SNEAK_ATTACK_1 = 221;
const int FEAT_SNEAK_ATTACK_2 = 345;
const int FEAT_SNEAK_ATTACK_3 = 346;
const int FEAT_SNEAK_ATTACK_4 = 347;
const int FEAT_SNEAK_ATTACK_5 = 348;
const int FEAT_SNEAK_ATTACK_6 = 349;
const int FEAT_SNEAK_ATTACK_7 = 350;
const int FEAT_SNEAK_ATTACK_8 = 351;
const int FEAT_SNEAK_ATTACK_9 = 352;
const int FEAT_SNEAK_ATTACK_10 = 353;
const int FEAT_SNEAK_ATTACK_11 = 1032;
const int FEAT_SNEAK_ATTACK_12 = 1033;
const int FEAT_SNEAK_ATTACK_13 = 1034;
const int FEAT_SNEAK_ATTACK_14 = 1035;
const int FEAT_SNEAK_ATTACK_15 = 1036;
const int FEAT_SNEAK_ATTACK_16 = 1037;
const int FEAT_SNEAK_ATTACK_17 = 1038;
const int FEAT_SNEAK_ATTACK_18 = 1039;
const int FEAT_SNEAK_ATTACK_19 = 1040;
const int FEAT_SNEAK_ATTACK_20 = 1041;

int SneakAmount(object oPerson)
{
    int sneakAmount = 0;
    int deathAttack = FALSE;

    if (GetHasFeat(FEAT_SNEAK_ATTACK_20, oPerson))
        sneakAmount += 20;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_19, oPerson))
        sneakAmount += 19;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_18, oPerson))
        sneakAmount += 18;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_17, oPerson))
        sneakAmount += 17;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_16, oPerson))
        sneakAmount += 16;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_15, oPerson))
        sneakAmount += 15;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_14, oPerson))
        sneakAmount += 14;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_13, oPerson))
        sneakAmount += 13;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_12, oPerson))
        sneakAmount += 12;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_11, oPerson))
        sneakAmount += 11;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_10, oPerson))
        sneakAmount += 10;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_9, oPerson))
        sneakAmount += 9;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_8, oPerson))
        sneakAmount += 8;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_7, oPerson))
        sneakAmount += 7;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_6, oPerson))
        sneakAmount += 6;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_5, oPerson))
        sneakAmount += 5;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_4, oPerson))
        sneakAmount += 4;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_3, oPerson))
        sneakAmount += 3;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_2, oPerson))
        sneakAmount += 2;
    else if (GetHasFeat(FEAT_SNEAK_ATTACK_1, oPerson))
        sneakAmount += 1;

    if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_15D6, oPerson))
        sneakAmount += 15;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_14D6, oPerson))
        sneakAmount += 14;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_13D6, oPerson))
        sneakAmount += 13;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_12D6, oPerson))
        sneakAmount += 12;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_11D6, oPerson))
        sneakAmount += 11;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_10D6, oPerson))
        sneakAmount += 10;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_9D6, oPerson))
        sneakAmount += 9;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_8D6, oPerson))
        sneakAmount += 8;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_7D6, oPerson))
        sneakAmount += 7;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_6D6, oPerson))
        sneakAmount += 6;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_5D6, oPerson))
        sneakAmount += 5;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_4D6, oPerson))
        sneakAmount += 4;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_3D6, oPerson))
        sneakAmount += 3;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_2D6, oPerson))
        sneakAmount += 2;
    else if (GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_1D6, oPerson))
        sneakAmount += 1;

    if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_20, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 20;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_19, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 19;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_18, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 18;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_17, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 17;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_16, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 16;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_15, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 15;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_14, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 14;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_13, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 13;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_12, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 12;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_11, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 11;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_10, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 10;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_9, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 9;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_8, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 8;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_7, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 7;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_6, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 6;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_5, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 5;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_4, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 4;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_3, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 3;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_2, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 2;
    }
    else if (GetHasFeat(FEAT_PRESTIGE_DEATH_ATTACK_1, oPerson))
    {
        if (!sneakAmount) deathAttack = TRUE;
        sneakAmount += 1;
    }

    //do it after death attack check to preserve death attack msg
    if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10, oPerson))
        sneakAmount + 10;
    else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9, oPerson))
        sneakAmount + 9;
    else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8, oPerson))
        sneakAmount + 8;
    else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7, oPerson))
        sneakAmount + 7;
    else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6, oPerson))
        sneakAmount + 6;
    else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5, oPerson))
        sneakAmount + 5;
    else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4, oPerson))
        sneakAmount + 4;
    else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3, oPerson))
        sneakAmount + 3;
    else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2, oPerson))
        sneakAmount + 2;
    else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1, oPerson))
        sneakAmount + 1;

    if (!sneakAmount)
        return 0;

    if (deathAttack)
        FloatingTextStringOnCreature("*Death Attack!*", oPerson, TRUE);
    else
        FloatingTextStringOnCreature("*Sneak Attack!*", oPerson, TRUE);

    return sneakAmount;
}


int HasEffectImmobilize(effect eCheck, object oObject)
{
    return
        GetEffectType(eCheck)==EFFECT_TYPE_PARALYZE ||
        GetEffectType(eCheck)==EFFECT_TYPE_CUTSCENE_PARALYZE ||
        GetEffectType(eCheck)==EFFECT_TYPE_PETRIFY ||
        (GetEffectType(eCheck)==EFFECT_TYPE_BLINDNESS && !GetHasFeat(FEAT_BLIND_FIGHT, oObject)) ||
        (GetEffectType(eCheck)==EFFECT_TYPE_DARKNESS && !GetHasFeat(FEAT_BLIND_FIGHT, oObject)) ||
        GetEffectType(eCheck)==EFFECT_TYPE_CONFUSED ||
        GetEffectType(eCheck)==EFFECT_TYPE_STUNNED;
}

//proper uncanny dodge check per D&D rules
int HasUncannyDodge(object oObject, object oAttacker)
{
   if ( GetHasFeat(FEAT_UNCANNY_DODGE_1, oObject) ||
        GetHasFeat(FEAT_UNCANNY_DODGE_2, oObject) ||
        GetHasFeat(FEAT_UNCANNY_DODGE_3, oObject) ||
        GetHasFeat(FEAT_UNCANNY_DODGE_4, oObject) ||
        GetHasFeat(FEAT_UNCANNY_DODGE_5, oObject) ||
        GetHasFeat(FEAT_UNCANNY_DODGE_6, oObject))
   {
        int nSneakLevels =  GetLevelByClass(CLASS_TYPE_BLACKGUARD, oAttacker) +
                            GetLevelByClass(CLASS_TYPE_ASSASSIN, oAttacker)+
                            GetLevelByClass(CLASS_TYPE_ROGUE, oAttacker);
        int nDodgeLevels =  GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oObject) +
                            GetLevelByClass(CLASS_TYPE_BARBARIAN, oObject)+
                            GetLevelByClass(CLASS_TYPE_ROGUE, oObject);
        if (nSneakLevels>nDodgeLevels+4)
            return TRUE;
   }
   return FALSE;
}

int CanBeSneaked (object oCaster, object oTarget)
{
    //only sneak creatures thx :)
    if (GetObjectType(oTarget)!=OBJECT_TYPE_CREATURE)
        return FALSE;

    //more than 10 meters (30ft in D&D rules) away means you cant pinpoint a sneak attack
    if (GetDistanceBetween(oCaster, oTarget)>10.0)
        return FALSE;

    //cant sneak immune creatures
    if (GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK))
    {
        return FALSE;
    }
    //can only sneak ones unaware
    if (GetObjectSeen(oCaster, oTarget))
    {
        //has an effect that stops us from being aware of attacker
        effect eCheck = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eCheck))
        {
            if (HasEffectImmobilize(eCheck, oTarget))
                return TRUE;
            eCheck = GetNextEffect(oTarget);
        }

        //is fighting us
        if (GetIsInCombat(oTarget) && (GetAttackTarget(oTarget) == oCaster))
            return FALSE;

        if (GetActionMode(oTarget, ACTION_MODE_COUNTERSPELL))
            return FALSE;

        //targeting someone else
        if (GetIsInCombat(oTarget) && GetAttackTarget(oTarget)!= oCaster)
            return TRUE;
    }
    if (HasUncannyDodge(oTarget, oCaster))
        return FALSE;

    return TRUE;
}

int getSneakDamageRanged(object oCaster, object oTarget)
{
    if (!CanBeSneaked(oCaster, oTarget))
     return 0;
    //now we sneak the hell outta them!!
    int sneakAmt = SneakAmount(oCaster);
    if (sneakAmt==0)
       return 0;

    int nTouch = TouchAttackRanged(oTarget);
    if (!nTouch)
       return 0;

     return d6(sneakAmt);
}
int getSneakDamage(object oCaster, object oTarget)
{
    if (!CanBeSneaked(oCaster, oTarget))
        return 0;
    //now we sneak the hell outta them!!

    int sneakAmt = SneakAmount(oCaster);
    if (sneakAmt==0)
        return 0;

    return d6(sneakAmt);
}
