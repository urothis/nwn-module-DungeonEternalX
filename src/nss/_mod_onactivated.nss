#include "db_inc"
#include "seed_random_magi"
#include "_functions"
#include "ness_token_manip"
#include "zdlg_include_i"
#include "dmg_stones_inc"
#include "_inc_port"

void DontDropGear(object oCopy) {
   TakeGoldFromCreature(GetGold(oCopy), oCopy, TRUE);
   SetLootable(oCopy, FALSE);
   object oItem = GetFirstItemInInventory(oCopy);
   while (GetIsObjectValid(oItem)) {
      SetDroppableFlag(oItem, FALSE);
      oItem = GetNextItemInInventory(oCopy);
   }
   int i;
   for (i = 0; i < NUM_INVENTORY_SLOTS; i++) {
      oItem = GetItemInSlot(i, oCopy);
      if (GetIsObjectValid(oItem)) SetDroppableFlag(oItem, FALSE);
   }
}


void main()
{
    object oItem      = GetItemActivated();
    object oPC        = GetItemActivator();
    string sTag       = GetTag(oItem);
    object oTarget    = GetItemActivatedTarget();
    string sTagTarget = GetTag(oTarget);
    location lTarget  = GetItemActivatedTargetLocation();

    if (GetStringLeft(sTag,5) == "item_")
    {
        ExecuteScript(sTag, oPC);
        return;
    }
    if (sTag == "FEATENHANCER")
    {
        ExecuteScript("ez_featenhancer", oPC);
        return;
    }

    if (sTag == "RANGERDODGE")
    {
        ExecuteScript("ez_rangerdodge", oPC);
        return;
    }

    if (sTag == "FIGHTERDODGE")
    {
        ExecuteScript("ez_fighterdodge", oPC);
        return;
    }

    string sRef = GetResRef(oItem);

    if (sTag == "pvptracker")
    {
        SetLocalString(oPC, "pvptracker", sTag);
        StartDlg(oPC, oItem, "item_pvptracker", TRUE, FALSE);
        return;
    }

    if (GetStringLowerCase(sTag) == "massdislike")
    {
        ExecuteScript("item_massdislike", OBJECT_SELF);
        return;
    }

    if (GetStringLowerCase(sTag) == "gtfo")
    {
        ExecuteScript("item_gtfo", OBJECT_SELF);
        return;
    }

    if (GetStringLowerCase(sTag) == "destroyer")
    {
        ExecuteScript("item_destroyer", OBJECT_SELF);
        return;
    }

   if (sTag == "DMREBOOT")
   {
      if (!GetIsDM(oPC)) return;
      SetLocalInt(GetModule(), "SERVER_TIME_LEFT", 3);
      ShoutMsg("DM is rebooting the server. Timer reset to < 5 minutes.");
      return;
   }

   if (sTag == "DMREBOOT2")
   {
      if (!GetIsDM(oPC)) return;
      SetLocalInt(GetModule(), "SERVER_TIME_LEFT", 60);
      ShoutMsg("DM is rebooting the server. Timer reset to < 60 minutes.");
      return;
   }

   if (sTag == "dmevent")
   {
      ExecuteScript("item_dmevent", OBJECT_SELF);
      return;
   }

   if (sTag == "Dislike")
   {
        ExecuteScript("seed_ani_start", oPC);
        return;
   }
   if (sTag == "ITEMSTRIPPER")
   {
        ExecuteScript("seed_strip_start", oPC);
        return;
   }
   if (sTag == "KNOWER")
   {
       if (!GetIsDM(oPC)) return;
       // KNOWER
       if (GetIsPC(oTarget))
       {
          LoggedSendMessageToPC(oPC, "Name = " + GetName(oTarget) + " (" + GetPCPlayerName(oTarget) + ")");
          LoggedSendMessageToPC(oPC, "TRUEID = " + dbGetTRUEIDName(oTarget)+"  "+IntToString(dbGetTRUEID(oTarget)));
          LoggedSendMessageToPC(oPC, "DEXID = " + IntToString(dbGetDEXID(oTarget)));
          LoggedSendMessageToPC(oPC, "IP = " + GetPCIPAddress(oTarget));
          LoggedSendMessageToPC(oPC, "CDKey = " + GetPCPublicCDKey(oTarget));
          ActionCastSpellAtObject(SPELL_LESSER_RESTORATION, oTarget, METAMAGIC_ANY, TRUE);
       }
       else
       {
          LoggedSendMessageToPC(oPC, "Tag = " + sTagTarget);
          LoggedSendMessageToPC(oPC, "Ref = " + GetResRef(oTarget));
       }
       if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
       {
          LoggedSendMessageToPC(oPC, "HD = " + IntToString(GetHitDice(oTarget)));
          LoggedSendMessageToPC(oPC, "CR = " + FloatToString(GetChallengeRating(oTarget)));
          LoggedSendMessageToPC(oPC, "Race = " + RacialString(GetRacialType(oTarget)) + " (" + GetSubRace(oTarget) +")");
          LoggedSendMessageToPC(oPC, "HP = " + IntToString(GetCurrentHitPoints(oTarget)) + "/" + IntToString(GetMaxHitPoints(oTarget)));
          LoggedSendMessageToPC(oPC, "BAB = " + IntToString(GetBaseAttackBonus(oTarget)));
          LoggedSendMessageToPC(oPC, "AC = " + IntToString(GetAC(oTarget)));
          LoggedSendMessageToPC(oPC, "SR = " + IntToString(GetSpellResistance(oTarget)));
          if(GetLevelByPosition(1, oTarget)) LoggedSendMessageToPC(oPC, ClassString(GetClassByPosition(1, oTarget)) + " (" + IntToString(GetLevelByPosition(1, oTarget)) + ")");
          if(GetLevelByPosition(2, oTarget)) LoggedSendMessageToPC(oPC, ClassString(GetClassByPosition(2, oTarget)) + " (" + IntToString(GetLevelByPosition(2, oTarget)) + ")");
          if(GetLevelByPosition(3, oTarget)) LoggedSendMessageToPC(oPC, ClassString(GetClassByPosition(3, oTarget)) + " (" + IntToString(GetLevelByPosition(3, oTarget)) + ")");
          LoggedSendMessageToPC(oPC, "Str = " + IntToString(GetAbilityScore(oTarget, ABILITY_STRENGTH))    + " (" + IntToString(GetAbilityModifier(ABILITY_STRENGTH, oTarget)) + ")");
          LoggedSendMessageToPC(oPC, "Dex = " + IntToString(GetAbilityScore(oTarget, ABILITY_DEXTERITY))   + " (" + IntToString(GetAbilityModifier(ABILITY_DEXTERITY, oTarget)) + ")");
          LoggedSendMessageToPC(oPC, "Con = " + IntToString(GetAbilityScore(oTarget, ABILITY_CONSTITUTION))+ " (" + IntToString(GetAbilityModifier(ABILITY_CONSTITUTION, oTarget)) + ")");
          LoggedSendMessageToPC(oPC, "Int = " + IntToString(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE))+ " (" + IntToString(GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget)) + ")");
          LoggedSendMessageToPC(oPC, "Wis = " + IntToString(GetAbilityScore(oTarget, ABILITY_WISDOM))      + " (" + IntToString(GetAbilityModifier(ABILITY_WISDOM, oTarget)) + ")");
          LoggedSendMessageToPC(oPC, "Cha = " + IntToString(GetAbilityScore(oTarget, ABILITY_CHARISMA))    + " (" + IntToString(GetAbilityModifier(ABILITY_CHARISMA, oTarget)) + ")");
          LoggedSendMessageToPC(oPC, "XP = " + IntToString(GetXP(oTarget)));
          LoggedSendMessageToPC(oPC, "GP = " + IntToString(GetGold(oTarget)));
       }
    }

    if (sTag == "RS_WandofPorting")
    {
        if (IsWarpAllowed(oPC))
        {
            DelayCommand(0.0, ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION), oPC));
            DelayCommand(2.0, ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_GLOBE_INVULNERABILITY), oPC));
            DelayCommand(3.0, PortToBind(oPC));
            return;
        }
    }
    // End of new bindstone stuff
    if (sTag == "seed_ban_tool")
    {
        ExecuteScript("seed_ban_start", oPC);
        return;
    }

    if (sTag == "LomirBabaYaga")
    {
        if (GetPCPlayerName(oPC)=="NoobFriedRice")
            SpeakString("My name is Lomir and I qq'ed and got my wish. I have my very own Baba Yaga portal stone because I am homosexual! ^^", TALKVOLUME_SHOUT);
        return;
    }

    if (GetStringLeft(sTag, 4) == "SMS_") // SMS ITEM
    {
        if (sTagTarget == "LEVELING_WEAPON" || GetStringLeft(sTagTarget, 8) == "EPICITEM" || GetStringLeft(sTagTarget, 11) == "EPICCRAFTED")
        {
            SendMessageToPC(oPC, "Sorry, this item can not be modified.");
            return;
        }
        if (IPGetIsItemEquipable(oTarget) && GetItemPossessor(oTarget) == oPC)
        {
            IPRemoveAllItemProperties(oTarget);
        }
        int bSuccess = SMS_OnItemActivate(oPC, oTarget, oItem);
        return;
    }

    string sTag5 = GetStringLeft(sTag, 5);

    if (sTag5 == "DMGS_")
    {
        ExecuteScript("item_dmgstone", oPC);
        return;
    }

    if (sTag5 == "CHARG")
    {
        ExecuteScript("item_charges", oPC);
        return;
    }

   if (sTag5 == "BLING")  // BLING BLING
   {
      string sMsg = sTag + " traded in by " + GetName(oPC);
      sTag = GetStringRight(sTag, GetStringLength(sTag)-6);
      string sSQL = "select tt_rplid from tokentracker where tt_ttid="+sTag;
      NWNX_SQL_ExecuteQuery(sSQL);
      if (NWNX_SQL_ReadyToReadNextRow())
      {
         NWNX_SQL_ReadNextRow();
         if (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)) > 0)
         {
            dbLogMsg("Dup Bling used " + GetName(oItem),"DUPBLING", dbGetTRUEID(oPC),dbGetDEXID(oPC),dbGetLIID(oPC),dbGetPLID(oPC));
            SendMessageToPC(oPC, "Sorry your bling has no credibility.");
            return;
         }
      }
      int nXPOnPC = GetXP(oPC);
      //dbSetXP(oPC, nXPOnPC + 25000, "BLING_XP"); INVALID FUNCTION ------ REWRITE
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oPC);
      PlayVoiceChat(VOICE_CHAT_YES, oPC);
      GiveXPToCreature(oPC, 25000);
      sSQL = "update tokentracker set tt_redemed=now(), tt_rplid="+IntToString(dbGetPLID(oPC))+", tt_rmsg="+dbQuotes(sMsg)+" where tt_ttid="+sTag;
      NWNX_SQL_ExecuteQuery(sSQL);
      WriteTimestampedLogEntry("Bling Destroyed: " + GetName(oPC) + " / " + GetTag(oItem) + " / " + GetName(oItem));
      return;
   }

    // if(sTag == "SEED_VALIDATED") sTag = GetResRef(oItem);
    // Tag Based Execute Script
    ExecuteScript(GetStringLowerCase(sTag), OBJECT_SELF);
}
