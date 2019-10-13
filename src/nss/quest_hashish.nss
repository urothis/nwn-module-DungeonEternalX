#include "zdlg_include_i"
#include "zdialog_inc"
#include "nw_i0_plot"
#include "seed_faction_inc"
#include "_inc_port"
#include "fame_inc"
#include "quest_inc"
#include "time_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

void SpawnMadGolem(object oHashish, location lGolem)
{
    object oGolem = CreateObject(OBJECT_TYPE_CREATURE, "NW_SKELDEVOUR", lGolem);
    AssignCommand(oGolem, ActionAttack(oHashish));
    DelayCommand(0.1, SetCommandable(FALSE, oGolem));
    DelayCommand(5.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oGolem)));
    DelayCommand(5.5, DestroyObject(oGolem));
}

void HashishGiveReward(object oPC, int nCount, int nGolem = FALSE)
{
    if (nGolem)
    {
        object oItem = CreateItemOnObject("item_summon_ally", oPC, 1, "HASHISHS_BGOLEM");
        SetName(oItem, "Hashish's Bonegolem");
        SetItemCharges(oItem, 30 + d4());
    }
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    NWNX_SQL_ExecuteQuery("select st_knuckles_tot from statistics where st_trueid=" + sTRUEID);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ExecuteQuery("update statistics set st_knuckles_tot=st_knuckles_tot+"+IntToString(nCount)+" where st_trueid=" + sTRUEID);
    }
    else NWNX_SQL_ExecuteQuery("insert into statistics (st_trueid,st_knuckles_tot) values (" + sTRUEID + ","+IntToString(nCount)+")");

    if (nGolem)
    {
        NWNX_SQL_ExecuteQuery("select st_knuckles_fin from statistics where st_trueid=" + sTRUEID);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ExecuteQuery("update statistics set st_knuckles_fin=st_knuckles_fin+1 where st_trueid=" + sTRUEID);
        }
        else NWNX_SQL_ExecuteQuery("insert into statistics (st_trueid,st_knuckles_fin) values (" + sTRUEID + ",1)");
    }

    IncFameOnChar(oPC, IntToFloat(nCount) * 0.2);
    DelayCommand(0.1, StoreFameOnDB(oPC, SDB_GetFAID(oPC)));
}

void HashishCutscene(object oPC)
{
    object oWPHashish   = GetNearestObjectByTag("WP_HASHISH_NPC");
    location lGolem     = GetLocation(GetNearestObjectByTag("WP_HASHISH_GOLEM"));
    object oWPPC        = GetNearestObjectByTag("WP_HASHISH_PC");
    object oHashish     = CreateObject(OBJECT_TYPE_CREATURE, "hashishkabob", GetLocation(oWPHashish));

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), oHashish);
    SetPortMode(oPC, PORT_NOT_ALLOWED);

    ActionDoCommand(SetCutsceneMode(oPC, TRUE, FALSE));
    ActionDoCommand(FadeToBlack(oPC));
    ActionWait(2.0);
    ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oPC, 18.0));
    ActionDoCommand(AssignCommand(oPC, SetCameraFacing(80.0, 5.0, 70.0)));
    ActionDoCommand(AssignCommand(oPC, JumpToObject(oWPPC)));
    ActionDoCommand(FadeFromBlack(oPC));
    ActionWait(2.0);
    ActionDoCommand(AssignCommand(oHashish, ActionCastFakeSpellAtLocation(SPELL_SUMMON_CREATURE_III, lGolem)));
    ActionWait(2.0);
    ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), lGolem));
    ActionWait(1.0);
    ActionDoCommand(AssignCommand(oHashish, SpeakString("You Fool! You have brought me rubbish again…")));
    ActionDoCommand(SpawnMadGolem(oHashish, lGolem));
    ActionWait(1.0);
    ActionDoCommand(AssignCommand(oHashish, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 1.0)));
    ActionWait(2.0);
    ActionDoCommand(AssignCommand(oHashish, SpeakString("Ah, Frederick! Come and help me, you imbecile!")));
    ActionDoCommand(AssignCommand(oHashish, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 2.0)));
    ActionWait(2.0);
    ActionDoCommand(AssignCommand(oHashish, SpeakString("You’ve ruined it again – this is all your fault!")));
    ActionWait(1.0);
    ActionDoCommand(AssignCommand(oHashish, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 5.0)));
    ActionWait(4.0);
    ActionDoCommand(FadeToBlack(oPC));
    ActionWait(2.0);
    ActionDoCommand(AssignCommand(oPC, ClearAllActions()));
    ActionDoCommand(SetCutsceneMode(oPC, FALSE, TRUE));
    ActionDoCommand(AssignCommand(oPC, JumpToLocation(GetLocalLocation(oPC, "HASHISH_PC_LOC"))));
    ActionDoCommand(DestroyObject(oHashish));
    ActionWait(1.0);
    ActionDoCommand(ExploreAreaForPlayer(GetArea(oPC), oPC, FALSE));
    ActionDoCommand(FadeFromBlack(oPC));
    ActionDoCommand(SetPortMode(oPC));
    ActionDoCommand(DeleteLocalLocation(oPC, "HASHISH_PC_LOC"));
    ActionWait(2.0);
    ActionDoCommand(SpeakString("Get rid of this rubbish – you’ve brought me the wrong stuff again, you waste-of-space. Get me new ones from the crypts – and be sharp about it. "));
}


