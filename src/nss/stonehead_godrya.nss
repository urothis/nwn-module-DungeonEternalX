#include "_functions"
#include "_inc_port"
#include "pg_lists_i"
#include "random_loot_inc"
#include "nw_i0_plot"
#include "quest_inc"
#include "pc_inc"

void GiveFOM(object oStonehead, object oArea, object oPC)
{
    object oWP = GetNearestObjectByTag("WP_STONEHEAD_CSEXIT", oStonehead);
    AssignCommand(oStonehead, DelayCommand(0.5, ActionCastSpellAtObject(SPELL_FREEDOM_OF_MOVEMENT, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));
    AssignCommand(oPC, DelayCommand(2.5, ActionForceFollowObject(oStonehead, 1.0)));
    AssignCommand(oStonehead, SpeakString("You gonna need that spell. I gave you 10 Potions aswell."));
    AssignCommand(oStonehead, DelayCommand(2.0, SpeakString("Follow me, i show you the way.")));
    AssignCommand(oStonehead, DelayCommand(4.0, ActionForceMoveToObject(oWP, TRUE)));
}

void PortToWP(object oArea, object oWP, object oStonehead, object oPC)
{
    AssignCommand(oPC, JumpToObject(oWP));
    SetCameraMode(oPC, CAMERA_MODE_CHASE_CAMERA);
    AssignCommand(oPC, ActionForceFollowObject(oStonehead, 3.0));
}

void StoneheadCutscenePreparePort(object oPC, object oArea)
{
    object oWPNPC      = GetNearestObjectByTag("WP_STONEHEAD_NPC");
    object oWPPC       = GetNearestObjectByTag("WP_STONEHEAD_PC");

    object oStonehead  = CreateObject(OBJECT_TYPE_CREATURE, "stonehead", GetLocation(oWPNPC), FALSE, "STONEHEAD2");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), oWPNPC);
    SetPortMode(oPC, PORT_NOT_ALLOWED);

    ActionDoCommand(SetCutsceneMode(oPC, TRUE, FALSE));
    ActionDoCommand(FadeToBlack(oPC));
    ActionWait(2.0);
    ActionDoCommand(AssignCommand(oArea, PortToWP(oArea, oWPPC, oStonehead, oPC)));
    ActionDoCommand(FadeFromBlack(oPC));
    ActionWait(2.0);
    ActionDoCommand(AssignCommand(oStonehead, ActionCastFakeSpellAtObject(SPELL_NATURES_BALANCE, oStonehead)));
    ActionWait(1.0);
    ActionDoCommand(AssignCommand(oArea, GiveFOM(oStonehead, oArea, oPC)));
    ActionWait(14.0);
    ActionDoCommand(FadeToBlack(oPC));
    ActionWait(2.0);
    ActionDoCommand(SetCutsceneMode(oPC, FALSE, TRUE));
    ActionDoCommand(AssignCommand(oPC, ClearAllActions()));
    ActionDoCommand(DestroyObject(oStonehead));
    ActionDoCommand(SetPortMode(oPC));
    ActionDoCommand(AssignCommand(oPC, JumpToObject(GetWaypointByTag("WP_DRYAD_PC"))));
}


void main()
{
    object oPC = GetPCSpeaker();
    object oArea = GetArea(OBJECT_SELF);
    if (!HasItem(oPC, "BAR_OF_SILVER"))
    {
        SpeakString("Lies! You got no good silver bar!");
        return;
    }

    TakeNumItems(oPC, "BAR_OF_SILVER", 1);
    Q_UpdateQuest(oPC, "3");

    oArea = GetObjectByTag("ENCHASSARA_CAVE_2");
    int nDoLater = GetLocalInt(OBJECT_SELF, "DO_IT_LATER");

    if (nDoLater || pcGetIsPCInArea(oArea))
    {
        SpeakString("Ooooh, someone else in there now, let's do it little later.");
        return;
    }
    SetLocalInt(oPC, "DO_GOBLIN_VS_DRYAD", TRUE);
    SetLocalInt(OBJECT_SELF, "DO_IT_LATER", TRUE);
    DelayCommand(60.0, DeleteLocalInt(OBJECT_SELF, "DO_IT_LATER"));
    string sTRUEID = IntToString(dbGetTRUEID(oPC));

    object oPotion = CopyItem(LootGetItemByTag("LOOT_POT_FOM"), OBJECT_SELF, TRUE);
    SetItemStackSize(oPotion, 10);
    ActionGiveItem(oPotion, oPC);

    NWNX_SQL_ExecuteQuery("select st_stonehead from statistics where st_trueid=" + sTRUEID);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ExecuteQuery("update statistics set st_stonehead=st_stonehead+1 where st_trueid=" + sTRUEID);
    }
    else NWNX_SQL_ExecuteQuery("insert into statistics (st_trueid,st_stonehead) values (" + sTRUEID + ",1)");
    SetLocalObject(oArea, "DRYAD_BOSS_PLAYER", oPC);
    DelayCommand(1.0, StoneheadCutscenePreparePort(oPC, oArea));
}
