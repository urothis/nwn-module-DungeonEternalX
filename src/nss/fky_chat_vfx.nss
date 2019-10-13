//::////////////////////////////////////////////////////////////////////////:://
//:: SIMTools V3.0 Speech Integration & Management Tools Version 3.0        :://
//:: Created By: FunkySwerve                                                :://
//:: Created On: April 4 2006                                               :://
//:: Last Updated: March 27 2007                                            :://
//:: With Thanks To:                                                        :://
//:: Dumbo - for his amazing plugin                                         :://
//:: Virusman - for Linux versions, and for the reset plugin, and for       :://
//::    his excellent events plugin, without which this update would not    :://
//::    be possible                                                         :://
//:: Dazzle - for his script samples                                        :://
//:: Butch - for the emote wand scripts                                     :://
//:: The DMFI project - for the languages conversions and many of the emotes:://
//:: Lanessar and the players of the Myth Drannor PW - for the new languages:://
//:: The players and DMs of Higher Ground for their input and playtesting   :://
//::////////////////////////////////////////////////////////////////////////:://
#include "fky_chat_const"
string GetVFXName(int nVFX)
{
    string sReturn = "";
    switch (nVFX/100)
    {
        case 0:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 0: sReturn = "VFX_DUR_BLUR"; break;
case 1: sReturn = "VFX_DUR_DARKNESS"; break;
case 2: sReturn = "VFX_DUR_ENTANGLE"; break;
case 3: sReturn = "VFX_DUR_FREEDOM_OF_MOVEMENT"; break;
case 4: sReturn = "VFX_DUR_GLOBE_INVULNERABILITY"; break;
case 5: sReturn = "VFX_DUR_BLACKOUT"; break;
case 6: sReturn = "VFX_DUR_INVISIBILITY"; break;
case 7: sReturn = "VFX_DUR_MIND_AFFECTING_NEGATIVE"; break;
case 8: sReturn = "VFX_DUR_MIND_AFFECTING_POSITIVE"; break;
case 9: sReturn = "VFX_DUR_GHOSTLY_VISAGE"; break;
case 10: sReturn = "VFX_DUR_ETHEREAL_VISAGE"; break;
case 11: sReturn = "VFX_DUR_PROT_BARKSKIN"; break;
case 12: sReturn = "VFX_DUR_PROT_GREATER_STONESKIN"; break;
case 13: sReturn = "VFX_DUR_PROT_PREMONITION"; break;
case 14: sReturn = "VFX_DUR_PROT_SHADOW_ARMOR"; break;
case 15: sReturn = "VFX_DUR_PROT_STONESKIN"; break;
case 16: sReturn = "VFX_DUR_SANCTUARY"; break;
case 17: sReturn = "VFX_DUR_WEB"; break;
case 18: sReturn = "VFX_FNF_BLINDDEAF"; break;
case 19: sReturn = "VFX_FNF_DISPEL"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 20: sReturn = "VFX_FNF_DISPEL_DISJUNCTION"; break;
case 21: sReturn = "VFX_FNF_DISPEL_GREATER"; break;
case 22: sReturn = "VFX_FNF_FIREBALL"; break;
case 23: sReturn = "VFX_FNF_FIRESTORM"; break;
case 24: sReturn = "VFX_FNF_IMPLOSION"; break;
//case 25: sReturn = "VFX_FNF_MASS_HASTE"; break;
case 26: sReturn = "VFX_FNF_MASS_HEAL"; break;
case 27: sReturn = "VFX_FNF_MASS_MIND_AFFECTING"; break;
case 28: sReturn = "VFX_FNF_METEOR_SWARM"; break;
case 29: sReturn = "VFX_FNF_NATURES_BALANCE"; break;
case 30: sReturn = "VFX_FNF_PWKILL"; break;
case 31: sReturn = "VFX_FNF_PWSTUN"; break;
case 32: sReturn = "VFX_FNF_SUMMON_GATE"; break;
case 33: sReturn = "VFX_FNF_SUMMON_MONSTER_1"; break;
case 34: sReturn = "VFX_FNF_SUMMON_MONSTER_2"; break;
case 35: sReturn = "VFX_FNF_SUMMON_MONSTER_3"; break;
case 36: sReturn = "VFX_FNF_SUMMON_UNDEAD"; break;
case 37: sReturn = "VFX_FNF_SUNBEAM"; break;
case 38: sReturn = "VFX_FNF_TIME_STOP"; break;
case 39: sReturn = "VFX_FNF_WAIL_O_BANSHEES"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 40: sReturn = "VFX_FNF_WEIRD"; break;
case 41: sReturn = "VFX_FNF_WORD"; break;
case 42: sReturn = "VFX_IMP_AC_BONUS"; break;
case 43: sReturn = "VFX_IMP_ACID_L"; break;
case 44: sReturn = "VFX_IMP_ACID_S"; break;
//case 45: sReturn = "VFX_IMP_ALTER_WEAPON"; break;
case 46: sReturn = "VFX_IMP_BLIND_DEAF_M"; break;
case 47: sReturn = "VFX_IMP_BREACH"; break;
case 48: sReturn = "VFX_IMP_CONFUSION_S"; break;
case 49: sReturn = "VFX_IMP_DAZED_S"; break;
case 50: sReturn = "VFX_IMP_DEATH"; break;
case 51: sReturn = "VFX_IMP_DISEASE_S"; break;
case 52: sReturn = "VFX_IMP_DISPEL"; break;
case 53: sReturn = "VFX_IMP_DISPEL_DISJUNCTION"; break;
case 54: sReturn = "VFX_IMP_DIVINE_STRIKE_FIRE"; break;
case 55: sReturn = "VFX_IMP_DIVINE_STRIKE_HOLY"; break;
case 56: sReturn = "VFX_IMP_DOMINATE_S"; break;
case 57: sReturn = "VFX_IMP_DOOM"; break;
case 58: sReturn = "VFX_IMP_FEAR_S"; break;
//case 59: sReturn = "VFX_IMP_FLAME_L"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 60: sReturn = "VFX_IMP_FLAME_M"; break;
case 61: sReturn = "VFX_IMP_FLAME_S"; break;
case 62: sReturn = "VFX_IMP_FROST_L"; break;
case 63: sReturn = "VFX_IMP_FROST_S"; break;
case 64: sReturn = "VFX_IMP_GREASE"; break;
case 65: sReturn = "VFX_IMP_HASTE"; break;
case 66: sReturn = "VFX_IMP_HEALING_G"; break;
case 67: sReturn = "VFX_IMP_HEALING_L"; break;
case 68: sReturn = "VFX_IMP_HEALING_M"; break;
case 69: sReturn = "VFX_IMP_HEALING_S"; break;
case 70: sReturn = "VFX_IMP_HEALING_X"; break;
case 71: sReturn = "VFX_IMP_HOLY_AID"; break;
case 72: sReturn = "VFX_IMP_KNOCK"; break;
case 73: sReturn = "VFX_BEAM_LIGHTNING"; break;
case 74: sReturn = "VFX_IMP_LIGHTNING_M"; break;
case 75: sReturn = "VFX_IMP_LIGHTNING_S"; break;
case 76: sReturn = "VFX_IMP_MAGBLUE"; break;
//case 77: sReturn = "VFX_IMP_MAGBLUE2"; break;
//case 78: sReturn = "VFX_IMP_MAGBLUE3"; break;
//case 79: sReturn = "VFX_IMP_MAGBLUE4"; break;
            }
            break;
            case 4:
            switch (nVFX)
            {
//case 80: sReturn = "VFX_IMP_MAGBLUE5"; break;
case 81: sReturn = "VFX_IMP_NEGATIVE_ENERGY"; break;
case 82: sReturn = "VFX_DUR_PARALYZE_HOLD"; break;
case 83: sReturn = "VFX_IMP_POISON_L"; break;
case 84: sReturn = "VFX_IMP_POISON_S"; break;
case 85: sReturn = "VFX_IMP_POLYMORPH"; break;
case 86: sReturn = "VFX_IMP_PULSE_COLD"; break;
case 87: sReturn = "VFX_IMP_PULSE_FIRE"; break;
case 88: sReturn = "VFX_IMP_PULSE_HOLY"; break;
case 89: sReturn = "VFX_IMP_PULSE_NEGATIVE"; break;
case 90: sReturn = "VFX_IMP_RAISE_DEAD"; break;
case 91: sReturn = "VFX_IMP_REDUCE_ABILITY_SCORE"; break;
case 92: sReturn = "VFX_IMP_REMOVE_CONDITION"; break;
case 93: sReturn = "VFX_IMP_SILENCE"; break;
case 94: sReturn = "VFX_IMP_SLEEP"; break;
case 95: sReturn = "VFX_IMP_SLOW"; break;
case 96: sReturn = "VFX_IMP_SONIC"; break;
case 97: sReturn = "VFX_IMP_STUN"; break;
case 98: sReturn = "VFX_IMP_SUNSTRIKE"; break;
case 99: sReturn = "VFX_IMP_UNSUMMON"; break;
            }
            break;
        }
        break;
        case 1:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 100: sReturn = "VFX_COM_SPECIAL_BLUE_RED"; break;
