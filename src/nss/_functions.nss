#include "_inc_despawn"
#include "inc_server"
#include "nwnx_creature"

const int BIT1  =           1;
const int BIT2  =           2;
const int BIT3  =           4;
const int BIT4  =           8;
const int BIT5  =          16;
const int BIT6  =          32;
const int BIT7  =          64;
const int BIT8  =         128;
const int BIT9  =         256;
const int BIT10 =         512;
const int BIT11 =        1024;
const int BIT12 =        2048;
const int BIT13 =        4096;
const int BIT14 =        8192;
const int BIT15 =       16384;
const int BIT16 =       32768;
const int BIT17 =       65536;
const int BIT18 =      131072;
const int BIT19 =      262144;
const int BIT20 =      524288;
const int BIT21 =     1048576;
const int BIT22 =     2097152;
const int BIT23 =     4194304;
const int BIT24 =     8388608;
const int BIT25 =    16777216;
const int BIT26 =    33554432;
const int BIT27 =    67108864;
const int BIT28 =   134217728;
const int BIT29 =   268435456;
const int BIT30 =   536870912;
const int BIT31 =  1073741824;



int IsDev(object oPC);
// Create an item with the template sItemTemplate in oTarget's inventory,
// and flag it as Plot and Curse
// - nStackSize: This is the stack size of the item to be created
// - sNewTag: If this string is not empty, it will replace the default tag from the template
// * Return value: The object that has been created.  On error, this returns
//   OBJECT_INVALID.
// If the item created was merged into an existing stack of similar items,
// the function will return the merged stack object. If the merged stack
// overflowed, the function will return the overflowed stack that was created.
object CreateCursedItem(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="");

// * Destroy a single object by resref
void Insured_Destroy(object oObject);

// Destroys the object with float seconds
void Insured_Destroy_Delay(object oObject, float fDelay);

// Locks specified object. Must be lockable. This is up to the programmer to know better!
void LockObject(object oObject);

// Locks specified object after fDelay seconds. Must be lockable. This is up to the programmer to know better!
void LockObjectDelay(object oObject, float fDelay);

// Simple close door script.
void CloseDoor(object oObject);

// Simple delayed (seconds) close door script.
void CloseDoorDelay(object oObject, float fDelay);

// Get the object with the specified tag.
// * Returns OBJECT_INVALID if the object cannot be found.
// oStored is the Object where LocalVariable is stored as cache
object DefGetObjectByTag(string sTag, object oStored=OBJECT_SELF);

// Get the Baseitemtype-Name of oItem (It use 2da file)
string GetNameByBaseItemType2da(int nBaseItemType);

// XP Bonus is the multiplier, set to 2 for double XP, 3 for triple ...
void ActionCreateObject(int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="", int nXpBonus = FALSE, int nDespawn = FALSE);
void DoFlameOfLife(object oTarget);
// oPC = The pc that is checked, oArea = his current Area, fDist = the distance to check for enemies
int GetIsHostilePcNearby(object oPC, object oArea, float fDist, int nCheckLevel = 0);

// Destroy all items in inventory
void DestroyInventory(object oPC);
void UnequipItem(object oPC, object oItem);

// Return TRUE if AreaTag start with "STADIUM"
int GetIsDeXStadium(string sAreaTag);

// duplicates the item and returns a new object
// oItem - item to copy
// oTargetInventory - create item in this object's inventory. If this parameter
//                    is not valid, the item will be created in oItem's location
// nCount - how often
// bCopyVars - copy the local variables from the old item to the new one
void ActionCopyItem(object oItem, object oTargetInventory=OBJECT_INVALID, int nCount=1, int bCopyVars=FALSE);

// Create an item with the template sItemTemplate in oTarget's inventory.
// - nStackSize: This is the stack size of the item to be created
// - sNewTag: If this string is not empty, it will replace the default tag from the template
// * Return value: The object that has been created.  On error, this returns
//   OBJECT_INVALID.
// If the item created was merged into an existing stack of similar items,
// the function will return the merged stack object. If the merged stack
// overflowed, the function will return the overflowed stack that was created.
void ActionCreateItemOnObject(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="");

// Get if base item type is equipable (BASE_ITEM_*)
int GetIsEquipable(int nBaseItemType);

// Function checks if oPC is valid before sending message, use this if action is delayed.
void ActionSendMessageToPC(object oPC, string sMsg);

// Function checks if oPC is valid before sending message, use this if action is delayed.
void ActionFloatingTextStringOnCreature(string sStringToDisplay, object oCreatureToFloatAbove, int bBroadcastToFaction=TRUE);

// Check if oTarget is Player. Return FALSE if DM or INVALID oTarget
int GetIsPlayer(object oTarget);


