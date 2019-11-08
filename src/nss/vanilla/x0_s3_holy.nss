//::///////////////////////////////////////////////
//:: Holy Water
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "pc_inc"

int CryptRingGetSuccess(object oPC, object oTarget, object oItem, string sTag, int nLvl)
{
    float fLvl = IntToFloat(nLvl);
    float fCR = GetChallengeRating(oTarget);
    if (fLvl <= fCR + 2.0)
    {
        int nCnt = GetLocalInt(oItem, sTag) + 1;
        SetLocalInt(oItem, sTag, nCnt);
        return TRUE;
    }
    if (nLvl > 13) FloatingTextStringOnCreature("The ring is fully loaded.", oPC);
    else FloatingTextStringOnCreature("You have to find stronger creatures", oPC);
    return FALSE;
}

void CryptRingDoEnhancement(object oPC, object oItem, int nLvl)
{
    int nItemLvl = GetLocalInt(oItem, "QUEST_CRYPT_RING");
    int nAC, nLight;
    if (nLvl >= 2 && nItemLvl == 0)
    {
        nAC = 2;
        SetLocalInt(oItem, "QUEST_CRYPT_RING", 1);
        FloatingTextStringOnCreature("The ring feels more powerfull now", oPC);
        DelayCommand(0.5, UnequipItem(oPC, oItem));
    }
    if (nLvl >= 4 && nItemLvl == 1)
    {
        nAC = 3;
        SetLocalInt(oItem, "QUEST_CRYPT_RING", 2);
        FloatingTextStringOnCreature("The ring feels more powerfull now", oPC);
        DelayCommand(0.5, UnequipItem(oPC, oItem));
    }
    if (nLvl >= 6 && nItemLvl == 2)
    {
        nAC = 4;
        nLight = IP_CONST_LIGHTBRIGHTNESS_LOW;
        SetLocalInt(oItem, "QUEST_CRYPT_RING", 3);
        FloatingTextStringOnCreature("The ring feels more powerfull now", oPC);
        DelayCommand(0.5, UnequipItem(oPC, oItem));
    }
    if (nLvl >= 8 && nItemLvl == 3)
    {
        nAC = 5;
        nLight = IP_CONST_LIGHTBRIGHTNESS_BRIGHT;
        SetLocalInt(oItem, "QUEST_CRYPT_RING", 4);
        FloatingTextStringOnCreature("The ring feels more powerfull now", oPC);
        DelayCommand(0.5, UnequipItem(oPC, oItem));
    }
    if (nLvl >= 10 && nItemLvl == 4)
    {
        IPSafeAddItemProperty(oItem, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_10, IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY));
        nLight = IP_CONST_LIGHTBRIGHTNESS_BRIGHT;
        SetLocalInt(oItem, "QUEST_CRYPT_RING", 5);
        FloatingTextStringOnCreature("The ring feels more powerfull now", oPC);
        DelayCommand(0.5, UnequipItem(oPC, oItem));
    }

    if (nAC) IPSafeAddItemProperty(oItem, ItemPropertyACBonusVsRace(RACIAL_TYPE_UNDEAD, nAC));
    if (nLight) IPSafeAddItemProperty(oItem, ItemPropertyLight(nLight, IP_CONST_LIGHTCOLOR_WHITE));
    if (nAC || nLight) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oPC);
}


void main()
{
    object oItem = GetSpellCastItem();
    int nDoQuest;
    object oTarget;
    if (GetIsObjectValid(oItem) && GetTag(oItem) == "QUEST_CRYPT_RING")
    {
        object oPC = OBJECT_SELF;
        int nLvl = pcGetRealLevel(oPC);
        int nLvlStoredOnItem = GetLocalInt(oItem, "QUEST_CRYPT_RING_PCLVL");
        if (nLvl < nLvlStoredOnItem)
        {
            // player de-lvled
            FloatingTextStringOnCreature("De-lvled character, item destroyed", oPC);
            Insured_Destroy(oItem);
            return;
        }
        if (nLvl > nLvlStoredOnItem) SetLocalInt(oItem, "QUEST_CRYPT_RING_PCLVL", nLvl);

        object oTarget = GetSpellTargetObject();
        int nDmg = GetCurrentHitPoints(oTarget);
        if (!GetIsPC(oTarget) && nLvl < 13)
        {
            string sTag = GetTag(oTarget);
            if (sTag == "ZOMBIE")
            {
                nDoQuest = CryptRingGetSuccess(oPC, oTarget, oItem, sTag, nLvl);
                CryptRingDoEnhancement(oPC, oItem, nLvl);
            }
            else if (sTag == "CRYPT_ZOMBIE")
            {
                nDoQuest = CryptRingGetSuccess(oPC, oTarget, oItem, sTag, nLvl);
                CryptRingDoEnhancement(oPC, oItem, nLvl);
            }
            else if (sTag == "SKELLY_BRAWLER")
            {
                nDoQuest = CryptRingGetSuccess(oPC, oTarget, oItem, sTag, nLvl);
                CryptRingDoEnhancement(oPC, oItem, nLvl);
            }
            else if (sTag == "SKELLY_MAGE")
            {
                nDoQuest = CryptRingGetSuccess(oPC, oTarget, oItem, sTag, nLvl);
                CryptRingDoEnhancement(oPC, oItem, nLvl);
            }
            else if (sTag == "SKELLY_WIZARD")
            {
                nDoQuest = CryptRingGetSuccess(oPC, oTarget, oItem, sTag, nLvl);
                CryptRingDoEnhancement(oPC, oItem, nLvl);
            }
            else if (sTag == "SKELLY_PRIEST")
            {
                nDoQuest = CryptRingGetSuccess(oPC, oTarget, oItem, sTag, nLvl);
                CryptRingDoEnhancement(oPC, oItem, nLvl);
            }
        }
        if (nDoQuest == TRUE)
        {
            DoGrenade(nDmg, nDmg, VFX_IMP_HEAD_HOLY, VFX_IMP_DEATH, DAMAGE_TYPE_DIVINE, RADIUS_SIZE_SMALL, OBJECT_TYPE_CREATURE, RACIAL_TYPE_UNDEAD);
            return;
        }
    }
    DoGrenade(d4(2),1, VFX_IMP_HEAD_HOLY, VFX_FNF_LOS_NORMAL_20, DAMAGE_TYPE_DIVINE, RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE, RACIAL_TYPE_UNDEAD);
}
