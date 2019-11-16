//::///////////////////////////////////////////////
//:: x2_s2_whirl.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Performs a whirlwind or improved whirlwind
    attack.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-20
//:://////////////////////////////////////////////
//:: Updated By: GZ, Sept 09, 2003
#include "x0_i0_spells"
#include "gen_inc_color"

//void doAttack(object oAttacker, object oTarget);

#include "inc_attacks"

void CustomMeleeDamage(object oTarget, object oUser = OBJECT_SELF, string sHand = "Right", int bCrit = FALSE, int bImproved = FALSE );

void main()
{
    object oSelf = OBJECT_SELF;
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSelf);
    string sMain = "Right";
    if (IPGetIsRangedWeapon(oWeapon))
    {
        SendMessageToPC(oSelf, "You cannot use this attack with ranged weapons");
        return;
    }
    else if (!GetIsObjectValid(oWeapon))
    {
        sMain = "Unarmed";
    }

    // Declare Major Variables
    float fSize = RADIUS_SIZE_MEDIUM;
    location lLoc = GetLocation(oSelf);
    int nDamageType;
    effect eVis = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);

    int bImproved = (GetSpellId() == 645);// improved whirlwind
    if (bImproved)
    {
        fSize = RADIUS_SIZE_HUGE;
        eVis = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    }
    //fRange = FeetToMeters(fRange);

    effect eVis2 = EffectVisualEffect(460);
    //effect eHit = EffectVisualEffect(VFX_COM_HIT_SONIC);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSelf);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lLoc);


    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSize, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (!GetIsDead(oTarget))
        {
            if (GetIsReactionTypeHostile(oTarget, oSelf) )
            {
                // Make Attack Roll
                int nAttack = DoAttackRoll(oTarget, sMain, oSelf, TRUE);
                if (nAttack >= 1)
                {
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) nAttack = 1;
                    //AssignCommand(oSelf, ActionAttack(oTarget, TRUE));
                    DelayCommand(0.2, CustomMeleeDamage(oTarget, oSelf, sMain, nAttack, bImproved));
                }

                if (GetIsDualWielding(oSelf))
                {
                    int nAttack2;

                    if (GetUsingDoubleSidedWeapon(oSelf))
                    {
                        nAttack2 = DoAttackRoll(oTarget, "Right", oSelf, TRUE);
                        if (nAttack2 >= 1)
                        {
                            if (GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) nAttack2 = 1;
                            // Apply Offhand Damage
                            DelayCommand(0.2, CustomMeleeDamage(oTarget, oSelf, "DoubleOffhand", nAttack2, bImproved));
                        }
                    }
                    else
                    {
                        nAttack2 = DoAttackRoll(oTarget, "Left", oSelf, TRUE);
                        if (nAttack2 >= 1)
                        {
                            if (GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) nAttack2 = 1;
                            // Apply Offhand Damage
                            DelayCommand(0.2, CustomMeleeDamage(oTarget, oSelf, "Left", nAttack2, bImproved));
                        }
                    }
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSize, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void CustomMeleeDamage(object oTarget, object oUser = OBJECT_SELF, string sHand = "Right", int bCrit = FALSE, int bImproved = FALSE )
{
    object oWeapon;
    int nDamage = 0;

    int nAcid = 0;
    int nBludgeoning = 0;
    int nCold = 0;
    int nDivine = 0;
    int nElectrical = 0;
    int nFire = 0;
    int nMagical = 0;
    int nNegative = 0;
    int nPiercing = 0;
    int nPositive = 0;
    int nSlashing = 0;
    int nSonic = 0;

    int nDamageType;
    int nBase = 0;
    int nCritMultiplier = 2;
    float fStrMultiplier = 1.0;

    if ( sHand == "Right")
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUser);
        if (GetUsingDoubleSidedWeapon(oUser))
        {
            fStrMultiplier = 1.0;
        }
        else if (GetWeaponSize(oWeapon) > GetCreatureSize(oUser))
        {
            fStrMultiplier = 1.5;
        }
        else
        {
            fStrMultiplier = 1.0;
        }
    }
    else if ( sHand == "Left")
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oUser);
        fStrMultiplier = 0.5;
    }
    else if ( sHand == "DoubleOffhand")
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUser);
        fStrMultiplier = 0.5;
    }

    // Check damage, feats and crit multiplier
    if (GetIsObjectValid(oWeapon))
    {
        //got a wapon
        if (IPGetIsMeleeWeapon(oWeapon))
        {
            //is melee
            nBase = GetWeaponBaseDamage(oWeapon);
            if ( GetHasWeaponFeat(oUser, sHand, 8) ) nBase += 2;
            if ( GetHasWeaponFeat(oUser, sHand, 4) ) nBase += 4;

            // get item property damage bonuses
            nBase += IPGetWeaponEnhancementBonus(oWeapon);

            nBase += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_BLUDGEONING);
            nBase += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_PIERCING);
            nBase += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_SLASHING);

            nAcid       += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_ACID);
            nCold       += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_COLD);
            nDivine     += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_DIVINE);
            nElectrical += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_ELECTRICAL);
            nFire       += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_FIRE);
            nMagical    += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_MAGICAL);
            nNegative   += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_NEGATIVE);
            nPositive   += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_POSITIVE);
            nSonic      += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_SONIC);

            nCritMultiplier = GetWeaponBaseCritMultiplier(oWeapon);
            if ( GetHasWeaponFeat(oUser, sHand, 5) && GetHasFeat(FEAT_INCREASE_MULTIPLIER, oUser) ) nCritMultiplier += 1;

            //Get equipped weapon type
            if (GetSlashingWeapon(oWeapon)) nDamageType = DAMAGE_TYPE_SLASHING;
            else if (IPGetIsBludgeoningWeapon(oWeapon)) nDamageType = DAMAGE_TYPE_BLUDGEONING;
            else nDamageType = DAMAGE_TYPE_PIERCING;
        }
        else
        {
            //ranged weapon
            return;
        }
    }
    else if ( sHand == "Unarmed")
    {
        //no weapon, likely unarmed
        nBase = GetUnarmedDamage(oUser);

        object oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oUser);
        if (GetBaseItemType(oWeapon) == BASE_ITEM_GLOVES)
        {
            // get item property damage bonuses
            nBase += IPGetWeaponEnhancementBonus(oWeapon);

            nBase += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_BLUDGEONING);
            nBase += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_PIERCING);
            nBase += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_SLASHING);

            nAcid       += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_ACID);
            nCold       += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_COLD);
            nDivine     += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_DIVINE);
            nElectrical += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_ELECTRICAL);
            nFire       += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_FIRE);
            nMagical    += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_MAGICAL);
            nNegative   += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_NEGATIVE);
            nPositive   += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_POSITIVE);
            nSonic      += IPGetWeaponDamageBonus(oWeapon, IP_CONST_DAMAGETYPE_SONIC);

        }

        nCritMultiplier = GetWeaponBaseCritMultiplier(oWeapon);

        nCritMultiplier = 2;
        nDamageType = DAMAGE_TYPE_BLUDGEONING;

    }

    int nLevel = GetHitDice(oUser);
    int nStr = GetAbilityModifier(ABILITY_STRENGTH, oUser);
    int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oUser);
    int bOverwhelmingCrit = GetHasWeaponFeat(oUser, sHand, 2);
    int bDevastatingCrit = GetHasWeaponFeat(oUser, sHand, 1);

    float fStr = IntToFloat(nStr) * fStrMultiplier;
    nStr = FloatToInt(fStr);

    int nDamageMode = GetCombatModeDamageBonus(oUser);

    nDamage = nBase + nStr + nDex + nDamageMode;
    nDamage      += GetEffectDamageBonus(oUser, DAMAGE_TYPE_BLUDGEONING);
    nDamage      += GetEffectDamageBonus(oUser, DAMAGE_TYPE_PIERCING);
    nDamage      += GetEffectDamageBonus(oUser, DAMAGE_TYPE_SLASHING);

    nAcid        += GetEffectDamageBonus(oUser, DAMAGE_TYPE_ACID);
    nCold        += GetEffectDamageBonus(oUser, DAMAGE_TYPE_COLD);
    nDivine      += GetEffectDamageBonus(oUser, DAMAGE_TYPE_DIVINE);
    nElectrical  += GetEffectDamageBonus(oUser, DAMAGE_TYPE_ELECTRICAL);
    nFire        += GetEffectDamageBonus(oUser, DAMAGE_TYPE_FIRE);
    nMagical     += GetEffectDamageBonus(oUser, DAMAGE_TYPE_MAGICAL);
    nNegative    += GetEffectDamageBonus(oUser, DAMAGE_TYPE_NEGATIVE);
    nPositive    += GetEffectDamageBonus(oUser, DAMAGE_TYPE_POSITIVE);
    nSonic       += GetEffectDamageBonus(oUser, DAMAGE_TYPE_SONIC);



    if (bCrit >= 2)
    {
        nDamage     *= nCritMultiplier;
        nAcid       *= nCritMultiplier;
        nCold       *= nCritMultiplier;
        nDivine     *= nCritMultiplier;
        nElectrical *= nCritMultiplier;
        nFire       *= nCritMultiplier;
        nMagical    *= nCritMultiplier;
        nNegative   *= nCritMultiplier;
        nPositive   *= nCritMultiplier;
        nSonic      *= nCritMultiplier;
    }
    if (bCrit >= 2 && bOverwhelmingCrit) nDamage += d6(nCritMultiplier);
    if (bImproved)
    {
        nDamage     += (nDamage/2);
        nAcid       += (nAcid/2);
        nCold       += (nCold/2);
        nDivine     += (nDivine/2);
        nElectrical += (nElectrical/2);
        nFire       += (nFire/2);
        nMagical    += (nMagical/2);
        nNegative   += (nNegative/2);
        nPositive   += (nPositive/2);
        nSonic      += (nSonic/2);
    }

    if (bCrit >= 2 && bDevastatingCrit && !GetImmortal(oTarget))
    {
        int nBleedDamage = nDamage+nAcid+nCold+nDivine+nElectrical+nFire+nMagical+nNegative+nPositive+nSonic;
        SalvDevastatingCritical(oTarget, oUser, nBleedDamage);
        /*
        int nDC = 10 + (nLevel/2) + nStr;
        if (!FortitudeSave(oTarget, nDC, SAVING_THROW_TYPE_NONE, oUser))
        {
            effect eDeath = EffectDeath(TRUE,TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
        }
        */
    }

    effect eDamage = EffectDamage(nDamage, nDamageType);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

    if (nAcid)
    {
        effect eAcid = EffectDamage(nAcid, DAMAGE_TYPE_ACID);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget);
    }
    if (nBludgeoning)
    {
        effect eBludgeoning = EffectDamage(nBludgeoning, DAMAGE_TYPE_BLUDGEONING);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eBludgeoning, oTarget);
    }
    if (nCold)
    {
        effect eCold = EffectDamage(nCold, DAMAGE_TYPE_COLD);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget);
    }
    if (nDivine)
    {
        effect eDivine = EffectDamage(nDivine, DAMAGE_TYPE_DIVINE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDivine, oTarget);
    }
    if (nElectrical)
    {
        effect eElectrical = EffectDamage(nElectrical, DAMAGE_TYPE_ELECTRICAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eElectrical, oTarget);
    }
    if (nFire)
    {
        effect eFire = EffectDamage(nFire, DAMAGE_TYPE_FIRE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget);
    }
    if (nMagical)
    {
        effect eMagical = EffectDamage(nMagical, DAMAGE_TYPE_MAGICAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eMagical, oTarget);
    }
    if (nNegative)
    {
        effect eNegative = EffectDamage(nNegative, DAMAGE_TYPE_NEGATIVE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eNegative, oTarget);
    }
    if (nPiercing)
    {
        effect ePiercing = EffectDamage(nPiercing, DAMAGE_TYPE_PIERCING);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, ePiercing, oTarget);
    }
    if (nPositive)
    {
        effect ePositive = EffectDamage(nPositive, DAMAGE_TYPE_POSITIVE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, ePositive, oTarget);
    }
    if (nSlashing)
    {
        effect eSlashing = EffectDamage(nSlashing, DAMAGE_TYPE_SLASHING);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSlashing, oTarget);
    }
    if (nSonic)
    {
        effect eSonic = EffectDamage(nSonic, DAMAGE_TYPE_SONIC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSonic, oTarget);
    }
}