case 101: sReturn = "VFX_COM_SPECIAL_PINK_ORANGE"; break;
case 102: sReturn = "VFX_COM_SPECIAL_RED_WHITE"; break;
case 103: sReturn = "VFX_COM_SPECIAL_RED_ORANGE"; break;
case 104: sReturn = "VFX_COM_SPECIAL_WHITE_BLUE"; break;
case 105: sReturn = "VFX_COM_SPECIAL_WHITE_ORANGE"; break;
case 106: sReturn = "VFX_COM_BLOOD_REG_WIMP"; break;
case 107: sReturn = "VFX_COM_BLOOD_LRG_WIMP"; break;
case 108: sReturn = "VFX_COM_BLOOD_CRT_WIMP"; break;
case 109: sReturn = "VFX_COM_BLOOD_REG_RED"; break;
case 110: sReturn = "VFX_COM_BLOOD_REG_GREEN"; break;
case 111: sReturn = "VFX_COM_BLOOD_REG_YELLOW"; break;
case 112: sReturn = "VFX_COM_BLOOD_LRG_RED"; break;
case 113: sReturn = "VFX_COM_BLOOD_LRG_GREEN"; break;
case 114: sReturn = "VFX_COM_BLOOD_LRG_YELLOW"; break;
case 115: sReturn = "VFX_COM_BLOOD_CRT_RED"; break;
case 116: sReturn = "VFX_COM_BLOOD_CRT_GREEN"; break;
case 117: sReturn = "VFX_COM_BLOOD_CRT_YELLOW"; break;
case 118: sReturn = "VFX_COM_SPARKS_PARRY"; break;
//case 119: sReturn = "VFX_COM_GIB"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 120: sReturn = "VFX_COM_UNLOAD_MODEL"; break;
case 121: sReturn = "VFX_COM_CHUNK_RED_SMALL"; break;
case 122: sReturn = "VFX_COM_CHUNK_RED_MEDIUM"; break;
case 123: sReturn = "VFX_COM_CHUNK_GREEN_SMALL"; break;
case 124: sReturn = "VFX_COM_CHUNK_GREEN_MEDIUM"; break;
case 125: sReturn = "VFX_COM_CHUNK_YELLOW_SMALL"; break;
case 126: sReturn = "VFX_COM_CHUNK_YELLOW_MEDIUM"; break;
/*case 127: sReturn = "VFX_ITM_ACID"; break;
case 128: sReturn = "VFX_ITM_FIRE"; break;
case 129: sReturn = "VFX_ITM_FROST"; break;
case 130: sReturn = "VFX_ITM_ILLUMINATED_BLUE"; break;
case 131: sReturn = "VFX_ITM_ILLUMINATED_PURPLE"; break;
case 132: sReturn = "VFX_ITM_ILLUMINATED_RED"; break;
case 133: sReturn = "VFX_ITM_LIGHTNING"; break;
case 134: sReturn = "VFX_ITM_PULSING_BLUE"; break;
case 135: sReturn = "VFX_ITM_PULSING_PURPLE"; break;
case 136: sReturn = "VFX_ITM_PULSING_RED"; break;
case 137: sReturn = "VFX_ITM_SMOKING"; break;*/
case 138: sReturn = "VFX_DUR_SPELLTURNING"; break;
case 139: sReturn = "VFX_IMP_IMPROVE_ABILITY_SCORE"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 140: sReturn = "VFX_IMP_CHARM"; break;
case 141: sReturn = "VFX_IMP_MAGICAL_VISION"; break;
//case 142: sReturn = "VFX_IMP_LAW_HELP"; break;
//case 143: sReturn = "VFX_IMP_CHAOS_HELP"; break;
case 144: sReturn = "VFX_IMP_EVIL_HELP"; break;
case 145: sReturn = "VFX_IMP_GOOD_HELP"; break;
case 146: sReturn = "VFX_IMP_DEATH_WARD"; break;
case 147: sReturn = "VFX_DUR_ELEMENTAL_SHIELD"; break;
case 148: sReturn = "VFX_DUR_LIGHT"; break;
case 149: sReturn = "VFX_IMP_MAGIC_PROTECTION"; break;
case 150: sReturn = "VFX_IMP_SUPER_HEROISM"; break;
case 151: sReturn = "VFX_FNF_STORM"; break;
case 152: sReturn = "VFX_IMP_ELEMENTAL_PROTECTION"; break;
case 153: sReturn = "VFX_DUR_LIGHT_BLUE_5"; break;
case 154: sReturn = "VFX_DUR_LIGHT_BLUE_10"; break;
case 155: sReturn = "VFX_DUR_LIGHT_BLUE_15"; break;
case 156: sReturn = "VFX_DUR_LIGHT_BLUE_20"; break;
case 157: sReturn = "VFX_DUR_LIGHT_YELLOW_5"; break;
case 158: sReturn = "VFX_DUR_LIGHT_YELLOW_10"; break;
case 159: sReturn = "VFX_DUR_LIGHT_YELLOW_15"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 160: sReturn = "VFX_DUR_LIGHT_YELLOW_20"; break;
case 161: sReturn = "VFX_DUR_LIGHT_PURPLE_5"; break;
case 162: sReturn = "VFX_DUR_LIGHT_PURPLE_10"; break;
case 163: sReturn = "VFX_DUR_LIGHT_PURPLE_15"; break;
case 164: sReturn = "VFX_DUR_LIGHT_PURPLE_20"; break;
case 165: sReturn = "VFX_DUR_LIGHT_RED_5"; break;
case 166: sReturn = "VFX_DUR_LIGHT_RED_10"; break;
case 167: sReturn = "VFX_DUR_LIGHT_RED_15"; break;
case 168: sReturn = "VFX_DUR_LIGHT_RED_20"; break;
case 169: sReturn = "VFX_DUR_LIGHT_ORANGE_5"; break;
case 170: sReturn = "VFX_DUR_LIGHT_ORANGE_10"; break;
case 171: sReturn = "VFX_DUR_LIGHT_ORANGE_15"; break;
case 172: sReturn = "VFX_DUR_LIGHT_ORANGE_20"; break;
case 173: sReturn = "VFX_DUR_LIGHT_WHITE_5"; break;
case 174: sReturn = "VFX_DUR_LIGHT_WHITE_10"; break;
case 175: sReturn = "VFX_DUR_LIGHT_WHITE_15"; break;
case 176: sReturn = "VFX_DUR_LIGHT_WHITE_20"; break;
case 177: sReturn = "VFX_DUR_LIGHT_GREY_5"; break;
case 178: sReturn = "VFX_DUR_LIGHT_GREY_10"; break;
case 179: sReturn = "VFX_DUR_LIGHT_GREY_15"; break;
            }
            break;
            case 4:
            switch (nVFX)
            {
case 180: sReturn = "VFX_DUR_LIGHT_GREY_20"; break;
case 181: sReturn = "VFX_IMP_MIRV"; break;
case 182: sReturn = "VFX_DUR_DARKVISION"; break;
case 183: sReturn = "VFX_FNF_SOUND_BURST"; break;
case 184: sReturn = "VFX_FNF_STRIKE_HOLY"; break;
case 185: sReturn = "VFX_FNF_LOS_EVIL_10"; break;
case 186: sReturn = "VFX_FNF_LOS_EVIL_20"; break;
case 187: sReturn = "VFX_FNF_LOS_EVIL_30"; break;
case 188: sReturn = "VFX_FNF_LOS_HOLY_10"; break;
case 189: sReturn = "VFX_FNF_LOS_HOLY_20"; break;
case 190: sReturn = "VFX_FNF_LOS_HOLY_30"; break;
case 191: sReturn = "VFX_FNF_LOS_NORMAL_10"; break;
case 192: sReturn = "VFX_FNF_LOS_NORMAL_20"; break;
case 193: sReturn = "VFX_FNF_LOS_NORMAL_30"; break;
case 194: sReturn = "VFX_IMP_HEAD_ACID"; break;
case 195: sReturn = "VFX_IMP_HEAD_FIRE"; break;
case 196: sReturn = "VFX_IMP_HEAD_SONIC"; break;
case 197: sReturn = "VFX_IMP_HEAD_ELECTRICITY"; break;
case 198: sReturn = "VFX_IMP_HEAD_COLD"; break;
case 199: sReturn = "VFX_IMP_HEAD_HOLY"; break;
            }
            break;
        }
        break;
        case 2:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 200: sReturn = "VFX_IMP_HEAD_NATURE"; break;
