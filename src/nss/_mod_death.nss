#include "_inc_death"
#include "rune_include"
#include "_inc_deitydb"
#include "gen_inc_color"
#include "x2_i0_spells"
#include "db_inc"
#include "seed_faction_inc"
#include "artifact_inc"
#include "fame_charvalue"
#include "otman_event"

void DoScore (object oKilled, object oKiller)
{
    int nDD         = PCDB_GetInt(oKilled, "Deaths");
    int nKK         = PCDB_GetInt(oKiller, "Kills");
    int nSpreeKills = PCDB_GetInt(oKiller, "SpreeKills");

    PCDB_SetInt(oKilled, "Deaths", ++nDD);
    PCDB_SetInt(oKiller, "Kills", ++nKK);
    PCDB_SetInt(oKiller, "SpreeKills", ++nSpreeKills);
    PCDB_DeleteInt(oKilled, "SpreeKills");
}

object GetAnotherKiller(object oKilled, object oOldKiller, object oArea)
{
    object oEnemy = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oKilled, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    if (GetIsObjectValid(oEnemy))
    {
        if (oEnemy == oOldKiller) oEnemy = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oKilled, 2, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
        if (GetArea(oEnemy) == oArea)
        {
            if (GetCurrentHitPoints(oEnemy) > 0) return oEnemy;
        }
    }
    return OBJECT_INVALID;
}

void DoSpreeBonus (object oKiller, object oKilled, int nKilled)
{
    string sName = GetName(oKiller);
    string sMessage;
    effect eBonus = EffectHeal(GetMaxHitPoints(oKilled));
    effect eLink, eDur;

    if(nKilled == 5)
    {
        sMessage    = sName + " is on a <cZ>KILLING SPREE</c> with 10 kills!";
        eLink       = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
        eDur        = EffectVisualEffect(VFX_DUR_IOUNSTONE_YELLOW);
    }
    else if(nKilled == 10)
    {
        sMessage    = sName + " is on a <cd>MASSIVE KILLING SPREE</c> with 15 kills!";
        eLink       = EffectConcealment(30);
        eDur        = EffectVisualEffect(VFX_DUR_IOUNSTONE_YELLOW);
    }
    else if(nKilled == 15)
    {
        sMessage    = sName + " is on an <cn>EXCESSIVE KILLING SPREE</c> with 20 kills!";
        eLink       = EffectDamageReduction(25, DAMAGE_POWER_PLUS_TWENTY);
        eDur        = EffectVisualEffect(VFX_DUR_IOUNSTONE_YELLOW);
    }
    else if(nKilled == 20)
    {
        sMessage    = sName + " is on a <cx>LUDICROUS KILLING SPREE</c> with 25 kills!";
        eLink       = EffectDamageShield(25, DAMAGE_BONUS_2d6, DAMAGE_TYPE_PIERCING);
        eDur        = EffectVisualEffect(VFX_DUR_IOUNSTONE_YELLOW);
    }
    else if(nKilled == 25)
    {
        sMessage    = sName + " is <c‚>DOMINATING</c> with 30 kills!";
        eLink       = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
        eDur        = EffectVisualEffect(VFX_DUR_IOUNSTONE_YELLOW);
    }
    else if(nKilled == 30)
    {
        sMessage    = sName + " is <c´>GODLIKE</c> with 35 kills!";
        eLink       = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
        eDur        = EffectVisualEffect(VFX_DUR_GLOW_RED);
    }
    else
        return;

    ShoutMsg(sMessage);

    eLink = ExtraordinaryEffect(EffectLinkEffects(eLink, eDur));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eBonus, oKiller);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oKiller);
}
// TYPE1: faction TK, TYPE2: PK no area shout, TYPE3: PK area shout
void DoKillShout(string sKiller, int nKHD, string sKilled, int nDHD, int TYPE, object oArea, string sAddMsg = "")
{
   sKiller += " (" + IntToString(nKHD) + ")";
   sKilled += " (" + IntToString(nDHD) + ")";

   if (TYPE == 1) ShoutMsg(GetRGB(9,6,1) + sKiller + " has killed his factionmate " + sKilled + " at " + GetName(oArea) + sAddMsg);
   else if (TYPE == 2) ShoutMsg(GetRGB(15,1,1) + sKiller + " has killed " + sKilled + sAddMsg);
   else ShoutMsg(GetRGB(15,1,1) + sKiller + " has killed " + sKilled + " at " + GetName(oArea) + sAddMsg);

   // disabled by ezramun
   //SQLExecDirect("insert into chattext (ct_seid, ct_plid, ct_channel, ct_text, ct_toplid) values (" +
   //   DelimList(SDB_GetSEID(), InQs(SDB_GetPLID(oKiller)), InQs("K"), InQs(sMsg), InQs(SDB_GetPLID(oKilled))) + ")");

}

