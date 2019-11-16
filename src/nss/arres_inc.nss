#include "x2_inc_itemprop"
#include "inc_wep_ac_bon"

void GiveArresAura(object oPC);
int RandomChance(int nChance, object oPC);
int GetHighestClass(object oPC);
int CheckDMItem(object oPC, object oItem);
int GetLevelByXP(int nXP);
int GetXPReqByLevel(int nLevel);
void CheckAllItems(object oPC);
void DestroyIllegalItem(object oPC, object oItem);
int CheckMeetRequirement(object oPC, object oItem);
int GetIsPureFighter(object oPC);
void CursePC(object oPC);
void Debug(object oPC, string sMsg);
void PolyWithMerge(object oPC, int nPoly, float nDuration, int bDoMerge = FALSE);

int RandomChance(int nChance, object oPC) {
    int nNum = Random(nChance);
    Debug(oPC, "Roll: " + IntToString(nNum));
    return !nNum || GetLocalInt(oPC, "IAMARRES");
}

int GetHighestClass(object oPC) {
    int classLvl1 = GetLevelByPosition(1, oPC);
    int classLvl2 = GetLevelByPosition(2, oPC);
    int classLvl3 = GetLevelByPosition(3, oPC);

    if(classLvl1 >= classLvl2 && classLvl1 >= classLvl3) return GetClassByPosition(1, oPC);
    if(classLvl2 >= classLvl2 && classLvl2 >= classLvl3) return GetClassByPosition(2, oPC);
    if(classLvl3 >= classLvl1 && classLvl3 >= classLvl2) return GetClassByPosition(3, oPC);

    return CLASS_TYPE_INVALID;
}

int CheckDMItem(object oPC, object oItem) {
    if (!GetIsDM(oPC) && !GetLocalInt(oPC, "IAMADEV")) {
        DestroyObject(oItem);
        SendMessageToPC(oPC, "You are not a DM.");
        return FALSE;
    }
    return TRUE;
}

int GetLevelByXP(int nXP) {   // this will give the current level based on XP even if the character didn't level his character yet
    int i;
    for(i = 1; i <= 40; i++) {
        int iXP = i * (i - 1) * 500;
        if(iXP > nXP)
            return i;
    }
    return 40; // the character has more XP than level 40
}


int GetXPReqByLevel(int nLevel) {
    return nLevel * (nLevel - 1) * 500;
}

void CheckAllItems(object oPC)
{
    object oItem;
    int nSlot;
    for (nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; nSlot++)
    {
        oItem = GetItemInSlot(nSlot, oPC);

        if (GetIsObjectValid(oItem))
        {
            IPRemoveAllItemProperties(oItem, DURATION_TYPE_TEMPORARY);
            DestroyIllegalItem(oPC, oItem);
        }
    }
}

void DestroyIllegalItem(object oPC, object oItem)
{
    string sResRef  = GetResRef(oItem);
    if (sResRef == "fi_mail2"   || sResRef == "fi_boots_str004" ||
        sResRef == "fi_boots2"  || sResRef == "fi_boots_dex004" ||
        sResRef == "fi_robe2"   || sResRef == "fi_bracers026"   ||
        sResRef == "fi_helm005" || sResRef == "fi_leather2"     ||
        sResRef == "fi_belt002" || sResRef == "fi_helm003")
    {
        DestroyObject(oItem);
    }
}

int CheckMeetRequirement(object oPC, object oItem) {
    string sResRef  = GetResRef(oItem);
    if(sResRef =="fi_mail2"
    || sResRef == "fi_leather2"
    || sResRef == "fi_robe2"
    || sResRef == "fi_boots2"
    || sResRef == "fi_boots_dex004"
    || sResRef == "fi_boots_str004"
    || sResRef == "fi_bracers026"
    || sResRef == "fi_helm005")
        return GetIsPureFighter(oPC);
    if(sResRef == "fi_belt002"){
        if (GetIsPureFighter(oPC) && GetLevelByClass(CLASS_TYPE_RANGER, oPC))
        return TRUE;
    }
    return FALSE;
}

int GetIsPureFighter(object oPC) {
    int nFighter = GetLevelByClass(CLASS_TYPE_FIGHTER, oPC);
    int nDefender = GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER, oPC);
    int nRanger = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
    int nBlackGuard = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
    int nSumNF = nDefender + nRanger + nBlackGuard;
    int nSumAll = nFighter + nSumNF;
    if (nFighter >= nSumNF && nSumAll == GetHitDice(oPC)) return TRUE;
    else return FALSE;

}

void CursePC(object oPC) {
    effect eCurse = EffectCurse(GetAbilityScore(oPC, ABILITY_STRENGTH)     - 8,
                                GetAbilityScore(oPC, ABILITY_DEXTERITY)    - 8,
                                GetAbilityScore(oPC, ABILITY_CONSTITUTION) - 8,
                                GetAbilityScore(oPC, ABILITY_INTELLIGENCE) - 8,
                                GetAbilityScore(oPC, ABILITY_WISDOM)       - 8,
                                GetAbilityScore(oPC, ABILITY_CHARISMA)     - 8);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOOM), oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurse, oPC, 60.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 0.1);
}

void PolyWithMerge(object oPC, int nPoly, float nDuration, int bDoMerge = FALSE) {
    //--------------------------------------------------------------------------
    // Store the old objects so we can access them after the character has
    // changed into his new form
    //--------------------------------------------------------------------------
    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST,     oPC);
    object oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,  oPC);
    object oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,      oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,     oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,     oPC);
    object oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,      oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,      oPC);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oPC);

    if (GetIsObjectValid(oShield)) {
        if (GetBaseItemType(oShield) != BASE_ITEM_LARGESHIELD
         && GetBaseItemType(oShield) != BASE_ITEM_SMALLSHIELD
         && GetBaseItemType(oShield) != BASE_ITEM_TOWERSHIELD) {
            oShield = OBJECT_INVALID;
        }
    }

    //--------------------------------------------------------------------------
    // Here the actual polymorphing is done
    //--------------------------------------------------------------------------
    effect ePoly = ExtraordinaryEffect(EffectPolymorph(nPoly));
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, nDuration);
    SignalEvent(oPC, EventSpellCastAt(oPC, GetSpellId(), FALSE));

    if (!bDoMerge) return;
    //--------------------------------------------------------------------------
    // This code handles the merging of item properties
    //--------------------------------------------------------------------------
    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if (oWeaponNew == OBJECT_INVALID) GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    if (oWeaponNew == OBJECT_INVALID) GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    if (oWeaponNew == OBJECT_INVALID) GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);

    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);

    //identify weapon
    SetIdentified(oWeaponNew, TRUE);
    // ...Weapons
    IPWildShapeCopyItemProperties(oWeaponOld, oWeaponNew, TRUE);
    IPWildShapeCopyItemProperties(oArmorOld,  oArmorNew);
    // ...Armor
    IPWildShapeCopyItemProperties(oHelmetOld, oArmorNew);
    IPWildShapeCopyItemProperties(oShield,    oArmorNew);
    // ...Magic Items
    IPWildShapeCopyItemProperties(oRing1Old,  oArmorNew);
    IPWildShapeCopyItemProperties(oRing2Old,  oArmorNew);
    IPWildShapeCopyItemProperties(oAmuletOld, oArmorNew);
    IPWildShapeCopyItemProperties(oCloakOld,  oArmorNew);
    IPWildShapeCopyItemProperties(oBootsOld,  oArmorNew);
    IPWildShapeCopyItemProperties(oBeltOld,   oArmorNew);
}
