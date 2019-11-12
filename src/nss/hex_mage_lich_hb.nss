#include "nw_i0_generic"
void main()
{

object oSelf = OBJECT_SELF;
int MaxHP = GetMaxHitPoints(OBJECT_SELF);
float castDelay = 2.0;


object oFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND | REPUTATION_TYPE_NEUTRAL, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY | !REPUTATION_TYPE_NEUTRAL | !REPUTATION_TYPE_FRIEND | PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);

object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oSelf, 1);
{
AssignCommand(oSummon, ActionDoCommand(ActionAttack(oTarget, FALSE)));
}

if(GetTag(OBJECT_SELF)=="ArcaneHorror" && GetLocalInt(OBJECT_SELF, "SWITCH_SPELL_CLASS_CD")!=1)
{

int Rand = Random(4);
switch(Rand)
{
case 0:
{
SetLocalInt(OBJECT_SELF, "FIRE", 1);
SetLocalInt(OBJECT_SELF, "COLD", 0);
SetLocalInt(OBJECT_SELF, "ZAP", 0);
SetLocalInt(OBJECT_SELF, "DEATH", 0);
break;
}
case 1:
{
SetLocalInt(OBJECT_SELF, "FIRE", 0);
SetLocalInt(OBJECT_SELF, "COLD", 1);
SetLocalInt(OBJECT_SELF, "ZAP", 0);
SetLocalInt(OBJECT_SELF, "DEATH", 0);
break;
}
case 2:
{
SetLocalInt(OBJECT_SELF, "FIRE", 0);
SetLocalInt(OBJECT_SELF, "COLD", 0);
SetLocalInt(OBJECT_SELF, "ZAP", 1);
SetLocalInt(OBJECT_SELF, "DEATH", 0);
break;
}
case 3:
{
SetLocalInt(OBJECT_SELF, "FIRE", 0);
SetLocalInt(OBJECT_SELF, "COLD", 0);
SetLocalInt(OBJECT_SELF, "ZAP", 0);
SetLocalInt(OBJECT_SELF, "DEATH", 1);
break;
}
}

SetLocalInt(OBJECT_SELF, "SWITCH_SPELL_CLASS_CD", 1);
DelayCommand(9.0, SetLocalInt(OBJECT_SELF, "SWITCH_SPELL_CLASS_CD", 0));
}


// ONCE ONLY CLEAR ALL ACTIONS FOR START OF COMBAT
if((GetIsInCombat(OBJECT_SELF) == TRUE && GetCurrentAction(OBJECT_SELF)!= ACTION_CASTSPELL))
{
ClearAllActions();
}

//SPELL MANTLE
if(GetCurrentHitPoints(oSelf)== MaxHP &&
!GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oSelf))
{
ActionCastSpellAtObject(SPELL_GREATER_SPELL_MANTLE, oSelf);
DelayCommand(castDelay, ClearActions());
}

if(GetCurrentHitPoints(oSelf)== MaxHP &&
!GetHasSpellEffect(FEAT_EPIC_SPELL_EPIC_WARDING, oSelf))
{
ActionCastSpellAtObject(FEAT_EPIC_SPELL_EPIC_WARDING, oSelf);
DelayCommand(castDelay, ClearActions());
}

//TRUE SEEING
if(GetCurrentHitPoints(oSelf)== MaxHP &&
!GetHasSpellEffect(SPELL_TRUE_SEEING, oSelf) &&
GetIsInCombat(oSelf) == FALSE)
{
ClearActions();
ActionCastSpellAtObject(SPELL_TRUE_SEEING, oSelf);
DelayCommand(castDelay, ClearActions());
}


 // MORDSWORD
 if(GetCurrentHitPoints(oSelf)== MaxHP &&
 GetHasSpell(SPELL_MORDENKAINENS_SWORD) > 1 &&
 !GetHasSpellEffect(SPELL_MORDENKAINENS_SWORD, oSelf) &&
 GetTag(OBJECT_SELF)!="DEATH" &&
 GetIsInCombat(oSelf) == FALSE)
            {
            ActionCastSpellAtObject(SPELL_MORDENKAINENS_SWORD, oSelf);
            DelayCommand(castDelay, ClearActions());
            }

 // CREATE UNDEAD IF TAG IS "DEATH"
 if(GetCurrentHitPoints(oSelf)== MaxHP &&
 GetHasSpell(SPELL_CREATE_UNDEAD) > 1 &&
 !GetHasSpellEffect(SPELL_CREATE_UNDEAD, oSelf) &&
 GetTag(OBJECT_SELF)=="DEATH" &&
 GetIsInCombat(oSelf) == FALSE)
            {
            ActionCastSpellAtObject(SPELL_CREATE_UNDEAD, oSelf);
            DelayCommand(castDelay, ClearActions());
            }

