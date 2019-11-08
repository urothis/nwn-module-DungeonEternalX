//::///////////////////////////////////////////////
//:: x2_inc_ws_smith
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Main include file for the weapon upgrade smith.

    * Nov 5th 2003 (BK)
     - Unlimited ammo property is now +5 not +3
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

//****************************************************
// * Constants
//****************************************************
#include "x2_inc_itemprop"

// Tokens
const int WeaponToken = 9809;
  const int CostOfAcid = 9711;  // All elemental damages use this.
  const int CostOfHaste = 9712;
  const int CostOfKeen = 9713;
  const int CostOfTrueSeeing = 9714;
  const int CostOfSpellResistance = 9715;
  const int CostOfRegeneration2 = 9716;
  const int CostOfEnhancement = 9717;

  // * Ranged
  const int CostOfAttackBonus = 9611;
  const int CostOfMighty1 = 9615;
  const int CostOfMighty2 = 9616;
  const int CostOfMighty3 = 9617;
  const int CostOfMighty4 = 9618;
  const int CostOfMighty5 = 9612;
  const int CostOfMighty10 = 9613;
  const int CostOfUnlimited3 = 9614;
  const int CostOfUnlimited0 = 9619;

// Prices
 // All elemental damages use this.

const int WS_COST_ACID_PROPERTY_1 = 3948;
const int WS_COST_ACID_PROPERTY_2 = 10380;
const int WS_COST_ACID_PROPERTY_3 = 13810;
const int WS_COST_ACID_PROPERTY_4 = 24530;
const int WS_COST_ACID_PROPERTY_5 = 24530;
const int WS_COST_ACID_PROPERTY_1D4 = 3948;
const int WS_COST_ACID_PROPERTY_1D6 = 10380;
const int WS_COST_ACID_PROPERTY_1D8 = 13810;
const int WS_COST_ACID_PROPERTY_1D10 = 24530;
const int WS_COST_ACID_PROPERTY_2D6 = 17730;

//const int WS_COST_ATTACK_BONUS = 30000;
const int WS_COST_ENHANCEMENT_BONUS = 1648;
const int WS_COST_HASTE = 150000;
const int WS_COST_KEEN = 2030;
const int WS_COST_TRUESEEING = 30000;
const int WS_COST_SPELLRESISTANCE = 75000;
const int WS_COST_REGENERATION2 = 75000;
const int WS_COST_MIGHTY_1 = 160;
const int WS_COST_MIGHTY_2 = 510;
const int WS_COST_MIGHTY_3 = 1110;
const int WS_COST_MIGHTY_4 = 1960;
const int WS_COST_MIGHTY_5 = 3060;
const int WS_COST_MIGHTY_10 = 5000;
const int WS_COST_UNLIMITED_3 = 100000;
const int WS_COST_UNLIMITED_0 = 8060;

// * Other Constants -- needed to make "fake" constants for some item property
const int IP_CONST_WS_ATTACK_BONUS = 19000;
const int IP_CONST_WS_ENHANCEMENT_BONUS = 19001;
const int IP_CONST_WS_HASTE = 19002;
const int IP_CONST_WS_KEEN = 19003;
const int IP_CONST_WS_TRUESEEING = 19005;
const int IP_CONST_WS_SPELLRESISTANCE = 19006;
const int IP_CONST_WS_REGENERATION = 19007;
const int IP_CONST_WS_MIGHTY_1 = 19011;
const int IP_CONST_WS_MIGHTY_2 = 19012;
const int IP_CONST_WS_MIGHTY_3 = 19013;
const int IP_CONST_WS_MIGHTY_4 = 19014;
const int IP_CONST_WS_MIGHTY_5 = 19008;
const int IP_CONST_WS_MIGHTY_10 = 19009;
const int IP_CONST_WS_UNLIMITED_3 = 19010;
const int IP_CONST_WS_UNLIMITED_0 = 19015;

const int MAX_ENHANCEMENT_BONUS = 5;
const int MAX_ATTACK_BONUS = 5;

