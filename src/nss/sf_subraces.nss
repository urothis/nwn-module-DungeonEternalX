#include "sfsubr_functs"

void LoadSubrace_UndeadHalfElf() {
    SF_CreateNewSubrace("UndeadHalfElf", APPEARANCE_TYPE_MUMMY_WARRIOR, APPEARANCE_TYPE_MUMMY_WARRIOR, "skin_undeadhe", "", "", TRUE);
    SF_SetSubraceRaceRestriction("UndeadHalfElf", ALLOW_USE_TRUE, RACE_RESTRICT_HALFELF);
    SF_AdjustSubraceStats("UndeadHalfElf", 1, 1, 1, 1, 1, 1);
    SF_SetSubraceFeat("UndeadHalfElf", FEAT_ALERTNESS);
    SF_SetSubraceMovementSpeed("UndeadHalfElf", 120);
}

void LoadSubrace_Ettin() {
    SF_CreateNewSubrace("Ettin", APPEARANCE_TYPE_ETTIN, APPEARANCE_TYPE_ETTIN, "skin_ettin");
    SF_SetSubraceRaceRestriction("Ettin", ALLOW_USE_TRUE, RACE_RESTRICT_ELF | RACE_RESTRICT_HALFELF | RACE_RESTRICT_HUMAN);
    SF_AdjustSubraceStats("Ettin", 0, -2, 4, 0, -2, 0);
    SF_SetSubraceFeat("Ettin", FEAT_WEAPON_FOCUS_SPEAR);
    SF_SetSubraceFeat("Ettin", FEAT_WEAPON_FOCUS_CLUB);
    SF_SetSubraceFeat("Ettin", FEAT_ALERTNESS);
    SF_SetSubraceMovementSpeed("Ettin", 120);
}

/*void LoadSubrace_Shielddwarf() {
    SF_CreateNewSubrace("Shielddwarf", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_shdwarf");
    SF_SetSubraceRaceRestriction("Shielddwarf", ALLOW_USE_TRUE, RACE_RESTRICT_DWARF);
    SF_AdjustSubraceStats("Shielddwarf", 0, 0, 0, 0, 0, 0);
    SF_SetSubraceFeat("Shielddwarf", FEAT_DODGE);
    SF_SetSubraceFeat("Shielddwarf", FEAT_MOBILITY);
    SF_SetSubraceFeat("Shielddwarf", FEAT_ALERTNESS);
}*/

void LoadSubrace_Ogre() {
    SF_CreateNewSubrace("Ogre", APPEARANCE_TYPE_OGRE, APPEARANCE_TYPE_OGREB, "skin_ogre");
    SF_SetSubraceRaceRestriction("Ogre", ALLOW_USE_TRUE, RACE_RESTRICT_HALFORC);
    SF_AdjustSubraceStats("Ogre", 2, -2, 2, 0, 0, -2);
    SF_SetSubraceFeat("Ogre", FEAT_WEAPON_FOCUS_HALBERD);
    SF_SetSubraceFeat("Ogre", FEAT_WEAPON_FOCUS_BASTARD_SWORD);
    SF_SetSubraceFeat("Ogre", FEAT_ALERTNESS);
    SF_SetSubraceMovementSpeed("Ogre", 120);
}

void LoadSubrace_Seahag() {
    SF_CreateNewSubrace("Seahag", APPEARANCE_TYPE_SEA_HAG, APPEARANCE_TYPE_SEA_HAG, "skin_seahag", "", "", FALSE, 19);
    SF_SetSubraceRaceRestriction("Seahag", ALLOW_USE_TRUE, RACE_RESTRICT_HALFELF | RACE_RESTRICT_HUMAN | RACE_RESTRICT_ELF);
    SF_AdjustSubraceStats("Seahag", 0, 0, 4, -2, 0, -2);
    SF_SetSubraceFeat("Seahag", FEAT_RESIST_ENERGY_COLD);
    SF_SetSubraceFeat("Seahag", FEAT_RESIST_ENERGY_ELECTRICAL);
    SF_SetSubraceFeat("Seahag", FEAT_IRON_WILL);
    SF_SetSubraceFeat("Seahag", FEAT_ALERTNESS);
    SF_SetSubraceMovementSpeed("Seahag", 120);
}

void LoadSubrace_Gnoll() {
    SF_CreateNewSubrace("Gnoll", APPEARANCE_TYPE_GNOLL_WARRIOR, APPEARANCE_TYPE_GNOLL_WIZ, "skin_gnoll");
    SF_SetSubraceRaceRestriction("Gnoll", ALLOW_USE_TRUE, RACE_RESTRICT_HALFELF | RACE_RESTRICT_DWARF);
    SF_AdjustSubraceStats("Gnoll", 2, -4, 0, 0, 2, 0);
    SF_SetSubraceFeat("Gnoll", FEAT_WEAPON_FOCUS_BATTLE_AXE);
    SF_SetSubraceFeat("Gnoll", FEAT_ALERTNESS);
    SF_SetSubraceMovementSpeed("Gnoll", 120);
}

