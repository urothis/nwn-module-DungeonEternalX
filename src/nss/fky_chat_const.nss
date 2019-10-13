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

//This file contains all the strings in the scriptset, set as consts. This was done to make the
//task of translating them into other languages simpler. The only remaining english strings outside
//this file that can be changed without breaking the scripts should be the subrace names in the
//fky_chat_config script, and the VFX names in the fky_chat_vfx.

//If you take the time to translate all these please send me an .erf of the script, and I will include it
//in the scriptset for other speakers of your language.

//////////////////////////////Appearance Constants//////////////////////////////
//These are here simply to make the scripts cleaner and more readable, and to make the colors
//changeable on the fly.

const string COLOR_END = "</c>";
const string COLOR_GREEN = "<c þ >"; //tells - acid
const string COLOR_RED = "<cþ<<>";
const string COLOR_RED2 = "<cþ>"; //fire damage
const string COLOR_WHITE = "<cþþþ>";
const string COLOR_BLUE = "<c!}þ>";  //electrical damage
const string COLOR_PURPLE = "<cþ>"; //names
const string COLOR_LT_PURPLE = "<cÍþ>";
const string COLOR_LT_GREEN = "<c´þd>";
const string COLOR_ORANGE = "<cþ–2>";
const string COLOR_GOLD = "<cþïP>"; //shouts
const string COLOR_YELLOW = "<cþþ>"; //send message to pc default (server messages)
const string COLOR_LT_BLUE = "<cßþ>"; //dm channel
const string COLOR_LT_BLUE2 = "<c›þþ>"; //cold damage
const string NEWLINE = "\n";

////////////////////////////////////Targeting///////////////////////////////////

const string AREA_TARGET_OK = "a";
const string OBJECT_TARGET = "o";
const string LOCATION_TARGET = "l";
const string ITEM_TARGET = "i";

////////////////////////////////////Warnings////////////////////////////////////

const string BADCHANNEL = "Invalid Channel Designation!";
const string SPAMFIX = "Spam Fix";
const string NO_ITEM = "No Item in Righthand Slot!";
const string NO_DM_TARGET = "Invalid command! You may not target a DM with this!";
const string NO_OTHER_DM_TARGET = "Invalid command! You may not target another DM with this!";
const string TARGET_OBJECT = "Invalid command! You must target an object with this!";
const string DM_ONLY = "Invalid item usage! Only DMs may use this!";
const string BADCOMMAND = "Invalid Command!";
const string NO_DM_APPEAR = "You cannot change the appearance of other DMs!";
const string NO_BASE_NPC = "Only PC base appearances are stored. You cannot use this command on NPCs.";
const string APP_CHANGED = "Appearance changed!";
const string NOT_DEAD = "You may not issue commands while dead!";
const string BADEMOTE = "Invalid Emote!";
const string NOT_DEAD_EM = "You may not emote while dead!";
const string BADLANG = "Invalid Language!";
const string BADVENT = "Invalid command! You must first select a taget with the DM Voice Thrower item!";
const string ADMIN_ONLY = "This command is reserved for administrators only!";
const string PENDING_EDIT = "This character already has leto edits pending, have them relog or boot them and try again!";
const string LETO_CONFIRM = "Leto edit entered! Character will be booted for edits momentarily.";
const string LETO_DELETE = "Deletion confirmed! Character will be booted for deletion momentarily.";
const string PC_ONLY = "This command may only be targeted at pcs!";
const string CREATURE_ONLY = "This command may only be targeted at creatures!";
const string CONFIRM_DELETE = "Please confirm deletion by sending command again followed by target's cd key as shown in ";
const string CONFIRM_DELETE2 = "playerinfo.";
const string DISCONFIRM = "Text entered did not match target's cd key! Please try again.";
const string SELECT_NO_FROM = "SELECT queries must contain a 'from', in upper or lower case.";
const string NO_BLANK_COLUMN = "SELECT queries cannot have blank column names.";
const string SQL_ROWS = " rows in set.";
const string NO_STAR = "SELECT queries cannot use * in SIMTools, they must specify column names.";
const string REQ_SEMI = "SQL commands must end in a semicolon (;)!";
const string REQUIRES_NUMBER = "This command must be followed by a positive number!";
const string REQUIRES_TARGET = "Please use your Command Targeter to select a target, or send them a tell with the !target command!";
const string REQUIRES_TARGET2 = "Please use your Command Targeter to select a target item!";
const string TARGETER_ERROR = "Command Targeter error!";
const string TARGETER_ERROR2 = "This command cannot target areas! Please reenter the command and target an object.";
const string TARGETER_ERROR3 = "Invalid location! Please try again.";
const string TARGETER_ERROR4 = "This command must target an inventory item! Please reenter the command and target an inventory item.";
const string TARGETER_ERROR5 = "You cannot target inventory items via tell! Please reenter the command and use the Command Targeter.";
const string NO_COMMON_OL = "You cannot use the one-liner command to speak common!";
const string TARGET_REQ_TELL1 = "The ";
const string TARGET_REQ_TELL2 = "command must be sent in a tell, to the intended target! Command cancelled.";
const string TARGET_NO_COMM = "You do not have any commands awaiting a target!";
const string TARGET_ON_SERV= "The target is no longer valid! Command cancelled.";

