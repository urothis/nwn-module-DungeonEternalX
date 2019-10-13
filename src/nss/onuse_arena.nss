#include "_functions"
#include "effect_inc"
#include "gen_inc_color"

string GetArenaListSettings(object oItem);

void ResetCrystallBall(object oArea)
{
    location lLoc = GetLocation(GetWaypointByTag("WP_CRYSTAL_BALL_" + IntToString(d3())));
    object oBall = CreateObject(OBJECT_TYPE_PLACEABLE, "crystal_ball", lLoc);

    vector vVec = GetPositionFromLocation(lLoc);
    vVec = Vector(vVec.x, vVec.y, vVec.z - 2.0);
    lLoc = Location(oArea, vVec, 0.0);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_TIME_STOP), lLoc);

    DeleteLocalObject(oArea, "CRYSTAL_BALL_CARRIER");
}

void PlayTimeEffect(object oPC, object oArea, object oSelf)
{
    int nPlayed = GetLocalInt(oArea, "TIMER_PLAYED");
    if (nPlayed >= 3) return;

    if (GetLocalObject(oArea, "CRYSTAL_BALL_CARRIER") != oPC) return;
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_TIME_STOP), oSelf);
    SetLocalInt(oArea, "TIMER_PLAYED", nPlayed++);
    DelayCommand(4.0, PlayTimeEffect(oPC, oArea, oSelf));
}

void PlacingCrystalBall(object oPC, object oArea, object oSelf)
{
    if (!GetIsObjectValid(oPC)) return;
    AssignCommand(oSelf, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));

    if (GetLocalObject(oArea, "CRYSTAL_BALL_CARRIER") != oPC) return;
    DeleteLocalObject(oArea, "CRYSTAL_BALL_CARRIER");

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_WRATH), oSelf);
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_BLINDDEAF), oSelf));

    int nTeam = GetLocalInt(oSelf, "SCORE_FOR_TEAM");
    int nScore1 = GetLocalInt(oArea, "SCORES_TEAM_1");
    int nScore2 = GetLocalInt(oArea, "SCORES_TEAM_2");
    string sMsg;
    if (nTeam == 1)
    {
        nScore1++;
        SetLocalInt(oArea, "SCORES_TEAM_1", nScore1);
        sMsg = "Red";
    }
    else
    {
        nScore2++;
        SetLocalInt(oArea, "SCORES_TEAM_2", nScore2);
        sMsg = "Green";
    }
    sMsg = GetName(oPC) + " has scored for " + sMsg + " Team! " + GetRGB(13, 9, 13) + "Red " + IntToString(nScore1) + " : " + " Green " + IntToString(nScore2);
    SpeakString(sMsg, TALKVOLUME_SHOUT);
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC));
}

void PortTeam(location lPortal, object oDest, int nTeam)
{
   object oPC = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPortal);
   object oDM = GetLastUsedBy();
   while (GetIsObjectValid(oPC))
   {
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, JumpToObject(oDest));
      SendMessageToPC(oDM, "     " + GetName(oPC));
      SetLocalInt(oPC, "STADIUM_TEAM", nTeam);
      oPC = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPortal);
   }
}

void GetOnPodiums(object oArea)
{
    object oWP = GetNearestObjectByTag("WP_ARENA");
    object oPC = GetFirstObjectInArea(oArea);
    while (GetIsObjectValid(oPC))
    {
        if (GetIsPC(oPC))
        {
            if (!GetIsDM(oPC))
            {
                AssignCommand(oPC, ClearAllActions(TRUE));
                StripAllEffects(oPC);
                DelayCommand(0.1, AssignCommand(oPC, JumpToObject(oWP)));
            }
        }
        oPC = GetNextObjectInArea(oArea);
    }
}

