#include "db_inc"
#include "nw_i0_plot"
#include "_inc_death"
#include "flel_arena"
#include "sfsubr_functs"

void OnPCRespawn(object oPC) // SAVE PC STATUS
{
    dbUpdatePlayerStatus(oPC);
}

void main()
{
    object oMod = GetModule();
    object oPC = GetLastRespawnButtonPresser();

    SetCommandable(FALSE, oPC);
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectHaste()), oPC));
    // Added so PC's can fight in the arena without death penalties
    // Arena Script - won't take XP or gold if a PC dies in an arena
    effect eFx = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    object oArea = GetArea(oPC);
    string sAreaTag = GetTag(oArea);

    if (sAreaTag == "MAP_JAIL" || sAreaTag == "MAP_TRAININGHALL")
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPC);
        DelayCommand(0.2, ForceRest(oPC));
        return;
    }

    if (GetIsDeXStadium(sAreaTag))
    {
        AssignCommand(oPC, ClearAllActions(TRUE));
        string sWP = "WP_ARENA";
        if (sAreaTag == "STADIUM_3")
        {
            int nTeam = GetLocalInt(oPC, "STADIUM_TEAM");
            if (nTeam)
            {
                sWP = "ARENA_JUMP_" + IntToString(nTeam) + "_WP";
                DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_PARALYZED)), oPC, 30.0));
                DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectCutsceneParalyze()), oPC, 30.0));
            }
        }
        AssignCommand(oPC, JumpToObject(GetNearestObjectByTag(sWP)));

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFx, oPC, 2.0);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPC);

        DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPC)),oPC));
        DelayCommand(0.2, ForceRest(oPC));
        return;
    }
    /*if (sAreaTag == "DEXBLOOD")
    {
        string sTeam = GetLocalString(oPC, "BL_TEAM");
        location lTeam;
        if (sTeam=="RED") {
           lTeam = GetLocation(GetObjectByTag("BL_SPAWN_RED"));
        } else {
           lTeam = GetLocation(GetObjectByTag("BL_SPAWN_GREEN"));
        }
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFx, oPC, 2.0);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPC);
        AssignCommand(oPC, JumpToLocation(lTeam));
        DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPC)),oPC));
        DelayCommand(0.2, ForceRest(oPC));
        return;
    }*/

    if (sAreaTag == "Arena")
    {
        // Res the PC and end this script - so PC will res in the arena with no penalties
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFx, oPC, 2.0);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPC)),oPC);
        ForceRest(oPC);
        object oTarget = DefGetObjectByTag("ARENA_ENTRY", GetWPHolder());
        location lTarget = GetLocation(oTarget);
        AssignCommand(oPC, JumpToLocation(lTarget));
        return;
    }

    int nHD = GetHitDice(oPC);
    int nXP = GetXP(oPC);
    string sName = GetName(oPC);
    string sRespawnWP = "Ethereal_Enter";
    if (sAreaTag == "MAP_TRAININGHALL" || sAreaTag == "MAP_JAIL") sRespawnWP = "";
    RespawnChar(oPC, sRespawnWP);
    DeathPenaltyGrave(oPC, nHD, nXP, sName);

    SF_ApplySubraceSpellResistance(oPC);
    SetCommandable(TRUE,oPC);
    OnPCRespawn(oPC);
    /*int i = (GetLocalInt(oMod, "GHOSTCURRENT") + 1) % GetLocalInt(oMod, "GHOSTCOUNT");
    SetLocalInt(oMod, "GHOSTCURRENT", i);
    SetName(GetObjectByTag("LostSpirit", i), "Ghost of " + GetName(oRespawner));*/

    //ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oRespawner)),oRespawner);

}
