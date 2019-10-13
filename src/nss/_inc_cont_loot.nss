//:: Copyright (c) 2005 Dungeon Eternal X
#include "_inc_tclass"
#include "_functions"

void DestroyItem(object oItem)
{
    if(!GetIsPC(GetItemPossessor(oItem)))
    {
        Insured_Destroy(oItem);
    }
}

object Opener = GetLastOpenedBy();
int OpenerLvl = GetHitDice(Opener);

//Equipment
void MakeEquipmentOnObject(int LvlLoot = 0, object Container = OBJECT_SELF)
{
    int i, iRandom;
    string EquipResRef;
    if(LvlLoot == 0){LvlLoot = OpenerLvl;}
    if (LvlLoot > 21)
    {LvlLoot = 21;}
    iRandom = Random(210);
    switch(LvlLoot)
    {
        case 1:
            EquipResRef = MakeTClass(1);
            break;
        case 2:
            if(iRandom <= 210)
            {
                     if(iRandom >= 12){EquipResRef = MakeTClass( 1);}
                else                  {EquipResRef = MakeTClass( 2);}
            }
            break;
        case 3:
            if(iRandom <= 210)
            {
                     if(iRandom >= 27){EquipResRef = MakeTClass( 1);}
                else if(iRandom >=  5){EquipResRef = MakeTClass( 2);}
                else                  {EquipResRef = MakeTClass( 3);}
            }
            break;
        case 4:
            if(iRandom <= 210)
            {
                     if(iRandom >= 41){EquipResRef = MakeTClass( 1);}
                else if(iRandom >= 12){EquipResRef = MakeTClass( 2);}
                else if(iRandom >=  3){EquipResRef = MakeTClass( 3);}
                else                  {EquipResRef = MakeTClass( 4);}
            }
            break;
        case 5:
            if(iRandom <= 210)
            {
                     if(iRandom >= 41){EquipResRef = MakeTClass( 1);}
                else if(iRandom >= 12){EquipResRef = MakeTClass( 2);}
                else if(iRandom >=  5){EquipResRef = MakeTClass( 3);}
                else if(iRandom >=  1){EquipResRef = MakeTClass( 4);}
                else                    {EquipResRef = MakeTClass( 5);}
            }
            break;
        case 6:
            if(iRandom <= 210)
            {
                     if(iRandom >= 62){EquipResRef = MakeTClass( 1);}
                else if(iRandom >= 18){EquipResRef = MakeTClass( 2);}
                else if(iRandom >=  8){EquipResRef = MakeTClass( 3);}
                else if(iRandom >=  3){EquipResRef = MakeTClass( 4);}
                else if(iRandom >=  1){EquipResRef = MakeTClass( 5);}
                else                  {EquipResRef = MakeTClass( 6);}
            }
            break;
        case 7:
            if(iRandom <= 210)
            {
                     if(iRandom >= 62){EquipResRef = MakeTClass( 1);}
                else if(iRandom >= 18){EquipResRef = MakeTClass( 2);}
                else if(iRandom >=  8){EquipResRef = MakeTClass( 3);}
                else if(iRandom >=  5){EquipResRef = MakeTClass( 4);}
                else if(iRandom >=  3){EquipResRef = MakeTClass( 5);}
                else if(iRandom >=  1){EquipResRef = MakeTClass( 6);}
                else                  {EquipResRef = MakeTClass( 7);}
            }
            break;
        case 8:
            if(iRandom <= 210)
            {
                     if(iRandom >= 62){EquipResRef = MakeTClass( 1);}
                else if(iRandom >= 27){EquipResRef = MakeTClass( 2);}
                else if(iRandom >= 12){EquipResRef = MakeTClass( 3);}
                else if(iRandom >=  8){EquipResRef = MakeTClass( 4);}
                else if(iRandom >=  5){EquipResRef = MakeTClass( 5);}
                else if(iRandom >=  3){EquipResRef = MakeTClass( 6);}
                else if(iRandom >=  1){EquipResRef = MakeTClass( 7);}
                else                  {EquipResRef = MakeTClass( 8);}
            }
            break;
        case 9:
            if(iRandom <= 210)
            {
                     if(iRandom >= 62){EquipResRef = MakeTClass( 1);}
                else if(iRandom >= 27){EquipResRef = MakeTClass( 2);}
                else if(iRandom >= 18){EquipResRef = MakeTClass( 3);}
                else if(iRandom >= 12){EquipResRef = MakeTClass( 4);}
                else if(iRandom >=  8){EquipResRef = MakeTClass( 5);}
                else if(iRandom >=  5){EquipResRef = MakeTClass( 6);}
                else if(iRandom >=  3){EquipResRef = MakeTClass( 7);}
                else if(iRandom >=  1){EquipResRef = MakeTClass( 8);}
                else                  {EquipResRef = MakeTClass( 9);}
            }
            break;
        case 10:
            if(iRandom <= 210)
            {
                     if(iRandom >= 93){EquipResRef = MakeTClass( 1);}
                else if(iRandom >= 41){EquipResRef = MakeTClass( 2);}
                else if(iRandom >= 27){EquipResRef = MakeTClass( 3);}
                else if(iRandom >= 18){EquipResRef = MakeTClass( 4);}
                else if(iRandom >= 12){EquipResRef = MakeTClass( 5);}
                else if(iRandom >=  8){EquipResRef = MakeTClass( 6);}
                else if(iRandom >=  5){EquipResRef = MakeTClass( 7);}
                else if(iRandom >=  3){EquipResRef = MakeTClass( 8);}
                else if(iRandom >=  1){EquipResRef = MakeTClass( 9);}
                else                  {EquipResRef = MakeTClass(10);}
            }
            break;
        case 11:
            if(iRandom <= 210)
            {
                     if(iRandom >= 93){EquipResRef = MakeTClass( 1);}
                else if(iRandom >= 62){EquipResRef = MakeTClass( 2);}
                else if(iRandom >= 41){EquipResRef = MakeTClass( 3);}
                else if(iRandom >= 27){EquipResRef = MakeTClass( 4);}
                else if(iRandom >= 18){EquipResRef = MakeTClass( 5);}
                else if(iRandom >= 12){EquipResRef = MakeTClass( 6);}
                else if(iRandom >=  8){EquipResRef = MakeTClass( 7);}
                else if(iRandom >=  5){EquipResRef = MakeTClass( 8);}
                else if(iRandom >=  3){EquipResRef = MakeTClass( 9);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(10);}
                else                  {EquipResRef = MakeTClass(11);}
            }
            break;
        case 12:
            if(iRandom <= 210)
            {
                     if(iRandom >=140){EquipResRef = MakeTClass( 1);}
                else if(iRandom >= 93){EquipResRef = MakeTClass( 2);}
                else if(iRandom >= 62){EquipResRef = MakeTClass( 3);}
                else if(iRandom >= 41){EquipResRef = MakeTClass( 4);}
                else if(iRandom >= 27){EquipResRef = MakeTClass( 5);}
                else if(iRandom >= 18){EquipResRef = MakeTClass( 6);}
                else if(iRandom >= 12){EquipResRef = MakeTClass( 7);}
                else if(iRandom >=  8){EquipResRef = MakeTClass( 8);}
                else if(iRandom >=  5){EquipResRef = MakeTClass( 9);}
                else if(iRandom >=  3){EquipResRef = MakeTClass(10);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(11);}
                else                  {EquipResRef = MakeTClass(12);}
            }
            break;
        case 13:
            if(iRandom <= 210)
            {
                     if(iRandom >=140){EquipResRef = MakeTClass( 2);}
                else if(iRandom >= 93){EquipResRef = MakeTClass( 3);}
                else if(iRandom >= 62){EquipResRef = MakeTClass( 4);}
                else if(iRandom >= 41){EquipResRef = MakeTClass( 5);}
                else if(iRandom >= 27){EquipResRef = MakeTClass( 6);}
                else if(iRandom >= 18){EquipResRef = MakeTClass( 7);}
                else if(iRandom >= 12){EquipResRef = MakeTClass( 8);}
                else if(iRandom >=  8){EquipResRef = MakeTClass( 9);}
                else if(iRandom >=  5){EquipResRef = MakeTClass(10);}
                else if(iRandom >=  3){EquipResRef = MakeTClass(11);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(12);}
                else                  {EquipResRef = MakeTClass(13);}
            }
            break;
        case 14:
            if(iRandom <= 210)
            {
                     if(iRandom >=140){EquipResRef = MakeTClass( 3);}
                else if(iRandom >= 93){EquipResRef = MakeTClass( 4);}
                else if(iRandom >= 62){EquipResRef = MakeTClass( 5);}
                else if(iRandom >= 41){EquipResRef = MakeTClass( 6);}
                else if(iRandom >= 27){EquipResRef = MakeTClass( 7);}
                else if(iRandom >= 18){EquipResRef = MakeTClass( 8);}
                else if(iRandom >= 12){EquipResRef = MakeTClass( 9);}
                else if(iRandom >=  8){EquipResRef = MakeTClass(10);}
                else if(iRandom >=  5){EquipResRef = MakeTClass(11);}
                else if(iRandom >=  3){EquipResRef = MakeTClass(12);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(13);}
                else                  {EquipResRef = MakeTClass(14);}
            }
            break;
        case 15:
            if(iRandom <= 210)
            {
                     if(iRandom >=140){EquipResRef = MakeTClass( 4);}
                else if(iRandom >= 93){EquipResRef = MakeTClass( 5);}
                else if(iRandom >= 62){EquipResRef = MakeTClass( 6);}
                else if(iRandom >= 41){EquipResRef = MakeTClass( 7);}
                else if(iRandom >= 27){EquipResRef = MakeTClass( 8);}
                else if(iRandom >= 18){EquipResRef = MakeTClass( 9);}
                else if(iRandom >= 12){EquipResRef = MakeTClass(10);}
                else if(iRandom >=  8){EquipResRef = MakeTClass(11);}
                else if(iRandom >=  5){EquipResRef = MakeTClass(12);}
                else if(iRandom >=  3){EquipResRef = MakeTClass(13);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(14);}
                else                  {EquipResRef = MakeTClass(15);}
            }
            break;
        case 16:
            if(iRandom <= 210)
            {
                     if(iRandom >=140){EquipResRef = MakeTClass( 5);}
                else if(iRandom >= 93){EquipResRef = MakeTClass( 6);}
                else if(iRandom >= 62){EquipResRef = MakeTClass( 7);}
                else if(iRandom >= 41){EquipResRef = MakeTClass( 8);}
                else if(iRandom >= 27){EquipResRef = MakeTClass( 9);}
                else if(iRandom >= 18){EquipResRef = MakeTClass(10);}
                else if(iRandom >= 12){EquipResRef = MakeTClass(11);}
                else if(iRandom >=  8){EquipResRef = MakeTClass(12);}
                else if(iRandom >=  5){EquipResRef = MakeTClass(13);}
                else if(iRandom >=  3){EquipResRef = MakeTClass(14);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(15);}
                else                  {EquipResRef = MakeTClass(16);}
            }
            break;
        case 17:
            if(iRandom <= 210)
            {
                     if(iRandom >=140){EquipResRef = MakeTClass( 6);}
                else if(iRandom >= 93){EquipResRef = MakeTClass( 7);}
                else if(iRandom >= 62){EquipResRef = MakeTClass( 8);}
                else if(iRandom >= 41){EquipResRef = MakeTClass( 9);}
                else if(iRandom >= 27){EquipResRef = MakeTClass(10);}
                else if(iRandom >= 18){EquipResRef = MakeTClass(11);}
                else if(iRandom >= 12){EquipResRef = MakeTClass(12);}
                else if(iRandom >=  8){EquipResRef = MakeTClass(13);}
                else if(iRandom >=  5){EquipResRef = MakeTClass(14);}
                else if(iRandom >=  3){EquipResRef = MakeTClass(15);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(16);}
                else                  {EquipResRef = MakeTClass(17);}
            }
            break;
        case 18:
            if(iRandom <= 210)
            {
                     if(iRandom >=140){EquipResRef = MakeTClass( 7);}
                else if(iRandom >= 93){EquipResRef = MakeTClass( 8);}
                else if(iRandom >= 62){EquipResRef = MakeTClass( 9);}
                else if(iRandom >= 41){EquipResRef = MakeTClass(10);}
                else if(iRandom >= 27){EquipResRef = MakeTClass(11);}
                else if(iRandom >= 18){EquipResRef = MakeTClass(12);}
                else if(iRandom >= 12){EquipResRef = MakeTClass(13);}
                else if(iRandom >=  8){EquipResRef = MakeTClass(14);}
                else if(iRandom >=  5){EquipResRef = MakeTClass(15);}
                else if(iRandom >=  3){EquipResRef = MakeTClass(16);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(17);}
                else                  {EquipResRef = MakeTClass(18);}
            }
            break;
        case 19:
            if(iRandom <= 210)
            {
                     if(iRandom > 140){EquipResRef = MakeTClass( 8);}
                else if(iRandom >= 93){EquipResRef = MakeTClass( 9);}
                else if(iRandom >= 62){EquipResRef = MakeTClass(10);}
                else if(iRandom >= 41){EquipResRef = MakeTClass(11);}
                else if(iRandom >= 27){EquipResRef = MakeTClass(12);}
                else if(iRandom >= 18){EquipResRef = MakeTClass(13);}
                else if(iRandom >= 12){EquipResRef = MakeTClass(14);}
                else if(iRandom >=  8){EquipResRef = MakeTClass(15);}
                else if(iRandom >=  5){EquipResRef = MakeTClass(16);}
                else if(iRandom >=  3){EquipResRef = MakeTClass(17);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(18);}
                else                  {EquipResRef = MakeTClass(19);}
            }
            break;
        case 20:
            if(iRandom <= 210)
            {
                     if(iRandom >=209){EquipResRef = MakeTClass(10);}
                else if(iRandom >= 93){EquipResRef = MakeTClass(11);}
                else if(iRandom >= 62){EquipResRef = MakeTClass(12);}
                else if(iRandom >= 41){EquipResRef = MakeTClass(13);}
                else if(iRandom >= 27){EquipResRef = MakeTClass(14);}
                else if(iRandom >=180){EquipResRef = MakeTClass(15);}
                else if(iRandom >=150){EquipResRef = MakeTClass(16);}
                else if(iRandom >=130){EquipResRef = MakeTClass(17);}
                else if(iRandom >=100){EquipResRef = MakeTClass(18);}
                else if(iRandom >= 50){EquipResRef = MakeTClass(19);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(20);}
                else                  {EquipResRef = MakeTClass(21);}

           }
            break;
        case 21:
            if(iRandom <= 210)
            {
                     if(iRandom >=140){EquipResRef = MakeTClass(18);}
                else if(iRandom >= 93){EquipResRef = MakeTClass(18);}
                else if(iRandom >= 62){EquipResRef = MakeTClass(18);}
                else if(iRandom >= 41){EquipResRef = MakeTClass(19);}
                else if(iRandom >= 27){EquipResRef = MakeTClass(19);}
                else if(iRandom >= 18){EquipResRef = MakeTClass(19);}
                else if(iRandom >= 12){EquipResRef = MakeTClass(20);}
                else if(iRandom >=  8){EquipResRef = MakeTClass(20);}
                else if(iRandom >=  5){EquipResRef = MakeTClass(20);}
                else if(iRandom >=  3){EquipResRef = MakeTClass(21);}
                else if(iRandom >=  1){EquipResRef = MakeTClass(21);}
                else                  {EquipResRef = MakeTClass(21);}
            }
            break;

    object oItem = CreateItemOnObject(EquipResRef);
    }
}

