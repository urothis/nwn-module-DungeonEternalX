#include "nw_i0_plot"
#include "inc_traininghall"
#include "_functions"

void main()
{
    object oPC = GetPCSpeaker();
    if (GetIsTestChar(oPC))
    {
        DestroyInventory(oPC);
        CreateCursedItem("nw_it_mpotion016", oPC, 5); // Aid
        CreateCursedItem("nw_it_mpotion009", oPC, 5); // Bless
        CreateCursedItem("nw_it_mpotion015", oPC, 5); // Bullstrength
        CreateCursedItem("nw_it_mpotion014", oPC, 5); // Cats Grace
        CreateCursedItem("nw_it_mpotion010", oPC, 5); // Eagles Splendor
        CreateCursedItem("nw_it_mpotion017", oPC, 5); // Fox Cunning
        CreateCursedItem("nw_it_mpotion018", oPC, 5); // Owls Wisdom
        CreateCursedItem("nw_it_mpotion013", oPC, 5); // Endurance
        CreateCursedItem("nw_it_sparscr606", oPC, 5); // True Seeing
        CreateCursedItem("potionofmagearmo", oPC, 5);
        CreateCursedItem("featenhancer", oPC);
        CreateCursedItem("fighterdodge", oPC);
        CreateCursedItem("rangerdodge", oPC);
        AssignCommand(OBJECT_SELF, SpeakString("There you go! Check your inventory."));
    }
    else AssignCommand(OBJECT_SELF, SpeakString("Sorry, my services are only for [test] character"));
}


