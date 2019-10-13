#include "_functions"
#include "random_loot_inc"
#include "fame_inc"
#include "quest_inc"
#include "effect_inc"
#include "inc_traininghall"

const int SLOT_XP     = 75;
const int SLOT_GOLD   = 60;
const int SLOT_COST   = 10000;

void SlotRemoveFlags(object oLever)
{
    int nRound = 1;
    int nField = 1;
    float fDelay;
    object oFlag;
    object oField = GetLocalObject(oLever, "WP_SLOT_" + IntToString(nRound) + IntToString(nField));
    while (nRound <= 4)
    {
        while (nField <= 4)
        {
            oField = GetLocalObject(oLever, "WP_SLOT_" + IntToString(nRound) + IntToString(nField));
            oFlag = GetLocalObject(oField, "SLOT_FLAG");
            if (!GetIsObjectValid(oFlag)) return;
            DelayCommand(fDelay, DestroyObject(oFlag));
            DeleteLocalInt(oField, "SLOT_FLAG");
            nField++;
            fDelay += 0.1;
        }
        nRound++;
        nField = 1;
    }
    StripAllEffects(GetLocalObject(oLever, "SLOT_BALL_1"));
    StripAllEffects(GetLocalObject(oLever, "SLOT_BALL_2"));
}

int nZwischenStand(string sTag, int nRound, int nField, object oFlag, object oLever)
{
    int nScore;
    int nBeam = (sTag == "slot_flag_white") ? VFX_BEAM_SILENT_COLD : VFX_BEAM_SILENT_ODD;
    object oFlagLast;
    object oField = GetLocalObject(oLever, "WP_SLOT_" + IntToString(nRound-1) + IntToString(nField-1));
    if (GetIsObjectValid(oField))
    {
        oFlagLast = GetLocalObject(oField, "SLOT_FLAG");
        if (GetTag(oFlagLast) == sTag)
        {
            if (GetLocalInt(oFlagLast, "DO_SCORE"))
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBeam(nBeam, oFlagLast, BODY_NODE_CHEST), oFlag);
                nScore = nScore + (SLOT_XP * nRound * nRound);
                SetLocalInt(oFlag, "DO_SCORE", TRUE);
            }
        }
    }
    oField = GetLocalObject(oLever, "WP_SLOT_" + IntToString(nRound-1) + IntToString(nField+1));
    if (GetIsObjectValid(oField))
    {
        oFlagLast = GetLocalObject(oField, "SLOT_FLAG");
        if (GetTag(oFlagLast) == sTag)
        {
            if (GetLocalInt(oFlagLast, "DO_SCORE"))
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBeam(nBeam, oFlagLast, BODY_NODE_CHEST), oFlag);
                nScore = nScore + (SLOT_XP * nRound * nRound);
                SetLocalInt(oFlag, "DO_SCORE", TRUE);
            }
        }
    }
    return nScore;
}

int SlotCountScore(object oLever, int nRound, object oPC)
{
    int nField = 1;
    int nScore;
    string sTag;
    effect eBeam;
    object oField;
    object oFlag;

    while (nField <= 4)
    {
        oField = GetLocalObject(oLever, "WP_SLOT_" + IntToString(nRound) + IntToString(nField));
        oFlag = GetLocalObject(oField, "SLOT_FLAG");
        if (!GetIsObjectValid(oFlag)) return nScore;
        sTag = GetTag(oFlag);
        if (nRound == 1 || nRound == 3)
        {
            if (nField == 1 || nField == 3)
            {
                if (sTag == "slot_flag_black")
                {
                    if (nRound == 1)
                    {
                        SetLocalInt(oFlag, "DO_SCORE", TRUE);
                        nScore += SLOT_XP;
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBeam(VFX_BEAM_SILENT_ODD, oFlag, BODY_NODE_CHEST), GetLocalObject(oLever, "SLOT_BALL_1"));
                    }
                    else nScore += nZwischenStand("slot_flag_black", nRound, nField, oFlag, oLever);
                }
            }
            else if (nField == 2 || nField == 4)
            {
                if (sTag == "slot_flag_white")
                {
                    if (nRound == 1)
                    {
                        SetLocalInt(oFlag, "DO_SCORE", TRUE);
                        nScore += SLOT_XP;
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBeam(VFX_BEAM_SILENT_COLD, oFlag, BODY_NODE_CHEST), GetLocalObject(oLever, "SLOT_BALL_2"));
                    }
                    else nScore += nZwischenStand("slot_flag_white", nRound, nField, oFlag, oLever);
                }
            }
        }
        else if (nRound == 2 || nRound == 4)
        {
            if (nField == 2 || nField == 4)
            {
                if (sTag == "slot_flag_black")
                {
                    nScore += nZwischenStand("slot_flag_black", nRound, nField, oFlag, oLever);
                }
            }
            else if (nField == 1 || nField == 3)
            {
                if (sTag == "slot_flag_white")
                {
                    nScore += nZwischenStand("slot_flag_white", nRound, nField, oFlag, oLever);
                }
            }
        }
        nField++;
    }
    if (nRound == 1 && nScore == 4*SLOT_XP)
    {
        oFlag = GetLocalObject(GetLocalObject(oLever, "WP_SLOT_11"), "SLOT_FLAG");
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_SILENT_ODD, oFlag, BODY_NODE_CHEST), GetLocalObject(GetLocalObject(oLever, "WP_SLOT_14"), "SLOT_FLAG"), 6.0);
        object oPC = GetLastUsedBy();
        CreateTrainingToken(oPC);
        IncFameOnChar(oPC, 2.0);
        DelayCommand(0.1, StoreFameOnDB(oPC, GetLocalString(oPC, "FAID")));

        ShoutMsg("OH SNAP! "+GetName(oPC)+" is GETTING RICH OFF SLOTS. KILL HIM DEAD.");

        Q_UpdateQuest(oPC, "11");

        string sTRUEID = IntToString(dbGetTRUEID(oPC));
        NWNX_SQL_ExecuteQuery("select st_flagstars from statistics where st_trueid=" + sTRUEID);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ExecuteQuery("update statistics set st_flagstars=st_flagstars+1 where st_trueid=" + sTRUEID);
        }
        else NWNX_SQL_ExecuteQuery("insert into statistics (st_trueid,st_flagstars) values (" + sTRUEID + ",1)");
    }
    else if (nRound == 2 && nScore == 24*SLOT_XP)
    {
        CreateTrainingToken(oPC, 2);
        IncFameOnChar(oPC, 4.0);
        DelayCommand(0.1, StoreFameOnDB(oPC, GetLocalString(oPC, "FAID")));

        ShoutMsg("OH SNAP! "+GetName(oPC)+" is GETTING RICH OFF SLOTS. KILL HIM DEAD.");
    }
    else if (nRound == 3 && nScore == 54*SLOT_XP)
    {
        CreateTrainingToken(oPC, 3);
        IncFameOnChar(oPC, 8.0);
        DelayCommand(0.1, StoreFameOnDB(oPC, GetLocalString(oPC, "FAID")));
        ShoutMsg("OH SNAP! "+GetName(oPC)+" is GETTING RICH OFF SLOTS. KILL HIM DEAD.");
    }
    else if (nRound == 4 && nScore == 96*SLOT_XP)
    {
        CreateTrainingToken(oPC, 4);
        IncFameOnChar(oPC, 16.0);
        DelayCommand(0.1, StoreFameOnDB(oPC, GetLocalString(oPC, "FAID")));
        ShoutMsg("OH SNAP! "+GetName(oPC)+" is GETTING RICH OFF SLOTS. KILL HIM DEAD.");
    }
    return nScore;
}