//Potions
/*void MakePotionsOnObject(int LvlLoot = 0, object Container = OBJECT_SELF)
{
    string PotResRef;
    if(LvlLoot == 0){LvlLoot = OpenerLvl;}
             if(LvlLoot > 20){PotResRef = AssignRandomPotionResRef(5);}
        else if(LvlLoot > 15){PotResRef = AssignRandomPotionResRef(4);}
        else if(LvlLoot > 10){PotResRef = AssignRandomPotionResRef(3);}
        else if(LvlLoot >  5){PotResRef = AssignRandomPotionResRef(2);}
        else                 {PotResRef = AssignRandomPotionResRef(1);}

    object oItem = CreateItemOnObject(PotResRef);
}
*/
//Healing Kits
void MakeKitsOnObject(int LvlLoot = 0, object Container = OBJECT_SELF)
{
    string KitResRef;
    if(LvlLoot == 0)    {LvlLoot = OpenerLvl;}
             if(LvlLoot > 15){KitResRef = AssignKitResRef(4);}
        else if(LvlLoot > 10){KitResRef = AssignKitResRef(3);}
        else if(LvlLoot >  5){KitResRef = AssignKitResRef(2);}
        else                 {KitResRef = AssignKitResRef(1);}
    object oItem = CreateItemOnObject(KitResRef);
}

