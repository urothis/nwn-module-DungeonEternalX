// Test whether the given area is an arena area
// Arena areas have abnormal respawning options
// When you respawn you are put back to maximum
// hitpoints instead of being ported to ethereal
// plane
// Returns TRUE if the given area is an arena area
int IsArenaArea (object oArea)
{
    string sAreaTag = GetTag(oArea);
    return  sAreaTag == "thearena001"       || sAreaTag == "fightclub"      ||
            sAreaTag == "area018"           || sAreaTag == "colliseumarena" ||
            sAreaTag == "freeforallarena"   || sAreaTag == "Deathmatch"     ||
            sAreaTag == "TournamentArena"   || sAreaTag == "TrainingCampTheHallsofBlood"  ||
            sAreaTag == "TrainingCamp";
}
