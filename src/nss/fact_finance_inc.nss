//:://////////////////////////////////////////////
/*
      // moved this to here for readability
*/
//:://////////////////////////////////////////////

#include "seed_faction_inc"
#include "time_inc"

string ShowAccountBalance(object oAltar, string sFAID, string sType, string sAccount = "");

string ShowAccountBalance(object oAltar, string sFAID, string sType, string sAccount = "")
{
    string sMsg, sSQL, sStr;
    int nInt;
    if (sType == "FINANCE_INFO_TOTAL")
    {
        if (GetHasTimePassed(oAltar, 30, sType))
        {
            sSQL =  "SELECT " +
                    "(SELECT sum(fb_amount) FROM factionbank where fb_faid=" + sFAID + " and fb_type1='" + FBANK_T1_XP + "' and fb_type2='" + FBANK_T2_TITHE + "')," +      // 1 XP_IN_TITHE
                    "(SELECT sum(fb_amount) FROM factionbank where fb_faid=" + sFAID + " and fb_type1='" + FBANK_T1_XP + "' and fb_type2='" + FBANK_T2_OBELISK + "')," +    // 2 XP_OUT_OBELISK
                    "(SELECT sum(fb_amount) FROM factionbank where fb_faid=" + sFAID + " and fb_type1='" + FBANK_T1_XP + "' and fb_type2='" + FBANK_T2_WITHDRAW + "')," +   // 3 XP_OUT_WITHDRAW

                    "(SELECT sum(fb_amount) FROM factionbank where fb_faid=" + sFAID + " and fb_type1='" + FBANK_T1_GP + "' and fb_type2='" + FBANK_T2_TITHE + "')," +      // 4 GP_IN_TITHE
                    "(SELECT sum(fb_amount) FROM factionbank where fb_faid=" + sFAID + " and fb_type1='" + FBANK_T1_GP + "' and fb_type2='" + FBANK_T2_DEPOSIT + "')," +    // 5 GP_IN_DEPOSIT
                    "(SELECT sum(fb_amount) FROM factionbank where fb_faid=" + sFAID + " and fb_type1='" + FBANK_T1_GP + "' and fb_type2='" + FBANK_T2_OBELISK + "')," +    // 6 GP_OUT_OBELISK
                    "(SELECT sum(fb_amount) FROM factionbank where fb_faid=" + sFAID + " and fb_type1='" + FBANK_T1_GP + "' and fb_type2='" + FBANK_T2_WITHDRAW + "')" +    // 7 GP_OUT_WITHDRAW
                    "from factionbank limit 1";
            NWNX_SQL_ExecuteQuery(sSQL);
            if (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                sMsg = "Account activity in 3 months (Updated every hour)\n";
                sMsg += "------------------------\n";
                sStr = NWNX_SQL_ReadDataInActiveRow(0);   nInt = StringToInt(sStr);
                sMsg += "Tithe: +" + sStr + "XP\n";
                sStr = NWNX_SQL_ReadDataInActiveRow(1);   nInt -= StringToInt(sStr);
                sMsg += "Obelisk: -" + sStr + "XP\n";
                sStr = NWNX_SQL_ReadDataInActiveRow(2);   nInt -= StringToInt(sStr);
                sMsg += "Withdraw: -" + sStr + "XP\n";
                sMsg += "------ TOTAL: " + IntToString(nInt) + "XP\n\n";
                sStr = NWNX_SQL_ReadDataInActiveRow(3);   nInt = StringToInt(sStr);
                sMsg += "Tithe: +" + sStr + "GP\n";
                sStr = NWNX_SQL_ReadDataInActiveRow(4);   nInt += StringToInt(sStr);
                sMsg += "Deposit: +" + sStr + "GP\n";
                sStr = NWNX_SQL_ReadDataInActiveRow(5);   nInt -= StringToInt(sStr);
                sMsg += "Obelisk: -" + sStr + "GP\n";
                sStr = NWNX_SQL_ReadDataInActiveRow(6);   nInt -= StringToInt(sStr);
                sMsg += "Withdraw: -" + sStr + "GP\n";
                sMsg += "------ TOTAL: " + IntToString(nInt) + "GP\n\n";
                SetLocalString(oAltar, sType, sMsg);
            }
        }
        else return GetLocalString(oAltar, sType);
    }
    else if (sType == FBANK_T1_XP+FBANK_T2_WITHDRAW)
    {
        if (GetHasTimePassed(oAltar, 30, sType))
        {
            sSQL =  "SELECT " +
                    "(SELECT sum(fb_amount) FROM factionbank where fb_faid=" + sFAID + " and fb_type1='" + FBANK_T1_XP + "' and fb_type2='" + FBANK_T2_WITHDRAW + "' and fb_rank_out in('" + DB_FACTION_LIEUTENANT + "','" + DB_FACTION_GENERAL + "'))," +
                    "(SELECT sum(fb_amount) FROM factionbank where fb_faid=" + sFAID + " and fb_type1='" + FBANK_T1_GP + "' and fb_type2='" + FBANK_T2_WITHDRAW + "' and fb_rank_out in('" + DB_FACTION_LIEUTENANT + "','" + DB_FACTION_GENERAL + "'))," +
                    "(SELECT sum(fb_amount) FROM factionbank where fb_faid=" + sFAID + " and fb_type1='" + FBANK_T1_XP + "' and fb_type2='" + FBANK_T2_WITHDRAW + "' and fb_rank_out='Deposit Gold')" +
                    "from factionbank limit 1";
            NWNX_SQL_ExecuteQuery(sSQL);
            if (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                sMsg = "Withdraw Overview (Updated every hour)\n";
                sMsg += "------------------------\n";
                sMsg += "Manual Withdraw: -" + NWNX_SQL_ReadDataInActiveRow(0) + "XP\n";
                sMsg += "Manual Withdraw: -" + NWNX_SQL_ReadDataInActiveRow(1) + "GP\n";
                sMsg += "XP Reward for depositing GP:  -" + NWNX_SQL_ReadDataInActiveRow(2) + "XP\n";
                sMsg += "------------------------\n";
                SetLocalString(oAltar, sType, sMsg);
            }
        }
        else return GetLocalString(oAltar, sType);
    }
    else if (sType == FBANK_T1_XP+FBANK_T2_WITHDRAW+"OFFICER")
    {
        if (GetHasTimePassed(oAltar, 30, sType))
        {
            sSQL =  "SELECT fb_acc_out, fb_rank_out, fb_amount, fb_type1, round(UNIX_TIMESTAMP(now()) - UNIX_TIMESTAMP(fb_date)) " +
                    "FROM factionbank where fb_faid=" + sFAID + " and fb_type1 in('" + FBANK_T1_XP + "','" + FBANK_T1_GP + "') and fb_type2='" + FBANK_T2_WITHDRAW +
                    "' and fb_rank_out in('" + DB_FACTION_LIEUTENANT + "','" + DB_FACTION_GENERAL + "') limit 20";
            NWNX_SQL_ExecuteQuery(sSQL);
            sMsg = "Manual Withdraw by Officers (Updated every hour)\n";
            sMsg += "------------------------\n";
            while (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                sMsg += "- Given " + NWNX_SQL_ReadDataInActiveRow(2) + NWNX_SQL_ReadDataInActiveRow(3) + " to " + NWNX_SQL_ReadDataInActiveRow(0) + " by " + NWNX_SQL_ReadDataInActiveRow(1) + " " + ConvertSecondsToString(StringToInt(NWNX_SQL_ReadDataInActiveRow(4))) + "ago\n";
            }
            SetLocalString(oAltar, sType, sMsg);
        }
        else return GetLocalString(oAltar, sType);
    }
    return sMsg;
}

//void main(){}
