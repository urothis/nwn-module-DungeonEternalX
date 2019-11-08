//::///////////////////////////////////////////////
//:: General Treasure Spawn Script   LOW
//::///////////////////////////////////////////////
#include "_inc_cont_loot"
#include "time_func"

void main(){
    if(WaitInterval(600) == TRUE){
        int LootLvl = ReturnMaxLvl();
        MakeLowContainerLoot(LootLvl);
    }
}

