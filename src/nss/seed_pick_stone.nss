#include "enc_inc"
#include "_functions"
#include "db_inc"

const int SMS_NEVER       = 0; // TURNS IT OFF
const int SMS_VERY_RARE   = 1;
const int SMS_RARE        = 2;
const int SMS_COMMON      = 6;
const int SMS_BERY_COMMON = 12; // WEIGHTED CHANCE
int nGlobalWeight; // Global Weight Total

int SMS_PickByWeight(int nPass, int nRoll, int nWeight);

void SMS_UpdateStoneID(object oPC, object oItem) {
   int nStoneID = GetLocalInt(oItem, "STONE_ID");
   if (!nStoneID) return;
   string sSQL = "update stonetracker set st_plid=" + GetLocalString(oPC, "DB_PLID") + " where st_stid="+IntToString(nStoneID);
   NWNX_SQL_ExecuteQuery(sSQL);
}

int SMS_GetNextStoneID(object oCreateOn, string sName) {
   string sToken;
   string sPLID = "0";
   if (GetIsPC(oCreateOn)) sPLID = GetLocalString(oCreateOn, "DB_PLID");
   string sSQL = "insert into stonetracker (st_name, st_plid) values ("+ DelimList(dbQuotes(sName), sPLID) + ")";
   NWNX_SQL_ExecuteQuery(sSQL);
   sSQL = "select last_insert_id() from stonetracker limit 1";
   NWNX_SQL_ExecuteQuery(sSQL);
   if (NWNX_SQL_ReadyToReadNextRow())
   {
      NWNX_SQL_ReadNextRow();
      sToken = NWNX_SQL_ReadDataInActiveRow(0);
      WriteTimestampedLogEntry(sName + "#" + sToken);
   }
   else
   {
      WriteTimestampedLogEntry("No database! Token not fetched.");
      sToken = "0";
   }
   return StringToInt(sToken);
}

