#include "gen_inc_color"
#include "_functions"

const int RUNE_EFFECT_SAVES = 1;
const int RUNE_EFFECT_REGENERATION = 2;
const int RUNE_EFFECT_CONCEALMENT = 3;
const int RUNE_EFFECT_ARMOR_BONUS = 4;
const int RUNE_EFFECT_ELEMENTAL_BONUS = 5;
const int RUNE_EFFECT_IMMUNE_DEATH = 6;
const int RUNE_EFFECT_IMMUNE_MIND = 7;
const int RUNE_EFFECT_IMMUNE_KD = 8;
const int RUNE_EFFECT_ELEMENTAL_DAMAGE_RESISTANCE = 9;
const int RUNE_EFFECT_ELEMENTAL_SHIELD = 10;
const int RUNE_EFFECT_SPELL_RESISTANCE = 11;
const int RUNE_EFFECT_SKILL_INCREASE = 12;
const int RUNE_EFFECT_FORTITUDE_INCREASE = 13;
const int RUNE_EFFECT_REFLEX_INCREASE = 14;
const int RUNE_EFFECT_WILL_INCREASE = 15;
const int RUNE_EFFECT_PHYSICAL_DAMAGE_RESISTANCE = 16;
const int RUNE_EFFECT_RARE_DAMAGE_RESISTANCE = 17;
const int RUNE_EFFECT_SKILL_DISCIPLINE_INCREASE = 18;
const int RUNE_EFFECT_SKILL_STEALTH_INCREASE = 19;
const int RUNE_EFFECT_SKILL_SEEKER_INCREASE = 20;
const int RUNE_EFFECT_SKILL_TAUNT_INCREASE = 21;
const int RUNE_EFFECT_PHYSICAL_SHIELD = 22;
const int RUNE_EFFECT_RARE_SHIELD = 23;
const int RUNE_EFFECT_PHYSICAL_BONUS = 24;
const int RUNE_EFFECT_RARE_BONUS = 25;


const int RUNE_EFFECT_RANDOM = 0;  // when used in SpawnRune, generates a random effect for the rune
const int RUNE_MAX_EFFECT_ID = 25; // largest value of RUNE_EFFECT_* (for finding a random effect)

const float RUNE_DURATION    = 1800.0; // how long does the rune effect last?
const float RUNE_HEARTBEAT   = 60.0;  // how often to check if the rune has expired
const float RUNE_RESPAWNTIME = 1860.0; // how long before a rune respawns after it is taken
const float RUNE_DESPAWNTIME = 180.0;  // how long before a dropped rune despawns

// forward declarations
int GetPCHasRune(object oPC);

//int GetRuneEffectId(object oRuneOrPC);
//void SetRuneEffectId(object oRuneOrPC, int nRuneEffect=RUNE_EFFECT_RANDOM);

//float GetRuneTimeLeft(object oRuneOrPC);
//void SetRuneTimeLeft(object oRuneOrPC, float fTimeLeft=RUNE_DURATION);

//effect GetRuneEffect(object oRune);
//string GetRuneDescription(object oRune);

//int GetRuneIsUsed(object oRune);
//void SetRuneIsUsed(object oRune);

//object SpawnRune(location lSpawnPoint, int nRuneEffect=RUNE_EFFECT_RANDOM, float fTimeLeft=RUNE_DURATION, int nUsed=FALSE);
//void SpawnRuneVoid(location lSpawnPoint, int nRuneEffect=RUNE_EFFECT_RANDOM, float fTimeLeft=RUNE_DURATION, int nUsed=FALSE);
//void PickupRune(object oPC, object oRune=OBJECT_SELF);
//void DropRune(object oPC);
//void CleanRuneFromPC(object oPC);
//void RuneHeartBeat(object oPC);

// sets a rune effect id (RUNE_EFFECT_*) of a rune
void SetRuneEffectId(object oRuneOrPC, int nRuneEffect=RUNE_EFFECT_RANDOM) {
    if (!GetIsObjectValid(oRuneOrPC)) { return; }
    SetLocalInt(oRuneOrPC, "RUNE_EFFECT", nRuneEffect);
}

// sets the timeleft on a rune
void SetRuneTimeLeft(object oRuneOrPC, float fTimeLeft=RUNE_DURATION) {
    if (!GetIsObjectValid(oRuneOrPC)) { return; }
    SetLocalFloat(oRuneOrPC, "RUNE_TIMELEFT", fTimeLeft);
}