///////////////////////////////Command Completion///////////////////////////////
const string COMCOM1 = "Please speak the tail number you want.";
const string COMCOM2 = "Please speak the wing number you want.";
const string COMCOM3 = "Please speak the DC of the skill check.";
const string COMCOM4 = "Please speak the number of points to adjust target's alignment by.";
const string COMCOM5 = "Please speak the vfx number.";
const string COMCOM5b = "Please speak the duration in seconds.";
const string COMCOM6 = "Please speak the number to set the ability to.";
const string COMCOM7 = "Please speak the number to set the saving throw to.";
const string COMCOM8 = "Please speak the appearance number to use.";
const string COMCOM9 = "Please speak the amount of experience.";
const string COMCOM10 = "Please speak the number of levels.";
const string COMCOM11 = "Please speak the message to send.";
const string COMCOM12 = "Please speak the desired name.";
const string COMCOM13 = "Please speak the resref.";
const string COMCOM14 = "Please speak the sql query to send.";
const string COMCOM15 = "Please speak the name of the variable to retrieve.";
const string COMCOM16 = "Please speak the name of the variable to set.";
const string COMCOM17 = "Please speak the vaule to set the variable to.";
const string COMCOM18 = "Please speak the hour of the day to advance time to.";
const string COMCOM19 = "Please speak the tag of the waypoint to port to.";

///////////////////////////////////Skill Checks/////////////////////////////////

const string IMPOSSIBLE = "*success not possible*";
const string FAILED = "*failure*";
const string SUCCESS = "*success*";
const string VERSUS = " vs. DC: ";

//////////////////////////////////Miscellaneous/////////////////////////////////

const string VOMIT = "Bhhuaaarrggg";
const string VISUAL = "New visual added!";
const string VISUAL_REMOVE = "Visual removed!";
const string VENTRILO = "Ventrilo target selected!";
const string USES_3 = "You have already used this command 3 times during your banning this reset.";
const string LEADER = " [Party Leader]";
const string NFOHEADER = "Player Information:";
const string NFOHD = "Total Levels: ";
const string NFO1 = "Name: ";
const string NFO2 = "Playername: ";
const string NFO3 = "ID: ";
const string NFO4 = "IP: ";
const string NFO5 = "Classes: ";
const string NFO6 = "Experience: ";
const string NFO7 = "Experience Needed for Next Level: ";
const string NFO8 = "Area: ";
const string NFO9 = "Party: ";
const string NFO10 = "Diety: ";
const string NFO11 = "Subrace: ";
const string NFO12 = "Gold: ";
const string NFO13 = "Gold + Inventory Value: ";
//const string NFO14 = "Invalid Command! You must use a tell to get player info!";
const string NONE = "None";
const string LEGLEVEL = "Legendary Levels ";
const string CREATE1 = "You have created a ";
const string CREATE2 = " on ";
const string CREATE3 = "Invalid resref! No item created.";
const string FREEZE1 = "You have been frozen by a DM!";
const string FREEZE2 = "You have frozen ";
const string FREEZE3 = "You cannot freeze DMs!";
const string UNFREEZE1 = "You have been unfrozen!";
const string UNFREEZE2 = "You have unfrozen ";
const string INVIS = "You are now cutsecene invisible and ghosted.";
const string UNINVIS = "You are no longer cutsecene invisible or ghosted.";
const string INVUL1 = "You are now invulnerable.";
const string INVUL2 = " is now invulnerable.";
const string UNINVUL1 = "You are no longer invulnerable.";
const string UNINVUL2 = " is no longer invulnerable.";
const string UNINVUL3 = "You cannot remove invulnerability from other DMs!";
const string KILL1 = " is now dead.";
const string KILL2 = "You cannot DM kill DMs!";
const string DMREZ = " is now resurrected.";
const string LFG1 = "Level ";
const string LFG2 = " looking for a group!";
const string LOL = "*Laughs out loud*";
const string XP1 = "You have awarded ";
const string XP2 = " XP to ";
const string XP3 = " is already level 40!";
const string XP4 = "levels";
const string XP5 = "level";
const string XP6 = "You have given ";
const string XP7 = " to ";
const string XP8 = "You have removed ";
const string XP9 = " XP from ";
const string XP10 = " from ";
const string XP11 = "'s party.";
const string XP12 = " level to ";
const string XP13 = " levels to ";
const string XP14 = " level from ";
const string XP15 = " levels from ";
const string ALIGN1 = "You adjusted the alignment of ";
const string ALIGN2 = " towards chaos.";
const string ALIGN3 = " towards evil.";
const string ALIGN4 = " towards good.";
const string ALIGN5 = " towards law.";
const string SQL_SENT = "Database command sent!";
const string TIME_SET = "Module time advanced!";
const string FACTION_REP = "Faction adjustments made!";
const string WEATHER_CHANGE = "Weather change made!";
const string EXPLORE1 = "Area revealed to player!";
const string EXPLORE2 = "Area hidden from player!";
const string BOOTED = "You booted ";
const string ITEM_ID = "You identified ";
const string ITEM_DESTROY = "You destroyed ";
const string ITEM_END = "'s items!";
const string ITEM_END2 = "'s inventory items!";
const string ITEM_END3 = "'s equipped items!";
const string VARIABLE_SET = "Variable set!";
const string NO_VAR_SPACE = "Variables may not have spaces in their names!";
const string VARINT1 = "Local int ";
const string VARINT2 = " value: ";
const string VARINT3 = "Local float ";
const string VARINT4 = "Local string ";
const string NO_RESREF_SPACE = "Creature resrefs may not have spaces in their names!";
const string SPAWNED = "Creature spawned";
const string NO_CRITTER_RESREF = "Invalid resref! No creature spawned.";
const string DMSTEALTH1 = "Player not found.";
const string DMSTEALTH2 = " attempted to send you a tell saying: ";
const string DMSTEALTH3 = "You are now stealthy, and will show as not found if people send you tells.";
const string DMSTEALTH4 = "You are no longer stealthy, and will receive tells normally.";

