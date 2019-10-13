#include "dmg_stones_inc"
#include "random_loot_inc"

int EIX_ConstToCountDmg(int nDamageBonus);
int EIX_ConstToCountOnHit(int nDC);
string EIX_ConstToTag(int nSubType);
float EIX_ExtractStones(object oWeapon, object oPC, float fDelay=0.0, object oContainer=OBJECT_SELF);
int EIX_UpdateOldStoneDB(object oItem, object oPC);
string EIX_StringToTag(string sSubType);
//Remakes all damage stones before the TRUEID system was in place, or ID<12701
float EIX_RemakeOldStones(object oPC, object oContainer);

void main()
{
    object oPC = GetLastClosedBy();
    object oChest = OBJECT_SELF;
    float fDelay;
    string sTag;
    SetLocked(oChest, TRUE);
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        sTag = GetTag(oItem);
        if (MatchMeleeWeapon(oItem) || GetBaseItemType(oItem) == BASE_ITEM_GLOVES)
        {
            if (sTag == "SEED_VALIDATED" || GetStringLeft(sTag, 7) == "CRAFTED")
            {
                fDelay = EIX_ExtractStones(oItem, oPC, fDelay);
                DelayCommand(fDelay + 1.0, SetLocked(oChest, FALSE));
                return;
            }
        }
        if (MatchMeleeWeapon(oItem) && GetStringLeft(GetName(oItem),4)=="Epic")
        {
            SpeakString("Fap...fap..fap..fap.fap.fap");
            fDelay = EIX_ExtractStones(oItem, oPC, fDelay);
        }
        oItem = GetNextItemInInventory(oChest);
    }
    fDelay+=EIX_RemakeOldStones(oPC, oChest);
    DelayCommand(fDelay + 1.0, SetLocked(oChest, FALSE));
}


int EIX_ConstToCountDmg(int nDamageBonus)
{
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d4)  return 1;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d6)  return 2;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d4)  return 3;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d10) return 4;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d6)  return 5;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d8)  return 6;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d10) return 7;
    if (nDamageBonus == IP_CONST_DAMAGEBONUS_2d12) return 8;
    return FALSE;
}

int EIX_ConstToCountOnHit(int nDC)
{
    if (nDC == IP_CONST_ONHIT_SAVEDC_14)    return 1;
    if (nDC == IP_CONST_ONHIT_SAVEDC_16)    return 2;
    if (nDC == IP_CONST_ONHIT_SAVEDC_18)    return 3;
    if (nDC == IP_CONST_ONHIT_SAVEDC_20)    return 4;
    if (nDC == IP_CONST_ONHIT_SAVEDC_22)    return 5;
    if (nDC == IP_CONST_ONHIT_SAVEDC_24)    return 6;
    if (nDC == IP_CONST_ONHIT_SAVEDC_26)    return 7;
    return FALSE;
}

string EIX_ConstToTag(int nSubType)
{
    if (nSubType == IP_CONST_DAMAGETYPE_SONIC)         return "DMGS_SONIC";
    if (nSubType == IP_CONST_DAMAGETYPE_BLUDGEONING)   return "DMGS_BLUDGE";
    if (nSubType == IP_CONST_DAMAGETYPE_SLASHING)      return "DMGS_SLASH";
    if (nSubType == IP_CONST_DAMAGETYPE_PIERCING)      return "DMGS_PIERCE";
    if (nSubType == IP_CONST_DAMAGETYPE_NEGATIVE)      return "DMGS_NEGATIVE";
    if (nSubType == IP_CONST_DAMAGETYPE_DIVINE)        return "DMGS_DIVINE";
    if (nSubType == IP_CONST_DAMAGETYPE_MAGICAL)       return "DMGS_MAGIC";
    if (nSubType == IP_CONST_DAMAGETYPE_POSITIVE)      return "DMGS_POSITIVE";
    return "";
}