case 201: sReturn = "VFX_IMP_HEAD_HEAL"; break;
case 202: sReturn = "VFX_IMP_HEAD_MIND"; break;
case 203: sReturn = "VFX_IMP_HEAD_EVIL"; break;
case 204: sReturn = "VFX_IMP_HEAD_ODD"; break;
case 205: sReturn = "VFX_DUR_CESSATE_NEUTRAL"; break;
case 206: sReturn = "VFX_DUR_CESSATE_POSITIVE"; break;
case 207: sReturn = "VFX_DUR_CESSATE_NEGATIVE"; break;
case 208: sReturn = "VFX_DUR_MIND_AFFECTING_DISABLED"; break;
case 209: sReturn = "VFX_DUR_MIND_AFFECTING_DOMINATED"; break;
case 210: sReturn = "VFX_BEAM_FIRE"; break;
case 211: sReturn = "VFX_BEAM_COLD"; break;
case 212: sReturn = "VFX_BEAM_HOLY"; break;
case 213: sReturn = "VFX_BEAM_MIND"; break;
case 214: sReturn = "VFX_BEAM_EVIL"; break;
case 215: sReturn = "VFX_BEAM_ODD"; break;
case 216: sReturn = "VFX_BEAM_FIRE_LASH"; break;
case 217: sReturn = "VFX_IMP_DEATH_L"; break;
case 218: sReturn = "VFX_DUR_MIND_AFFECTING_FEAR"; break;
case 219: sReturn = "VFX_FNF_SUMMON_CELESTIAL"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 220: sReturn = "VFX_DUR_GLOBE_MINOR"; break;
case 221: sReturn = "VFX_IMP_RESTORATION_LESSER"; break;
case 222: sReturn = "VFX_IMP_RESTORATION"; break;
case 223: sReturn = "VFX_IMP_RESTORATION_GREATER"; break;
case 224: sReturn = "VFX_DUR_PROTECTION_ELEMENTS"; break;
case 225: sReturn = "VFX_DUR_PROTECTION_GOOD_MINOR"; break;
case 226: sReturn = "VFX_DUR_PROTECTION_GOOD_MAJOR"; break;
case 227: sReturn = "VFX_DUR_PROTECTION_EVIL_MINOR"; break;
case 228: sReturn = "VFX_DUR_PROTECTION_EVIL_MAJOR"; break;
case 229: sReturn = "VFX_DUR_MAGICAL_SIGHT"; break;
case 230: sReturn = "VFX_DUR_WEB_MASS"; break;
case 231: sReturn = "VFX_FNF_ICESTORM"; break;
case 232: sReturn = "VFX_DUR_PARALYZED"; break;
case 233: sReturn = "VFX_IMP_MIRV_FLAME"; break;
case 234: sReturn = "VFX_IMP_DESTRUCTION"; break;
case 235: sReturn = "VFX_COM_CHUNK_RED_LARGE"; break;
case 236: sReturn = "VFX_COM_CHUNK_BONE_MEDIUM"; break;
case 237: sReturn = "VFX_COM_BLOOD_SPARK_SMALL"; break;
case 238: sReturn = "VFX_COM_BLOOD_SPARK_MEDIUM"; break;
case 239: sReturn = "VFX_COM_BLOOD_SPARK_LARGE"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 240: sReturn = "VFX_DUR_GHOSTLY_PULSE"; break;
case 241: sReturn = "VFX_FNF_HORRID_WILTING"; break;
case 242: sReturn = "VFX_DUR_BLINDVISION"; break;
case 243: sReturn = "VFX_DUR_LOWLIGHTVISION"; break;
case 244: sReturn = "VFX_DUR_ULTRAVISION"; break;
case 245: sReturn = "VFX_DUR_MIRV_ACID"; break;
case 246: sReturn = "VFX_IMP_HARM"; break;
case 247: sReturn = "VFX_DUR_BLIND"; break;
case 248: sReturn = "VFX_DUR_ANTI_LIGHT_10"; break;
case 249: sReturn = "VFX_DUR_MAGIC_RESISTANCE"; break;
case 250: sReturn = "VFX_IMP_MAGIC_RESISTANCE_USE"; break;
case 251: sReturn = "VFX_IMP_GLOBE_USE"; break;
case 252: sReturn = "VFX_IMP_WILL_SAVING_THROW_USE"; break;
case 253: sReturn = "VFX_IMP_SPIKE_TRAP"; break;
case 254: sReturn = "VFX_IMP_SPELL_MANTLE_USE"; break;
case 255: sReturn = "VFX_IMP_FORTITUDE_SAVING_THROW_USE"; break;
case 256: sReturn = "VFX_IMP_REFLEX_SAVE_THROW_USE"; break;
case 257: sReturn = "VFX_FNF_GAS_EXPLOSION_ACID"; break;
case 258: sReturn = "VFX_FNF_GAS_EXPLOSION_EVIL"; break;
case 259: sReturn = "VFX_FNF_GAS_EXPLOSION_NATURE"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 260: sReturn = "VFX_FNF_GAS_EXPLOSION_FIRE"; break;
case 261: sReturn = "VFX_FNF_GAS_EXPLOSION_GREASE"; break;
case 262: sReturn = "VFX_FNF_GAS_EXPLOSION_MIND"; break;
case 263: sReturn = "VFX_FNF_SMOKE_PUFF"; break;
case 264: sReturn = "VFX_IMP_PULSE_WATER"; break;
case 265: sReturn = "VFX_IMP_PULSE_WIND"; break;
case 266: sReturn = "VFX_IMP_PULSE_NATURE"; break;
case 267: sReturn = "VFX_DUR_AURA_COLD"; break;
case 268: sReturn = "VFX_DUR_AURA_FIRE"; break;
case 269: sReturn = "VFX_DUR_AURA_POISON"; break;
case 270: sReturn = "VFX_DUR_AURA_DISEASE"; break;
case 271: sReturn = "VFX_DUR_AURA_ODD"; break;
case 272: sReturn = "VFX_DUR_AURA_SILENCE"; break;
case 273: sReturn = "VFX_IMP_AURA_HOLY"; break;
case 274: sReturn = "VFX_IMP_AURA_UNEARTHLY"; break;
case 275: sReturn = "VFX_IMP_AURA_FEAR"; break;
case 276: sReturn = "VFX_IMP_AURA_NEGATIVE_ENERGY"; break;
case 277: sReturn = "VFX_DUR_BARD_SONG"; break;
case 278: sReturn = "VFX_FNF_HOWL_MIND"; break;
case 279: sReturn = "VFX_FNF_HOWL_ODD"; break;
            }
            break;
            case 4:
            switch (nVFX)
            {
case 280: sReturn = "VFX_COM_HIT_FIRE"; break;
case 281: sReturn = "VFX_COM_HIT_FROST"; break;
case 282: sReturn = "VFX_COM_HIT_ELECTRICAL"; break;
case 283: sReturn = "VFX_COM_HIT_ACID"; break;
case 284: sReturn = "VFX_COM_HIT_SONIC"; break;
case 285: sReturn = "VFX_FNF_HOWL_WAR_CRY"; break;
case 286: sReturn = "VFX_FNF_SCREEN_SHAKE"; break;
case 287: sReturn = "VFX_FNF_SCREEN_BUMP"; break;
case 288: sReturn = "VFX_COM_HIT_NEGATIVE"; break;
case 289: sReturn = "VFX_COM_HIT_DIVINE"; break;
case 290: sReturn = "VFX_FNF_HOWL_WAR_CRY_FEMALE"; break;
case 291: sReturn = "VFX_DUR_AURA_DRAGON_FEAR"; break;
            }
            break;
        }
        break;
        case 3:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 303: sReturn = "VFX_DUR_FLAG_RED"; break;
