#include "x2_inc_itemprop"
#include "x0_i0_match"
#include "seed_magic_stone"
#include "db_inc"

const float DMGS_FAMECOST_MULT      = 3.0;  // Multiplier for dmg bonus > 2d6
const int   DMGS_FAMECOST_ELEMENTAL = 0;    // acid, fire, electrical, cold
const int   DMGS_FAMECOST_LOW_RARE  = 20;   // bludgeoning, piercing, slashing, negative, sonic
const int   DMGS_FAMECOST_HIGH_RARE = 100;  // positive, divine, magical
const int   DMGS_VERY_RARE          = 1;
const int   DMGS_RARE               = 3;
const int   DMGS_COMMON             = 9;

int DMGS_GetNextDmgBonus(int nDamageBonus, int nInc = TRUE);
int DMGS_GetFameCost(int nDamageBonus, int nDamageType);
object DMGS_CreateStone(object oCreateOn, string sTag = "");
void DMGS_ActionCreateStone(object oCreateOn, string sTag = "");
string DMGS_GetStoneName(string sTagStone);
int DMGS_UpdateStoneDB(object oStone, object oPC);

void DMGS_RemoveElementalDmg(object oWeapon, int nVisualFX)
{
    int nSubType;
    itemproperty ipProperty = GetFirstItemProperty(oWeapon);
    while (GetIsItemPropertyValid(ipProperty))
    {
        if (GetItemPropertyType(ipProperty) == ITEM_PROPERTY_DAMAGE_BONUS)
        {
            nSubType = GetItemPropertySubType(ipProperty);
            if (nSubType == IP_CONST_DAMAGETYPE_ACID || nSubType == IP_CONST_DAMAGETYPE_COLD ||
                nSubType == IP_CONST_DAMAGETYPE_FIRE || nSubType == IP_CONST_DAMAGETYPE_ELECTRICAL)
            {
                RemoveItemProperty(oWeapon, ipProperty);
            }
        }
        else
        {
            RemoveItemProperty(oWeapon, ipProperty);
        }
        ipProperty = GetNextItemProperty(oWeapon);
    }
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(5), oWeapon);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_DISCIPLINE, 4), oWeapon);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVampiricRegeneration(6), oWeapon);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6), oWeapon);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen(), oWeapon);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(nVisualFX), oWeapon);
}

int DMGS_GetDmgBonusValue(int nDamageBonus)
{
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d4)  return 4;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d6)  return 6;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d4)  return 8;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d10) return 10;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d6)  return 12;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d8)  return 16;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d10) return 20;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d12) return 24;
    return FALSE;
}

int DMGS_GetFameCost(int nDamageBonus, int nDamageType)
{
    int nCost;
    switch (nDamageType)
    {
        case IP_CONST_DAMAGETYPE_ACID:
        case IP_CONST_DAMAGETYPE_COLD:
        case IP_CONST_DAMAGETYPE_FIRE:
        case IP_CONST_DAMAGETYPE_ELECTRICAL:
            nCost = DMGS_FAMECOST_ELEMENTAL;
            break;
        case IP_CONST_DAMAGETYPE_SONIC:
        case IP_CONST_DAMAGETYPE_BLUDGEONING:
        case IP_CONST_DAMAGETYPE_PIERCING:
        case IP_CONST_DAMAGETYPE_SLASHING:
        case IP_CONST_DAMAGETYPE_NEGATIVE:
            nCost = DMGS_FAMECOST_LOW_RARE;
            if (DMGS_GetDmgBonusValue(nDamageBonus) > 12) nCost = FloatToInt(IntToFloat(nCost) * DMGS_FAMECOST_MULT);
            break;
        case IP_CONST_DAMAGETYPE_DIVINE:
        case IP_CONST_DAMAGETYPE_MAGICAL:
        case IP_CONST_DAMAGETYPE_POSITIVE:
            nCost = DMGS_FAMECOST_HIGH_RARE;
            if (DMGS_GetDmgBonusValue(nDamageBonus) > 12) nCost = FloatToInt(IntToFloat(nCost) * DMGS_FAMECOST_MULT);
            break;
    }
    return nCost;
}

