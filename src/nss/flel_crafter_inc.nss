//::///////////////////////////////////////////////
//:: Name Flel's NPC Item Crafters
//:: FileName flel_crafter_inc
//:: Copyright (c) 2005 Floris Barthel
//:://////////////////////////////////////////////
/*
    Include file for crafters. All constants (a ton) are defined here. Also all
    item property adjustments are here. So if you want to change the amount of
    damage mods that can be put on weapons, you're at the right place.
*/

// Max attack/enchancement bonus on weapons
const int MAX_AB_EB_BONUS = 5;

// Allowed number of damage mods on weapons
const int MAX_DAMAGE_DICE_LARGE = 3;
// Allowed number of damage mods on weapons
const int MAX_DAMAGE_DICE_MEDIUM = 2;
// Allowed number of damage mods on weapons
const int MAX_DAMAGE_DICE_SMALL= 2;
// Allowed number of damage mods on weapons
const int MAX_DAMAGE_DICE_THROWING_WEAP = 2;
// Allowed number of damage mods on weapons
const int MAX_DAMAGE_DICE_AMMO = 1;
// Allowed number of damage mods on gloves
const int MAX_DAMAGE_DICE_GLOVES = 3;
// Damage granted per mod
const int MAX_DAMAGE_PER_MOD = 12;

// Allowed number of weapon OnHit's
const int MAX_ONHITS = 1;
// Allowed amount of mighty on ranged/throwing weapons
const int MAX_MIGHTY = 16;

// Max AC bonus on items
const int MAX_AC_BONUS = 5;
//const int MAX_SHIELD_AC_BONUS = 8;
// Max ability bonus on items
const int MAX_ABILITY_BONUS = 8;
// Max skill point bonus on items
const int MAX_SKILL_BONUS = 4;
// Max saving throw bonus on items
const int MAX_SAVE_BONUS = 5;
// Max saving throw vs effects on items
const int MAX_SAVE_EFFECT_BONUS = 3;
// Max number of bonus spell slots on items
const int MAX_BONUS_SPELLSLOTS = 1;
// Maximum regeneration allowed on items
const int MAX_REGEN = 2;
// Maximum vamp regen allowed on weapons
const int MAX_VAMP_REGEN = 6;

/*******************************************************************************
************************** DO NOT EDIT BELOW THIS LINE *************************
*******************************************************************************/

// Item container. Object variable stored on the crafter NPC which holds
// the working item
const string ITEM = "ITEM";

// CURRENT_ line of vars keeps track of what and how much of certain
// properties have been added to items in order to prevent exploiting
// Values are unsigned integers
const string CURRENT_ABILITY_BONUS = "CURRENT_ABILITY_BONUS";
const string CURRENT_REGEN = "CURRENT_REGEN";
const string CURRENT_SKILL_BONUS = "CURRENT_SKILL_BONUS";
const string CURRENT_SAVE_BONUS = "CURRENT_SAVE_BONUS";
const string CURRENT_SAVE_EFFECT_BONUS = "CURRENT_SAVE_EFFECT_BONUS";
const string CURRENT_BONUS_SPELLSLOTS = "CURRENT_BONUS_SPELLSLOTS";
const string CURRENT_VAMP_REGEN = "CURRENT_VAMP_REGEN";
const string CURRENT_DAMAGE_DICE = "CURRENT_DAMAGE_DICE";
const string CURRENT_ONHITS = "CURRENT_ONHITS";

// _SELECTED line of vars keep track of the values submitted in multi-menu
// item properties so they can be recalled when creating the item property
// Values are unsigned integers
const string ABILITY_TYPE_SELECTED = "ABILITY_TYPE_SELECTED";
const string SKILL_TYPE_SELECTED = "SKILL_TYPE_SELECTED";
const string DAMAGE_TYPE_SELECTED = "DAMAGE_TYPE_SELECTED";
const string SAVE_TYPE_SELECTED = "SAVE_TYPE_SELECTED";
const string SAVE_EFFECT_TYPE_SELECTED = "SAVE_EFFECT_TYPE_SELECTED";
const string SPELLSLOT_CLASS_SELECTED = "SPELLSLOT_CLASS_SELECTED";
const string LIGHT_BRIGHTNESS_SELECTED = "LIGHT_BRIGHTNESS_SELECTED";
const string ONHIT_TYPE_SELECTED = "ONHIT_TYPE_SELECTED";
const string ONHIT_DC_SELECTED = "ONHIT_DC_SELECTED";

// SELECTOR var stores the viewing page on the PC
// Values are constants of the SELECT_ prefex, all unsigned integers
const string SELECTOR = "SELECTOR";
const string LAST_SELECTOR = "LAST_SELECTOR";