case 304: sReturn = "VFX_DUR_FLAG_BLUE"; break;
case 305: sReturn = "VFX_DUR_FLAG_PURPLE_FIXED"; break;
case 306: sReturn = "VFX_DUR_FLAG_GOLD_FIXED"; break;
case 307: sReturn = "VFX_BEAM_SILENT_LIGHTNING"; break;
case 308: sReturn = "VFX_BEAM_SILENT_FIRE"; break;
case 309: sReturn = "VFX_BEAM_SILENT_COLD"; break;
case 310: sReturn = "VFX_BEAM_SILENT_HOLY"; break;
case 311: sReturn = "VFX_BEAM_SILENT_MIND"; break;
case 312: sReturn = "VFX_BEAM_SILENT_EVIL"; break;
case 313: sReturn = "VFX_BEAM_SILENT_ODD"; break;
case 314: sReturn = "VFX_DUR_BIGBYS_INTERPOSING_HAND"; break;
case 315: sReturn = "VFX_IMP_BIGBYS_FORCEFUL_HAND"; break;
case 316: sReturn = "VFX_DUR_BIGBYS_CLENCHED_FIST"; break;
case 317: sReturn = "VFX_DUR_BIGBYS_CRUSHING_HAND"; break;
case 318: sReturn = "VFX_DUR_BIGBYS_GRASPING_HAND"; break;
case 319: sReturn = "VFX_DUR_CALTROPS"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 320: sReturn = "VFX_DUR_SMOKE"; break;
case 321: sReturn = "VFX_DUR_PIXIEDUST"; break;
case 322: sReturn = "VFX_FNF_DECK"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 346: sReturn = "VFX_DUR_TENTACLE"; break;
case 351: sReturn = "VFX_DUR_PETRIFY"; break;
case 352: sReturn = "VFX_DUR_FREEZE_ANIMATION"; break;
case 353: sReturn = "VFX_COM_CHUNK_STONE_SMALL"; break;
case 354: sReturn = "VFX_COM_CHUNK_STONE_MEDIUM"; break;
case 355: sReturn = "VFX_DUR_CUTSCENE_INVISIBILITY"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 360: sReturn = "VFX_EYES_RED_FLAME_HUMAN_MALE"; break;
case 361: sReturn = "VFX_EYES_RED_FLAME_HUMAN_FEMALE"; break;
case 362: sReturn = "VFX_EYES_RED_FLAME_DWARF_MALE"; break;
case 363: sReturn = "VFX_EYES_RED_FLAME_DWARF_FEMALE"; break;
case 364: sReturn = "VFX_EYES_RED_FLAME_ELF_MALE"; break;
case 365: sReturn = "VFX_EYES_RED_FLAME_ELF_FEMALE"; break;
case 366: sReturn = "VFX_EYES_RED_FLAME_GNOME_MALE"; break;
case 367: sReturn = "VFX_EYES_RED_FLAME_GNOME_FEMALE"; break;
case 368: sReturn = "VFX_EYES_RED_FLAME_HALFLING_MALE"; break;
case 369: sReturn = "VFX_EYES_RED_FLAME_HALFLING_FEMALE"; break;
case 370: sReturn = "VFX_EYES_RED_FLAME_HALFORC_MALE"; break;
case 371: sReturn = "VFX_EYES_RED_FLAME_HALFORC_FEMALE"; break;
case 372: sReturn = "VFX_EYES_RED_FLAME_TROGLODYTE"; break;
            }
            break;
        }
        break;
        case 4:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 403: sReturn = "VFX_DUR_IOUNSTONE"; break;