// INVIS
if(GetCurrentHitPoints(oSelf)== MaxHP &&
!GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oSelf) &&
GetIsInCombat(oSelf) == FALSE)
{
ClearActions();
ActionCastSpellAtObject(SPELL_INVISIBILITY_SPHERE, oSelf);
DelayCommand(castDelay, ClearActions());
}

if(GetCurrentHitPoints(oSelf)== MaxHP &&
!GetHasSpellEffect(SPELL_DISPLACEMENT, oSelf) &&
GetIsInCombat(oSelf) == FALSE)
{
ClearActions();
ActionCastSpellAtObject(SPELL_DISPLACEMENT, oSelf);
DelayCommand(castDelay, ClearActions());
}


//ACID SHIELD
if(GetCurrentHitPoints(oSelf)== MaxHP &&
!GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oSelf) &&
GetIsInCombat(oSelf) == FALSE)
{
ClearActions();
ActionCastSpellAtObject(SPELL_MESTILS_ACID_SHEATH, oSelf);
DelayCommand(castDelay, ClearActions());
}
//ACID SHIELD

//ETHEREAL VISAGE
if(GetCurrentHitPoints(oSelf)== MaxHP &&
!GetHasSpellEffect(SPELL_ETHEREAL_VISAGE, oSelf) &&
GetIsInCombat(oSelf) == FALSE)
{
ClearActions();
ActionCastSpellAtObject(SPELL_ETHEREAL_VISAGE, oSelf);
DelayCommand(castDelay, ClearActions());
}
//ETHEREAL VISAGE

//PREMO
if(GetCurrentHitPoints(oSelf)== MaxHP &&
!GetHasSpellEffect(SPELL_PREMONITION, oSelf) &&
GetIsInCombat(oSelf) == FALSE)
{
ClearActions();
ActionCastSpellAtObject(SPELL_PREMONITION, oSelf);
DelayCommand(castDelay, ClearActions());
}
//PREMO

//ENERGY BUFFER
if(GetCurrentHitPoints(oSelf)== MaxHP &&
!GetHasSpellEffect(SPELL_ENERGY_BUFFER, oSelf) &&
GetIsInCombat(oSelf) == FALSE)
{
ClearActions();
ActionCastSpellAtObject(SPELL_ENERGY_BUFFER, oSelf);
DelayCommand(castDelay, ClearActions());
}
//ENERGY BUFFER

if(!GetIsInCombat())
{
WalkWayPoints();
}

if(!GetIsInCombat())
{
ActionRandomWalk();
}

//*****************FIND TRAPS*******************
object oTrap = GetLastTrapDetected(OBJECT_SELF);
//object oTrap = GetNearestTrapToObject(oSelf, FALSE);

if(GetSkillRank(SKILL_SET_TRAP, oTarget, TRUE) >= 30 &&
   GetCurrentAction(oTarget) == ACTION_SETTRAP &&
   GetHasSpell(SPELL_FIND_TRAPS, oSelf) > 0)
{
ClearActions();
DelayCommand(4.0, ActionCastSpellAtObject(SPELL_FIND_TRAPS, oSelf));
DelayCommand(7.0, ClearActions());
}

if(GetTrapDetectedBy(oTrap, OBJECT_SELF) &&
GetHasSpell(SPELL_FIND_TRAPS, OBJECT_SELF) > 0)
{
ClearActions();
ActionCastSpellAtObject(SPELL_FIND_TRAPS, OBJECT_SELF);
DelayCommand(castDelay, ClearActions());
}
//*****************FIND TRAPS*******************


if (GetCurrentHitPoints() < MaxHP  &&
    !GetIsInCombat() ||
    GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, oSelf) < 1 &&
    !GetIsInCombat() ||
    GetHasSpell(SPELL_HORRID_WILTING, oSelf) < 1 &&
    !GetIsInCombat() ||
    GetHasSpell(SPELL_FINGER_OF_DEATH, oSelf) < 1 &&
    !GetIsInCombat() ||
    GetHasSpell(SPELL_ISAACS_GREATER_MISSILE_STORM, oSelf) < 1 &&
    !GetIsInCombat() ||
    GetHasSpell(SPELL_LESSER_SPELL_MANTLE, oSelf) < 1 &&
    !GetIsInCombat() ||
    GetHasSpell(SPELL_ICE_STORM, oSelf) < 1 &&
    !GetIsInCombat() ||
    GetHasSpell(SPELL_NEGATIVE_ENERGY_BURST, oSelf) < 1 &&
    !GetIsInCombat() ||
    GetHasSpell(SPELL_BALAGARNSIRONHORN, oSelf) < 1)
      {
      ClearActions();
      ActionRest(TRUE);
      }
}