//Damage stone system
//Destroys an object with the LocalInt "PC_DOES_NOT_POSSESS_ITEM" = TRUE
//Functionality is confusing.
void DestroyObjectDropped(object oItem);

//Get item level based on gold value
int GetItemLevel(int nValue);

//Server shouts sMsg
void ShoutMsg(string sMsg);

// Add fVal with SetLocalFloat on oObject and return total count
float IncLocalFloat(object oObject, string sFloatName, float fVal = 0.0);

// Add nVal with SetLocalFloat on oObject and return total count
int IncLocalInt(object oObject, string sIntName, int nVal = 1);

// return first, second, fourth... supports 1 - 10
string GetCountString(int nCount, int nLowerCase = FALSE);
int GetMax(int iNum1 = 0, int iNum2 = 0);
int GetMin(int iNum1 = 0, int iNum2 = 0);
float GetMaxf(float iNum1 = 0.0, float iNum2 = 0.0);
float GetMinf(float iNum1 = 0.0, float iNum2 = 0.0);
void LetoReadSpellSchool(object oPC);

//Adds the value of oPC's items in inventory.
int GetNetWorth(object oPC);
void DestroyControlledCreatures(object oMaster);
int GetHasSpellSchool(object oPC, int iSchool);
int PickOneInt(int i1=-1, int i2=-1, int i3=-1, int i4=-1, int i5=-1, int i6=-1, int i7=-1, int i8=-1, int i9=-1, int i10=-1);
int RandomUpperHalf(int nIn);
//Stores in the log files.
void LoggedSendMessageToPC(object oPC, string sMsg);
//Sets the LocalInt sKey with the value nValue if it's 0.
int DefLocalInt(object oObject, string sKey, int nValue);
int HasShield(int iShield, string sCheck, string sNew);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

object CreateCursedItem(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="")
{
    object oItem = CreateItemOnObject(sItemTemplate, oTarget, nStackSize, sNewTag);
    SetItemCursedFlag(oItem, TRUE);
    SetPlotFlag(oItem, TRUE);
    return oItem;
}

void Insured_Destroy(object oObject)
{
    DestroyObject(oObject);
}

void Insured_Destroy_Delay(object oObject, float fDelay)
{
    DelayCommand(fDelay, DestroyObject(oObject));
}

void LockObject(object oObject)
{
    if (GetLockLockable(oObject))    SetLocked(oObject, TRUE);
}

void LockObjectDelay(object oObject, float fDelay)
{
    if (GetLockLockable(oObject))    DelayCommand(fDelay, SetLocked(oObject, TRUE));
}

void CloseDoor(object oObject)
{
    ActionCloseDoor(oObject);
}

void CloseDoorDelay(object oObject, float fDelay)
{
    DelayCommand (fDelay, ActionCloseDoor(oObject));
}

object DefGetObjectByTag(string sTag, object oStored=OBJECT_SELF)
{
    object oObject = GetLocalObject(oStored, sTag);
    if (!GetIsObjectValid(oObject))
    {
        oObject = GetObjectByTag(sTag);
        SetLocalObject(oStored, sTag, oObject);
    }
    return oObject;
}

string GetNameByBaseItemType2da(int nBaseItemType)
{
    return GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", nBaseItemType)));
}

void UnequipItem(object oPC, object oItem)
{
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, ActionUnequipItem(oItem));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oPC, SetCommandable(FALSE));
}

int GetIsDeXStadium(string sAreaTag)
{
    return (GetStringLeft(GetStringUpperCase(sAreaTag), 7) == "STADIUM");
}

void ActionCopyItem(object oItem, object oTargetInventory=OBJECT_INVALID, int nCount=1, int bCopyVars=FALSE)
{
    int i;
    for (i = 1; i <= nCount; i++) CopyItem(oItem, oTargetInventory, bCopyVars);
}

void ActionCreateItemOnObject(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="")
{
    CreateItemOnObject(sItemTemplate, oTarget, nStackSize, sNewTag);
}

void ActionCreateObject(int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="", int nXpBonus = FALSE, int nDespawn = FALSE)
{
    object oObject = CreateObject(nObjectType, sTemplate, lLocation, bUseAppearAnimation, sNewTag);
    if (nXpBonus) SetLocalInt(oObject, "XP_BONUS", nXpBonus);
    if (nDespawn) AssignCommand(GetAreaFromLocation(lLocation), DelayCommand(IntToFloat(nDespawn), Despawn(oObject)));
}