case 407: sReturn = "VFX_IMP_TORNADO"; break;
case 408: sReturn = "VFX_DUR_GLOW_LIGHT_BLUE"; break;
case 409: sReturn = "VFX_DUR_GLOW_PURPLE"; break;
case 410: sReturn = "VFX_DUR_GLOW_BLUE"; break;
case 411: sReturn = "VFX_DUR_GLOW_RED"; break;
case 412: sReturn = "VFX_DUR_GLOW_LIGHT_RED"; break;
case 413: sReturn = "VFX_DUR_GLOW_YELLOW"; break;
case 414: sReturn = "VFX_DUR_GLOW_LIGHT_YELLOW"; break;
case 415: sReturn = "VFX_DUR_GLOW_GREEN"; break;
case 416: sReturn = "VFX_DUR_GLOW_LIGHT_GREEN"; break;
case 417: sReturn = "VFX_DUR_GLOW_ORANGE"; break;
case 418: sReturn = "VFX_DUR_GLOW_LIGHT_ORANGE"; break;
case 419: sReturn = "VFX_DUR_GLOW_BROWN"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 420: sReturn = "VFX_DUR_GLOW_LIGHT_BROWN"; break;
case 421: sReturn = "VFX_DUR_GLOW_GREY"; break;
case 422: sReturn = "VFX_DUR_GLOW_WHITE"; break;
case 423: sReturn = "VFX_DUR_GLOW_LIGHT_PURPLE"; break;
case 424: sReturn = "VFX_DUR_GHOST_TRANSPARENT"; break;
case 425: sReturn = "VFX_DUR_GHOST_SMOKE"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 445: sReturn = "VFX_DUR_GLYPH_OF_WARDING"; break;
case 446: sReturn = "VFX_FNF_SOUND_BURST_SILENT"; break;
case 459: sReturn = "VFX_FNF_ELECTRIC_EXPLOSION"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 460: sReturn = "VFX_IMP_DUST_EXPLOSION"; break;
case 461: sReturn = "VFX_IMP_PULSE_HOLY_SILENT"; break;
case 463: sReturn = "VFX_DUR_DEATH_ARMOR"; break;
case 465: sReturn = "VFX_DUR_ICESKIN"; break;
case 473: sReturn = "VFX_FNF_SWINGING_BLADE"; break;
case 474: sReturn = "VFX_DUR_INFERNO"; break;
case 475: sReturn = "VFX_FNF_DEMON_HAND"; break;
case 476: sReturn = "VFX_DUR_STONEHOLD"; break;
case 477: sReturn = "VFX_FNF_MYSTICAL_EXPLOSION"; break;
case 478: sReturn = "VFX_DUR_GHOSTLY_VISAGE_NO_SOUND"; break;
case 479: sReturn = "VFX_DUR_GHOST_SMOKE_2"; break;
            }
            break;
            case 4:
            switch (nVFX)
            {
case 480: sReturn = "VFX_DUR_FLIES"; break;
case 481: sReturn = "VFX_FNF_SUMMONDRAGON"; break;
case 482: sReturn = "VFX_BEAM_FIRE_W"; break;
case 483: sReturn = "VFX_BEAM_FIRE_W_SILENT"; break;
case 484: sReturn = "VFX_BEAM_CHAIN"; break;
case 485: sReturn = "VFX_BEAM_BLACK"; break;
case 486: sReturn = "VFX_IMP_WALLSPIKE"; break;
case 487: sReturn = "VFX_FNF_GREATER_RUIN"; break;
case 488: sReturn = "VFX_FNF_UNDEAD_DRAGON"; break;
case 495: sReturn = "VFX_DUR_PROT_EPIC_ARMOR"; break;
case 496: sReturn = "VFX_FNF_SUMMON_EPIC_UNDEAD"; break;
case 497: sReturn = "VFX_DUR_PROT_EPIC_ARMOR_2"; break;
case 498: sReturn = "VFX_DUR_INFERNO_CHEST"; break;
case 499: sReturn = "VFX_DUR_IOUNSTONE_RED"; break;
            }
            break;
        }
        break;
        case 5:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 500: sReturn = "VFX_DUR_IOUNSTONE_BLUE"; break;