//Scrolls
/*void MakeScrollsOnObject(int LvlLoot = 0, object Container = OBJECT_SELF)
{
    string ScrollResRef;
    if(LvlLoot == 0)    {LvlLoot = OpenerLvl;}
             if(LvlLoot > 20){ScrollResRef = AssignRandomScrollResRef(5);}
        else if(LvlLoot > 15){ScrollResRef = AssignRandomScrollResRef(4);}
        else if(LvlLoot > 10){ScrollResRef = AssignRandomScrollResRef(3);}
        else if(LvlLoot >  5){ScrollResRef = AssignRandomScrollResRef(2);}
        else                 {ScrollResRef = AssignRandomScrollResRef(1);}
    object oItem = CreateItemOnObject(ScrollResRef);
}
 */
//GEMS
void MakeGemsOnObject(int LvlLoot = 0, object Container = OBJECT_SELF)
{
    string GemResRef;
    if(LvlLoot == 0)    {LvlLoot = OpenerLvl;}
             if(LvlLoot > 18){GemResRef = AssignGemResRef(10);}
        else if(LvlLoot > 16){GemResRef = AssignGemResRef(9);}
        else if(LvlLoot > 14){GemResRef = AssignGemResRef(8);}
        else if(LvlLoot > 12){GemResRef = AssignGemResRef(7);}
        else if(LvlLoot > 10){GemResRef = AssignGemResRef(6);}
        else if(LvlLoot >  8){GemResRef = AssignGemResRef(5);}
        else if(LvlLoot >  6){GemResRef = AssignGemResRef(4);}
        else if(LvlLoot >  4){GemResRef = AssignGemResRef(3);}
        else if(LvlLoot >  2){GemResRef = AssignGemResRef(2);}
        else                 {GemResRef = AssignGemResRef(1);}
    object oItem = CreateItemOnObject(GemResRef);
}