/////////////////////////////////////Ignore/////////////////////////////////////

const string IGNORE1 = "You are currently ignoring ";
const string IGNORE2 = "You are currently not ignoring anyone.";
const string IGNORE3 = "You are now ignoring tells from ";
const string IGNORE4 = " is now ignoring tells from you.";
const string IGNORE5 = "You are already ignoring ";
const string IGNORE6 = "You may not ignore tells from yourself!";
const string IGNORE7 = "You may not ignore tells from DMs!";
//const string IGNORE8 = "Ignore commands must be sent as tells!";
const string IGNORED = "You are now ignoring dm channel.";
const string IGNOREM = "You are now ignoring meta channels.";
const string IGNORET = "You are now ignoring tells.";
const string UNIGNORED = "You are no longer ignoring dm channel.";
const string UNIGNOREM = "You are no longer ignoring meta channels.";
const string UNIGNORET = "You are no longer ignoring tells.";
const string UNIGNORE1 = "You are no longer ignoring tells from ";
const string UNIGNORE2 = " is no longer ignoring tells from you.";
const string UNIGNORE3 = "You weren't ignoring ";
//const string UNIGNORE4 = "Unignore commands must be sent as tells!";
const string ISIGNORED = " is ignoring your tells.";

/////////////////////////////////////Banning////////////////////////////////////

const string BAN1 = " is banned from shout.";
const string BAN2 = " is banned from dm channel.";
const string BAN3 = "There are no players playing who are banned from shout or dm channel.";
const string TEMPBANDM1 = "You have been temporarily banned from using the DM channel. The ban will be lifted after the next server reset.";
const string TEMPBANGEN = "You have temp banned ";
const string TEMPBANDM2 = " from the DM channel.";
const string PERMABAN1 = "You have been permanently banned from the server";
const string PERMABANGEN = "You have permanently banned ";
const string PERMABAN2 = " from the server.";
const string TEMPBAN = "This character has been temporarily banned from the server. You may still login and play with other characters. The ban will be lifted after the next server reset.";
const string TEMPBAN2 = " from the server. They will still be able to login another character and play, and have been told this.";
const string TEMPBANSHT = "You have been temporarily banned from using the shout channel. If you feel this was a mistake, please contact a DM. You can still use the !lfg command up to 3 times. The ban will be lifted after the server resets.";
const string TEMPBANSHT2 = " from the shout channel.";
const string BANNEDBY = "DMBanned by ";
const string PERMBANSHT1 = "You have been permanently banned from using the shout channel. If you feel this was a mistake, please contact a DM. You can still use the !lfg command up to 3 times per reset.";
const string PERMBANSHT2 = " from the shout channel.";
const string NOBANDM = "You cannot ban DMs!";
const string NOBOOTDM = "You cannot boot DMs!";
const string BANREASON1 = "There is no listed reason for the shout ban. This means that it was done at least one reset ago, and the player in question is permabanned. This was probably not done lightly, so proceed with caution.";
const string BANREASON2 = "Reason for ban: ";
const string UNBAN1 = "Your ban from use of the DM channel has been lifted.";
const string UNBAN2 = " from the DM channel.";
const string UNBAN3 = "Your ban from using the shout channel has been lifted.";
const string UNBAN4 = " from the shout channel.";
const string UNBANGEN = "You have unbanned ";
const string BANNEDSHT = "You are banned from using the shout channel.";
const string BANNEDDM = "You are currently banned from using the DM channel. The ban will be lifted next reset.";

///////////////////////////////////Dice Rolls///////////////////////////////////

const string ROLL1 = " rolled a [";
const string ROLL2 = "] and got a: [";
const string ROLLGOOD = "Wow! Nice roll!";

//////////////////////////////////Visul Effects/////////////////////////////////

const string BADEFFECT_TYPE = "Invalid Command! Specify S, E, or SE for supernatural or extraordinary effect.";
const string BADEFFECT_NUM = "Invalid VFX#!";
const string NEED_DURATION = "Invalid duration number! Specify 0 for instant, 1 for temporary, or 2 for permanent.";

////////////////////////////////////Languages///////////////////////////////////

const string LANGLIST1 = "You may speak in any language that your character knows, in two different ways. By typing ";
const string LANGLIST2 = "with a space after it and then the name of the laguage, followed by a space and then the meesage you want to speak, you may utter a single sentence at a time in the language designated. You may also type ";
const string LANGLIST3 = "followed by a space and then the name of the language. That will cause your character to speak that language until instructed to speak another language or to ";
const string LANGLIST4 = "The only language that your character knows is common.";
const string LANGLIST5 = "Your character knows the following languages:";
const string LANGLIST6 = "You may stop speaking another language at any time with the ";
const string LANGLIST7 = " comand.";
const string LANGLIST8 = "These are all the languages a character can learn:";
const string LANG1 = "Invalid Language!";
const string LANG2 = "You taught ";
const string LANG3 = "You removed knowledge of ";
const string LANG4 = " from  ";
const string SPEAK1 = "You are now speaking Common instead of ";
const string SPEAK2 = "You are already speaking Common!";
const string SPEAK3 = "You are already speaking ";
const string SPEAK4 = "You are now speaking ";
const string SPEAK5 = " instead of ";
const string SPEAK6 = "You do not know ";
const string UNKN_LANG = "Unknown Language";
const string CHAN_LANG = "You may only speak languages in talk or party channels!";
const string NO_SPEAK = "You cannot speak ";