//****************************************************
// * Declaration
//****************************************************
void SetWeaponToken(object oPC);
// * Function checks against WS_ properties to
// * see if its okay to add this item property
int IsOkToAdd(object oPC, int nPropertyCode);
object GetRightHandWeapon(object oPC);
// * sets all custom tokens for the prices of services
void wsSetupPrices();
// * A variable has been set earlier to indicate
// * which item property you want to add
// * now it tests to see if you have enough
// * gold for that item property
int wsHaveEnoughGoldForCurrentItemProperty(object oPC);
// * MAJOR
// * Actual function to add the enhancement to the item
void wsEnhanceItem(object oWielder, object oPC);
// * Returns the correct item proeprty based upon nType
// * oItem is passed in to find specific information about the
// * current item
itemproperty ReturnItemPropertyToUse(int nType, object oItem);
// * Returns total attack bonus for the item
int ReturnAttackBonus(object oItem);
// * Returns total enhancement bonus for the item
int ReturnEnhancementBonus(object oItem);

//****************************************************
// * Implementation
//****************************************************

void SetWeaponToken(object oPC)
{
    // * Get Name of weapon
    // * Assumption -- a weapon is being held
    // * in the main hand
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    string sWeaponName = "";
    if (GetIsObjectValid(oItem) == TRUE)
    {
        sWeaponName = GetName(oItem);
    }
    else
    {
        return;
    }
    SetCustomToken(WeaponToken, sWeaponName);
}
object GetRightHandWeapon(object oPC)
{
    return  GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
}
// * Function checks against WS_ properties to
// * see if its okay to add this item property
int IsOkToAdd(object oPC, int nPropertyCode)
{
    object oItem = GetRightHandWeapon(oPC);

    // * Always okay to add attack or enhancement bonuses, up to +10
    /*if (nPropertyCode ==  IP_CONST_WS_ATTACK_BONUS)
    {
        int nEnh = ReturnEnhancementBonus(oItem);
        if (nEnh < 5)
            return TRUE;
        else
            return FALSE;
    }
    else */
    if (nPropertyCode == IP_CONST_WS_ENHANCEMENT_BONUS)
    {
        int nEnh = ReturnEnhancementBonus(oItem);
        if (nEnh < 5)
            return TRUE;
        else
            return FALSE;

    }

    itemproperty ip = ReturnItemPropertyToUse(nPropertyCode, oItem);
    int nMatchSubType = TRUE;


    // * Its okay to add these item properties as long as the subtype does not match
    nMatchSubType = TRUE;

    int bOkToAdd = IPGetItemHasProperty(oItem,ip, -1, TRUE);
    if (bOkToAdd == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}
// * this function added to balance out cost of very high magical item
// * modification (so its not super cheat to get a +10 weapon)
int InflateCost(int nGoldNeed)
{
    // * Modifier (November 5 2003 -- Up the price if this item already
    // * has numerous other enchancement bonuses
        object oItem = GetRightHandWeapon(GetPCSpeaker());
        int nBonus = ReturnEnhancementBonus(oItem);
        int iKeen = GetItemHasItemProperty(oItem, ITEM_PROPERTY_KEEN);
        int iEle = GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS);

        if (iKeen)
        {
            nBonus = nBonus + 1;
        }
        if (iEle)
        {
            nBonus = nBonus + 1;
        }

        switch (nBonus)
            {
                case 0:
                {
                    break;
                }
                case 1:
                {
                    nGoldNeed = nGoldNeed + 5602;
                    break;
                }
                case 2:
                {
                    nGoldNeed = nGoldNeed + 15202;
                    break;
                }
                case 3:
                {
                    nGoldNeed = nGoldNeed + 28802;
                    break;
                }
                case 4:
                {
                    nGoldNeed = nGoldNeed + 46402;
                    break;
                }
                case 5:
                {
                    nGoldNeed = nGoldNeed + 142882;
                    break;
                }
                case 6:
                {
                    nGoldNeed = nGoldNeed + 240382;
                    break;
                }
                case 7:
                {
                    nGoldNeed = nGoldNeed + 390382;
                    break;
                }
            }
        return nGoldNeed;
}


