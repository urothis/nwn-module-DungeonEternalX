#include "quest_inc"

void main()
{
    object oPC = GetLastOpenedBy();
    object oSelf = OBJECT_SELF;
    if (GetPCPlayerName(oPC) != "Ezramun") return;
    LootCreateGems(oSelf, 2000000, 2000000);
}