string SMS_CastName(int nSpellID) {
   if      (nSpellID==IP_CONST_CASTSPELL_AID_3                            ) return "Aid";
   else if (nSpellID==IP_CONST_CASTSPELL_AMPLIFY_5                        ) return "Amplify";
   else if (nSpellID==IP_CONST_CASTSPELL_ANIMATE_DEAD_15                  ) return "Animate Dead";
   else if (nSpellID==IP_CONST_CASTSPELL_AURA_OF_VITALITY_13              ) return "Aura Of Vitality";
   else if (nSpellID==IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15         ) return "Aura Versus Alignment";
   else if (nSpellID==IP_CONST_CASTSPELL_AURAOFGLORY_7                    ) return "Aura of Glory";
   else if (nSpellID==IP_CONST_CASTSPELL_AWAKEN_9                         ) return "Awaken";
   else if (nSpellID==IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7              ) return "Balagarn's Iron Horn";
   else if (nSpellID==IP_CONST_CASTSPELL_BANE_5                           ) return "Bane";
   else if (nSpellID==IP_CONST_CASTSPELL_BARKSKIN_12                      ) return "Barkskin";
   else if (nSpellID==IP_CONST_CASTSPELL_BLESS_2                          ) return "Bless";
   else if (nSpellID==IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3             ) return "Blindness Deafness";
   else if (nSpellID==IP_CONST_CASTSPELL_BLOOD_FRENZY_7                   ) return "Blood Frenzy";
   else if (nSpellID==IP_CONST_CASTSPELL_BULLS_STRENGTH_15                ) return "Bulls Strength";
   else if (nSpellID==IP_CONST_CASTSPELL_CALL_LIGHTNING_10                ) return "Call Lightning";
   else if (nSpellID==IP_CONST_CASTSPELL_CAMOFLAGE_5                      ) return "Camoflage";
   else if (nSpellID==IP_CONST_CASTSPELL_CATS_GRACE_15                    ) return "Cats Grace";
   else if (nSpellID==IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20               ) return "Chain Lightning";
   else if (nSpellID==IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15    ) return "Clairaudience/Clairvoyance";
   else if (nSpellID==IP_CONST_CASTSPELL_CLARITY_3                        ) return "Clarity";
   else if (nSpellID==IP_CONST_CASTSPELL_CLOUDKILL_9                      ) return "Cloud Kill";
   else if (nSpellID==IP_CONST_CASTSPELL_CONE_OF_COLD_15                  ) return "Cone Of Cold";
   else if (nSpellID==IP_CONST_CASTSPELL_CONFUSION_10                     ) return "Confusion";
   else if (nSpellID==IP_CONST_CASTSPELL_CONTROL_UNDEAD_20                ) return "Control Undead";
   else if (nSpellID==IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_18         ) return "Create Greater Undead";
   else if (nSpellID==IP_CONST_CASTSPELL_CREATE_UNDEAD_16                 ) return "Create Undead";
   else if (nSpellID==IP_CONST_CASTSPELL_DARKNESS_3                       ) return "Darkness";
   else if (nSpellID==IP_CONST_CASTSPELL_DARKVISION_6                     ) return "Darkvision";
   else if (nSpellID==IP_CONST_CASTSPELL_DEATH_WARD_7                     ) return "Death Ward";
   else if (nSpellID==IP_CONST_CASTSPELL_DISMISSAL_18                     ) return "Dismissal";
   else if (nSpellID==IP_CONST_CASTSPELL_DISPEL_MAGIC_10                  ) return "Dispel Magic";
   else if (nSpellID==IP_CONST_CASTSPELL_DISPLACEMENT_9                   ) return "Displacement";
   else if (nSpellID==IP_CONST_CASTSPELL_DOMINATE_MONSTER_17              ) return "Dominate Monster";
   else if (nSpellID==IP_CONST_CASTSPELL_DOOM_5                           ) return "Doom";
   else if (nSpellID==IP_CONST_CASTSPELL_DRAGON_BREATH_ACID_10            ) return "Dragon Breath - Acid";
   else if (nSpellID==IP_CONST_CASTSPELL_DRAGON_BREATH_COLD_10            ) return "Dragon Breath - Cold";
   else if (nSpellID==IP_CONST_CASTSPELL_DRAGON_BREATH_FEAR_10            ) return "Dragon Breath - Fear";
   else if (nSpellID==IP_CONST_CASTSPELL_DRAGON_BREATH_FIRE_10            ) return "Dragon Breath - Fire";
   else if (nSpellID==IP_CONST_CASTSPELL_DRAGON_BREATH_GAS_10             ) return "Dragon Breath - Gas";
   else if (nSpellID==IP_CONST_CASTSPELL_DRAGON_BREATH_LIGHTNING_10       ) return "Dragon Breath - Lightning";
   else if (nSpellID==IP_CONST_CASTSPELL_DRAGON_BREATH_PARALYZE_10        ) return "Dragon Breath - Paralyze";
   else if (nSpellID==IP_CONST_CASTSPELL_DRAGON_BREATH_SLEEP_10           ) return "Dragon Breath - Sleep";
   else if (nSpellID==IP_CONST_CASTSPELL_DRAGON_BREATH_SLOW_10            ) return "Dragon Breath - Slow";
   else if (nSpellID==IP_CONST_CASTSPELL_DRAGON_BREATH_WEAKEN_10          ) return "Dragon Breath - Weaken";
   else if (nSpellID==IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15                 ) return "Eagle Spledor";
   else if (nSpellID==IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12              ) return "Elemental Shield";
   else if (nSpellID==IP_CONST_CASTSPELL_ENDURANCE_15                     ) return "Endurance";
   else if (nSpellID==IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2                ) return "Endure Elements";
   else if (nSpellID==IP_CONST_CASTSPELL_ENERGY_BUFFER_20                 ) return "Energy Buffer";
   else if (nSpellID==IP_CONST_CASTSPELL_ENERGY_DRAIN_17                  ) return "Energy Drain";
   else if (nSpellID==IP_CONST_CASTSPELL_ENERVATION_7                     ) return "Enervation";
   else if (nSpellID==IP_CONST_CASTSPELL_ENTANGLE_5                       ) return "Entangle";
   else if (nSpellID==IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5                ) return "Entropic Shield";
   else if (nSpellID==IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15               ) return "Ethereal Visage";
   else if (nSpellID==IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5            ) return "Expeditious Retreat";
   else if (nSpellID==IP_CONST_CASTSPELL_FEAR_5                           ) return "Fear";
   else if (nSpellID==IP_CONST_CASTSPELL_FEEBLEMIND_9                     ) return "Feeblemind";
   else if (nSpellID==IP_CONST_CASTSPELL_FIND_TRAPS_3                     ) return "Find Traps";
   else if (nSpellID==IP_CONST_CASTSPELL_FIREBALL_10                      ) return "Fireball";
   else if (nSpellID==IP_CONST_CASTSPELL_FIREBRAND_15                     ) return "Firebrand";
   else if (nSpellID==IP_CONST_CASTSPELL_FLAME_ARROW_18                   ) return "Flame Arrow";
   else if (nSpellID==IP_CONST_CASTSPELL_FLAME_LASH_10                    ) return "Flame Lash";
   else if (nSpellID==IP_CONST_CASTSPELL_FLAME_STRIKE_18                  ) return "Flame Strike";
   else if (nSpellID==IP_CONST_CASTSPELL_FLESH_TO_STONE_5                 ) return "Flesh To Stone";
   else if (nSpellID==IP_CONST_CASTSPELL_FOXS_CUNNING_15                  ) return "Foxs Cunning";
   else if (nSpellID==IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7            ) return "Freedom Of Movement";
   else if (nSpellID==IP_CONST_CASTSPELL_GATE_17                          ) return "Gate";
   else if (nSpellID==IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15                ) return "Ghostly Visage";
   else if (nSpellID==IP_CONST_CASTSPELL_GHOUL_TOUCH_3                    ) return "Ghoul Touch";
   else if (nSpellID==IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11      ) return "Globe Of Invulnerability";
   else if (nSpellID==IP_CONST_CASTSPELL_GREASE_2                         ) return "Grease";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_BULLS_STRENGTH_11        ) return "Greater Bulls Strength";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_CATS_GRACE_11            ) return "Greater Cats Grace";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_DISPELLING_15            ) return "Greater Dispelling";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_EAGLES_SPLENDOR_11       ) return "Greater Eagles Splendor";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_ENDURANCE_11             ) return "Greater Endurance";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_FOXS_CUNNING_11          ) return "Greater Foxs Cunning";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_MAGIC_FANG_9             ) return "Greater Magic Fang";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_OWLS_WISDOM_11           ) return "Greater Owls Wisdom";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_PLANAR_BINDING_15        ) return "Greater Planar Binding";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_RESTORATION_13           ) return "Greater Restoration";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_SHADOW_CONJURATION_9     ) return "Greater Shadow Conjuration";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_SPELL_BREACH_11          ) return "Greater Spell Breach";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_SPELL_MANTLE_17          ) return "Greater Spell Mantle";
   else if (nSpellID==IP_CONST_CASTSPELL_GREATER_STONESKIN_11             ) return "Greater Stoneskin";
   else if (nSpellID==IP_CONST_CASTSPELL_GUST_OF_WIND_10                  ) return "Gust Of Wind";
   else if (nSpellID==IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12            ) return "Hammer Of The Gods";
   else if (nSpellID==IP_CONST_CASTSPELL_HASTE_10                         ) return "Haste";
   else if (nSpellID==IP_CONST_CASTSPELL_HOLD_ANIMAL_3                    ) return "Hold Animal";
   else if (nSpellID==IP_CONST_CASTSPELL_HOLD_MONSTER_7                   ) return "Hold Monster";
   else if (nSpellID==IP_CONST_CASTSPELL_HOLD_PERSON_3                    ) return "Hold Person";
   else if (nSpellID==IP_CONST_CASTSPELL_ICE_STORM_9                      ) return "Ice Storm";
   else if (nSpellID==IP_CONST_CASTSPELL_IDENTIFY_3                       ) return "Identify";
   else if (nSpellID==IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7          ) return "Improved Invisibility";
   else if (nSpellID==IP_CONST_CASTSPELL_INVISIBILITY_3                   ) return "Invisibility";
   else if (nSpellID==IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5             ) return "Invisibility Purge";
   else if (nSpellID==IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5            ) return "Invisibility Sphere";
   else if (nSpellID==IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15  ) return "Isaacs Greater Missile Storm";
   else if (nSpellID==IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13   ) return "Isaacs Lesser Missile Storm";
   else if (nSpellID==IP_CONST_CASTSPELL_KNOCK_3                          ) return "Knock";
   else if (nSpellID==IP_CONST_CASTSPELL_LEGEND_LORE_5                    ) return "Legend Lore";
   else if (nSpellID==IP_CONST_CASTSPELL_LESSER_DISPEL_5                  ) return "Lesser Dispel";
   else if (nSpellID==IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9              ) return "Lesser Mind Blank";
   else if (nSpellID==IP_CONST_CASTSPELL_LESSER_PLANAR_BINDING_9          ) return "Lesser Planar Binding";
   else if (nSpellID==IP_CONST_CASTSPELL_LESSER_RESTORATION_3             ) return "Lesser Restoration";
   else if (nSpellID==IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7            ) return "Lesser Spell Breach";
   else if (nSpellID==IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9            ) return "Lesser Spell Mantle";
   else if (nSpellID==IP_CONST_CASTSPELL_LIGHTNING_BOLT_10                ) return "Lightning Bolt";
   else if (nSpellID==IP_CONST_CASTSPELL_MAGE_ARMOR_2                     ) return "Mage Armor";
   else if (nSpellID==IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5 ) return "Magic Circle Against Alignment";
   else if (nSpellID==IP_CONST_CASTSPELL_MAGIC_FANG_5                     ) return "Magic Fang";
   else if (nSpellID==IP_CONST_CASTSPELL_MAGIC_MISSILE_9                  ) return "Magic Missile";
   else if (nSpellID==IP_CONST_CASTSPELL_MASS_BLINDNESS_DEAFNESS_15       ) return "Mass Blindness Deafness";
   else if (nSpellID==IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13                ) return "Mass Camoflage";
   else if (nSpellID==IP_CONST_CASTSPELL_MASS_HASTE_11                    ) return "Mass Haste";
   else if (nSpellID==IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9               ) return "Melfs Acid Arrow";
   else if (nSpellID==IP_CONST_CASTSPELL_MIND_BLANK_15                    ) return "Mind Blank";
   else if (nSpellID==IP_CONST_CASTSPELL_MIND_FOG_9                       ) return "Mind Fog";
   else if (nSpellID==IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_15) return "Minor Globe Of Invulnerability";
   else if (nSpellID==IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_10         ) return "Negative Energy Burst";
   else if (nSpellID==IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_15    ) return "Negative Energy Protection";
   else if (nSpellID==IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_9            ) return "Negative Energy Ray";
   else if (nSpellID==IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5              ) return "Neutralize Poison";
   else if (nSpellID==IP_CONST_CASTSPELL_ONE_WITH_THE_LAND_7              ) return "One With The Land";
   else if (nSpellID==IP_CONST_CASTSPELL_OWLS_INSIGHT_15                  ) return "Owls Insight";
   else if (nSpellID==IP_CONST_CASTSPELL_OWLS_WISDOM_15                   ) return "Owls Wisdom";
   else if (nSpellID==IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7              ) return "Phantasmal Killer";
   else if (nSpellID==IP_CONST_CASTSPELL_PLANAR_BINDING_11                ) return "Planar Binding";
   else if (nSpellID==IP_CONST_CASTSPELL_POLYMORPH_SELF_7                 ) return "Polymorph Self";
   else if (nSpellID==IP_CONST_CASTSPELL_POWER_WORD_STUN_13               ) return "Power Word Stun";
   else if (nSpellID==IP_CONST_CASTSPELL_PRAYER_5                         ) return "Prayer";
   else if (nSpellID==IP_CONST_CASTSPELL_PREMONITION_15                   ) return "Premonition";
   else if (nSpellID==IP_CONST_CASTSPELL_PRISMATIC_SPRAY_13               ) return "Prismatic Spray";
   else if (nSpellID==IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5      ) return "Protection From Alignment";
   else if (nSpellID==IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10      ) return "Protection From Elements";
   else if (nSpellID==IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20        ) return "Protection From Spells";
   else if (nSpellID==IP_CONST_CASTSPELL_RAISE_DEAD_9                     ) return "Raise Dead";
   else if (nSpellID==IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2            ) return "Ray Of Enfeeblement";
   else if (nSpellID==IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5      ) return "Remove Blindness Deafness";
   else if (nSpellID==IP_CONST_CASTSPELL_REMOVE_FEAR_2                    ) return "Remove Fear";
   else if (nSpellID==IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3               ) return "Remove Paralysis";
   else if (nSpellID==IP_CONST_CASTSPELL_RESIST_ELEMENTS_10               ) return "Resist Elements";
   else if (nSpellID==IP_CONST_CASTSPELL_RESTORATION_7                    ) return "Restoration";
   else if (nSpellID==IP_CONST_CASTSPELL_ROGUES_CUNNING_3                 ) return "Rogues Cunning";
   else if (nSpellID==IP_CONST_CASTSPELL_SEARING_LIGHT_5                  ) return "Searing Light";
   else if (nSpellID==IP_CONST_CASTSPELL_SEE_INVISIBILITY_3               ) return "See Invisibility";
   else if (nSpellID==IP_CONST_CASTSPELL_SHADOW_SHIELD_13                 ) return "Shadow Shield";
   else if (nSpellID==IP_CONST_CASTSPELL_SHAPECHANGE_17                   ) return "Shape Change";
   else if (nSpellID==IP_CONST_CASTSPELL_SHIELD_5                         ) return "Shield";
   else if (nSpellID==IP_CONST_CASTSPELL_SILENCE_3                        ) return "Silence";
   else if (nSpellID==IP_CONST_CASTSPELL_SLEEP_5                          ) return "Sleep";
   else if (nSpellID==IP_CONST_CASTSPELL_SLOW_5                           ) return "Slow";
   else if (nSpellID==IP_CONST_CASTSPELL_SOUND_BURST_3                    ) return "Sound Burst";
   else if (nSpellID==IP_CONST_CASTSPELL_SPELL_RESISTANCE_15              ) return "Spell Resistance";
   else if (nSpellID==IP_CONST_CASTSPELL_SPIKE_GROWTH_9                   ) return "Spike Growth";
   else if (nSpellID==IP_CONST_CASTSPELL_STINKING_CLOUD_5                 ) return "Stinking Cloud";
   else if (nSpellID==IP_CONST_CASTSPELL_STONE_TO_FLESH_5                 ) return "Stone To Flesh";
   else if (nSpellID==IP_CONST_CASTSPELL_STONESKIN_7                      ) return "Stoneskin";
   else if (nSpellID==IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5              ) return "Summon Creature 1";
   else if (nSpellID==IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3             ) return "Summon Creature 2";
   else if (nSpellID==IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5            ) return "Summon Creature 3";
   else if (nSpellID==IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7             ) return "Summon Creature 4";
   else if (nSpellID==IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17            ) return "Summon Creature 9";
   else if (nSpellID==IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9              ) return "Summon Creature 5";
   else if (nSpellID==IP_CONST_CASTSPELL_SUMMON_CREATURE_VI_11            ) return "Summon Creature 6";
   else if (nSpellID==IP_CONST_CASTSPELL_SUMMON_CREATURE_VII_13           ) return "Summon Creature 7";
   else if (nSpellID==IP_CONST_CASTSPELL_SUMMON_CREATURE_VIII_15          ) return "Summon Creature 8";
   else if (nSpellID==IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7        ) return "Tashas Hideous Laughter";
   else if (nSpellID==IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11        ) return "Tenser's Transformation";
   else if (nSpellID==IP_CONST_CASTSPELL_TRUE_STRIKE_5                    ) return "True Strike";
   else if (nSpellID==IP_CONST_CASTSPELL_UNDEATHS_ETERNAL_FOE_20          ) return "Undeath's Eternal Foe";
   else if (nSpellID==IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5                 ) return "Vampiric Touch";
   else if (nSpellID==IP_CONST_CASTSPELL_WAR_CRY_7                        ) return "War Cry";
   else if (nSpellID==IP_CONST_CASTSPELL_WEB_3                            ) return "Web";
   else if (nSpellID==IP_CONST_CASTSPELL_WOUNDING_WHISPERS_9              ) return "Wounding Whispers";
   return "Uselessness";
}