// * sets all custom tokens for the prices of services
void wsSetupPrices()
{
    object oNPC = GetObjectByTag("Frane");
    int iVal = GetLocalInt(oNPC, "dmgvalue");

    //SetCustomToken(CostOfAttackBonus, IntToString(WS_COST_ATTACK_BONUS));
    SetCustomToken(CostOfEnhancement, IntToString(InflateCost(WS_COST_ENHANCEMENT_BONUS)));

    SetCustomToken(CostOfHaste, IntToString(WS_COST_HASTE));
    SetCustomToken(CostOfKeen, IntToString(WS_COST_KEEN));
    SetCustomToken(CostOfTrueSeeing, IntToString(WS_COST_TRUESEEING));
    SetCustomToken(CostOfSpellResistance, IntToString(WS_COST_SPELLRESISTANCE));
    SetCustomToken(CostOfRegeneration2, IntToString(WS_COST_REGENERATION2));

    //switch (iMight)
    //{
       // case 1:
    SetCustomToken(CostOfMighty1, IntToString(WS_COST_MIGHTY_1));
    SetCustomToken(CostOfMighty2, IntToString(WS_COST_MIGHTY_2));
    SetCustomToken(CostOfMighty3, IntToString(WS_COST_MIGHTY_3));
    SetCustomToken(CostOfMighty4, IntToString(WS_COST_MIGHTY_4));
    SetCustomToken(CostOfMighty5, IntToString(WS_COST_MIGHTY_5));
    SetCustomToken(CostOfMighty10, IntToString(WS_COST_MIGHTY_10));
    SetCustomToken(CostOfUnlimited3, IntToString(WS_COST_UNLIMITED_3));
    SetCustomToken(CostOfUnlimited0, IntToString(WS_COST_UNLIMITED_0));

    switch (iVal)
    {
        case 0:
        {
            SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY_2D6));
            break;
        }
        case 1:
        {
            SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY_1D6));
            break;
        }
        case 2:
        {
            SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY_1));
            break;
        }
        case 3:
        {
            SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY_2));
            break;
        }
        case 4:
        {
            SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY_3));
            break;
        }
        case 5:
        {
            SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY_4));
            break;
        }
        case 6:
        {
            SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY_5));
            break;
        }
        case 7:
        {
            SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY_1D4));
            break;
        }
        case 8:
        {
            SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY_1D8));
            break;
        }
        case 9:
        {
            SetCustomToken(CostOfAcid, IntToString(WS_COST_ACID_PROPERTY_1D10));
            break;
        }
    }
}


