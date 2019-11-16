#include "zdlg_include_i"
#include "seed_faction_inc"

const string CCINPC_LIST = "CCINPC_LIST"; // Class Changes Info NPC
const string CCINPC_CURRENT_PAGE = "CCINPC_CURRENT_PAGE";

const int CCINPC_PAGE_MAIN_MENU             = 10;
const int CCINPC_PAGE_CLASSES               = 11;
const int CCINPC_PAGE_SPELLS                = 12;
//const int CCINPC_PAGE_SKILLS                = 13;
//const int CCINPC_PAGE_FEATS                 = 14;
const int CCINPC_SHOW_MESSAGE               = 15;

const int CCINPC_PAGE_ARCANEARCHER          = 100;
const int CCINPC_PAGE_ASSASSIN              = 101;
const int CCINPC_PAGE_BARBARIAN             = 102;
const int CCINPC_PAGE_BARD                  = 103;
const int CCINPC_PAGE_BLACKGUARD            = 104;
const int CCINPC_PAGE_CHAMPIONOFTORM        = 105;
const int CCINPC_PAGE_CLERIC                = 106;
const int CCINPC_PAGE_DRUID                 = 107;
const int CCINPC_PAGE_DWARFENDEFENDER       = 108;
const int CCINPC_PAGE_FIGHTER               = 109;
const int CCINPC_PAGE_HARPERSCOUT           = 110;
const int CCINPC_PAGE_MONK                  = 111;
const int CCINPC_PAGE_PALADIN               = 112;
const int CCINPC_PAGE_PALEMASTER            = 113;
const int CCINPC_PAGE_PURPLEDRAGONKNIGHT    = 114;
const int CCINPC_PAGE_RANGER                = 115;
const int CCINPC_PAGE_REDDRAGONDISCIPLE     = 116;
const int CCINPC_PAGE_ROGUE                 = 117;
const int CCINPC_PAGE_SHADOWDANCER          = 118;
const int CCINPC_PAGE_SHIFTER               = 119;
const int CCINPC_PAGE_SORCERER              = 120;
const int CCINPC_PAGE_WEAPONMASTER          = 121;
const int CCINPC_PAGE_WIZARD                = 122;

const int CCINPC_PAGE_ABJURATION            = 201;
const int CCINPC_PAGE_CONJURATION           = 202;
const int CCINPC_PAGE_DIVINATION            = 203;
const int CCINPC_PAGE_ENCHANTMENT           = 204;
const int CCINPC_PAGE_EVOCATION             = 205;
const int CCINPC_PAGE_ILLUSION              = 206;
const int CCINPC_PAGE_NECROMANCY            = 207;
const int CCINPC_PAGE_TRANSMUTATION         = 208;
const int CCINPC_PAGE_EPICSPELLS            = 209;

const int CCINPC_PAGE_USEMAGICALDEVICE      = 301;
const int CCINPC_PAGE_DETECTSTEALTH         = 302;
const int CCINPC_PAGE_PICKPOCKET            = 303;
const int CCINPC_PAGE_DISPELBREACH          = 304;
const int CCINPC_PAGE_DUAL2HANDED           = 305;
const int CCINPC_PAGE_DISARM                = 306;
const int CCINPC_BOOK_ITEMS                 = 307;
const int CCINPC_BOOK_TRAPS                 = 308;
const int CCINPC_BOOK_PURECLASS             = 309;
const int CCINPC_BOOK_THEFORT               = 310;


void SetMenuOptionInt(string sOptionText, int iOptionValue, object oPC, string sList = CCINPC_LIST);
void SetMenuOptionString(string sOptionText, string sOptionValue, object oPC, string sList = CCINPC_LIST);
void SetMenuOptionObject(string sOptionText, object oOptionValue, object oPC, string sList = CCINPC_LIST);
string JapSendMessage(object oPC, object oMember, string sPCName, string sPCLogin, string sListPlayer, string sFAIDMember, int nLvlMember, int nLvlPC, int nSendMessage = FALSE);

