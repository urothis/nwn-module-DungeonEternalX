//::///////////////////////////////////////////////
//:: Scarface's Leto Subrace System
//:: Subrace Constants Include
//:: sfsubr_consts
//:://////////////////////////////////////////////
/*
    Written By Scarface
*/
//:://////////////////////////////////////////////

// Server Vault Directory - Must contain forward slash "/" NOT back slash "\"
string NWN_SERVERVAULT_DIR = "C:/NWNServer/servervault/";
string NWN_2DA_DIR = "C:/NWNServer/source/";

//:: The path to your NWN folder:
const string NWNPATH = "C:/NWNServer/";

// :: If set to TRUE then players will not have to re-login to the server manually...
// :: it would be a seemless transistion.
const int LETO_ACTIVATE_PORTAL = TRUE;

//****---- You MUST fill in these settings if LETO_ACTIVATE_PORTAL to TRUE -----****

// :: The IP address of your server.
// :: Example: "192.168.0.100:5121"
const string LETO_PORTAL_IP_ADDRESS = "server.dungeoneternalx.com:51475";

// :: The server's log-in password for the player:
const string LETO_PORAL_SERVER_PASSWORD = "";

// :: If set to TRUE it will use SQL NWNX databases.
// :: NWNX must be installed for this to work! Refer to sha_subr_methds for more
// :: details.
const int ENABLE_NWNX_DATABASE = TRUE;

// :: Name of the Subrace Database.
// :: Dafult Value: SUBRACE_DB
const string SUBRACE_DATABASE = "SUBRACE_DB";

// :: String stored in the SUBRACE_DATABASE to indicate that changes to character file
// :: have already been done.
const string LETO_CHANGES_MADE_FOR_THIS_LEVEL = "LTO_D";

// :: Tag of the Subrace information storer object.
// :: Default value:  _SUBRACE_STORE
const string SUBRACE_INFO_STORER_TAG = "_SUBRACE_STORE";

//:: An internal tag used as starting name of the Local <Strings, Int and Float>
//:: stored on the PC/Storer.
//:: Dafult Value: SBRCE
const string SUBRACE_TAG = "SBRCE";

// Global Variables
object MODULE = GetModule();
const string ID_ITEM = "sf_id_item";

// Global Binary Representation Constants
const int ALLOW_USE_TRUE    = 2048;
const int ALLOW_USE_FALSE   = 4096;

//constants for flags!!!//

const int FLAG1           = 0x00000001;
const int FLAG2           = 0x00000002;
const int FLAG3           = 0x00000004;
const int FLAG4           = 0x00000008;
const int FLAG5           = 0x00000010;
const int FLAG6           = 0x00000020;
const int FLAG7           = 0x00000040;
const int FLAG8           = 0x00000080;
const int FLAG9           = 0x00000100;
const int FLAG10          = 0x00000200;
const int FLAG11          = 0x00000400;
const int FLAG12          = 0x00000800;
const int FLAG13          = 0x00001000;
const int FLAG14          = 0x00002000;
const int FLAG15          = 0x00004000;
const int FLAG16          = 0x00008000;
const int FLAG17          = 0x00010000;
const int FLAG18          = 0x00020000;
const int FLAG19          = 0x00040000;
const int FLAG20          = 0x00080000;
const int FLAG21          = 0x00100000;
const int FLAG22          = 0x00200000;
const int FLAG23          = 0x00400000;
const int FLAG24          = 0x00800000;
const int FLAG25          = 0x01000000;
const int FLAG26          = 0x02000000;
const int FLAG27          = 0x04000000;
const int FLAG28          = 0x08000000;
const int FLAG29          = 0x10000000;
const int FLAG30          = 0x20000000;
const int FLAG31          = 0x40000000;
const int FLAG32          = 0x80000000;
const int ALLFLAGS        = 0xFFFFFFFF;
const int NOFLAGS         = 0x00000000;


const int TINYGROUP1      = 0x0000000F; // 4 Flags per group. 8 groups per flagset.
const int TINYGROUP2      = 0x000000F0; // Value range 0-15.
const int TINYGROUP3      = 0x00000F00;
const int TINYGROUP4      = 0x0000F000;
const int TINYGROUP5      = 0x000F0000;
const int TINYGROUP6      = 0x00F00000;
const int TINYGROUP7      = 0x0F000000;
const int TINYGROUP8      = 0xF0000000;
const int ALLTINYGROUPS   = 0xFFFFFFFF;

