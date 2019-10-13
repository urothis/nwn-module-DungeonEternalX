#include "_functions"
#include "pg_lists_i"
#include "db_inc"
#include "dmg_stones_inc"

object EI_GetContainer();
void EI_LoadData();
object EI_GetItem(int nID, object oContainer);
string EI_GetName(int nID, object oContainer);
int EI_GetCost(int nID, object oContainer);
int EI_GetIsBound(int nID, object oContainer);
// Intern Function
string EI_GetCategory(int nBaseItemType);
// Check if player meets the requirements
int EI_GetMeetReq(int nID, object oPC, object oContainer);
string EI_GetReqText(int nID, object oContainer);
// needed for damage stones in shop
int GetXPCostPerFameCost(int nFameCost);
int GetHasEpicItemWithReq(object oPC);
// create item and return true if item is bound, needed for invocate cutscene
int BuyEpicItem(object oPC);
// Fetches the TRUEID the EpicItem belongs to, based on the name of the item.
int EI_GetTRUEID(object oEpicItem);
// Fetches the EIID the EpicItem belongs to, based on the name of the item.
int EI_GetEIID(object oEpicItem);
//Checks the db epic_item table for a TRUEID column == 0. Then updates it.
void EI_UpdateTRUEIDonWeapon(object oPC, object oItem);

const int LESS_THAN_20_MONK     = 1;
const int LESS_THAN_27_MONK     = 2;
const int SUBRACE_ARCTICDWARF   = 3;
const int BARD_MIN_31           = 4;
const int BG_EPIC_ASN           = 5;
const int VIRTUE_HELM           = 6;

void EI_LoadData()
{
    object oContainer = EI_GetContainer();
    int nID, nBaseItemType, nCatID, nCatExisting;
    string sCategory, sCatLoop;

    object oItem = GetFirstItemInInventory(oContainer);
    while(GetIsObjectValid(oItem))
    {
        nID++;
        nBaseItemType = GetBaseItemType(oItem);

        // Store Existance of item and give it a ID
        SetLocalObject(oContainer, "EPICITEM_" + IntToString(nID), oItem);
        AddIntElement(nID, "EPICITEM_LIST", oContainer);

        // Store Category info on item
        sCategory = EI_GetCategory(nBaseItemType);
        // SetLocalString(oItem, "CATEGORY", sCategory);

        // check existance of category
        nCatExisting = FALSE;
        sCatLoop = GetFirstStringElement("EPICITEM_CATEGORY_LIST", oContainer);
        while (sCatLoop != "")
        {
            if (sCatLoop == sCategory)
            {
                nCatExisting = TRUE;
                break;
            }
            sCatLoop = GetNextStringElement();
        }
        // Category not existing? then store it
        if (!nCatExisting) AddStringElement(sCategory, "EPICITEM_CATEGORY_LIST", oContainer);
        // Store the item in the category
        AddIntElement(nID, sCategory, oContainer);

        // Get Next item
        oItem = GetNextItemInInventory(oContainer);
    }

    // create a category for damage stones
    AddStringElement("Damage Stones", "EPICITEM_CATEGORY_LIST", oContainer);
}

int GetXPCostPerFameCost(int nFameCost)
{
    return nFameCost * 60;
}

int GetHasEpicItemWithReq(object oPC)
{
    NWNX_SQL_ExecuteQuery("select eiid from epic_item where status='active' and req !=0 and plid=" + IntToString(dbGetPLID(oPC)) + " limit 1");
    if (NWNX_SQL_ReadyToReadNextRow()) // got epic-item with REQ
    {
        FloatingTextStringOnCreature("Can not de-level character with epic items. Give it back at Temple of Adaghar and receive fame.", oPC, FALSE);
        return TRUE;
    }
    return FALSE;
}