void main()
{
    object oPC = GetLastUsedBy();
    object oSelf = OBJECT_SELF;
    string sTag = GetTag(oSelf);
    object oArea = GetArea(oSelf);
    string sAreaTag = GetTag(oArea);
    object oRules   = GetObjectByTag("arena_list");  //Placable where the rules are set and retrieved

    if (sTag == "ARENA_CHAIN")
    {
        if (!GetIsDM(oPC))
        {
            DeleteLocalInt(oPC, "STADIUM_TEAM");
            object oWP = GetNearestObjectByTag("WP_ARENA");
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, JumpToObject(oWP));
            DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE), oPC));
            return;
        }

        if (!GetLocalInt(oSelf, "STATE")) // start game
        {
            location lPortal1 = GetLocation(GetNearestObjectByTag("ARENA_JUMP_1"));
            location lPortal2 = GetLocation(GetNearestObjectByTag("ARENA_JUMP_2"));
            object oDest1 = GetNearestObjectByTag("ARENA_JUMP_1_WP");
            object oDest2 = GetNearestObjectByTag("ARENA_JUMP_2_WP");
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_PWKILL), lPortal1);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), lPortal2);
            PlaySound("as_cv_bell2");
            DelayCommand(1.0, PortTeam(lPortal1, oDest1, 1));
            DelayCommand(1.0, PortTeam(lPortal2, oDest2, 2));
            object oArea = GetArea(oSelf);
            if (sAreaTag == "STADIUM_3") // Crystal ball game
            {
                SetLocalInt(oArea, "SCORES_TEAM_1", 0);
                SetLocalInt(oArea, "SCORES_TEAM_2", 0);
                SetLocalInt(oSelf, "STATE", TRUE); // only in crystal ball arena
            }
        }
        else // only in crystal ball arena
        {
            GetOnPodiums(oArea);
            SetLocalInt(oSelf, "STATE", FALSE);
        }
    }
    else if (sTag == "ARENA_PORTAL")
    {
        object oWP = GetLocalObject(oSelf, "WHICH_ARENA");

        if (GetIsObjectValid(oWP))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_FIRE), oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION), oPC);
            DelayCommand(2.0, AssignCommand(oPC, JumpToObject(oWP)));
        }
        else
            if (GetIsDM(oPC))
                DelayCommand(2.0, AssignCommand(oPC, JumpToObject(GetObjectByTag("STADIUM_RULES_ROOM"))));
            else
                SendMessageToPC(oPC, GetRGB(15,1,1) + "There is no tourney right now, or the tourney is closed.");
    }
    else if (sTag == "ARENA_ON_OFF")
    {
        if (!GetIsDM(oPC)) return;
        object oPortal = DefGetObjectByTag("ARENA_PORTAL");
        string sMsg;
        if (!GetLocalInt(oSelf, "ARENA_ON"))// it is off, turn it on
        {
            object oWP = GetNearestObjectByTag("WP_ARENA");
            SetLocalObject(oPortal, "WHICH_ARENA", oWP);
            SetLocalInt(oSelf, "ARENA_ON", TRUE);
            sMsg = GetRGBColor(CLR_RED) + GetName(oPC) + GetRGBColor(CLR_NEONGREEN) + " is holding a tourney.\n " + GetRGBColor(CLR_ORANGE) + "Go to Loftenwood tavern and use the portal device to be ported." + GetRGBColor(CLR_WHITE);
            SpeakString(sMsg, TALKVOLUME_SHOUT);
            SpeakString(GetArenaListSettings(oRules), TALKVOLUME_SHOUT);
        }
        else // it is on, turn it off
        {
            DeleteLocalInt(oSelf, "ARENA_ON");
            DeleteLocalObject(oPortal, "WHICH_ARENA");
            sMsg = GetRGBColor(CLR_RED) + "Tourney porting is now closed." + GetRGBColor(CLR_WHITE);
            SpeakString(sMsg, TALKVOLUME_SHOUT);
        }
    }
    else if (sTag == "CRYSTAL_BALL_PORTAL")
    {
        object oDest = GetNearestObjectByTag("WP_SPHERE_KEEPER_" + IntToString(GetLocalInt(oPC, "STADIUM_TEAM")));
        ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_DEATH_ARMOR), oPC);
        DelayCommand(0.5, AssignCommand(oPC, JumpToObject(oDest)));
    }
    else if (sTag == "CRYSTAL_BALL")
    {
        if (GetLocalInt(oSelf, "PICKED_ALLREADY")) return;

        // SetLocalInt(oPC, "STADIUM_TEAM", 1); // remove this later, testing script

        SetLocalInt(oSelf, "PICKED_ALLREADY", TRUE);
        SetLocalObject(oArea, "CRYSTAL_BALL_CARRIER", oPC);
        DelayCommand(0.1, DestroyObject(oSelf));
        float fDur = 30.0;
        //StripAllEffects(oPC);
        AssignCommand(oArea, DelayCommand(fDur, ResetCrystallBall(oArea)));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_WRATH), oPC);
        AssignCommand(oArea, DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_FLAG_GOLD_FIXED)), oPC, fDur - 4.5)));

        AssignCommand(oPC, ClearAllActions(TRUE));
    }
    else if (sTag == "SPHERE_KEEPER")
    {
        if (GetLocalObject(oArea, "CRYSTAL_BALL_CARRIER") != oPC) return;
        SetLocalInt(oArea, "TIMER_PLAYED", 1);
        PlayTimeEffect(oPC, oArea, oSelf);

        ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);

        AssignCommand(oPC, ClearAllActions(TRUE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_PARALYZED)), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectCutsceneParalyze()), oPC);
        AssignCommand(oArea, DelayCommand(10.0, PlacingCrystalBall(oPC, oArea, oSelf)));
    }
}