// removes rune variables from the pc
void CleanRuneFromPC(object oPC) {
    if (!GetIsObjectValid(oPC)) { return; }
    if (!GetIsPC(oPC)) { return; }
    SetRuneEffectId(oPC, 0);
    SetRuneTimeLeft(oPC, 0.0);
}

// gets the rune effect id (RUNE_EFFECT_*) of a rune, 0 on error
int GetRuneEffectId(object oRuneOrPC) {
    return GetLocalInt(oRuneOrPC, "RUNE_EFFECT");
}

// player has rune?
int GetPCHasRune(object oPC) {
    return GetRuneEffectId(oPC);
}

// gets the timeleft on a rune, 0.0f on error
float GetRuneTimeLeft(object oRuneOrPC) {
    return GetLocalFloat(oRuneOrPC, "RUNE_TIMELEFT");
}

// gets if the rune is used or not
int GetRuneIsUsed(object oRune) {
    return GetLocalInt(oRune, "RUNE_USED");
}

// marks the rune as used
void SetRuneIsUsed(object oRune) {
    if (!GetIsObjectValid(oRune)) { return; }
    SetLocalInt(oRune, "RUNE_USED", 1);
}


// returns the effect that the rune gives
effect GetRuneEffect(object oRune) {
  effect eRuneEffect = EffectTemporaryHitpoints(0);

  // valid rune object?
  if (!GetIsObjectValid(oRune)) { return eRuneEffect; }

  int nRuneEffect = GetRuneEffectId(oRune);

  switch(nRuneEffect) {
    case RUNE_EFFECT_SAVES:
      eRuneEffect = EffectSavingThrowIncrease(SAVING_THROW_ALL, 8);
      break;
    case RUNE_EFFECT_REGENERATION:
      eRuneEffect = EffectRegenerate(8, 6.0);
      break;
    case RUNE_EFFECT_CONCEALMENT:
      eRuneEffect = EffectConcealment(60);
      break;
    case RUNE_EFFECT_ARMOR_BONUS:
      eRuneEffect = EffectACIncrease(8, AC_DEFLECTION_BONUS);
      break; // players already have +5, so this is just +3 really
    case RUNE_EFFECT_ELEMENTAL_BONUS:
      eRuneEffect = EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_ACID);
      eRuneEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_COLD), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_ELECTRICAL), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_FIRE), eRuneEffect);
      break;
    case RUNE_EFFECT_PHYSICAL_BONUS:
      eRuneEffect = EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_BLUDGEONING);
      eRuneEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_PIERCING), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_SLASHING), eRuneEffect);
      break;
    case RUNE_EFFECT_RARE_BONUS:
      eRuneEffect = EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
      eRuneEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_NEGATIVE), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_POSITIVE), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_SONIC), eRuneEffect);
      break;
    case RUNE_EFFECT_IMMUNE_DEATH:
      eRuneEffect = EffectImmunity(IMMUNITY_TYPE_DEATH);
      eRuneEffect = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectSpellLevelAbsorption(9, 0, SPELL_SCHOOL_NECROMANCY), eRuneEffect);
      break;
    case RUNE_EFFECT_IMMUNE_MIND:
      eRuneEffect = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
      eRuneEffect = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_PARALYSIS), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_ENTANGLE), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_SLOW), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE), eRuneEffect);
      break;
    case RUNE_EFFECT_IMMUNE_KD:
      eRuneEffect = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
      break;
    case RUNE_EFFECT_ELEMENTAL_DAMAGE_RESISTANCE:
      eRuneEffect = EffectDamageResistance(DAMAGE_TYPE_ACID, 12);
      eRuneEffect = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_COLD, 12), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 12), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_FIRE, 12), eRuneEffect);
      break;
    case RUNE_EFFECT_PHYSICAL_DAMAGE_RESISTANCE:
      eRuneEffect = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 12), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_SLASHING, 12), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_PIERCING, 12), eRuneEffect);
      break;
    case RUNE_EFFECT_RARE_DAMAGE_RESISTANCE:
      eRuneEffect = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_DIVINE, 12), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 12), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_POSITIVE, 12), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_SONIC, 12), eRuneEffect);
      break;
    case RUNE_EFFECT_ELEMENTAL_SHIELD:
      eRuneEffect = EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_ACID);
      eRuneEffect = EffectLinkEffects(EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_ELECTRICAL), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE), eRuneEffect);
      break;
    case RUNE_EFFECT_PHYSICAL_SHIELD:
      eRuneEffect = EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_BLUDGEONING);
      eRuneEffect = EffectLinkEffects(EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_PIERCING), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_SLASHING), eRuneEffect);
      break;
    case RUNE_EFFECT_RARE_SHIELD:
      eRuneEffect = EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_DIVINE);
      eRuneEffect = EffectLinkEffects(EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_NEGATIVE), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_POSITIVE), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectDamageShield(6, DAMAGE_BONUS_1d6, DAMAGE_TYPE_SONIC), eRuneEffect);
      break;
    case RUNE_EFFECT_SPELL_RESISTANCE:
      eRuneEffect = EffectSpellResistanceIncrease(20);
      break;
    case RUNE_EFFECT_SKILL_INCREASE:
      eRuneEffect = EffectSkillIncrease(SKILL_ALL_SKILLS, 15);
      break;
    case RUNE_EFFECT_FORTITUDE_INCREASE:
      eRuneEffect = EffectSavingThrowIncrease(SAVING_THROW_FORT, 12);
      break;
    case RUNE_EFFECT_REFLEX_INCREASE:
      eRuneEffect = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 12);
      break;
    case RUNE_EFFECT_WILL_INCREASE:
      eRuneEffect = EffectSavingThrowIncrease(SAVING_THROW_WILL, 12);
      break;
    case RUNE_EFFECT_SKILL_DISCIPLINE_INCREASE:
      eRuneEffect = EffectSkillIncrease(SKILL_DISCIPLINE, 30);
      break;
    case RUNE_EFFECT_SKILL_TAUNT_INCREASE:
      eRuneEffect = EffectSkillIncrease(SKILL_TAUNT, 30);
      break;
    case RUNE_EFFECT_SKILL_STEALTH_INCREASE:
      eRuneEffect = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 30);
      eRuneEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, 30), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectAbilityIncrease(ABILITY_DEXTERITY, 12), eRuneEffect);
      break;
    case RUNE_EFFECT_SKILL_SEEKER_INCREASE:
      eRuneEffect = EffectSkillIncrease(SKILL_LISTEN, 30);
      eRuneEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_SPOT, 30), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectSeeInvisible(), eRuneEffect);
      eRuneEffect = EffectLinkEffects(EffectUltravision(), eRuneEffect);
      break;
    default:
      break;
  }
  return eRuneEffect;
}