void OnPCDeath(object oPC, object oKiller) // CALL ON PLAYER DEATH
{
    if (GetIsDM(oKiller)) return;
    if (GetIsDMPossessed(oKiller)) return;

    // MODULE KILLED THEM FOR SOME REASON, SO DONT INC DEATH COUNT
    if (GetLocalInt(oPC, "NO_DEATH_PEN")) DeleteLocalInt(oPC, "NO_DEATH_PEN");
    else IncLocalInt(oPC, "DEATHS");

    if (GetIsPC(oKiller))
    {
        string sSQL;
        string sPLID = IntToString(dbGetPLID(oPC));
        string skPLID = IntToString(dbGetPLID(oKiller));
        //string skPVID = SDB_GetPVID(oKiller);
        string skLevel = IntToString(GetHitDice(oKiller));

        sSQL = "update player set pked=pked+1, dlpked=now() where plid=" + sPLID;
        NWNX_SQL_ExecuteQuery(sSQL);
        sSQL = "update player set pker=pker+1, dlpker=now() where plid=" + skPLID;
        NWNX_SQL_ExecuteQuery(sSQL);

        if (HasItemByTag(oPC, "GeneralOtmansRing")) // Cory - As requested by Vengeance, added a boss ring for his events
        {                                           // The ring transfers to the newest killer until turned in to a DM
            GeneralOtmanEvent(oPC, oKiller);
        }
    }
    dbUpdatePlayerStatus(oPC); // SAVE PC STATUS
}

void main()
{
    object oKilled  = GetLastPlayerDied();
    object oArea    = GetArea(oKilled);
    string sAreaTag = GetTag(oArea);


    DropRune(oKilled);
    Artifact_Drop(oKilled);

    DeleteLocalInt(oKilled, "TERRIFYPULSE"); // clear pulse variable on death
    DeleteLocalInt(oKilled, "FRENZY"); // CLEAR WARLORD FRENZY
    DeleteLocalInt(oKilled, "TOKEN");
    DeleteLocalInt(oKilled, "BgPulseCount"); // Clears Blackguard Bullstrenght Pulse
    DeleteLocalInt(oKilled, "FeatEnhancerActive");
    SetLocalInt(oKilled, "i_TI_LastRest", 0);

    DestroyControlledCreatures(oKilled);

    // telling the PC that they will not incur any penalties for respawning
    if (GetIsDeXStadium(sAreaTag) || sAreaTag == "Arena")
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oKilled);
        DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), oKilled));
        DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oKilled));
        if (sAreaTag == "STADIUM_3")
        {
            if (GetLocalObject(oArea, "CRYSTAL_BALL_CARRIER") == oKilled)
            {
                DeleteLocalObject(oArea, "CRYSTAL_BALL_CARRIER");
            }
        }
        if (GetIsDead(oKilled))
        {
            DelayCommand(3.0, PopUpDeathGUIPanel(oKilled,TRUE,TRUE,1,"Go on, Respawn! Death in this arena carries no penality..."));
            return;
        }
    }

////////////////////////////////////////////////////////////////////////////////

    object oKiller = GetLastHostileActor(oKilled);

    if (!GetIsObjectValid(oKiller)) oKiller = GetAnotherKiller(oKilled, oKiller, oArea);
    else if (!GetIsPC(oKiller) && GetIsPC(GetMaster(oKiller))) // If the killer is not a PC but it's master is
    {
        oKiller = GetMaster(oKiller); // Record te kill for the master
    }
