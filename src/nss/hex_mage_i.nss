#include "nw_i0_generic"
#include "nw_i0_spells"

void KillShout(object oKiller, object oPCKilled, object oArea)
{

    string sKiller = GetName(oKiller);
    string sPC = GetName(oPCKilled);
    string sArea = GetName(oArea);
    string sShout;

if(GetLocalInt(oPCKilled, "KILLED_BY_BOSS")!=1 && GetIsDead(oPCKilled))
{
SetLocalInt(oPCKilled, "KILLED_BY_BOSS", 1);
sShout = "I have annihilated " + sPC + " at " + sArea;
SpeakString(sShout, TALKVOLUME_SHOUT);
SetLocalInt(OBJECT_SELF, "PLAYERS_KILLED_BY_BOSS", GetLocalInt(OBJECT_SELF, "PLAYERS_KILLED_BY_BOSS")+1);
}
else if(GetLocalInt(oPCKilled, "KILLED_BY_BOSS")==1 && !GetIsDead(oPCKilled))
{
SetLocalInt(oPCKilled, "KILLED_BY_BOSS", 0);
}
else
{
return;
}

}

void CanBeDisabled(object oTarget)
{


if(GetHasSpellEffect(SPELL_DOMINATE_MONSTER, oTarget) ||
   GetHasSpellEffect(SPELL_MASS_CHARM, oTarget) ||
   GetHasSpellEffect(SPELL_CONFUSION, oTarget))
   {
   SetLocalInt(oTarget, "CAN_BE_DISABLED", 1);
   }
   else
   {
   SetLocalInt(oTarget, "CAN_BE_DISABLED", 0);
   DelayCommand(30.00, SetLocalInt(oTarget, "CAN_BE_DISABLED", 0));
   }

}



void main()
{
object oFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND | REPUTATION_TYPE_NEUTRAL, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
object oTargetHiding = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_NOT_SEEN);
object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
object oSummonEnemy = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
object oSummonAlly = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF);
object oMaster = GetMaster(oTarget);
object oSelf = OBJECT_SELF;
float fDelay = GetRandomDelay(2.0, 3.0);
int MaxHP = GetMaxHitPoints(OBJECT_SELF);

float fDistance = GetDistanceToObject(oTarget);
int Boolean = (fDistance<=20.0);
int HitpointsoTarget = GetCurrentHitPoints(oTarget);


object  oPCKilled = GetLastPlayerDied();
object  oKiller = GetLastHostileActor(oPCKilled);
object oArea = GetArea(oPCKilled);

if(oKiller==OBJECT_SELF)
{
KillShout(oKiller, oPCKilled, oArea);
DelayCommand(1.0, KillShout(oKiller, oPCKilled, oArea));
DelayCommand(2.0, KillShout(oKiller, oPCKilled, oArea));
DelayCommand(3.0, KillShout(oKiller, oPCKilled, oArea));
DelayCommand(4.0, KillShout(oKiller, oPCKilled, oArea));
DelayCommand(5.0, KillShout(oKiller, oPCKilled, oArea));
}



//***************** oTarget HasEffectsCheck ***********************
// BREACH LIST
int HasLesserMantle = GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget);                        // LESSER SPELL MANTLE
int HasMantle = GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget);                                     // SPELL MANTLE
int HasGreaterMantle = GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget);                      // GREATER SPELL MANTLE
int HasNegProt = GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget);                      // NEGATIVE ENERGY PROT
int HasShadowShield = GetHasSpellEffect(SPELL_SHADOW_SHIELD, oTarget);                              // SHADOW SHIELD
int HasNeBProt = GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_BURST, oTarget);                           // NEGATIVE ENERGY BURST
int HasGlobe = GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget);                          // GLOBE OF INVULNERABILITY
int HasMinorGlobe = GetHasSpellEffect(SPELL_MINOR_GLOBE_OF_INVULNERABILITY, oTarget);               // MINOR GLOBE OF INVULNERABILITY
int HasSpellResistance = GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget);                        // SPELL RESISTANCE
int HasLesserMindBlank = GetHasSpellEffect(SPELL_LESSER_MIND_BLANK, oTarget);                       // LESSER MIND BLANK
int HasMindBlank = GetHasSpellEffect(SPELL_MIND_BLANK, oTarget);                                    // MIND BLANK
int HasEleShield = GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget);
int HasAcidShield = GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oTarget);
int HasEtherealVisage = GetHasSpellEffect(SPELL_ETHEREAL_VISAGE, oTarget);
int HasGhostVisage = GetHasSpellEffect(SPELL_GHOSTLY_VISAGE, oTarget);
int HasProtFromEle = GetHasSpellEffect(SPELL_PROTECTION_FROM_ELEMENTS, oTarget);
int HasEnergyBuffer = GetHasSpellEffect(SPELL_ENERGY_BUFFER, oTarget);


//NOT BREACHABLE
int HasUEF = GetHasSpellEffect(SPELL_UNDEATHS_ETERNAL_FOE, oTarget);                                // UNDEATHS ETHERNAL FOE
int HasGreatShadowConj = GetHasSpellEffect(SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE, oTarget);  // GREATER SHADOW CONJURATION
int HasDisplace = GetHasSpellEffect(SPELL_DISPLACEMENT, oTarget);                                   // DISPLACEMENT
int HasImpInvis = GetHasSpellEffect(SPELL_IMPROVED_INVISIBILITY, oTarget);                          // IMPROVED INVISIBILITY
int HasDeathWard = GetHasSpellEffect(SPELL_DEATH_WARD, oTarget);                                    // DEATHWARD
int HasClarity = GetHasSpellEffect(SPELL_CLARITY, oTarget);                                         // CLARITY
int HasProtEvil = GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oTarget);                           // PROTECTION FROM EVIL
int HasTrueSeeing = GetHasSpellEffect(SPELL_TRUE_SEEING, oTarget);                                  // TRUE SEEING
int HasSeeInvis = GetHasSpellEffect(SPELL_SEE_INVISIBILITY, oTarget);                               // SEE INVISIBILITY

//SUMMONS
int HasIXSummon = GetHasSpellEffect(SPELL_SUMMON_CREATURE_IX, oTarget);
int HasVIIISummon = GetHasSpellEffect(SPELL_SUMMON_CREATURE_VIII, oTarget);
int HasVIISummon = GetHasSpellEffect(SPELL_SUMMON_CREATURE_VII, oTarget);
int HasVISummon = GetHasSpellEffect(SPELL_SUMMON_CREATURE_VI, oTarget);
int HasVSummon = GetHasSpellEffect(SPELL_SUMMON_CREATURE_V, oTarget);
int HasIVSummon = GetHasSpellEffect(SPELL_SUMMON_CREATURE_IV, oTarget);
int HasIIISummon = GetHasSpellEffect(SPELL_SUMMON_CREATURE_III, oTarget);
int HasIISummon = GetHasSpellEffect(SPELL_SUMMON_CREATURE_II, oTarget);
int HasISummon = GetHasSpellEffect(SPELL_SUMMON_CREATURE_I, oTarget);
int HasCreateUndead = GetHasSpellEffect(SPELL_CREATE_UNDEAD, oTarget);
int HasCreateGreaterUndead = GetHasSpellEffect(SPELL_CREATE_GREATER_UNDEAD, oTarget);
int HasAnimateDead = GetHasSpellEffect(SPELL_ANIMATE_DEAD, oTarget);
int HasMordeSword = GetHasSpellEffect(SPELL_MORDENKAINENS_SWORD, oTarget);
int HasBladeofDisaster = GetHasSpellEffect(SPELL_BLACK_BLADE_OF_DISASTER, oTarget);
int HasGreaterPlanarBinding = GetHasSpellEffect(SPELL_GREATER_PLANAR_BINDING, oTarget);
int HasPlanarBinding = GetHasSpellEffect(SPELL_PLANAR_BINDING, oTarget);
int HasLesserPlanarBinding = GetHasSpellEffect(SPELL_LESSER_PLANAR_BINDING, oTarget);
//***************** oTarget HasEffectsCheck ***********************