//All three cant-style languages have the same default:

const string LANG_DEFAULT = "*nods*";

////////////////////////////////////Channels///////////////////////////////////

const string TALK = "Talk";
const string SHOUT = "Shout";
const string WHISPER = "Whisper";
const string TELL = "Tell";
const string SERVER = "Server";
const string PARTY = "Party";
const string DM = "DM";
const string UNKNOWN = "Unknown";
const string CHAN1 = "Meta";
const string CHAN2 = "Channel";
const string METADBND = " has disbanded the metachannel.";
const string METAMEMB = "The following people are members of your current metachannel:";
const string METABAD = "Invalid Command! You are not currently in a metachannel.";
const string META1 = "Metachannel invite accepted!";
const string META2 = " has joined the metachannel.";
const string META3 = "You have not receieved an invitation to a metachannel.";
const string META4 = "You are already in a metachannel! You must leave it before you can accept an invitation to another.";
const string META5 = "Metachannel invite declined!";
const string META6 = " has declined an invitation to join the channel.";
const string META7 = "Metachannel invite received from ";
const string META8 = "Metachannel invite sent!";
const string META9 = " is already in a metachannel!";
//const string META10 = "Invalid Command! You must invite with a tell.";
const string META11 = "You have been kicked from the metachannel!";
const string META12 = " has been kicked from the metachannel.";
const string META13 = "Invalid Command! ";
const string META14 = " is not a member of your metachannel!";
const string META15 = "Invalid Command! Only the leader can kick.";
const string META16 = "Invalid Command! You must kick with a tell.";
const string META17 = "You have exited the metachannel!";
const string META18 = " has exited the metachannel.";
const string NOMETA1 = "You may not use metachannels while dead!";
const string NOMETA2 = "You must be in a metagroup to send messages on metachannels!";

/////////////////////////////////////Skills/////////////////////////////////////

const string SKILL0 = "Animal Empathy";
const string SKILL1 = "Concentration";
const string SKILL2 = "Disable Trap";
const string SKILL3 = "Discipline";
const string SKILL4 = "Heal";
const string SKILL5 = "Hide";
const string SKILL6 = "Listen";
const string SKILL7 = "Lore";
const string SKILL8 = "Move Silently";
const string SKILL9 = "Open Lock";
const string SKILL10 = "Parry";
const string SKILL11 = "Perform";
const string SKILL12 = "Persuade";
const string SKILL13 = "Pick Pocket";
const string SKILL14 = "Search";
const string SKILL15 = "Set Trap";
const string SKILL16 = "Spellcraft";
const string SKILL17 = "Spot";
const string SKILL18 = "Taunt";
const string SKILL19 = "Use Magic Device";
const string SKILL20 = "Appraise";
const string SKILL21 = "Tumble";
const string SKILL22 = "Craft Trap";
const string SKILL23 = "Bluff";
const string SKILL24 = "Intimidate";
const string SKILL25 = "Craft Armor";
const string SKILL26 = "Craft Weapon";

/////////////////////////////////////Classes////////////////////////////////////

const string CLASS0 = "Barbarian";
const string CLASS1 = "Bard";
const string CLASS2 = "Cleric";
const string CLASS3 = "Druid";
const string CLASS4 = "Fighter";
const string CLASS5 = "Monk";
const string CLASS6 = "Paladin";
const string CLASS7 = "Ranger";
const string CLASS8 = "Rogue";
const string CLASS9 = "Sorcerer";
const string CLASS10 = "Wizard";
const string CLASS27 = "Shadowdancer";
const string CLASS28 = "Harper Scout";
const string CLASS29 = "Arcane Archer";
const string CLASS30 = "Assassin";
const string CLASS31 = "Blackguard";
const string CLASS32 = "Champion of Torm";
const string CLASS33 = "Weapon Master";
const string CLASS34 = "Pale Master";
const string CLASS35 = "Shifter";
const string CLASS36 = "Dwarven Defender";
const string CLASS37 = "Red Dragon Disciple";

/////////////////////////////////////Emotes/////////////////////////////////////

