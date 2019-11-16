#include "ness_pvp_db_inc"
#include "pg_lists_i"
#include "db_inc"


//Send the name of the weapon as declared in the function parameter,
//searches the database for the name, and then fetches the name
//from the database. Failsafe way to check if the item exists.
//Returns FALSE on query error.
int PvPstrLoadWeapon(string sID);

//Send the name of the armor as declared in the function parameter,
//searches the database for the name, and then fetches the name
//from the database. Failsafe way to check if the item exists.
//Returns FALSE on query error.
int PvPstrLoadArmor(string sID);

//Fetches from pvp_weapons a list of the options in one string with the name
//sName. Returns the string when called.
string PvpDisplayWeaponSQL(string sName);

//This function receives a string ("1d4", "2d10", etc.) and returns IP_CONST_DAMAGEBONUS_*
int PvpComputeDamageBonus(string sDamage);

//This function receives a string ("positive", "slashing", etc.) and returns DAMAGE_TYPE_*
int PvpComputeDamageType(string sType);

//This function receives a string ("str", "con", etc.) and returns IP_CONST_ABILITY_*
int PvpComputeAbilityType(string sType);

//This function receives a string ("heal", "discipline", etc.) and returns SKILL_*
int PvpComputeSkill(string sSkill);

//This function receives a string ("cleric", "bard", etc.) and returns IP_CONST_CLASS_* (only spell casters)
int PvpComputeClass(string sClass);

//This function receives an int ("10", "100", etc.) and returns IP_CONST_DAMAGEVULNERABILITY_*_PERCENT (only 10-100%)
int PvpComputePercent(int nPercent);

//This function receives a string ("fort", "reflex", or "will") and returns IP_CONST_SAVEBASETYPE_* or 0;
int PvpComputeSaveType(string sType);

//Sets the structure weapon to empty variables, like "" or 0.
void PvpClearVariables();

// Load master pvp-item data on module
void PvPLoadData();

// Get Item name by ID. 1 = Weapons, 2 = Armor
string PvPItemGetName(string sID, int nWhich=1);
// Get Item ResRef by ID. 1 = Weapons, 2 = Armor
string PvPItemGetResRef(string sID, int nWhich=1);
// Get Item Cost by ID. 1 = Weapons, 2 = Armor
string PvPItemGetCost(string sID, int nWhich=1);
// Get Item by ID, if not existing, create it. 1 = Weapons, 2 = Armor
object PvPGetItem(string sID, int nWhich=1);
// Get the object where items and variables are stored
object PvPGetContainer();

void PvpApplyStatsToWeapon(object oItem);
void PvpApplyStatsToArmor(object oItem);

void PvPLoadData()
{
    object oContainer = PvPGetContainer();
    DeleteList("PVP_WEAPONS_LIST", oContainer);
    DeleteList("PVP_ARMOR_LIST", oContainer);
    string sIDList = "";
    string sSQL, sID;
    sSQL = "select id, name, resref, cost from pvp_weapons order by id";
    NWNX_SQL_ExecuteQuery(sSQL);
    while(NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sID = NWNX_SQL_ReadDataInActiveRow(0);
        SetLocalString(oContainer, "PVP_WEAPONS_NAME_" + sID, NWNX_SQL_ReadDataInActiveRow(1));
        SetLocalString(oContainer, "PVP_WEAPONS_RESREF_" + sID, NWNX_SQL_ReadDataInActiveRow(2));
        SetLocalString(oContainer, "PVP_WEAPONS_COST_" + sID, NWNX_SQL_ReadDataInActiveRow(3));
        AddStringElement(sID, "PVP_WEAPONS_LIST", oContainer);
    }
    sSQL = "select id, name, resref, cost from pvp_armor order by id";
    NWNX_SQL_ExecuteQuery(sSQL);
    while(NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sID = NWNX_SQL_ReadDataInActiveRow(0);
        SetLocalString(oContainer, "PVP_ARMOR_NAME_" + sID, NWNX_SQL_ReadDataInActiveRow(1));
        SetLocalString(oContainer, "PVP_ARMOR_RESREF_" + sID, NWNX_SQL_ReadDataInActiveRow(2));
        SetLocalString(oContainer, "PVP_ARMOR_COST_" + sID, NWNX_SQL_ReadDataInActiveRow(3));
        AddStringElement(sID, "PVP_ARMOR_LIST", oContainer);
    }
}

