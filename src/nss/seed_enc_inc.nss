#include "seed_random_magi"
#include "_inc_despawn"
#include "pc_inc"

int OkToSpawn(int iChance, object oPC=OBJECT_INVALID, int iMaxLevel = 0);
object MakeCreature(string sWhich, object oLocation, float fDespawn=30.0, string sNewTag="");
void voidMakeCreature(string sWhich, object oLocation, object oEnteredBy = OBJECT_INVALID, float fDespawn=30.0, string sNewTag="");
// Despawn set to 600.0
object SpawnBoss(string sWhich, object oLocation);

void DoPrayer(object oPC) {
   int iWhich=d8();
   switch (iWhich) {
      case '1':
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0f, IntToFloat(d2()+1)));
         break;
      case '2':
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0f, IntToFloat(d2()+1)));
         break;
      case '3':
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW));
         break;
      case '4':
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1));
         break;
      case '5':
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0f, IntToFloat(d2()+1)));
         break;
      case '6':
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0f, IntToFloat(d2()+1)));
         break;
      case '7':
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM));
         break;
      case '8':
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2));
         break;
      default:
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW));
   }
}

void DropInvItem(object oMinion, string sTag) {
   object oItem;
   int iSlot=0;
   for(iSlot=0;iSlot < INVENTORY_SLOT_CWEAPON_L;iSlot++) {   // skip creature items
      oItem = GetItemInSlot(iSlot, oMinion);
      if (GetTag(oItem)==sTag) {
         SetDroppableFlag(oItem, TRUE);
         return;
      }
   }
   oItem = GetFirstItemInInventory(oMinion);
   while (GetIsObjectValid(oMinion)) {
      if (GetTag(oItem)==sTag) {
           SetDroppableFlag(oItem, TRUE);
           return;
      }
      oItem = GetNextItemInInventory(oMinion);
   }
}

object MakeCreature(string sWhich, object oLocation, float fDespawn=30.0, string sNewTag="")
{
   object oMinion = CreateObject(OBJECT_TYPE_CREATURE, sWhich, GetLocation(oLocation));
   AssignCommand(GetArea(OBJECT_SELF), DelayCommand(fDespawn, Despawn(oMinion)));
   return oMinion;
}

void voidMakeCreature(string sWhich, object oLocation, object oEnteredBy = OBJECT_INVALID, float fDespawn=30.0, string sNewTag="")
{
    object oMinion = MakeCreature(sWhich, oLocation);
    if (GetIsObjectValid(oEnteredBy) && pcIsClose(oEnteredBy, 50.0))
    {
        AssignCommand(oMinion, ActionMoveToObject(oEnteredBy, TRUE, 4.0));
    }
}

object SpawnBoss(string sWhich, object oLocation)
{
    object oMinion = MakeCreature(sWhich, oLocation, 600.0);
    SetLocalInt(oMinion, "BOSS", TRUE);
    SetAILevel(oMinion, AI_LEVEL_NORMAL);
    if (GetHasSpell(SPELL_SPELL_RESISTANCE,oMinion))
    {
        DelayCommand(0.5f, AssignCommand(oMinion, ActionCastSpellAtObject(SPELL_SPELL_RESISTANCE, oMinion)));
    }
    else if (GetHasSpell(SPELL_FREEDOM_OF_MOVEMENT,oMinion))
    {
        DelayCommand(0.5f, AssignCommand(oMinion, ActionCastSpellAtObject(SPELL_FREEDOM_OF_MOVEMENT, oMinion)));
    }
    return oMinion;
}

void voidSpawnBoss(string sWhich, object oLocation, object oPC)
{
    object oMinion = SpawnBoss(sWhich, oLocation);
    AssignCommand(oMinion, ActionAttack(oPC));
}

object DropEquippedItem(object oMinion, int iPCTChance=25, int iSlot=INVENTORY_SLOT_RIGHTHAND) {
   object oItem = GetItemInSlot(iSlot, oMinion);
   object oCopy = oItem;
   /*if (Random(100)<=iPCTChance) {
      oCopy = CopyObject(oItem, GetLocation(oMinion), oMinion, "SEED_VALIDATED");
      SetDroppableFlag(oCopy, TRUE);
      AssignCommand(oMinion, ActionEquipItem(oCopy, iSlot));
   }*/
   return oCopy;
}

int OkToSpawn(int iChance, object oPC=OBJECT_INVALID, int iMaxLevel = 0) {
   if (Random(iChance)) return FALSE; // IF NOT 0, EXIT
   if (oPC!=OBJECT_INVALID && !GetIsPC(oPC)) return FALSE;
   if (iMaxLevel!=0 && oPC!=OBJECT_INVALID) return (GetHitDice(oPC)<=iMaxLevel);
   return TRUE;
}

void HideWeapons(object oPC) { // Puts away object's weapons
   AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)));
   AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)));
} // HideWeapons
