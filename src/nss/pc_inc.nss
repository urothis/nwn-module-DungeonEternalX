int pcCountParty(object oMinion);
//Is the object within fDist of OBJECT_SELF?
int pcIsClose(object oObject, float fDist = 50.0);
int pcGetNetWorth(object oPC);
int pcGetHDFromXP(int nXP, int nHD = 1);
int pcGetRealLevel(object oPC);
int pcGetXPByLevel(int nLevel);
int pcGetIsPCInArea(object oArea = OBJECT_SELF);


int pcCountParty(object oMinion)
{
   object oParty = GetFirstFactionMember(oMinion);
   int nCnt = 0;
   while (GetIsObjectValid(oParty))
   {
      if (GetArea(oParty) == GetArea(oMinion)) nCnt++;
      oParty = GetNextFactionMember(oMinion);
   }
   return nCnt;
}

int pcIsClose(object oObject, float fDist = 50.0)
{
   return (GetArea(OBJECT_SELF) == GetArea(oObject) && GetDistanceBetween(OBJECT_SELF, oObject) < fDist);
}

int pcGetNetWorth(object oPC)
{
   int iSlot=0;
   int iGP = 0;
   object oItem;
   for(iSlot = 0; iSlot < NUM_INVENTORY_SLOTS; iSlot++) {
      oItem = GetItemInSlot(iSlot, oPC);
      if (GetIsObjectValid(oItem)) iGP = iGP + GetGoldPieceValue(oItem);
   }
   oItem=GetFirstItemInInventory(oPC);
   while(GetIsObjectValid(oItem)) {
      iGP = iGP + GetGoldPieceValue(oItem);
      oItem = GetNextItemInInventory(oPC);
   }
   return iGP;
}

int pcGetHDFromXP(int nXP, int nHD = 1)
{
   int nNextLvl;
   int nNextXP;
   int i;
   for (i = nHD; i<=40; i++) {
      nNextLvl = i + 1;
      nNextXP = ((nNextLvl * (nNextLvl - 1)) / 2) * 1000;
      if (nXP < nNextXP) return i;
   }
   return nHD;
}

int pcGetRealLevel(object oPC)
{
   int nXP = GetXP(oPC);
   int nHD = GetHitDice(oPC);
   return pcGetHDFromXP(nXP, nHD);
}

int pcGetXPByLevel(int nLevel)
{
   return ((nLevel * (nLevel - 1)) / 2) * 1000;
}

int pcGetIsPCInArea(object oArea = OBJECT_SELF)
{
  object oPC = GetFirstObjectInArea(oArea);
  if (!GetIsPC(oPC)) oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC);
  return (GetArea(oPC) == oArea) ? TRUE : FALSE;
}
//void main(){}
