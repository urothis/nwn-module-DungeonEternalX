//::///////////////////////////////////////////////
//:: Turn Undead
//:: NW_S2_TurnDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks domain powers and class to determine
    the proper turning abilities of the casting
    character.

    Changelog:
        Note: The first section contains a summary of changes made. The second
        section explains in greater detail about the changes.

    Modified by : Slynderdale
             on : April 15 , 2005
    Changes:
             - Added Rebuke Undead
             - Turning is now a Supernatural effect
             - Turning now skips creatures that were already turned/rebuked
             - Turn undead checks both the creatures racial type and class
             - Turned creatures have their movement speed decreased by half
             - Cleric, Paladin, Blackguard and Champion of Torm levels now stack
             - Turn undead Knocks over valid creatures

    Modified by : Slynderdale
             on : April 21 , 2005
    Changes:
             - Added function HasTurnedEffect
             - Added function GetTurnModifier
             - Added function GetIsAssociate
             - Magical beasts are now turnable/rebukable

    Modified by : Slynderdale
             on : April 26 , 2005
    Changes:
             - Added more to the Turn Modifier function and Fixed it up a bit
             - Fixed some errors and bugs in the code and made some code improvments

    Modified by : Slynderdale
             on : May 1 , 2005
    Changes:
             - Added support for the War Domain, Turned/Rebuked creatures will take divine damage.
             - Added support for the Travel domain which adds to the turning range.
             - Added more to the Trickery domain, Added rolling a lucky 7 or unlucky 13.
             - Construct turn damage was changed from d3(nTurnLevel+nHDModifier) to d3(nTurnLevel)+nHDModifier
             - Fixed some errors and bugs in the code and made some code improvments

    Modified by : Slynderdale
             on : June 3 , 2005
    Changes:
             - Added support for local integers on creatures
             - Added function GetRacialCheck which now handles the racial checkings
             - Fixed some errors and bugs in the code and made some code improvments

    ----------------------------------------------------------------------------------------

    More Info:
        - Added Rebuke Undead
            Evil aligned players or those with the REBUKE_UNDEAD local int can
            now rebuke undead. When you rebuke undead, instead of turning a creature,
            you paralyze them. If your rebuking level is high enough, you have a chance
            of dominating them and having them under your control for a duration.

        - Turning is now a Supernatural effect
            Made turning a Supernatural effect so the turning effects can not be dispelled.

        - Turning now skips creatures that were already turned/rebuked
            Turned creatures will not count against your turning count.

        - Turn undead checks both the creatures racial type and class
            If a creature was created and have an incorrectly set race but
            have levels like Undead, it will be considered undead.

        - Turned creatures have their movement speed decreased by half
            If you're attacking something with a fear effect in NWN, the game
            tends to move you close to the target, then stop you, then move the creature away,
            so you never actually get to ATTACK it even if you're hasted and it's a zombie.
            Even worse is that creatures that are knocked down magically spring up and run away,
            and it's just SO annoying.

        - Cleric, Paladin, Blackguard and Champion of Torm levels now stack
            The turning level isn't decided on the class with the highest level.
            Cleric levels now stack with Blackguard and Paladin levels but Paladin
            and Blackguard levels don't stack with each other.

        - Turn undead Knocks over valid creatures
            This fixes a bug where sometimes turned/Rebuked undead still attack.
            The other reason behind this is when you rebuke/turn undead. You
            release a tremendous amount of (un)holy energy. This energy causing those
            affected to be knocked off their feet.

        - Added checks to see if a creature is turnable
            HasTurnedEffect is called to check if the creature can be turned.
            It checks to see if the creature is already turned, paralized,
            petrified, frightened, stunned or dominated. This way creatures
            who can't or shouldn't be turned won't use up HD turn counts.

        - Added Associate Checking
            I added a check so rebuke undead will not try to add associates
            under your command, instead they will be paralized. Also when turning
            a summoned creature, it will show an unsummon special effect.

        - Magical beasts are now turnable/rebukable
            If you have the magic domain, you can turn/rebuke magical beasts now.

        - Several domains and feats affect your turn modifier
            GetTurnModifier is used to get the modifier for the current target. The bigger the
            modifier the better the chance you will turn the target and the longer the effects will last.
            The modifier also effects the damage you do to constructs if you have the destruction domain.
            This modifier take into account several domains that don't really get much use and also
            focuses in necromancy adds to the modifier against undead. Also various domains and things
            may subtract from your modifier.
              *Evil Domain: If you try to turn a creature with an good alignment and you
                have the evil domain power, you gain a +1 modifier. Unless you also have the
                good domain, -1 is subtracted from the modifier versus evil.
              *Good Domain: If you try to turn a creature with a evil alignment and you
                have the good domain power, you gain a +1 modifier. Unless you also have the
                good domain, -1 is subtracted from the modifier versus good.
              *Sun Domain: You gain a +1 modifier to all checks.
              *Knowledge Domain: You gain a modifier that is dependant on your wisdom bonus.
                You gain one third of your wisdom bonus as a modifier. If your wisdom bonus is
                equal to or smaller then 0, then the current wisdom bonus - 2 is subtracted
                from the modifier.
              *Strength Domain: Checks your strength bonus versus the targets strength bonus.
                If your strength bonus is 2 or more times higher, then you gain +1 to the modifier.
                If your strength is higher, then you gain +1 to the modifer.
                If the targets strength is 2 or more times higher, then you lose -1 from the modifier.
                If the targets strength is higher, then you lose -1 from the modifer.
                These stack for a total of +2 or -2 to your modifier.
              *Water/Fire/Air/Earth Domain: You gain +1 to your modifier versus the corresponding
                elemental of the domain you have.
              *Trickery Domain: The trickery can have a negative and positive effect to our modifier,
                Theres a 50% chance it will have a positive effect and a 50% it will have a negative effect.
                If you also have the luck domain, it becomes 80% for a positive effect and 20% for a negative
                effect. If its positive, you gain 1-3 to your modifier. If its negative, you lose 1-3 from
                your modifier. Also if it rolls a lucky 7 or a unluck 13, the results of the modifier are
                doubled. So if you had a negative effect of -3 and roll an unlucky 13, it will become -6.
                The same goes for the positive modifier with rolling a 7,
              *Death Domain: You gain a +1 modifier versus undead.
            Focuses in necromancy will add to your modifier against those considered undead.
              *Spell Focus Necromancy: +2
              *Greater Spell Focus Necromancy: +2
              *Epic Spell Focus Necromancy: +2
              The bonuses from the focuses stack for a total of +6 if you have all three.
            The higher the modifier the easier it is to turn the creature. Also the
            higher the modifier, the longer the rebuke/turn effects will last on the target.
            The current duration is (nClassLevel + 5)*nTimeModifier rounds.
            nClassLevel is the number of levels of cleric, paladin/blackguard and CoT you have.
            nTimeModifier defaults to 1, so the duration is normal, but if your modifier is greater
            then 1, the nTimeModifier is set to the current modifier.
            The modifier is added to the dice roll when damaging constructs if you have the destruction
            domain, so the damage is now d3(nTurnLevel)+nHDModifier.

        - War Domain damages Turned/Rebuked creatures
            If you have the War Domain and successfuly turn or rebuke a creature, they will take a small
            ammount of Divine damage. This doesn't stack with the magic damage that is already done to
            constructs. The damage done is d6(3)+nHDModifier.

        - Travel Domain Extends Turning Range
            Originally the turning range is 20m (65ft) but if you have the Travel Doamin this changes to
            25m (80ft), adding another 5m tot he original distance. This way you can turn creatures which
            are farther away then usual.

        - Added support for local integers on creatures
            Added support for several local integers on the creatures so builders have greater control how a
            creature is turned or if they are immune to turning.
                TurnImmunity: If TurnImmunity is set to True, the creature can not be turned.
                IsTurnable: Is IsTurnable is set to true, the creatue can be turned no matter what it might be.
                IsUndead: If IsUndead is set, the creature will be treated as an undead when turned.
                IsVermin: If IsVermin is set, the creature will be treated as a vermin when turned.
                IsElemental: If IsElemental is set, the creature will be treated as an elemenal when turned.
                IsConstruct: If IsConstruct is set, the creature will be treated as a construct when turned.
                IsOutsider: If IsOutsider is set, the creature will be treated as an outsider when turned.
                IsMagicalBeast: If IsMagicalBeast is set, the creature will be treated as a magical beast when turned.
                TurnHDOverride: If TurnHDOverride is set to anything greater then 0, the value set for TurnHDOverride
                                will override the creatures current HD and be used instead of their default one.
                                The new value will still be affected by the turn modifier as well.
            You can specify is a creature can be turned with IsTurnable, if so, the creature can be turned like everything
            else but it won't have a race type like undead or so on unless it has thatr ace already. The creature will have HD
            equal to their HitDice plus their turn resistance. Also anyone with Turn Undead will be able to turn them without
            any special feats or skills.
            If you want to make a creature be set as turnable but give it a race or use a race check, use the more precise ones
            such as IsOutsider. The creature will then be considered an outsider while being turned, using the outsider HD
            calculations and also check if the player can turn outsiders.
            **Note: IsTurnable overrides the other settings except for TurnImmunity. So if you have IsTurnable and IsOutsider, the
                    creature can still be turned even if the player can't turn outsiders.

        - Added function GetRacialCheck which now handles the racial checkings
            This function compares the given race against the targets race. This checks against the targets
            racial type, if they have the racial class or if they have the racial local interget override set.
            If true, it returns True, if False, it returns false. The first parameter is the race to check for
            such as RACIAL_TYPE_UNDEAD. The second parameter is optional and specifies the target. The default
            is OBJECT_SELF which is the PC using the script.