int GetGoldValueForService(int nService)
{
    int nGoldNeed = 0;
    switch (nService)
    {
        case IP_CONST_DAMAGETYPE_ACID:
        case IP_CONST_DAMAGETYPE_FIRE:
        case IP_CONST_DAMAGETYPE_COLD:
        case IP_CONST_DAMAGETYPE_ELECTRICAL:
        {
            object oNPC = GetObjectByTag("Frane");
            int iVal = GetLocalInt(oNPC, "dmgvalue");
            switch (iVal)
            {
                case 0: nGoldNeed = WS_COST_ACID_PROPERTY_2D6;
                        nGoldNeed = InflateCost(nGoldNeed);
                    break;
                case 1: nGoldNeed = WS_COST_ACID_PROPERTY_1D6;
                        nGoldNeed = InflateCost(nGoldNeed);
                    break;
                case 2: nGoldNeed = WS_COST_ACID_PROPERTY_1;
                        nGoldNeed = InflateCost(nGoldNeed);
                    break;
                case 3: nGoldNeed = WS_COST_ACID_PROPERTY_2;
                        nGoldNeed = InflateCost(nGoldNeed);
                    break;
                case 4: nGoldNeed = WS_COST_ACID_PROPERTY_3;
                        nGoldNeed = InflateCost(nGoldNeed);
                    break;
                case 5: nGoldNeed = WS_COST_ACID_PROPERTY_4;
                        nGoldNeed = InflateCost(nGoldNeed);
                    break;
                case 6: nGoldNeed = WS_COST_ACID_PROPERTY_5;
                        nGoldNeed = InflateCost(nGoldNeed);
                    break;
                case 7: nGoldNeed = WS_COST_ACID_PROPERTY_1D4;
                        nGoldNeed = InflateCost(nGoldNeed);
                    break;
                case 8: nGoldNeed = WS_COST_ACID_PROPERTY_1D8;
                        nGoldNeed = InflateCost(nGoldNeed);
                    break;
                case 9: nGoldNeed = WS_COST_ACID_PROPERTY_1D10;
                        nGoldNeed = InflateCost(nGoldNeed);
                    break;
            }
            break;
        }
        //case IP_CONST_WS_ATTACK_BONUS: nGoldNeed = WS_COST_ATTACK_BONUS; break;
        case IP_CONST_WS_ENHANCEMENT_BONUS:
        {
            nGoldNeed = WS_COST_ENHANCEMENT_BONUS;
            nGoldNeed = InflateCost(nGoldNeed);
            break;
        }
        case IP_CONST_WS_HASTE: nGoldNeed = WS_COST_HASTE; break;
        case IP_CONST_WS_KEEN:
        {
            nGoldNeed = WS_COST_KEEN;
            nGoldNeed = InflateCost(nGoldNeed);
            break;
        }
        case IP_CONST_WS_TRUESEEING: nGoldNeed = WS_COST_TRUESEEING;break;
        case IP_CONST_WS_SPELLRESISTANCE: nGoldNeed = WS_COST_SPELLRESISTANCE; break;
        case IP_CONST_WS_REGENERATION: nGoldNeed = WS_COST_REGENERATION2; break;
        case IP_CONST_WS_MIGHTY_1: nGoldNeed = WS_COST_MIGHTY_1; break;
        case IP_CONST_WS_MIGHTY_2: nGoldNeed = WS_COST_MIGHTY_2; break;
        case IP_CONST_WS_MIGHTY_3: nGoldNeed = WS_COST_MIGHTY_3; break;
        case IP_CONST_WS_MIGHTY_4: nGoldNeed = WS_COST_MIGHTY_4; break;
        case IP_CONST_WS_MIGHTY_5: nGoldNeed = WS_COST_MIGHTY_5; break;
        case IP_CONST_WS_MIGHTY_10: nGoldNeed = WS_COST_MIGHTY_10; break;
        case IP_CONST_WS_UNLIMITED_3: nGoldNeed = WS_COST_UNLIMITED_3; break;
        case IP_CONST_WS_UNLIMITED_0: nGoldNeed = WS_COST_UNLIMITED_0; break;
    }
    SetCustomToken(9713, IntToString(nGoldNeed));
    return nGoldNeed;
}

/*int GetMeetsILR(object oPC, object oItem)
{
    int nLevel=GetHitDice(oPC)-1;
    int nGP=GetGoldPieceValue(oItem);
    return (StringToInt(Get2DAString("itemvalue","MAXSINGLEITEMVALUE", nLevel))<=nGP);
}
*/