string PvPItemGetName(string sID, int nWhich=1)
{
   object oContainer = PvPGetContainer();
   if (nWhich == 1) return GetLocalString(oContainer, "PVP_WEAPONS_NAME_" + sID);
   else if (nWhich == 2) return GetLocalString(oContainer, "PVP_ARMOR_NAME_" + sID);
   else return "";
}

string PvPItemGetResRef(string sID, int nWhich=1)
{
   object oContainer = PvPGetContainer();
   if (nWhich == 1) return GetLocalString(oContainer, "PVP_WEAPONS_RESREF_" + sID);
   else if (nWhich == 2) return GetLocalString(oContainer, "PVP_ARMOR_RESREF_" + sID);
   else return "";
}

string PvPItemGetCost(string sID, int nWhich=1)
{
   object oContainer = PvPGetContainer();
   if (nWhich == 1) return GetLocalString(oContainer, "PVP_WEAPONS_COST_" + sID);
   else if (nWhich == 2) return GetLocalString(oContainer, "PVP_ARMOR_COST_" + sID);
   else return "";
}

object PvPGetContainer()
{
    object oModule = GetModule();
    object oContainer = GetLocalObject(oModule, "PVP_ITEM_CONTAINER"); // get the container where items are stored
    if (!GetIsObjectValid(oContainer)) // If not existing, find it and store on module
    {
        oContainer = GetObjectByTag("PVP_ITEM_CONTAINER");
        if (GetIsObjectValid(oContainer)) SetLocalObject(oModule, "PVP_ITEM_CONTAINER", oContainer);
    }
    return oContainer;
}

object PvPGetItem(string sID, int nWhich=1)
{
    string sWhich;
    object oContainer = PvPGetContainer();
    object oItem;

    if (nWhich == 1)
    {
        oItem = GetLocalObject(oContainer, "PVP_WEAPONS_" + sID);
        if (!GetIsObjectValid(oItem)) // If item not existing, create it
        {
            if (PvPstrLoadWeapon(sID))
            {
                oItem = CreateItemOnObject(PvPItemGetResRef(sID, nWhich), oContainer);
                PvpApplyStatsToWeapon(oItem);
                if (GetIsObjectValid(oItem)) SetLocalObject(oContainer, "PVP_WEAPONS_" + sID, oItem);
                return oItem;
            }
        }
    }
    else if (nWhich == 2)
    {
        oItem = GetLocalObject(oContainer, "PVP_ARMOR_" + sID);
        if (!GetIsObjectValid(oItem)) // If item not existing, create it
        {
            if (PvPstrLoadArmor(sID))
            {
                oItem = CreateItemOnObject(PvPItemGetResRef(sID, nWhich), oContainer);
                PvpApplyStatsToArmor(oItem);
                if (GetIsObjectValid(oItem)) SetLocalObject(oContainer, "PVP_ARMOR_" + sID, oItem);
                return oItem;
            }
        }
    }
    return oItem;
}

///////////////////////////
// Structure Data. Used to store fetched MySQL data for the PvP store.
// Meant for easy item creation and dynamic weapon/armor stats.
// To create weapons/armor, see the Dev. forums.
struct pvpWeapon
{
    string sName;
    string sResRef;
    int    nCost;
    string sDamage1;
    string sDamage2;
    string sMasscrit;
    string sSkill1;
    string sSkill2;
    string sSkillminus;
    int    nEnhancment;
    string sOnhit;
    int    nKeen;
    int    nFeat1;
    int    nFeat2;
    string sSpellslot1;
    string sSpellslot2;
    string sVuln1;
    string sVuln2;
    string sResist1;
    string sResist2;
    string sOnhitspell;
    int    nFreedom;
    int    nVamp;
    int    nTrueSeeing;
    int    nHolyAvenger;
    int    nDarkvision;
};

struct pvpArmor
{
    string sName;
    string sResRef;
    int    nCost;
    string sAC;
    string sAbility1;
    string sAbility2;
    string sAbility3;
    string sAbilityMinus;
    string sResistance;
    string sVulnerability;
    string sSaves1;
    string sSaves2;
    string sSavesMinus;
    int    nFreedom;
    int    nEvasion;
    int    nDarkvision;
    int    nHaste;
    string sSkill1;
    string sSkill2;
    string sSkillMinus;
};

////////
//Public declaration of a single structure for weapons/armor/misc.
////////

