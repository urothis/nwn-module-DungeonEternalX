
///////////////////////////////////////////////////////////////////////////////
/////////////////////Mad Rabbit's Player Chat Commands/////////////////////////
////////////////////////////////Version 1.01///////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
/*
////////////////////////////////////////////////////////////////////////////////
//Created By : MadRabbit                                                      //
//Email : mad_rabbit_land@hotmail.com                                         //
//Created On : March 2009                                                     //
//Updated On : March 2009                                                     //
//NOTE : Do not email me with requests. Only bug reports and suggestions for  //
//improvement of the entire program for the vault. I do not do special        //
//versions for individual worlds.                                             //
//CREDIT : Ravish for Ravish's Intimate Emotes                                //
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
Version 1.01 (March 2009)
    - Added messages informing players of which action they just performed to
the Description Modification section.
    - Removed the const string for the spam variable name as not used enough
to justify taking up space
    -Restructured the code on com_source so future updates will require no
modification
    - Added /dsc pvw
    - Added /mad rabbit touch of death
    - Added /eye commands
    - Added /sex commands
    - Added commands for speaking through player associates
    - Added /sve commands
    - Added /itm commands
    - Added /jrl commands

Version 1.02 (March2009)
    -Updated the instructions on core_source, Player Book, and html file
    -Added the commands /stp and /stp buffs. These files along with /sve
and /mad rabbit touch of death have been packaged into MRMisc
    -Added hlp commands to Emotes, Description Modification, Item Modification,
Sexual Positions, Voice Chat
    -Erfs Updated: MRCore, MRLibrary, MRMisc, MREmotes, MRItem, MRDesc, MRSex,
MR Voice

VERSION 1.03 (March2009)
    -Updated the instructions on core_source and html file for the new /csm
commands. Not added to Player Book
    -Added MROptional1 Erf to the download list featuring commands for Vaei's
Additional Animations.
    -Erfs Updated: MRCore

Version 1.04 (March2009)
    -Updated the instructions on core_source, Player Book, and html file
    -Added the commands /dce
    -Added the commands /fam, /cmp and /sum
    -Erfs Updated: MRDice, MRFamiliar, MRCompanion, MRSummons, MRLibrary, MRCore



////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
TO INSTALL
-Import the erf MRCore.
-The remaining erfs each contain a specific group of commands. The name of each
group and the commands they contain can be found below. Each group can function
independently from the other so you may import the ones you want and leave out
the ones you don’t. Ex: MREmotes contains all the emote commands and MRItems
contains all the item modification commands. If you wish to use the entire
library of commands, import MRLibrary.
- Place the script on_player_chat on the OnPlayerChat Event under Module
Properties or open the script and follow the instructions to add the code to
your own script.
- Place the script on_item_act on the OnActivateItem Event under Module
Properties or open the script and follow the instructions to add the code to
your own script.
- Place the book Player Chat Commands for sale somewhere in your module for
players to use.
- Place the item Player Command Item Selector for sale somewhere in your module
for players to use if you are using the Item Modification commands.
- Blank Notes and Player Journals should NOT be placed anywhere in the module.
They only need to exist in the palette. (Item Modification commands)
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
PLAYER CHAT COMMANDS

COMMAND                       ACTION
/emo hlp                      Displays a list of all emote commands
/emo bend                     Player bends over slightly
/emo bend low                 Player bends over low to the ground
/emo bored                    Player becomes bored
/emo bow                      Player bows
/emo conjure 1                Player begins to conjure a spell (1)
/emo conjure 2                Player begins to conjure a spell (2)
/emo dance                    Player begins to dance
/emo dodge                    Player dodges by stepping to side
/emo drink                    Player drinks
/emo duck                     Player dodges by ducking low
/emo greet                    Player greets another player
/emo head left                Player turns head to left
/emo head right               Player turns head to right
/emo laugh                    Player laughs
/emo lay up                   Player lays down, face up
/emo lay down                 Player lays down, face down
/emo listen                   Player begins to listen
/emo look                     Player begins to look off in the distance
/emo kneel                    Player kneels
/emo plead                    Player pleads with another player
/emo read                     Player reads a book
/emo salute                   Player salutes
/emo scratch                  Player scratchs their head
/emo sit                      Player sits on the ground
/emo spasm                    Player begins to spasm
/emo smoke                    Player begins to smoke a pipe
/emo talk                     Player talks to another player
/emo taunt                    Player taunts another player
/emo threaten                 Player threatens another player
/emo victory 1                Player performs Victory Animation 1
/emo victory 2                Player performs Victory Animation 2
/emo victory 3                Player performs Victory Animation 3
/emo worship                  Player worships

/hug front                    Hug nearest player face to face
/hug behind                   Hug nearest player from behind
/hug back up                  Back up tight against nearest player

/wlk                          Toggles walking mode on and off

/tch on                       Turn touching mode on
/tch off                      Turn touching mode off

/lap chair facing             Sit in the lap of the nearest person in a chair, facing them
/lap chair away               Sit in the lap of the nearest person in a chair, facing away
/lap chair left               Sit in the lap of the nearest person in a chair, facing to left
/lap chair right              Sit in the lap of the nearest person in a chair, facing to right
/lap facing                   Sit in the lap of the nearest person on the ground, facing them
/lap away                     Sit in the lap of the nearest person on the ground, facing away

/dsc hlp                      Displays a list of all description commands
/dsc sve                      Temporarily saves your current description
/dsc lod                      Loads your temporarily saved description
/dsc clr                      Clears your temporarily saved description
/dsc add DESCRIPTION          Adds DESCRIPTION to the end of your current description.
/dsc car                      Adds a carriage line to the end of your description.
/dsc del                      Deletes your current description
/dsc rst                      Resets your description to the orginal one from character creation
/dsc pvw                      Shows player their description

*The following are used in conjunction with the Player Command Item Selector item*
/itm hlp                      Displays a list of all item modification commands
/itm pvw                      Gives the name of the item currently selected
/itm clr                      Clears the selected item
/itm add DESCRIPTION          Adds DESCRIPTION to the end of the selected item's current description
/itm car                      Adds a carriage line to the end of the selected item's current description
/itm del                      Deletes the selected item's current description
/itm rst                      Reset's the item's current description and name to the orginal description and name
/itm nme NAME                 Changes the selected item's name to NAME
/itm nte                      Creates a Blank Note on player. The note can be modified with the other commands to
                              create unique messages to give to other players. Blank Notes cannot be sold for money

/jrl TEXT                     Adds a dated entry to the Player Journal item. If the player does not have a journal,
                              it will create one and add the first entry.

/spk cmp TEXT                 Animal Companion will speak TEXT
/spk fam TEXT                 Familiar will speak TEXT
/spk sum TEXT                 First Summoned Creature will speak TEXT
/spk chm TEXT                 First Charmed Creature will speak TEXT
/spk hch TEXT                 First Henchman will speak TEXT

/fam nme NAME                 Sets the name of the player's familiar to NAME
/fam sth                      Toggles the player's familiar's stealth mode on and off
/fam det                      Toggles the player's familiar's detect mode on and off

/cmp nme NAME                 Sets the name of the player's animal companion to NAME
/cmp sth                      Toggles the player's animal companion's stealth mode on and off
/cmp det                      Toggles the player's animal companion's detect mode on and off

/sum name NAME                 Sets the name of the player's summed creature to NAME
/sum sth                      Toggles the player's summoned creature's stealth mode on and off
/sum det                      Toggles the player's summoned creature's detect mode on and off
/sum attack                   PCs summoned creature will attack their target

/dce #d2                      Rolls # of d2 dice (Ex. /dce 3d2 rolls 3 d2 dice) Max # is 9
/dce #d3                      Rolls # of d3 dice (Ex. /dce 3d3 rolls 3 d3 dice) Max # is 9
/dce #d4                      Rolls # of d4 dice (Ex. /dce 3d4 rolls 3 d4 dice) Max # is 9
/dce #d6                      Rolls # of d6 dice (Ex. /dce 3d6 rolls 3 d6 dice) Max # is 9
/dce #d8                      Rolls # of d8 dice (Ex. /dce 3d8 rolls 3 d8 dice) Max # is 9
/dce #d10                     Rolls # of d10 dice (Ex. /dce 3d10 rolls 3 d10 dice) Max # is 9
/dce #d12                     Rolls # of d12 dice (Ex. /dce 3d12 rolls 3 d12 dice) Max # is 9
/dce #d20                     Rolls # of d20 dice (Ex. /dce 3d20 rolls 3 d20 dice) Max # is 9
/dce #d100                    Rolls # of d100 dice (Ex. /dce 3d100 rolls 3 d100 dice) Max # is 9
/dce fort                     Rolls a fortitude save
/dce will                     Rolls a will save
/dce rflx                     Rolls a reflex save
/dce chr                      Rolls a charisma roll
/dce con                      Rolls a constitution roll
/dce dex                      Rolls a dexterity roll
/dce str                      Rolls a strength roll
/dce int                      Rolls a intelligence roll
/dce wis                      Rolls a wisdom roll

*Eyes are removed only by resting*
*Player must rest to clear eye effet before attempting to apply another. Otherwise,
*both effects will be active*
/eye blue                     Applys glowing blue eyes to the player
/eye green                    Applys glowing green eyes to the player
/eye orange                   Applys glowing orange eyes to the player
/eye purple                   Applys glowing purple eyes to the player
/eye flame                    Applys glowing flame eyes to the player
/eye white                    Applys glowing white eyes to the player
/eye yellow                   Applys glowing yellow eyes to the player

*The following will place a player in a sexual position with the nearest player
based on the position of that player*
/sex hlp                      Displays a list of all sexual position commands
*Person Is Standing*
/sex stand 1                  Enter from behind. (standing)
/sex stand 2                  Perform oral sex. (kneeling)
/sex stand 3                  Position yourself to be entered from behind. (bent at waist)
*Person Is Kneeling*
/sex kneel 1                  Kneel behind the person. (kneeling)
/sex kneel 2                  Position yourself for the Person to perform oral sex on you. (standing)
/sex kneel 3                  Position yourself to be entered from behind (bent low).
/sex kneel 4                  Position yourself to be entered from behind (kneeling).
*Person Is Bent Over*
/sex bent 1                   Enter from behind.
*Person Is Laying On Back*
/sex back 1                   Perform '69'.
/sex back 2                   Sit between the person's legs. (sitting)
/sex back 3                   Sit with the person's head snuggled in your lap.
/sex back 4                   (Kneeling) on the ground above the person's head.
/sex back 5                   Ride the person, facing their head. (kneeling)
/sex back 6                   Ride the person, facing away from their head. (kneeling)
/sex back 7                   Straddle the person's tummy, facing their head. (kneeling)
/sex back 8                   Sit on the person's face, facing away from their feet. (kneeling)
/sex back 9                   Sit on the person's face, facing towards their feet. (kneeling)
*Person Is Laying On Tummy*
/sex tummy 1                  Enter from behind. (sitting) (looks best without erection)
/sex tummy 2                  Enter from behind. (kneeling) (looks best without erection)
/sex tummy 3                  Straddle the person's bottom, facing towards their head. (kneeling)
/sex tummy 4                  Sit so the person is face down in you lap. (sitting) (looks best without erection)

/mad rabbit touch of death    Player commits suicide. Instant Death.
/sve                          Exports your character to either the local vault or server vault
/stp                          Stops all actions and animations
/stp buffs                    Removes all positive spell buffs from player.

*The following commands fire voice chat files*
/voc hlp                      Displays a list of all voice chat commands
/voc attack
/voc bad idea
/voc battle cry 1
/voc battle cry 2
/voc battle cry 3
/voc bored
/voc can do
/voc cant do
/voc cheer
/voc cuss
/voc death
/voc encumbered
/voc enemies
/voc flee
/voc follow me
/voc g attack 1
/voc g attack 2
/voc g attack 3
/voc goodbye
/voc good idea
/voc group
/voc guard me
/voc heal me
/voc hello
/voc help
/voc hide
/voc hold
/voc laugh
/voc look here
/voc move over
/voc near death
/voc no
/voc pain 1
/voc pain 2
/voc pain 3
/voc pick lock
/voc poisoned
/voc rest
/voc search
/voc selected
/voc spell failed
/voc stop
/voc talk to me
/voc task complete
/voc taunt
/voc thanks
/voc threaten
/voc weapon sucks
/voc yes

*Optional Erf 1 = Commands for Vaei's Additional Animations*
/csm point = Point with weapon
/csm think = Deep in thought
/csm head = Clasp head
/csm fold = Folds arms across chest
/csm jump = Jump in the air
/csm follow = Motion for others to follow
/csm alert = Get in alert crouching stance
/csm dangle = Dangle in air by hands
/csm smash = Perform smash animation
/csm sleep = Sleep on the floor
*/
///////////////////////////////////////////////////////////////////////////////
///DO NOT CHANGE ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING///
///////////////////////////////Constants///////////////////////////////////////