*/
//:://////////////////////////////////////////////
//:: Created By: Nov 2, 2001
//:: Created On: Preston Watamaniuk
//:://////////////////////////////////////////////
//:: MODIFIED MARCH 5 2003 for Blackguards
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"
//#include "sha_subr_methds"

//This function is used to do a racial check against the target.
//This checks the creatures race, classes and also local integers that specify the race
int GetRacialCheck(int nRace, object oTarget = OBJECT_SELF)
{
    if (!GetIsObjectValid(oTarget))
        return FALSE;

    int nRacial;
    int nClassUndead, nClassVermin, nClassElemental, nClassConstruct, nClassOutsider, nClassMagicalBeast;
    int nIsUndead, nIsVermin, nIsElemental, nIsConstruct, nIsOutsider, nIsMagicalBeast;

    nRacial = GetRacialType(oTarget);
    nClassUndead = GetLevelByClass(CLASS_TYPE_UNDEAD,oTarget);
    nClassVermin = GetLevelByClass(CLASS_TYPE_VERMIN,oTarget);
    nClassElemental = GetLevelByClass(CLASS_TYPE_ELEMENTAL,oTarget);
    nClassConstruct = GetLevelByClass(CLASS_TYPE_CONSTRUCT,oTarget);
    nClassOutsider = GetLevelByClass(CLASS_TYPE_OUTSIDER,oTarget);
    nClassMagicalBeast = GetLevelByClass(CLASS_TYPE_MAGICAL_BEAST,oTarget);

    nIsUndead=FALSE; nIsVermin=FALSE; nIsElemental=FALSE; nIsConstruct=FALSE; nIsOutsider=FALSE; nIsMagicalBeast=FALSE;
    if(nRacial == RACIAL_TYPE_UNDEAD || nClassUndead > 0 || GetLocalInt(oTarget,"IsUndead")) nIsUndead = TRUE;
    if(nRacial == RACIAL_TYPE_VERMIN || nClassVermin > 0 || GetLocalInt(oTarget,"IsVermin")) nIsVermin = TRUE;
    if(nRacial == RACIAL_TYPE_ELEMENTAL || nClassElemental > 0 || GetLocalInt(oTarget,"IsElemental")) nIsElemental = TRUE;
    if(nRacial == RACIAL_TYPE_CONSTRUCT || nClassConstruct > 0 || GetLocalInt(oTarget,"IsConstruct")) nIsConstruct = TRUE;
    if(nRacial == RACIAL_TYPE_OUTSIDER || nClassOutsider > 0 || GetLocalInt(oTarget,"IsOutsider")) nIsOutsider = TRUE;
    if(nRacial == RACIAL_TYPE_MAGICAL_BEAST || nClassMagicalBeast > 0 || GetLocalInt(oTarget,"IsMagicalBeast")) nIsMagicalBeast = TRUE;

    if (nRace == RACIAL_TYPE_UNDEAD && nIsUndead  ||
        nRace == RACIAL_TYPE_VERMIN && nIsVermin  ||
        nRace == RACIAL_TYPE_ELEMENTAL && nIsElemental  ||
        nRace == RACIAL_TYPE_CONSTRUCT && nIsConstruct  ||
        nRace == RACIAL_TYPE_OUTSIDER && nIsOutsider  ||
        nRace == RACIAL_TYPE_MAGICAL_BEAST && nIsMagicalBeast)
        return TRUE;

    if (nRacial == nRace)
        return TRUE;

    return FALSE;
}

