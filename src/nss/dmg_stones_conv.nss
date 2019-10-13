#include "zdlg_include_i"
#include "zdialog_inc"
#include "dmg_stones_inc"
#include "db_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

int GOLD_COST = 1000000;

const int DMGS_ACTION_INCREASE    = 1;
const int DMGS_ACTION_DECREASE    = 2;
const int DMGS_ACTION_REMOVE      = 3;
const int DMGS_ACTION_PICK_VFX    = 4;

const int DMGS_PAGE_PICK_VFX      = 10;


void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

void CleanupWeapon(object oWeapon)
{
    DeleteLocalInt(oWeapon, "DMG_CNT");
    DeleteLocalInt(oWeapon, "DMG_MODS");
    int nCnt = 1;
    string sString = GetLocalString(oWeapon, "DMG" + IntToString(nCnt));
    while (sString != "")
    {
        DeleteLocalInt(oWeapon, "DMG_TYPE" + IntToString(nCnt));
        DeleteLocalInt(oWeapon, "DMG_BONUS" + IntToString(nCnt));
        DeleteLocalString(oWeapon, "DMG" + IntToString(nCnt));
        nCnt++;
        sString = GetLocalString(oWeapon, "DMG" + IntToString(nCnt));
    }
}

void CleanUp(object oPC, object oWeapon)
{
    DeleteList(GetCurrentList(oPC) + "_SUB", oPC);
    DeleteLocalInt(oPC, "DMGS_TYPE");
    DeleteLocalInt(oPC, "DMGS_NXT_DMG");
    if (GetIsObjectValid(oWeapon)) CleanupWeapon(oWeapon);
    CleanUpInc(oPC);
    DeleteLocalObject(oPC, "DMGS_WEAPON");
    DeleteLocalObject(oPC, "DMGS_STONE");
}