// returns a discription of the effect that the rune gives
string GetRuneDescription(object oRune) {
  string sDesc = "Invalid Rune";

  // valid rune object?
  if (!GetIsObjectValid(oRune)) { return sDesc; }

  int nRuneEffect = GetRuneEffectId(oRune);

  switch(nRuneEffect) {
    case RUNE_EFFECT_SAVES:
      sDesc = "Rune of Saving Throws: +8 Universal Saves";
      break;
    case RUNE_EFFECT_REGENERATION:
      sDesc = "Rune of Vitality: +8 Regeneration";
      break;
    case RUNE_EFFECT_CONCEALMENT:
      sDesc = "Rune of Shadows: 60% Concealment";
      break;
    case RUNE_EFFECT_ARMOR_BONUS:
      sDesc = "Rune of Deflection: +8 Deflection AC";
      break; // players already have +5, so this is just +3 really
    case RUNE_EFFECT_ELEMENTAL_BONUS:
      sDesc = "Rune of Elemental Vengence: +1d8 Bonus Combat Damage: Acid, Cold, Electric, Fire";
      break;
    case RUNE_EFFECT_PHYSICAL_BONUS:
      sDesc = "Rune of Physical Vengence: +1d8 Bonus Combat Damage: Bludgeoning, Piercing, Slashing";
      break;
    case RUNE_EFFECT_RARE_BONUS:
      sDesc = "Rune of Godly Vengence: +1d8 Bonus Combat Damage: Divine, Negative, Positive, Sonic";
      break;
    case RUNE_EFFECT_IMMUNE_DEATH:
      sDesc = "Rune of Bone: Immunity to Death Effects, Negative Level, Ability Decrease, Negative Damage and Necromancy Spells";
      break;
    case RUNE_EFFECT_IMMUNE_MIND:
      sDesc = "Rune of Freedom: Immunity to Paralysis, Entangle, Slow, Movement Speed Decrease, Mind Effects";
      break;
    case RUNE_EFFECT_IMMUNE_KD:
      sDesc = "Rune of Steadfast Fighters: Immunity to Knockdown";
      break;
    case RUNE_EFFECT_ELEMENTAL_DAMAGE_RESISTANCE:
      sDesc = "Rune of Elements: 10/- Damage Resistance: Acid, Cold, Electric, Fire";
      break;
    case RUNE_EFFECT_PHYSICAL_DAMAGE_RESISTANCE:
      sDesc = "Rune of Barbarians: 10/- Damage Resistance: Bludgeoning, Piercing, Slashing";
      break;
    case RUNE_EFFECT_RARE_DAMAGE_RESISTANCE:
      sDesc = "Rune of Demi Gods: 10/- Damage Resistance: Divine, Negative, Positive, Sonic";
      break;
    case RUNE_EFFECT_ELEMENTAL_SHIELD:
      sDesc = "Rune of Elemental Shielding: 8+1d8 Damage Shield: Acid, Cold, Electric, Fire";
      break;
    case RUNE_EFFECT_PHYSICAL_SHIELD:
      sDesc = "Rune of Physical Shielding: 8+1d8 Damage Shield: Bludgeoning, Piercing, Slashing";
      break;
    case RUNE_EFFECT_RARE_SHIELD:
      sDesc = "Rune of Godly Shielding: 8+1d8 Damage Shield: Divine, Negative, Positive, Sonic";
      break;
    case RUNE_EFFECT_SPELL_RESISTANCE:
      sDesc = "Rune of Resistance: +20 Spell Resistance";
      break;
    case RUNE_EFFECT_SKILL_INCREASE:
      sDesc = "Rune of Masters: +15 to All Skills";
      break;
    case RUNE_EFFECT_FORTITUDE_INCREASE:
      sDesc = "Rune of Burliness: +12 to Fortitude Save";
      break;
    case RUNE_EFFECT_REFLEX_INCREASE:
      sDesc = "Rune of Acrobats: +12 to Reflex Save";
      break;
    case RUNE_EFFECT_WILL_INCREASE:
      sDesc = "Rune of Steely Resolve: +12 to Will Save";
      break;
    case RUNE_EFFECT_SKILL_DISCIPLINE_INCREASE:
      sDesc = "Rune of Discipline: +30 to Discipline Skill";
      break;
    case RUNE_EFFECT_SKILL_TAUNT_INCREASE:
      sDesc = "Rune of Trash Talkers: +30 to Taunt Skill";
      break;
    case RUNE_EFFECT_SKILL_STEALTH_INCREASE:
      sDesc = "Rune of Sneaks: +30 to Hide and Move Silent Skills, +12 Dexterity";
      break;
    case RUNE_EFFECT_SKILL_SEEKER_INCREASE:
      sDesc = "Rune of Seekers: +30 to Listen and Spot Skills, See Invisible, Ultravision";
      break;
    default:
      break;
  }
  return sDesc;
}