string SMS_GetItemResRef(string sTag) {
   if      (sTag=="SMS_DAGGER")                  return "SMS_DAGGER";
   else if (sTag=="SMS_KUKRI")                   return "SMS_KUKRI";
   else if (sTag=="SMS_SHURIKEN")                return "SMS_SHURIKEN";
   else if (sTag=="SMS_THROWING_AXE")            return "SMS_THROWING_AXE";
   else if (sTag=="SMS_LIGHT_CROSSBOW")          return "SMS_LIGHT_CROSSBOW";
   else if (sTag=="SMS_DART")                    return "SMS_DART";
   else if (sTag=="SMS_LIGHT_HAMMER")            return "SMS_LIGHT_HAMMER";
   else if (sTag=="SMS_HANDAXE")                 return "SMS_HANDAXE";
   else if (sTag=="SMS_MACE")                    return "SMS_MACE";
   else if (sTag=="SMS_SICKLE")                  return "SMS_SICKLE";
   else if (sTag=="SMS_SLING")                   return "SMS_SLING";
   else if (sTag=="SMS_SHORTSWORD")              return "SMS_SHORTSWORD";
   else if (sTag=="SMS_BASTARD")                 return "SMS_BASTARD";
   else if (sTag=="SMS_BATTLEAXE")               return "SMS_BATTLEAXE";
   else if (sTag=="SMS_CLUB")                    return "SMS_CLUB";
   else if (sTag=="SMS_HEAVY_CROSSBOW")          return "SMS_HEAVY_CROSSBOW";
   else if (sTag=="SMS_DWARVEN_WARAXE")          return "SMS_DWARVEN_WARAXE";
   else if (sTag=="SMS_LIGHT_FLAIL")             return "SMS_LIGHT_FLAIL";
   else if (sTag=="SMS_KATANA")                  return "SMS_KATANA";
   else if (sTag=="SMS_LONGSWORD")               return "SMS_LONGSWORD";
   else if (sTag=="SMS_MORNINGSTAR")             return "SMS_MORNINGSTAR";
   else if (sTag=="SMS_SHORTBOW")                return "SMS_SHORTBOW";
   else if (sTag=="SMS_WARHAMMER")               return "SMS_WARHAMMER";
   else if (sTag=="SMS_WHIP")                    return "SMS_WHIP";
   else if (sTag=="SMS_DIRE_MACE")               return "SMS_DIRE_MACE";
   else if (sTag=="SMS_TWO-BLADED_SWORD")        return "SMS_TWO-BLADED_SWORD";
   else if (sTag=="SMS_DOUBLE_AXE")              return "SMS_DOUBLE_AXE";
   else if (sTag=="SMS_HEAVY_FLAIL")             return "SMS_HEAVY_FLAIL";
   else if (sTag=="SMS_GREATAXE")                return "SMS_GREATAXE";
   else if (sTag=="SMS_GREATSWORD")              return "SMS_GREATSWORD";
   else if (sTag=="SMS_HALBERD")                 return "SMS_HALBERD";
   else if (sTag=="SMS_LONGBOW")                 return "SMS_LONGBOW";
   else if (sTag=="SMS_QUARTERSTAFF")            return "SMS_QUARTERSTAFF";
   else if (sTag=="SMS_SPEAR")                   return "SMS_SPEAR";
   return "SMS_DAGGER";
}