//Get the modifer for Turn Undead. This effects how long the turn effects last and how well
//it will go against a creature.
int GetTurnModifier(object oTarget)
{
    //Declare major variables
    int nHDModifier = 0;
    int nWisMod;
    int nWisdomBonus = GetAbilityModifier(ABILITY_WISDOM);
    int nStrengthBonus = GetAbilityModifier(ABILITY_STRENGTH);
    int nAppearance = GetAppearanceType(oTarget);
    int nAlign = GetAlignmentGoodEvil(oTarget);
    int nRacial = GetRacialType(oTarget);
    int nClassUndead = GetLevelByClass(CLASS_TYPE_UNDEAD,oTarget);

    //Check to see if they have any focuses in Necromancy or the death domain
    //If so, add them to the modifier which makes it easier to turn the undead
    if(GetRacialCheck(RACIAL_TYPE_UNDEAD, oTarget))
    {
        if(GetHasFeat(FEAT_DEATH_DOMAIN_POWER))
            nHDModifier = nHDModifier + 1;
        if(GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY))
            nHDModifier = nHDModifier + 2;
        if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY))
            nHDModifier = nHDModifier + 2;
        if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY))
            nHDModifier = nHDModifier + 2;
    }

    //Check to see if the player has the Good or Evil domain
    //If they do, check to see if the creature's alignment is good or evil
    //If the alignment opposite the domain, add to the turning modifier if the
    //alignment is the same, subtract from the modifier
    if (GetHasFeat(FEAT_EVIL_DOMAIN_POWER))
    {
        if (nAlign == ALIGNMENT_GOOD)
            nHDModifier = nHDModifier + 1;
        if (nAlign == ALIGNMENT_EVIL && !GetHasFeat(FEAT_GOOD_DOMAIN_POWER))
            nHDModifier = nHDModifier - 1;
    }
    if (GetHasFeat(FEAT_GOOD_DOMAIN_POWER))
    {
        if (nAlign == ALIGNMENT_EVIL)
            nHDModifier = nHDModifier + 1;
        if (nAlign == ALIGNMENT_GOOD && !GetHasFeat(FEAT_EVIL_DOMAIN_POWER))
            nHDModifier = nHDModifier - 1;
    }

    //Check to see if the player has the knoledge domain power
    //If so, add 1/3rd if their wisdom bonus to the modifier
    //If their wisdom bonus is 0 or lower, then the modifier is
    //their wisdom bonus minus 2.
    if (GetHasFeat(FEAT_KNOWLEDGE_DOMAIN_POWER))
    {
        if (nWisdomBonus > 0)
        {
            nWisMod = nWisdomBonus / 3;
            if (nWisMod > 0)
                nHDModifier = nHDModifier + nWisMod;
        }
        else
        {
            nWisMod = nWisdomBonus - 2;
            nHDModifier = nHDModifier + nWisMod;
        }
    }

    //Check your strength bonus versus the targets
    //If your strength bonus is 2 or more times higher, then you gain +1 to the modifier
    //If your strength is higher, then you gain +1 to the modifer
    //If the targets strength is 2 or more times higher, then you lose -1 from the modifier
    //If the targets strength is higher, then you lose -1 from the modifer
    //These stack for a total of +2 or -2
    if (GetHasFeat(FEAT_STRENGTH_DOMAIN_POWER))
    {
        int nTarStrengthBonus = GetAbilityModifier(ABILITY_STRENGTH,oTarget);
        if ((nStrengthBonus*2) < nTarStrengthBonus)
            nHDModifier = nHDModifier - 1;
        if (nStrengthBonus < nTarStrengthBonus)
            nHDModifier = nHDModifier - 1;
        if (nStrengthBonus > (nTarStrengthBonus*2))
            nHDModifier = nHDModifier + 1;
        if (nStrengthBonus > nTarStrengthBonus)
            nHDModifier = nHDModifier + 1;
    }

    //If you have the air domain, make it easier to turn air elementals
    if (GetHasFeat(FEAT_AIR_DOMAIN_POWER) &&
       (nAppearance == APPEARANCE_TYPE_ELEMENTAL_AIR ||
        nAppearance == APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER))
    {
        nHDModifier = nHDModifier + 1;
    }

    //If you have the earth domain, make it easier to turn earth elementals
    if (GetHasFeat(FEAT_EARTH_DOMAIN_POWER) &&
       (nAppearance == APPEARANCE_TYPE_ELEMENTAL_EARTH ||
        nAppearance == APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER))
    {
        nHDModifier = nHDModifier + 1;
    }

    //If you have the fire domain, make it easier to turn fire elementals
    if (GetHasFeat(FEAT_FIRE_DOMAIN_POWER) &&
       (nAppearance == APPEARANCE_TYPE_ELEMENTAL_FIRE ||
        nAppearance == APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER))
    {
        nHDModifier = nHDModifier + 1;
    }

    //If you have the water domain, make it easier to turn water elementals
    if (GetHasFeat(FEAT_WATER_DOMAIN_POWER) &&
       (nAppearance == APPEARANCE_TYPE_ELEMENTAL_WATER ||
        nAppearance == APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER))
    {
        nHDModifier = nHDModifier + 1;
    }

    //Checks to see if you have the Trickery domain and calculate the effects
    //Theres a 50% chance for a positive effect and a 50% for a negative effect
    //unless you have the luck domain feat, then theres only a 20% chance for a
    //negative effect. Lucky 7 and Unlucky 13 doubles the results.
    if (GetHasFeat(FEAT_TRICKERY_DOMAIN_POWER))
    {
        int nTrickMod;
        int nTrick = d20();
        if (GetHasFeat(FEAT_LUCK_DOMAIN_POWER))
            nTrick = nTrick - 6;
        if (nTrick <= 10)
        {
            nTrickMod = d3();
            if (nTrick == 7) //Lucky 7
                nTrickMod = nTrickMod * 2;
        }
        else
        {
            nTrickMod = d3()*-1;
            if (nTrick == 13) //UnLucky 13
                nTrickMod = nTrickMod * 2;
        }
        nHDModifier = nHDModifier + nTrickMod;
    }

    //The sun domain improves your turning modifier
    if (GetHasFeat(FEAT_SUN_DOMAIN_POWER))
    {
        nHDModifier = nHDModifier + 1;
    }

    return nHDModifier;
}

