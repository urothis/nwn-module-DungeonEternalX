#include "pure_caster_inc"
#include "string_inc"

void ApplyHaste(object oPC)
{
    object oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectHaste()), oSum);
}

string GetElementType(string sAir, string sWater, string sFire, string sEarth)
{
     string dom1 = "";
     string dom2 = "";
     if (GetHasFeat(FEAT_AIR_DOMAIN_POWER))   if (dom1=="") dom1=sAir  ; else dom2=sAir;   //return sAir;
     if (GetHasFeat(FEAT_WATER_DOMAIN_POWER)) if (dom1=="") dom1=sWater; else dom2=sWater; //return sWater;
     if (GetHasFeat(FEAT_FIRE_DOMAIN_POWER))  if (dom1=="") dom1=sFire ; else dom2=sFire;  //return sFire;
     if (GetHasFeat(FEAT_EARTH_DOMAIN_POWER)) if (dom1=="") dom1=sEarth; else dom2=sEarth; //return sEarth;
     if (dom1!="") return PickOne(dom1, dom2); // IF THEY ARE SPECIAL, PICK ONE OF THE SPECIALTIES
     return PickOne(sAir, sWater, sFire, sEarth); // OTHERWISE, RANDOMIZE!
}

effect SetSummonEffect(int nSpellID, int nPureLevel)
{
    int nFNF_Effect;
    string sSummon;
    int lvl = 1;
    if (nSpellID == SPELL_SUMMON_CREATURE_I) lvl = 1;
    else if (nSpellID == SPELL_SUMMON_CREATURE_II) lvl = 2;
    else if (nSpellID == SPELL_SUMMON_CREATURE_III) lvl = 3;
    else if (nSpellID == SPELL_SUMMON_CREATURE_IV) lvl = 4;
    else if (nSpellID == SPELL_SUMMON_CREATURE_V) lvl = 5;
    else if (nSpellID == SPELL_SUMMON_CREATURE_VI) lvl = 6;
    else if (nSpellID == SPELL_SUMMON_CREATURE_VII) lvl = 7;
    else if (nSpellID == SPELL_SUMMON_CREATURE_VIII)  lvl = 8;
    else if (nSpellID == SPELL_SUMMON_CREATURE_IX)  lvl = 9;

    nPureLevel -= 17;
    if (nPureLevel > 0) lvl += nPureLevel / 7; // ie 24=10, 31=11, 38=12

    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION)) lvl = lvl + 1;
    if (GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER)) lvl = lvl + 1; //WITH THE ANIMAL DOMAIN
    if (GetHasSpellSchool(OBJECT_SELF, SPELL_SCHOOL_CONJURATION)) lvl = lvl + 1;

    nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3; // DEFAULT
    if (lvl == 1)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
        sSummon = "NW_S_badgerdire";
    }
    else if (lvl == 2)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
        sSummon = "NW_S_BOARDIRE";
    }
    else if (lvl == 3)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
        sSummon = "NW_S_WOLFDIRE";
    }
    else if (lvl == 4)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
        sSummon = "NW_S_SPIDDIRE";
    }
    else if (lvl == 5)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
        sSummon = "NW_S_beardire";
    }
    else if (lvl == 6)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
        sSummon = "NW_S_diretiger";
    }
    else if (lvl == 7)
    {
        sSummon = GetElementType("NW_S_AIRHUGE","NW_S_WATERHUGE","NW_S_FIREHUGE","NW_S_EARTHHUGE");
    }
    else if (lvl == 8)
    {
        sSummon = GetElementType("NW_S_AIRGREAT","NW_S_WATERGREAT","NW_S_FIREGREAT","NW_S_EARTHGREAT");
    }
    else if (lvl == 9)
    {
        sSummon = GetElementType("NW_S_AIRELDER","NW_S_WATERELDER","NW_S_FIREELDER","NW_S_EARTHELDER");
    }
    else if (lvl == 10)
    {
        sSummon = GetElementType("SU_AIRANCIENT","SU_WATERANCIENT","SU_FIREANCIENT","SU_EARTHANCIENT");
    }
    else if (lvl == 11)
    {
        sSummon = GetElementType("SU_AIRABORIGINAL","SU_WATERABORIGIN","SU_FIREABORIGINA","SU_EARTHABORIGIN");
    }
    else if (lvl == 12)
    {
        sSummon = GetElementType("SU_AIRPRIMORDIAL","SU_WATERPRIMORDI","SU_FIREPRIMORDIA","SU_EARTHPRIMORDI");
    }
    else if (lvl == 13)
    {
        sSummon = GetElementType("SU_AIRPRIMEVAL","SU_WATERPRIMEVAL","SU_FIREPRIMEVAL","SU_EARTHPRIMEVAL");
    }
    else if (lvl > 13)
    {
        sSummon = GetElementType("SU_AIRCREATOR","SU_WATERCREATOR","SU_FIRECREATOR","SU_EARTHCREATOR");
        DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_WORD), GetSpellTargetLocation()));
    }
    return EffectSummonCreature(sSummon, nFNF_Effect);
}