string SMS_GetStoneResRef(string sTag) {
   if      (sTag=="SMS_AC")               return "SMS_AC";
   else if (sTag=="SMS_ATTACK")           return "SMS_ATTACK";
   else if (sTag=="SMS_DAM_ELECTRIC")     return "SMS_DAMAGE1";
   else if (sTag=="SMS_DAM_ACID")         return "SMS_DAMAGE1";
   else if (sTag=="SMS_DAM_COLD")         return "SMS_DAMAGE1";
   else if (sTag=="SMS_DAM_FIRE")         return "SMS_DAMAGE1";
   else if (sTag=="SMS_DAM_BLUNT")        return "SMS_DAMAGE2";
   else if (sTag=="SMS_DAM_POINTY")       return "SMS_DAMAGE2";
   else if (sTag=="SMS_DAM_SHARP")        return "SMS_DAMAGE2";
   else if (sTag=="SMS_DAM_SONIC")        return "SMS_DAMAGE2";
   else if (sTag=="SMS_DAM_POSITIVE")     return "SMS_DAMAGE3";
   else if (sTag=="SMS_DAM_NEGATIVE")     return "SMS_DAMAGE3";
   else if (sTag=="SMS_DAM_DIVINE")       return "SMS_DAMAGE4";
   else if (sTag=="SMS_DAM_MAGIC")        return "SMS_DAMAGE4";
   else if (sTag=="SMS_OH_DAZE")          return "SMS_ONHIT1";
   else if (sTag=="SMS_OH_FEAR")          return "SMS_ONHIT1";
   else if (sTag=="SMS_OH_SLOW")          return "SMS_ONHIT1";
   else if (sTag=="SMS_OH_STUN")          return "SMS_ONHIT2";
   else if (sTag=="SMS_OH_HOLD")          return "SMS_ONHIT2";
   else if (sTag=="SMS_REGEN")            return "SMS_REGEN";
   else if (sTag=="SMS_SAVE_FORTITUDE")   return "SMS_SAVECUP";
   else if (sTag=="SMS_SAVE_REFLEX")      return "SMS_SAVECUP";
   else if (sTag=="SMS_SAVE_WILL")        return "SMS_SAVECUP";
   else if (sTag=="SMS_SAVE_DEATH")       return "SMS_SAVESKULL";
   else if (sTag=="SMS_SAVE_MIND")        return "SMS_SAVESKULL";
   else if (sTag=="SMS_SAVE_FEAR")        return "SMS_SAVESKULL";
   else if (sTag=="SMS_SK_CONCENTRATION") return "SMS_SKILL";
   else if (sTag=="SMS_SK_INTIMIDATE")    return "SMS_SKILL";
   else if (sTag=="SMS_SK_SPELLCRAFT")    return "SMS_SKILL";
   else if (sTag=="SMS_SK_DISCIPLINE")    return "SMS_SKILL";
   else if (sTag=="SMS_SK_PERFORM")       return "SMS_SKILL";
   else if (sTag=="SMS_SK_LISTEN")        return "SMS_SKILL";
   else if (sTag=="SMS_SK_TAUNT")         return "SMS_SKILL";
   else if (sTag=="SMS_SK_SPOT")          return "SMS_SKILL";
   else if (sTag=="SMS_SK_UMD")           return "SMS_SKILL";
   else if (sTag=="SMS_SPELLRESIST")      return "SMS_SPELLRESIST";
   else if (GetStringLeft(sTag,9)=="SMS_CAST_") return "SMS_CAST";
   return "SMS_AC";
}