const int SMALLGROUP1     = 0x0000003F; // 6 Flags per group. 5 groups per flagset plus 1 extra group with only 2 flags.
const int SMALLGROUP2     = 0x00000FC0; // Value range 0-63.
const int SMALLGROUP3     = 0x0003F000;
const int SMALLGROUP4     = 0x00FC0000;
const int SMALLGROUP5     = 0x3F000000;
const int SMALLGROUPX     = 0xC0000000; // Special Group with only 2 flags. Value range 0-3.
const int ALLSMALLGROUPS  = 0x3FFFFFFF;

const int MEDIUMGROUP1    = 0x000000FF; // 8 Flags per group. 4 groups per flagset.
const int MEDIUMGROUP2    = 0x0000FF00; // Value range 0-255.
const int MEDIUMGROUP3    = 0x00FF0000;
const int MEDIUMGROUP4    = 0xFF000000;
const int ALLMEDIUMGROUPS = 0xFFFFFFFF;

const int LARGEGROUP1     = 0x000003FF; // 10 Flags per group. 3 groups per flagset plus 1 extra group with only 2 flags.
const int LARGEGROUP2     = 0x000FFC00; // Value range 0-1023
const int LARGEGROUP3     = 0x3FF00000;
const int LARGEGROUPX     = 0xC0000000; // Special Group with only 2 flags. Value range 0-3.
const int ALLLARGEGROUPS  = 0x3FFFFFFF;

const int HUGEGROUP1      = 0x0000FFFF; // 16 Flags per group. 2 groups per flagset.
const int HUGEGROUP2      = 0xFFFF0000; // Value range 0-65535
const int ALLHUGEGROUPS   = 0xFFFFFFFF;

const int ALLGROUPS       = 0xFFFFFFFF;
const int GROUPVALUE      = 0xFFFFFFFF;
const int NOGROUPS        = 0x00000000;

// Class Type Binary Representation Constants
const int CLASS_RESTRICT_BARBARIAN = 1;
const int CLASS_RESTRICT_BARD      = 2;
const int CLASS_RESTRICT_CLERIC    = 4;
const int CLASS_RESTRICT_DRUID     = 8;
const int CLASS_RESTRICT_FIGHTER   = 16;
const int CLASS_RESTRICT_MONK      = 32;
const int CLASS_RESTRICT_PALADIN   = 64;
const int CLASS_RESTRICT_RANGER    = 128;
const int CLASS_RESTRICT_ROGUE     = 256;
const int CLASS_RESTRICT_SORCERER  = 512;
const int CLASS_RESTRICT_WIZARD    = 1024;

// Racial Type Binary Representation Constants
const int RACE_RESTRICT_DWARF      = 1;
const int RACE_RESTRICT_ELF        = 2;
const int RACE_RESTRICT_GNOME      = 4;
const int RACE_RESTRICT_HALFELF    = 8;
const int RACE_RESTRICT_HALFLING   = 16;
const int RACE_RESTRICT_HALFORC    = 32;
const int RACE_RESTRICT_HUMAN      = 64;

// Alignment Binary Representation Constants
const int ALIGN_RESTRICT_GOOD       = 1;
const int ALIGN_RESTRICT_NEUTRAL1   = 2;
const int ALIGN_RESTRICT_EVIL       = 4;
const int ALIGN_RESTRICT_LAWFUL     = 8;
const int ALIGN_RESTRICT_NEUTRAL2   = 16;
const int ALIGN_RESTRICT_CHAOTIC    = 32;

// Equipment Size Binary Representation Constants
const int EQUIP_RESTRICT_WEAPON_TINY    = 1;
const int EQUIP_RESTRICT_WEAPON_SMALL   = 2;
const int EQUIP_RESTRICT_WEAPON_MEDIUM  = 4;
const int EQUIP_RESTRICT_WEAPON_LARGE   = 8;
const int EQUIP_RESTRICT_ARMOUR_CLOTH   = 16;
const int EQUIP_RESTRICT_ARMOUR_LIGHT   = 32;
const int EQUIP_RESTRICT_ARMOUR_MEDIUM  = 64;
const int EQUIP_RESTRICT_ARMOUR_HEAVY   = 128;
const int EQUIP_RESTRICT_SHIELD_SMALL   = 256;
const int EQUIP_RESTRICT_SHIELD_LARGE   = 512;
const int EQUIP_RESTRICT_SHIELD_TOWER   = 1024;