//This function checks to see if the turned creature is an associate to another creature
//This way it won't try to rebuke associates of another player and also unsummon summons
int GetIsAssociate(object oTarget, int nCheckAll = FALSE)
{
    if (GetIsObjectValid(oTarget))
    {
        object oMaster = GetMaster(oTarget);
        if (GetIsObjectValid(oMaster))
        {
            int nAssociate = GetAssociateType(oTarget);
            if(nAssociate == ASSOCIATE_TYPE_SUMMONED ||
               nAssociate == ASSOCIATE_TYPE_FAMILIAR ||
               nAssociate == ASSOCIATE_TYPE_ANIMALCOMPANION)
            {
                return TRUE;
            }
            if (nCheckAll &&
               (nAssociate == ASSOCIATE_TYPE_DOMINATED ||
                nAssociate == ASSOCIATE_TYPE_HENCHMAN))
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}

//Check to see if the target is already turned, paralized,
//petrified, frightened, stunned and dominated. If so, return true.
int HasTurnedEffect(object oTarget)
{
    return
        GetHasEffect(EFFECT_TYPE_TURNED, oTarget) ||
        GetHasEffect(EFFECT_TYPE_FRIGHTENED, oTarget) ||
        GetHasEffect(EFFECT_TYPE_PARALYZE, oTarget) ||
        GetHasEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, oTarget) ||
        GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) ||
        GetHasEffect(EFFECT_TYPE_STUNNED, oTarget) ||
        GetHasEffect(EFFECT_TYPE_DOMINATED, oTarget);
}

