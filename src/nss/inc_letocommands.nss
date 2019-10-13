/*
Primogenitors Letoscript Commands
These assume you are running a servervault game with NWNX2 and Letoscript v18
Leto is avaliable from http://sourceforge.net/projects/leto/
NNWNX2 is avaliable from http://nwvault.ign.com/Files/other/data/1046636009723.shtml

You should also customize the constants in inc_letoscript so that they point to
your neverwinter nights directory.

There are three steps to a letoscript change
1. Bring the object into letoscript
2. Give commands
3. Bring the object back to NWN

The first step is different for PCs and for NPCs/objects.
For PCs, you can load their .bic file directly.
However, when you apply the changes, they have to be offline.
For NPCs, you can save them in the bioware database, then have leto extract
them from there.
Use the LetoWorkWithObject for both of these, but remeber to boot PCs before
running the script

The second step is to create the commands and then run them.
This is what most of the functions in this file are for. They create the script
that leto understands. The results can be simply added together to create one long
string. Once all the commands are together, they are run on the object.

Finally you have to bring the object back into NWN. For PCs the changes will apply
from whenever they rejoin the server. For NPCs you do the opposite of extraction,
i.e. put them into the database then put them into the game.

Notes:
This may make characters illegal, so it is recommended that Enforce Legal Characters is off.
*/
#include "inc_letoscript"

//general setting a variable in letoscript function
//adds it if it doesnt exist
//replaces a value if it does exist
string LetoSet(string sLocation,string sValue, string sType, int bAdd = TRUE);

//general adjusting a variable in letoscript function
//wont work with stringtypes
string LetoAdjust(string sLocation, int nValue, string sType);

//deleting a field
string LetoDelete(string sLocation);

//get a field
string LetoGet(string sLocation);

string LetoAdd(string sLocation,string sValue, string sType)
{
    return LetoSet(sLocation, sValue, sType, TRUE);
}

string LetoSet(string sLocation,string sValue, string sType, int bAdd = TRUE)
{
//phoenix
// <gff:add 'FirstName' {type='string' value=<qq:Bob the Minogon> setifexists=True}>
//unicorn
// add /FirstName, Value => qq{Bob the Minogon}, Type => gffLocString, SetIfExists => TRUE;
    if(sType != "byte"
        && sType != "word"
        && sType != "int"
        && sType != "dword"
        && sType != "char"
        && sType != "short"
        && sType != "dword64"
        && sType != "int64"
        && sType != "float"
        && sType != "double"
        && sType != "list")
    {
        if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
          sValue = "<qq:"+sValue+">";
        else
            sValue = "qq{"+sValue+"}";
        //wrap strings in quotes, so it doest go awry
        //sValue = "'"+sValue+"'";
    }
    if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
    {
        string sReturn = "<gff:";
        //if(bAdd)
            sReturn +="add";
        //else
        //    sReturn +="set";
        sReturn += "'"+sLocation+"' {type='"+sType+"' ";
        if(sType != "list")
            sReturn += "value="+sValue+" ";
        if(!bAdd)
            sReturn += " setifexists=True";
        sReturn += "}> ";
        return  sReturn;
    }
//unicorn
    else
    {
        string sReturn = "add /"+sLocation+", ";
        if(sType != "list")
            sReturn += "Value => "+sValue+", ";
        sReturn += "Type => gff"+sType;
        if(bAdd)
            sReturn += ", SetIfExists => TRUE";
        sReturn += "; ";
        return sReturn;
    }
}

string LetoAdjust(string sLocation, int nValue, string sType)
{
//phoenix
// <gff:set 'Str' {type='byte' value=(<gff:get 'Str'>+2)}>
//unicorn
// /Str = /Str+2;
    string sValue = IntToString(nValue);
    if(nValue >= 0)
        sValue = "+"+sValue;
    if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        return LetoSet(sLocation, "(<gff:get '"+sLocation+"'>"+sValue+")", sType);
//unicorn
    else
        return LetoSet(sLocation, "(/"+sLocation+sValue+")", sType);
}

//deleting a field
string LetoDelete(string sLocation)
{
//phoenix
// <gff:delete 'Str'>
//unicorn
// clear /Str;
    if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        return "<gff:delete '"+sLocation+"'> ";
    else
        return "clear /"+sLocation+"; ";

}