// ********************************DETECT TRAPS AND REMOVE TRAPS *************************************
object oTrap = GetLastTrapDetected(OBJECT_SELF);

if(GetTrapDetectedBy(oTrap, OBJECT_SELF) &&
GetHasSpell(SPELL_FIND_TRAPS, OBJECT_SELF) > 0)
{
ClearActions();
ActionCastSpellAtObject(SPELL_FIND_TRAPS, OBJECT_SELF);
DelayCommand(fDelay, ClearActions());
}
// ********************************DETECT TRAPS AND REMOVE TRAPS *************************************

//****************** TELEPORT TO RUNNERS ************************
if(GetDistanceToObject(oTarget) >= 20.0 &&
GetCurrentHitPoints(OBJECT_SELF) >= 200 &&
GetSkillRank(SKILL_SET_TRAP, oPC, TRUE) < 40 &&
GetLocalInt(OBJECT_SELF, "TELEPORT_LONG")!=1 &&
GetLocalInt(OBJECT_SELF, "TELEPORT_ENABLED")==1)
{
ClearAllActions();
ActionCastFakeSpellAtObject(SPELL_GREATER_PLANAR_BINDING, OBJECT_SELF);

effect eVFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oSelf, 1.0));

eVFX = EffectVisualEffect(VFX_FNF_PWKILL);
DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oSelf));

DelayCommand(2.0, ActionJumpToObject(oPC));
DelayCommand(2.0, ClearActions());
SetLocalInt(OBJECT_SELF, "TELEPORT_LONG", 1);
DelayCommand(4.5, SetLocalInt(OBJECT_SELF, "TELEPORT_LONG", 0));
}
//****************** TELEPORT TO RUNNERS ************************

//***********************TELEPORT TO THINGS HIDING BEHIND WALLS**********************************
if(GetDistanceToObject(oTargetHiding) <= 15.0 &&
GetDistanceToObject(oTargetHiding) >= 3.0 &&
!GetObjectSeen(oTarget, OBJECT_SELF) &&
GetLocalInt(OBJECT_SELF, "TELEPORT_UNSEEN")!=1 &&
GetLocalInt(OBJECT_SELF, "TELEPORT_ENABLED")==1)
{
ClearAllActions();
ActionCastFakeSpellAtObject(SPELL_GREATER_PLANAR_BINDING, OBJECT_SELF);

effect eVFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, OBJECT_SELF, 1.0));

eVFX = EffectVisualEffect(VFX_FNF_PWKILL);
DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX, OBJECT_SELF));

location lLocation = GetLocation(oTargetHiding);

DelayCommand(2.0, ActionJumpToLocation(lLocation));
DelayCommand(2.0, ClearActions());
SetLocalInt(OBJECT_SELF, "TELEPORT_UNSEEN", 1);
DelayCommand(9.0, SetLocalInt(OBJECT_SELF, "TELEPORT_UNSEEN", 0));
}
//***********************TELEPORT TO THINGS HIDING BEHIND WALLS**********************************


// *************************TELEPORT TO PC IF BEING COUNTERED************************************************************************************
int i = 1;
object oTargetCounterer = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
while(GetIsObjectValid(oTargetCounterer) && !GetActionMode(oTargetCounterer, ACTION_MODE_COUNTERSPELL))
{
oTargetCounterer = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i++, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
}

        if(GetActionMode(oTargetCounterer, ACTION_MODE_COUNTERSPELL) && GetDistanceToObject(oTargetCounterer) >= 3.0)
        {
              ClearAllActions();
              ActionCastFakeSpellAtObject(SPELL_GREATER_PLANAR_BINDING, OBJECT_SELF);

              effect eVFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
              DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, OBJECT_SELF, 1.0));

              eVFX = EffectVisualEffect(VFX_FNF_PWSTUN);
              DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX, OBJECT_SELF));

              DelayCommand(2.0, ActionJumpToObject(oTargetCounterer));
              DelayCommand(2.0, ClearActions());
        }

        //                          ATTACK IF STILL BEING COUNTERED AT CLOSE RANGE
        if(GetActionMode(oTargetCounterer, ACTION_MODE_COUNTERSPELL) && GetDistanceToObject(oTargetCounterer) <= 3.0)
        {
        ActionAttack(oTargetCounterer);
        }

// *************************TELEPORT TO PC IF BEING COUNTERED************************************************************************************


// ***************** DISPEL PC ON COOLDOWN ***************************
{
int i = 1;
object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 20.0)
    {

       if(GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, OBJECT_SELF) > 0 &&
          HasNegProt&&
          GetLocalInt(oTarget, "MORD_COOLDOWN")!=1 ||
          HasShadowShield&&
          GetLocalInt(oTarget, "MORD_COOLDOWN")!=1  ||
          HasGlobe&&
          GetLocalInt(oTarget, "MORD_COOLDOWN")!=1 ||
          HasSpellResistance&&
          GetLocalInt(oTarget, "MORD_COOLDOWN")!=1 ||
          HasEleShield&&
          GetLocalInt(oTarget, "MORD_COOLDOWN")!=1 ||
          HasDeathWard&&
          GetLocalInt(oTarget, "MORD_COOLDOWN")!=1||
          HasUEF&&
          GetLocalInt(oTarget, "MORD_COOLDOWN")!=1 ||
          HasTrueSeeing&&
          GetLocalInt(oTarget, "MORD_COOLDOWN")!=1 ||
          HasClarity&&
          GetLocalInt(oTarget, "MORD_COOLDOWN")!=1 ||
          HasImpInvis &&
          GetLocalInt(oTarget, "MORD_COOLDOWN")!=1)
         {
         ActionCastSpellAtObject(SPELL_MORDENKAINENS_DISJUNCTION, oTarget);
         SetLocalInt(oTarget, "MORD_COOLDOWN", 1);
         DelayCommand(30.0, SetLocalInt(oTarget, "MORD_COOLDOWN", 0));
         DelayCommand(fDelay, ClearActions());
         }
oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i++, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
    }
}
// ***************** DISPEL PC ON COOLDOWN ***************************