string GetArenaListSettings(object oItem)
{
    string intro    = "";
    string disabled = GetRGBColor(CLR_RED) + "Current tourney options disabled:\n" + GetRGBColor();
    string list     = "";


    if (GetLocalInt(oItem, "arena_casters"))         intro = GetRGBColor(CLR_RED) + "Current rules are:\n" + GetRGBColor() + "Casters only!\n";
    if (GetLocalInt(oItem, "arena_melee"))           intro = GetRGBColor(CLR_RED) + "Current rules are:\n" + GetRGBColor() + "Melee only!\n";
    if (GetLocalInt(oItem, "arena_archers"))         list += "Archers\n";
    if (GetLocalInt(oItem, "arena_mages"))           list += "Mages\n";
    if (GetLocalInt(oItem, "arena_clerics"))         list += "Clerics\n";
    if (GetLocalInt(oItem, "arena_dragons"))         list += "Dragons\n";
    if (GetLocalInt(oItem, "arena_rez"))             list += "Resurrection\n";
    if (GetLocalInt(oItem, "arena_druids"))          list += "Druids\n";
    if (GetLocalInt(oItem, "arena_summons"))         list += "Summons\n";
    if (GetLocalInt(oItem, "arena_bards"))           list += "Bards\n";
    if (GetLocalInt(oItem, "arena_kits"))            list += "Heal kits\n";
    if (GetLocalInt(oItem, "arena_pale"))            list += "Pale Masters\n";
    if (GetLocalInt(oItem, "arena_heals"))           list += "Heals\n";
    if (GetLocalInt(oItem, "arena_offensivespells")) list += "Offensive spells\n";
    if (GetLocalInt(oItem, "arena_umd"))             list += "Offensive UMD spells\n";

    if (GetLocalInt(oItem, "arena_gamemode"))
    {
        list += "\n\n" + GetRGBColor(CLR_YELLOW) + "Specified Game Mode:\n" + GetRGBColor(CLR_WHITE);
        if (GetLocalInt(oItem, "arena_mode_duels"))  list += "Duels\n";
        if (GetLocalInt(oItem, "arena_mode_ffa"))    list += "Free for all\n";
        if (GetLocalInt(oItem, "arena_mode_2v2"))    list += "2v2\n";
        if (GetLocalInt(oItem, "arena_mode_teams"))  list += "Multiple Teams\n";
        if (GetLocalInt(oItem, "arena_mode_ctf"))    list += "Capture the flag\n";
        if (GetLocalInt(oItem, "arena_mode_king"))   list += "King of the hill\n";
    }
    return intro + disabled + list;
}