//deleting a field
string LetoGet(string sLocation)
{
//phoenix
// <Str>
//unicorn
// /Str;
    if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        return "<"+sLocation+">";
    else
        return "print /"+sLocation+";";

}

//Returns a script to set a name
//if bLastName is true, then its a last name
//otherwise its a first name.
//this only works with creatures
string SetCreatureName(string sName, int bLastName = FALSE);

//Returns a script to set a name
//this only works with items
string SetItemName(string sName);

//returns a script to set description
//for items this is unidentified description
//use SetIdentifiedDescription for an identified description
string SetObjectDescription(string sDescription);

//returns a script to set an identified description
//only works with items
string SetIdentifiedDescription(string sDescription);

//returns a script to set an ability score
//this is an absolute setting, so racial bonuses
//RDD bonuses, and great X I-X feats will be in addition to this
//Non-ELC compliant
string SetAbility(int nAbility, int nScore);

//returns a script to adjust an ability score
//this is relative to the current value so use negative to lower
//and positive to raise
//Non-ELC compliant
string AdjustAbility(int nAbility, int nAdjustment);

//returns a script to specify a tail on the model
//see tailmodel.2da for possible values
string SetTail(int nTailID);

//returns a script to specify wings on the model
//see wingmodel.2da for possible values
string SetWings(int nWingsID);

//returns a script to set a skill score
//this is an absolute setting, so racial bonuses
//feat bonuses, ability bonuses and armor bonuses
//will be in addition to this
//Non-ELC compliant
string SetSkill(int nSkill, int nScore, int nLevel = 1);

//returns a script to adjust a skill score
//this is relative to the current value so use negative to lower
//and positive to raise
//Non-ELC compliant
string AdjustSkill(int nSkill, int nAdjustment, int nLevel = 1);

//returns a script to set the number of spare skill points
//this is absolute and replaces any existing value
//Non-ELC compliant
string SetSpareSkill(int nScore, int nLevel = 1);

//returns a script to adjust the number of spare skill points
//Non-ELC compliant
string AdjustSpareSkill(int nScore, int nLevel = 1);

//returns a script to change race
//this does not alter appearance, feats, or special abilities
//it only changes the racial type
//this will affect racial ability score modifiers however
//Non-ELC compliant
string SetRace(int nRace);

//returns a script to change hit points
//Non-ELC compliant
string AdjustHitPoints(int nHP, int nLevel = 1);

//returns a script to change gender
string SetGender(int nGender);

//returns a script to change skin color
//the values are based on the windows in the toolset
//start at 0 in top left
string SetSkinColor(int nColor);

//returns a script to change hair color
//the values are based on the windows in the toolset
//start at 0 in top left
string SetHairColor(int nColor);

//returns a script to change tatto color
//the values are based on the windows in the toolset
//start at 0 in top left
//nTattoo determines if its tattoo 1 or 2
string SetTatooColor(int nColor, int nTattoo);

//returns a script to change movement rate
//as defined in creaturespeed.2da
//may not work if its appearance linked
//Non-ELC compliant
string SetMovement(int nRate);

//returns a script to change soundset
//as defined in soundset.2da
string SetSoundset(int nSoundsetID);

//returns a script to change portrait
//as defined in portrats.2da
//this only works with PCs and adds the po_ to the start of the string
string SetPCPortrait(string sPortrait);

//returns a script to change portrait
//as defined in portrats.2da
//this only works with NPCs and is a 2da reference
string SetNPCPortrait(int nPortraitID);

//returns a script to change the script assigned to an event
//should work with PC or NPC
//uses the EVENT_* constants
string SetScript(int nEvent, string sScript);

//returns a script to set the value of a save
//this is absolute and replaces any existing value
//Non-ELC compliant
string SetSave(int nSaveType, int nSave);

//returns a script to adjust a save score
//this is relative to the current value so use negative to lower
//and positive to raise
//Non-ELC compliant
string AdjustSave(int nSaveType, int nAdjustment);

//returns a script to add a feat
//Non-ELC compliant
string AddFeat(int nFeat, int nLevel = 1);

//returns a script to remove a feat
//Non-ELC compliant
string RemoveFeat(int nFeat);