// spawns a rune and initializes it, returns the rune
object SpawnRune(location lSpawnPoint, int nRuneEffect=RUNE_EFFECT_RANDOM, float fTimeLeft=RUNE_DURATION, int nUsed=FALSE) {
  object oRune = CreateObject(OBJECT_TYPE_PLACEABLE, "magicrune", lSpawnPoint);

  // random effect?
  if (nRuneEffect == RUNE_EFFECT_RANDOM || nRuneEffect <= 0) {
    nRuneEffect = Random(RUNE_MAX_EFFECT_ID)+1;
  }

  SetRuneEffectId(oRune, nRuneEffect);
  SetRuneTimeLeft(oRune, fTimeLeft);

  if (nUsed == TRUE) {
    SetRuneIsUsed(oRune);
  }
  return oRune;
}

// spawns a rune without returning it (for delaycommand())
void SpawnRuneVoid(location lSpawnPoint, int nRuneEffect=RUNE_EFFECT_RANDOM, float fTimeLeft=RUNE_DURATION, int nUsed=FALSE) {
  SpawnRune(lSpawnPoint, nRuneEffect, fTimeLeft, nUsed);
}

// updates the RUNE_TIMELEFT local variable on the player
// so when the rune runes out they are able to pick up a new one
void RuneHeartBeat(object oPC) {
  if (!GetIsObjectValid(oPC)) { return; }
  if (!GetIsPC(oPC)) { return; }
  if (!GetPCHasRune(oPC)) { return; }

  float fTimeLeft = GetRuneTimeLeft(oPC);
  fTimeLeft -= RUNE_HEARTBEAT;
  if (fTimeLeft <= 0.0) {
    CleanRuneFromPC(oPC);
    return;
  }
  SetRuneTimeLeft(oPC, fTimeLeft);

  // run again next heartbeat
  AssignCommand(oPC, DelayCommand(RUNE_HEARTBEAT, RuneHeartBeat(oPC)));
}