void SetMenuOptionInt(string sOptionText, int iOptionValue, object oPC, string sList = CCINPC_LIST) {
    ReplaceIntElement(AddStringElement(GetRGB(15,12,7) + sOptionText, CCINPC_LIST, oPC)-1, iOptionValue  , sList, oPC);
}
void SetMenuOptionString(string sOptionText, string sOptionValue, object oPC, string sList = CCINPC_LIST) {
    ReplaceStringElement(AddStringElement(GetRGB(15,12,7) + sOptionText, CCINPC_LIST, oPC)-1, sOptionValue  , sList, oPC);
}
void SetMenuOptionObject(string sOptionText, object oOptionValue, object oPC, string sList = CCINPC_LIST){
    ReplaceObjectElement(AddStringElement(GetRGB(15,12,7) + sOptionText, CCINPC_LIST, oPC)-1, oOptionValue  , sList, oPC);
}

int GetNextPage(){
    return GetLocalInt(GetPcDlgSpeaker(), CCINPC_CURRENT_PAGE);
}

void SetNextPage(int nPage){
    SetLocalInt(GetPcDlgSpeaker(), CCINPC_CURRENT_PAGE, nPage);
}

int GetPageOptionSelected(string sLIST = CCINPC_LIST){
    return GetIntElement(GetDlgSelection(), sLIST, GetPcDlgSpeaker());
}

string DisabledText(string sText) {
   return GetRGBColor(CLR_GRAY) + sText;
}

void HandleSelection(object oPC){
    string sFAIDMember;
    string sListPlayer = "";
    int nLvlMember;
    int nSendMessage = TRUE;
    int nCount = 0;
    object oMember, oItem;
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    string sPCName = GetName(oPC);
    string sPCLogin = GetPCPlayerName(oPC);
    int nLvlPC = GetHitDice(oPC);
    int iOptionSelected = GetPageOptionSelected(); // RETURN THE KEY VALUE ASSOCIATED WITH THE SELECTION

    switch (iOptionSelected) {
    case CCINPC_PAGE_MAIN_MENU:
    case CCINPC_PAGE_CLASSES:
    case CCINPC_PAGE_SPELLS:
        SetNextPage(iOptionSelected);
        return;
////////////////////////////////////////////////////////////////////////////////
// CLASSES
////////////////////////////////////////////////////////////////////////////////
    case CCINPC_PAGE_ARCANEARCHER:
        return;
    case CCINPC_PAGE_ASSASSIN:
        oItem = GetObjectByTag("CCINPC_BOOK_ASSASSIN");
        AssignCommand(oPC, ActionExamine(oItem));
        SetNextPage(iOptionSelected);
        return;
    case CCINPC_PAGE_BARBARIAN:
        oItem = GetObjectByTag("CCINPC_BOOK_BARBARIAN");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_BARD:
        oItem = GetObjectByTag("CCINPC_BOOK_BARD");
        AssignCommand(oPC, ActionExamine(oItem));
        SetNextPage(iOptionSelected);
        return;
    case CCINPC_PAGE_BLACKGUARD:
        oItem = GetObjectByTag("CCINPC_BOOK_BLACKGUARD");
        AssignCommand(oPC, ActionExamine(oItem));
        SetNextPage(iOptionSelected);
        return;
    case CCINPC_PAGE_CHAMPIONOFTORM:
        oItem = GetObjectByTag("CCINPC_BOOK_CHAMPIONOFTORM");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_DRUID:
        oItem = GetObjectByTag("CCINPC_BOOK_DRUID");
        AssignCommand(oPC, ActionExamine(oItem));
        SetNextPage(iOptionSelected);
        return;
    case CCINPC_PAGE_DWARFENDEFENDER:
        oItem = GetObjectByTag("CCINPC_BOOK_DWARFENDEFENDER");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_FIGHTER:
        oItem = GetObjectByTag("CCINPC_BOOK_FIGHTER");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_HARPERSCOUT:
        oItem = GetObjectByTag("CCINPC_BOOK_HARPER");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_MONK:
        SetNextPage(iOptionSelected);
        return;
    case CCINPC_PAGE_CLERIC:
    case CCINPC_PAGE_PALADIN:
        SetNextPage(iOptionSelected);
        return;
    case CCINPC_PAGE_PALEMASTER:
        oItem = GetObjectByTag("CCINPC_BOOK_PALEMASTER");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_PURPLEDRAGONKNIGHT:
        return;
    case CCINPC_PAGE_RANGER:
        oItem = GetObjectByTag("CCINPC_BOOK_RANGER");
        AssignCommand(oPC, ActionExamine(oItem));
        SetNextPage(iOptionSelected);
        return;
    case CCINPC_PAGE_REDDRAGONDISCIPLE:
    case CCINPC_PAGE_ROGUE:
    case CCINPC_PAGE_SHADOWDANCER:
    case CCINPC_PAGE_SHIFTER:
        oItem = GetObjectByTag("CCINPC_BOOK_SHIFTER");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_SORCERER:
    case CCINPC_PAGE_WIZARD:
    case CCINPC_PAGE_WEAPONMASTER:
        oItem = GetObjectByTag("CCINPC_BOOK_WEAPONMASTER");
        AssignCommand(oPC, ActionExamine(oItem));
        //SetNextPage(iOptionSelected);
        return;
////////////////////////////////////////////////////////////////////////////////
// SPELLS
////////////////////////////////////////////////////////////////////////////////
    case CCINPC_PAGE_ABJURATION:
        oItem = GetObjectByTag("CCINPC_BOOK_ABJURATION");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_CONJURATION:
        oItem = GetObjectByTag("CCINPC_BOOK_CONJURATION");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_DIVINATION:
        return;
    case CCINPC_PAGE_ENCHANTMENT:
        oItem = GetObjectByTag("CCINPC_BOOK_ENCHANTMENT");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_EVOCATION:
        oItem = GetObjectByTag("CCINPC_BOOK_EVOCATION");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_ILLUSION:
        oItem = GetObjectByTag("CCINPC_BOOK_ILLUSION");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_NECROMANCY:
        oItem = GetObjectByTag("CCINPC_BOOK_NECROMANCY");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_TRANSMUTATION:
        oItem = GetObjectByTag("CCINPC_BOOK_TRANSMUTATION");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_EPICSPELLS:
        oItem = GetObjectByTag("CCINPC_BOOK_EPICSPELLS");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
////////////////////////////////////////////////////////////////////////////////
// GENERAL
////////////////////////////////////////////////////////////////////////////////
    case CCINPC_PAGE_USEMAGICALDEVICE:
        oItem = GetObjectByTag("CCINPC_BOOK_USEMAGICALDEVICE");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_DETECTSTEALTH:
    case CCINPC_PAGE_PICKPOCKET:
        return;
    case CCINPC_PAGE_DISPELBREACH:
        oItem = GetObjectByTag("CCINPC_BOOK_DISPELBREACH");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_DUAL2HANDED:
        oItem = GetObjectByTag("CCINPC_BOOK_DUAL2HANDED");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_PAGE_DISARM:
        oItem = GetObjectByTag("CCINPC_BOOK_DISARM");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_BOOK_ITEMS:
        oItem = GetObjectByTag("CCINPC_BOOK_ITEMS");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_BOOK_TRAPS:
        oItem = GetObjectByTag("CCINPC_BOOK_TRAPS");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_BOOK_PURECLASS:
        oItem = GetObjectByTag("CCINPC_BOOK_PURECLASS");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
    case CCINPC_BOOK_THEFORT:
        oItem = GetObjectByTag("CCINPC_BOOK_THEFORT");
        AssignCommand(oPC, ActionExamine(oItem));
        return;
////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////
    }
}