struct pvpWeapon weapon;

struct pvpArmor armor;

int PvPstrLoadWeapon(string sID)
{
    string sSQL;
    sSQL = "SELECT * from pvp_weapons where id=" + sID;
    NWNX_SQL_ExecuteQuery(sSQL);

    //If a record was found, load the data from the query.
    if (!NWNX_SQL_ReadyToReadNextRow())   return FALSE;
    else
    {
        NWNX_SQL_ReadNextRow();
        weapon.sName =       NWNX_SQL_ReadDataInActiveRow(1);                  weapon.sResRef =     NWNX_SQL_ReadDataInActiveRow(2);
        weapon.nCost =       StringToInt(NWNX_SQL_ReadDataInActiveRow(3));     weapon.sDamage1 =    NWNX_SQL_ReadDataInActiveRow(4);
        weapon.sDamage2 =    NWNX_SQL_ReadDataInActiveRow(5);                  weapon.sMasscrit =   NWNX_SQL_ReadDataInActiveRow(6);
        weapon.sSkill1 =     NWNX_SQL_ReadDataInActiveRow(7);                  weapon.sSkill2 =     NWNX_SQL_ReadDataInActiveRow(8);
        weapon.sSkillminus = NWNX_SQL_ReadDataInActiveRow(9);                  weapon.nEnhancment = StringToInt(NWNX_SQL_ReadDataInActiveRow(10));
        weapon.sOnhit =      NWNX_SQL_ReadDataInActiveRow(11);                 weapon.nKeen =       StringToInt(NWNX_SQL_ReadDataInActiveRow(12));
        weapon.nFeat1 =      StringToInt(NWNX_SQL_ReadDataInActiveRow(13));    weapon.nFeat2 =      StringToInt(NWNX_SQL_ReadDataInActiveRow(14));
        weapon.sSpellslot1 = NWNX_SQL_ReadDataInActiveRow(15);                 weapon.sSpellslot2 = NWNX_SQL_ReadDataInActiveRow(16);
        weapon.sVuln1 =      NWNX_SQL_ReadDataInActiveRow(17);                 weapon.sVuln2 =      NWNX_SQL_ReadDataInActiveRow(18);
        weapon.sResist1 =    NWNX_SQL_ReadDataInActiveRow(19);                 weapon.sResist2 =    NWNX_SQL_ReadDataInActiveRow(20);
        weapon.sOnhitspell = NWNX_SQL_ReadDataInActiveRow(21);                 weapon.nFreedom =    StringToInt(NWNX_SQL_ReadDataInActiveRow(22));
        weapon.nVamp =       StringToInt(NWNX_SQL_ReadDataInActiveRow(23));    weapon.nTrueSeeing = StringToInt(NWNX_SQL_ReadDataInActiveRow(24));
        weapon.nHolyAvenger= StringToInt(NWNX_SQL_ReadDataInActiveRow(25));    weapon.nDarkvision = StringToInt(NWNX_SQL_ReadDataInActiveRow(26));

        return TRUE;
    }
}

int PvPstrLoadArmor(string sID)
{
    /////////////////
    //MySQL string, resultset, and pull from it
    int fetch = 0;
    string sSQL;
    sSQL = "SELECT * from pvp_armor where id=" + sID;
    NWNX_SQL_ExecuteQuery(sSQL);

    //If a record was found, load the data from the query.
    if (!NWNX_SQL_ReadyToReadNextRow())   return FALSE;
    else
    {
        NWNX_SQL_ReadNextRow();
        armor.sName =       NWNX_SQL_ReadDataInActiveRow(1);                  armor.sResRef =        NWNX_SQL_ReadDataInActiveRow(2);
        armor.nCost =       StringToInt(NWNX_SQL_ReadDataInActiveRow(3));     armor.sAC =            NWNX_SQL_ReadDataInActiveRow(4);
        armor.sAbility1 =   NWNX_SQL_ReadDataInActiveRow(5);                  armor.sAbility2 =      NWNX_SQL_ReadDataInActiveRow(6);
        armor.sAbility3 =   NWNX_SQL_ReadDataInActiveRow(7);                  armor.sAbilityMinus =  NWNX_SQL_ReadDataInActiveRow(8);
        armor.sResistance = NWNX_SQL_ReadDataInActiveRow(9);                  armor.sVulnerability = NWNX_SQL_ReadDataInActiveRow(10);
        armor.sSaves1 =     NWNX_SQL_ReadDataInActiveRow(11);                 armor.sSaves2 =        NWNX_SQL_ReadDataInActiveRow(12);
        armor.sSavesMinus = NWNX_SQL_ReadDataInActiveRow(13);                 armor.nFreedom =       StringToInt(NWNX_SQL_ReadDataInActiveRow(16));
        armor.nEvasion =    StringToInt(NWNX_SQL_ReadDataInActiveRow(15));    armor.nDarkvision =    StringToInt(NWNX_SQL_ReadDataInActiveRow(17));
        armor.nHaste =      StringToInt(NWNX_SQL_ReadDataInActiveRow(17));    armor.sSkill1 =        NWNX_SQL_ReadDataInActiveRow(18);
        armor.sSkill2 =     NWNX_SQL_ReadDataInActiveRow(19);                 armor.sSkillMinus =    NWNX_SQL_ReadDataInActiveRow(20);
        return TRUE;
    }
}


