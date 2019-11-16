#include "gen_inc_color"
#include "_functions"

string LoftGossipTalk(int nRoll)
{
    switch (nRoll)
    {
        case 1: return "Baba Yaga sells a range of Weapon and Ability buffs";
        case 2: return "Fighting the Undead? Make sure u get your weapon blessed at Baba Yagas";
        case 3: return "Baba Yaga sells Heal Kits for the budding adventurer";
        case 4: return "Poisons and Traps can be purchased at the general store in Loftenwood";
        case 5: return "True Seeing needs a Listen or Spot Skill of 65";
        case 6: return "The CR rating is to ensure you get maximum xp, if you’re higher than the CR of an area move on";
        case 7: return "Dex is a full pvp server, level at your own risk!";
        case 8: return "New adventurers may want to check the Library in Loftenwood Tavern for any Class/Spell changes";
        case 9: return "There are many player factions in Dex, check forums for more information";
        case 10: return "New player receive a fame-boost";
        case 11: return "You can exchange old damage stones into new ones in the Temple of Adaghar.\nDamage stones can be extracted from old weapons.\nOn-Hit Rods can be converted into random rare stones.";
        case 12: return "Some areas got increased specific item drops.";
        case 13: return "You can donate XP for fame at bank.";
        case 14: return "Don’t forget to check your journal!";
        case 15: return "Visit us at https://DungeonEternalX.com";
    }
    return "Visit us at https://DungeonEternalX.com";
}


void main()
{
    object oPC = GetEnteringObject();
    if (GetIsPC(oPC)) DelayCommand(10.0, ActionSendMessageToPC(oPC, GetRGB(1,7,7) + LoftGossipTalk(Random(15)+1)));

    ExecuteScript("_mod_areaenter", OBJECT_SELF);
}
