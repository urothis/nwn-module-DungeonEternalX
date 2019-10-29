#include "rune_include"
#include "sfsubr_functs"
#include "inc_setmaxhps"
#include "db_inc"
#include "artifact_inc"
#include "gen_inc_color"
#include "fky_chat_inc"
#include "fame_charvalue"
#include "_webhook"

void OnClientExit(object oPC) // CALL ON CLIENT EXIT
{
    if (GetLocalString(oPC, "BANNED")!="") return;   // DON'T DO ANYTHING IF BOOTING A BANNED PLAYER CAUSE WE DIDN'T WHEN THEY ENTERED
    string sLIID = IntToString(dbGetLIID(oPC));
    string sKills= IntToString(GetLocalInt(oPC, "KILLS"));
    string sGold = IntToString(GetNetWorth(oPC));
    string sXP   = IntToString(GetXP(oPC));
    string sSts  = (GetCurrentHitPoints(oPC)>0) ? "OK" : "DEAD";
    string sAPLID= "0";
    if (GetIsInCombat(oPC))
    {
        object oLHA = GetLastHostileActor(oPC);
        if (GetIsPC(oLHA))
        {
            sSts = "ATTACK";
            sAPLID = IntToString(dbGetPLID(GetLastHostileActor(oPC)));
        }
    }

    string sSQL  = "update login set logout=now(), " +
            DelimList(dbSetField("kills",   sKills),
                      dbSetField("xpout",   sXP),
                      dbSetField("statusout",  dbQuotes(sSts)),
                      dbSetField("goldout", sGold),
                      dbSetField("attackplid", sAPLID)) +
                   " where liid=" + sLIID;
    NWNX_SQL_ExecuteQuery(sSQL);
    dbUpdatePlayerStatus(oPC, "0");
}


void main()
{
    object oPC = GetExitingObject();

    string sCharactername = GetLocalString(oPC, "player_name");
    string sPlayername    = GetLocalString(oPC, "player_pname");
    string publicKey      = GetLocalString(oPC, "player_cdkey");
    string sFAID          = GetLocalString(oPC, "FAID");

    // logout webhook
    LogoutWebhook(oPC);

    if (GetIsDM(oPC))
    {
        if (sCharactername != "Turther Thern")
        {
            ShoutMsg("[DM] " + sCharactername + " (" + sPlayername + ") has left the server.");
        }
    }

    //Speech_OnClientExit(oPC);
    if (!GetIsDM(oPC))
    {
        MaxHitPointsPCExit(oPC);

        if (GetIsInCombat(oPC)) // Is in combat; consider a Death Log
        {
            if (GetCurrentHitPoints(oPC) > 0)
            {
                object oAttacker = GetLastHostileActor(oPC);
                if (GetIsPC(oAttacker))
                {
                    object oAreaKiller = GetArea(oAttacker);
                    string sMsg = GetRGB(15,4,15) + GetName(oAttacker) + GetRGB() + " autokilled " + GetRGB(15,4,15) + sCharactername + GetRGB() + " (logged during combat)";
                    sMsg += dropPvpLoot(oPC, oAttacker, oAreaKiller);
                    ShoutMsg(sMsg);
                }
            }
        }

        OnClientExit(oPC);
        Artifact_Drop(oPC); // Drop artifact
        DestroyControlledCreatures(oPC); // kill dominated
        LetoPCExit(oPC);
    }

    dbUpdateSessionCnt(-1);
    StoreTimeOnDB(oPC, sFAID, TRUE); // "fame_inc"
    StoreFameOnDB(oPC, sFAID, TRUE); // "fame_inc"
}