float SlotCreateFlags(int nRound, object oLever)
{
    object oField;
    float fDelay;
    int nField = 1;
    while (nField <= 4)
    {
        oField = GetLocalObject(oLever, "WP_SLOT_" + IntToString(nRound) + IntToString(nField));
        DelayCommand(fDelay, SetLocalObject(oField, "SLOT_FLAG", CreateObject(OBJECT_TYPE_PLACEABLE, (d2() == 1) ? "slot_flag_black" : "slot_flag_white", GetLocation(oField))));
        nField++;
        fDelay += 0.3;
    }
    return fDelay;
}


void main()
{
    object oPC = GetLastUsedBy();
    object oLever = OBJECT_SELF;

    int nMode = GetLocalInt(oLever, "MODE");
    if (nMode == 1)
    {
        SpeakString("Do not spam...");
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(15+d6()), oPC);
        return;
    }

    int nCredit = GetLocalInt(oLever, "SLOT_CREDIT");
    int nRound = GetLocalInt(oLever, "SLOT_ROUND");
    if (!nRound) nRound = 1;
    if (nMode == 2)
    {
        ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
        ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
        int nScore = SlotCountScore(oLever, nRound - 1, oPC);
        if (nScore > 0)
        {
            GiveXPToCreature(oPC, nScore);
            //GiveGoldToCreature(oPC, nScore * SLOT_GOLD);
            //if (nScore > 30 * SLOT_XP) LootCreateScrollPot(oPC, 2); // allways 1 (Scroll), unless rolled 2 (Pot)
            if (nScore > 45 * SLOT_XP) LootCreateScrollPot(oPC, 2);
        }
        else
        {
            SetLocalInt(oLever, "SLOT_ROUND", 0);
            SlotRemoveFlags(oLever);
        }
        SetLocalInt(oLever, "MODE", 1);
        DelayCommand(1.0, DeleteLocalInt(oLever, "MODE"));
        return;
    }
    ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    SetLocalInt(oLever, "MODE", 1);

    if (nRound > 4)
    {
        nRound = 1;
        SlotRemoveFlags(oLever);
    }

    float fDelay = 0.5;
    int nCost = SLOT_COST * nRound;
    if (nCredit >= nCost)
    {
        //SendMessageToPC(oPC, "Round " + IntToString(nRound) + ": -" + IntToString(nCost) + " Credit (" + IntToString(nCredit-nCost) + ")");
        SetLocalInt(oLever, "SLOT_ROUND", nRound + 1);
        SetLocalInt(oLever, "SLOT_CREDIT", nCredit - nCost);
        fDelay += SlotCreateFlags(nRound, oLever);
        DelayCommand(fDelay, SetLocalInt(oLever, "MODE", 2));
    }
    else
    {
        if (nCredit > 0)
        {
            GiveGoldToCreature(oPC, nCredit);
            DeleteLocalInt(oLever, "SLOT_CREDIT");
        }
        DelayCommand(fDelay, DeleteLocalInt(oLever, "MODE"));
        SendMessageToPC(oPC, "Not enough credit!");
    }

    DelayCommand(fDelay, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));

}
