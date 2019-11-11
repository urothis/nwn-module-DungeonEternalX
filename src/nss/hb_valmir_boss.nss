#include "NW_I0_GENERIC"

void SpawnCopy()  // spawns copy of velmir, this copy will be destroyed if damaged or targetted by a spell. the copy is an illusion
{
location lLocation = GetLocation(OBJECT_SELF);
object oSpawnVelmir = CreateObject(OBJECT_TYPE_CREATURE, "valmirboss", lLocation, FALSE, "ValmirBossV");
effect eVFX = EffectVisualEffect(VFX_IMP_CHARM);
DelayCommand(0.50, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oSpawnVelmir));
DelayCommand(0.50, DetermineCombatRound(oSpawnVelmir));
}

void SpawnRavenousBat()  // spawns a ravenous bat, which is an extremely fast moving killer with high attacks per round.
{
object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF);
ActionAttack(oTarget, FALSE);

location lLocation = GetLocation(OBJECT_SELF);
object oSpawnBats = CreateObject(OBJECT_TYPE_CREATURE, "RavenousBat", lLocation, FALSE);
effect eVFX = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
DelayCommand(0.50, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oSpawnBats));
DelayCommand(0.25, AssignCommand(oSpawnBats, ActionAttack(oTarget)));
DelayCommand(11.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oSpawnBats));
if(GetTag(oSpawnBats)=="RavenousBat")
{
DelayCommand(12.0, DestroyObject(oSpawnBats));
}
}

void SafeJump()
{
object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
if(oTarget!=OBJECT_INVALID && GetArea(oTarget)==GetArea(OBJECT_SELF) && !GetIsDead(oTarget))
{
JumpToObject(oTarget);
}
}

// KILL SHOUT  KILL SHOUT  KILL SHOUT  KILL SHOUT  KILL SHOUT  KILL SHOUT  KILL SHOUT  KILL SHOUT  KILL SHOUT  KILL SHOUT  KILL SHOUT
void KillShout(object oKiller, object oPCKilled, object oAreaZ)
{

    string sKiller = GetName(oKiller);
    string sPC = GetName(oPCKilled);
    string sArea = GetName(oAreaZ);
    string sShout;

if(GetLocalInt(oPCKilled, "KILLED_BY_BOSS")!=1 && GetIsDead(oPCKilled))
{
SetLocalInt(oPCKilled, "KILLED_BY_BOSS", 1);
sShout = "I have skewered " + sPC + " at " + sArea;
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


void main()   // VOID MAIN VOID MAIN VOID MAIN VOID MAIN VOID MAIN *****************************************************************************************************************
{

// BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT
object  oPCKilled = GetLastPlayerDied();
object  oKiller = GetLastHostileActor(oPCKilled);
object oAreaZ = GetArea(oPCKilled);
object oTargetHiding = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_NOT_SEEN);

if(oKiller==OBJECT_SELF)
{
KillShout(oKiller, oPCKilled, oAreaZ);
DelayCommand(1.0, KillShout(oKiller, oPCKilled, oAreaZ));
DelayCommand(2.0, KillShout(oKiller, oPCKilled, oAreaZ));
DelayCommand(3.0, KillShout(oKiller, oPCKilled, oAreaZ));
DelayCommand(4.0, KillShout(oKiller, oPCKilled, oAreaZ));
DelayCommand(5.0, KillShout(oKiller, oPCKilled, oAreaZ));
}
// BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT BOSS KILL SHOUT



// *************************************** check to see how many velmirs are currently in the area. if there are less than 2, spawn 5 illusions  ***********************************************
object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
if(GetLocalInt(OBJECT_SELF, "BATS_ACTIVE")!=1)
{
ActionAttack(oTarget, FALSE);
}

object oArea = GetArea(OBJECT_SELF);
int iCount=0;
object oObject = GetFirstObjectInArea(oArea);
while(oObject!=OBJECT_INVALID)
{
oObject = GetNextObjectInArea(oArea);
    if(GetTag(oObject)=="ValmirBoss" || GetTag(oObject)=="ValmirBossV")
    {
    iCount++;
    }
}
if(iCount<2 && GetTag(OBJECT_SELF)=="ValmirBoss" && GetLocalInt(OBJECT_SELF, "SPAWN_COPY_CD")!=1 && GetLocalInt(OBJECT_SELF, "BATS_ACTIVE")!=1)   // make sure bats aren't active while spawning clones.
{
int i;
for(i=1;i<=5;i++)
{
DelayCommand((IntToFloat(i)/2),SpawnCopy());
}
SetLocalInt(OBJECT_SELF, "SPAWN_COPY_CD", 1);
DelayCommand(60.00, SetLocalInt(OBJECT_SELF, "SPAWN_COPY_CD", 0));
}
else
{
}
// *************************************** check to see how many velmirs are currently in the area. if there are less than 2, spawn 5 illusions  ***********************************************

//***********************TELEPORT TO THINGS HIDING BEHIND WALLS**********************************
    {

    if(GetDistanceToObject(oTargetHiding) <= 20.0 &&
    GetDistanceToObject(oTargetHiding) >= 2.0 &&
    !GetObjectSeen(oTarget, OBJECT_SELF) &&
    GetLocalInt(OBJECT_SELF, "TELEPORT_UNSEEN")!=1 &&
    GetLocalInt(OBJECT_SELF, "TELEPORT_ENABLED")==1)
    {
    ClearAllActions();
    ActionCastFakeSpellAtObject(SPELL_GREATER_PLANAR_BINDING, OBJECT_SELF);

    effect eVFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, OBJECT_SELF, 1.0));

    eVFX = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX, OBJECT_SELF));

    location lLocation = GetLocation(oTargetHiding);

    DelayCommand(2.0, ActionJumpToLocation(lLocation));
    DelayCommand(2.0, ClearActions());
    SetLocalInt(OBJECT_SELF, "TELEPORT_UNSEEN", 1);
    DelayCommand(9.0, SetLocalInt(OBJECT_SELF, "TELEPORT_UNSEEN", 0));
    }

    }
