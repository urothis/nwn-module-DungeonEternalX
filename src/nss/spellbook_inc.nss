#include "gen_inc_color"

int SpellBookDoDesc(object oBook)
{
    int nID = 1; // switch IDs
    int nTotal, nCnt;
    string sMsg, sName, sCntMsg, sColor;
    while (nID <= 20)
    {
        nCnt = GetLocalInt(oBook, "SCROLL_CNT_" + IntToString(nID));
        sCntMsg = "";
        if (!nCnt)
        {
            sColor = GetRGB(10,10,10);
            sName = "Empty";
        }
        else
        {
            sColor = GetRGB(1,11,1);
            sName = GetLocalString(oBook, "SCROLL_NAME_" + IntToString(nID));
            sCntMsg = IntToString(nCnt) + " * ";
        }
        nTotal += nCnt;
        sMsg += sColor + "\nPage " + IntToString(nID) + ": " + sCntMsg + sName;
        nID++;
    }
    SetDescription(oBook, "You have stored " + IntToString(nTotal) + " Scrolls.\n" + sMsg + GetRGB());
    return nTotal;
}


void SpellBookDoWeight(object oBook, int nTotalCnt)
{
    itemproperty ipWeight = GetFirstItemProperty(oBook);
    while (GetIsItemPropertyValid(ipWeight))
    {
        if (GetItemPropertyType(ipWeight) == ITEM_PROPERTY_WEIGHT_INCREASE)
        {
            RemoveItemProperty(oBook, ipWeight);
        }
        ipWeight = GetNextItemProperty(oBook);
    }
    int nWeight = nTotalCnt/10; // 0.1 LBS per scroll
    int nAdded, nLBS;
    while (nWeight >= 5)
    {
        if (nWeight >= 100)
        {
            nLBS = IP_CONST_WEIGHTINCREASE_100_LBS;
            nAdded = 100;
        }
        else if (nWeight >= 50)
        {
            nLBS = IP_CONST_WEIGHTINCREASE_50_LBS;
            nAdded = 50;
        }
        else if (nWeight >= 30)
        {
            nLBS = IP_CONST_WEIGHTINCREASE_30_LBS;
            nAdded = 30;
        }
        else if (nWeight >= 15)
        {
            nLBS = IP_CONST_WEIGHTINCREASE_15_LBS;
            nAdded = 15;
        }
        else if (nWeight >= 10)
        {
            nLBS = IP_CONST_WEIGHTINCREASE_10_LBS;
            nAdded = 10;
        }
        else if (nWeight >= 5)
        {
            nLBS = IP_CONST_WEIGHTINCREASE_5_LBS;
            nAdded = 5;
        }
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(nLBS), oBook);
        nWeight = nWeight - nAdded;
    }
}
//void main(){}