//if it returns 0 makes other functions use character lvl else returns highest possible lvl for that particular area
int ReturnMaxLvl(object Container = OBJECT_SELF)
{
    int LootLvlLimit;
    int ReturnValue = 1;
    string IS_LIMIT = GetStringLeft(GetTag(GetArea(Container)), 3);
    if(GetStringLeft(IS_LIMIT, 1) == "_"){
        LootLvlLimit = StringToInt(GetStringRight(IS_LIMIT, 2));

        if(OpenerLvl > LootLvlLimit)    ReturnValue = LootLvlLimit;
        else    ReturnValue = OpenerLvl;
    }
    else    ReturnValue = OpenerLvl;
    return ReturnValue;
}

//used to make low ammounts loot in a container. note: container must be the caller
void MakeLowContainerLoot(int LootLvlSelect)
{
    int i, iGold;
    for(i = 0; i < 3; i++)
    {
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
    }
}

//used to make moderate loot in a container. note: container must be the caller
void MakeMedContainerLoot(int LootLvlSelect){
    int i, iGold;
    for(i = 0; i < 6; i++)
    {
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
        if (d10() == 1)  MakeGemsOnObject(LootLvlSelect);
    }
}

//used to make high ammounts loot in a container. this will make ALOT of loot so use it sparingly note: container must be the caller
void MakeHighContainerLoot(int LootLvlSelect){
    int i, iGold;
    for(i = 0; i < 10; i++)
    {
        if (d10() == 1) { MakeGemsOnObject(LootLvlSelect); }
        if (d10() == 1) { MakeGemsOnObject(LootLvlSelect); }
        if (d10() == 1) { MakeGemsOnObject(LootLvlSelect); }
        if (d10() == 1) { MakeGemsOnObject(LootLvlSelect); }
        if (d10() == 1) { MakeGemsOnObject(LootLvlSelect); }
        if (d10() == 1) { MakeGemsOnObject(LootLvlSelect); }
    }
}
