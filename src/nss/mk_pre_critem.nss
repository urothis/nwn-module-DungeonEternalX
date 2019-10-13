#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);
    int nPart =  GetLocalInt(OBJECT_SELF,"X2_TAILOR_CURRENT_PART");
    int nAppearance = 0;
    string sAppearance = "";

    switch (CIGetCurrentModMode(oPC))
    {
    case X2_CI_MODMODE_ARMOR:
        nAppearance = GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,nPart);
        {
            int nCondition0=0;
            if (MK_HasOppositePart(nPart))
            {
                int nPart2 = MK_GetOppositePart(nPart);
                if (GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,nPart)!=
                    GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,nPart2))
                {
                    nCondition0=1;
                }
            }
            MK_GenericDialog_SetCondition(0,nCondition0);
//            SetLocalInt(OBJECT_SELF, "MK_CONDITION_0", nCondition0);
        }
        break;
    case X2_CI_MODMODE_WEAPON:
        nAppearance = GetItemAppearance(oItem,ITEM_APPR_TYPE_WEAPON_MODEL,nPart) * 10+
                      GetItemAppearance(oItem,ITEM_APPR_TYPE_WEAPON_COLOR,nPart);
        break;
    case MK_CI_MODMODE_CLOAK:
        nAppearance = GetItemAppearance(oItem, 0, 0);
        sAppearance = Get2DAString("CloakModel", "LABEL", nAppearance);
        break;
    case MK_CI_MODMODE_HELMET:
        nAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, 0);
        break;
    case MK_CI_MODMODE_SHIELD:
        nAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
        break;
    }
    SetCustomToken(MK_TOKEN_PARTNUMBER, IntToString(nAppearance));
    SetCustomToken(MK_TOKEN_PARTSTRING, sAppearance);

    return TRUE;
}