int DMGS_GetWeaponFameValue(object oWeapon)
{
    int nType;  int nBonus;  int nCost;  int nFame;

    itemproperty ipProperty = GetFirstItemProperty(oWeapon);
    while (GetIsItemPropertyValid(ipProperty))
    {
        if (GetItemPropertyType(ipProperty) == ITEM_PROPERTY_DAMAGE_BONUS)
        {
            if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_PERMANENT)
            {
                nType = GetItemPropertySubType(ipProperty);
                nBonus = GetItemPropertyCostTableValue(ipProperty);
                while (nBonus > -1)
                {
                    nCost = DMGS_GetFameCost(nBonus, nType);
                    nFame += nCost;
                    nBonus = DMGS_GetNextDmgBonus(nBonus, FALSE);
                }
            }
        }
        ipProperty = GetNextItemProperty(oWeapon);
    }
    return nFame;
}

int DMGS_GetDmgModsAllowed(int nWeaponSize, int nBaseType)
{
    if (nBaseType == BASE_ITEM_GLOVES)  return SMS_WEAPON_MODS_GLOVES;
    else if (nWeaponSize == 1)          return SMS_WEAPON_MODS_TINY;
    else if (nWeaponSize == 2)          return SMS_WEAPON_MODS_SMALL;
    else if (nWeaponSize == 3)          return SMS_WEAPON_MODS_MEDIUM;
    else if (nWeaponSize == 4)          return SMS_WEAPON_MODS_LARGE;
    return FALSE;
}

int DMGS_GetDmgVFX(int nDamageType)
{
    switch (nDamageType)
    {
        case IP_CONST_DAMAGETYPE_ACID:          return VFX_IMP_HEAD_ACID;
        case IP_CONST_DAMAGETYPE_COLD:          return VFX_IMP_HEAD_COLD;
        case IP_CONST_DAMAGETYPE_DIVINE:        return VFX_IMP_HEAD_HOLY;
        case IP_CONST_DAMAGETYPE_ELECTRICAL:    return VFX_IMP_HEAD_ELECTRICITY;
        case IP_CONST_DAMAGETYPE_FIRE:          return VFX_IMP_HEAD_FIRE;
        case IP_CONST_DAMAGETYPE_MAGICAL:       return VFX_IMP_MAGBLUE;
        case IP_CONST_DAMAGETYPE_NEGATIVE:      return VFX_IMP_HEAD_EVIL;
        case IP_CONST_DAMAGETYPE_POSITIVE:      return VFX_IMP_HEAD_MIND;
        case IP_CONST_DAMAGETYPE_SONIC:         return VFX_IMP_HEAD_SONIC;
        case IP_CONST_DAMAGETYPE_BLUDGEONING:   return VFX_IMP_HEAD_NATURE;
        case IP_CONST_DAMAGETYPE_PIERCING:      return VFX_IMP_HEAD_NATURE;
        case IP_CONST_DAMAGETYPE_SLASHING:      return VFX_IMP_HEAD_NATURE;
    }
    return VFX_IMP_HEAD_ODD;
}

int DMGS_GetDmgBonus(object oWeapon, int nDamageType, int nDoLoad = TRUE)
{
    int nModsCnt;   int nSubType = -1;  int nDamageBonusReturn = -1;
    int nCnt = 1;   int nDamageCnt;     int nDamageBonus = -1;

    itemproperty ipProperty = GetFirstItemProperty(oWeapon);
    while (GetIsItemPropertyValid(ipProperty))
    {
        if (GetItemPropertyType(ipProperty) == ITEM_PROPERTY_DAMAGE_BONUS)
        {
            if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_PERMANENT)
            {
                nModsCnt++;
                nDamageBonus = GetItemPropertyCostTableValue(ipProperty);
                nSubType = GetItemPropertySubType(ipProperty);
                nDamageCnt += DMGS_GetDmgBonusValue(nDamageBonus);
                if (nDoLoad) SetLocalString(oWeapon, "DMG" + IntToString(nCnt), DamageTypeString(nSubType) + " " + DamageBonusString(nDamageBonus));
                if (nDoLoad) SetLocalInt(oWeapon, "DMG_TYPE" + IntToString(nCnt), nSubType);
                if (nDoLoad) SetLocalInt(oWeapon, "DMG_BONUS" + IntToString(nCnt), nDamageBonus);
                if (nSubType == nDamageType) nDamageBonusReturn = nDamageBonus;
                nCnt++;
            }
        }
        ipProperty = GetNextItemProperty(oWeapon);
    }
    if (nDoLoad) SetLocalInt(oWeapon, "DMG_CNT", nDamageCnt);
    if (nDoLoad) SetLocalInt(oWeapon, "DMG_MODS", nModsCnt);
    return nDamageBonusReturn;
}