//******************************** KILL LARGE NUMBER OF LIVING ENEMIES ***************************
{
int i = 1;
int n = 0;
object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 15.0 && oTarget!=OBJECT_SELF)
{
oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i++, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
n++;
}
oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
if(n>=3 &&
GetLocalInt(OBJECT_SELF, "CAST_WAIL")!=1 &&
!GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) &&
!GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) &&
!GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) &&
!GetHasSpellEffect(SPELL_DEATH_WARD, oTarget) &&
!GetHasSpellEffect(SPELL_SHADOW_SHIELD, oTarget) &&
!GetHasSpellEffect(SPELL_UNDEATHS_ETERNAL_FOE, oTarget) &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
GetRacialType(oTarget)!=RACIAL_TYPE_CONSTRUCT &&
oTarget!=OBJECT_SELF)
{
ActionCastSpellAtObject(SPELL_WAIL_OF_THE_BANSHEE, oTarget);
SetLocalInt(OBJECT_SELF, "CAST_WAIL", 1);
DelayCommand(12.0, SetLocalInt(OBJECT_SELF, "CAST_WAIL", 0));
DelayCommand(fDelay, ClearActions());
}

}
//******************************** KILL LARGE NUMBER OF LIVING ENEMIES ***************************

//************************* CAST THUNDERCLAP ON LARGE NUMBER OF ENEMIES **********************
{
int i = 1;
int n = 0;
object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 15.0 && oTarget!=OBJECT_SELF)
{
oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i++, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
n++;
}
oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
 if       (n>=3 &&
           GetHasSpell(SPELL_GREAT_THUNDERCLAP, oSelf) > 0 &&
          !GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) &&
          !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) &&
          !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) &&
          !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) &&
          !GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
           GetLocalInt(OBJECT_SELF, "THUNDER_CLAP_CD")!=1 &&
           GetDistanceToObject(oTarget) <= 20.0 &&
           oTarget!=OBJECT_SELF
           )

{
ActionCastSpellAtObject(SPELL_GREAT_THUNDERCLAP, oTarget);
SetLocalInt(OBJECT_SELF, "THUNDER_CLAP_CD", 1);
DelayCommand(9.0, SetLocalInt(OBJECT_SELF, "THUNDER_CLAP_CD", 0));
DelayCommand(fDelay, ClearAllActions());
}
}
//************************* CAST THUNDERCLAP ON LARGE NUMBER OF ENEMIES **********************

// **************************** SPAM MANTLE IF HAS DAMAGE VULNS ****************************
    effect eLoop = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(eLoop))
    {
    if(GetEffectType(eLoop) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE)
    {
    if(!GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, OBJECT_SELF))
    {
    ActionCastSpellAtObject(SPELL_GREATER_SPELL_MANTLE, OBJECT_SELF);
    DelayCommand(fDelay, ClearActions());
    }
    break;
    }
    eLoop = GetNextEffect(OBJECT_SELF);
    }
// **************************** SPAM MANTLE IF HAS DAMAGE VULNS ****************************

//********************************* HORN ******************************
if(     GetHasSpell(SPELL_BALAGARNSIRONHORN, OBJECT_SELF) > 0 &&
        GetAbilityScore(oTarget, ABILITY_STRENGTH, FALSE) <= 24 &&
        GetAbilityScore(oTarget, ABILITY_DEXTERITY, FALSE) <= 24 &&
        !GetHasFeat(FEAT_WEAPON_FINESSE, oTarget) &&
        !GetHasFeat(FEAT_STRENGTH_DOMAIN_POWER, oTarget) &&
        !GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_1, oTarget) &&
        !GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN) &&
        !GetHasSpellEffect(SPELL_GHOSTLY_VISAGE, oTarget) &&
        !GetHasSpellEffect(SPELL_ETHEREAL_VISAGE, oTarget) &&
        !GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget) &&
        !GetHasSpellEffect(SPELL_GREAT_THUNDERCLAP, oTarget) &&
        !GetHasSpellEffect(SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE, oTarget) &&
        !GetHasSpellEffect(SPELL_MINOR_GLOBE_OF_INVULNERABILITY, oTarget) &&
        !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget)&&
        !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) &&
        !GetHasSpellEffect(SPELL_HOLD_MONSTER, oTarget) &&
        !GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
         GetDistanceToObject(oTarget)<=10.0 &&
         GetLocalInt(OBJECT_SELF, "THUNDER_CLAP_CD")!=1 &&
         GetCurrentHitPoints(oTarget) >=1
        )

    {
    ActionCastSpellAtObject(SPELL_BALAGARNSIRONHORN, OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "THUNDER_CLAP_CD", 1);
    if(GetTag(OBJECT_SELF)=="ArcaneHorror" || GetLocalInt(OBJECT_SELF, "ARCANE_HORROR")==1)
    {DelayCommand(11.0, SetLocalInt(OBJECT_SELF, "THUNDER_CLAP_CD", 0));}
    else{DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "THUNDER_CLAP_CD", 0));}
    DelayCommand(fDelay, ClearActions());
    }
//********************************* HORN ******************************


// OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL
if(!HasTrueSeeing && !HasSeeInvis && !GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, OBJECT_SELF))
{
ActionCastSpellAtObject(SPELL_INVISIBILITY_SPHERE, OBJECT_SELF);
DelayCommand(fDelay, ClearActions());
}

if(!HasTrueSeeing && GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, OBJECT_SELF) && !GetHasSpellEffect(SPELL_TRUE_SEEING, OBJECT_SELF))
{
ActionCastSpellAtObject(SPELL_TRUE_SEEING, OBJECT_SELF);
DelayCommand(fDelay, ClearActions());
}




//********************** HIDE IN PLAIN SIGHT **********************
if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && GetCurrentAction(OBJECT_SELF)!= ACTION_CASTSPELL)
{
SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
}
//********************** HIDE IN PLAIN SIGHT **********************


//*************** DELAYED BLAST FIREBALL **********************
if(GetHasSpell(SPELL_WAIL_OF_THE_BANSHEE, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_DRAGON_IMMUNE_PARALYSIS, oTarget) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_1, oTarget) &&
!GetHasFeat(FEAT_FIRE_DOMAIN_POWER, oTarget) &&
!HasEleShield &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasGlobe &&
GetResRef(OBJECT_SELF)=="oversoul_necro_h" &&
HasUEF
)
         {
         ActionCastSpellAtObject(SPELL_DELAYED_BLAST_FIREBALL, oTarget, METAMAGIC_EMPOWER);
         DelayCommand(fDelay, ClearActions());
         }
//*************** DELAYED BLAST FIREBALL **********************

// OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL OVERSOUL

 if(GetHasSpell(SPELL_CREATE_UNDEAD) >= 1 &&
   !GetHasSpellEffect(SPELL_CREATE_UNDEAD, OBJECT_SELF) &&
    GetHasSpellEffect(SPELL_IMPROVED_INVISIBILITY, OBJECT_SELF) &&
   !HasTrueSeeing &&
   GetResRef(OBJECT_SELF)!="libraryattendant" &&
    d3(1)==3)
            {
            ActionCastSpellAtObject(SPELL_CREATE_UNDEAD, OBJECT_SELF);
            DelayCommand(0.5, DetermineCombatRound(oSummonAlly));
            DelayCommand(fDelay, ClearActions());
            }