//returns a script to add a special ability
//credit to demux
string AddSpecialAbility(int iSpell = -1, int iAmount = 1, int iLevel = 1);

//returns a script to specify AC
string SetNaturalAC(int nAC);

//returns a script to adjust AC
string AdjustNaturalAC(int nAdjustment);

//returns a script to add spell to memorized
//does not work for bard/sorcerer, use spell known instead
string AddSpellToMemorized(int nClassPos, int nSpellLevel, int nSlot, int nSpell);

//returns a script to add spell to known
//does not work for divine caster, use spell memorized instead
//also wizard NPCs dont check their spellbooks to change spells
string AddSpellToKnown(int nClassPos, int nSpellLevel, int nSpell);

//returns a script to set a domain
//this does not add/remove the feat associated with any domains
//if nDomainID is -1, the domain is deleted
string SetDomain(int nClassPos, int nDomainNo, int nDomainID);

//returns a script to set spellschool
//does not affect spells already in spellbook
//if nSchool is -1, the school is deleted
string SetSpellSchool(int nClassPos, int nSchool);

//returns a script to remove a known spell
//does not work for divine caster, use spell memorized instead
//also wizard NPCs dont check their spellbooks to change spells
string RemoveSpellFromKnown(int nClassPos, int nSpellLevel, int nSpell);


//returns a script to remove a memorized spell
//does not work for bard/sorcerer, use spell known instead
string RemoveSpellFromMemorized(int nClassPos, int nSpellLevel, int nSlot, int nSpell);

//class
//spell per day
//familiar
//animal companion
//spell redied
//spell metamagic

//constants defined
const int EVENT_SPAWN = 1007;
const int EVENT_DEATH = 1009;
const int EVENT_USER  = 1010;
const int EVENT_BLOCKED = 1012;


string SetCreatureName(string sName, int bLastName = FALSE)
{
//for creatures
//pheonix
//<gff:set 'First' <qq:Sir Brian>>
//unicorn
// /First = qq{Sir Brian};
    string sLoc;
    if(bLastName)
        sLoc = "LastName";
    else
        sLoc = "FirstName";
    return LetoSet(sLoc, sName, "locstring");
}

string SetItemName(string sName)
{
//for items
//phoenix
//<gff:set 'LocalizedName' <qq:Sir Brian>>
//unicorn
// /LocalizedName = qq{Sir Brian};
    return LetoSet("LocalizedName", sName, "locstring");
}

string SetObjectDescription(string sDescription)
{
//phoenix
//<gff:set 'Description' <qq:A mighty warrior of the realm.>>
//unicorn
// /Description = qq{A mighty warrior of the realm.};
    return LetoSet("Description" , sDescription, "locstring");
}

string SetIdentifiedDescription(string sDescription)
{
//phoenix
//<gff:set 'Description' <qq:A mighty warrior of the realm.>>
//unicorn
// /Description = qq{A mighty warrior of the realm.};
    return LetoSet("DescIdentified" , sDescription, "locstring");
}

string SetAbility(int nAbility, int nScore)
{
//phoenix
//<gff:set 'Str' 24>
//unicorn
// /Str = 24;
    string sLoc;
    switch(nAbility)
    {
        case ABILITY_STRENGTH:
            sLoc = "Str";
            break;
        case ABILITY_DEXTERITY:
            sLoc = "Dex";
            break;
        case ABILITY_CONSTITUTION:
            sLoc = "Con";
            break;
        case ABILITY_INTELLIGENCE:
            sLoc = "Int";
            break;
        case ABILITY_WISDOM:
            sLoc = "Wis";
            break;
        case ABILITY_CHARISMA:
            sLoc = "Cha";
            break;
    }
    return LetoSet(sLoc, IntToString(nScore), "byte");
}

string AdjustAbility(int nAbility, int nAdjustment)
{
//phoenix
//<gff:set 'Str' (<gff:get 'Str'>+2)>
//unicorn
// /Str = /Str+2;
    string sAbility;
    switch(nAbility)
    {
        case ABILITY_STRENGTH:
            sAbility= "Str";
            break;
        case ABILITY_DEXTERITY:
            sAbility= "Dex";
            break;
        case ABILITY_CONSTITUTION:
            sAbility= "Con";
            break;
        case ABILITY_INTELLIGENCE:
            sAbility= "Int";
            break;
        case ABILITY_WISDOM:
            sAbility= "Wis";
            break;
        case ABILITY_CHARISMA:
            sAbility= "Cha";
            break;
    }
    return LetoAdjust(sAbility, nAdjustment, "byte");
}