//Duration of the looping emotes
//Default = 7200.0 //2 hours
const float PC_COMMAND_LOOP_DUR = 7200.0;

//How long a player must wait before using another player voice command
//Set to 0.0 to allow players to use commands with no delay.
//Default = 6.0 //6 seconds or 1 round
const float PC_COMMAND_SPAM_DELAY = 6.0;

//This is the maximum length of a secondary command. Exception is /desc add and
//any other commands that require text input from player
const int PC_COMMAND_MAX_COMMAND_LENGTH = 32;

//This is the prefix of primary command scripts
const string PC_COMMAND_PRIMARY_SCRIPTS = "com_s_";

//////////////////////////////Declarations//////////////////////////////////////

//Master function for Player Chat Command program. For On Player Chat event
void MRPlayerChat();

//Master function for On Activate Item event
void MROnActivateItem();

///////////////////////////////Definition//////////////////////////////////////

void MRPlayerChat()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();

    //Determine if its one of my commands
    string sSlash = GetSubString(sMessage, 0, 1);

    //Dont fire the code if its not one of my commands.
    if (sSlash != "/") return;

    //Get the primary command
    string sPrimaryCommand = GetSubString(sMessage, 1, 3);
    //Combine it with the script prefix to create a script name.
    string sScript = PC_COMMAND_PRIMARY_SCRIPTS + sPrimaryCommand;

    //Fire the code
    ExecuteScript(sScript, oPC);
}

void MROnActivateItem()
{
    object oItem = GetItemActivated();
    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    string sTag = GetTag(oItem);

    //If its not the Item Selector, abort
    if (sTag != "pc_comm_itm_svr") return;

    //If oTarget is not a valid item, abort
    if (!GetIsObjectValid(oTarget) || GetObjectType(oTarget) != OBJECT_TYPE_ITEM) {
        SendMessageToPC(oPC, "You must target an item with the Player Command Item Selector!");
        return; }

    SetLocalObject(oPC, "PC_COMM_SVD_ITEM", oTarget);
    SendMessageToPC(oPC, "The item " + GetName(oTarget) + " has been selected");
}