// ONCE ONLY CLEAR ALL ACTIONS FOR START OF COMBAT
if((GetIsInCombat(OBJECT_SELF) == TRUE && GetCurrentAction(OBJECT_SELF)!= ACTION_CASTSPELL))
{
ClearAllActions();
}


//********************************* DISPEL SUMMONS *********************************************
if(
!GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oSummonEnemy) &&
!GetHasSpellEffect(SPELL_SPELL_MANTLE, oSummonEnemy) &&
!GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oSummonEnemy))
{
ActionCastSpellAtObject(SPELL_DISMISSAL, oSummonEnemy);
DelayCommand(fDelay, ClearActions());
}
//********************************* DISPEL SUMMONS *********************************************

// ARCANE HORROR ARCANE HORROR ARCANE HORROR ARCANE HORROR ARCANE HORROR ARCANE HORROR ARCANE HORROR ARCANE HORROR

//*************** PHANTASMAL KILLER **********************

if(GetHasSpell(SPELL_PHANTASMAL_KILLER, OBJECT_SELF) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasShadowShield &&
!HasNegProt &&
!HasUEF &&
!HasClarity &&
!HasMindBlank &&
!HasLesserMindBlank &&
!HasEtherealVisage &&
!HasGlobe &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
(GetTag(OBJECT_SELF)=="ARCANE_HORROR" || GetLocalInt(OBJECT_SELF, "ARCANE_HORROR")==1) &&
GetDistanceToObject(oTarget) <= 8.0 &&
GetLocalInt(oTarget, "PHANTASMAL_SPELL_CD")!=1)
         {
         ActionCastSpellAtObject(SPELL_PHANTASMAL_KILLER, oTarget);
         SetLocalInt(oTarget, "PHANTASMAL_SPELL_CD", 1);
         DelayCommand(3.0, SetLocalInt(oTarget, "PHANTASMAL_SPELL_CD", 0));
         DelayCommand(fDelay, ClearActions());
         }

//*************** PHANTASMAL KILLER **********************

//*************** WEIRD **********************

if(GetHasSpell(SPELL_WEIRD, OBJECT_SELF) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasShadowShield &&
!HasNegProt &&
!HasUEF &&
!HasClarity &&
!HasMindBlank &&
!HasLesserMindBlank &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
(GetTag(OBJECT_SELF)=="ARCANE_HORROR" || GetLocalInt(OBJECT_SELF, "ARCANE_HORROR")==1) &&
GetDistanceToObject(oTarget) <= 7.0 &&
GetLocalInt(oTarget, "WEIRD_SPELL_CD")!=1)
         {
         ActionCastSpellAtObject(SPELL_WEIRD, oTarget);
         SetLocalInt(oTarget, "WEIRD_SPELL_CD", 1);
         DelayCommand(3.0, SetLocalInt(oTarget, "WEIRD_SPELL_CD", 0));
         DelayCommand(fDelay, ClearActions());
         }

//*************** WEIRD **********************


// ARCANE HORROR ARCANE HORROR ARCANE HORROR ARCANE HORROR ARCANE HORROR ARCANE HORROR ARCANE HORROR ARCANE HORROR

// GREATER SUCCUBUS GREATER SUCCUBUS GREATER SUCCUBUS GREATER SUCCUBUS GREATER SUCCUBUS GREATER SUCCUBUS GREATER SUCCUBUS


//*************** ENERGY DRAIN **********************