//Checks to see if the player is able to command the creature depending
//On how many slots you have left and the target HD.
int CanCommand(int nClassLevel, int nTargetHD)
{
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    int nNew = nSlots + nTargetHD;
    if(nClassLevel >= nNew)
    {
        return TRUE;
    }
    return FALSE;
}

//Add the creature under the player's command
void AddCommand(int nTargetHD)
{
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    SetLocalInt(OBJECT_SELF, "wb_clr_comm_slots", nSlots + nTargetHD);
}

//Remove the creature from the players command
void SubCommand(int nTargetHD)
{
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    SetLocalInt(OBJECT_SELF, "wb_clr_comm_slots", nSlots - nTargetHD);
}

//Gets all creatures in a 20m radius around the caster and rebukes them or not.  If the creatures
//HD are 1/2 or less of the nClassLevel then the creature is commanded (dominated) or dismissed.
void RebukeUndead(int nTurnLevel, int nTurnHD, int nVermin, int nElemental, int nConstructs, int nGoodOrEvilDomain, int nPlanar, int nMagicDomain, int nClassLevel)
{
    //Declare major variables
    int nCnt = 1;
    int nHDModifier = 0;
    int nTimeModifier = 1;
    int nIsUndead, nIsVermin, nIsElemental, nIsConstruct, nIsOutsider, nIsMagicalBeast;
    int nHD, nHDCount, bValid, nDamage, nDuration;
    nHDCount = 0;
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eUnsummonVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eDamage;
    effect eKnockdown = EffectKnockdown();
    //Yes I know its rebuke undead, but turn then anyways so they don't count towards the HD score
    effect eTurned = EffectTurned();
    //Cutscene Paralyze sometimes fail if the target is immune to paralyzation.
    //If thats the case, then immobilze them so they can't move.
    //They won't attack because they are turned with EffectTurned. Hence another reason why I left it in.
    effect eParalyze = EffectCutsceneParalyze();
    effect eImmobilize = EffectCutsceneImmobilize();
    effect eRebukeLink = EffectLinkEffects(eVisTurn, eTurned);
    eRebukeLink = EffectLinkEffects(eRebukeLink, eParalyze);
    eRebukeLink = EffectLinkEffects(eRebukeLink, eImmobilize);
    //Made it a supernatural effect so it can't be dispelled.
    eRebukeLink = SupernaturalEffect(eRebukeLink);

    effect eDeath = SupernaturalEffect(EffectDeath(TRUE));

    effect eDominate = SupernaturalEffect(EffectCutsceneDominated());
    effect eDominVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDominateLink = EffectLinkEffects(eDominate, eDominVis);

    effect eImpactVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF));

    //Get nearest enemy within 20m (60ft)
    //If you have the Travel domain get the nearest enemy within 25m (80ft)
    float fDistance = 20.0;
    if (GetHasFeat(FEAT_TRAVEL_DOMAIN_POWER))
        fDistance = 25.0;
    object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE , OBJECT_SELF, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
    while(GetIsObjectValid(oTarget) && nHDCount < nTurnHD && GetDistanceToObject(oTarget) <= fDistance)
    {
        //Check to see if the creature is can be turned or is friendly
        //This will prevent creatures thata re already turned from using up HD slots
        if(!GetIsFriend(oTarget) && !GetFactionEqual(oTarget) && !HasTurnedEffect(oTarget) && !GetLocalInt(oTarget,"TurnImmunity"))
        {
            //Check the racial type of the creature. This checks both the race and the classes they have
            //So if a creature has an improperly set race but took undead levels, consider them undead
            nIsUndead=FALSE; nIsVermin=FALSE; nIsElemental=FALSE; nIsConstruct=FALSE; nIsOutsider=FALSE; nIsMagicalBeast=FALSE;
            if(GetRacialCheck(RACIAL_TYPE_UNDEAD, oTarget)) nIsUndead = TRUE;
            if(GetRacialCheck(RACIAL_TYPE_VERMIN, oTarget)) nIsVermin = TRUE;
            if(GetRacialCheck(RACIAL_TYPE_ELEMENTAL, oTarget)) nIsElemental = TRUE;
            if(GetRacialCheck(RACIAL_TYPE_CONSTRUCT, oTarget)) nIsConstruct = TRUE;
            if(GetRacialCheck(RACIAL_TYPE_OUTSIDER, oTarget)) nIsOutsider = TRUE;
            if(GetRacialCheck(RACIAL_TYPE_MAGICAL_BEAST, oTarget)) nIsMagicalBeast = TRUE;

            if (nIsOutsider)
            {
                if (nPlanar)
                {
                    //Planar turning decreases spell resistance against turning by 1/2
                    nHD = GetHitDice(oTarget) + (GetSpellResistance(oTarget) /2) + GetTurnResistanceHD(oTarget);
                }
                else
                {
                    nHD = GetHitDice(oTarget) + (GetSpellResistance(oTarget) + GetTurnResistanceHD(oTarget));
                }
            }
            else //(full turn resistance)
            {
                nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
            }

            if (GetLocalInt(oTarget,"TurnHDOverride") > 0)
            {
                nHD = GetLocalInt(oTarget,"TurnHDOverride");
            }

            nHDModifier = GetTurnModifier(oTarget);
            nHD = nHD - nHDModifier;
            if(nHD < 1)
                nHD = 1;
            if(nHDModifier > 1)
                nTimeModifier = nHDModifier;

            if(nHD <= nTurnLevel && nHD <= (nTurnHD - nHDCount))
            {
                //Check the various domain turning types
                if(nIsUndead)
                {
                    bValid = TRUE;
                }
                else if (nIsVermin && nVermin > 0)
                {
                    bValid = TRUE;
                }
                else if (nIsElemental && nElemental > 0)
                {
                    bValid = TRUE;
                }
                else if (nIsConstruct && nConstructs > 0)
                {
                    //The construct handling code below to prevent redundant code.
                    bValid = TRUE;
                }
                else if (nIsOutsider && (nGoodOrEvilDomain+nPlanar) > 0)
                {
                    bValid = TRUE;
                }
                else if (nIsMagicalBeast && nMagicDomain > 0)
                {
                    bValid = TRUE;
                }
                else if (GetLocalInt(oTarget,"IsTurnable"))
                {
                    bValid = TRUE;
                }
                // * if wearing gauntlets of the lich,then can be turned
                else if (GetIsObjectValid(GetItemPossessedBy(oTarget, "x2_gauntletlich")) == TRUE)
                {
                    if (GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS)) == "x2_gauntletlich")
                    {
                        bValid = TRUE;
                    }
                }

                //Apply results of the turn
                if(bValid == TRUE)
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    //Added Knockdown to the target. The reason behind this is simple, when a cleric
                    //Paladin, ect uses Turn undead, they release a powerful blast of (un)holy energy that
                    //Knocks the creatures off their feet. Also fixes the bug were sometimes the creatures
                    //Still attacked when turned.
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0);

                    //The duration for the turning effect in Rounds
                    nDuration = (nClassLevel + 5)*nTimeModifier;
                    if (nIsConstruct)
                    {
                        //Handle the construct damage here
                        nDamage = d3(nTurnLevel)+nHDModifier;
                        if (nDamage < 1) nDamage = 1;
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    }
                    else if((nClassLevel/2) >= nHD && !GetIsPC(oTarget) && !GetIsAssociate(oTarget, TRUE) && CanCommand(nClassLevel, nHD))
                    {
                        //Dominate the target
                        DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDominateLink, oTarget, RoundsToSeconds(nDuration)));
                        AssignCommand(oTarget, ClearAllActions());
                        SetIsTemporaryFriend(oTarget, OBJECT_SELF, TRUE, RoundsToSeconds(nDuration));
                        AddCommand(nHD);
                        DelayCommand(RoundsToSeconds(nDuration), SubCommand(nHD));
                    }
                    else
                    {
                        //Damage the target if player has the War Domain
                        if (GetHasFeat(FEAT_WAR_DOMAIN_POWER))
                        {
                            nDamage = d6(3)+nHDModifier;
                            if (nDamage < 1) nDamage = 1;
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_DIVINE), oTarget);
                        }
                        //Rebuke the target
                        AssignCommand(oTarget, ClearAllActions());
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRebukeLink, oTarget, RoundsToSeconds(nDuration));
                    }
                    nHDCount = nHDCount + nHD;
                }
            }
            bValid = FALSE;
        }
        nCnt++;
        oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE , OBJECT_SELF, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
    }
}