// SELECT_ line of constant used by PC local var SELECTOR and by the program
// to select which page to display
// All of them are unique unsigned integers
const int SELECT_WEAPON =           1;
const int SELECT_WEAPON_SMALL =     2;
const int SELECT_WEAPON_MEDIUM =    3;
const int SELECT_WEAPON_LARGE =     4;
const int SELECT_EB =                5;
const int SELECT_AB =                6;
const int SELECT_DAMAGE_TYPE =       7;
const int SELECT_DAMAGE_DIE =        8;
const int SELECT_ONHIT_TYPE =        9;
const int SELECT_ONHIT_DC =          10;
const int SELECT_ONHIT_DURATION =    11;
const int SELECT_WEAPON_PROPERTIES = 12;
const int SELECT_MASSCRITS =         13;
const int SELECT_VAMP_REGEN =        14;
const int SELECT_WEAPON_RANGED =     15;
const int SELECT_KEEN =              16;
const int SELECT_MIGHTY =            17;
const int SELECT_MONK_GLOVES =       18;
const int SELECT_MAGIC_ITEM =        19;
const int SELECT_ITEM_PROPERTIES =   20;
const int SELECT_OTHER_ITEM_PROPS =  21;
const int SELECT_CONFIRM_DIALOG =    22;
const int SELECT_AC_B =              23;
const int SELECT_ABILITY_TYPE =      24;
const int SELECT_ABILITY_BONUS =     25;
const int SELECT_SKILL_TYPE =        26;
const int SELECT_SKILL_BONUS =       27;
const int SELECT_SAVE_TYPE =         28;
const int SELECT_SAVE_BONUS =        29;
const int SELECT_SAVE_EFFECT_TYPE =  30;
const int SELECT_SAVE_EFFECT_BONUS = 31;
const int SELECT_BONUS_SPELLSLOT =   32;
const int SELECT_SPELLSLOT_LEVEL =   33;
const int SELECT_REGEN =             34;
const int SELECT_HASTE =             35;
const int SELECT_DARKVISION =        36;
const int SELECT_LIGHT_BRIGHTNESS =  37;
const int SELECT_LIGHT_COLOR =       38;
const int SELECT_ARMOR =             39;
const int SELECT_ARMOR_HEAVY =       40;
const int SELECT_ARMOR_MEDIUM =      41;
const int SELECT_ARMOR_LIGHT =       42;
const int SELECT_ARMOR_SHIELD =      43;
const int SELECT_ARMOR_HELMET =      44;
const int SELECT_ARMOR_ROBES =       45;
const int SELECT_PROJECTILE =        46;
const int SELECT_AMMUNITION =        47;
const int SELECT_THROWING_WEAPON =   48;
const int SELECT_ONHIT_DISEASE =     49;
const int SELECT_ONHIT_POISON =      50;
const int SELECT_ONHIT_ABILITYDRAIN =51;
const int SELECT_NAV_BACK =          52;
const int SELECT_NAV_RETURN =        53;
const int SELECT_NAV_EXAMINE =       54;

const string SHOWING = "SHOWING";

// SHOW constants for item properties
const int SHOW_ABILITY_BONUS = 1;
const int SHOW_SKILL_BONUS = 2;
const int SHOW_SAVE_BONUS = 4;
const int SHOW_SAVE_EFFECT_BONUS = 8;
const int SHOW_BONUS_SPELLSLOT = 16;
const int SHOW_REGEN = 32;
const int SHOW_ITEM_PROPERTIES = 63; // SHOW_ABILITY_BONUS | SHOW_SKILL_BONUS | SHOW_SAVE_BONUS | SHOW_SAVE_EFFECT_BONUS | SHOW_BONUS_SPELLSLOTS | SHOW_REGEN
const int SHOW_EB = 64;
const int SHOW_AB = 128;
const int SHOW_KEEN = 256;
const int SHOW_DAMAGE_BONUS = 512;
const int SHOW_MASSCRITS = 1024;
const int SHOW_VAMP_REGEN = 2048;
const int SHOW_ONHIT = 4096;
const int SHOW_MIGHTY = 8192;
const int SHOW_WEAPON_PROPERTIES = 16320; // SHOW_MIGHTY | SHOW_ONHIT | SHOW_VAMP_REGEN | SHOW_MASSCRITS | SHOW_DAMAGE_BONUS | SHOW_KEEN | SHOW_AB | SHOW_EB
const int SHOW_ALL = 16383; // ALL
const int SHOW_NAV_BACK = 16384;
const int SHOW_NAV_RETURN = 32768;

// List IDs that store lists
const string LIST = "LIST";
// Resref list for item creation
const string RESREF = "RESREF";

//Max dmg dice
const string MAX_DAMAGE_DICE = "MAX_DAMAGE_DICE";