const string EMOTE_INTRO = "These are the emotes you can use via chat. They can be typed into any chat channel (party, talk, shout, etc.) and have the same effect in all of them. They are case insensitive. Most emotes also have a two-letter shortcut which may be used instead, in parentheses to the right of the emote.";
const string EMOTE1 = "agree (ag)";
const string EMOTE2 = "beg (bg)";
const string EMOTE3 = "bend (bn)";
const string EMOTE4 = "bored (bo)";
const string EMOTE5 = "bow (bw)";
const string EMOTE6 = "cantrip (ca)";
const string EMOTE7 = "cast (cs)";
const string EMOTE8 = "celebrate (cl)";
const string EMOTE9 = "chat (ct)";
const string EMOTE10 = "cheer (ch)";
const string EMOTE11 = "chuckle (ck)";
const string EMOTE12 = "curtsy (cy)";
const string EMOTE13 = "dance (da)";
const string EMOTE14 = "dead (dd)";
const string EMOTE15 = "demand (dm)";
const string EMOTE16 = "die (di)";
const string EMOTE17 = "dodge (dg)";
const string EMOTE18 = "drink (dr)";
const string EMOTE19 = "drunk (dn)";
const string EMOTE20 = "duck (dk)";
const string EMOTE21 = "exhausted (ex)";
const string EMOTE22 = "fall (fl)";
const string EMOTE23 = "fatigue (fa)";
const string EMOTE24 = "fiddle (fi)";
const string EMOTE25 = "fidget (fg)";
const string EMOTE26 = "flop (fp)";
const string EMOTE27 = "giggle (gi) (female only)";
const string EMOTE28 = "greet (gr)";
const string EMOTE29 = "hooray (hy)";
const string EMOTE30 = "hum (hm)";
const string EMOTE31 = "laugh (la)";
const string EMOTE32 = "meditate (md)";
const string EMOTE33 = "mock (mo)";
const string EMOTE34 = "nap (np)";
const string EMOTE35 = "no";
const string EMOTE36 = "nod (nd)";
const string EMOTE37 = "peer (pe)";
const string EMOTE38 = "plead (pl)";
const string EMOTE39 = "pray (pr)";
const string EMOTE40 = "prone (pn)";
const string EMOTE41 = "puke (pu)";
const string EMOTE42 = "read (re)";
const string EMOTE43 = "salute (sa)";
const string EMOTE44 = "scan (sn)";
const string EMOTE45 = "scratch (sc)";
const string EMOTE46 = "shift (sh)";
const string EMOTE47 = "sing (sg)";
const string EMOTE48 = "sip";
const string EMOTE49 = "sit (si)";
const string EMOTE50 = "sleep (sl)";
const string EMOTE51 = "smoke (sm)";
const string EMOTE52 = "snore";
const string EMOTE53 = "spasm (sp)";
const string EMOTE54 = "steal (st)";
const string EMOTE55 = "stretch (sr)";
const string EMOTE56 = "stoop (so)";
const string EMOTE57 = "swipe (sw)";
const string EMOTE58 = "talk (tl)";
const string EMOTE59 = "taunt (ta)";
const string EMOTE60 = "threaten (th)";
const string EMOTE61 = "tired (ti)";
const string EMOTE62 = "vomit (vm)";
const string EMOTE63 = "wave (wa)";
const string EMOTE64 = "whistle (wh)";
const string EMOTE65 = "woozy (wz)";
const string EMOTE66 = "worship (wo)";
const string EMOTE67 = "yawn (yw)";

////////////////////////////////////Commands////////////////////////////////////

const string COMMAND1 = "These are the commands you can use via chat. They can be typed into any chat channel (party, talk, shout, etc.) and have the same effect in all of them. They are case insensitive.";
const string COMMAND2 = "Commands shown in green must either be sent via tell or targeted with the command targeter. You will be prompted to use the command targeter if you do not target via tell.";
const string COMMAND2_1 = "= Rolls a d4.";
const string COMMAND3 = "= Rolls a d6.";
const string COMMAND4 = "= Rolls a d8.";
const string COMMAND4_1 = "= Rolls a d10.";
const string COMMAND5 = "= Rolls a d12.";
const string COMMAND6 = "= Rolls a d20.";
const string COMMAND7 = "= Rolls a d100.";
const string COMMAND9 = "(must be targeted by tell) = Lists the target's Playername, CD Key, IP, Classes, Experience, Experience Needed for Next Level, Area, Partymembers, Diety, Subrace, Gold, and Gold Plus Inventory Value.";
const string COMMAND10 = "(must be targeted by tell) = Lists the target's Playername, CD Key, Classes, Experience, Experience Needed for Next Level, Area, and Partymembers. If used on yourself it also shows Diety, Subrace, Gold, and Gold Plus Inventory Value.";
const string COMMAND11 = "= Changes weapon visual to acid.";
const string COMMAND12 = "= Changes weapon visual to cold.";
const string COMMAND13 = "= Changes weapon visual to electric.";
const string COMMAND14 = "= Changes weapon visual to evil.";
const string COMMAND15 = "= Changes weapon visual to fire.";
const string COMMAND16 = "= Changes weapon visual to holy.";
const string COMMAND17 = "= Lists the useable chat emotes.";
//const string COMMAND18 = "= Lists the useable chat commands.";
const string COMMAND19 = "= Lists the players you have chosen to ignore.";
const string COMMAND20 = "= Lists all the languages a player can speak, and explains the ";
const string COMMAND20b = " (oneliner) and ";
const string COMMAND20c = " command uses.";
const string COMMAND21 = "= Lists all the languages available in SIMTools.";
const string COMMAND22 = "= Announces that you are looking for a group in shout.";
const string COMMAND23 = "= Accepts an invitation to a metachannel.";
const string COMMAND24 = "= Declines an invitation to a metachannel.";
const string COMMAND25 = "= Removes every member of the metachannel. Only the leader of the metachannel can disband it.";
const string COMMAND26 = "(must be targeted by tell or command targeter) = Invites the target to your current metachannel. If you are not in a meta chanel, a new channel will be created if that person accepts.";
const string COMMAND27 = "(must be targeted by tell or command targeter) = Kicks the target from your metachannel. Only the leader of the metachannel can kick people from it.";
const string COMMAND28 = "= Removes you from your current metachannel.";
const string COMMAND29 = "= Lists the people in your metachannel.";
const string COMMAND30 = "= Sends the text entered after the channel designation to the player's metachannel.";
const string COMMAND31 = "= Allows the speaker to rename one of their items. The command format is ";
//const string COMMAND31b = "old name";
const string COMMAND31c = "new name";
const string COMMAND31d = ". The command is case-sensitive. Example: To rename item Longsword to Sam's Sword: ";
//const string COMMAND31e = "Longsword";
const string COMMAND31f = "Sam's Sword";
const string COMMAND31g = ". This command must be targeted at an item, using the Command Targeter.";
const string COMMAND32a = "= This command is identical in function and format to ";
const string COMMAND32b = ", but will rename all items in the targeted item's possessor's inventory of the same name as the targeted item.";
const string COMMAND33 = "= Allows players to roll checks against a specific skill and DC. The command format is ";
const string COMMAND33b = "(skill#) (DC#)";
const string COMMAND33c = " . Example: A DC 20 Discipline Check would be spoken as follows: ";
const string COMMAND33d = " . The result will be displayed in floating text above the player. A list of skill numbers can be called up using the ";
const string COMMAND33e = " command.";
const string COMMAND34 = "= Sends a list of the skills and matching skill numbers to the players combat log, for easy reference when using the ";
const string COMMAND34b = " command to do skill checks.";
const string COMMAND35 = "(must be targeted by tell or command targeter) = You will not receive tells from the player you send this command to.";
const string COMMAND36 = "(must be targeted by tell or command targeter) = Removes ignore status.";
const string COMMAND37 = "(must be targeted by tell or command targeter) = Changes the character's tail to the specified number, or removes it if 0 entered. The command format is ";
const string COMMAND38 = ". May not be used on other DMs.";
const string COMMAND39 = "(must be targeted by tell or command targeter) = Changes the character's wings to the specified number, or removes them if 0 entered. The command format is ";
const string COMMAND40 = "= Lists the useable chat commands plus explanations.";
const string COMMAND41 = "= Speak a single line in the specified language. The command format is ";
const string COMMAND42 = " (name of language) (message)";
const string COMMAND43 = ". You can get a list of the languages your character is able to speak with the ";
const string COMMAND44 = " command.";
const string COMMAND45 = "= Using this command makes you speak the language specified until you ";
const string COMMAND46 = " another language or ";
const string COMMAND47 = " to speak normally again. You can get a list of the languages your character is able to speak with the ";
const string COMMAND48 = " command.";
const string COMMAND49 = "(must be targeted by tell or command targeter) = Deletes the target character. It will ask for confimation by repetition of the command combined with the target's public cd key, as shown in the ";
const string COMMAND50 = "= Removes weapon visual.";
const string COMMAND51 = "= Forces summoned creature to attack PCs current target. WIP.";