if(GetHasSpell(SPELL_ENERGY_DRAIN, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasGlobe &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasShadowShield &&
!HasNegProt &&
!HasUEF &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
(GetTag(OBJECT_SELF)=="GREATER_SUCCUBUS" || GetLocalInt(OBJECT_SELF, "GREATER_SUCCUBUS")==1) &&
GetDistanceToObject(oTarget) <= 7.0 &&
GetLocalInt(oTarget, "ENERGY_DRAIN_USED")!=1)
         {
         ActionCastSpellAtObject(SPELL_ENERGY_DRAIN, oTarget);
         SetLocalInt(oTarget, "ENERGY_DRAIN_USED", 1);
         DelayCommand(30.0, SetLocalInt(oTarget, "ENERGY_DRAIN_USED", 0));
         DelayCommand(fDelay, ClearActions());
         }

//*************** ENERGY DRAIN **********************

//*************** FINGER OF DEATH **********************
if(GetHasSpell(SPELL_WEIRD, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasGlobe &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasShadowShield &&
!HasNegProt &&
!HasUEF &&
!HasDeathWard &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
GetRacialType(oTarget)!=RACIAL_TYPE_CONSTRUCT &&
(GetTag(OBJECT_SELF)=="GREATER_SUCCUBUS" || GetLocalInt(OBJECT_SELF, "GREATER_SUCCUBUS")==1) &&
GetDistanceToObject(oTarget) <= 8.0)
         {
         ActionCastSpellAtObject(SPELL_FINGER_OF_DEATH, oTarget, METAMAGIC_EMPOWER);
         DelayCommand(fDelay, ClearActions());
         }
//*************** FINGER OF DEATH **********************

//*************** DOMINATE MONSTER **********************
if(GetHasSpell(SPELL_DOMINATE_MONSTER, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasClarity &&
!HasMindBlank &&
!HasLesserMindBlank &&
!HasProtFromEle &&
!GetHasSpellEffect(SPELL_DOMINATE_MONSTER, oTarget) &&
!GetHasSpellEffect(SPELL_MASS_CHARM, oTarget) &&
!GetHasSpellEffect(SPELL_CONFUSION, oTarget) &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
GetRacialType(oTarget)!=RACIAL_TYPE_CONSTRUCT &&
!GetHasFeat(FEAT_PERFECT_SELF, oTarget) &&
GetWillSavingThrow(oTarget)<=45 &&
(GetTag(OBJECT_SELF)=="ENCHANTER" || GetLocalInt(OBJECT_SELF, "ENCHANTER")==1) &&
GetDistanceToObject(oTarget) <= 18.0 &&
d100(1)>=50)
         {
         ActionCastSpellAtObject(SPELL_DOMINATE_MONSTER, oTarget);
         DelayCommand(fDelay, ClearAllActions());
         }
//*************** DOMINATE MONSTER **********************

//*************** MASS CHARM **********************
if(GetHasSpell(SPELL_MASS_CHARM, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasClarity &&
!HasMindBlank &&
!HasLesserMindBlank &&
!HasProtFromEle &&
GetWillSavingThrow(oTarget)<=40 &&
!GetHasSpellEffect(SPELL_DOMINATE_MONSTER, oTarget) &&
!GetHasSpellEffect(SPELL_MASS_CHARM, oTarget) &&
!GetHasSpellEffect(SPELL_CONFUSION, oTarget) &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
GetRacialType(oTarget)!=RACIAL_TYPE_CONSTRUCT &&
!GetHasFeat(FEAT_PERFECT_SELF, oTarget) &&
(GetTag(OBJECT_SELF)=="ENCHANTER" || GetLocalInt(OBJECT_SELF, "ENCHANTER")==1) &&
GetDistanceToObject(oTarget) <= 7.0 &&
d100(1)>=25)
         {
         ActionCastSpellAtObject(SPELL_MASS_CHARM, oTarget);
         DelayCommand(fDelay, ClearAllActions());
         }
//*************** MASS CHARM **********************


//*************** CONFUSION **********************
if(GetHasSpell(SPELL_CONFUSION, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasClarity &&
!HasMindBlank &&
!HasLesserMindBlank &&
!HasProtFromEle &&
GetWillSavingThrow(oTarget)<=40 &&
!GetHasSpellEffect(SPELL_DOMINATE_MONSTER, oTarget) &&
!GetHasSpellEffect(SPELL_MASS_CHARM, oTarget) &&
!GetHasSpellEffect(SPELL_CONFUSION, oTarget) &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
GetRacialType(oTarget)!=RACIAL_TYPE_CONSTRUCT &&
!GetHasFeat(FEAT_PERFECT_SELF, oTarget) &&
(GetTag(OBJECT_SELF)=="ENCHANTER" || GetLocalInt(OBJECT_SELF, "ENCHANTER")==1) &&
GetDistanceToObject(oTarget) <= 18.0 &&
d100(1)>=50)
         {
         ActionCastSpellAtObject(SPELL_CONFUSION, oTarget);
         DelayCommand(fDelay, ClearAllActions());
         }
//*************** CONFUSION **********************



// GREATER SUCCUBUS GREATER SUCCUBUS GREATER SUCCUBUS GREATER SUCCUBUS GREATER SUCCUBUS GREATER SUCCUBUS GREATER SUCCUBUS

// FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE




//*************** METEOR SWARM **********************
if(GetHasSpell(VFX_FNF_METEOR_SWARM, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_DRAGON_IMMUNE_PARALYSIS, oTarget) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!HasEleShield &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
(GetTag(OBJECT_SELF)=="FIRE" || GetLocalInt(OBJECT_SELF, "FIRE")==1) &&
GetDistanceToObject(oTarget) >= 5.0 &&
GetDistanceToObject(oTarget) <= 10.0)
         {
         ActionCastSpellAtObject(SPELL_METEOR_SWARM, OBJECT_SELF);
         DelayCommand(fDelay, ClearActions());
         }
//*************** METEOR SWARM **********************

//*************** FIREBRAND **********************
if(GetHasSpell(SPELL_HORRID_WILTING, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_DRAGON_IMMUNE_PARALYSIS, oTarget) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!HasEleShield &&
!HasMantle &&
!HasEtherealVisage &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasGlobe &&
(GetTag(OBJECT_SELF)=="FIRE" || GetLocalInt(OBJECT_SELF, "FIRE")==1) &&
GetDistanceToObject(oTarget) >= 15.0 &&
         (d100()<=75))
         {
         ActionCastSpellAtObject(SPELL_FIREBRAND, oTarget, METAMAGIC_MAXIMIZE);
         DelayCommand(fDelay, ClearActions());
         }
//*************** FIREBRAND **********************

//*************** FLAME ARROW **********************
if(GetHasSpell(SPELL_ISAACS_GREATER_MISSILE_STORM, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_EPIC_ENERGY_RESISTANCE_FIRE_1, oTarget) &&
!GetHasFeat(FEAT_DRAGON_IMMUNE_PARALYSIS, oTarget) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!HasEleShield &&
!HasGlobe &&
!HasMinorGlobe &&
!HasEtherealVisage &&
!HasGhostVisage &&
!HasGreatShadowConj &&
(GetTag(OBJECT_SELF)=="FIRE" || GetLocalInt(OBJECT_SELF, "FIRE")==1) &&
(d100()<=25))

         {
         ActionCastSpellAtObject(SPELL_FLAME_ARROW, oTarget, METAMAGIC_MAXIMIZE);
         DelayCommand(fDelay, ClearActions());
         }
//*************** FLAME ARROW **********************

//*************** DELAYED BLAST FIREBALL **********************
if(GetHasSpell(SPELL_WAIL_OF_THE_BANSHEE, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_DRAGON_IMMUNE_PARALYSIS, oTarget) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!HasEleShield &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasGlobe &&
(GetTag(OBJECT_SELF)=="FIRE" || GetLocalInt(OBJECT_SELF, "FIRE")==1) &&
         (d100()<=100))
         {
         ActionCastSpellAtObject(SPELL_DELAYED_BLAST_FIREBALL, oTarget, METAMAGIC_EMPOWER);
         DelayCommand(fDelay, ClearActions());
         }
//*************** DELAYED BLAST FIREBALL **********************

//*************** ACID FOG **********************
if(GetHasSpell(SPELL_POWER_WORD_KILL, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_EPIC_ENERGY_RESISTANCE_ACID_1, oTarget) &&
 GetDistanceToObject(oTarget) >= 6.7 &&
(GetTag(OBJECT_SELF)=="FIRE" || GetLocalInt(OBJECT_SELF, "FIRE")==1) &&
         (d100()<=20)
         && GetLocalInt(OBJECT_SELF, "AcidFogCount")==0)
         {
         ActionCastSpellAtObject(SPELL_ACID_FOG, oTarget, METAMAGIC_MAXIMIZE);
         DelayCommand(3.0, SetLocalInt(OBJECT_SELF, "AcidFogCount", 1));
         DelayCommand(30.0, SetLocalInt(OBJECT_SELF, "AcidFogCount", 0));
         DelayCommand(fDelay, ClearActions());
         }
//*************** ACID FOG **********************

// FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE FIRE

// ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP

//*************** PRISMATIC SPRAY **********************
if(GetHasSpell(SPELL_FINGER_OF_DEATH, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasGlobe &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
(GetTag(OBJECT_SELF)=="ZAP" || GetLocalInt(OBJECT_SELF, "ZAP")==1) &&
GetDistanceToObject(oTarget) <= 7.0 &&
         (d100()<=50))
         {
         ActionCastSpellAtObject(SPELL_PRISMATIC_SPRAY, oTarget);
         DelayCommand(fDelay, ClearActions());
         }
//*************** PRISMATIC SPRAY **********************

//*************** SCINTILLATING SPHERE **********************
if(GetHasSpell(SPELL_CHAIN_LIGHTNING, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!HasGlobe &&
!HasMantle &&
!HasEtherealVisage &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasGreatShadowConj &&
(GetTag(OBJECT_SELF)=="ZAP" || GetLocalInt(OBJECT_SELF, "ZAP")==1) &&
         (d100()<=30))
         {
         ActionCastSpellAtObject(SPELL_SCINTILLATING_SPHERE, oTarget, METAMAGIC_MAXIMIZE);
         DelayCommand(fDelay, ClearActions());
         }
//*************** SCINTILLATING SPHERE **********************

//*************** BALL LIGHTNING **********************
if(GetHasSpell(SPELL_HORRID_WILTING, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!HasGlobe &&
!HasMantle &&
!HasEtherealVisage &&
!HasGreaterMantle &&
!HasLesserMantle &&
(GetTag(OBJECT_SELF)=="ZAP" || GetLocalInt(OBJECT_SELF, "ZAP")==1) &&
         (d100()<=40))
         {
         ActionCastSpellAtObject(SPELL_BALL_LIGHTNING, oTarget, METAMAGIC_MAXIMIZE);
         DelayCommand(fDelay, ClearActions());
         }
//*************** BALL LIGHTNING **********************

//*************** CHAIN LIGHTNING **********************
if(GetHasSpell(SPELL_METEOR_SWARM, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!HasGlobe &&
!HasMantle &&
!HasEtherealVisage &&
!HasGreaterMantle &&
!HasLesserMantle &&
(GetTag(OBJECT_SELF)=="ZAP" || GetLocalInt(OBJECT_SELF, "ZAP")==1) &&
         (d100()<=100))
         {
         ActionCastSpellAtObject(SPELL_CHAIN_LIGHTNING, oTarget, METAMAGIC_MAXIMIZE);
         DelayCommand(fDelay, ClearActions());
         }
//*************** CHAIN LIGHTNING **********************

// ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP ZAP

// COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD

/*
//*************** RAY OF FROST **********************
if(GetHasSpell(SPELL_LIGHTNING_BOLT) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!HasGlobe &&
!HasMinorGlobe &&
!HasEtherealVisage &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasGhostVisage &&
!HasGreatShadowConj &&
(GetTag(OBJECT_SELF)=="COLD" || GetLocalInt(OBJECT_SELF, "COLD")==1) &&
         (d100()<=30))
         {
         ActionCastSpellAtObject(SPELL_RAY_OF_FROST, oTarget, METAMAGIC_MAXIMIZE);
         DelayCommand(fDelay, ClearActions());
         }
//*************** RAY OF FROST **********************

//*************** ICE DAGGER **********************
if(GetHasSpell(SPELL_CONE_OF_COLD) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!HasGlobe &&
!HasMinorGlobe &&
!HasEtherealVisage &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasGreatShadowConj &&
(GetTag(OBJECT_SELF)=="COLD" || GetLocalInt(OBJECT_SELF, "COLD")==1) &&
GetDistanceToObject(oTarget) <= 7.0 &&
         (d100()<=40))
         {
         ActionCastSpellAtObject(SPELL_ICE_DAGGER, oTarget, METAMAGIC_MAXIMIZE);
         DelayCommand(fDelay, ClearActions());
         }
//*************** ICE DAGGER **********************
*/

//*************** CONE OF COLD **********************
if(GetHasSpell(SPELL_FINGER_OF_DEATH) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
!HasGlobe &&
!HasMinorGlobe &&
!HasEtherealVisage &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
(GetTag(OBJECT_SELF)=="COLD" || GetLocalInt(OBJECT_SELF, "COLD")==1) &&
GetDistanceToObject(oTarget) <= 7.0 &&
         (d100()<=75))
         {
         ActionCastSpellAtObject(SPELL_CONE_OF_COLD, oTarget, METAMAGIC_EMPOWER);
         DelayCommand(fDelay, ClearActions());
         }
//*************** CONE_OF_COLD **********************

//******************** CAST ICE STORM *****************************
// OFFENSIVE & %CHANCE
      if(GetHasSpell(SPELL_FINGER_OF_DEATH, oSelf) > 1 &&
        !GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
        !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) &&
        !GetHasSpellEffect(SPELL_ENERGY_BUFFER, oTarget) &&
        !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) &&
        !GetHasSpellEffect(SPELL_PROTECTION_FROM_ELEMENTS, oTarget) &&
        !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) &&
        !HasEtherealVisage &&
        !GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
        (GetTag(OBJECT_SELF)=="COLD" || GetLocalInt(OBJECT_SELF, "COLD")==1) &&
         GetDistanceToObject(oTarget) >= 6.7 &&
         (d100()<=50))


{
ActionCastSpellAtObject(SPELL_ICE_STORM, oTarget, METAMAGIC_MAXIMIZE);
DelayCommand(fDelay, ClearActions());
{
if(      HitpointsoTarget < HitpointsoTarget &&
         GetHasSpell(SPELL_FINGER_OF_DEATH, oSelf) > 1 &&
         !GetHasFeat(FEAT_EPIC_DWARVEN_DEFENDER, oTarget) &&
        !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) &&
        !GetHasSpellEffect(SPELL_ENERGY_BUFFER, oTarget) &&
        !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) &&
        !GetHasSpellEffect(SPELL_PROTECTION_FROM_ELEMENTS, oTarget) &&
        !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) &&
        !HasEtherealVisage &&
        !GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
        (GetTag(OBJECT_SELF)=="COLD" || GetLocalInt(OBJECT_SELF, "COLD")==1) &&
         GetDistanceToObject(oTarget) >= 6.7)
         {
ActionCastSpellAtObject(SPELL_ICE_STORM, oTarget, METAMAGIC_MAXIMIZE);
DelayCommand(fDelay, ClearActions());
}
}
DelayCommand(fDelay, ClearActions());

if (GetHasSpell(SPELL_FINGER_OF_DEATH, oSelf) < 1  &&
    GetHasSpell(SPELL_ISAACS_GREATER_MISSILE_STORM, oSelf) > 1)
         {
         ActionCastSpellAtObject(SPELL_ICE_STORM, oTarget, METAMAGIC_EMPOWER);
         DelayCommand(fDelay, ClearActions());
         }

}
//******************** CAST ICE STORM *****************************

// COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD COLD

// DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH

//*************** ENERGY DRAIN **********************

if(GetHasSpell(SPELL_ENERGY_DRAIN, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasGlobe &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasShadowShield &&
!HasNegProt &&
!HasUEF &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
(GetTag(OBJECT_SELF)=="DEATH" || GetLocalInt(OBJECT_SELF, "DEATH")==1) &&
GetDistanceToObject(oTarget) <= 7.0 &&
GetLocalInt(oTarget, "ENERGY_DRAIN_USED")!=1)
         {
         ActionCastSpellAtObject(SPELL_ENERGY_DRAIN, oTarget);
         SetLocalInt(oTarget, "ENERGY_DRAIN_USED", 1);
         DelayCommand(60.0, SetLocalInt(oTarget, "ENERGY_DRAIN_USED", 0));
         DelayCommand(fDelay, ClearActions());
         }

//*************** ENERGY DRAIN **********************

//*************** FINGER OF DEATH **********************
if(GetHasSpell(SPELL_WEIRD, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasGlobe &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasShadowShield &&
!HasNegProt &&
!HasUEF &&
!HasDeathWard &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
GetRacialType(oTarget)!=RACIAL_TYPE_CONSTRUCT &&
(GetTag(OBJECT_SELF)=="DEATH" || GetLocalInt(OBJECT_SELF, "DEATH")==1) &&
GetDistanceToObject(oTarget) <= 8.0)
         {
         ActionCastSpellAtObject(SPELL_FINGER_OF_DEATH, oTarget, METAMAGIC_EMPOWER);
         DelayCommand(fDelay, ClearActions());
         }
//*************** FINGER OF DEATH **********************

/*
// ******************* CAST CIRCLE OF DOOM ***************************
       if(GetHasSpell(SPELL_CIRCLE_OF_DOOM, oSelf) > 0 &&
         !GetHasSpellEffect(SPELL_SHADOW_SHIELD, oPC)   &&
         !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oPC)  &&
         !GetHasSpellEffect(SPELL_SPELL_MANTLE, oPC)  &&
         !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oPC) &&
         !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oPC) &&
         !GetHasSpellEffect(SPELL_UNDEATHS_ETERNAL_FOE, oPC) &&
         !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oPC) &&
         !GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oPC) &&
         !GetHasSpellEffect(SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE, oPC) &&
         !GetHasSpellEffect(SPELL_MINOR_GLOBE_OF_INVULNERABILITY, oPC)&&
         !HasEtherealVisage &&
         !GetIsImmune(oPC, EFFECT_TYPE_SPELL_IMMUNITY) &&
          GetRacialType(oPC) != RACIAL_TYPE_UNDEAD &&
          GetDistanceToObject(oPC) <= 20.0 &&
          (d100()<=30))
         {
         ActionCastSpellAtObject(SPELL_CIRCLE_OF_DOOM, oPC, METAMAGIC_MAXIMIZE);
         DelayCommand(fDelay, ClearActions());
         }
// ******************* CAST CIRCLE OF DOOM ***************************
*/

//*************** NEGATIVE ENERGY BURST **********************

if(GetHasSpell(SPELL_TRUE_SEEING, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasGlobe &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasShadowShield &&
!HasEtherealVisage &&
!HasNegProt &&
!HasUEF &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
(GetTag(OBJECT_SELF)=="DEATH" || GetLocalInt(OBJECT_SELF, "DEATH")==1) &&
         (d100()<=25))
         {
         ActionCastSpellAtObject(SPELL_NEGATIVE_ENERGY_BURST, oTarget, METAMAGIC_MAXIMIZE);
         DelayCommand(fDelay, ClearActions());
         }
//*************** NEGATIVE ENERGY BURST **********************

//*************** HORRID WILTING **********************
if(GetHasSpell(SPELL_HORRID_WILTING, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasShadowShield &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
(GetTag(OBJECT_SELF)=="DEATH" || GetLocalInt(OBJECT_SELF, "DEATH")==1) &&
         (d100()<=10))
         {
         ActionCastSpellAtObject(SPELL_HORRID_WILTING, oTarget);
         DelayCommand(fDelay, ClearActions());
         }
//*************** HORRID WILTING **********************




// DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH DEATH


 // *******Stop PC from cheesing AI too much *********
if(GetLastSpell()== SPELL_INCENDIARY_CLOUD &&
   GetLastSpell()== SPELL_INCENDIARY_CLOUD ||
   GetLastSpell()== SPELL_ACID_FOG &&
   GetLastSpell()== SPELL_ACID_FOG ||
   GetLastSpell()== SPELL_STORM_OF_VENGEANCE &&
   GetLastSpell()== SPELL_STORM_OF_VENGEANCE ||
   GetLastSpell()== SPELL_CLOUDKILL&&
   GetLastSpell()== SPELL_CLOUDKILL ||
   GetLastSpell()== SPELL_STONEHOLD &&
   GetLastSpell()== SPELL_STONEHOLD ||
   GetLastSpell()== SPELL_BLADE_BARRIER &&
   GetLastSpell()== SPELL_BLADE_BARRIER ||
   GetHasSpellEffect(SPELL_INCENDIARY_CLOUD, OBJECT_SELF) ||
   GetHasSpellEffect(SPELL_ACID_FOG, OBJECT_SELF) ||
   GetHasSpellEffect(SPELL_STORM_OF_VENGEANCE, OBJECT_SELF) ||
   GetHasSpellEffect(SPELL_CLOUDKILL, OBJECT_SELF)||
   GetHasSpellEffect(SPELL_STONEHOLD, OBJECT_SELF) ||
   GetHasSpellEffect(SPELL_BLADE_BARRIER, OBJECT_SELF) ||
   GetHasSpellEffect(SPELL_SILENCE, OBJECT_SELF))
{
if(GetLocalInt(OBJECT_SELF, "GUST_CD")!=1)
{
ActionCastSpellAtObject(SPELL_GUST_OF_WIND, OBJECT_SELF);
SetLocalInt(OBJECT_SELF, "GUST_CD", 1);
DelayCommand(7.0, SetLocalInt(OBJECT_SELF, "GUST_CD", 0));
DelayCommand(fDelay, ClearAllActions());
}
}
 // *******Stop PC from cheesing AI too much *********


//*************** FINGER OF DEATH **********************
if(GetHasSpell(SPELL_WEIRD, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasGlobe &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasShadowShield &&
!HasNegProt &&
!HasUEF &&
!HasDeathWard &&
GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD &&
GetRacialType(oTarget)!=RACIAL_TYPE_CONSTRUCT &&
GetDistanceToObject(oTarget) <= 8.0)
         {
         ActionCastSpellAtObject(SPELL_FINGER_OF_DEATH, oTarget, METAMAGIC_EMPOWER);
         DelayCommand(fDelay, ClearActions());
         }
//*************** FINGER OF DEATH **********************


//*************** IGMS WHEN CLOSE ENOUGH **********************
      if(GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, oSelf) > 0 &&
        !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) &&
        !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) &&
        !GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
         GetDistanceToObject(oTarget) <= 6.7 &&
         (d100()<=50))

{
ActionCastSpellAtObject(SPELL_ISAACS_GREATER_MISSILE_STORM, oTarget, METAMAGIC_MAXIMIZE);
DelayCommand(fDelay, ClearActions());

if(GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, oSelf) < 1)
{
ActionCastSpellAtObject(SPELL_ISAACS_GREATER_MISSILE_STORM, oTarget, METAMAGIC_EMPOWER);
DelayCommand(fDelay, ClearActions());
}
}
//*************** IGMS WHEN CLOSE ENOUGH **********************



//*************** CLOUDKILL **********************
if(GetHasSpell(SPELL_HORRID_WILTING, oSelf) > 0 &&
!GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
!HasMantle &&
!HasGreaterMantle &&
!HasLesserMantle &&
!HasEnergyBuffer &&
!HasProtFromEle &&
!GetHasFeat(FEAT_EPIC_ENERGY_RESISTANCE_ACID_1, oTarget) &&
GetDistanceToObject(oTarget) >= 6.7 &&
         (d100()<=20))
         {
         ActionCastSpellAtObject(SPELL_CLOUDKILL, oTarget, METAMAGIC_MAXIMIZE);
         DelayCommand(fDelay, ClearActions());
         }
//*************** CLOUDKILL **********************

//******************** CAST ICE STORM *****************************
// OFFENSIVE & %CHANCE
      if(GetHasSpell(SPELL_FINGER_OF_DEATH, oSelf) > 1 &&
        !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) &&
        !GetHasSpellEffect(SPELL_ENERGY_BUFFER, oTarget) &&
        !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) &&
        !GetHasSpellEffect(SPELL_PROTECTION_FROM_ELEMENTS, oTarget) &&
        !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) &&
        !GetHasSpellEffect(SPELL_ETHEREAL_VISAGE, oTarget) &&
        !GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
        !GetHasFeat(FEAT_EPIC_ENERGY_RESISTANCE_COLD_2, oTarget) &&
         GetDistanceToObject(oTarget) >= 6.7 &&
         (d100()<=50))
{
ActionCastSpellAtObject(SPELL_ICE_STORM, oTarget, METAMAGIC_MAXIMIZE);
DelayCommand(fDelay, ClearActions());
{
if(      HitpointsoTarget < HitpointsoTarget &&
         GetHasSpell(SPELL_FINGER_OF_DEATH, oSelf) > 1 &&
        !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) &&
        !GetHasSpellEffect(SPELL_ENERGY_BUFFER, oTarget) &&
        !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) &&
        !GetHasSpellEffect(SPELL_PROTECTION_FROM_ELEMENTS, oTarget) &&
        !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) &&
        !GetHasSpellEffect(SPELL_ETHEREAL_VISAGE, oTarget) &&
        !GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
         GetDistanceToObject(oTarget) >= 6.7)
         {
ActionCastSpellAtObject(SPELL_ICE_STORM, oTarget, METAMAGIC_MAXIMIZE);
DelayCommand(fDelay, ClearActions());
}
}
DelayCommand(fDelay, ClearActions());