string SMS_GetItemName(string sTag) {
   if      (sTag=="SMS_DAGGER")                  return "SMS_DAGGER";
   else if (sTag=="SMS_KUKRI")                   return "SMS_KUKRI";
   else if (sTag=="SMS_SHURIKEN")                return "SMS_SHURIKEN";
   else if (sTag=="SMS_THROWING_AXE")            return "SMS_THROWING_AXE";
   else if (sTag=="SMS_LIGHT_CROSSBOW")          return "SMS_LIGHT_CROSSBOW";
   else if (sTag=="SMS_DART")                    return "SMS_DART";
   else if (sTag=="SMS_LIGHT_HAMMER")            return "SMS_LIGHT_HAMMER";
   else if (sTag=="SMS_HANDAXE")                 return "SMS_HANDAXE";
   else if (sTag=="SMS_MACE")                    return "SMS_MACE";
   else if (sTag=="SMS_SICKLE")                  return "SMS_SICKLE";
   else if (sTag=="SMS_SLING")                   return "SMS_SLING";
   else if (sTag=="SMS_SHORTSWORD")              return "SMS_SHORTSWORD";
   else if (sTag=="SMS_BASTARD")                 return "SMS_BASTARD";
   else if (sTag=="SMS_BATTLEAXE")               return "SMS_BATTLEAXE";
   else if (sTag=="SMS_CLUB")                    return "SMS_CLUB";
   else if (sTag=="SMS_HEAVY_CROSSBOW")          return "SMS_HEAVY_CROSSBOW";
   else if (sTag=="SMS_DWARVEN_WARAXE")          return "SMS_DWARVEN_WARAXE";
   else if (sTag=="SMS_LIGHT_FLAIL")             return "SMS_LIGHT_FLAIL";
   else if (sTag=="SMS_KATANA")                  return "SMS_KATANA";
   else if (sTag=="SMS_LONGSWORD")               return "SMS_LONGSWORD";
   else if (sTag=="SMS_MORNINGSTAR")             return "SMS_MORNINGSTAR";
   else if (sTag=="SMS_SHORTBOW")                return "SMS_SHORTBOW";
   else if (sTag=="SMS_WARHAMMER")               return "SMS_WARHAMMER";
   else if (sTag=="SMS_WHIP")                    return "SMS_WHIP";
   else if (sTag=="SMS_DIRE_MACE")               return "SMS_DIRE_MACE";
   else if (sTag=="SMS_TWO-BLADED_SWORD")        return "SMS_TWO-BLADED_SWORD";
   else if (sTag=="SMS_DOUBLE_AXE")              return "SMS_DOUBLE_AXE";
   else if (sTag=="SMS_HEAVY_FLAIL")             return "SMS_HEAVY_FLAIL";
   else if (sTag=="SMS_GREATAXE")                return "SMS_GREATAXE";
   else if (sTag=="SMS_GREATSWORD")              return "SMS_GREATSWORD";
   else if (sTag=="SMS_HALBERD")                 return "SMS_HALBERD";
   else if (sTag=="SMS_LONGBOW")                 return "SMS_LONGBOW";
   else if (sTag=="SMS_QUARTERSTAFF")            return "SMS_QUARTERSTAFF";
   else if (sTag=="SMS_SPEAR")                   return "SMS_SPEAR";
   return "Seraphim's Shank";
}