effect SetDruidSummonEffect(int nSpellID) {
   int nFNF_Effect;
   int nRoll = d3();
   int HasSF  = GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION);
   int HasGSF = GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION);
   int HasESF = GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION);
   string sSummon;
   string sFloatMsg = "Summon Creature";
   int nDruidLevel = GetLevelByClass(CLASS_TYPE_DRUID);

   if (nSpellID == SPELL_SUMMON_CREATURE_I) {
      nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
      sFloatMsg += " I: Druid Bonus";
      if (nDruidLevel >= 3 && HasGSF) {
         sFloatMsg += " III - Cockatrice";
         sSummon = "ds_01_cockatrice";
      } else if (nDruidLevel >= 2 && HasSF) {
         sFloatMsg += " II - Penguin";
         sSummon = "ds_01_penguin";
      } else {
         sFloatMsg += " I - McNugget";
         sSummon = "ds_01_chicken";
      }
   } else if (nSpellID == SPELL_SUMMON_CREATURE_II) {
      nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
      sFloatMsg += " II: Druid Bonus";
      if (nDruidLevel >= 7 && HasGSF) {
         sFloatMsg += " III - Bomber Beetle";
         sSummon = "ds_02_bombardier";
      } else if (nDruidLevel >= 5 && HasSF) {
         sFloatMsg += " II - Spitting Beetle";
         sSummon = "ds_02_spitting";
      } else {
         sFloatMsg += " I - Stink Bettle";
         sSummon = "ds_02_stink";
      }
   } else if (nSpellID == SPELL_SUMMON_CREATURE_III) {
      nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
      sFloatMsg += " III: Bonus";
      if (nDruidLevel >= 11 && HasGSF) {
         sFloatMsg += " III - Wraith Spider";
         sSummon = "ds_03_wraithspid";
      } else if (nDruidLevel >= 8 && HasSF) {
         sFloatMsg += " II - Phase Spider";
         sSummon = "ds_03_phasespide";
      } else {
         sFloatMsg += " I - Green Spider";
         sSummon = "ds_03_greenspide";
      }
   } else if (nSpellID == SPELL_SUMMON_CREATURE_IV) {
      nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
      sFloatMsg += " IV: Bonus";
      if (nDruidLevel >= 15 && HasGSF) {
         sFloatMsg += " III - Werewolf";
         sSummon = "ds_04_werewolf";
      } else if (nDruidLevel >= 11 && HasSF) {
         sFloatMsg += " II - Werecat";
         sSummon = "ds_04_werecat";
      } else {
         sFloatMsg += " I - Wererat";
         sSummon = "ds_04_wererat";
      }
   } else if (nSpellID == SPELL_SUMMON_CREATURE_V) {
      nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
      sFloatMsg += " V: Bonus";
      if (nDruidLevel >= 19 && HasGSF) {
         sFloatMsg += " III - Mastiff";
         sSummon = "ds_05_mastiff";
      } else if (nDruidLevel >= 14 && HasSF) {
         sFloatMsg += " II - Fenhound";
         sSummon = "ds_05_fenhound";
      } else {
         sFloatMsg += " I - Worg";
         sSummon = "ds_05_worg";
      }
   } else if (nSpellID == SPELL_SUMMON_CREATURE_VI) {
      nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
      sFloatMsg += " VI: Bonus";
      if (nDruidLevel >= 23 && HasESF) {
         sFloatMsg += " III - Stinger";
         sSummon = "ds_06_stinger";
      } else if (nDruidLevel >= 17 && HasGSF) {
         sFloatMsg += " II - Formian";
         sSummon = "ds_06_formian";
      } else {
         sFloatMsg += " I - Drider";
         sSummon = "ds_06_drider";
      }
   } else if (nSpellID == SPELL_SUMMON_CREATURE_VII) {
      nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
      sFloatMsg += " VII: Bonus";
      if (nDruidLevel >= 27 && HasESF) {
         sFloatMsg += " III - Umberhulk";
         sSummon = "ds_07_umberhulk";
      } else if (nDruidLevel >= 20 && HasGSF) {
         sFloatMsg += " II - Hook Horror";
         sSummon = "ds_07_hookhorror";
      } else {
         sFloatMsg += " I - Ettercap";
         sSummon = "ds_07_ettercap";
      }
   } else if (nSpellID == SPELL_SUMMON_CREATURE_VIII) {
      nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
      sFloatMsg += " VIII: Bonus";
      if (nDruidLevel >= 31 && HasESF) {
         sFloatMsg += " III - Harpy";
         sSummon = "ds_08_harpy";
      } else if (nDruidLevel >= 23 && HasGSF) {
         sFloatMsg += " II - Siren";
         sSummon = "ds_08_siren";
      } else {
         sFloatMsg += " I - Medusa";
         sSummon = "ds_08_medusa";
      }
   } else if (nSpellID == SPELL_SUMMON_CREATURE_IX) {
      nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
      sFloatMsg += " IX: Bonus";
      if (nDruidLevel == 40 && HasESF) {
         sFloatMsg += " IV - Death Slaad";
         sSummon = "ds_09_deathslaad";
      } else if (nDruidLevel >= 35 && HasESF) {
         sFloatMsg += " III - Ancient Slaad";
         sSummon = "ds_09_ancientsla";
      } else if (nDruidLevel >= 26 && HasGSF) {
         sFloatMsg += " II - Elder Slaad";
         sSummon = "ds_09_elderslaad";
      } else {
         sFloatMsg += " I - Forest Slaad";
         sSummon = "ds_09_forestslaa";
      }
   }
   FloatingTextStringOnCreature(sFloatMsg, OBJECT_SELF);
   effect eSummonedMonster = EffectSummonCreature(sSummon, nFNF_Effect);
   if (sSummon == " IV - Death Slaad")
   {
        eSummonedMonster = SupernaturalEffect(eSummonedMonster);
   }
   return eSummonedMonster;
}


