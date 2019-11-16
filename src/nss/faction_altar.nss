#include "zdlg_include_i"
#include "zdialog_inc"
#include "seed_faction_inc"
#include "fame_inc"
#include "quest_inc"
#include "db_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

/*      Don't think this is needed anymore
int CheckIsCAIDRecorded(string sCAID, object oHolder)
{
    string sCheck = GetFirstStringElement("CAID_LIST", oHolder);
    while (sCheck != "")
    {
        if (sCheck == sCAID) return TRUE;
        sCheck = GetNextStringElement();
    }
    AddStringElement(sCAID, "CAID_LIST", oHolder);
    return FALSE;
}
*/

void HandleSelection(object oPC)
{
    string sMsg;    string sAccount;    string sLastUpdate;
    string sRank;   string sTime;       string sListMsg;
    string sFAID = SDB_GetFAID(oPC);    string sTRUEID;
    int nCnt;       int nTick;          int nStoredTick;
    int nAmount, nAmount2;
    object oHolder = OBJECT_SELF;
    int nOptionSelected = GetPageOptionSelected(oHolder);
    switch (nOptionSelected){
    case ZDIALOG_MAIN_MENU:
        SetNextPage(oHolder, nOptionSelected);
        return;
    /*case 1:
        sMsg = "   - notice, records are last logins, not last activity\n   - listed are logins older than 5 minutes\n";
        nTick = GetTick();
        nStoredTick = GetLocalInt(oHolder, "MEMBER_LIST_TICK");
        if (nTick - nStoredTick > 7)
        {
            SQLExecDirect("select ca_ckid, ac_name, fm_rank, round((UNIX_TIMESTAMP(now()) - UNIX_TIMESTAMP(ca_dllogin))/60)" +
                          " from cdkeyaccount, account, factionmember" +
                          " where ca_acid = ac_acid and ca_ckid = fm_ckid and fm_faid = " + GetLocalString(GetArea(oPC), "FAID") +
                          " order by ca_dllogin desc limit 20");
            sMsg += "   - last list update was < 1 minute ago\n\n";
            while (SQLFetch() && nCnt < 10)
            {
                sTime = SQLGetData(4);
                if (StringToInt(sTime) > 5)
                {
                    if (!CheckIsCAIDRecorded(SQLGetData(1), oHolder))
                    {
                        nCnt++;
                        if (nCnt < 10) sListMsg += "0";
                        sListMsg += IntToString(nCnt) + ". " + SQLGetData(2) + " (" + SQLGetData(3) + ")\n     -- " + ConvertSeconds(StringToInt(sTime)*60) + "\n\n";
                    }
                }
            }
            SetLocalString(oHolder, "MEMBER_LIST", sListMsg);
            SetLocalInt(oHolder, "MEMBER_LIST_TICK", nTick);
        }
        else
        {
            sMsg += "   - last list update was " + ConvertSeconds((nTick - nStoredTick)*120+60) + "ago\n\n";
            sListMsg += GetLocalString(oHolder, "MEMBER_LIST");
        }
        DeleteList("CAID_LIST", oHolder);
        SetShowMessage(oHolder, sMsg + sListMsg);
        return;*/
    case 2: // DEPOSIT GOLD CONFIRM
        nAmount = GetGold(oPC);
        if (nAmount < 100)
        {
            SetShowMessage(oHolder, "You cannot donate pocket lint!");
            PlaySound("as_pl_beggarm1");
            return;
        }
        else if (GetHitDice(oPC) >= 40)
        {
            SetShowMessage(oHolder, "You can not deposit GP and gain XP, you are allready at max level!");
            return;
        }
        else if (GetFactionsXP(sFAID) < 300000)
        {
            SetShowMessage(oHolder, "You can not deposit GP and gain XP, there is not enough XP in factionbank! (min 300k)");
            return;
        }
        sAccount = GetPCPlayerName(oPC);
        if (!GetHasTimePassed(oHolder, 15, "DEPOSIT_GP" + sAccount))
        {
            SetShowMessage(oHolder, "You can do this every 30 minutes. " + ShowLastUpdate(oHolder, "DEPOSIT_GP" + sAccount, "deposit"));
            return;
        }
        sFAID = SDB_GetFAID(oPC);
        if (nAmount > FACT_GP_DEPOSIT_CAP) nAmount = FACT_GP_DEPOSIT_CAP;
        nAmount2 = nAmount/XP_WORTH_GP/2;
        sMsg = "Deposit " + IntToString(nAmount) + "GP and withdraw " + IntToString(nAmount2) +
        "XP" + GetRGB() + " ?\n\nYou can do this every 30 minutes, XP will be transfered from " + SDB_FactionGetName(sFAID) + "bank account into this character";
        SetConfirmAction(oHolder, sMsg, 3);
        return;
    case 3: // DEPOSIT GOLD CONFIRMED
        nAmount = GetGold(oPC);
        if (nAmount < 100)
        {
            SetShowMessage(oHolder, "You seem to have lost some gold!?");
            PlaySound("as_pl_beggarm1");
            return;
        }
        sFAID = SDB_GetFAID(oPC);
        sAccount = GetPCPlayerName(oPC);
        sTRUEID = IntToString(dbGetTRUEID(oPC));
        if (nAmount > FACT_GP_DEPOSIT_CAP) nAmount = FACT_GP_DEPOSIT_CAP;
        nAmount2 = nAmount/XP_WORTH_GP/2;
        TakeGoldFromCreature(nAmount, oPC, TRUE);
        NWNX_SQL_ExecuteQuery("update faction set fa_bankxp=fa_bankxp-" + IntToString(nAmount2) + ", fa_bankgold=fa_bankgold+" + IntToString(nAmount) + " where fa_faid=" + SDB_GetFAID(oPC));
        FactionLogBankTransfer(sTRUEID, "", FBANK_T1_GP, FBANK_T2_DEPOSIT, nAmount, sFAID);
        FactionLogBankTransfer("", sTRUEID, FBANK_T1_XP, FBANK_T2_WITHDRAW, nAmount2, sFAID, "Deposit Gold");
        DelayCommand(0.1, UpdateFactionStats(sFAID));
        GiveXPToCreature(oPC, nAmount2);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oPC);
        SetShowMessage(oHolder, "Success! Deposited " + IntToString(nAmount) + "GP to faction account and withdrawed " + IntToString(nAmount2) + "XP, thank you!");
        return;
    case ZDIALOG_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC)
{
    object oHolder = OBJECT_SELF;
    string sList   = GetCurrentList(oHolder);
    string sRGB, sFAID;
    DeleteList(sList, oHolder);
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        //SetMenuOptionInt("List most recently active member", 1, oHolder);
        //sFAID = SDB_GetFAID(oPC);
        //if (GetHitDice(oPC) >= 40 || GetFactionsXP(sFAID) < 300000) sRGB = GetRGB(6,6,6);
        //SetMenuOptionInt(sRGB + "Deposit GP and gain XP", 2, oHolder);
        return;
    case ZDIALOG_SHOW_MESSAGE:
        DoShowMessage(oHolder);
        return;
    case ZDIALOG_CONFIRM:
        DoConfirmAction(oHolder);
        return;
    }
}

void CleanUp(object oHolder)
{
    CleanUpInc(oHolder);
}

void main ()
{
    object oPC = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    object oHolder = OBJECT_SELF;
    switch(iEvent) {
    case DLG_INIT:
        SetNextPage(oHolder, ZDIALOG_MAIN_MENU);
        break;
    case DLG_PAGE_INIT:
        BuildPage(GetNextPage(oHolder), oPC);
        SetShowEndSelection(TRUE);
        SetDlgResponseList(GetCurrentList(oHolder), oHolder);
        break;
    case DLG_SELECTION:
        HandleSelection(oPC);
        break;
    case DLG_ABORT:
    case DLG_END:
        CleanUp(oHolder);
    break;
    }
}