/*string PvPDisplayWeaponSQL(string sName)
{
    /////////////////
    //MySQL string, resultset, and pull from it
    int fetch = 0;
    string sSQL;
    sSQL = "SELECT * from pvp_weapons where name=" + Quotes(sName)+" limit 1";
    SQLExecDirect(sSQL);
    fetch=SQLFetch();
    //////////////////

    //If a record was found, load the data from the query.
    if (fetch==SQL_ERROR)   return "ERROR: No record found";
    else
    {
        return "Name = " + NWNX_SQL_ReadDataInActiveRow(2) + "\nResRef = " + NWNX_SQL_ReadDataInActiveRow(3) + "\nCost = " + NWNX_SQL_ReadDataInActiveRow(4) +
               "\nDamage1 = " + NWNX_SQL_ReadDataInActiveRow(5) + "\nDamage2 = " + NWNX_SQL_ReadDataInActiveRow(6) + "\nMassCrit = " + NWNX_SQL_ReadDataInActiveRow(7) +
               "\nSkill1 = " + NWNX_SQL_ReadDataInActiveRow(8) + "\nSkill2 = " + NWNX_SQL_ReadDataInActiveRow(9) + "\nSkillMinus = " + NWNX_SQL_ReadDataInActiveRow(10) +
               "\nEnhancment = " + NWNX_SQL_ReadDataInActiveRow(11) + "\nOnhit = " + NWNX_SQL_ReadDataInActiveRow(12) + "\nKeen = " + NWNX_SQL_ReadDataInActiveRow(13) +
               "\nFeat1 = " + NWNX_SQL_ReadDataInActiveRow(14) + "\nFeat2 = " + NWNX_SQL_ReadDataInActiveRow(15) + "\nSpellslot1 = " + NWNX_SQL_ReadDataInActiveRow(16) +
               "\nSpellslot2 = " + NWNX_SQL_ReadDataInActiveRow(17) + "\nVuln1 = " + NWNX_SQL_ReadDataInActiveRow(18) + "\nVuln2 = " + NWNX_SQL_ReadDataInActiveRow(19) +
               "\nResist1 = " + NWNX_SQL_ReadDataInActiveRow(20) + "\nResist2 = " + NWNX_SQL_ReadDataInActiveRow(21) + "\nOnhitSpell = " + NWNX_SQL_ReadDataInActiveRow(22) +
               "\nFreedom = " + NWNX_SQL_ReadDataInActiveRow(23) + "\nVamp = " + NWNX_SQL_ReadDataInActiveRow(24) + "\nTrueseeing = " + NWNX_SQL_ReadDataInActiveRow(25) +
               "\nHolyAvenger = " + NWNX_SQL_ReadDataInActiveRow(26) + "\nDarkvision = " + NWNX_SQL_ReadDataInActiveRow(27);
    }
}*/