float EIX_ExtractStones(object oWeapon, object oPC, float fDelay=0.0, object oContainer=OBJECT_SELF)
{
    int nSuccess;
    int nType;
    int nSubType;
    int nCostTableValue;
    int nStoneCount;
    int nCount;
    string sStoneTag;
    itemproperty ipProperty = GetFirstItemProperty(oWeapon);
    while (GetIsItemPropertyValid(ipProperty))
    {
        if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_PERMANENT)
        {
            nType = GetItemPropertyType(ipProperty);
            if (nType == ITEM_PROPERTY_DAMAGE_BONUS)
            {
                nSubType = GetItemPropertySubType(ipProperty);
                sStoneTag = EIX_ConstToTag(nSubType);
                if (sStoneTag != "")
                {
                    nStoneCount = EIX_ConstToCountDmg(GetItemPropertyCostTableValue(ipProperty));

                    DelayCommand(0.1, RemoveItemProperty(oWeapon, ipProperty));
                    DelayCommand(fDelay, ActionSpeakString(IntToString(nStoneCount) + " * " + DMGS_GetStoneName(sStoneTag)));
                    for (nCount = 1; nCount <= nStoneCount; nCount++)
                    {
                        DelayCommand(fDelay, DMGS_ActionCreateStone(oPC, sStoneTag));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(DMGS_GetDmgVFX(nSubType)), OBJECT_SELF));
                        fDelay += 1.0;
                    }
                    nSuccess = TRUE;
                }
            }
            else if (nType == ITEM_PROPERTY_ON_HIT_PROPERTIES)
            {
                nSubType = GetItemPropertySubType(ipProperty);
                nStoneCount = EIX_ConstToCountOnHit(GetItemPropertyCostTableValue(ipProperty));
                DelayCommand(0.1, RemoveItemProperty(oWeapon, ipProperty));
                for (nCount = 1; nCount <= nStoneCount; nCount++)
                {
                    sStoneTag = PickOne("DMGS_DIVINE", "DMGS_MAGIC", "DMGS_POSITIVE");
                    DelayCommand(fDelay, ActionSpeakString("Converted On-Hit to " + DMGS_GetStoneName(sStoneTag)));
                    DelayCommand(fDelay, DMGS_ActionCreateStone(oContainer, sStoneTag));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(DMGS_GetDmgVFX(DMGS_GetStoneDmgType(sStoneTag))), OBJECT_SELF));
                    fDelay += 1.0;
                }
                nSuccess = TRUE;
            }
        }
        ipProperty = GetNextItemProperty(oWeapon);
    }
    if (nSuccess) DestroyObject(oWeapon);
    return fDelay;
}

int EIX_UpdateOldStoneDB(object oItem, object oPC)
{
    string sTag = GetName(oItem);
    int bSuccess = FindSubString(sTag, "#");
    if (bSuccess != -1)
    {
        string sACID = IntToString(dbGetACID(oPC));
        string sPLID = IntToString(dbGetPLID(oPC));

        bSuccess++;
        sTag = GetStringRight(sTag, GetStringLength(sTag) - bSuccess);
        NWNX_SQL_ExecuteQuery("select st_usedplid from stonetracker where st_stid=" + sTag);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            bSuccess = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
            if (bSuccess > 0)
            {
                Insured_Destroy(oItem);
                return FALSE;
            }
        }
        NWNX_SQL_ExecuteQuery("update stonetracker set st_used=now(), st_usedplid=" + sPLID + " where st_stid=" + sTag);
        Insured_Destroy(oItem);
        return TRUE;
    }
    Insured_Destroy(oItem);
    return FALSE;
}

string EIX_StringToTag(string sSubType)
{
    if (sSubType == "Sonic")         return "DMGS_SONIC";
    if (sSubType == "Bludgeoning")   return "DMGS_BLUDGE";
    if (sSubType == "Slashing")      return "DMGS_SLASH";
    if (sSubType == "Piercing")      return "DMGS_PIERCE";
    if (sSubType == "Negative")      return "DMGS_NEGATIVE";
    if (sSubType == "Divine")        return "DMGS_DIVINE";
    if (sSubType == "Magic")         return "DMGS_MAGIC";
    if (sSubType == "Positive")      return "DMGS_POSITIVE";
    if (sSubType == "Acid")          return "DMGS_ACID";
    if (sSubType == "Fire")          return "DMGS_FIRE";
    if (sSubType == "Cold")          return "DMGS_COLD";
    if (sSubType == "Electric")   return "DMGS_ELECTRICITY";
    return "ERROR String To Tag";
}

float EIX_RemakeOldStones(object oPC, object oContainer)
{
    string sName;
    float fDelay=0.0;
    object oItem = GetFirstItemInInventory(oContainer);
    while (GetIsObjectValid(oItem))
    {
        sName = GetName(oItem);
        if (GetStringLeft(sName, 5) == "Stone")
        {
            string sStone = GetSubString(sName, 9, GetStringLength(sName));
            if (StringToInt(GetSubString(sStone, FindSubString(sStone, "#")+1, GetStringLength(sStone))) < 12701)
            {
                fDelay+=1.0;
                DelayCommand(fDelay,ActionSpeakString("Remade a Stone of "+GetStringLeft(sStone, FindSubString(sStone, "#")-8)+" Damage."));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DESTRUCTION), OBJECT_SELF));
                DelayCommand(fDelay, DMGS_ActionCreateStone(oPC, EIX_StringToTag(GetStringLeft(sStone, FindSubString(sStone, "#")-8))));
                Insured_Destroy(oItem);
            }
        }
        oItem=GetNextItemInInventory(oContainer);
    }
    return fDelay;
}
