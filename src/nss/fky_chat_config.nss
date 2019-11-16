#include "db_inc"

const int USING_LINUX = TRUE;//Set this to TRUE if you are using Linux instead of Windows. The Linux version of the
//chat plugin has some added functionality which allows popup conversations with command completion when a command
//or emote is misentered.

const int USING_NWNX_DB = FALSE;//Set this to TRUE if you are using NWNX/APS persistence ints. Leave
//it set to FALSE otherwise, or if you are unsure what this means. The persistence ints in these scripts
//use the default APS database and columns, so if you did not customize your MySQL/MySQLite database they are
//ready to use. Please note that the aps_include file in this scriptset is the Windows version,
//and therefore includes support for SCO/RCO. Linux systems can use the include but will be unable to
//use persistent object commands (they will also need the Linux so to replace the dll, of course).

const int PROCESS_NPC_SPEECH = FALSE;//Leave this set this to TRUE if you want speech from NPCs to be processed through SIMTools.
//This means that all channels (including silent channels) will be monitored. It is useful for processing the speech
//of DMs possesssing NPCs. It's also necessary if you want to prevent avoidance of the ignore function by PCs possessing
//their familiars. The only downside is the increased number of scriptcalls generated, but the effect on performance should
//not be noticeable.

const int IGNORE_SILENT_CHANNELS = TRUE;//This switch turns off processing of silent channel speech if you have chosen to
//process NPC speech with the PROCESS_NPC_SPEECH speech above. This is important because monsters communicate across
//the entire module using the silent channels, and processing them could result in a greatly increased number of
//scriptcalls. You should only set this switch to FALSE if you plan to add to the functionality of SIMTools in a way
//that requires processing of silent channels. The current SIMTools scripts do not rely on processing silent channels
//at all, and DMs possessing NPCs will still have their speech processed with IGNORE_SILENT_CHANNELS set to TRUE.

const int TEXT_LOGGING_ENABLED = TRUE;//Set to TRUE to send all messages to the text log.

const int SPAMBLOCK_ENABLED = FALSE;//Set this to FALSE to turn off spam blocker. It is intended to
//stop advertising of other servers on yours.

const string EMOTE_SYMBOL = "*";//Set this to whatever single character you want players to access the emotes
//with. It is recommended that you select only a normally unused symbol, because any line beginning with this
//symbol will be seen by the system as an attempted emote, and suppressed accordingly (with an 'invalid emote'
//warning if they aren't among the listed emotes). ONLY A SINGLE CHARACTER MAY BE USED. Do not choose the
//forward slash (/), or metachannels and languages will not work. You may simply choose to use the default
//asterisk symbol, if you prefer. If you select a symbol other than the asterisk, the list commands and list
//emotes functions will display the correct symbol automatically, but you will have to change the descriptions
//of the 2 command list items to reflect the change, if you plan to use them and want them to be accurate.

const string COMMAND_SYMBOL = "!";//Set this to whatever single character you want players to access the
//commands with. It is recommended that you select only a normally unused symbol, because any line beginning
//with this symbol will be seen by the system as an attempted emote, and suppressed accordingly (with an
//'invalid emote' warning if they aren't among the listed emotes). ONLY A SINGLE CHARACTER MAY BE USED. YOU
//MUST PICK A DIFFERENT SYMBOL THAN THE ONE YOU CHOOSE FOR EMOTES, OR THE COMMANDS WILL NOT WORK. Do not
//choose the forward slash (/), or metachannels will not work. You may simply choose to use the default
//exclamation mark symbol, if you prefer. If you select a symbol other than the exclamation mark, the list commands
//and list emotes functions will display the correct symbol automatically, but you will have to change the
//descriptions of the 2 command list items to reflect the change, if you plan to use them and want them to be accurate.

const int ENABLE_WEAPON_VISUALS = TRUE;//Set this to TRUE to allow players to change the vfx on their weapons
//via the !wp commands.

const int ENABLE_METALANGUAGE_CONVERSION = FALSE;//Set this to FALSE to stop common metagame chat like 'lol'
//from being converted to emotes like *Laughs out loud* when spoken in the talk channel. Currently only 'lol'
//is converted, more will be added.

/////////////////////////////////Message Routing////////////////////////////////

const int SEND_CHANNELS_TO_CHAT_LOG = TRUE;//Set this to FALSE if you want languages, listening, and metachannels
//sent to the combat log instead of the chat log. This will elimimate the [Tell] bracketed text in front of messages
//but can make messages harder for players to read.

