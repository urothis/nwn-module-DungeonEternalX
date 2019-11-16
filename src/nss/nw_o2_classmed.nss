//::///////////////////////////////////////////////
//:: General Treasure Spawn Script   MEDIUM
//::///////////////////////////////////////////////
#include "_inc_cont_loot"
#include "time_func"

void main(){
    if(WaitInterval(600) == TRUE){
        int LootLvl = ReturnMaxLvl();
        MakeMedContainerLoot(LootLvl);
    }
}