string SMS_GetStoneName(string sTag) {
   if      (sTag=="SMS_AC")               return "Charm of Shielding";
   else if (sTag=="SMS_ATTACK")           return "Stone of Attack";
   else if (sTag=="SMS_DAM_ACID")         return "Stone of Acid Damage";
   else if (sTag=="SMS_DAM_COLD")         return "Stone of Cold Damage";
   else if (sTag=="SMS_DAM_ELECTRIC")     return "Stone of Electric Damage";
   else if (sTag=="SMS_DAM_FIRE")         return "Stone of Fire Damage";
   else if (sTag=="SMS_REGEN")            return "Tooth of the Troll";
   else if (sTag=="SMS_SK_CONCENTRATION") return "Braizer of Concentration";
   else if (sTag=="SMS_SK_LISTEN")        return "Braizer of Listen";
   else if (sTag=="SMS_SK_SPELLCRAFT")    return "Braizer of Spellcraft";
   else if (sTag=="SMS_SK_SPOT")          return "Braizer of Spot";
   else if (sTag=="SMS_DAM_BLUNT")        return "Stone of Bludgeoning Damage";
   else if (sTag=="SMS_DAM_POINTY")       return "Stone of Piercing Damage";
   else if (sTag=="SMS_DAM_SHARP")        return "Stone of Slashing Damage";
   else if (sTag=="SMS_DAM_SONIC")        return "Stone of Sonic Damage";
   else if (sTag=="SMS_SAVE_FEAR")        return "Skull of Fear Save";
   else if (sTag=="SMS_SAVE_MIND")        return "Skull of Mind Save";
   else if (sTag=="SMS_SK_INTIMIDATE")    return "Braizer of Intimidate";
   else if (sTag=="SMS_SK_TAUNT")         return "Braizer of Taunt";
   else if (sTag=="SMS_DAM_NEGATIVE")     return "Stone of Negative Damage";
   else if (sTag=="SMS_DAM_POSITIVE")     return "Stone of Positive Damage";
   else if (sTag=="SMS_OH_DAZE")          return "Rod of Daze";
   else if (sTag=="SMS_OH_FEAR")          return "Rod of Fear";
   else if (sTag=="SMS_OH_SLOW")          return "Rod of Slow";
   else if (sTag=="SMS_SAVE_DEATH")       return "Skull of Death Save";
   else if (sTag=="SMS_SK_DISCIPLINE")    return "Braizer of Discipline";
   else if (sTag=="SMS_SK_PERFORM")       return "Braizer of Performing";
   else if (sTag=="SMS_SK_UMD")           return "Braizer of Using Magic";
   else if (sTag=="SMS_DAM_DIVINE")       return "Stone of Divine Damage";
   else if (sTag=="SMS_DAM_MAGIC")        return "Stone of Magic Damage";
   else if (sTag=="SMS_OH_HOLD")          return "Rod of Hold";
   else if (sTag=="SMS_OH_STUN")          return "Rod of Stun";
   else if (sTag=="SMS_SAVE_FORTITUDE")   return "Skull of Fortitude Save";
   else if (sTag=="SMS_SAVE_REFLEX")      return "Skull of Reflex Save";
   else if (sTag=="SMS_SAVE_WILL")        return "Skull of Will Save";
   else if (sTag=="SMS_SPELLRESIST")      return "Charm of the Dragon";
   else if (GetStringLeft(sTag,9)=="SMS_CAST_") {
      int nSpellID = StringToInt(GetStringRight(sTag, GetStringLength(sTag)-9));
      return "Figurine of " + SMS_CastName(nSpellID);
   }
   return "Charm of Shielding";
}