void LoadSubrace_Azer() {
    SF_CreateNewSubrace("Azer", APPEARANCE_TYPE_AZER_MALE, APPEARANCE_TYPE_AZER_FEMALE, "skin_azer");
    SF_SetSubraceRaceRestriction("Azer", ALLOW_USE_TRUE, RACE_RESTRICT_DWARF);
    SF_AdjustSubraceStats("Azer", 2, -2, 0, 0, -2, 2);
    SF_SetSubraceFeat("Azer", FEAT_EPIC_ENERGY_RESISTANCE_FIRE_2);
    SF_SetSubraceFeat("Azer", FEAT_ALERTNESS);
    SF_SetSubraceAppearanceColor("Azer", 14, 49);
    SF_SetSubraceMovementSpeed("Azer", 120);
}

void LoadSubrace_Duergar() {
    SF_CreateNewSubrace("Duergar", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_duergar");
    SF_SetSubraceRaceRestriction("Duergar", ALLOW_USE_TRUE, RACE_RESTRICT_DWARF);
    SF_AdjustSubraceStats("Duergar", 2, -2, 2, -2, 0, 0);
    SF_SetSubraceFeat("Duergar", FEAT_WEAPON_FOCUS_WAR_HAMMER);
    SF_SetSubraceFeat("Duergar", FEAT_ALERTNESS);
    SF_SetSubraceAppearanceColor("Duergar", 19, 7);
}

void LoadSubrace_ArcticDwarf() {
    SF_CreateNewSubrace("ArcticDwarf", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_arcticdwarf");
    SF_SetSubraceRaceRestriction("ArcticDwarf", ALLOW_USE_TRUE, RACE_RESTRICT_DWARF);
    SF_AdjustSubraceStats("ArcticDwarf", 0, -2, 2, -2, 0, 2);
    SF_SetSubraceFeat("ArcticDwarf", FEAT_EPIC_ENERGY_RESISTANCE_COLD_2);
    SF_SetSubraceFeat("ArcticDwarf", FEAT_ALERTNESS);
    SF_SetSubraceFeat("ArcticDwarf", FEAT_DODGE);
    SF_SetSubraceFeat("ArcticDwarf", FEAT_TOUGHNESS);
    SF_SetSubraceAppearanceColor("ArcticDwarf", 60, 56);
}

void LoadSubrace_Avariel() {
    SF_CreateNewSubrace("Avariel", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_avariel");
    SF_SetSubraceRaceRestriction("Avariel", ALLOW_USE_TRUE, RACE_RESTRICT_ELF | RACE_RESTRICT_HALFELF);
    SF_AdjustSubraceStats("Avariel", -2, 2, -2, 0, 0, 2);
    SF_SetSubraceAppearanceColor("Avariel", 62, 57);
    SF_SetSubraceBodyAttatchments("Avariel", 6, 0);
    SF_SetSubraceFeat("Avariel", FEAT_ALERTNESS);

}

void LoadSubrace_Drow() {
    SF_CreateNewSubrace("Drow", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_drow");
    SF_SetSubraceRaceRestriction("Drow", ALLOW_USE_TRUE, RACE_RESTRICT_ELF | RACE_RESTRICT_HALFELF);
    SF_AdjustSubraceStats("Drow", -2, 2, 0, 2, -2, 0);
    SF_SetSubraceFeat("Drow", FEAT_HARDINESS_VERSUS_SPELLS);
    SF_SetSubraceFeat("Drow", FEAT_WEAPON_PROFICIENCY_EXOTIC);
    SF_SetSubraceFeat("Drow", FEAT_ALERTNESS);
    SF_SetSubraceAppearanceColor("Drow", 43, 56);
}

void LoadSubrace_Darkelf() {
    SF_CreateNewSubrace("Darkelf", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_darkelf");
    SF_SetSubraceRaceRestriction("Darkelf", ALLOW_USE_TRUE, RACE_RESTRICT_ELF | RACE_RESTRICT_HALFELF);
    SF_AdjustSubraceStats("Darkelf", -2, 0, 0, 0, 4, -2);
    SF_SetSubraceAppearanceColor("Darkelf", 43, 56);
    SF_SetSubraceFeat("Darkelf", FEAT_COMBAT_CASTING);
    SF_SetSubraceFeat("Darkelf", FEAT_ALERTNESS);
}

void LoadSubrace_Dopkalfar() {
    SF_CreateNewSubrace("Dopkalfar", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_dopkalfar");
    SF_SetSubraceAppearanceColor("Dopkalfar", 60, 56);
    SF_SetSubraceRaceRestriction("Dopkalfar", ALLOW_USE_TRUE, RACE_RESTRICT_ELF | RACE_RESTRICT_HALFELF);
    SF_AdjustSubraceStats("Dopkalfar", -2, -2, 0, 2, 2, 0);
    SF_SetSubraceFeat("Dopkalfar", FEAT_SPELL_FOCUS_ABJURATION);
    SF_SetSubraceFeat("Dopkalfar", FEAT_EPIC_ENERGY_RESISTANCE_COLD_1);
    SF_SetSubraceFeat("Dopkalfar", FEAT_ALERTNESS);
}


void LoadSubrace_Ljosalfar() {
    SF_CreateNewSubrace("Ljosalfar", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_ljosalfar");
    SF_SetSubraceAppearanceColor("Ljosalfar", 14, 49);
    SF_SetSubraceRaceRestriction("Ljosalfar", ALLOW_USE_TRUE, RACE_RESTRICT_ELF | RACE_RESTRICT_HALFELF);
    SF_SetSubraceFeat("Ljosalfar", FEAT_EPIC_ENERGY_RESISTANCE_FIRE_1);
    SF_SetSubraceFeat("Ljosalfar", FEAT_WEAPON_FOCUS_LONG_SWORD);
    SF_SetSubraceFeat("Ljosalfar", FEAT_WEAPON_FOCUS_KATANA);
    SF_SetSubraceFeat("Ljosalfar", FEAT_ALERTNESS);
    SF_AdjustSubraceStats("Ljosalfar", 2, 0, 2, -2, -2, 0);
}

void LoadSubrace_Svirfneblin()
{
    SF_CreateNewSubrace("Svirfneblin", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_svirfneblin");
    SF_SetSubraceRaceRestriction("Svirfneblin", ALLOW_USE_TRUE, RACE_RESTRICT_GNOME | RACE_RESTRICT_HALFLING);
    SF_AdjustSubraceStats("Svirfneblin", 0, 2, -2, 0, -2, 2);
    SF_SetSubraceFeat("Svirfneblin", FEAT_DODGE);
    SF_SetSubraceFeat("Svirfneblin", FEAT_SPELL_FOCUS_ILLUSION);
    SF_SetSubraceFeat("Svirfneblin", FEAT_GREATER_SPELL_FOCUS_ILLUSION);
    SF_SetSubraceFeat("Svirfneblin", FEAT_WEAPON_FOCUS_DART);
    SF_SetSubraceFeat("Svirfneblin", FEAT_WEAPON_FOCUS_SHORT_SWORD);
    SF_SetSubraceFeat("Svirfneblin", FEAT_HARDINESS_VERSUS_ILLUSIONS);
    SF_SetSubraceFeat("Svirfneblin", FEAT_ALERTNESS);
    SF_SetSubraceAppearanceColor("Svirfneblin", 19, -1);

}

void LoadSubrace_Kobold() {
    SF_CreateNewSubrace("Kobold", APPEARANCE_TYPE_KOBOLD_A, APPEARANCE_TYPE_KOBOLD_B, "skin_kobold");
    SF_SetSubraceRaceRestriction("Kobold", ALLOW_USE_TRUE, RACE_RESTRICT_GNOME | RACE_RESTRICT_DWARF | RACE_RESTRICT_HALFELF);
    SF_AdjustSubraceStats("Kobold", 0, 4, -2, -2, 0, 0);
    SF_SetSubraceFeat("Kobold", FEAT_POINT_BLANK_SHOT);
    SF_SetSubraceFeat("Kobold", FEAT_DODGE);
    SF_SetSubraceFeat("Kobold", FEAT_ALERTNESS);
}

void LoadSubrace_Aasimar() {
    SF_CreateNewSubrace("Aasimar", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_aasimar");
    SF_AdjustSubraceStats("Aasimar", -2, 0, -2, 0, 2, 2);
    SF_SetSubraceAppearanceColor ("Aasimar", 41, 45);
    SF_SetSubraceBodyAttatchments("Aasimar", WINGS_TYPE_ANGEL, TAIL_TYPE_NONE);
    SF_SetSubraceFeat("Aasimar", FEAT_ALERTNESS);
}

void LoadSubrace_Tiefling() {
    SF_CreateNewSubrace("Tiefling", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_tiefling");
    SF_AdjustSubraceStats("Tiefling", -2, 2, -2, 2, 0, 0);
    SF_SetSubraceAppearanceColor("Tiefling", 26, -1);
    SF_SetSubraceBodyAttatchments("Tiefling", WINGS_TYPE_NONE, TAIL_TYPE_DEVIL);
    SF_SetSubraceFeat("Tiefling", FEAT_ALERTNESS);
}

/////////////////// Cory New Subraces /////////////////////////

/// Humans ///
void LoadSubrace_EarthGenasi() {
    SF_CreateNewSubrace("EarthGenasi", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_earthgenasi");
    SF_SetSubraceRaceRestriction("EarthGenasi", ALLOW_USE_TRUE, RACE_RESTRICT_HUMAN);
    SF_AdjustSubraceStats("EarthGenasi", 2, 0, 0, -2, 0, 0);
    SF_SetSubraceAppearanceColor("EarthGenasi", 171, 171);
    SF_SetSubraceFeat("EarthGenasi", FEAT_RESIST_ENERGY_ELECTRICAL);
    SF_SetSubraceFeat("EarthGenasi", FEAT_ALERTNESS);
}

void LoadSubrace_WaterGenasi() {
    SF_CreateNewSubrace("WaterGenasi", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_watergenasi");
    SF_SetSubraceRaceRestriction("WaterGenasi", ALLOW_USE_TRUE, RACE_RESTRICT_HUMAN);
    SF_AdjustSubraceStats("WaterGenasi", 0, 0, 2, 0, 0, -2);
    SF_SetSubraceAppearanceColor("WaterGenasi", 48, 136);
    SF_SetSubraceFeat("WaterGenasi", FEAT_RESIST_ENERGY_COLD);
    SF_SetSubraceFeat("WaterGenasi", FEAT_ALERTNESS);
}

/// Half-Orcs ///

void LoadSubrace_MountainOrc() {
    SF_CreateNewSubrace("MountainOrc", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_mountainorc");
    SF_SetSubraceRaceRestriction("MountainOrc", ALLOW_USE_TRUE, RACE_RESTRICT_HALFORC);
    SF_AdjustSubraceStats("MountainOrc", 2, 0, 1, 0, -2, 0);
    SF_SetSubraceFeat("MountainOrc", FEAT_ALERTNESS);
}

void LoadSubrace_Ondonti() {
    SF_CreateNewSubrace("Ondonti", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_odnonti");
    SF_SetSubraceRaceRestriction("Ondonti", ALLOW_USE_TRUE, RACE_RESTRICT_HALFORC);
    SF_AdjustSubraceStats("Ondonti", 2, -2, -1, 0, 2, 0);
    SF_SetSubraceFeat("Ondonti", FEAT_ALERTNESS);
}

// Gnomes ///

void LoadSubrace_RockGnome() {
    SF_CreateNewSubrace("RockGnome", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_rockgnome");
    SF_SetSubraceRaceRestriction("RockGnome", ALLOW_USE_TRUE, RACE_RESTRICT_GNOME);
    SF_AdjustSubraceStats("RockGnome", 0, -2, 2, 0, 0, 0);
    SF_SetSubraceFeat("RockGnome", FEAT_ALERTNESS);
}

void LoadSubrace_DeepGnome() {
    SF_CreateNewSubrace("DeepGnome", APPEARANCE_TYPE_INVALID, APPEARANCE_TYPE_INVALID, "skin_deepgnome");
    SF_SetSubraceRaceRestriction("DeepGnome", ALLOW_USE_TRUE, RACE_RESTRICT_GNOME);
    SF_AdjustSubraceStats("DeepGnome", 2, -2, 0, 0, 2, -2);
    SF_SetSubraceFeat("DeepGnome", FEAT_ALERTNESS);
}

void main()
{
    LoadSubrace_UndeadHalfElf();
    LoadSubrace_Ettin();
    //LoadSubrace_Shielddwarf();
    LoadSubrace_Ogre();
    LoadSubrace_Seahag();
    LoadSubrace_Gnoll();
    LoadSubrace_Azer();
    LoadSubrace_Duergar();
    LoadSubrace_ArcticDwarf();
    LoadSubrace_Avariel();
    LoadSubrace_Drow();
    LoadSubrace_Darkelf();
    LoadSubrace_Dopkalfar();
    LoadSubrace_Ljosalfar();
    LoadSubrace_Svirfneblin();
    LoadSubrace_Kobold();
    LoadSubrace_Aasimar();
    LoadSubrace_Tiefling();

    // Cory - New Subs
    LoadSubrace_EarthGenasi();
    LoadSubrace_WaterGenasi();
    LoadSubrace_MountainOrc();
    LoadSubrace_Ondonti();
    LoadSubrace_RockGnome();
    LoadSubrace_DeepGnome();
}