///////////////////////////////////DM Commands//////////////////////////////////

const string DMCOMMAND1 = "These are the DM commands that DMs and DMs logged in as players can use via chat. They are case insensitive.";
const string DMCOMMAND2 = "= Bans the target from using DM channel until the next reset. May not be targeted at a DM.";
const string DMCOMMAND3 = "= Bans the target player's cdkey permanently from your server. If the banned player attempts to reconnect they are autobooted. May not be targeted at a DM.";
const string DMCOMMAND4 = "= Bans the target character from your server until the next reset. If the banned character attempts to reconnect they are autobooted. May not be targeted at a DM.";
const string DMCOMMAND5 = "= Bans the target from using shout channel until the next reset. May not be targeted at a DM.";
const string DMCOMMAND6 = "= Bans the target from using shout channel permanently. May not be targeted at a DM.";
const string DMCOMMAND7 = "= Allows the DM to change the appearance of the targeted creature. The command format is ";
const string DMCOMMAND7b = "appearance number";
const string DMCOMMAND7c = " . Example: to change the target's appearance to that of a badger: ";
const string DMCOMMAND7d = " .There are too many appearance numbers to list, but experimentation will yeild results, as with the dm console command. Numbers range up to around 3200 or so if CEP2 is installed, fewer otherwise.";
const string DMCOMMAND8 = "= Resets the appearance of the target PC to what it was before any ";
const string DMCOMMAND8b = " commands were used on them. It is only available if you are using the NWNX database, or are using the Bioware database with languages enabled. Unlike the ";
const string DMCOMMAND8c = " command, this command can only be used on PCs.";
const string DMCOMMAND9 = "= Creates an item of the entered resref on the target.";
const string DMCOMMAND10 = "= Makes the target uncommandable. May not be targeted at a DM.";
const string DMCOMMAND11 = "= Allows the DM to create any vfx on the target. For COM, IMP, and FNF visuals, the format is simple, because the duration type and duration are always 0: ";
const string DMCOMMAND11b = "vfx#";
const string DMCOMMAND11c = " . Example: to apply a meteor swarm vfx effect on the target: ";
const string DMCOMMAND11d = "For DUR, BEAM, and EYES visuals, a duration type and duration must be specified, and you may also make the effect extraordinary (undispellable) or supernatural (not removed by rest), or both. Format: ";
const string DMCOMMAND11e = "duration type#";
const string DMCOMMAND11f = "duration";
const string DMCOMMAND11g = " . Duration type is either 1 for temporary or 2 for permanent. Duration is the number of seconds you want the effect to last. Example: to apply a dominated vfx effect for a duration of 5 minutes: ";
const string DMCOMMAND11h = "To make that same effect Extraordinary: ";
const string DMCOMMAND11i = " . To make permanent vfx you use 2 for the type, and use 0 for the number of seconds: ";
const string DMCOMMAND11j = " . Because vfx numbers are far from intuitive, a ";
const string DMCOMMAND11k = " command is available to show what vfx # creates what effect.";
const string DMCOMMAND12 = "= Lists the vfx numbers and names of each type of vfx, by replacing the asterisk with one of 6 three-letter fx type codes: ";
const string DMCOMMAND12b = ". Example: ";
const string DMCOMMAND12c = " lists all the vfx names and numbers for Fire-and-Forget type visual effects. ";
const string DMCOMMAND12d = " lists duration types, ";
const string DMCOMMAND12e = " lists beam types, and so on.";
const string DMCOMMAND13 = "= This command is identical in function and format to the ";
const string DMCOMMAND13b = " command, but will create the effect at the target location instead of on a target object.";
const string DMCOMMAND14 = "= Removes all visual effects on the target that were created by the sender. This includes all those created by the ";
const string DMCOMMAND15 = "= Shows a list of all the players banned from shout or DM channel.";
const string DMCOMMAND16 = "= Shows why the target was banned from shout channel - Spam or DM. The reason for the banning is only stored until the next reset, so will not display for permabanned players. The name of the DM who did the ban will be shown for DM bans, and the message that resulted in the ban will be displayed for spam autobans.";
const string DMCOMMAND16_1 = "= Gives the target the specified amount of experience. The command format is ";
const string DMCOMMAND16_1b = "amount of xp to give";
const string DMCOMMAND16_1c = ". To award 500xp, for instance, you would type: ";
const string DMCOMMAND16_2 = "= Gives the target the specified number of levels. The command format is ";
const string DMCOMMAND16_2b = "number of levels to give";
const string DMCOMMAND16_2c = ". To give 2 levels, for instance, you would type: ";
const string DMCOMMAND16_3 = "= Removes the specified amount of experience from the target. The command format is ";
const string DMCOMMAND16_3b = "amount of xp to take";
const string DMCOMMAND16_3c =". To remove 500xp, for instance, you would type: ";
const string DMCOMMAND16_4 = "= Removes the specified number of levels from the target. The command format is ";
const string DMCOMMAND16_4b = "number of levels to take";
const string DMCOMMAND16_4c = ". To take 2 levels, for instance, you would type: ";
const string DMCOMMAND17 = "= The sender will ignore DM channel if they are logged in as a player.";
const string DMCOMMAND18 = "= The sender will ignore meta channels.";
const string DMCOMMAND19 = "= The sender will ignore all tells except those sent to or by him.";
const string DMCOMMAND20 = "= The sender is made cutsecene invisible and ghosted.";
const string DMCOMMAND21 = "= The target is made invulnerable.";
const string DMCOMMAND22 = "= The target is killed. May not be used on DMs.";
const string DMCOMMAND23 = "= Teaches the target the language specified. The language name, in lower case, follows the command: ";
const string DMCOMMAND23b = ", for instance, would teach the target the Sylvan language. You can list the available languages using the ";
const string DMCOMMAND23c = " command.";
const string DMCOMMAND24 = "= The sender is sent a list explaining all the dm_ commands for use by DMs and DMs logged in as players.";
const string DMCOMMAND25 = "= The target is teleported to the sender. May not be used on other DMs.";
const string DMCOMMAND26 = "= The target is sent for punishment. May not be used on other DMs.";
const string DMCOMMAND27 = "= The target is sent for detainment. May not be used on other DMs.";
const string DMCOMMAND28 = "= The target is teleported to his partyleader. May not be used on other DMs.";
const string DMCOMMAND29 = "= The sender is teleported to the target.";
const string DMCOMMAND30 = "= The target is teleported to town. May not be used on other DMs.";
const string DMCOMMAND31 = "= The target is resurrected. May not be used on other DMs.";
const string DMCOMMAND32 = "= The server is shut down and restarted immediately.";
const string DMCOMMAND33 = "= The target is no longer banned from using DM channel.";
const string DMCOMMAND34 = "= The target is no longer banned from using shout channel.";
const string DMCOMMAND35 = "= Makes the target commandable again.";
const string DMCOMMAND36 = "= The sender will no longer ignore DM channel.";
const string DMCOMMAND37 = "= The sender will no longer ignore meta channels.";
const string DMCOMMAND38 = "= The sender will no longer ignore any tells.";
const string DMCOMMAND39 = "= The sender is no longer cutsecene invisible or ghosted.";
const string DMCOMMAND40 = "= The target is made vulnerable again.";
const string DMCOMMAND41 = "= Removes knowledge of the language specified from the target. Format is the same as ";
const string DMCOMMAND41b = " . You can list the available languages using the ";
const string DMCOMMAND41c = " command.";
const string DMCOMMAND42 = "= This is the ventriloquism command. Once they select a target, the dm may 'throw' their voice to the target at any time, simply by typing /v with a space after it, before the text to be spoken by the target. May only be used by DMs. May not be targeted at other DMs.";
const string DMCOMMAND43 = "= The target has their alignment shifted towards chaos by the number of points input. The command format is ";
const string DMCOMMAND44 = "(amount to shift)";
const string DMCOMMAND45 = ". Note that partymembers will be affected as well to an extent.";
const string DMCOMMAND46 = "= The target has their alignment shifted towards evil by the number of points input. The command format is ";
const string DMCOMMAND47 = "= The target has their alignment shifted towards good by the number of points input. The command format is ";
const string DMCOMMAND48 = "= The target has their alignment shifted towards law by the number of points input. The command format is ";
const string DMCOMMAND69 = "(amount to give)";
const string DMCOMMAND70 = "(number to give)";
const string DMCOMMAND71 = "(amount to remove)";
const string DMCOMMAND72 = "(number to remove)";
const string DMCOMMAND73 = "= All items in the target's inventory are identified.";
const string DMCOMMAND74 = "= All the target's items are destroyed. May only be used on creatures.";
const string DMCOMMAND75 = "= All items the target has equipped are destroyed. May only be used on creatures.";
const string DMCOMMAND76 = "= All items in the target's inventory are destroyed.";
const string DMCOMMAND78 = "= Lists the dm_ commands useable by DMs and DMs logged in as players, plus explanations.";
const string DMCOMMAND79 = "= The target is booted. May not be used on other DMs.";
const string DMCOMMAND80 = "= Executes the input sql command to the database. It can return SELECT queries as well, so long as they specify column names instead of using *. Command format is ";
const string DMCOMMAND81 = " (sql query)";
const string DMCOMMAND82 = ". Only administrators can use this command.";
const string DMCOMMAND83 = "= The target is instantly rested. May not be used on other DMs.";
const string DMCOMMAND84 = "= The target has their area map revealed to them.";
const string DMCOMMAND85 = "= The target has their area map hidden from them.";
const string DMCOMMAND86 = "= Jumps the DM to the targeted location.";
const string DMCOMMAND87 = "= All players in the party of the target are teleported to the sender. May not be targeted at other DMs.";
const string DMCOMMAND88 = "= All players in the party of the target are sent for punishment. May not be targeted at other DMs.";
const string DMCOMMAND89 = "= All players in the party of the target are sent for detainment. May not be targeted at other DMs.";
const string DMCOMMAND90 = "= All players in the party of the target are teleported to their partyleader. May not be targeted at other DMs.";
const string DMCOMMAND91 = "= All players in the party of the dm are teleported to the target of the tell. May be targeted at NPCs and other objects, unlike the other party port commands.";
const string DMCOMMAND92 = "= All players in the party of the target are teleported to town. May not be targeted at other DMs.";
const string DMCOMMAND93 = "(desired score)";
const string DMCOMMAND94 = "(desired save)";
const string DMCOMMAND95 = "= The target's charisma is set to the number specified. The number must be between 3 and 99 inclusive. The command format is ";
const string DMCOMMAND96 = "= The target's constitution is set to the number specified. The number must be between 3 and 99 inclusive. The command format is ";
const string DMCOMMAND97 = "= The target's dexterity is set to the number specified. The number must be between 3 and 99 inclusive. The command format is ";
const string DMCOMMAND98 = "= The target's intelligence is set to the number specified. The number must be between 3 and 99 inclusive. The command format is ";
const string DMCOMMAND99 = "= The target's strength is set to the number specified. The number must be between 3 and 99 inclusive. The command format is ";
const string DMCOMMAND100 = "= The target's wisdom is set to the number specified. The number must be between 3 and 99 inclusive. The command format is ";
const string DMCOMMAND101 = "= The target's fort save is set to the number specified. The command format is ";
const string DMCOMMAND102 = "= The target's reflex save is set to the number specified. The command format is ";
const string DMCOMMAND103 = "= The target's will save is set to the number specified. The command format is ";
const string DMCOMMAND104 = "(name of variable)";
const string DMCOMMAND105 = " (int value)";
const string DMCOMMAND106 = " (float value)";
const string DMCOMMAND107 = " (string value)";
const string DMCOMMAND108 = ". You may target the area by clicking on the ground.";
const string DMCOMMAND109 = "= Sets";
const string DMCOMMAND110 = "= Gets";
const string DMCOMMAND111 = " a local int";
const string DMCOMMAND112 = " a local float";
const string DMCOMMAND113 = " a local string";
const string DMCOMMAND114 = " on the target. Command format is ";
const string DMCOMMAND115 = " on the module. Command format is ";
const string DMCOMMAND116 = "= This command sets the module time forward to the specified hour. The command format is ";
const string DMCOMMAND117 = "= The weather in the target's area is set to clear, if it is an exterior area.";
const string DMCOMMAND118 = "= The weather in the target's area is set to rain, if it is an exterior area.";
const string DMCOMMAND119 = "= The weather in the target's area is set back to the area default settings, if it is an exterior area.";
const string DMCOMMAND120 = "= The weather in the target's area is set to snow, if it is an exterior area.";
const string DMCOMMAND121 = "= The weather is set to clear in all exterior areas.";
const string DMCOMMAND122 = "= The weather is set to rain in all exterior areas.";
const string DMCOMMAND123 = "= The weather is set back to the area default settings in all exterior areas.";
const string DMCOMMAND124 = "= The weather is set to snow in all exterior areas.";
const string DMCOMMAND125 = "(desired hour)";
const string DMCOMMAND126 = "= Spawns a creature of the specified resref at the target location. Command format is ";
const string DMCOMMAND127 = "(resref)";
const string DMCOMMAND128 = "= Can be used instead of the DM Voice Thrower to select a target for the ";
const string DMCOMMAND129 = " (ventriloquism) command. May not target DMs.";
const string DMCOMMAND130 = "= The target is teleported to the specified waypoint. May not be used on other DMs.";
const string DMCOMMAND131 = "= All players in the party of the target are teleported to the specified waypoint. May not be used on other DMs.";
const string DMCOMMAND132 = "= Toggles dm stealth mode off and on. When dm stealth mode is on tells sent to you will display the 'Player not found.' message to the sender.";