void HandleSelection(object oPC)
{
    object oHolder = OBJECT_SELF;
    object oItem;
    int nCount;     int nTotalItems;    int nTime;
    int nNeededItems = 50;
    string sMsg;
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    int nOptionSelected = GetPageOptionSelected(oHolder);
    switch (nOptionSelected){ // WHAT IS SELECTED AT BUILDPAGE?
    case ZDIALOG_MAIN_MENU:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case 1:
        nTime = GetTick() - GetLocalInt(oHolder, "TICK_" + sTRUEID);
        if (!HasItem(oPC, "SKELETON_KNUCKLE")) SetShowMessage(oHolder, "Why are you wasting my time? Get out of my sight, you worthless oaf!");
        else if (nTime < 15) // 15 gamehours = 30 minutes
        {
            SetShowMessage(oHolder, "*Frederick seems to be an unreliable character and as you have just brought the wizard something you decide to wait a bit ( " + ConvertSecondsToString((15-nTime)*120) + ") before bringing him anything else.*\n\nWhy are you wasting my time? Get out of my sight, you worthless oaf!");
        }
        else
        {
            nTotalItems = GetLocalInt(oHolder, "TOTAL_KNUCKLES");
            if (nTotalItems == 0) nTotalItems = dbGetPersistentInt(oHolder, "TOTAL_KNUCKLES");
            if (nTotalItems < 0) nTotalItems = 0;
            SetLocalInt(oHolder, "TICK_" + sTRUEID, GetTick());

            oItem = GetFirstItemInInventory(oPC);
            while (GetIsObjectValid(oItem))
            {
                if (GetTag(oItem) == "SKELETON_KNUCKLE")
                {
                    nCount++;
                    nTotalItems++;
                    DestroyObject(oItem);
                }
                if (nCount == 5 || nTotalItems == nNeededItems) break;
                oItem = GetNextItemInInventory(oPC);
            }

            Q_UpdateQuest(oPC, "4", FALSE, IntToString(Q_GetHasQuest(oPC, "4") + nCount));

            if (nTotalItems < nNeededItems)
            {
                if (nCount == 5) sMsg = "*Frederick seems to be an unreliable character so you give the wizard five Skeleton's Knuckles so that he won’t get suspicious and give you a closer look. Perhaps you should try again later*";
                else sMsg = "*You give the wizard " + IntToString(nCount) + " Skeleton's Knuckles which he snatches away greedily*";
                SetLocalInt(oHolder, "TOTAL_KNUCKLES", nTotalItems);
                dbSetPersistentInt(oHolder, "TOTAL_KNUCKLES", nTotalItems);
                SetShowMessage(oHolder, sMsg + "\n\nI need more (" + IntToString(nNeededItems-nTotalItems) + "), you fool, go and get me some! *Sigh* What more could I expect from you.");
                HashishGiveReward(oPC, nCount);
            }
            else
            {
                DeleteLocalInt(oHolder, "TOTAL_KNUCKLES");
                dbSetPersistentInt(oHolder, "TOTAL_KNUCKLES", 0);
                AssignCommand(oHolder, SpeakString("Ha ha! I finally have enough to finish it… did you hear me Zelda?", TALKVOLUME_SHOUT));
                AssignCommand(GetObjectByTag("quest_zelda"), DelayCommand(6.0, SpeakString("One day you gonna turn Tanglebrook into ruins with your experiments", TALKVOLUME_SHOUT)));
                SetLocalLocation(oPC, "HASHISH_PC_LOC", GetLocation(oPC));
                DelayCommand(2.0, HashishCutscene(oPC));
                DelayCommand(6.0, HashishGiveReward(oPC, nTotalItems, TRUE));
                EndDlg();
            }
        }
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
    string sMsg;
    DeleteList(sList, oHolder); // START FRESH PAGE
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        DeleteLocalInt(oHolder, "ZDLG_CONFIRM");
        SetDlgPrompt("Excellent! Where is it?");
        if (!HasItem(oPC, "SKELETON_KNUCKLE")) sMsg = "uhm...";
        else sMsg = "[Give Skeleton's Knuckles]";
        SetMenuOptionInt(sMsg, 1, oHolder);
        return;
   case ZDIALOG_SHOW_MESSAGE:
        DoShowMessage(oHolder);
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