void PvpApplyStatsToWeapon(object oItem)
{
    string sTemp      = "";
    string sQuantity  = "";
    int    nLength;
    int    nSubtract;


    if (weapon.sName != "")        SetName(oItem, weapon.sName);
    else return;

    SetLocalInt(oItem, "PVP_ITEM_COST", weapon.nCost);

    if (weapon.sDamage1 != "")
    {
        sTemp     = weapon.sDamage1;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 3);
        nSubtract = 4;
        // Checks for strings longer than 3, like 1d10 or 2d12. If true, sets the new string and subtract
        if (GetStringLeft(sQuantity, 1)=="d")
        {
            sQuantity  = GetStringRight(sTemp, 4);
            nSubtract = 5;
        }

        //Remaining string should be "damagetype". Removes the " 2d6" or " 1d10" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(PvpComputeDamageType(sTemp), PvpComputeDamageBonus(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (weapon.sDamage2 != "")
    {
        sTemp     = weapon.sDamage2;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 3);
        nSubtract = 4;
        // Checks for strings longer than 3, like 1d10 or 2d12. If true, sets the new string and subtract
        if (GetStringLeft(sQuantity, 1)=="d")
        {
            sQuantity  = GetStringRight(sTemp, 4);
            nSubtract = 5;
        }

        //Remaining string should be "damagetype". Removes the " 2d6" or " 1d10" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(PvpComputeDamageType(sTemp), PvpComputeDamageBonus(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (weapon.sMasscrit != "")
    {
        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(PvpComputeDamageBonus(weapon.sMasscrit)), oItem);
    }
    if (weapon.sSkill1 != "")
    {
        sTemp     = weapon.sSkill1;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        // Checks for single or double digit, then changes.
        if (GetStringLeft(sQuantity, 1)==" ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "skill". Removes the " 1" or " 4" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(PvpComputeSkill(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";   nLength=0;   nSubtract=0;
    }
    if (weapon.sSkill2 != "")
    {
        sTemp     = weapon.sSkill2;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        // Checks for single or double digit, then changes.
        if (GetStringLeft(sQuantity, 1)==" ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "skill". Removes the " 1" or " 4" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(PvpComputeSkill(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";   nLength=0;   nSubtract=0;
    }
    if (weapon.sSkillminus != "")
    {
        sTemp     = weapon.sSkillminus;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        // Checks for single or double digit, then changes.
        if (GetStringLeft(sQuantity, 1)==" ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "skill". Removes the " 1" or " 4" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseSkill(PvpComputeSkill(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";   nLength=0;   nSubtract=0;
    }
    if (weapon.nEnhancment)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(weapon.nEnhancment), oItem);
    }
    if (weapon.sOnhit != "")
    {
        sTemp     = weapon.sOnhit;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "num". Removes the " 10" or " 26" save dc from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(StringToInt(sTemp), StringToInt(sQuantity), IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (weapon.nKeen)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen(), oItem);
    }
    if (weapon.nFeat1)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(weapon.nFeat1), oItem);
    }
    if (weapon.nFeat2)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(weapon.nFeat2), oItem);
    }
    if (weapon.sSpellslot1 != "")
    {
        sTemp     = weapon.sSpellslot1;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 1);
        nSubtract = 2;

        //Remaining string should be "class". Removes the " 1" or " 9" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(PvpComputeClass(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (weapon.sSpellslot2 != "")
    {
        sTemp     = weapon.sSpellslot2;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 1);
        nSubtract = 2;

        //Remaining string should be "class". Removes the " 1" or " 9" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(PvpComputeClass(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (weapon.sVuln1 != "")
    {
        sTemp     = weapon.sVuln1;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 3);
        nSubtract = 4;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 2);
            nSubtract = 3;
        }

        //Remaining string should be "energy type". Removes the " 10" or " 100" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageVulnerability(PvpComputeDamageType(sTemp), PvpComputePercent(StringToInt(sQuantity))), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (weapon.sVuln2 != "")
    {
        sTemp     = weapon.sVuln2;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 3);
        nSubtract = 4;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 2);
            nSubtract = 3;
        }

        //Remaining string should be "energy type". Removes the " 10" or " 100" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageVulnerability(PvpComputeDamageType(sTemp), PvpComputePercent(StringToInt(sQuantity))), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (weapon.sResist1 != "")
    {
        sTemp     = weapon.sResist1;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 3);
        nSubtract = 4;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 2);
            nSubtract = 3;
        }

        //Remaining string should be "energy type". Removes the " 10" or " 100" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(PvpComputeDamageType(sTemp), PvpComputePercent(StringToInt(sQuantity))), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (weapon.sResist2 != "")
    {
        sTemp     = weapon.sResist2;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 3);
        nSubtract = 4;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 2);
            nSubtract = 3;
        }

        //Remaining string should be "energy type". Removes the " 10" or " 100" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(PvpComputeDamageType(sTemp), PvpComputePercent(StringToInt(sQuantity))), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (weapon.sOnhitspell != "")
    {
        sTemp     = weapon.sOnhitspell;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        if (GetStringLeft(sQuantity, 1) != " ")
        {
            sQuantity  = GetStringRight(sTemp, 3);
            nSubtract = 4;
        }

        //Remaining string should be "energy type". Removes the " 10" or " 100" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitCastSpell(StringToInt(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (weapon.nFreedom)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyFreeAction(), oItem);
    }
    if (weapon.nVamp)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVampiricRegeneration(weapon.nVamp), oItem);
    }
    if (weapon.nTrueSeeing)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyTrueSeeing(), oItem);
    }
    if (weapon.nHolyAvenger)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyHolyAvenger(), oItem);
    }
    if (weapon.nDarkvision)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDarkvision(), oItem);
    }
}