string SetTail(int nTailID)
{
//pheonix
//<gff:add 'Tail' {value=2 setifexists=True}>
//unicorn
// /Tail = 2;
    return LetoSet("Tail", IntToString(nTailID), "byte");
}

string SetWings(int nWingsID)
{
//pheonix
//<gff:add 'Wings' {value=2 setifexists=True}>
//unicorn
// /Wings = 2;
    return LetoSet("Wings", IntToString(nWingsID), "byte");
}

string AdjustSkill(int nSkill, int nAdjustment, int nLevel = 1)
{
//<gff:add 'SkillList/[3]/Rank' {value=<gff:get 'SkillList/[3]/Rank'>+5 setifexists=True}>
//<gff:add 'LvlStatList/[0]/SkillList/[3]/Rank' {value=<gff:get 'LvlStatList/[0]/SkillList/[3]/Rank'>+5 setifexists=True}>
    string sReturn;
    sReturn += LetoAdjust("SkillList/["+IntToString(nSkill)+"]/Rank", nAdjustment, "byte");
    sReturn += LetoAdjust("LvlStatList/["+IntToString(nLevel-1)+"]/SkillList/["+IntToString(nSkill)+"]/Rank", nAdjustment, "byte");
    return sReturn;
}

string SetSkill(int nSkill, int nScore, int nLevel = 1)
{
//<gff:add 'SkillList/[3]/Rank' {value=5 setifexists=True}>
//<gff:add 'LvlStatList/[0]/SkillList/[3]/Rank' {value=5 setifexists=True}>
    string sReturn;
    sReturn += LetoSet("SkillList/["+IntToString(nSkill)+"]/Rank", IntToString(nScore), "byte");
    sReturn += LetoSet("LvlStatList/["+IntToString(nLevel-1)+"]/SkillList/["+IntToString(nSkill)+"]/Rank", IntToString(nScore), "byte");
    return sReturn;
}

string SetSpareSkill(int nScore, int nLevel = 1)
{
//<gff:set 'SkillPoints' 5>
//<gff:set 'LvlStatList/[0]/SkillPoints' 5>
    string sReturn;
    sReturn += LetoSet("SkillPoints", IntToString(nScore), "byte");
    sReturn += LetoSet("LvlStatList/["+IntToString(nLevel-1)+"]/SkillPoints", IntToString(nScore), "byte");
    return sReturn;
}

string AdjustSpareSkill(int nScore, int nLevel = 1)
{
//<gff:set 'SkillPoints' (<gff:get 'SkillPoints'>+5)>
//<gff:set 'LvlStatList/[0]/SkillPoints' (<gff:get 'LvlStatList/[0]/SkillPoints'>+5)>
    string sReturn;
    sReturn += LetoAdjust("SkillPoints", nScore, "word");
    sReturn += LetoAdjust("LvlStatList/["+IntToString(nLevel-1)+"]/SkillPoints", nScore, "word");
    return sReturn;
}

string SetRace(int nRace)
{
//pheonix
//<gff:add 'Race' {value=2 setifexists=True}>
//unicorn
// /Race = 2;
    return LetoSet("Race", IntToString(nRace), "byte");
}

string AdjustHitPoints(int nHP, int nLevel = 1)
{
//<gff:set 'HitPoints' (<HitPoints>+5)>
//<gff:set 'LvlStatList/[0]/LvlStatHitDie' (<LvlStatList/[0]/LvlStatHitDie>+5)>
//<gff:set 'MaxHitPoints' (<MaxHitPoints>+5)>
//<gff:set 'CurrentHitPoints' (<CurrentHitPoints>+5)>
//<gff:set 'PregameCurrent' (<PregameCurrent>+5)>
    string sReturn;
    sReturn += LetoAdjust("HitPoints", nHP, "short");
    sReturn += LetoAdjust("LvlStatList/["+IntToString(nLevel-1)+"]/LvlStatHitDie", nHP, "short");
    sReturn += LetoAdjust("MaxHitPoints", nHP, "short");
    sReturn += LetoAdjust("CurrentHitPoints", nHP, "short");
    sReturn += LetoAdjust("PregameCurrent", nHP, "short");
    return sReturn;
}