////////////////////////////////Listening Options///////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
//DM Listening//////////////////////////////////////////////////////////////////
const int DMS_HEAR_TELLS = FALSE;//Set this to TRUE if you want people listed in the VerifyDMKey function
//who are logged in as DMs to receive all player tell messages.
//
const int DM_PLAYERS_HEAR_TELLS = FALSE;//Set this to TRUE if you want people listed in the VerifyDMKey
//function who are logged in as players to receive all player tell messages in their combat logs. It will
//NOT route tells to people logged in as DMs, so you should use both this and the above command if you
//want both. Neither of the above commands will route tells from DMs.
//
const int DM_PLAYERS_HEAR_DM = FALSE;//Set this to TRUE if you want people listed in the VerifyDMKey
//function who are logged in as players to receive all DM messages in their combat logs. This will route
//DM messages to anyone with a cdkey you list below, if they are logged as a player. It will route DM
//messages from both players and DMs. People listed in the VerifyDMKey function who are logged as players
//will have the option to ignore these messages if this option is enabled, via the dm_ignoredm command.
//
//Admin Listening///////////////////////////////////////////////////////////////
const int ADMIN_DMS_HEAR_TELLS = TRUE;//Set this to TRUE if you want people listed in the VerifyAdminKey
//function who are logged in as DMs to receive all player tell messages.
//
const int ADMIN_PLAYERS_HEAR_TELLS = FALSE;//Set this to TRUE if you want people listed in the VerifyAdminKey
//function who are logged in as players to receive all tell messages in their combat logs. It will NOT route
//tells to people logged in as DMs, so you should use both this and the above command if you want both.
//Neither of the above commands will route tells from DMs.
//
const int ADMIN_PLAYERS_HEAR_DM = FALSE;//Set this to TRUE if you want administrators logged in as players
//to receive all DM messages in their combat logs. This will route DM messages to anyone with a cdkey you
//list below in the VerifyAdminKey function, if they are logged as a player. It will route DM messages from
//both players and DMs. DMs logged as players will have the option to ignore these messages if this option
//is enabled, via the dm_ignoredm command.
//
//General Listening/////////////////////////////////////////////////////////////
const int ENABLE_DM_TELL_ROUTING = FALSE;//Set this to TRUE if you want tells from the DM tell channel
//routed as well as tells from the player channel. This is dependant on what channel is used, and not on
//player/dm/admin status.
//
const int DM_TELLS_ROUTED_ONLY_TO_ADMINS = FALSE;//Set this to TRUE if you want DM tells routed to
//administrators (people with cd keys listed in the VerifyAdminKey function) but not to DMs (people with
//cd keys listed in the VerifyAdminKey function. You should leave the above function set to FALSE if you
//enable this.


const int DMS_HEAR_META = FALSE;//Set this to TRUE if you want DMs to receive all player metamessages. DMs
//will have the option to ignore these messages with the command dm_ignoremeta. If a DM is also in a
//metachannel, it will not duplicate the messages (like NWN does with party channel when a DM joins a party).
//
const int DM_PLAYERS_HEAR_META = FALSE;///Set this to TRUE if you want DMs logged in as players
//to receive all DM messages in their combat logs. This will route DM messages to anyone with a cdkey you
//list below in the VerifyDMKey function, if they are logged as a player. It will NOT route metamessages
//to people logged in as DMs, so you should use both this and the above command if you want both. DMs
//logged in as players will have the option to ignore these messages with the command dm_ignoremeta.
//If a DM is also in a metachannel, it will not duplicate the messages (like NWN does with party channel
//when a DM joins a party).
//
const int ADMIN_DMS_HEAR_META = FALSE;//Set this to TRUE if you want administrators logged in as DMs to receive
//all player metamessages. Administrators will have the option to ignore these messages with the command
//dm_ignoremeta. If a administrator is also in a metachannel, it will not duplicate the messages
//(like NWN does with party channel when a DM joins a party).
//
const int ADMIN_PLAYERS_HEAR_META = FALSE;///Set this to TRUE if you want administrators logged in as players
//to receive all DM messages in their combat logs. This will route DM messages to anyone with a cdkey you
//list below in the VerifyAdminKey function,if they are logged as a player. It will NOT route metamessages
//to people logged in as DMs, so you should use both this and the above command if you want both.
//Administrators logged in as players will have the option to ignore these messages with the command
//dm_ignoremeta. If an administrator is also in a metachannel, it will not duplicate the messages
//(like NWN does with party channel when a DM joins a party).