//Gets all creatures in a 20m radius around the caster and turns them or not.  If the creatures
//HD are 1/2 or less of the nClassLevel then the creature is destroyed.
void TurnUndead(int nTurnLevel, int nTurnHD, int nVermin, int nElemental, int nConstructs, int nGoodOrEvilDomain, int nPlanar, int nMagicDomain, int nClassLevel)
{
    //Declare major variables
    int nCnt = 1;
    int nHDModifier = 0;
    int nTimeModifier = 1;
    int nIsUndead, nIsVermin, nIsElemental, nIsConstruct, nIsOutsider, nIsMagicalBeast;
    int nHD, nHDCount, bValid, nDamage, nDuration;
    nHDCount = 0;
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eUnsummonVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eDamage;
    effect eKnockdown = EffectKnockdown();
    effect eTurned = EffectTurned();
    //Decrease the creatures speed to fix an annoying bug. If you're attacking something with a fear effect in NWN,
    //the game tends to move you close to the target, then stop you, then move the creature away,
    //so you never actually get to ATTACK it even if you're hasted and it's a zombie.
    //Even worse is that creatures that are knocked down magically spring up and run away, and it's just SO annoying.
    effect eSlowDown = EffectMovementSpeedDecrease(50);
    effect eTurnLink = EffectLinkEffects(eVisTurn, eTurned);
    eTurnLink = EffectLinkEffects(eTurnLink, eSlowDown);
    //Made it a supernatural effect so it cant't be dispelled.
    eTurnLink = SupernaturalEffect(eTurnLink);

    effect eDeath = SupernaturalEffect(EffectDeath(TRUE));

    effect eImpactVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF));

    //Get nearest enemy within 20m (65ft)
    //If you have the Travel domain get the nearest enemy within 25m (80ft)
    float fDistance = 20.0;
    if (GetHasFeat(FEAT_TRAVEL_DOMAIN_POWER))
        fDistance = 25.0;
    object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE , OBJECT_SELF, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
    while(GetIsObjectValid(oTarget) && nHDCount < nTurnHD && GetDistanceToObject(oTarget) <= fDistance)
    {
        //Check to see if the creature is can be turned or is friendly
        //This will prevent creatures thata re already turned from using up HD slots
        if(!GetIsFriend(oTarget) && !GetFactionEqual(oTarget) && !HasTurnedEffect(oTarget) && !GetLocalInt(oTarget,"TurnImmunity"))
        {
            //Check the racial type of the creature. This checks both the race and the classes they have
            //So if a creature has an improperly set race but took undead levels, consider them undead
            nIsUndead=FALSE; nIsVermin=FALSE; nIsElemental=FALSE; nIsConstruct=FALSE; nIsOutsider=FALSE; nIsMagicalBeast=FALSE;
            if(GetRacialCheck(RACIAL_TYPE_UNDEAD, oTarget)) nIsUndead = TRUE;
            if(GetRacialCheck(RACIAL_TYPE_VERMIN, oTarget)) nIsVermin = TRUE;
            if(GetRacialCheck(RACIAL_TYPE_ELEMENTAL, oTarget)) nIsElemental = TRUE;
            if(GetRacialCheck(RACIAL_TYPE_CONSTRUCT, oTarget)) nIsConstruct = TRUE;
            if(GetRacialCheck(RACIAL_TYPE_OUTSIDER, oTarget)) nIsOutsider = TRUE;
            if(GetRacialCheck(RACIAL_TYPE_MAGICAL_BEAST, oTarget)) nIsMagicalBeast = TRUE;
/*
//---------Modified for Shayan's Subrace Engine------------//
            if(GetIsPC(oTarget))
            {
                if(Subrace_GetIsUndead(oTarget))
                {
                nIsUndead = TRUE;
                }
            }
//--------------------------End----------------------------//
*/
            if (nIsOutsider)
            {
                if (nPlanar)
                {
                     //Planar turning decreases spell resistance against turning by 1/2
                    nHD = GetHitDice(oTarget) + (GetSpellResistance(oTarget) /2) + GetTurnResistanceHD(oTarget);
                }
                else
                {
                    nHD = GetHitDice(oTarget) + (GetSpellResistance(oTarget) + GetTurnResistanceHD(oTarget));
                }
            }
            else //(full turn resistance)
            {
                nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
            }

            if (GetLocalInt(oTarget,"TurnHDOverride") > 0)
            {
                nHD = GetLocalInt(oTarget,"TurnHDOverride");
            }

            nHDModifier = GetTurnModifier(oTarget);
            nHD = nHD - nHDModifier;
            if(nHD < 1)
                  nHD = 1;
            if(nHDModifier > 1)
                  nTimeModifier = nHDModifier;

            if(nHD <= nTurnLevel && nHD <= (nTurnHD - nHDCount))
           {
                //Check the various domain turning types
//---------Modified for Shayan's Subrace Engine------------//
           /* if(GetIsPC(oTarget))
            {
                if(Subrace_GetIsUndead(oTarget))
                {
                nIsUndead = TRUE;
                }
            } */
//--------------------------End----------------------------//

                if(nIsUndead)
                {
                    bValid = TRUE;
                }
                else if (nIsVermin && nVermin > 0)
                {
                    bValid = TRUE;
                }
                else if (nIsElemental && nElemental > 0)
                {
                    bValid = TRUE;
                }
                else if (nIsConstruct && nConstructs > 0)
                {
                    //The construct handling code below to prevent redundant code.
                    bValid = TRUE;
                }
                else if (nIsOutsider && (nGoodOrEvilDomain+nPlanar) > 0)
                {
                    bValid = TRUE;
                }
                else if (nIsMagicalBeast && nMagicDomain > 0)
                {
                    bValid = TRUE;
                }
                else if (GetLocalInt(oTarget,"IsTurnable"))
                {
                    bValid = TRUE;
                }
                // * if wearing gauntlets of the lich,then can be turned
                else if (GetIsObjectValid(GetItemPossessedBy(oTarget, "x2_gauntletlich")) == TRUE)
                {
                    if (GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS)) == "x2_gauntletlich")
                    {
                        bValid = TRUE;
                    }
                }

                //Apply results of the turn
                if(bValid == TRUE)
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    //Added Knockdown to the target. The reason behind this is simple, when a cleric
                   //Paladin, ect uses Turn undead, they release a powerful blast of (un)holy energy that
                    //Knocks the creatures off their feet. Also fixes the bug were sometimes the creatures
                    //Still attacked when turned.
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0);

                    //The duration for the turning effect in Rounds
                    nDuration = (nClassLevel + 5)*nTimeModifier;
                    if (nIsConstruct)
                    {
                        //Handle the construct damage here
                        nDamage = d3(nTurnLevel)+nHDModifier;
                        if (nDamage < 1) nDamage = 1;
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    }
                    else if((nClassLevel/2) >= nHD)
                    {
                        if (nIsOutsider && (nGoodOrEvilDomain+nPlanar) > 0 || GetIsAssociate(oTarget))
                        {
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eUnsummonVis, oTarget);
                        }

                        //Destroy the target
                        DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    }
                   else
                    {
                        //Damage the target if player has the War Domain
                        if (GetHasFeat(FEAT_WAR_DOMAIN_POWER))
                        {
                            nDamage = d6(3)+nHDModifier;
                            if (nDamage < 1) nDamage = 1;
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_DIVINE), oTarget);
                        }
                        //Turn the target
                        AssignCommand(oTarget, ClearAllActions());
                        AssignCommand(oTarget, ActionMoveAwayFromObject(OBJECT_SELF, TRUE));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTurnLink, oTarget, RoundsToSeconds(nDuration));
                    }
                    nHDCount = nHDCount + nHD;
                }
            }
            bValid = FALSE;
        }
        nCnt++;
        oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE , OBJECT_SELF, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
    }
}

