void RestBoss(object oBoss) {
   if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oBoss))) return; // PC IN THE ROOM, QUIT WITHOUT RESTING
   ForceRest(oBoss);
}

void main() {
   object oArea = OBJECT_SELF;
   ExecuteScript("_mod_areaexit", oArea);
   string sFAID = GetLocalString(oArea, "FAID"); // GET AREA'S FACTION
   string sBossTag = "BOSS_" + sFAID;
   object oBoss = GetObjectByTag(sBossTag);
   if (oBoss==OBJECT_INVALID) return; // NO BOSS, NO WORK TO DO
   if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oBoss))) return; // PC IN THE ROOM, NOTHING TO DO
   DelayCommand(300.0f, RestBoss(oBoss));

}