//***********************TELEPORT TO THINGS HIDING BEHIND WALLS**********************************

// ***************************************************************** teleport illusion copy to main boss, so copies dont get lost and become useless ******************************************
object oVelmirActual = GetObjectByTag("ValmirBoss");
if(GetTag(OBJECT_SELF)=="ValmirBossV" && GetDistanceToObject(oVelmirActual)>=5.00)
{
effect eVFX = EffectVisualEffect(VFX_IMP_CHARM);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
JumpToObject(oVelmirActual);
}
// ***************************************************************** teleport illusion copy to main boss, so copies dont get lost and become useless ******************************************

// REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST
if(!GetIsInCombat() && GetCurrentHitPoints(OBJECT_SELF)<GetMaxHitPoints(OBJECT_SELF)) // boss rests if not in combat and if its HP is less than maximum
{
ActionRest();
}
// REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST REST

// **************************************************** H E A L S E L F if below quarter HP, CD set to 30.00 seconds currently. H E A L S E L F **********************************************************************
if(GetIsInCombat() && (GetCurrentHitPoints(OBJECT_SELF)<=(GetMaxHitPoints(OBJECT_SELF)/2)) && GetLocalInt(OBJECT_SELF, "SELF_HEAL_CD")!=1)
{
ClearAllActions();
ActionCastSpellAtObject(SPELL_HARM, OBJECT_SELF);
SetLocalInt(OBJECT_SELF, "SELF_HEAL_CD", 1);
DelayCommand(12.0, SetLocalInt(OBJECT_SELF, "SELF_HEAL_CD", 0));
}
// **************************************************** H E A L S E L F if below quarter HP, CD set to 30.00 seconds currently. H E A L S E L F **********************************************************************



// **************************************************************** SPAWN RAVENOUS BATS ***********************************************************************************************
if(GetIsInCombat() && GetCurrentHitPoints(OBJECT_SELF)<GetMaxHitPoints(OBJECT_SELF) && GetLocalInt(OBJECT_SELF, "BAT_SPAWNER_CD")!=1 && GetTag(OBJECT_SELF)=="ValmirBoss")
{

object oArea = GetArea(OBJECT_SELF);
int iCountBats=0;
object oObject = GetFirstObjectInArea(oArea);
while(oObject!=OBJECT_INVALID)
{
oObject = GetNextObjectInArea(oArea);
    if(GetTag(oObject)=="RavenousBat")
    {
    iCountBats++;
    }
}

effect eCutInvis = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
effect eDarkness = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_DARKNESS));

if(iCountBats<=30)// if there are less than 30 ravenous bats in the area, spawn 10 ravenous bats
{
ClearAllActions();
int Bat;
for(Bat=1;Bat<=10;Bat++)
{
DelayCommand((IntToFloat(Bat)/10), SpawnRavenousBat());
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDarkness, OBJECT_SELF, 1.5);
DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCutInvis, OBJECT_SELF, 10.5));
DelayCommand(12.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDarkness, OBJECT_SELF, 1.5));
SetLocalInt(OBJECT_SELF, "BATS_ACTIVE", 1);
DelayCommand(15.0, SetLocalInt(OBJECT_SELF, "BATS_ACTIVE", 0));
}
ActionWait(12.0);
DelayCommand(12.5, SafeJump());


SetLocalInt(OBJECT_SELF, "BAT_SPAWNER_CD", 1);
DelayCommand(36.00+IntToFloat(Random(21)), SetLocalInt(OBJECT_SELF, "BAT_SPAWNER_CD", 0));
}
}
// **************************************************************** SPAWN RAVENOUS BATS ***********************************************************************************************


}
