//::///////////////////////////////////////////////
//:: Gated Demon: On Heartbeat
//:: NW_C2_GATED.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script will have people perform default
    animations. For the Gated Balor this script
    will check if the master is protected from
    by Protection from Evil.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"
#include "string_inc"

void BoostBalor(object oBalor)
{
   string sTag = GetTag(oBalor);
   int nDamageAmt1 = 0;
   int nDamageAmt2 = 0;
   int nVisual = ITEM_VISUAL_ACID;
   int nVampRegen = 0;
   if (sTag=="SU_BALOR1") {
      nDamageAmt1 = IP_CONST_DAMAGEBONUS_2d4;
      nDamageAmt2 = IP_CONST_DAMAGEBONUS_2d4;
   } else if (sTag=="SU_BALOR2") {
      nDamageAmt1 = IP_CONST_DAMAGEBONUS_2d6;
      nDamageAmt2 = IP_CONST_DAMAGEBONUS_2d6;
   } else if (sTag=="SU_BALOR3") {
      nDamageAmt1 = IP_CONST_DAMAGEBONUS_2d8;
      nDamageAmt2 = IP_CONST_DAMAGEBONUS_2d8;
   } else if (sTag=="SU_BALOR4") {
      nDamageAmt1 = IP_CONST_DAMAGEBONUS_2d10;
      nDamageAmt2 = IP_CONST_DAMAGEBONUS_2d10;
   } else if (sTag=="SU_BALOR5") {
      nDamageAmt1 = IP_CONST_DAMAGEBONUS_2d12;
      nDamageAmt2 = IP_CONST_DAMAGEBONUS_2d12;
      nVampRegen = 3;
   } else if (sTag=="SU_BALOR6") {
      nDamageAmt1 = IP_CONST_DAMAGEBONUS_2d12;
      nDamageAmt2 = IP_CONST_DAMAGEBONUS_2d12;
      nVisual = ITEM_VISUAL_EVIL;
      nVampRegen = 5;
      string sName;
      int nRoll = d6();
      if (nRoll==1) sName = PickOne("Lucifuge Rofocale", "Melchiresa", "Decarabia", "Caacrinolaas", "Glasya-Labolas", "Mictlantecuhtli", "Tzitzimime", "Adramelech", "Sidragasum");
      if (nRoll==2) sName = PickOne("Marchosias", "Astaroth", "Haagenti", "Lix Tetrax", "Bali Raj", "Naberius", "Thammuz", "Semyazza");
      if (nRoll==3) sName = PickOne("Malphas", "Pithius", "Armaros", "Halphas", "Naberus", "Alloces", "Cimejes", "Cerenus", "Pruflas");
      if (nRoll==4) sName = PickOne("Shaitan", "Yuki-Onna", "Vassago", "Apollyon", "Focalor", "Ziminar", "Valefor", "Forneus", "Bifrons");
      if (nRoll==5) sName = PickOne("Dantalion", "Sabnock", "Razakel", "Belphegor", "Teeraal", "Humbaba", "Andrealphus","Merihem", "Abaddon");
      if (nRoll==6) sName = PickOne("Oni", "Ose", "Azi", "Bagat", "Dasa", "Rahab", "Volac", "Samael", "Dumah");
      SetName(oBalor, sName);

   } else {
      return; // NOT A BALOR?
   }
   object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBalor);
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID,     nDamageAmt1), oItem);
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, nDamageAmt2), oItem);
   if (nVampRegen) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVampiricRegeneration(nVampRegen), oItem);
   SpeakString("Arrrgg!");
}


void main() {
   object oMaster = GetMaster(OBJECT_SELF);
   BoostBalor(OBJECT_SELF);
   if (!GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oMaster) && !GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oMaster) && !GetHasSpellEffect(SPELL_HOLY_AURA, oMaster)) {
      RemoveSummonedAssociate(oMaster, OBJECT_SELF);
      SetIsTemporaryEnemy(oMaster);
      DetermineCombatRound(oMaster);
   } else {
        SetIsTemporaryFriend(oMaster);
        //Do not bother checking the last target seen if already fighting
        if(
           !GetIsObjectValid(GetAttackTarget()) &&
           !GetIsObjectValid(GetAttemptedSpellTarget()) &&
           !GetIsObjectValid(GetAttemptedAttackTarget()) &&
           !GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN))
          )
        {
            if(GetAssociateState(NW_ASC_HAVE_MASTER))
            {
                if(!GetIsInCombat() || !GetAssociateState(NW_ASC_IS_BUSY))
                {
                    if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
                    {
                        if(GetDistanceToObject(GetMaster()) > GetFollowDistance())
                        {
                            //SpeakString("DEBUG: I am moving to master");
                            ClearAllActions();
                            ActionForceMoveToObject(GetMaster(), TRUE, GetFollowDistance());
                        }
                    }
                }
            }
        }
        if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
        {
            SignalEvent(OBJECT_SELF, EventUserDefined(1001));
        }
    }
}
