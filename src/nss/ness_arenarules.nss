#include "gen_inc_color"

//Deletes all the local ints specified in this function.
void ArenaResetAll(object oItem);
//Gets a generated string based on settings set in the rules room.
string GetArenaListSettings(object oItem);

void main()
{
    object oItem    = OBJECT_SELF;     //Device being used
    object oPC      = GetLastUsedBy();
    object oRules   = GetObjectByTag("arena_list");  //Placable where the rules are set and retrieved
    string sTag     = GetTag(oItem);   //Tag of the placable

    if (!GetIsDM(oPC))
    {
        if (GetIsPC(oPC) == TRUE && sTag == "stadium_list")
            SendMessageToPC(oPC, GetArenaListSettings(oRules));
        return;
    }

    if (sTag == "arena_archers")         { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_mages")           { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_clerics")         { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_dragons")         { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_rez")             { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_druids")          { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_summons")         { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_bards")           { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_kits")            { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_pale")            { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_heals")           { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_offensivespells") { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_umd")             { SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_resetall")        { ArenaResetAll(oRules);           return; }
    if (sTag == "arena_casters")         { ArenaResetAll(oRules); SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_melee")           { ArenaResetAll(oRules); SetLocalInt(oRules, sTag, TRUE); return; }

    string sList = GetArenaListSettings(oItem);
    if (sTag == "arena_list")            { ActionDoCommand(SpeakString(sList)); return; }
    if (sTag == "stadium_list")          { SpeakString(GetArenaListSettings(oRules), TALKVOLUME_SHOUT); }

    //Game Mode settings
    if (sTag == "arena_mode_duels")      { SetLocalInt(oRules, "arena_gamemode", TRUE); SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_mode_ffa")        { SetLocalInt(oRules, "arena_gamemode", TRUE); SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_mode_2v2")        { SetLocalInt(oRules, "arena_gamemode", TRUE); SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_mode_teams")      { SetLocalInt(oRules, "arena_gamemode", TRUE); SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_mode_ctf")        { SetLocalInt(oRules, "arena_gamemode", TRUE); SetLocalInt(oRules, sTag, TRUE); return; }
    if (sTag == "arena_mode_king")       { SetLocalInt(oRules, "arena_gamemode", TRUE); SetLocalInt(oRules, sTag, TRUE); return; }

    return;
}

void ArenaResetAll(object oItem)
{
    DeleteLocalInt(oItem, "arena_archers");
    DeleteLocalInt(oItem, "arena_mages");
    DeleteLocalInt(oItem, "arena_clerics");
    DeleteLocalInt(oItem, "arena_dragons");
    DeleteLocalInt(oItem, "arena_melee");
    DeleteLocalInt(oItem, "arena_rez");
    DeleteLocalInt(oItem, "arena_casters");
    DeleteLocalInt(oItem, "arena_druids");
    DeleteLocalInt(oItem, "arena_summons");
    DeleteLocalInt(oItem, "arena_bards");
    DeleteLocalInt(oItem, "arena_kits");
    DeleteLocalInt(oItem, "arena_pale");
    DeleteLocalInt(oItem, "arena_heals");
    DeleteLocalInt(oItem, "arena_offensivespells");
    DeleteLocalInt(oItem, "arena_umd");

    //Game Mode vars
    DeleteLocalInt(oItem, "arena_gamemode");
    DeleteLocalInt(oItem, "arena_mode_duels");
    DeleteLocalInt(oItem, "arena_mode_ffa");
    DeleteLocalInt(oItem, "arena_mode_2v2");
    DeleteLocalInt(oItem, "arena_mode_teams");
    DeleteLocalInt(oItem, "arena_mode_ctf");
    DeleteLocalInt(oItem, "arena_mode_king");
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