// applies a rune effect to a player (ie, when they pick up a rune)
void PickupRune(object oPC, object oRune=OBJECT_SELF) {
  // valid player?
  if (!GetIsObjectValid(oPC)) { return; }
  if (!GetIsPC(oPC)) { return; }
  if (GetIsDM(oPC)) { return; }

  // valid rune object?
  if (!GetIsObjectValid(oRune)) { return; }

  // check if the player already has a rune effect
  if (GetPCHasRune(oPC)) {
    FloatingTextStringOnCreature("You already have a Rune!", oPC);
    return;
  }

  // get the timeleft of the rune
  float fTimeLeft = RUNE_DURATION;
  int nUsed = GetRuneIsUsed(oRune);
  if (nUsed) {
    fTimeLeft = GetRuneTimeLeft(oRune);
  }

  // get the rune effect of the rune
  int nRuneEffect = GetRuneEffectId(oRune);
  if (nRuneEffect == RUNE_EFFECT_RANDOM || nRuneEffect <= 0) {
    nRuneEffect = Random(RUNE_MAX_EFFECT_ID)+1;
    SetRuneEffectId(oRune, nRuneEffect);
  }

  // set the timeleft and rune effect id on the player
  SetRuneTimeLeft(oPC, fTimeLeft-0.1);
  SetRuneEffectId(oPC, nRuneEffect);

  // get the effect of the rune
  effect eRuneEffect = GetRuneEffect(oRune);

  // get description of rune
  string sRuneDesc = GetRuneDescription(oRune);

  // add some visual effects to the rune effect
  eRuneEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_GLYPH_OF_WARDING), eRuneEffect);
  eRuneEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_SMOKE), eRuneEffect);

  // make the effect undispellable
  eRuneEffect = ExtraordinaryEffect(eRuneEffect);

  // apply the rune effect
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRuneEffect, oPC, fTimeLeft);
  AssignCommand(oPC, DelayCommand(fTimeLeft, CleanRuneFromPC(oPC)));

  // start heartbeat to update RUNE_TIMELEFT on the player
  AssignCommand(oPC, DelayCommand(RUNE_HEARTBEAT, RuneHeartBeat(oPC)));

  // float some text
  FloatingTextStringOnCreature(sRuneDesc, oPC);
  ShoutMsg(GetRGB(15,15,1) + GetName(oPC) + GetRGB() + " has picked up " + GetRGB(15,15,1) + sRuneDesc + GetRGB() +  " in " + GetRGB(15,15,1) + GetName(GetArea(oPC)));

  // if this is a new rune, setup a delay command to spawn a new rune in a few minutes...
  if (!nUsed) {
    location lRune = GetLocation(oRune);
    AssignCommand(GetArea(oRune), DelayCommand(RUNE_RESPAWNTIME, SpawnRuneVoid(lRune)));
  }

  // destroy the rune
  DestroyObject(oRune);

}

// drop a rune from a player if they have one
void DropRune(object oPC) {
  // valid player?
  if (!GetIsObjectValid(oPC)) { return; }
  if (!GetIsPC(oPC)) { return; }
  if (!GetPCHasRune(oPC)) { return; }

  int nRuneEffect = GetRuneEffectId(oPC);
  float fTimeLeft = GetRuneTimeLeft(oPC);

  // clean up the player's variables
  CleanRuneFromPC(oPC);

  // spawn the old rune if time is left on it
  if (fTimeLeft > 0.0) {
    object oRune = SpawnRune(GetLocation(oPC), nRuneEffect, fTimeLeft, TRUE);
    // despawn the rune if nobody has picked it up after RUNE_DESPAWNTIME
    AssignCommand(oRune, DelayCommand(RUNE_DESPAWNTIME, DestroyObject(oRune)));
  }
}