int DMGS_GetNextDmgBonus(int nDamageBonus, int nInc = TRUE)
{
    if (nInc)
    {
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d12)  return -2; // maxed
        if (nDamageBonus == -1)                         return IP_CONST_DAMAGEBONUS_1d4; // 4
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d4)   return IP_CONST_DAMAGEBONUS_1d6; // 6
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d6)   return IP_CONST_DAMAGEBONUS_2d4; // 8
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d4)   return IP_CONST_DAMAGEBONUS_1d10; // 10
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d10)  return IP_CONST_DAMAGEBONUS_2d6; // 12

        if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d6)   return IP_CONST_DAMAGEBONUS_2d8; // 16
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d8)   return IP_CONST_DAMAGEBONUS_2d10; // 20
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d10)  return IP_CONST_DAMAGEBONUS_2d12; // 24
        return -1; // error or false
    }
    else
    {
        if (nDamageBonus == -1)                         return -1; // error or false
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d12)  return IP_CONST_DAMAGEBONUS_2d10;
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d10)  return IP_CONST_DAMAGEBONUS_2d8;
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d8)   return IP_CONST_DAMAGEBONUS_2d6;

        if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d6)   return IP_CONST_DAMAGEBONUS_1d10;
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d10)  return IP_CONST_DAMAGEBONUS_2d4;
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d4)   return IP_CONST_DAMAGEBONUS_1d6;
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d6)   return IP_CONST_DAMAGEBONUS_1d4;
        if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d4)   return -2;
    }
    return -1; // error or false
}

int DMGS_GetStoneDmgType(string sTagStone)
{
    if (sTagStone == "DMGS_FIRE")     return IP_CONST_DAMAGETYPE_FIRE;
    if (sTagStone == "DMGS_ACID")     return IP_CONST_DAMAGETYPE_ACID;
    if (sTagStone == "DMGS_ELECTRIC") return IP_CONST_DAMAGETYPE_ELECTRICAL;
    if (sTagStone == "DMGS_COLD")     return IP_CONST_DAMAGETYPE_COLD;
    if (sTagStone == "DMGS_SONIC")    return IP_CONST_DAMAGETYPE_SONIC;
    if (sTagStone == "DMGS_BLUDGE")   return IP_CONST_DAMAGETYPE_BLUDGEONING;
    if (sTagStone == "DMGS_SLASH")    return IP_CONST_DAMAGETYPE_SLASHING;
    if (sTagStone == "DMGS_PIERCE")   return IP_CONST_DAMAGETYPE_PIERCING;
    if (sTagStone == "DMGS_NEGATIVE") return IP_CONST_DAMAGETYPE_NEGATIVE;
    if (sTagStone == "DMGS_DIVINE")   return IP_CONST_DAMAGETYPE_DIVINE;
    if (sTagStone == "DMGS_MAGIC")    return IP_CONST_DAMAGETYPE_MAGICAL;
    if (sTagStone == "DMGS_POSITIVE") return IP_CONST_DAMAGETYPE_POSITIVE;
    return -1;
}

string DMGS_GetStoneName(string sTagStone)
{
    if (sTagStone == "DMGS_FIRE")     return "Stone of Fire Damage";
    if (sTagStone == "DMGS_ACID")     return "Stone of Acid Damage";
    if (sTagStone == "DMGS_ELECTRIC") return "Stone of Electric Damage";
    if (sTagStone == "DMGS_COLD")     return "Stone of Cold Damage";
    if (sTagStone == "DMGS_SONIC")    return "Stone of Sonic Damage";
    if (sTagStone == "DMGS_BLUDGE")   return "Stone of Bludgeoning Damage";
    if (sTagStone == "DMGS_SLASH")    return "Stone of Slashing Damage";
    if (sTagStone == "DMGS_PIERCE")   return "Stone of Piercing Damage";
    if (sTagStone == "DMGS_NEGATIVE") return "Stone of Negative Damage";
    if (sTagStone == "DMGS_DIVINE")   return "Stone of Divine Damage";
    if (sTagStone == "DMGS_MAGIC")    return "Stone of Magic Damage";
    if (sTagStone == "DMGS_POSITIVE") return "Stone of Positive Damage";
    return "";
}

string DMGS_GetNextStoneID(string sTag)
{
    string sToken;
    NWNX_SQL_ExecuteQuery("insert into dmg_stones (ds_tag) values ('" + sTag + "')");
    NWNX_SQL_ExecuteQuery("select last_insert_id() from dmg_stones limit 1");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sToken = NWNX_SQL_ReadDataInActiveRow(0);
    }
    return sToken;
}