/////////////////////////Conditional Channel Disabling//////////////////////////
////////////////////////////////////////////////////////////////////////////////
const int DISALLOW_SPEECH_WHILE_DEAD = FALSE;//Set to TRUE to disable speech by dead players on one,
//several, or all chat channels. Then set the constants for the channels you want to disable to TRUE.
//These channels will only block player speakers, not DM speakers, and not DMs logged in as players. Emotes
//and Commands are automatically blocked on all channels when the player using them is dead.

const int DISABLE_DEAD_TALK = FALSE;
const int DISABLE_DEAD_SHOUT = FALSE;
const int DISABLE_DEAD_WHISPER = FALSE;
const int DISABLE_DEAD_TELL = FALSE;
const int DISABLE_DEAD_PARTY = FALSE;
const int DISABLE_DEAD_DM = FALSE;

const int DISALLOW_SPEECH_WHILE_SILENCED = FALSE;//Set to TRUE to disable speech by silenced players on one,
//several, or all chat channels. Then set the constants for the channels you want to disable to TRUE.
//These channels will only block player speakers, not DM speakers, and not DMs logged in as players.

const int DISABLE_SILENCED_TALK = FALSE;
const int DISABLE_SILENCED_SHOUT = FALSE;
const int DISABLE_SILENCED_WHISPER = FALSE;
const int DISABLE_SILENCED_TELL = FALSE;
const int DISABLE_SILENCED_PARTY = FALSE;
const int DISABLE_SILENCED_DM = FALSE;

//////////////////////////Permanent Channel Disabling///////////////////////////
////////////////////////////////////////////////////////////////////////////////
const int ENABLE_PERMANENT_CHANNEL_MUTING = FALSE;//Set this to TRUE if you want to permanently disable
//one, several, or all chat channels. Then set the constants for the channels you want to disable to TRUE.
//These channels will only block player speakers, not DM speakers, and not DMs logged in as players.
//Disabling a channel will ONLY prevent text from displaying on that channel. Emotes and commands can still
//be entered on it.

const int PERMANENT_CHANNEL_MUTING_FOR_PC_ONLY = TRUE;//Set this to FALSE to have permanent channel muting affect
//NPCs as well as PCs. Server shouts will be unaffacted.

const int DISABLE_TALK_CHANNEL = FALSE;
const int DISABLE_SHOUT_CHANNEL = FALSE;
const int DISABLE_WHISPER_CHANNEL = FALSE;
const int DISABLE_TELL_CHANNEL = FALSE;
const int DISABLE_PARTY_CHANNEL = FALSE;
const int DISABLE_DM_CHANNEL = FALSE;


//////////////////////////////DM_PORT DESTINATIONS//////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//If you want the DM commands dm_porthell, dm_portjail, and dm_porttown to work, you must specify the tags
//of their waypoints here.
//dm_porthell
const string LOCATION_HELL = "FKY_WAY_HELL"; //Replace FKY_WAY_HELL with the tag of your 'hell' waypoint.
//dm_portjail
const string LOCATION_JAIL = "jail"; //Replace FKY_WAY_JAIL with the tag of your 'jail' waypoint.
//dm_porttown
const string LOCATION_TOWN = "TELE_Loftenwood"; //Replace FKY_WAY_TOWN with the tag of your 'town' waypoint.

////////////////////////CHARACTER EDITING WITH LETOSCRIPT///////////////////////
////////////////////////////////////////////////////////////////////////////////
//If you want the DM commands dm_setcha, dm_setcon, dm_setdex, dm_setint, dm_setstr, dm_setwis, dm_setfort,
//dm_setreflex, dm_setwill, and the standard command !delete to work, you must specify your servervault path
//here so that leto can locate the character files to edit them. These commands will not work on a localvault
//server. The character is booted after each command so that the file can be edited. Sample windows and linux
//servervault paths are shown below. Leaving this const blank will disable the commands above.
const string VAULTPATH_CHAT = "";
//const string VAULTPATH_CHAT = "C:/NeverwinterNights/NWN/servervault/";//windows sample
//const string VAULTPATH_CHAT = "/home/funkyswerve/nwn/servervault/";//linux sample

const int LETO_FOR_ADMINS_ONLY = FALSE;//Set this to TRUE if you want to prevent dungeon masters from
//using the leto DM commands. DMs and players can still use the !delete command, unless you change the
//DMS_CAN_DELETE and PLAYERS_CAN_DELETE consts, below, to FALSE.