int SMS_PickCastType(int nSubTypeFreq=SMS_BERY_COMMON) {
   int nRoll;
   int nPass;
   for (nPass=0; nPass<=1; nPass++) {
      if (nPass==0) nGlobalWeight = 0; // ZERO OUR ACCUMULATOR
      if      (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_ENTANGLE_5                       ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3             ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_AURAOFGLORY_7                    ;  // 0  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2            ;  // 0  2
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7        ;  // 0  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_GREASE_2                         ;  // 0  2
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_GHOUL_TOUCH_3                    ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_WEB_3                            ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SILENCE_3                        ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_IDENTIFY_3                       ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_BLOOD_FRENZY_7                   ;  // 0  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3             ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SOUND_BURST_3                    ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DARKVISION_6                     ;  // 0  6
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_MAGIC_MISSILE_9                  ;  // 0  9
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_BANE_5                           ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DOOM_5                           ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_MAGIC_FANG_5                     ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_HOLD_ANIMAL_3                    ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SLEEP_5                          ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5              ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DARKNESS_3                       ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_HOLD_PERSON_3                    ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_ONE_WITH_THE_LAND_7              ;  // 0  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5            ;  // 1  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5              ;  // 1  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_FEAR_5                           ;  // 1  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5                 ;  // 1  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_STINKING_CLOUD_5                 ;  // 1  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SLOW_5                           ;  // 1  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5            ;  // 1  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5             ;  // 1  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_ROGUES_CUNNING_3                 ;  // 1  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SPIKE_GROWTH_9                   ;  // 1  9
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_9            ;  // 1  9
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_GREATER_MAGIC_FANG_9             ;  // 1  9
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9               ;  // 2  9
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_FLAME_LASH_10                    ;  // 2  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SEARING_LIGHT_5                  ;  // 2  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_LEGEND_LORE_5                    ;  // 2  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13   ;  // 3  13
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_LIGHTNING_BOLT_10                ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DRAGON_BREATH_COLD_10            ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7            ;  // 3  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DRAGON_BREATH_FEAR_10            ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_POLYMORPH_SELF_7                 ;  // 3  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_HOLD_MONSTER_7                   ;  // 3  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13                ;  // 3  13
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DRAGON_BREATH_LIGHTNING_10       ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DRAGON_BREATH_SLEEP_10           ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DRAGON_BREATH_ACID_10            ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7              ;  // 3  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_CALL_LIGHTNING_10                ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DRAGON_BREATH_SLOW_10            ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_CONFUSION_10                     ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DRAGON_BREATH_FIRE_10            ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_FIREBALL_10                      ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DRAGON_BREATH_GAS_10             ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_ENERVATION_7                     ;  // 3  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7             ;  // 3  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DRAGON_BREATH_WEAKEN_10          ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_HASTE_10                         ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7            ;  // 3  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_DRAGON_BREATH_PARALYZE_10        ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_GUST_OF_WIND_10                  ;  // 4  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_AMPLIFY_5                        ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_KNOCK_3                          ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_BLESS_2                          ;  // 0  2
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5            ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2                ;  // 0  2
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_MAGE_ARMOR_2                     ;  // 0  2
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_REMOVE_FEAR_2                    ;  // 0  2
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_FIND_TRAPS_3                     ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_SEE_INVISIBILITY_3               ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3               ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_AID_3                            ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_INVISIBILITY_3                   ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_LESSER_RESTORATION_3             ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_SHIELD_5                         ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_CLARITY_3                        ;  // 0  3
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5      ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5                ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_CAMOFLAGE_5                      ;  // 0  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_BARKSKIN_12                      ;  // 1  12
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_DISPLACEMENT_9                   ;  // 1  9
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5      ;  // 1  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5 ;  // 1  5
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_WOUNDING_WHISPERS_9              ;  // 1  9
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_RESIST_ELEMENTS_10               ;  // 2  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15                 ;  // 3  15
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_RESTORATION_7                    ;  // 3  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_BULLS_STRENGTH_15                ;  // 3  15
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15                ;  // 3  15
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_OWLS_WISDOM_15                   ;  // 3  15
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_FOXS_CUNNING_15                  ;  // 3  15
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_STONESKIN_7                      ;  // 3  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10      ;  // 3  10
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_CATS_GRACE_15                    ;  // 3  15
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7              ;  // 0  7
      else if (nSubTypeFreq==SMS_BERY_COMMON && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_TRUE_STRIKE_5                    ;  // 0  5
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_FIREBRAND_15                     ;  // 5  15
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9              ;  // 5  9
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_ICE_STORM_9                      ;  // 5  9
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_MIND_FOG_9                       ;  // 5  9
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_LESSER_PLANAR_BINDING_9          ;  // 5  9
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_GREATER_SHADOW_CONJURATION_9     ;  // 5  9
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_ANIMATE_DEAD_15                  ;  // 5  15
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_FEEBLEMIND_9                     ;  // 5  9
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_CLOUDKILL_9                      ;  // 5  9
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_FLAME_ARROW_18                   ;  // 6  18
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_10         ;  // 6  10
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12            ;  // 6  12
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_CONE_OF_COLD_15                  ;  // 7  15
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_STONE_TO_FLESH_5                 ;  // 8  5
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_ENDURANCE_15                     ;  // 4  15
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9            ;  // 5  9
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_OWLS_INSIGHT_15                  ;  // 5  15
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9              ;  // 5  9
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15    ;  // 5  15
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_AWAKEN_9                         ;  // 5  9
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_15    ;  // 6  15
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12              ;  // 6  12
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_15;  // 7  15
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_PRAYER_5                         ;  // 1  5
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_LESSER_DISPEL_5                  ;  // 1  5
      else if (nSubTypeFreq==SMS_COMMON      && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_RAISE_DEAD_9                     ;  // 5  9
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_FLESH_TO_STONE_5                 ;  // 8  5
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15  ;  // 8  15
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_PLANAR_BINDING_11                ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SUMMON_CREATURE_VI_11            ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_FLAME_STRIKE_18                  ;  // 9  18
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_POWER_WORD_STUN_13               ;  // 11 13
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_PRISMATIC_SPRAY_13               ;  // 11 13
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SUMMON_CREATURE_VII_13           ;  // 11 13
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_CREATE_UNDEAD_16                 ;  // 12 16
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11        ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GREATER_EAGLES_SPLENDOR_11       ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GREATER_FOXS_CUNNING_11          ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11      ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_MASS_HASTE_11                    ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GREATER_CATS_GRACE_11            ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GREATER_ENDURANCE_11             ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GREATER_BULLS_STRENGTH_11        ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GREATER_OWLS_WISDOM_11           ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GREATER_STONESKIN_11             ;  // 8  11
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GREATER_DISPELLING_15            ;  // 9  15
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_DISMISSAL_18                     ;  // 9  18
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15               ;  // 9  15
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_GREATER_RESTORATION_13           ;  // 11 13
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_AURA_OF_VITALITY_13              ;  // 15 13
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_DISPEL_MAGIC_10                  ;  // 3  10
      else if (nSubTypeFreq==SMS_RARE        && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7          ;  // 3  7
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_MASS_BLINDNESS_DEAFNESS_15       ;  // 15 15
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_GREATER_PLANAR_BINDING_15        ;  // 15 15
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20               ;  // 15 20
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SUMMON_CREATURE_VIII_15          ;  // 15 15
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_18         ;  // 18 18
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17            ;  // 19 17
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_GATE_17                          ;  // 19 17
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_ENERGY_DRAIN_17                  ;  // 19 17
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) return IP_CONST_CASTSPELL_UNDEATHS_ETERNAL_FOE_20          ;  // 19 20
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15         ;  // 15 15
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_MIND_BLANK_15                    ;  // 15 15
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_ENERGY_BUFFER_20                 ;  // 15 20
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20        ;  // 17 20
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_CONTROL_UNDEAD_20                ;  // 17 20
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_DOMINATE_MONSTER_17              ;  // 19 17
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_COMMON     )) return IP_CONST_CASTSPELL_SHAPECHANGE_17                   ;  // 19 17
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_WAR_CRY_7                        ;  // 2  7
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_DEATH_WARD_7                     ;  // 3  7
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_SHADOW_SHIELD_13                 ;  // 11 13
      else if (nSubTypeFreq==SMS_VERY_RARE   && SMS_PickByWeight(nPass, nRoll, SMS_RARE       )) return IP_CONST_CASTSPELL_PREMONITION_15                   ;  // 15 15
      nRoll = Random(nGlobalWeight)+1; // PICK A NUMBER BETWEEN 1 & THE TOTAL WEIGHTED OPTIONS
   }
   return IP_CONST_CASTSPELL_BLESS_2;
}

int SMS_PickByWeight(int nPass, int nRoll, int nWeight)
{
    if (nPass == 0) // FIRST PASS OF LOOP SUMS UP THE TOTAL WEIGHT TO USE ON NEXT PASS TO SELECT ONE OF THE OPTIONS
    {
        nGlobalWeight = nGlobalWeight + nWeight;
    }
    else // SECOND PASS OVER THE WE ACTUAL DECIDE WHICH TO PICK
    {
        if ((nGlobalWeight - nWeight) < nRoll) return TRUE;
        nGlobalWeight = nGlobalWeight - nWeight; // DECOMPILE THE COUNTER TO SEE WHO WON
    }
    return FALSE; // RETURN FALSE ON FIRST PASS SO ALL CONDITIONS EXECUTE
}

string SMS_PickStone()
{
    int nRoll;
    int nPass;
    string sTag;
    for (nPass = 0; nPass <= 1; nPass++)
    {
        if (nPass == 0) nGlobalWeight = 0; // FIRST PASS, ZERO AND SUM UP OUR TOTAL CHANCES
        else nRoll = Random(nGlobalWeight)+1; // SECOND PASS, PICK A NUMBER BETWEEN 1 & THE TOTAL CHANCES, THEN RETURN THE TAG
        if (SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON     )) sTag = "SMS_DAM_COLD";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) sTag = "SMS_DAM_FIRE";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) sTag = "SMS_DAM_ACID";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_BERY_COMMON)) sTag = "SMS_DAM_ELECTRIC";

        else if (SMS_PickByWeight(nPass, nRoll, SMS_COMMON       )) sTag = "SMS_DAM_BLUNT";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_COMMON       )) sTag = "SMS_DAM_POINTY";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_COMMON       )) sTag = "SMS_DAM_SHARP";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_COMMON       )) sTag = "SMS_DAM_SONIC";

        else if (SMS_PickByWeight(nPass, nRoll, SMS_RARE         )) sTag = "SMS_OH_FEAR";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_RARE         )) sTag = "SMS_OH_DAZE";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_RARE         )) sTag = "SMS_OH_SLOW";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_RARE         )) sTag = "SMS_OH_STUN";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_RARE         )) sTag = "SMS_OH_HOLD";

        else if (SMS_PickByWeight(nPass, nRoll, SMS_VERY_RARE  )) sTag = "SMS_DAM_NEGATIVE";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_VERY_RARE  )) sTag = "SMS_DAM_DIVINE";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_VERY_RARE  )) sTag = "SMS_DAM_MAGIC";
        else if (SMS_PickByWeight(nPass, nRoll, SMS_VERY_RARE  )) sTag = "SMS_DAM_POSITIVE";
    }
    return sTag;
}