/*
void main()
{
    int bImproved = (GetSpellId() == 645); // improved whirlwind
    object oEnemy = OBJECT_SELF;

    // Play random battle cry
    int nSwitch = d10();
    switch (nSwitch)
    {
        case 1: PlayVoiceChat(VOICE_CHAT_BATTLECRY1); break;
        case 2: PlayVoiceChat(VOICE_CHAT_BATTLECRY2); break;
        case 3: PlayVoiceChat(VOICE_CHAT_BATTLECRY3); break;
    }

    // * GZ, Sept 09, 2003 - Added dust cloud to improved whirlwind
    if (!bImproved)
    {
      effect eVis = EffectVisualEffect(460);
      DelayCommand(1.0f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,OBJECT_SELF));
    }



    //DoWhirlwindAttack(TRUE,bImproved);
    // * make me resume combat



    object oPlayer = OBJECT_SELF;
    location lPlayer = GetLocation(oPlayer);

    FloatingTextStringOnCreature(GetRGBColor(CLR_CYAN) + "Whirlwind" + GetRGBColor(), oPlayer);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lPlayer, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    location lTarget = GetLocation(oTarget);
    float nDistance = 0.0f;

    effect eEffect;

    int nHaste = 0;
    if (GetHasEffect(EFFECT_TYPE_HASTE, oPlayer))
        nHaste++;

    int nBAB = 1;
    if (GetHitDice(oPlayer) > 20)
    {
        int nEpicAB = (GetHitDice(oPlayer) - 20) / 2;
        if (nEpicAB % 2 == 1)
            nEpicAB++;
        nBAB = GetBaseAttackBonus(oPlayer) - nEpicAB;
    }
    else
        nBAB = GetBaseAttackBonus(oPlayer);

    int nAttacksPerRound = nBAB/5 + nHaste;
    float fDelay = 6.0f/IntToFloat(nAttacksPerRound);

    if (nHaste)
    {
        if (nAttacksPerRound % 2 == 1)
            nAttacksPerRound++;
        nAttacksPerRound /= 2;
        fDelay /= 2.0f;
    }

    FloatingTextStringOnCreature(GetRGBColor(CLR_CYAN) + "  Attacks: " + IntToString(nAttacksPerRound) + "   Delay: "+ FloatToString(fDelay) + GetRGBColor(), oPlayer);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            int x;
            for (x = 0; x < nAttacksPerRound; x++)
            {
                //Get the distance between the explosion and the target to calculate delay
                nDistance = GetDistanceBetweenLocations(lPlayer, lTarget);

                DelayCommand(fDelay + x , doAttack(oPlayer, oTarget));

            }

            //ActionUseFeat(FEAT_WHIRLWIND_ATTACK, oEnemy);

        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }


}

void doAttack(object oAttacker, object oTarget)
{
    if (GetIsDead(oTarget))
        return;

    //Set the damage effect
    effect eEffect = EffectDamage(10, DAMAGE_TYPE_COLD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
}

*/