string SetGender(int nGender)
{
//pheonix
//<gff:add 'Gender' {value=2 setifexists=True}>
//unicorn
// /Gender = 2;
    return LetoSet("Gender", IntToString(nGender), "byte");
}

string SetSkinColor(int nColor)
{
//pheonix
//<gff:add 'Color_Skin' {value=2 setifexists=True}>
//unicorn
// /Color_Skin = 2;
    return LetoSet("Color_Skin", IntToString(nColor), "byte");
}

string SetHairColor(int nColor)
{
//pheonix
//<gff:add 'Color_Hair' {value=2 setifexists=True}>
//unicorn
// /Color_Hair = 2;
    return LetoSet("Color_Hair", IntToString(nColor), "byte");
}

string SetTatooColor(int nColor, int nTattoo)
{
//pheonix
//<gff:add 'Color_Tattoo1' {value=2 setifexists=True}>
//unicorn
// /Color_Tattoo1 = 2;
    return LetoSet("Color_Tattoo"+IntToString(nTattoo), IntToString(nColor), "byte");
}

string SetMovement(int nRate)
{
//pheonix
//<gff:add 'MovementRate' {value=2 setifexists=True}>
//unicorn
// /MovementRate = 2;
    return LetoSet("MovementRate", IntToString(nRate), "byte");
}

string SetSoundset(int nSoundsetID)
{
//pheonix
//<gff:add 'SoundSetFile' {value=2 setifexists=True}>
//unicorn
// /SoundSetFile = 2;
    return LetoSet("SoundSetFile", IntToString(nSoundsetID), "word");
}

string SetPCPortrait(string sPortrait)
{
//pheonix
//<gff:add 'Portrait' {value='dw_f_01_' setifexists=True}>
//unicorn
// /Portriat = 'dw_f_01_';
    return LetoSet("Portrait", "po_"+sPortrait, "resref");
}

string SetNPCPortrait(int nPortraitID)
{
//pheonix
//<gff:add 'PortraitId' {value='23' setifexists=True}>
//unicorn
// /PortraitId = 23;
    return LetoSet("PortraitId", IntToString(nPortraitID), "word");
}

string SetScript(int nEvent, string sScript)
{
//pheonix
//<gff:add 'ScriptAttacked' {type='resref' value='eras3' setifexists=True}>
//unicorn
// /ScriptAttacked = 'eras3';
    string sEvent = "Script";
    switch(nEvent)
    {
        case EVENT_ATTACKED:
            sEvent += "Attacked";
            break;
        case EVENT_DAMAGED:
            sEvent += "Damaged";
            break;
        case EVENT_DEATH:
            sEvent += "Death";
            break;
        case EVENT_DIALOGUE:
            sEvent += "Dialogue";
            break;
        case EVENT_DISTURBED:
            sEvent += "Disurbed";
            break;
        case EVENT_END_COMBAT_ROUND:
            sEvent += "EndRound";
            break;
        case EVENT_HEARTBEAT:
            sEvent += "Heartbeat";
            break;
        case EVENT_PERCEIVE:
            sEvent += "OnNotice";
            break;
        case EVENT_SPAWN:
            sEvent += "Spawn";
            break;
        case EVENT_SPELL_CAST_AT:
            sEvent += "SpellAt";
            break;
        case EVENT_USER:
            sEvent += "UserDefined";
            break;
        case EVENT_BLOCKED:
            sEvent += "OnBlocked";
            break;
    }
    return LetoSet(sEvent, sScript, "resref");
}

string SetSave(int nSaveType, int nSave)
{
//pheonix
//<gff:add 'willbonus' {type='byte' value='32' setifexists=True}>
//unicorn
// /willbonus = 32;
    string sSaveType;
    switch(nSaveType)
    {
        case SAVING_THROW_FORT:
            sSaveType += "fort";
            break;
        case SAVING_THROW_REFLEX:
            sSaveType += "reflex";
            break;
        case SAVING_THROW_WILL:
            sSaveType += "will";
            break;
    }
    sSaveType += "bonus' ";
    return LetoSet(sSaveType, IntToString(nSave), "byte");
}