object SMS_CreateStone(object oCreateOn, string sTag="") {
   if (sTag=="") sTag = SMS_PickStone();
   string sResRef = SMS_GetStoneResRef(sTag);
   string sName = SMS_GetStoneName(sTag);
   object oItem = CreateItemOnObject(sResRef, oCreateOn, 1, sTag);
   if (GetStringLeft(sTag,9)=="SMS_CAST_") {
      int nSpellID = StringToInt(GetStringRight(sTag, GetStringLength(sTag)-9));
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(nSpellID, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE), oItem);
      SetItemCharges(oItem, 10+Random(10));
   }
   int nStoneID = SMS_GetNextStoneID(oCreateOn, sName);
   SetName(oItem, sName + " #" + IntToString(nStoneID));
   if (!GetIsPC(oCreateOn)) { // DESTROY IF NOT CREATED ON PC
      SetLocalInt(oItem, "STONE_ID", nStoneID);
      SetLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM", 1);
      DelayCommand(180.f, DestroyObjectDropped(oItem));
   }
   return oItem;
}

object SMS_CreateItem(object oCreateOn, string sTag="") {
   if (sTag=="") sTag = SMS_PickStone();
   string sResRef = SMS_GetItemResRef(sTag);
   string sName = SMS_GetItemName(sTag);
   object oItem = CreateItemOnObject(sResRef, oCreateOn, 1, sTag);

   SetName(oItem, sName);
   if (!GetIsPC(oCreateOn)) { // DESTROY IF NOT CREATED ON PC
      SetLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM", 1);
      DelayCommand(180.f, DestroyObjectDropped(oItem));
   }
   return oItem;
}