if (GetHasSpell(SPELL_FINGER_OF_DEATH, oSelf) < 1  &&
    GetHasSpell(SPELL_ISAACS_GREATER_MISSILE_STORM, oSelf) > 1)
         {
         ActionCastSpellAtObject(SPELL_ICE_STORM, oTarget, METAMAGIC_EMPOWER);
         DelayCommand(fDelay, ClearActions());
         }

}
//******************** CAST ICE STORM *****************************


// *****************CAST SPELL MANTLE AS PRIMARY BUFF SPELL_MANTLE ***************
if(!GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oSelf))
{

ActionCastSpellAtObject(SPELL_GREATER_SPELL_MANTLE, oSelf);
if( GetHasSpell(SPELL_GREATER_SPELL_MANTLE) < 1 &&
   !GetHasSpellEffect(SPELL_SPELL_MANTLE, oSelf))
{

ActionCastSpellAtObject(SPELL_SPELL_MANTLE, oSelf);
if( GetHasSpell(SPELL_SPELL_MANTLE) < 1 &&
   !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oSelf))
{

ActionCastSpellAtObject(SPELL_LESSER_SPELL_MANTLE, oSelf);

if( GetHasSpell(SPELL_HORRID_WILTING) < 1 &&
   !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oSelf))
{

ActionCastSpellAtObject(SPELL_LESSER_SPELL_MANTLE, oSelf, METAMAGIC_MAXIMIZE);
DelayCommand(fDelay, ClearActions());
}
DelayCommand(fDelay, ClearActions());
}
DelayCommand(fDelay, ClearActions());
}
DelayCommand(fDelay, ClearActions());
}
// *****************CAST SPELL MANTLE AS PRIMARY BUFF SPELL_MANTLE ***************