string AdjustSave(int nSaveType, int nAdjustment)
{
//<gff:set 'willbonus' (<gff:get 'willbonus'>+2)>
    string sSaveType;
    switch(nSaveType)
    {
        case SAVING_THROW_FORT:
            sSaveType += "fort";
            break;
        case SAVING_THROW_REFLEX:
            sSaveType += "reflex";
            break;
        case SAVING_THROW_WILL:
            sSaveType += "will";
            break;
    }
    sSaveType += "bonus' ";
    return LetoAdjust(sSaveType, nAdjustment, "byte");
}

string SetNaturalAC(int nAC)
{
//pheonix
//<gff:add 'NaturalAC' {value='23' setifexists=True}>
//unicorn
// /NaturalAC = 23;
//this wont work for players
    return LetoSet("NaturalAC", IntToString(nAC), "byte");
}

string AdjustNaturalAC(int nAdjustment)
{
//<gff:set 'NaturalAC' <gff:get 'NaturalA'>+2>
//this wont work for players
    return LetoAdjust("NaturalAC", nAdjustment, "byte");
}

string SetDomain(int nClassPos, int nDomainNo, int nDomainID)
{
//<gff:add 'ClassList/[0]/Domain1'  {type='byte' value='2' setifexists=True}>
//this doesnt alter the matching feats
    return LetoSet("ClassList/["+IntToString(nClassPos-1)+"]/Domain"+IntToString(nDomainID), IntToString(nDomainNo), "byte");
}

string SetSpellSchool(int nClassPos, int nSchool)
{
//<gff:add 'ClassList/[0]/School'  {type='byte' value='2' setifexists=True}>
    return LetoSet("ClassList/["+IntToString(nClassPos-1)+"]/School", IntToString(nSchool), "byte");
}

//THESE FUNCTIONS BELOW DO NOT WORK WITH UNICORN SYNTAX YET

string AddSpellToMemorized(int nClassPos, int nSpellLevel, int nSlot, int nSpell)
{
//<gff:add 'ClassList/[0]/MemorizedList3/[3]/Spell'          {type='word' value='251' setifexists=True}>
//<gff:add 'ClassList/[0]/MemorizedList3/[3]/SpellFlags'     {type='byte' value='0'   setifexists=True}>
//<gff:add 'ClassList/[0]/MemorizedList3/[3]/Ready'          {type='byte' value='0'   setifexists=True}>
//<gff:add 'ClassList/[0]/MemorizedList3/[3]/SpellMetaMagic' {type='byte' value='0'   setifexists=True}>

    string sScript = LetoAdd("ClassList/["+IntToString(nClassPos)+"]/MemorizedList"+IntToString(nSpellLevel)+"/["+IntToString(nSlot)+"]/Spell", IntToString(nSpell), "word");
    sScript       += LetoAdd("ClassList/["+IntToString(nClassPos)+"]/MemorizedList"+IntToString(nSpellLevel)+"/["+IntToString(nSlot)+"]/SpellFlags", IntToString(1), "byte");
    sScript       += LetoAdd("ClassList/["+IntToString(nClassPos)+"]/MemorizedList"+IntToString(nSpellLevel)+"/["+IntToString(nSlot)+"]/Ready", IntToString(1), "byte");
    sScript       += LetoAdd("ClassList/["+IntToString(nClassPos)+"]/MemorizedList"+IntToString(nSpellLevel)+"/["+IntToString(nSlot)+"]/SpellMetaMagic", IntToString(0), "byte");
    return sScript;
}

string AddSpellToKnown(int nClassPos, int nSpellLevel, int nSpell)
{
//<gff:add 'ClassList/[0]/KnownList3/[_]/Spell'          {type='word' value='251' setifexists=True}>
//<gff:add 'ClassList/[0]/KnownList3/[_]/SpellFlags'     {type='byte' value='0'   setifexists=True}>
//<gff:add 'ClassList/[0]/KnownList3/[_]/Ready'          {type='byte' value='0'   setifexists=True}>
//<gff:add 'ClassList/[0]/KnownList3/[_]/SpellMetaMagic' {type='byte' value='0'   setifexists=True}>

    string sScript = LetoAdd("ClassList/["+IntToString(nClassPos)+"]/KnownList"+IntToString(nSpellLevel)+"/Spell", IntToString(nSpell), "word");
    return sScript;
}