case 501: sReturn = "VFX_DUR_IOUNSTONE_YELLOW"; break;
case 502: sReturn = "VFX_DUR_IOUNSTONE_GREEN"; break;
case 503: sReturn = "VFX_IMP_MIRV_ELECTRIC"; break;
case 504: sReturn = "VFX_COM_CHUNK_RED_BALLISTA"; break;
case 505: sReturn = "VFX_DUR_INFERNO_NO_SOUND"; break;
case 512: sReturn = "VFX_DUR_AURA_PULSE_RED_WHITE"; break;
case 513: sReturn = "VFX_DUR_AURA_PULSE_BLUE_WHITE"; break;
case 514: sReturn = "VFX_DUR_AURA_PULSE_GREEN_WHITE"; break;
case 515: sReturn = "VFX_DUR_AURA_PULSE_YELLOW_WHITE"; break;
case 516: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_WHITE"; break;
case 517: sReturn = "VFX_DUR_AURA_PULSE_CYAN_WHITE"; break;
case 518: sReturn = "VFX_DUR_AURA_PULSE_ORANGE_WHITE"; break;
case 519: sReturn = "VFX_DUR_AURA_PULSE_BROWN_WHITE"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 520: sReturn = "VFX_DUR_AURA_PULSE_PURPLE_WHITE"; break;
case 521: sReturn = "VFX_DUR_AURA_PULSE_GREY_WHITE"; break;
case 522: sReturn = "VFX_DUR_AURA_PULSE_GREY_BLACK"; break;
case 523: sReturn = "VFX_DUR_AURA_PULSE_BLUE_GREEN"; break;
case 524: sReturn = "VFX_DUR_AURA_PULSE_RED_BLUE"; break;
case 525: sReturn = "VFX_DUR_AURA_PULSE_RED_YELLOW"; break;
case 526: sReturn = "VFX_DUR_AURA_PULSE_GREEN_YELLOW"; break;
case 527: sReturn = "VFX_DUR_AURA_PULSE_RED_GREEN"; break;
case 528: sReturn = "VFX_DUR_AURA_PULSE_BLUE_YELLOW"; break;
case 529: sReturn = "VFX_DUR_AURA_PULSE_BLUE_BLACK"; break;
case 530: sReturn = "VFX_DUR_AURA_PULSE_RED_BLACK"; break;
case 531: sReturn = "VFX_DUR_AURA_PULSE_GREEN_BLACK"; break;
case 532: sReturn = "VFX_DUR_AURA_PULSE_YELLOW_BLACK"; break;
case 533: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_BLACK"; break;
case 534: sReturn = "VFX_DUR_AURA_PULSE_CYAN_BLACK"; break;
case 535: sReturn = "VFX_DUR_AURA_PULSE_ORANGE_BLACK"; break;
case 536: sReturn = "VFX_DUR_AURA_PULSE_BROWN_BLACK"; break;
case 537: sReturn = "VFX_DUR_AURA_PULSE_PURPLE_BLACK"; break;
case 538: sReturn = "VFX_DUR_AURA_PULSE_CYAN_GREEN"; break;
case 539: sReturn = "VFX_DUR_AURA_PULSE_CYAN_BLUE"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 540: sReturn = "VFX_DUR_AURA_PULSE_CYAN_RED"; break;
case 541: sReturn = "VFX_DUR_AURA_PULSE_CYAN_YELLOW"; break;
case 542: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_BLUE"; break;
case 543: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_RED"; break;
case 544: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_GREEN"; break;
case 545: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_YELLOW"; break;
case 546: sReturn = "VFX_DUR_AURA_PULSE_RED_ORANGE"; break;
case 547: sReturn = "VFX_DUR_AURA_PULSE_YELLOW_ORANGE"; break;
case 548: sReturn = "VFX_DUR_AURA_RED"; break;
case 549: sReturn = "VFX_DUR_AURA_GREEN"; break;
case 550: sReturn = "VFX_DUR_AURA_BLUE"; break;
case 551: sReturn = "VFX_DUR_AURA_MAGENTA"; break;
case 552: sReturn = "VFX_DUR_AURA_YELLOW"; break;
case 553: sReturn = "VFX_DUR_AURA_WHITE"; break;
case 554: sReturn = "VFX_DUR_AURA_ORANGE"; break;
case 555: sReturn = "VFX_DUR_AURA_BROWN"; break;
case 556: sReturn = "VFX_DUR_AURA_PURPLE"; break;
case 557: sReturn = "VFX_DUR_AURA_CYAN"; break;
case 558: sReturn = "VFX_DUR_AURA_GREEN_DARK"; break;
case 559: sReturn = "VFX_DUR_AURA_GREEN_LIGHT"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 560: sReturn = "VFX_DUR_AURA_RED_DARK"; break;
case 561: sReturn = "VFX_DUR_AURA_RED_LIGHT"; break;
case 562: sReturn = "VFX_DUR_AURA_BLUE_DARK"; break;
case 563: sReturn = "VFX_DUR_AURA_BLUE_LIGHT"; break;
case 564: sReturn = "VFX_DUR_AURA_YELLOW_DARK"; break;
case 565: sReturn = "VFX_DUR_AURA_YELLOW_LIGHT"; break;
case 566: sReturn = "VFX_DUR_BUBBLES"; break;
case 567: sReturn = "VFX_EYES_GREEN_HUMAN_MALE"; break;
case 568: sReturn = "VFX_EYES_GREEN_HUMAN_FEMALE"; break;
case 569: sReturn = "VFX_EYES_GREEN_DWARF_MALE"; break;
case 570: sReturn = "VFX_EYES_GREEN_DWARF_FEMALE"; break;
case 571: sReturn = "VFX_EYES_GREEN_ELF_MALE"; break;
case 572: sReturn = "VFX_EYES_GREEN_ELF_FEMALE"; break;
case 573: sReturn = "VFX_EYES_GREEN_GNOME_MALE"; break;
case 574: sReturn = "VFX_EYES_GREEN_GNOME_FEMALE"; break;
case 575: sReturn = "VFX_EYES_GREEN_HALFLING_MALE"; break;
case 576: sReturn = "VFX_EYES_GREEN_HALFLING_FEMALE"; break;
case 577: sReturn = "VFX_EYES_GREEN_HALFORC_MALE"; break;
case 578: sReturn = "VFX_EYES_GREEN_HALFORC_FEMALE"; break;
case 579: sReturn = "VFX_EYES_GREEN_TROGLODYTE"; break;
            }
            break;
        }
        break;
    }
    return sReturn;
}

