//::///////////////////////////////////////////////
//:: General Treasure Spawn Script   HIGH
//::///////////////////////////////////////////////
#include "_inc_cont_loot"
#include "time_func"

void main(){
    if(WaitInterval(600) == TRUE){
        int LootLvl = ReturnMaxLvl();
        MakeHighContainerLoot(LootLvl);
    }
}