int DMGS_GLOBALWEIGHT;

int DMGS_PickByWeight(int nPass, int nRoll, int nWeight)
{
    if (nPass == 0) // FIRST PASS OF LOOP SUMS UP THE TOTAL WEIGHT TO USE ON NEXT PASS TO SELECT ONE OF THE OPTIONS
    {
        DMGS_GLOBALWEIGHT = DMGS_GLOBALWEIGHT + nWeight;
    }
    else // SECOND PASS OVER THE WE ACTUAL DECIDE WHICH TO PICK
    {
        if ((DMGS_GLOBALWEIGHT - nWeight) < nRoll) return TRUE;
        DMGS_GLOBALWEIGHT = DMGS_GLOBALWEIGHT - nWeight; // DECOMPILE THE COUNTER TO SEE WHO WON
    }
    return FALSE; // RETURN FALSE ON FIRST PASS SO ALL CONDITIONS EXECUTE
}

string DMGS_PickRandomStone()
{
    int nRoll;
    int nPass;
    string sTag;
    for (nPass = 0; nPass <= 1; nPass++)
    {
        if (nPass == 0) DMGS_GLOBALWEIGHT = 0; // FIRST PASS, ZERO AND SUM UP OUR TOTAL CHANCES
        else nRoll = Random(DMGS_GLOBALWEIGHT) + 1; // SECOND PASS, PICK A NUMBER BETWEEN 1 & THE TOTAL CHANCES, THEN RETURN THE TAG

        if      (DMGS_PickByWeight(nPass, nRoll, DMGS_COMMON))      sTag = "DMGS_FIRE";
        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_COMMON))      sTag = "DMGS_COLD";
        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_COMMON))      sTag = "DMGS_ACID";
        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_COMMON))      sTag = "DMGS_ELECTRIC";

        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_RARE))        sTag = "DMGS_BLUDGE";
        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_RARE))        sTag = "DMGS_SLASH";
        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_RARE))        sTag = "DMGS_PIERCE";
        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_RARE))        sTag = "DMGS_SONIC";
        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_RARE))        sTag = "DMGS_NEGATIVE";

        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_VERY_RARE))   sTag = "DMGS_MAGIC";
        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_VERY_RARE))   sTag = "DMGS_DIVINE";
        else if (DMGS_PickByWeight(nPass, nRoll, DMGS_VERY_RARE))   sTag = "DMGS_POSITIVE";
    }
    return sTag;
}

int DMGS_UpdateStoneDB(object oStone, object oPC)
{
    string sName = GetName(oStone);
    int nSuccess = FindSubString(sName, "#");
    if (nSuccess != -1)
    {
        string sPLID = IntToString(dbGetPLID(oPC));
        if (oPC == oStone) sPLID = "1"; // pawn deleted it...
        nSuccess++;
        sName = GetStringRight(sName, GetStringLength(sName) - nSuccess);

        NWNX_SQL_ExecuteQuery("select ds_plid from dmg_stones where ds_id=" + sName);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            if (NWNX_SQL_ReadDataInActiveRow(0) != "0")
            {
                FloatingTextStringOnCreature("DUPED STONE DESTROYED", oPC);
                Insured_Destroy(oStone);
                return FALSE;
            }
            NWNX_SQL_ExecuteQuery("update dmg_stones set ds_used=now(), ds_plid=" + sPLID + " where ds_id=" + sName);
            return TRUE;
        }
        else
        {
            FloatingTextStringOnCreature("DB ERROR, please contact a DM/DEV", oPC);
            return FALSE;
        }
    }
    else
    {
        FloatingTextStringOnCreature("INVALID STONE DESTROYED", oPC);
        Insured_Destroy(oStone);
        return FALSE;
    }
    return FALSE;
}

object DMGS_CreateStone(object oCreateOn, string sTag = "")
{
    object oStone;
    if (sTag == "") sTag = DMGS_PickRandomStone();
    string sNewName = DMGS_GetStoneName(sTag);
    if (sNewName == "") return oStone;
    string sToken = DMGS_GetNextStoneID(sTag);
    if (sToken == "") return oStone;

    oStone = CreateItemOnObject("item_dmgstone", oCreateOn, 1, sTag);
    SetName(oStone, sNewName + " #" + sToken);
    return oStone;
}

void DMGS_ActionCreateStone(object oCreateOn, string sTag = "")
{
    DMGS_CreateStone(oCreateOn, sTag);
}

//void main(){}