int GetIsEquipable(int nBaseItemType)
{
    if (nBaseItemType >= 0 && nBaseItemType <= 22) return TRUE;
    else if (nBaseItemType >= 25 && nBaseItemType <= 28) return TRUE;
    else if (nBaseItemType >= 31 && nBaseItemType <= 33) return TRUE;
    else if (nBaseItemType >= 35 && nBaseItemType <= 38) return TRUE;
    else if (nBaseItemType >= 40 && nBaseItemType <= 42) return TRUE;
    else if (nBaseItemType >= 50 && nBaseItemType <= 53) return TRUE;
    else if (nBaseItemType >= 55 && nBaseItemType <= 61) return TRUE;
    else if (nBaseItemType == 45 || nBaseItemType == 47 || nBaseItemType == 63 ||
             nBaseItemType == 78 || nBaseItemType == 95 || nBaseItemType == 108 ||
             nBaseItemType == 111) return TRUE;
    return FALSE;
}

void ActionSendMessageToPC(object oPC, string sMsg)
{
    if (GetIsObjectValid(oPC))
    {
        SendMessageToPC(oPC, sMsg);
    }
}

void ActionFloatingTextStringOnCreature(string sStringToDisplay, object oCreatureToFloatAbove, int bBroadcastToFaction=TRUE)
{
    if (GetIsObjectValid(oCreatureToFloatAbove))
    {
        FloatingTextStringOnCreature(sStringToDisplay, oCreatureToFloatAbove, bBroadcastToFaction);
    }
}

int GetIsPlayer(object oTarget)
{
    if (!GetIsObjectValid(oTarget)) return FALSE;
    if (!GetIsPC(oTarget)) return FALSE;
    if (GetIsDM(oTarget)) return FALSE;
    if (GetIsDMPossessed(oTarget)) return FALSE;
    return TRUE;
}

void DoFlamingBrazier(object oTarget)
{
    if (GetHitDice(oTarget) > 39)
    {
        SendMessageToPC(oTarget, "Cannot be used by level 40 characters.");
    }
    else if (!GetIsHostilePcNearby(oTarget, GetArea(oTarget), 35.0))
    {
        effect eHeal = EffectLinkEffects(EffectHeal(250), EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    else
    {
        SendMessageToPC(oTarget, "someone disrupt your worship...");
    }
}

int GetIsHostilePcNearby(object oPC, object oArea, float fDist, int nCheckLevel = 0)
{
    int nCnt = 1;

    object oEnemy = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, nCnt);
    while (GetIsObjectValid(oEnemy))
    {
        if (oPC != oEnemy)
        {
            if (GetArea(oEnemy) != oArea) return FALSE;
            if (GetDistanceBetween(oPC, oEnemy) > fDist) return FALSE;

            if (GetIsReactionTypeHostile(oPC, oEnemy))
            {
                if (nCheckLevel > 0)
                {
                    if (abs(GetHitDice(oEnemy) - GetHitDice(oPC)) <= nCheckLevel) // effortless
                    {
                        if (GetCurrentHitPoints(oEnemy) > 0)
                        {
                            return TRUE;
                        }
                    }
                }
                else return TRUE;
            }
        }
        nCnt++;
        oEnemy = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, nCnt);
    }
    return FALSE;
}

void DestroyInventory(object oPC)
{
    object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
        Insured_Destroy(oItem);
        oItem = GetNextItemInInventory(oPC);
    }
}