void HandleSelection(object oPC)
{
    object oWeapon      = GetLocalObject(oPC, "DMGS_WEAPON");
    object oStone       = GetLocalObject(oPC, "DMGS_STONE");
    object oContainer   = GetObjectByTag("WorkContainer");
    int nOptionSelected = GetPageOptionSelected(oPC);
    int nDmgType;       int nNextDamageBonus;
    int nCost;          int nSubType;           int nPlayerFame;
    int nVisualFX;
    string sPlayerFame; string sTagStone;
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    string sList = GetCurrentList(oPC);
    switch (nOptionSelected){ // WHAT IS SELECTED AT BUILDPAGE?
    case ZDIALOG_MAIN_MENU:
    case DMGS_PAGE_PICK_VFX:
        SetNextPage(oPC, nOptionSelected);
        return;
    case DMGS_ACTION_PICK_VFX:
        SetLocalInt(oPC, "DMGS_WEAPON_VFX", GetIntElement(GetDlgSelection(), sList + "_SUB", oPC));
    case DMGS_ACTION_INCREASE:
        if (!GetIsObjectValid(oContainer) || !GetIsObjectValid(oStone) || !GetIsObjectValid(oWeapon))
        {
            EndDlg();
            return;
        }
        nDmgType            = GetLocalInt(oPC, "DMGS_TYPE");
        nNextDamageBonus    = GetLocalInt(oPC, "DMGS_NXT_DMG");
        nCost               = DMGS_GetFameCost(nNextDamageBonus, nDmgType);
        sTagStone           = GetTag(oStone);

        if (GetIsObjectValid(oStone) && GetIsObjectValid(oWeapon))
        {
            if (GetItemPossessor(oStone) != oPC || GetItemPossessor(oWeapon) != oPC) // caught exploiting
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
                Insured_Destroy(oStone);
                Insured_Destroy(oWeapon);
                EndDlg();
                return;
            }
            NWNX_SQL_ExecuteQuery("select fame from trueid where trueid="+ sTRUEID +" limit 1");
            if (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                sPlayerFame = NWNX_SQL_ReadDataInActiveRow(0);
                nPlayerFame = StringToInt(sPlayerFame);
            }
            else
            {
                FloatingTextStringOnCreature("DB ERROR, please contact a DM/DEV", oPC);
                EndDlg();
                return;
            }
            if (nCost > nPlayerFame) // check again, just incase
            {
                FloatingTextStringOnCreature("Not enough fame", oPC);
                EndDlg();
                return;
            }
            string sID = GetLocalString(oWeapon, "EIID");
            if (GOLD_COST > GetGold(oPC) && sID == "")
            {
                FloatingTextStringOnCreature("Not enough gold", oPC);
                EndDlg();
                return;
            }
            if (!DMGS_UpdateStoneDB(oStone, oPC))
            {
                EndDlg();
                return;
            }
            string sName = "Epic " + GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(oWeapon))));
            string sPLID = IntToString(dbGetPLID(oPC));
            string sDBID;
            if (sID == "") // Non Epic-Item, turn it to one
            {
                TakeGoldFromCreature(1000000, oPC, TRUE);
                object oWorkItem = CopyObject(oWeapon, GetLocation(oContainer), oContainer, "EPICCRAFTED_" + sPLID);
                NWNX_SQL_ExecuteQuery("insert into epic_item (tag, plid) values (" + DelimList(dbQuotes(GetTag(oWorkItem)), sPLID) + ")");
                NWNX_SQL_ExecuteQuery("select last_insert_id() from epic_item limit 1");

                if (NWNX_SQL_ReadyToReadNextRow())
                {
                    NWNX_SQL_ReadNextRow();
                    sDBID = NWNX_SQL_ReadDataInActiveRow(0);
                    sName += " of " + GetName(oPC) + " #" + sDBID;
                }
                else // DB down?
                {
                    FloatingTextStringOnCreature("DB ERROR, please contact a DM/DEV", oPC);
                    Insured_Destroy(oWorkItem);
                    EndDlg();
                    return;
                }
                SetName(oWorkItem, sName);
                SetLocalString(oWorkItem, "OWNER", sPLID);
                SetLocalString(oWorkItem, "EIID", sDBID);
                Insured_Destroy(oWeapon);
                oWeapon = CopyItem(oWorkItem, oPC, TRUE);
                // remove regular crafted elemental damage, onhit, add- masscrit, enhancement +5, blabla
                DMGS_RemoveElementalDmg(oWeapon, GetLocalInt(oPC, "DMGS_WEAPON_VFX"));
                Insured_Destroy(oWorkItem);
            }
            NWNX_SQL_ExecuteQuery("update trueid set fame=fame-"+ IntToString(nCost) + ", famespent=famespent+" + IntToString(nCost) + " where trueid=" + sTRUEID);
            SetLocalInt(oPC, "PLAYER_FAME", nPlayerFame - nCost);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(DMGS_GetDmgVFX(nDmgType)), oPC);
            IPSafeAddItemProperty(oWeapon, ItemPropertyDamageBonus(nDmgType, nNextDamageBonus));
            CleanupWeapon(oWeapon);
            Insured_Destroy(oStone);
            ExportSingleCharacter(oPC);
        }
        EndDlg();
        return;
    case DMGS_ACTION_DECREASE:
        nDmgType            = GetIntElement(GetDlgSelection(), sList + "_SUB", oPC);
        nNextDamageBonus    = DMGS_GetNextDmgBonus(DMGS_GetDmgBonus(oWeapon, nDmgType, FALSE), FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL), oPC);
        if (nNextDamageBonus == -2) IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_PERMANENT, nDmgType);
        else IPSafeAddItemProperty(oWeapon, ItemPropertyDamageBonus(nDmgType, nNextDamageBonus));
        CleanupWeapon(oWeapon);
        SetNextPage(oPC, ZDIALOG_MAIN_MENU);
        return;
    case DMGS_ACTION_REMOVE:
        nDmgType            = GetIntElement(GetDlgSelection(), sList + "_SUB", oPC);
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_PERMANENT, nDmgType);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL), oPC);
        CleanupWeapon(oWeapon);
        SetNextPage(oPC, ZDIALOG_MAIN_MENU);
        return;
    case ZDIALOG_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC)
{
    object oWeapon = GetLocalObject(oPC, "DMGS_WEAPON");
    object oStone  = GetLocalObject(oPC, "DMGS_STONE");
    string sList   = GetCurrentList(oPC);

    string sMsg1;       string sMsg2;       string sString;
    string sPlayerFame; string sTagStone;   string sID;

    int nNextDamageBonusDecrease;
    int nBonusDecrease; int nTypeDecrease;  int nNextDamageBonus;
    int nPCFame;        int nDmgType;       int nDmgCurrent;
    int nBaseType;      int nWeaponSize;    int nDmgModsAllowed;
    int nCost;          int nCurrentDmg;    int nMods;
    int nCnt;           int nDmgCnt;        int nTypeRemove;

    DeleteList(sList, oPC); // START FRESH PAGE
    DeleteList(sList + "_SUB", oPC);
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        nPCFame             = GetLocalInt(oPC, "PLAYER_FAME");
        sPlayerFame         = IntToString(nPCFame);
        sTagStone           = GetTag(oStone);
        sID                 = GetLocalString(oWeapon, "EIID"); // only epic weapons got this
        nDmgType            = DMGS_GetStoneDmgType(sTagStone);
        nDmgCurrent         = DMGS_GetDmgBonus(oWeapon, nDmgType);
        nMods               = GetLocalInt(oWeapon, "DMG_MODS");
        nBaseType           = GetBaseItemType(oWeapon);
        nWeaponSize         = StringToInt(Get2DAString("baseitems", "WeaponSize", nBaseType));
        nDmgModsAllowed     = DMGS_GetDmgModsAllowed(nWeaponSize, nBaseType);
        nNextDamageBonus    = DMGS_GetNextDmgBonus(nDmgCurrent);
        nCost               = DMGS_GetFameCost(nNextDamageBonus, nDmgType);
        nCurrentDmg         = GetLocalInt(oWeapon, "DMG_CNT");
        nDmgCnt             = 2; // 1d4 - 2d6 inc by 2
        if (DMGS_GetDmgBonusValue(nNextDamageBonus) > 12) nDmgCnt = 4; // else 4
        nDmgCnt += nCurrentDmg; // add the current dmg of the weapon

        sMsg1 = GetRGB(1, 15, 15) + "Damage mods on Weapon: " + IntToString(nMods);
        sMsg1 += GetRGB() + "\nMax allowed: " + IntToString(nDmgModsAllowed) + GetRGB(1, 15, 15);
        sMsg1 += "\n----------------------------";
        if (nMods)
        {
            nCnt = 1;
            sString = GetLocalString(oWeapon, "DMG" + IntToString(nCnt));
            while (sString != "")
            {
                sMsg1 += "\n" + sString;
                nCnt++;
                sString = GetLocalString(oWeapon, "DMG" + IntToString(nCnt));
            }
        }
        sMsg1 += "\n----------------------------";
        sMsg1 += "\nTotal damage: " + IntToString(nCurrentDmg);
        sMsg1 += GetRGB() + "\nMax allowed: " + IntToString(SMS_WEAPON_MODS_MAX * nDmgModsAllowed) + "\n\n";

        if (nDmgType == -1) // some wrong stone Tag maybe, like a DM created stone
        {
            Insured_Destroy(oStone);
            sMsg1 = GetRGB(15, 15, 1) + "INVALID DAMAGE STONE DESTROYED";
            sMsg2 = "";
        }
        else if (nNextDamageBonus == -1) // shouldn't happen, but oh well...
        {
            sMsg2 = GetRGB(15, 15, 1) + "ERROR - Please report this to DM/DEV";
        }
        else if (nCost > nPCFame)
        {
            sMsg2 = GetRGB(15, 15, 1) + "Not enough fame for this damage type\n(Cost: " + IntToString(nCost) + " your fame: " + sPlayerFame + ")";
        }
        else if (GOLD_COST > GetGold(oPC) && sID == "")
        {
            sMsg2 = GetRGB(15, 15, 1) + "First stone use on this weapon, not enough gold! (Cost: " + IntToString(GOLD_COST) + ")";
        }
        else if (nNextDamageBonus == -2) // maxed with 2d12
        {
            sMsg2 = GetRGB(15, 15, 1) + "This damage type is maxed and can not be enchanted any further.";
        }
        // if new stone result in to many mods
        else if (nMods == nDmgModsAllowed && nNextDamageBonus == IP_CONST_DAMAGEBONUS_1d4)
        {
            sMsg2 = GetRGB(15, 15, 1) + "This weapon has " + IntToString(nMods) + " different damage bonuses and can not be enchanted any further.";
            // allow to remove mods
            nCnt = 1;
            sString = GetLocalString(oWeapon, "DMG" + IntToString(nCnt));
            while (sString != "")
            {
                nTypeRemove = GetLocalInt(oWeapon, "DMG_TYPE" + IntToString(nCnt));
                if (nTypeRemove != nDmgType) // show only different dmg types than stone
                {
                    SetMenuOptionInt("Remove " + DamageTypeString(nTypeRemove) + " damagetype.", DMGS_ACTION_REMOVE, oPC);
                    AddIntElement(nTypeRemove, sList + "_SUB", oPC);
                }
                nCnt++;
                sString = GetLocalString(oWeapon, "DMG" + IntToString(nCnt));
            }
        }
        else if (nDmgCnt > SMS_WEAPON_MODS_MAX * nDmgModsAllowed) // total damage is to high?
        {
            sMsg2 = GetRGB(15, 15, 1) + "Increasing the " + DamageTypeString(nDmgType) + " damage to " + DamageBonusString(nNextDamageBonus) + " would exceed (" + IntToString(nDmgCnt) + ") the max total damage for this weapon type and cannot be enchanted any further.";
            // Allow to decrease bonus
            nCnt = 1;
            sString = GetLocalString(oWeapon, "DMG" + IntToString(nCnt));
            while (sString != "")
            {
                nTypeDecrease = GetLocalInt(oWeapon, "DMG_TYPE" + IntToString(nCnt));
                if (nTypeDecrease != nDmgType) // show only different dmg types than stone
                {
                    nBonusDecrease = GetLocalInt(oWeapon, "DMG_BONUS" + IntToString(nCnt));
                    nNextDamageBonusDecrease = DMGS_GetNextDmgBonus(nBonusDecrease, FALSE);
                    if (nNextDamageBonusDecrease == -2) // it was 1d4
                    {
                        SetMenuOptionInt("Remove " + DamageTypeString(nTypeDecrease) + " " + DamageBonusString(nBonusDecrease), DMGS_ACTION_DECREASE, oPC);
                    }
                    else SetMenuOptionInt("Decrease " + DamageTypeString(nTypeDecrease) + " " + DamageBonusString(nBonusDecrease) + " -> " + DamageBonusString(nNextDamageBonusDecrease), DMGS_ACTION_DECREASE, oPC);
                    AddIntElement(nTypeDecrease, sList + "_SUB", oPC);
                }
                nCnt++;
                sString = GetLocalString(oWeapon, "DMG" + IntToString(nCnt));
            }
        }
        else
        {
            if (sID == "")
            {   // because converting a regular weapon into epic crafted will remove
                // the elemental damage types
                if (nDmgType == IP_CONST_DAMAGETYPE_ACID || nDmgType == IP_CONST_DAMAGETYPE_COLD ||
                    nDmgType == IP_CONST_DAMAGETYPE_FIRE || nDmgType == IP_CONST_DAMAGETYPE_ELECTRICAL)
                {
                    nNextDamageBonus = IP_CONST_DAMAGEBONUS_1d4;
                }
            }
            sMsg2 = GetRGB(1, 11, 1) + "You can increase " + DamageTypeString(nDmgType) + " " + DamageBonusString(nDmgCurrent) +
                    " -> " + DamageBonusString(nNextDamageBonus);
            sMsg2 += "\nTotal damage " + IntToString(nCurrentDmg) + " -> " + IntToString(nDmgCnt);
            if (sID == "")
            {
                sMsg2 += GetRGB(15, 15, 1) + "\n\nATTENTION: This Weapon is NOT an epic crafted item. This item will be bound and only useable by this character. A regular crafter will never modify the mods on this weapon. " +
                                             "Using this stone on Non-Epic-Crafted Weapon will remove the regular crafted damage types fire, acid, electrical and cold, but can be added back with other damage stones. On-Hit properties will be removed and replaced with +4 discipline.";
            }
            SetLocalInt(oPC, "DMGS_TYPE", nDmgType);
            SetLocalInt(oPC, "DMGS_NXT_DMG", nNextDamageBonus);
            if (sID == "") SetMenuOptionInt("Do it! (Fame cost: " + IntToString(nCost) + ", Gold cost: 1.000.000)", DMGS_PAGE_PICK_VFX, oPC);
            else SetMenuOptionInt("Do it! (Fame cost: " + IntToString(nCost) + ")", DMGS_ACTION_INCREASE, oPC);
        }
        SetDlgPrompt(sMsg1 + sMsg2);
        return;
    case DMGS_PAGE_PICK_VFX:
        SetDlgPrompt("Pick visual effect for the weapon");
        SetMenuOptionInt("Acid", DMGS_ACTION_PICK_VFX, oPC);
        AddIntElement(ITEM_VISUAL_ACID, sList + "_SUB", oPC);
        SetMenuOptionInt("Cold", DMGS_ACTION_PICK_VFX, oPC);
        AddIntElement(ITEM_VISUAL_COLD, sList + "_SUB", oPC);
        SetMenuOptionInt("Electrical", DMGS_ACTION_PICK_VFX, oPC);
        AddIntElement(ITEM_VISUAL_ELECTRICAL, sList + "_SUB", oPC);
        SetMenuOptionInt("Fire", DMGS_ACTION_PICK_VFX, oPC);
        AddIntElement(ITEM_VISUAL_FIRE, sList + "_SUB", oPC);
        SetMenuOptionInt("Sonic", DMGS_ACTION_PICK_VFX, oPC);
        AddIntElement(ITEM_VISUAL_SONIC, sList + "_SUB", oPC);
        SetMenuOptionInt("Evil", DMGS_ACTION_PICK_VFX, oPC);
        AddIntElement(ITEM_VISUAL_EVIL, sList + "_SUB", oPC);
        SetMenuOptionInt("Holy", DMGS_ACTION_PICK_VFX, oPC);
        AddIntElement(ITEM_VISUAL_HOLY, sList + "_SUB", oPC);
        return;
    }
}

void main ()
{
    object oPC = GetPcDlgSpeaker();
    int nEvent = GetDlgEventType();
    switch(nEvent) {
    case DLG_INIT:
        SetNextPage(oPC, ZDIALOG_MAIN_MENU);
        break;
    case DLG_PAGE_INIT:
        BuildPage(GetNextPage(oPC), oPC);
        SetShowEndSelection(TRUE);
        SetDlgResponseList(GetCurrentList(oPC), oPC);
        break;
    case DLG_SELECTION:
        HandleSelection(oPC);
        break;
    case DLG_ABORT:
    case DLG_END:
        CleanUp(oPC, GetLocalObject(oPC, "DMGS_WEAPON"));
    break;
    }
}