void main()
{
    int nClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC);
    int nPaladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN);
    int nBlackguardlevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
    int nDivineChampionLevel = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION);
    int nTotalLevel = GetHitDice(OBJECT_SELF);

    int nTurnLevel = nClericLevel;
    int nClassLevel = nClericLevel;

    // GZ: Since paladin levels stack when turning, blackguard levels should stack as well
    // GZ: but not with the paladin levels (thus else if).
    if((nBlackguardlevel - 2) > 0 && (nBlackguardlevel > nPaladinLevel))
    {
        nClassLevel += (nBlackguardlevel - 2);
        nTurnLevel  += (nBlackguardlevel - 2);
    }
    else if((nPaladinLevel - 2) > 0)
    {
        nClassLevel += (nPaladinLevel -2);
        nTurnLevel  += (nPaladinLevel - 2);
    }

    //Added Divine Champion/Champion of Torm to the turning levels since they are similar to paladins.
    if(nDivineChampionLevel > 0)
    {
        nClassLevel += nDivineChampionLevel;
        nTurnLevel  += nDivineChampionLevel;
    }

    //Flags for bonus turning types
    int nElemental = GetHasFeat(FEAT_AIR_DOMAIN_POWER) + GetHasFeat(FEAT_EARTH_DOMAIN_POWER) + GetHasFeat(FEAT_FIRE_DOMAIN_POWER) + GetHasFeat(FEAT_WATER_DOMAIN_POWER);
    int nVermin = GetHasFeat(FEAT_PLANT_DOMAIN_POWER) + GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER) + GetHasFeat(FEAT_ANIMAL_COMPANION);
    int nConstructs = GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER);
    int nGoodOrEvilDomain = GetHasFeat(FEAT_GOOD_DOMAIN_POWER) + GetHasFeat(FEAT_EVIL_DOMAIN_POWER);
    int nMagicDomain = GetHasFeat(FEAT_MAGIC_DOMAIN_POWER);
    int nPlanar = GetHasFeat(854); //FEAT_EPIC_PLANAR_TURNING

    //Flag for improved turning ability
    int nSun = GetHasFeat(FEAT_SUN_DOMAIN_POWER);

    //Make a turning check roll, modify if have the Sun Domain
    int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
    int nTurnCheck = d20() + nChrMod;              //The roll to apply to the max HD of undead that can be turned --> nTurnLevel
    int nTurnHD = d6(2) + nChrMod + nClassLevel;   //The number of HD of undead that can be turned.

    if(nSun == TRUE)
    {
        nTurnCheck += d4();
        nTurnHD += d6();
    }

    //Determine the maximum HD of the undead that can be turned.
    if(nTurnCheck <= 0)
    {
        nTurnLevel -= 4;
    }
    else if(nTurnCheck >= 1 && nTurnCheck <= 3)
    {
        nTurnLevel -= 3;
    }
    else if(nTurnCheck >= 4 && nTurnCheck <= 6)
    {
        nTurnLevel -= 2;
    }
    else if(nTurnCheck >= 7 && nTurnCheck <= 9)
    {
        nTurnLevel -= 1;
    }
    else if(nTurnCheck >= 10 && nTurnCheck <= 12)
    {
        //Stays the same
    }
    else if(nTurnCheck >= 13 && nTurnCheck <= 15)
    {
       nTurnLevel += 1;
    }
    else if(nTurnCheck >= 16 && nTurnCheck <= 18)
    {
       nTurnLevel += 2;
    }
    else if(nTurnCheck >= 19 && nTurnCheck <= 21)
    {
        nTurnLevel += 3;
    }
    else if(nTurnCheck >= 22)
    {
        nTurnLevel += 4;
    }

    //Make sure the character's Turning Level is never less than 1.
    if (nTurnLevel < 1)
    {
        nTurnLevel = 1;
    }
    //Check to see if they are an Evil aligned Cleric or have the REBUKE_UNDEAD local int set to true.
    //If so, use rebuke undead instead of turn undead.
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    if(nAlign == ALIGNMENT_EVIL || GetLocalInt(OBJECT_SELF, "REBUKE_UNDEAD") == TRUE)
    {
        RebukeUndead(nTurnLevel, nTurnHD, nVermin, nElemental, nConstructs, nGoodOrEvilDomain, nPlanar, nMagicDomain, nClassLevel);
    }
    else
    {
        TurnUndead(nTurnLevel, nTurnHD, nVermin, nElemental, nConstructs, nGoodOrEvilDomain, nPlanar, nMagicDomain, nClassLevel);
    }
}