// ***************** DISPEL PC ***************************
       {
       if(GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, oSelf) > 0 &&
          GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget)  ||
          GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget)  ||
          GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) ||
          GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget) ||
          GetHasSpellEffect(SPELL_SHADOW_SHIELD, oTarget)  ||
          GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget) ||
          GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) ||
          GetHasSpellEffect(SPELL_ENERGY_BUFFER, oTarget) &&
          GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) ||
          GetHasSpellEffect(SPELL_PROTECTION_FROM_ELEMENTS, oTarget) &&
          GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) ||
          GetHasSpellEffect(SPELL_DEATH_WARD, oTarget) &&
          GetDistanceToObject(oTarget) <= 20.0)




         {
         ActionCastSpellAtObject(SPELL_MORDENKAINENS_DISJUNCTION, oTarget);
         DelayCommand(fDelay, ClearActions());
         }
// ***************** DISPEL PC ***************************



//******** USER LESSER BREACH WHEN OUT OF MORD **************
          if(GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, oSelf) < 1 &&
             GetHasSpell(SPELL_LESSER_SPELL_BREACH, oSelf) > 0 &&
             GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget)  ||
             GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget)  ||
             GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) ||
             GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget) ||
             GetHasSpellEffect(SPELL_SHADOW_SHIELD, oTarget)  ||
             GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget) ||
             GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) ||
             GetHasSpellEffect(SPELL_ENERGY_BUFFER, oTarget) &&
             GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) ||
             GetHasSpellEffect(SPELL_PROTECTION_FROM_ELEMENTS, oTarget) &&
             GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget))

         {
         ActionCastSpellAtObject(SPELL_LESSER_SPELL_BREACH, oTarget);
         DelayCommand(fDelay, ClearActions());
}
}
//******** USER LESSER BREACH WHEN OUT OF MORD **************