int GetItemLevelRequirement(object oItem, int nGP)
{
    int nCost=GetGoldPieceValue(oItem);
    nCost = nCost + nGP;

    if (nCost==0) return 0;
    if (nCost<=1000) return 1;
    else if (nCost<=1500) return 2;
    else if (nCost<=2500) return 3;
    else if (nCost<=3500) return 4;
    else if (nCost<=5000) return 5;
    else if (nCost<=6500) return 6;
    else if (nCost<=9000) return 7;
    else if (nCost<=12000) return 8;
    else if (nCost<=15000) return 9;
    else if (nCost<=19500) return 10;
    else if (nCost<=25000) return 11;
    else if (nCost<=30000) return 12;
    else if (nCost<=35000) return 13;
    else if (nCost<=40000) return 14;
    else if (nCost<=50000) return 15;
    else if (nCost<=65000) return 16;
    else if (nCost<=75000) return 17;
    else if (nCost<=90000) return 18;
    else if (nCost<=110000) return 19;
    else if (nCost<=130000) return 20;
    else if (nCost<=250000) return 21;
    else if (nCost<=500000) return 22;
    else if (nCost<=750000) return 23;
    else if (nCost<=1000000) return 24;
    else if (nCost<=1200000) return 25;
    else if (nCost<=1400000) return 26;
    else if (nCost<=1600000) return 27;
    else if (nCost<=1800000) return 28;
    else if (nCost<=2000000) return 29;
    else if (nCost<=2200000) return 30;
    else if (nCost<=2400000) return 31;
    else if (nCost<=2600000) return 32;
    else if (nCost<=2800000) return 33;
    else if (nCost<=3000000) return 34;
    else if (nCost<=3200000) return 35;
    else if (nCost<=3400000) return 36;
    else if (nCost<=3600000) return 37;
    else if (nCost<=3800000) return 38;
    else if (nCost<=4000000) return 39;
    else if (nCost<=4200000) return 40;
    else if (nCost<=4400000) return 41;
    else if (nCost<=4600000) return 42;
    else if (nCost<=4800000) return 43;
    else if (nCost<=5000000) return 44;
    else if (nCost<=5200000) return 45;
    else if (nCost<=5400000) return 46;
    else if (nCost<=5600000) return 47;
    else if (nCost<=5800000) return 48;
    else if (nCost<=6000000) return 49;
    else if (nCost<=6200000) return 50;
    else if (nCost<=6400000) return 51;
    else if (nCost<=6600000) return 52;
    else if (nCost<=6800000) return 53;
    else if (nCost<=7000000) return 54;
    else if (nCost<=7200000) return 55;
    else if (nCost<=7400000) return 56;
    else if (nCost<=7600000) return 57;
    else if (nCost<=7800000) return 58;
    else if (nCost<=8000000) return 59;
    else if (nCost<=8200000) return 60;
    else return 0;
}

// * A variable has been set earlier to indicate
// * which item property you want to add
// * now it tests to see if you have enough
// * gold for that item property
int wsHaveEnoughGoldForCurrentItemProperty(object oPC)
{
    object oItem = GetRightHandWeapon(oPC);
    int nGoldHave = GetGold(oPC);
    int nCurrentItemProperty = GetLocalInt(OBJECT_SELF, "X2_LAST_PROPERTY");
    int nGoldNeed = GetGoldValueForService(nCurrentItemProperty);
    int nLvl = GetItemLevelRequirement(oItem, nGoldNeed);
    SetCustomToken(9719, "1");
    nLvl = nLvl + 2;

    if (nGoldHave >= nGoldNeed)
    {
        SetCustomToken(9719, IntToString(nLvl));
        return TRUE;
    }
    return FALSE;
}

// * Returns total attack bonus for the item
/*int ReturnAttackBonus(object oItem)
{
    itemproperty ipFirst = GetFirstItemProperty(oItem);
    int nBonus = 0;
    while (GetIsItemPropertyValid(ipFirst) == TRUE)
    {
        if (GetItemPropertyType(ipFirst) == ITEM_PROPERTY_ATTACK_BONUS)
        {
            int nSubType = GetItemPropertyCostTableValue(ipFirst);
            //SpeakString("Found an attack bonus! " + IntToString(nSubType));
            nBonus = nBonus + (nSubType);
            return nBonus; // * Quick exit. Got what I need
        }
        ipFirst = GetNextItemProperty(oItem);
    }
    //SpeakString("Attack Bonus = " + IntToString(nBonus));
    return nBonus;
} */
// * Returns total enhancement bonus for the item
int ReturnEnhancementBonus(object oItem)
{
    itemproperty ipFirst = GetFirstItemProperty(oItem);
    int nBonus = 0;
    while (GetIsItemPropertyValid(ipFirst) == TRUE)
    {
        if (GetItemPropertyType(ipFirst) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            int nSubType = GetItemPropertyCostTableValue(ipFirst);
            //SpeakString("Found an attack bonus! SubType = " + IntToString(nSubType));
            nBonus = nBonus + (nSubType);
            return nBonus; // * Quick exit. Got what I need
        }
        ipFirst = GetNextItemProperty(oItem);
    }
    //SpeakString("Attack Bonus = " + IntToString(nBonus));
    return nBonus;
}