void DestroyObjectDropped(object oItem)
{
    if (!GetIsObjectValid(oItem)) return;
    if (!GetLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM")) return;

    DeleteLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM");
    if (GetItemStackSize(oItem) > 1) SetItemStackSize(oItem, 1);
    Insured_Destroy(oItem);
}

int GetItemLevel(int nValue)
{
   if (nValue <=1000   ) return 1 ;   if (nValue <=1500   ) return 2 ;   if (nValue <=2500   ) return 3 ;
   if (nValue <=3500   ) return 4 ;   if (nValue <=5000   ) return 5 ;   if (nValue <=6500   ) return 6 ;
   if (nValue <=9000   ) return 7 ;   if (nValue <=12000  ) return 8 ;   if (nValue <=15000  ) return 9 ;
   if (nValue <=19500  ) return 10;   if (nValue <=25000  ) return 11;   if (nValue <=30000  ) return 12;
   if (nValue <=35000  ) return 13;   if (nValue <=40000  ) return 14;   if (nValue <=50000  ) return 15;
   if (nValue <=65000  ) return 16;   if (nValue <=75000  ) return 17;   if (nValue <=90000  ) return 18;
   if (nValue <=110000 ) return 19;   if (nValue <=130000 ) return 20;   if (nValue <=250000 ) return 21;
   if (nValue <=1000000) return 22 + (nValue - 250001) / 250000;
   else return 25 + (nValue - 1000001) / 200000;
}

int IsDev(object oPC)
{
   return GetLocalInt(oPC, "IAMADEV");
}

void ShoutMsg(string sMsg)
{
   AssignCommand(GetModule(), SpeakString(sMsg, TALKVOLUME_SHOUT));
}

float IncLocalFloat(object oObject, string sFloatName, float fVal = 0.0)
{
    float fNew = GetLocalFloat(oObject, sFloatName) + fVal;
    if (fVal != 0.0) SetLocalFloat(oObject, sFloatName, fNew);
    return fNew;
}

int IncLocalInt(object oObject, string sIntName, int nVal = 1)
{
   int nNew = GetLocalInt(oObject, sIntName) + nVal;
   if (nVal) SetLocalInt(oObject, sIntName, nNew);
   return nNew;
}

int GetMax(int iNum1 = 0, int iNum2 = 0)
{
   return (iNum1 > iNum2) ? iNum1 : iNum2;
}

int GetMin(int iNum1 = 0, int iNum2 = 0)
{
   return (iNum1 < iNum2) ? iNum1 : iNum2;
}

float GetMaxf(float iNum1 = 0.0, float iNum2 = 0.0)
{
   return (iNum1 > iNum2) ? iNum1 : iNum2;
}

float GetMinf(float iNum1 = 0.0, float iNum2 = 0.0)
{
   return (iNum1 < iNum2) ? iNum1 : iNum2;
}

void LetoReadSpellSchool(object oPC)
{
   if (!GetLevelByClass(CLASS_TYPE_WIZARD, oPC)) return; // NO WIZ LEVELS, NOTHING TO SEE HERE
   int nSchool = NWNX_Creature_GetWizardSpecialization(oPC);
   SetLocalInt(oPC, "SPELL_SCHOOL", nSchool);
}

int GetNetWorth(object oPC)
{
   int iSlot=0;
   int iGP = 0;
   object oItem;
   for(iSlot = 0; iSlot < NUM_INVENTORY_SLOTS; iSlot++)
   {
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

void DestroyControlledCreatures(object oMaster)
{
    int nCnt = GetLocalInt(oMaster, "UNDEADCOUNT");
    if (nCnt==0) return;
    object oMinion = GetFirstObjectInArea(GetArea(oMaster));
    while (GetIsObjectValid(oMinion))
    {
        if (GetObjectType(oMinion) == OBJECT_TYPE_CREATURE)
        {
            if (GetLocalObject(oMinion, "DOMINATED") == oMaster)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_L), oMinion);
                Insured_Destroy_Delay(oMinion, 0.1);
            }
        }
        oMinion = GetNextObjectInArea(GetArea(oMaster));
    }
    DeleteLocalInt(OBJECT_SELF, "UNDEADCOUNT");
}

int GetHasSpellSchool(object oPC, int iSchool)
{
   if (!GetLevelByClass(CLASS_TYPE_WIZARD, oPC)) return FALSE; // NO WIZ LEVELS
   int iHasSchool = GetLocalInt(oPC, "SPELL_SCHOOL");
   return (iHasSchool==iSchool);
}

int PickOneInt(int i1=-1, int i2=-1, int i3=-1, int i4=-1, int i5=-1, int i6=-1, int i7=-1, int i8=-1, int i9=-1, int i10=-1)
{
   int i=(i1>-1)+(i2>-1)+(i3>-1)+(i4>-1)+(i5>-1)+(i6>-1)+(i7>-1)+(i8>-1)+(i9>-1)+(i10>-1); // count ints not null
   i=Random(i)+1;
   if (i==1) return i1;  if (i==2) return i2;  if (i==3) return i3;  if (i==4) return i4;  if (i==5) return i5;
   if (i==6) return i6;  if (i==7) return i7;  if (i==8) return i8;  if (i==9) return i9;  if (i==10) return i10;
   return -1;
}

int RandomUpperHalf(int nIn)
{
   if (nIn) nIn = nIn - Random(nIn/2);
   return nIn;
}

void LoggedSendMessageToPC(object oPC, string sMsg)
{
   WriteTimestampedLogEntry("To " + GetName(oPC) + ": " + sMsg);
   SendMessageToPC(oPC, sMsg);
}

int DefLocalInt(object oObject, string sKey, int nValue)
{
   int iCur = GetLocalInt(oObject, sKey);
   if (!iCur)
   {
      SetLocalInt(oObject, sKey, nValue);
      iCur = nValue;
   }
   return iCur;
}

int HasShield(int iShield, string sCheck, string sNew)
{
   if (GetHasSpellEffect(iShield, OBJECT_SELF))
   {
      SendMessageToPC(OBJECT_SELF, sNew + " shield cannot stack with " + sCheck + " shield.");
      return TRUE;
   }
   return FALSE;
}
//void main(){}