#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   int nSpellID = GetSpellId();
   int nDuration = 4 + GetCasterLevel(OBJECT_SELF)/4;
   effect eSummon;

   //Druid or Non-Druid summons?
   //If the caster has any number of druid levels use the druid summons.
   //There is a special case where, for example, a Cleric/Druid casting
   //Summon Creature as a Cleric spell will get the Druid summon bonuses.
   //We can try to prevent this by making sure the caster level is the
   //same as the caster's druid levels. If it is different, then the spell
   //is being cast as a different class (or maybe umd?). The player can
   //still get the bonus if they have an equal number of Cleric/Druid levels
   //for example, but in that case they could just as easily cast the spell
   //as a druid, so we let them cheese out the bonus anyway.
   int nDruidLevel = GetLevelByClass(CLASS_TYPE_DRUID);
   if (nDruidLevel > 0 && nDruidLevel == GetCasterLevel(OBJECT_SELF)) {
      eSummon = SetDruidSummonEffect(nSpellID);
   } else {
      eSummon = SetSummonEffect(nSpellID, nPureLevel);
   }

   //Make metamagic check for extend
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;   //Duration is +100%
   //Apply the VFX impact and summon effect
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));

   DelayCommand(1.0, ApplyHaste(OBJECT_SELF));
}