/////////////////////////////////////////////////////////////////////////////////

void PvpApplyStatsToArmor(object oItem)
{
    string sTemp      = "";
    string sQuantity  = "";
    int    nLength;
    int    nSubtract;


    if (armor.sName != "")        SetName(oItem, armor.sName);
    else return;

    SetLocalInt(oItem, "PVP_ITEM_COST", armor.nCost);

    if (armor.sAC != "")
    {
        sTemp     = armor.sSkill1;
        sQuantity = sTemp;

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";   nLength=0;   nSubtract=0;
    }
    if (armor.sAbility1 != "")
    {
        sTemp     = armor.sAbility1;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "attribute". Removes the 1 or 12 from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(PvpComputeAbilityType(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (armor.sAbility2 != "")
    {
        sTemp     = armor.sAbility2;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "attribute". Removes the 1 or 12 from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(PvpComputeAbilityType(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (armor.sAbility3 != "")
    {
        sTemp     = armor.sAbility3;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "attribute". Removes the 1 or 12 from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(PvpComputeAbilityType(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (armor.sAbilityMinus != "")
    {
        sTemp     = armor.sAbility1;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "attribute". Removes the 1 or 12 from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseAbility(PvpComputeAbilityType(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (armor.sResistance != "")
    {
        sTemp     = armor.sResistance;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 3);
        nSubtract = 4;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 2);
            nSubtract = 3;
        }

        //Remaining string should be "energy type". Removes the " 10" or " 100" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(PvpComputeDamageType(sTemp), PvpComputePercent(StringToInt(sQuantity))), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (armor.sVulnerability != "")
    {
        sTemp     = armor.sVulnerability;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 3);
        nSubtract = 4;
        if (GetStringLeft(sQuantity, 1) == " ")
        {
            sQuantity  = GetStringRight(sTemp, 2);
            nSubtract = 3;
        }

        //Remaining string should be "energy type". Removes the " 10" or " 100" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageVulnerability(PvpComputeDamageType(sTemp), PvpComputePercent(StringToInt(sQuantity))), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (armor.sSaves1 != "")
    {
        sTemp     = armor.sSaves1;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 1);
        nSubtract = 2;

        //Remaining string should be "attribute". Removes the 1 or 5 from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(PvpComputeSaveType(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (armor.sSaves2 != "")
    {
        sTemp     = armor.sSaves2;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 1);
        nSubtract = 2;

        //Remaining string should be "attribute". Removes the 1 or 5 from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(PvpComputeSaveType(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (armor.sSavesMinus != "")
    {
        sTemp     = armor.sSavesMinus;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 1);
        nSubtract = 2;

        //Remaining string should be "attribute". Removes the 1 or 5 from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyReducedSavingThrow(PvpComputeSaveType(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";    nLength=0;   nSubtract=0;
    }
    if (armor.nFreedom)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyFreeAction(), oItem);
    }
    if (armor.nEvasion)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImprovedEvasion(), oItem);
    }
    if (armor.nDarkvision)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDarkvision(), oItem);
    }
    if (armor.nHaste)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyHaste(), oItem);
    }
    if (armor.sSkill1 != "")
    {
        sTemp     = armor.sSkill1;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        // Checks for single or double digit, then changes.
        if (GetStringLeft(sQuantity, 1)==" ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "skill". Removes the " 1" or " 4" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(PvpComputeSkill(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";   nLength=0;   nSubtract=0;
    }
    if (armor.sSkill2 != "")
    {
        sTemp     = armor.sSkill2;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        // Checks for single or double digit, then changes.
        if (GetStringLeft(sQuantity, 1)==" ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "skill". Removes the " 1" or " 4" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(PvpComputeSkill(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";   nLength=0;   nSubtract=0;
    }
    if (armor.sSkillMinus != "")
    {
        sTemp     = armor.sSkillMinus;
        nLength   = GetStringLength(sTemp);
        sQuantity = GetStringRight(sTemp, 2);
        nSubtract = 3;
        // Checks for single or double digit, then changes.
        if (GetStringLeft(sQuantity, 1)==" ")
        {
            sQuantity  = GetStringRight(sTemp, 1);
            nSubtract = 2;
        }

        //Remaining string should be "skill". Removes the " 1" or " 4" from the selection.
        sTemp = GetStringLeft(sTemp, nLength - nSubtract);

        //Add the property to the item
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseSkill(PvpComputeSkill(sTemp), StringToInt(sQuantity)), oItem);

        //Reset variables
        sTemp="";   sQuantity="";   nLength=0;   nSubtract=0;
    }
}

int PvpComputeDamageBonus(string sDamage)
{
    if      (sDamage=="1d4")    return IP_CONST_DAMAGEBONUS_1d4;
    else if (sDamage=="1d6")    return IP_CONST_DAMAGEBONUS_1d6;
    else if (sDamage=="1d8")    return IP_CONST_DAMAGEBONUS_1d8;
    else if (sDamage=="2d4")    return IP_CONST_DAMAGEBONUS_2d4;
    else if (sDamage=="1d10")   return IP_CONST_DAMAGEBONUS_1d10;
    else if (sDamage=="1d12")   return IP_CONST_DAMAGEBONUS_1d12;
    else if (sDamage=="2d6")    return IP_CONST_DAMAGEBONUS_2d6;
    else if (sDamage=="2d8")    return IP_CONST_DAMAGEBONUS_2d8;
    else if (sDamage=="2d10")   return IP_CONST_DAMAGEBONUS_2d10;
    else if (sDamage=="2d12")   return IP_CONST_DAMAGEBONUS_2d12;
    return 0;
}

int PvpComputeDamageType(string sType)
{
    if      (sType=="acid")        return DAMAGE_TYPE_ACID;
    else if (sType=="cold")        return DAMAGE_TYPE_COLD;
    else if (sType=="fire")        return DAMAGE_TYPE_FIRE;
    else if (sType=="electric")    return DAMAGE_TYPE_ELECTRICAL;
    else if (sType=="sonic")       return DAMAGE_TYPE_SONIC;
    else if (sType=="negative")    return DAMAGE_TYPE_NEGATIVE;
    else if (sType=="positive")    return DAMAGE_TYPE_POSITIVE;
    else if (sType=="divine")      return DAMAGE_TYPE_DIVINE;
    else if (sType=="magical")     return DAMAGE_TYPE_MAGICAL;
    else if (sType=="bludgeoning") return DAMAGE_TYPE_BLUDGEONING;
    else if (sType=="slashing")    return DAMAGE_TYPE_SLASHING;
    else if (sType=="piercing")    return DAMAGE_TYPE_PIERCING;
    return 0;
}

int PvpComputeAbilityType(string sType)
{
    if      (sType=="str")      return IP_CONST_ABILITY_STR;
    else if (sType=="dex")      return IP_CONST_ABILITY_DEX;
    else if (sType=="con")      return IP_CONST_ABILITY_CON;
    else if (sType=="int")      return IP_CONST_ABILITY_INT;
    else if (sType=="wis")      return IP_CONST_ABILITY_WIS;
    else if (sType=="cha")      return IP_CONST_ABILITY_CHA;
    return 0;
}

int PvpComputeSkill(string sSkill)
{
    if      (sSkill=="animal empathy")   return SKILL_ANIMAL_EMPATHY;
    else if (sSkill=="appraise")         return SKILL_APPRAISE;
    else if (sSkill=="bluff")            return SKILL_BLUFF;
    else if (sSkill=="concentration")    return SKILL_CONCENTRATION;
    else if (sSkill=="discipline")       return SKILL_DISCIPLINE;
    else if (sSkill=="heal")             return SKILL_HEAL;
    else if (sSkill=="hide")             return SKILL_HIDE;
    else if (sSkill=="intimidate")       return SKILL_INTIMIDATE;
    else if (sSkill=="listen")           return SKILL_LISTEN;
    else if (sSkill=="lore")             return SKILL_LORE;
    else if (sSkill=="move silently")    return SKILL_MOVE_SILENTLY;
    else if (sSkill=="open lock")        return SKILL_OPEN_LOCK;
    else if (sSkill=="parry")            return SKILL_PARRY;
    else if (sSkill=="perform")          return SKILL_PERFORM;
    else if (sSkill=="persuade")         return SKILL_PERSUADE;
    else if (sSkill=="pick pocket")      return SKILL_PICK_POCKET;
    else if (sSkill=="ride")             return SKILL_RIDE;
    else if (sSkill=="search")           return SKILL_SEARCH;
    else if (sSkill=="set trap")         return SKILL_SET_TRAP;
    else if (sSkill=="spellcraft")       return SKILL_SPELLCRAFT;
    else if (sSkill=="spot")             return SKILL_SPOT;
    else if (sSkill=="taunt")            return SKILL_TAUNT;
    else if (sSkill=="tumble")           return SKILL_TUMBLE;
    else if (sSkill=="use magic device") return SKILL_USE_MAGIC_DEVICE;
    return 0;
}

int PvpComputeClass(string sClass)
{
    if      (sClass=="cleric")    return IP_CONST_CLASS_CLERIC;
    else if (sClass=="bard")      return IP_CONST_CLASS_BARD;
    else if (sClass=="druid")     return IP_CONST_CLASS_DRUID;
    else if (sClass=="paladin")   return IP_CONST_CLASS_PALADIN;
    else if (sClass=="ranger")    return IP_CONST_CLASS_RANGER;
    else if (sClass=="sorcerer")  return IP_CONST_CLASS_SORCERER;
    else if (sClass=="wizard")    return IP_CONST_CLASS_WIZARD;
    return 0;
}

int PvpComputePercent(int nPercent)
{
    switch (nPercent)
    {
        case 10:    return IP_CONST_DAMAGEVULNERABILITY_10_PERCENT;
        case 25:    return IP_CONST_DAMAGEVULNERABILITY_25_PERCENT;
        case 50:    return IP_CONST_DAMAGEVULNERABILITY_50_PERCENT;
        case 75:    return IP_CONST_DAMAGEVULNERABILITY_75_PERCENT;
        case 90:    return IP_CONST_DAMAGEVULNERABILITY_90_PERCENT;
        case 100:   return IP_CONST_DAMAGEVULNERABILITY_100_PERCENT;
        default:    return 0;
    }
    return 0;
}

int PvpComputeSaveType(string sType)
{
    if      (sType=="fort")      return IP_CONST_SAVEBASETYPE_FORTITUDE;
    else if (sType=="reflex")    return IP_CONST_SAVEBASETYPE_REFLEX;
    else if (sType=="will")      return IP_CONST_SAVEBASETYPE_WILL;
    return 0;
}

void PvpClearVariables()
{
    weapon.sName="";
    weapon.sResRef="";
    weapon.nCost=0;
    weapon.sDamage1="";
    weapon.sDamage2="";
    weapon.sMasscrit="";
    weapon.sSkill1="";
    weapon.sSkill2="";
    weapon.sSkillminus="";
    weapon.nEnhancment=0;
    weapon.sOnhit="";
    weapon.nKeen=0;
    weapon.nFeat1=0;
    weapon.nFeat2=0;
    weapon.sSpellslot1="";
    weapon.sSpellslot2="";
    weapon.sVuln1="";
    weapon.sVuln2="";
    weapon.sResist1="";
    weapon.sResist2="";
    weapon.sOnhitspell="";
    weapon.nFreedom=0;
    weapon.nVamp=0;
    weapon.nTrueSeeing=0;
    weapon.nHolyAvenger=0;
    weapon.nDarkvision=0;

    armor.sName="";
    armor.sResRef="";
    armor.nCost=0;
    armor.sAC="";
    armor.sAbility1="";
    armor.sAbility2="";
    armor.sAbility3="";
    armor.sAbilityMinus="";
    armor.sResistance="";
    armor.sVulnerability="";
    armor.sSaves1="";
    armor.sSaves2="";
    armor.sSavesMinus="";
    armor.nFreedom=0;
    armor.nEvasion=0;
    armor.nDarkvision=0;
    armor.nHaste=0;
    armor.sSkill1="";
    armor.sSkill2="";
    armor.sSkillMinus="";
}

//void main(){}