//******************** CAST ICE STORM *****************************




      if(GetHasSpell(SPELL_FINGER_OF_DEATH, oSelf) > 1 &&
        !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) &&
        !GetHasSpellEffect(SPELL_SUMMON_CREATURE_IX, oSelf)  &&
        !GetHasSpellEffect(SPELL_ENERGY_BUFFER, oTarget) &&
        !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) &&
        !GetHasSpellEffect(SPELL_PROTECTION_FROM_ELEMENTS, oTarget) &&
        !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget) &&
        !GetHasSpellEffect(SPELL_ETHEREAL_VISAGE, oTarget) &&
        !GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
         GetDistanceToObject(oTarget) >= 6.7)

{
ActionCastSpellAtObject(SPELL_ICE_STORM, oTarget, METAMAGIC_MAXIMIZE);
DelayCommand(fDelay, ClearActions());

if (GetHasSpell(SPELL_FINGER_OF_DEATH, oSelf) < 1  &&
    GetHasSpell(SPELL_ISAACS_GREATER_MISSILE_STORM, oSelf) > 1)
         {
         ActionCastSpellAtObject(SPELL_ICE_STORM, oTarget, METAMAGIC_EMPOWER);
         DelayCommand(fDelay, ClearActions());
         }
}
//******************** CAST ICE STORM *****************************


//*************** IGMS  **********************
   if(   GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, oSelf) > 0 &&
        !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) &&
        !GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oTarget) &&
        !HasGlobe &&
        !GetIsImmune(oTarget, EFFECT_TYPE_SPELL_IMMUNITY) &&
        !GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget))

{
ActionCastSpellAtObject(SPELL_ISAACS_GREATER_MISSILE_STORM, oTarget, METAMAGIC_MAXIMIZE);
DelayCommand(fDelay, ClearActions());
if(GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, oSelf) < 1)
{
ActionCastSpellAtObject(SPELL_ISAACS_GREATER_MISSILE_STORM, oTarget, METAMAGIC_EMPOWER);
DelayCommand(fDelay, ClearActions());
}
}
//*************** IGMS  **********************

}