// Wing Types - [Normal]
const int WINGS_TYPE_NONE          = 0;
const int WINGS_TYPE_DEMON         = 1;
const int WINGS_TYPE_ANGEL         = 2;
const int WINGS_TYPE_BAT           = 3;
const int WINGS_TYPE_DRAGON_RED    = 4;
const int WINGS_TYPE_BUTTERFLY     = 5;
const int WINGS_TYPE_BIRD          = 6;

// Wing Types - [CEP]
const int WINGS_TYPE_ERINYES       = 30;
const int WINGS_TYPE_BIRD_RED      = 31;
const int WINGS_TYPE_BIRD_BLACK    = 32;
const int WINGS_TYPE_BIRD_BLUE     = 33;
const int WINGS_TYPE_DRAGON_BLACK  = 34;
const int WINGS_TYPE_DRAGON_BLUE   = 35;
const int WINGS_TYPE_DRAGON_BRASS  = 36;
const int WINGS_TYPE_DRAGON_BRONZE = 37;
const int WINGS_TYPE_DRAGON_COPPER = 38;
const int WINGS_TYPE_DRAGON_GOLD   = 39;
const int WINGS_TYPE_DRAGON_GREEN  = 40;
const int WINGS_TYPE_DRAGON_SILVER = 41;
const int WINGS_TYPE_DRAGON_WHITE  = 42;

// Tail Types
const int TAIL_TYPE_NONE           = 0;
const int TAIL_TYPE_LIZARD         = 1;
const int TAIL_TYPE_BONE           = 2;
const int TAIL_TYPE_DEVIL          = 3;


const string SUBRACE_BONUS_SKILL_FLAGS = "BSKILLS";
const string SUBRACE_BONUS_SKILL_COUNT= "BSKILLS_C";
const int SUBRACE_BONUS_SKILL_FLAG = LARGEGROUP1;
const int SUBRACE_BONUS_SKILL_MODIFIER_FLAG = LARGEGROUP2;
const int SUBRACE_BONUS_SKILL_REMOVE_FLAG = LARGEGROUP3;

// Character Movement Speed
const int CHARACTER_SPEED_PC        = 0;
const int CHARACTER_SPEED_IMMOBILE  = 1;
const int CHARACTER_SPEED_VERYSLOW  = 2;
const int CHARACTER_SPEED_SLOW      = 3;
const int CHARACTER_SPEED_NORMAL    = 4;
const int CHARACTER_SPEED_FAST      = 5;
const int CHARACTER_SPEED_VERYFAST  = 6;
const int CHARACTER_SPEED_DEFAULT   = 7;
const int CHARACTER_SPEED_DM        = 8;

// Item ResRefs/Tags
const string DEFAULT_SUBRACE_HIDE = "sfsubr_hide";

// Subrace Messages
const string APPLYING_SUBRACE = "<cþ>Your subrace is being applied to your character. Please wait a moment.</c>";
const string APPLYING_SUBRACE_COMPLETE = "<cþ>Subrace application is complete. Enjoy!</c>";
const string APPLYING_SUBRACE_SKIN = "<cþ>Your subrace skin is being applied to your character.</c>";
const string APPLYING_SUBRACE_CLAW = "<cþ>Your subrace claws are being appliedto your character.</c>";
const string APPLYING_SPELL_RESISTANCE = "<cþ>Your subrace spell resistance is being applied to your character.</c>";
const string SUBRACE_ITEMS_APPLIED = "<cþ>Your subrace items have been applied to your character.</c>";
const string INVALID_SUBRACE = "<cþ>Error:</c> <cþþþ>The subrace name you have entered doesn't exist.</c>";
const string INVALID_CLASS = "<cþ>Error:</c> <cþþþ>You have chosen an incorrect class for this subrace.</c>";
const string INVALID_RACE = "<cþ>Error:</c> <cþþþ>You have chosen an incorrect race for this subrace.</c>";
const string INVALID_ALIGNMENT = "<cþ>Error:</c> <cþþþ>You have chosen an incorrect alignment for this subrace.</c>";
const string INVALID_EQUIPMENT = "<cþ>Error:</c> <cþþþ>You can't equip this type of item onto your subrace.</c>";
const string RELEVEL_CHARACTER = "<cþþþ>You must re-level your character.</c>";