void DoVFX(object oPC, string sText, object oTarget, int nLocation = FALSE) //dm_fx vfx# 1 1 20
{                                                                                  //1 1 20
    int nPos = FindSubString(sText, " ");//1
    int nDur;
    float fDur;
    int nExtraordinaryEffect = FALSE;
    int nSupernaturalEffect = FALSE;
    string sVFX = GetStringLeft(sText, nPos);//"1"
    string sText2; //""
    int nVFX = StringToInt(sVFX);//1
    if (!TestStringAgainstPattern("*n", sVFX))
    {
        FloatingTextStringOnCreature(COLOR_RED+REQUIRES_NUMBER+COLOR_END, oPC);
        return;
    }
    string sVFXName = GetVFXName(nVFX);//"VFX_DUR_DARKNESS"
    sVFXName = GetStringRight(sVFXName, GetStringLength(sVFXName) - 4);//cut off the VFX_  "DUR_DARKNESS"
    string sType = GetStringLeft(sVFXName, 4);//read vfx type  "DUR_"                                   //6-2= 4, 1 20
    sText = GetStringRight(sText, GetStringLength(sText) - (nPos+1));//clear the vfx number and space //1 20
    nPos = FindSubString(sText, " ");//find the next break - if not -1, must be for duration type, and time - will be 1
    if (nPos == 1)//
    {
        sText2 = GetStringLeft(sText, nPos);//1
        nDur = StringToInt(sText2);//get the duration - will be 0, 1, or 2
        if (!TestStringAgainstPattern("*n", sText2))
        {
            FloatingTextStringOnCreature(COLOR_RED+REQUIRES_NUMBER+COLOR_END, oPC);
            return;
        }
        sText = GetStringRight(sText, GetStringLength(sText) - 2); //clear type and space  //20
        int nPos2 = FindSubString(sText, " ");//-1
        if (nPos2 == -1) fDur = StringToFloat(sText);//they didnt specify supernatural or extraordinary
        else
        {
            fDur = StringToFloat(GetStringLeft(sText, nPos2));//300
            sText = GetStringRight(sText, GetStringLength(sText) - (nPos2+1));
            if (sText == "e") nExtraordinaryEffect = TRUE;
            else if (sText == "s") nSupernaturalEffect = TRUE;
            else if (sText == "se" || sText == "es")
            {
                nExtraordinaryEffect = TRUE;
                nSupernaturalEffect = TRUE;
            }
            else
            {
                FloatingTextStringOnCreature(COLOR_RED+BADEFFECT_TYPE+COLOR_END, oPC, FALSE);
                return;
            }
        }
    }
    else
    {
        FloatingTextStringOnCreature(COLOR_RED+NEED_DURATION+COLOR_END, oPC);
        return;
    }
    effect eVFX;
    location lTarget;
    if (nLocation)
    {
        lTarget = GetLocalLocation(oPC, "FKY_CHAT_LOCATION");
        DeleteLocalLocation(oPC, "FKY_CHAT_LOCATION");
        if (!GetIsObjectValid(GetAreaFromLocation(lTarget))) nLocation = FALSE;//safety to ensure that vfx not applied to invalid location
    }
    if (sType == "DUR_")
    {
        eVFX = EffectVisualEffect(nVFX);
        if (nExtraordinaryEffect) eVFX = ExtraordinaryEffect(eVFX);
        if (nSupernaturalEffect) eVFX = SupernaturalEffect(eVFX);
        if (nLocation) ApplyEffectAtLocation(nDur, eVFX, lTarget, fDur);
        else ApplyEffectToObject(nDur, eVFX, oTarget, fDur);
    }
    else if (sType == "BEAM")
    {
        eVFX = EffectBeam(nVFX, oPC, BODY_NODE_CHEST);
        if (nExtraordinaryEffect) eVFX = ExtraordinaryEffect(eVFX);
        if (nSupernaturalEffect) eVFX = SupernaturalEffect(eVFX);
        if (nLocation) ApplyEffectAtLocation(nDur, eVFX, lTarget, fDur);
        else ApplyEffectToObject(nDur, eVFX, oTarget, fDur);
    }
    else if (sType == "EYES")
    {
        eVFX = EffectVisualEffect(nVFX);
        if (nExtraordinaryEffect) eVFX = ExtraordinaryEffect(eVFX);
        if (nSupernaturalEffect) eVFX = SupernaturalEffect(eVFX);
        ApplyEffectToObject(nDur, eVFX, oTarget, fDur);
    }
    else if (sType == "IMP_")//none
    {
        eVFX = EffectVisualEffect(nVFX);
        if (nLocation) ApplyEffectAtLocation(0, eVFX, lTarget);
        else ApplyEffectToObject(0, eVFX, oTarget);
    }
    else if (sType == "COM_")//none
    {
        eVFX = EffectVisualEffect(nVFX);
        if (nLocation) ApplyEffectAtLocation(0, eVFX, lTarget);
        else ApplyEffectToObject(0, eVFX, oTarget);
    }
    else if (sType == "FNF_")//none
    {
        eVFX = EffectVisualEffect(nVFX);
        if (nLocation) ApplyEffectAtLocation(0, eVFX, lTarget);
        else ApplyEffectToObject(0, eVFX, oTarget);
    }
    else FloatingTextStringOnCreature(COLOR_RED+BADEFFECT_NUM+COLOR_END, oPC, FALSE);
}

void ListFX(object oPC, string sType) // dur, bea, eye, imp, com, fnf
{
    sType = "VFX_" + GetStringUpperCase(sType);
    int nX;
    string sMessage = "";
    string sName;
    for (nX = 0; nX < 580; nX++)
    {
        sName = GetVFXName(nX);
        if (GetStringLeft(sName, 7) == sType) sMessage += COLOR_PURPLE + IntToString(nX) + ": " + sName + COLOR_END + "\n";
    }
    SendMessageToPC(oPC, sMessage);
}

//void main(){}