void BuildPage(int nPage, object oPC){
    string sMsg = "";
    DeleteList(CCINPC_LIST, oPC); // START FRESH PAGE
    switch (nPage){
    case CCINPC_PAGE_MAIN_MENU:
        SetMenuOptionInt("Classes :: All Classes", CCINPC_PAGE_CLASSES, oPC);
        SetMenuOptionInt("Spells :: Spell Schools", CCINPC_PAGE_SPELLS, oPC);
        SetMenuOptionInt("General :: Use Magical Device", CCINPC_PAGE_USEMAGICALDEVICE, oPC);
        SetMenuOptionInt(DisabledText("General :: Detect / Stealth"), CCINPC_PAGE_DETECTSTEALTH, oPC);
        SetMenuOptionInt(DisabledText("General :: Pickpocket"), CCINPC_PAGE_PICKPOCKET, oPC);
        SetMenuOptionInt("General :: Dispel / Breach", CCINPC_PAGE_DISPELBREACH, oPC);
        SetMenuOptionInt("General :: Dualwield / 2 Handed Weapon", CCINPC_PAGE_DUAL2HANDED, oPC);
        SetMenuOptionInt("General :: Disarm", CCINPC_PAGE_DISARM, oPC);
        SetMenuOptionInt("General :: Epic Items", CCINPC_BOOK_ITEMS, oPC);
        SetMenuOptionInt("General :: Traps", CCINPC_BOOK_TRAPS, oPC);
        SetMenuOptionInt("General :: Pure Casters", CCINPC_BOOK_PURECLASS, oPC);
        SetMenuOptionInt("General :: The Fort", CCINPC_BOOK_THEFORT, oPC);
        return;
    case CCINPC_PAGE_CLASSES:
        //SetMenuOptionInt(DisabledText("Class :: Arcane Archer"), CCINPC_PAGE_ARCANEARCHER, oPC);
        SetMenuOptionInt("Class :: Assassin", CCINPC_PAGE_ASSASSIN, oPC);
        SetMenuOptionInt("Class :: Barbarian", CCINPC_PAGE_BARBARIAN, oPC);
        SetMenuOptionInt("Class :: Bard", CCINPC_PAGE_BARD, oPC);
        SetMenuOptionInt("Class :: Blackguard", CCINPC_PAGE_BLACKGUARD, oPC);
        SetMenuOptionInt("Class :: Champion of Torm", CCINPC_PAGE_CHAMPIONOFTORM, oPC);
        SetMenuOptionInt("Class :: Cleric", CCINPC_PAGE_CLERIC, oPC);
        SetMenuOptionInt("Class :: Paladin", CCINPC_PAGE_PALADIN, oPC);
        SetMenuOptionInt("Class :: Druid", CCINPC_PAGE_DRUID, oPC);
        SetMenuOptionInt("Class :: Dwarven Defender", CCINPC_PAGE_DWARFENDEFENDER, oPC);
        SetMenuOptionInt("Class :: Fighter", CCINPC_PAGE_FIGHTER, oPC);
        SetMenuOptionInt("Class :: Harper Scout", CCINPC_PAGE_HARPERSCOUT, oPC);
        SetMenuOptionInt("Class :: Monk", CCINPC_PAGE_MONK, oPC);
        SetMenuOptionInt("Class :: Palemaster", CCINPC_PAGE_PALEMASTER, oPC);
        //SetMenuOptionInt(DisabledText("Class :: Purple Dragon Knight"), CCINPC_PAGE_PURPLEDRAGONKNIGHT, oPC);
        SetMenuOptionInt("Class :: Ranger", CCINPC_PAGE_RANGER, oPC);
        //SetMenuOptionInt(DisabledText("Class :: Red Dragon Disciple"), CCINPC_PAGE_REDDRAGONDISCIPLE, oPC);
        //SetMenuOptionInt(DisabledText("Class :: Rogue"), CCINPC_PAGE_ROGUE, oPC);
        SetMenuOptionInt(DisabledText("Class :: Shadow Dancer"), CCINPC_PAGE_SHADOWDANCER, oPC);
        SetMenuOptionInt("Class :: Shifter", CCINPC_PAGE_SHIFTER, oPC);
        SetMenuOptionInt(DisabledText("Class :: Sorcerer / Wizard"), CCINPC_PAGE_SORCERER, oPC);
        //SetMenuOptionInt(DisabledText("Class :: Wizard"), CCINPC_PAGE_WIZARD, oPC);
        SetMenuOptionInt("Class :: Weapon Master", CCINPC_PAGE_WEAPONMASTER, oPC);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_SPELLS:
        SetMenuOptionInt("Spells :: Abjuration", CCINPC_PAGE_ABJURATION, oPC);
        SetMenuOptionInt("Spells :: Conjuration", CCINPC_PAGE_CONJURATION, oPC);
        SetMenuOptionInt(DisabledText("Spells :: Divination"), CCINPC_PAGE_DIVINATION, oPC);
        SetMenuOptionInt("Spells :: Enchantment", CCINPC_PAGE_ENCHANTMENT, oPC);
        SetMenuOptionInt("Spells :: Evocation", CCINPC_PAGE_EVOCATION, oPC);
        SetMenuOptionInt("Spells :: Illusion", CCINPC_PAGE_ILLUSION, oPC);
        SetMenuOptionInt("Spells :: Necromancy", CCINPC_PAGE_NECROMANCY, oPC);
        SetMenuOptionInt("Spells :: Transmutation", CCINPC_PAGE_TRANSMUTATION, oPC);
        SetMenuOptionInt("Spells :: Epic Spells", CCINPC_PAGE_EPICSPELLS, oPC);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_BARD:
        SetMenuOptionInt("Class :: Bard", CCINPC_PAGE_BARD, oPC);
        SetMenuOptionInt("Spells :: Enchantment (Balagarn's Iron Horn)", CCINPC_PAGE_ENCHANTMENT, oPC);
        SetMenuOptionInt("Spells :: Evocation (Dirge)", CCINPC_PAGE_EVOCATION, oPC);
        SetMenuOptionInt("General :: Dispel / Breach", CCINPC_PAGE_DISPELBREACH, oPC);
        SetMenuOptionInt("General :: Use Magical Device", CCINPC_PAGE_USEMAGICALDEVICE, oPC);
        SetMenuOptionInt("General :: Epic Items (Vaasa Minstrel Shield)", CCINPC_BOOK_ITEMS, oPC);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_RANGER:
        SetMenuOptionInt("Class :: Ranger", CCINPC_PAGE_RANGER, oPC);
        SetMenuOptionInt("Spells :: Transmutation (Bladethirst)", CCINPC_PAGE_TRANSMUTATION, oPC);
        SetMenuOptionInt("General :: Dualwield / 2 Handed Weapon", CCINPC_PAGE_DUAL2HANDED, oPC);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_PALADIN:
        SetMenuOptionInt("Spells :: Evocation (Divine Favor, Holy Sword)", CCINPC_PAGE_EVOCATION, oPC);
        SetMenuOptionInt("Spells :: Transmutation (Deafening Clang)", CCINPC_PAGE_TRANSMUTATION, oPC);
        SetMenuOptionInt("General :: Epic Items (Virtuousness Helm)", CCINPC_BOOK_ITEMS, oPC);
        return;
    case CCINPC_PAGE_CLERIC:
        SetMenuOptionInt("Spells :: Necromancy (Harm)", CCINPC_PAGE_NECROMANCY, oPC);
        SetMenuOptionInt("Spells :: Evocation (Divine Favor)", CCINPC_PAGE_EVOCATION, oPC);
        SetMenuOptionInt("Spells :: Conjuration (Heal, Gate, Summon creature)", CCINPC_PAGE_CONJURATION, oPC);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_PALEMASTER:
        SetMenuOptionInt("Spells :: Epic Spells (Epic Warding)", CCINPC_PAGE_EPICSPELLS, oPC);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_ASSASSIN:
        SetMenuOptionInt("Class :: Assassin", CCINPC_PAGE_ASSASSIN, oPC);
        SetMenuOptionInt("General :: Epic Items (Poison)", CCINPC_BOOK_ITEMS, oPC);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_MONK:
        SetMenuOptionInt("General :: Epic Items (Fist of Nibelungen)", CCINPC_BOOK_ITEMS, oPC);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_BLACKGUARD:
        SetMenuOptionInt("Class :: Blackguard", CCINPC_PAGE_BLACKGUARD, oPC);
        SetMenuOptionInt("General :: Epic Items (Poison)", CCINPC_BOOK_ITEMS, oPC);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_CHAMPIONOFTORM:
        SetMenuOptionInt("Class ability :: Divine Wrath", CCINPC_PAGE_CHAMPIONOFTORM, oPC);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_WEAPONMASTER:
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    case CCINPC_PAGE_DRUID:
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Page]", CCINPC_PAGE_MAIN_MENU, oPC);
        return;
    }
}

void CleanUp(object oPC){
    DeleteList(CCINPC_LIST, oPC);
    DeleteLocalInt(oPC, CCINPC_CURRENT_PAGE);
    DeleteLocalInt(oPC, "ZDIALOG");
}

void main (){
    object oPC = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    switch(iEvent) {
    case DLG_INIT:
        SetNextPage(CCINPC_PAGE_MAIN_MENU);
        break;
    case DLG_PAGE_INIT:
        BuildPage(GetNextPage(), oPC);
        SetShowEndSelection(TRUE);
        SetDlgResponseList(CCINPC_LIST, oPC);
        break;
    case DLG_SELECTION:
        HandleSelection(oPC);
        break;
    case DLG_ABORT:
    case DLG_END:
        CleanUp(oPC);
    break;
    }
}