int EI_GetMeetReq(int nID, object oPC, object oContainer)
{
    int nReq = GetLocalInt(GetLocalObject(oContainer, "EPICITEM_" + IntToString(nID)), "REQ");
    if (GetHitDice(oPC) < 40) return FALSE;
    switch (nReq)
    {
        case 0: return TRUE;
        case LESS_THAN_20_MONK:
            if (GetLevelByClass(CLASS_TYPE_MONK, oPC) < 20) return TRUE;
        case LESS_THAN_27_MONK:
            if (GetLevelByClass(CLASS_TYPE_MONK, oPC) < 27) return TRUE;
        case SUBRACE_ARCTICDWARF:
            if (GetStringUpperCase(GetSubRace(oPC)) == "ARCTICDWARF") return TRUE;
        case BARD_MIN_31:
            if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 30) return TRUE;
        case BG_EPIC_ASN:
            if (GetHasFeat(FEAT_EPIC_BLACKGUARD, oPC) || GetHasFeat(FEAT_EPIC_ASSASSIN, oPC)) return TRUE;
        case VIRTUE_HELM:
        if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oPC) >= 20 && GetHasFeat(FEAT_TURN_UNDEAD, oPC)) return TRUE;
    }
    return FALSE;
}

string EI_GetReqText(int nID, object oContainer)
{
    int nReq = GetLocalInt(GetLocalObject(oContainer, "EPICITEM_" + IntToString(nID)), "REQ");
    switch (nReq)
    {
        case 0: return "Nothing";
        case LESS_THAN_20_MONK:
            return "Less than 20 monk levels";
        case LESS_THAN_27_MONK:
            return "Less than 27 monk levels";
        case SUBRACE_ARCTICDWARF:
            return "Subrace Arctic Dwarf";
        case BARD_MIN_31:
            return "Min 31 Bard";
        case BG_EPIC_ASN:
            return "Epic Blackguard or Assassin";
        case VIRTUE_HELM:
            return "Feat Turn Undead, total 20 levels of Paladin and Champion of Torm";
    }
    return "";
}

object EI_GetItem(int nID, object oContainer)
{
    return GetLocalObject(oContainer, "EPICITEM_" + IntToString(nID));
}

string EI_GetName(int nID, object oContainer)
{
   return GetName(GetLocalObject(oContainer, "EPICITEM_" + IntToString(nID)));
}

int EI_GetCost(int nID, object oContainer)
{
   return GetLocalInt(GetLocalObject(oContainer, "EPICITEM_" + IntToString(nID)), "COST");
}

int EI_GetIsBound(int nID, object oContainer)
{
   return GetLocalInt(GetLocalObject(oContainer, "EPICITEM_" + IntToString(nID)), "BOUND");
}

object EI_GetContainer()
{
    return DefGetObjectByTag("EPICITEM_CONTAINER", GetModule());
}

string EI_GetCategory(int nBaseItemType)
{
    string sCategory = "";
    switch (StringToInt(Get2DAString("baseitems", "Category", nBaseItemType)))
    {
        case  1:
            sCategory = Get2DAString("baseitems", "ReqFeat0", nBaseItemType);
            if (sCategory == "44") sCategory = "Melee Weapons (Exotic)";
            else if (sCategory == "45") sCategory = "Melee Weapons (Martial)";
            else sCategory = "Melee Weapons (Simple)";
            break;
        case  2: sCategory = "Ranged Weapons"; break;
        case  3: sCategory = "Shields"; break;
        case  4: sCategory = "Armor"; break;
        case  5: sCategory = "Helmets"; break;
        case  6: sCategory = "Ammunition"; break;
        case  7: sCategory = "Throwing Weapons"; break;
        case 12: sCategory = "Clothing"; break;
        case  8: sCategory = "Magic Staffs/Rods"; break;
        case  9: sCategory = "Potions"; break;
        case 10: sCategory = "Scrolls"; break;
        case 16: sCategory = "Miscellaneous"; break;
    }
    return sCategory;
}