// * Returns the correct item proeprty based upon nType
// * oItem is passed in to find specific information about the
// * current item
itemproperty ReturnItemPropertyToUse(int nType, object oItem)
{
    itemproperty ip;
    switch(nType)
    {
        case IP_CONST_DAMAGETYPE_ACID:
        case IP_CONST_DAMAGETYPE_FIRE:
        case IP_CONST_DAMAGETYPE_COLD:
        case IP_CONST_DAMAGETYPE_ELECTRICAL:
        {
            object oNPC = GetObjectByTag("Frane");
            int nValue = GetLocalInt(oNPC, "dmgvalue");
            switch (nValue)
            {
                case 0:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_2d6);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
                case 1:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_1d6);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
                case 2:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_1);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
                case 3:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_2);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
                case 4:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_3);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
                case 5:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_4);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
                case 6:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_5);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
                case 7:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_1d4);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
                case 8:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_1d8);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
                case 9:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_1d10);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
                default:
                {
                    ip =ItemPropertyDamageBonus(nType, IP_CONST_DAMAGEBONUS_1);
                    SetLocalInt(oNPC, "dmgvalue", 0);
                    break;
                }
            //break;
            }
            break;
        }
        /*case IP_CONST_WS_ATTACK_BONUS:
        {
            int nNewBonus = ReturnAttackBonus(oItem) + 1;

            ip = ItemPropertyAttackBonus(nNewBonus);
            break;
        } */
        case IP_CONST_WS_ENHANCEMENT_BONUS:
        {

            int nNewBonus = ReturnEnhancementBonus(oItem) + 1;

            ip = ItemPropertyEnhancementBonus(nNewBonus);
            break;
        }
        case IP_CONST_WS_HASTE:
        {
            ip = ItemPropertyHaste();
            break;
        }
        case IP_CONST_WS_KEEN:
        {
            ip = ItemPropertyKeen();
            break;
        }
        case IP_CONST_WS_TRUESEEING:
        {
            ip = ItemPropertyTrueSeeing();
            break;
        }
        case IP_CONST_WS_SPELLRESISTANCE:
        {
            ip = ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20);
            break;
        }
        case IP_CONST_WS_REGENERATION:
        {
            ip = ItemPropertyRegeneration(2);
            break;
        }
        case IP_CONST_WS_MIGHTY_1:
        {
            ip = ItemPropertyMaxRangeStrengthMod(1);
            break;
        }
        case IP_CONST_WS_MIGHTY_2:
        {
            ip = ItemPropertyMaxRangeStrengthMod(2);
            break;
        }
        case IP_CONST_WS_MIGHTY_3:
        {
            ip = ItemPropertyMaxRangeStrengthMod(3);
            break;
        }
        case IP_CONST_WS_MIGHTY_4:
        {
            ip = ItemPropertyMaxRangeStrengthMod(4);
            break;
        }
        case IP_CONST_WS_MIGHTY_5:
        {
            ip = ItemPropertyMaxRangeStrengthMod(5);
            break;
        }
        case IP_CONST_WS_MIGHTY_10:
        {
            ip = ItemPropertyMaxRangeStrengthMod(10);
            break;
        }
        case IP_CONST_WS_UNLIMITED_3:
        {
            ip = ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_PLUS5);
            break;
        }
        case IP_CONST_WS_UNLIMITED_0:
        {
            ip = ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_BASIC);
            break;
        }

    }
    return ip;

}
// * MAJOR
// * Actual function to add the enhancement to the item
// * Also takes the gold
void wsEnhanceItem(object oWielder, object oPC)
{
    object oItem = GetRightHandWeapon(oWielder);
    int nCurrentItemProperty = GetLocalInt(OBJECT_SELF, "X2_LAST_PROPERTY");
    int nGoldToTake = GetGoldValueForService(nCurrentItemProperty);
    //SpeakString("Enhance " + GetName(oItem));

    // * if player tries to cheat just abort the item creation. (You can only have
    // * this happen by moving your gold out of your inventory as you are talking).
    if (GetGold(oPC) < nGoldToTake)
    {
        return;
    }
    TakeGoldFromCreature(nGoldToTake, oPC, FALSE);
    // * GZ: Remove all temporary item properties from oItem to counter bug #35259
    IPRemoveAllItemProperties(oItem,DURATION_TYPE_TEMPORARY);
    itemproperty ip =  ReturnItemPropertyToUse(nCurrentItemProperty, oItem);
    IPSafeAddItemProperty(oItem, ip, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}