const int ALREADY_USING_LETO = FALSE;//Set this to TRUE if you are already using letoscript elsewhere in
//your module (most likely for subraces). If you don't know what this means leave this set to FALSE. This
//will prevent some conflicts that might arise in the onclientexit event. If you set this to TRUE and the
//SIMTools leto commands stop working, you will need to set it back to FALSE and make edits to your onclientexit
//script to prevent conflict between your leto scripts and SIMTools. Or, if you decide that you would rather
//not use the SIMTools leto functions because of a conflict, just set this to TRUE, and leave the VAULTPATH_CHAT
//const above set to "".

const int SAFE_DELETE = FALSE;//Set this to TRUE if you do not want the !delete command to actually delete the
//characte file. If you do this it will simply rename the file to a .utc extension, so that it will not appear
//in the player's character selection screen, but can be retrieved simply by renaming the file back to a
//.bic extension. The only downside to enabling this option is that it will interfere with later leto edits of
//characters of the same name in that player's vault, if those leto edits use a method that converts the file to
//.utc format before editing (as SIMTools edits do).

const int DMS_CAN_DELETE = FALSE;//Set this to FALSE if you do not want DMs to be able to delete characters
//with the !delete command. The delete commmand allows deletion of the targeted character, though only DMs
//and admins can target characters besides their own.

const int PLAYERS_CAN_DELETE = FALSE;//Set this to FALSE if you do not want players to be able to delete
//their own characters with the !delete command.

////////////////////////////////////DM List/////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//This function returns TRUE if the player is a dm. For it to function correctly you must enter all
//the cd keys of your DMs. Dummy cdkeys are provided below as examples. If you are not comfortable with
//shortening the functions, simply overwrite the dummy keys with the keys of your dms, and leave the
//remaining keys as is. You may, of course, add more than twelve keys, as well.
int VerifyDMKey(object oPlayer);

int VerifyDMKey(object oPlayer)
{
    if (!GetLocalInt(oPlayer, "DMCHAT"))
    {
        NWNX_SQL_ExecuteQuery("select dm,chatdm from trueid where trueid="+IntToString(dbGetTRUEID(oPlayer)));
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            //SendMessageToPC(oPlayer,"dm stuff happs");
            if (StringToInt(NWNX_SQL_ReadDataInActiveRow(1)))
                SetLocalInt(oPlayer,"DMCHAT", TRUE);
            if (GetIsDM(oPlayer) && StringToInt(NWNX_SQL_ReadDataInActiveRow(0)))
                SetLocalInt(oPlayer,"DMCHAT", TRUE);
        }
    }
    //SendMessageToPC(oPlayer,"dm stuff not happs"+ IntToString(dbGetTRUEID(oPlayer)));
    return GetLocalInt(oPlayer, "DMCHAT");
}


//////////////////////////////////Admin List////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//This function returns TRUE if the player is an administrator. Administrators in SIMTools do not
//necessarily have more power than DMs, and in fact could be configured to have less. It is merely
//a separate designation from DM, with separate settings, and potentially more power. For it to
//function correctly you must enter all the cd keys of your administrators. DO NOT LIST SOMEONE IN BOTH
//DM AND ADMIN LISTS! The system is configured to treat them as two seperate groups. Dummy cdkeys are
//provided below as examples. If you are not comfortable with shortening the functions, simply overwrite
//the dummy keys with the keys of your dms, and leave the remaining keys as is. You may, of course, add
//more than twelve keys, as well.
int VerifyAdminKey(object oPlayer);

int VerifyAdminKey(object oPlayer)
{
    string sCDKey = GetPCPlayerName(oPlayer);//GetPCPublicCDKey(oPlayer);
    if (dbGetTRUEID(oPlayer) == 1 || dbGetTRUEID(oPlayer) == 2 )
        return TRUE;
    else
        return FALSE;
}

const string ESCAPE_STRING = "&&";//Adding this escape string to the beginning of a SpeakString call will
//prevent the speaker from translating the string if they are in 'speak another language' mode. The excape
//string is automatically filtered out of what they say, whether or not they are speaking another language
//at the time. It's useful for adding to the begging of strings in scripts that you don't ever want to be
//translated, like loot notification messsages. You can set it to whatever string you want, of whatever
//length, so long as it does not begin with your command symbol (default is !), your emote symbol
//(default is *), or the forward slash channel designator (/). It should only be used for TALKVOLUME_TALK
//SpeakStrings, as they are the only volume subject to translation.
//

const int SILENT_LORE_CHECKS = FALSE;//Set this to TRUE if you want the Lore checks for language recognition
//to be performed silently instead of being displayed.

//void main(){}