//////// If the killer is not a PC, return /////////////////////////////////////

    if (!GetIsPC(oKiller))
    {
        if (GetIsDead(oKilled)) DelayCommand(3.0f, PopUpDeathGUIPanel(oKilled,TRUE,TRUE,1,"You have died. Logging at this point is considered an exploit, so respawn before logging out."));
        return;
    }

    //////////////////
    // used for pvp reward
    SetLocalObject(oKilled, "LAST_DIED_AREA", oArea);
    DelayCommand(60.0, DeleteLocalObject(oKilled, "LAST_DIED_AREA"));

    OnPCDeath(oKilled, oKiller);

    // PKing records
    int nDHD        = GetHitDice(oKilled);
    int nKHD        = GetHitDice(oKiller);
    int nDiff       = nKHD - nDHD;
    string sName    = GetName(oKiller);
    string sDead    = GetName(oKilled);
    string sPlace   = GetName(oArea);
    string sFAIDKilled = SDB_GetFAID(oKilled);
    string sAddMsg;
    int nShoutType;
    int nGiveFame;

    if (oKiller != oKilled)
    {
        string sFAIDKiller = SDB_GetFAID(oKiller);
        if (sFAIDKiller == sFAIDKilled) //same faction or both factionless
        {
            int nTeamKill;
            if (SDB_FactionIsMember(oKiller)) nTeamKill = TRUE; // same faction, factioned
            else if (GetFactionEqual(oKiller, oKilled)) nTeamKill = TRUE; // same party
            else if (PartyGetEqualID(oKiller, oKilled)) nTeamKill = TRUE; // player left party

            // Cory - Check for DM event ring as well (faction killing messes things up with ring)
            if ((nTeamKill) && !(HasItemByTag(oKiller, "GeneralOtmansRing")))// factioned or same partymember
            {
                object oNewKiller = GetAnotherKiller(oKilled, oKiller, oArea); // get new killer
                if (GetIsObjectValid(oNewKiller)) // new killer found
                {
                    oKiller = oNewKiller;
                    sName = GetName(oKiller);
                    nKHD = GetHitDice(oKiller);
                    nShoutType = 2;
                    nGiveFame = TRUE;
                }
                else // no new killer found, but give fame  - Changed for increasing fame purposes - Venge
                {
                    nShoutType = 1;
                    nGiveFame = TRUE;
                }
            }
            else
            {
                if (abs(nDiff) <= 5 && nKHD != 40 || nKHD < nDHD) nShoutType = 2;
                else nShoutType = 3;
                nGiveFame = TRUE;
            }
        }
        else if (!StringToInt(sFAIDKilled) && nDiff > 5 && GetTotalFame(oKilled) < 250)
        {// some noob killed?
            RespawnChar(oKilled, "TELE_Loftenwood");
            SendMessageToPC(oKilled, "New player: You escaped a effortles player-kill attempt.");
            SendMessageToPC(oKiller, "Effortles player-kill attempt on a new player.");
            return;
        }
        else
        {
            if (abs(nDiff) <= 5 && nKHD != 40 || nKHD < nDHD)
            {
                nGiveFame = TRUE;
                nShoutType = 2;
            }
            else
            {
                nGiveFame = TRUE;
                nShoutType = 3;
            }

            if (nDiff <= 10)
            {
                // If oKilled was on a spree, shout that it was broken
                if (PCDB_GetInt(oKilled, "SpreeKills") >= 10) ShoutMsg(sName + " broke " + sDead + "'s KILLING SPREE!");

                // Do killing spree bonuses
                DoScore(oKilled, oKiller);
                DoSpreeBonus (oKiller, oKilled, PCDB_GetInt(oKiller, "SpreeKills"));
            }
        }
        DeathDoVFX(oKilled);
    }

    if (nGiveFame) sAddMsg = dropPvpLoot(oKilled, oKiller, oArea);
    if (nShoutType) DoKillShout(sName, nKHD, sDead, nDHD, nShoutType, oArea, sAddMsg);

    if (GetIsDead(oKilled)) DelayCommand(3.0, PopUpDeathGUIPanel(oKilled,TRUE,TRUE,1,"You have died. Logging at this point is considered an exploit, so respawn before logging out."));


    //Ezramun: Function checked, can be deactivated.
    //SDB_FactionOnPCDeath(oKilled, oKiller);
}
