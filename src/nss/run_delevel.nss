#include "_functions"
#include "db_inc"
#include "fame_inc"
#include "epic_inc"

void main()
{
    object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC)) return;
    if (GetLocalInt(oPC, "IS_DELVLING"))
    {
        FloatingTextStringOnCreature("Please wait...", oPC, FALSE);
        return;
    }
    if (GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) || GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC))
    {
        FloatingTextStringOnCreature("Can not de-level Palemaster or Red Dragon Disciples", oPC, FALSE);
        return;
    }
    int nLvl = GetHitDice(oPC);

    if (nLvl == 40)
    {
        if (GetHasEpicItemWithReq(oPC)) return;
    }
    SetLocalInt(oPC, "IS_DELVLING", TRUE);
    AssignCommand(oPC, ClearAllActions());

    int i;
    object oItem;
    float fDelay = 0.1;
    for(i = 0; i < INVENTORY_SLOT_ARROWS; i++)
    {
        oItem = GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oItem))
        {
            DelayCommand(fDelay, UnequipItem(oPC, oItem));
            fDelay += 0.1;
        }
    }
    int nOldXP = GetXP(oPC);
    int nNewXP = 1 + nOldXP - (nLvl - 1) * 1000;
    int nDonateXP = (nOldXP - nNewXP) / 100 * PARTIAL_DONATE_XP_VALUE;

    SetLocalInt (oPC, "i_TI_LastRest", 0);
    dbLogMsg("DELVL DONATE: " + IntToString(nDonateXP),"XP_DONATE",dbGetTRUEID(oPC),dbGetDEXID(oPC),dbGetLIID(oPC),dbGetPLID(oPC));
    IncFameOnChar(oPC, GetFameForXP(nDonateXP));
    StoreFameOnDB(oPC, SDB_GetFAID(oPC), FALSE);
    dbSetDonatedXP(oPC, nDonateXP);
    dbSaveHighestXP(oPC, nOldXP);

    DelayCommand(fDelay+0.1, SetXP(oPC, nNewXP));
    AssignCommand(oPC, DelayCommand(fDelay+0.2, ActionRest(TRUE)));
    DelayCommand(fDelay+1.0, SetLocalInt(oPC, "IS_DELVLING", FALSE));
}
