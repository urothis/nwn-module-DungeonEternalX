void main()
{
 location lLocation = GetLocation(OBJECT_SELF);
 object oEncounter = GetNearestObjectToLocation(OBJECT_TYPE_ENCOUNTER, lLocation);
 object oPC = GetEnteringObject();
 int nPClvl = GetLevelByPosition(1, oPC) +
              GetLevelByPosition(2, oPC) +
              GetLevelByPosition(3, oPC);
 int nEncounterDifficulty = GetEncounterDifficulty(oEncounter);

 if (GetIsPC(oPC))
 {
  // 16-25 lvl chracters won't spawn EASY encounters.
  if (16 <= nPClvl && nPClvl <= 25)
  {
   if (nEncounterDifficulty == ENCOUNTER_DIFFICULTY_EASY)
   {
    SetEncounterActive(FALSE, oEncounter);
    DelayCommand(20.0, SetEncounterActive(TRUE,oEncounter));
   }
  }
  // 26-34 lvl chracters won't spawn EASY, NORMAL encounters.
  if (26 <= nPClvl && nPClvl <= 34)
  {
   if (nEncounterDifficulty == ENCOUNTER_DIFFICULTY_EASY ||
       nEncounterDifficulty == ENCOUNTER_DIFFICULTY_NORMAL)
   {
    SetEncounterActive(FALSE, oEncounter);
    DelayCommand(20.0, SetEncounterActive(TRUE,oEncounter));
   }
  }
  // 35-40 lvl chracters won't spawn EASY, NORMAL, HARD encounters.
  if (35 <= nPClvl && nPClvl <= 40)
  {
   if (nEncounterDifficulty == ENCOUNTER_DIFFICULTY_EASY ||
       nEncounterDifficulty == ENCOUNTER_DIFFICULTY_NORMAL ||
       nEncounterDifficulty == ENCOUNTER_DIFFICULTY_HARD)
   {
    SetEncounterActive(FALSE, oEncounter);
    DelayCommand(20.0, SetEncounterActive(TRUE,oEncounter));
   }
  }
 }
}