//THESE FUNCTIONS BELOW DO NOT WORK WITH UNICORN SYNTAX YET

string RemoveSpellFromMemorized(int nClassPos, int nSpellLevel, int nSlot, int nSpell)
{
//<gff:delete 'ClassList/[0]/MemorizedList3/[3]/Spell'>
//<gff:delete 'ClassList/[0]/MemorizedList3/[3]/SpellFlags'>
//<gff:delete 'ClassList/[0]/MemorizedList3/[3]/Ready'>
//<gff:delete 'ClassList/[0]/MemorizedList3/[3]/SpellMetaMagic'>
    string sScript = "<gff:delete 'ClassList/["+IntToString(nClassPos)+"]/MemorizedList"+IntToString(nSpellLevel)+"/["+IntToString(nSlot)+"]/Spell'>";
    sScript +=       "<gff:delete 'ClassList/["+IntToString(nClassPos)+"]/MemorizedList"+IntToString(nSpellLevel)+"/["+IntToString(nSlot)+"]/SpellFlags'>";
    sScript +=       "<gff:delete 'ClassList/["+IntToString(nClassPos)+"]/MemorizedList"+IntToString(nSpellLevel)+"/["+IntToString(nSlot)+"]/Ready'>";
    sScript +=       "<gff:delete 'ClassList/["+IntToString(nClassPos)+"]/MemorizedList"+IntToString(nSpellLevel)+"/["+IntToString(nSlot)+"]/SpellMetaMagic'>";
    return sScript;
}

string AddFeat(int nFeat, int nLevel = 1)
{
//<gff:add 'FeatList/Feat' 3>
//<gff:add 'LvlStatList/[0]/FeatList/Feat' 3>
    string sReturn = "<gff:add 'Featlist/Feat' ";
    sReturn += IntToString(nFeat)+ ">";
    sReturn += "<gff:add 'LvlStatList/["+IntToString(nLevel-1)+"]/Featlist/Feat' ";
    sReturn += IntToString(nFeat)+ ">";
    return sReturn;
}

string RemoveSpellFromKnown(int nClassPos, int nSpellLevel, int nSpell)
{
//<gff:replace {name='ClassList/[1]/KnownList2' value=25 DeleteParent}>
    string sScript = "<gff:replace {name='ClassList/["+IntToString(nClassPos)+"]/KnownList"+IntToString(nSpellLevel)+"' value=25 DeleteParent}>";
    return sScript;
}

string RemoveFeat(int nFeat)
{
//<gff:replace {name='Feat' value=25 DeleteParent}>
    string sReturn = "<gff:replace {name='Feat' value="+IntToString(nFeat);
    sReturn += " DeleteParent=true}>";
    return sReturn;
}

//credit to demux
string AddSpecialAbility(int iSpell = -1, int iAmount = 1, int iLevel = 1)
{
//<gff:add 'SpecAbilityList' {type='list'}>
//"<gff:add 'SpecAbilityList/Spell' {type='word' value=5}>";
//"<gff:add 'SpecAbilityList/[_]/SpellFlags' {type='byte' value=1}>";
//"<gff:add 'SpecAbilityList/[_]/SpellCasterLevel' {type='byte' value=3}>";

    if(iSpell < 0 || iLevel < 0 || iAmount < 1) return "";

    string script = "";
    int i;
    string sSpell = IntToString(iSpell);
    string sAmount = IntToString(iAmount);
    string sLevel = IntToString(iLevel);

    PrintString("Adding spell... Name: "+sSpell+" | Amount: "+sAmount+" | Level: "+sLevel);
    for(i=0; i < iAmount; i++) {
        script +=
            "<gff:add 'SpecAbilityList' {type='list'}>"+
            "<gff:add 'SpecAbilityList/Spell' {type='word' value="+sSpell+"}>"+
            "<gff:add 'SpecAbilityList/[_]/SpellFlags' {type='byte' value=1}>"+
            "<gff:add 'SpecAbilityList/[_]/SpellCasterLevel' {type='byte' value="+sLevel+"}>";
    }

    return script;
}