int BuyEpicItem(object oPC)
{
    string sItem = GetLocalString(oPC, "BUY_ITEM_ID");
    DeleteLocalString(oPC, "BUY_ITEM_ID");

    int nCurrentFame;

    NWNX_SQL_ExecuteQuery("select fame from trueid where trueid="+ IntToString(dbGetTRUEID(oPC)) +" limit 1");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        nCurrentFame = StringToInt(NWNX_SQL_ReadDataInActiveRow());
    }
    else return FALSE; // Stop here

    int nBoundAction;
    int nCost;
    int nID = StringToInt(sItem);
    object oContainer = EI_GetContainer();
    object oWorkItem;

    if (nID) // item with a epicitem chest-ID
    {
        object oItem = EI_GetItem(nID, oContainer);

        nCost = EI_GetCost(nID, oContainer);
        if (nCurrentFame < nCost) return FALSE;

        string sName = GetName(oItem);

        if (EI_GetIsBound(nID, oContainer))
        {
            string sPLID = IntToString(dbGetPLID(oPC));
            string sDBID;
            oWorkItem = CopyItem(oItem, oContainer);
            string sReq = IntToString(GetLocalInt(oItem, "REQ"));

            NWNX_SQL_ExecuteQuery("insert into epic_item (tag,trueid,acid,plid,paid,req) values (" + DelimList(dbQuotes(GetTag(oItem)), IntToString(dbGetTRUEID(oPC)), IntToString(dbGetACID(oPC)), sPLID, IntToString(nCost), sReq) + ")");
            NWNX_SQL_ExecuteQuery("select last_insert_id() from epic_item limit 1");

            if (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                sDBID = NWNX_SQL_ReadDataInActiveRow(0);
                sName += " of " + GetName(oPC) + " #" + sDBID;
            }

            SetName(oWorkItem, sName);
            SetLocalString(oWorkItem, "OWNER", sPLID);
            SetLocalString(oWorkItem, "EIID", sDBID);
            CopyItem(oWorkItem, oPC, TRUE);
            Insured_Destroy(oWorkItem);
            nBoundAction = TRUE;
        }
        else
        {
            CopyItem(oItem, oPC);
            nBoundAction = FALSE;
        }
    }
    else if (GetStringLeft(sItem, 5) == "DMGS_") // damage stones
    {
        int nXPDonated = dbGetDonatedXP(oPC, TRUE);
        nCost = DMGS_GetFameCost(DAMAGE_BONUS_1d4, DMGS_GetStoneDmgType(sItem));
        int nXPCost = GetXPCostPerFameCost(nCost);
        if (nXPDonated < nXPCost || nCurrentFame < nCost) return FALSE;
        NWNX_SQL_ExecuteQuery("update trueid set donatedxp=donatedxp-"+IntToString(nXPCost)+" where trueid="+IntToString(dbGetTRUEID(oPC)));
        oWorkItem = DMGS_CreateStone(oContainer, sItem);
        CopyItem(oWorkItem, oPC, TRUE);
        Insured_Destroy(oWorkItem);
        nBoundAction = FALSE;
    }
    else return FALSE;

    NWNX_SQL_ExecuteQuery("update trueid set fame=fame-"+ IntToString(nCost) + ", famespent=famespent+" + IntToString(nCost) + " where trueid=" + IntToString(dbGetTRUEID(oPC)));
    SetLocalInt(oPC, "PLAYER_FAME", nCurrentFame - nCost);

    int nSpent = GetLocalInt(oPC, "PLAYER_FAME_SPENT") + nCost;
    SetLocalInt(oPC, "PLAYER_FAME_SPENT", nSpent);
    return nBoundAction;
}

int EI_GetTRUEID(object oEpicItem)
{
    int nTRUEID  = GetLocalInt(oEpicItem,"TRUEID");

    if (!nTRUEID)
    {
        string sEIID = GetSubString(GetName(oEpicItem),FindSubString(GetName(oEpicItem),"#")+1,GetStringLength(GetName(oEpicItem)));
        NWNX_SQL_ExecuteQuery("select trueid from epic_item where eiid="+sEIID);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            SetLocalInt(oEpicItem,"TRUEID",StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
        }

    }
    return GetLocalInt(oEpicItem,"TRUEID");
}

int EI_GetEIID(object oEpicItem)
{
    int nEIID  = GetLocalInt(oEpicItem,"EIID");

    if (!nEIID)
    {
        string sEIID = GetSubString(GetName(oEpicItem),FindSubString(GetName(oEpicItem),"#")+1,GetStringLength(GetName(oEpicItem)));
        SetLocalInt(oEpicItem,"EIID",StringToInt(sEIID));
    }
    return GetLocalInt(oEpicItem,"EIID");
}

void EI_UpdateTRUEIDonWeapon(object oPC, object oItem)
{
    NWNX_SQL_ExecuteQuery("select trueid from epic_item where status='active' and eiid=" + IntToString(EI_GetEIID(oItem)));
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        if (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)))
            NWNX_SQL_ExecuteQuery("update epic_item set trueid="+IntToString(dbGetTRUEID(oPC))+"where eiid="+IntToString(EI_GetEIID(oItem)));
    }
}

//void main(){}
