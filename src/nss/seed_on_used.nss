#include "nw_i0_plot"
#include "x2_inc_itemprop"
#include "x0_i0_position"
#include "_functions"
#include "time_inc"
#include "_server_reboot"

const int KEG_COST_ABILITY       = 25;
const int KEG_COST_BLESSWEAPON   = 50;
const int KEG_COST_DEAFCLANG     = 200;
const int KEG_COST_GRMAGICWEAPON = 50;
const int KEG_COST_DARKFIRE      = 100;
const int KEG_COST_HASTE         = 0;


void ApplyBoost(object oUser, int iSpell, string sFloatText = "") {
   object oCaster = DefGetObjectByTag("BABA_YAGA");
//   AssignCommand(oCaster, ActionCastSpellAtObject(iSpell, oUser, METAMAGIC_EXTEND, TRUE));
   ActionCastSpellAtObject(iSpell, oUser, METAMAGIC_EXTEND, TRUE);
   if (sFloatText != "") FloatingTextStringOnCreature(sFloatText, oUser, TRUE);
   DeleteLocalInt(oUser, "BUFFING");
}

void BoostBuddy(object oUser, int iSpell, int iBeam = 0) {
   object oFam = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oUser);
   if (!GetIsObjectValid(oFam)) oFam = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oUser);
   if (!GetIsObjectValid(oFam)) oFam = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oUser);
   if (GetIsObjectValid(oFam)) {
      if (iBeam !=0) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(iBeam, oUser, BODY_NODE_CHEST), oFam, 0.75);
      DelayCommand(0.5, ApplyBoost(oFam, iSpell));
      object oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oUser);
      if (GetIsObjectValid(oSum) && oFam!=GetAssociate(ASSOCIATE_TYPE_SUMMONED, oUser)) {
         if (iBeam !=0) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(iBeam, oFam, BODY_NODE_CHEST), oSum, 0.75);
         DelayCommand(0.5, ApplyBoost(oSum, iSpell));
      }
   }
}

int PayPiper(object oUser, int iPrice) {
   /*object oFish = GetItemPossessedBy(oUser, "NW_IT_MSMLMISC20"); // SHE LOVES FISHHEADS
   if (GetIsObjectValid(oFish)) {
      DestroyObject(oFish);
      FloatingTextStringOnCreature("Baba Yaga eats your fish.", oUser, TRUE);
      PlaySound(PickOne("as_pl_x2rghtav1","as_pl_x2rghtav2","as_pl_x2rghtav3"));
      return TRUE;
   }*/
   if (iPrice == 0) return TRUE; // FREEBIE
   if (iPrice > GetGold(oUser)) {
      FloatingTextStringOnCreature("Sorry, no credit.", oUser, TRUE);
      return FALSE;
   }
   TakeGoldFromCreature(iPrice, oUser);
   PlaySound("it_coins");
   return TRUE;
}

int AlreadyBuffed(object oUser, int iSpell) {
   if (GetLocalInt(oUser, "BUFFING")) {
      FloatingTextStringOnCreature("Waiting for buff...", oUser, TRUE);
      return TRUE;
   }
   if (GetHasSpellEffect(iSpell, oUser)) {
      FloatingTextStringOnCreature("Already buffed.", oUser, TRUE);
      return TRUE;
   }
   return FALSE;

}

void KegDrink(object oUser, int iSpell, int iPrice, string sFloatText = "") {
   if (AlreadyBuffed(oUser, iSpell)) return;
   //if (HasItem(oUser, "NW_IT_MSMLMISC20")) iPrice = 1; // FISH FOR BABA
   if (!PayPiper(oUser, iPrice)) return;
   SetLocalInt(oUser, "BUFFING", TRUE);
   AssignCommand(oUser, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
   DelayCommand(1.0, ApplyBoost(oUser, iSpell, sFloatText));
   DelayCommand(1.1, BoostBuddy(oUser, iSpell));
}

void GemUse(object oUser, int iSpell, int iPrice, int iBeam) {
   object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUser);
   if (oRight==OBJECT_INVALID) {
      FloatingTextStringOnCreature("No Weapon Held.", oUser, TRUE);
      return;
   }

   if (AlreadyBuffed(oUser, iSpell)) return;
   //if (HasItem(oUser, "NW_IT_MSMLMISC20")) iPrice = 1; // FISH FOR BABA
   if (!PayPiper(oUser, iPrice)) return;
   SetLocalInt(oUser, "BUFFING", TRUE);
   object oCaster = GetObjectByTag("BABA_YAGA");
   AssignCommand(oCaster, ClearAllActions());
   AssignCommand(oCaster, SetFacingPoint(GetPosition(oUser)));
   AssignCommand(oCaster, PlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 2.5));
   DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(iBeam, oCaster, BODY_NODE_HAND), OBJECT_SELF, 2.20));
   DelayCommand(0.9, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
   DelayCommand(1.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), OBJECT_SELF));
   DelayCommand(2.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), oCaster));
   DelayCommand(2.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_ODD), OBJECT_SELF));
   DelayCommand(2.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), oCaster));
   DelayCommand(2.4, AssignCommand(oCaster, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0)));
   DelayCommand(2.5, ApplyBoost(oUser, iSpell));
   DelayCommand(2.6, BoostBuddy(oUser, iSpell, iBeam));
   object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oUser);
   if (oLeft!=OBJECT_INVALID) {
      if (IPGetIsMeleeWeapon(oLeft)) {
         if (PayPiper(oUser, iPrice)) {
            DelayCommand(2.7, AssignCommand(oUser, ClearAllActions()));
            DelayCommand(2.8, AssignCommand(oUser, ActionUnequipItem(oRight)));
            DelayCommand(2.9, ApplyBoost(oUser, iSpell));
            DelayCommand(3.0, AssignCommand(oUser, ActionEquipItem(oRight, INVENTORY_SLOT_RIGHTHAND)));
            DelayCommand(3.1, AssignCommand(oUser, ActionEquipItem(oLeft, INVENTORY_SLOT_LEFTHAND)));
         }
      }
   }
   DelayCommand(6.5, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
}

void main()
{
    object oMod = GetModule();
    object oUser = GetLastUsedBy();
    if (oUser==OBJECT_INVALID) oUser = GetEnteringObject();
    object oLocator;
    location lTarget;
    int iSpell;
    string sTxt="";
    int iPrice;
    effect eEffect;
    int nLevel = GetHitDice(oUser);

    string sTag=GetTag(OBJECT_SELF);

    if (!GetIsObjectValid(oUser) && !GetIsPC(oUser)) return;

    if (GetStringLeft(sTag,4)=="KEG_")
    {
        if (HasItem(oUser, "BottomlessMug")) iPrice = 0;
        else iPrice = KEG_COST_ABILITY * nLevel;

        if (sTag=="KEG_STR")
        {
            KegDrink(oUser, SPELL_BULLS_STRENGTH, iPrice, "grr");
            return;
        }
        else if (sTag=="KEG_CON")
        {
            KegDrink(oUser, SPELL_ENDURANCE, iPrice, "mmm");
            return;
        }
        else if (sTag=="KEG_DEX")
        {
            KegDrink(oUser, SPELL_CATS_GRACE, iPrice, "yum");
            return;
        }
        else if (sTag=="KEG_WIS")
        {
            KegDrink(oUser, SPELL_OWLS_WISDOM, iPrice, "om");
            return;
        }
        else if (sTag=="KEG_INT")
        {
            KegDrink(oUser, SPELL_FOXS_CUNNING, iPrice, "hmm");
            return;
        }
        else if (sTag=="KEG_CHA")
        {
            KegDrink(oUser, SPELL_EAGLE_SPLEDOR, iPrice, "ooh");
            return;
        }
    }
    else if (sTag=="GEM_HASTE")
    {
        if (nLevel > 39)
        {
            FloatingTextStringOnCreature("Cannot be used by level 40 characters.", oUser, TRUE);
            return;
        }
        KegDrink(oUser, SPELL_HASTE, KEG_COST_HASTE, "มndale!!");
        return;
    }
    else if (sTag=="GEM_YELLOW")
    {
        if (nLevel == 40)
        {
            FloatingTextStringOnCreature("Cannot be used by level 40 characters.", oUser, TRUE);
            return;
        }
        GemUse(oUser, SPELL_BLESS_WEAPON, KEG_COST_BLESSWEAPON * nLevel, VFX_BEAM_HOLY);
        return;
    }
    else if (sTag=="GEM_BLUE")
    {
        if (nLevel == 40)
        {
            FloatingTextStringOnCreature("Cannot be used by level 40 characters.", oUser, TRUE);
            return;
        }
        GemUse(oUser, SPELL_DEAFENING_CLANG, KEG_COST_DEAFCLANG * nLevel, VFX_BEAM_LIGHTNING);
        return;
    }
    else if (sTag=="GEM_RED")
    {
        GemUse(oUser, SPELL_DARKFIRE, KEG_COST_DARKFIRE * nLevel, VFX_BEAM_FIRE);
        return;
    }
    else if (sTag=="GEM_GREEN")
    {
        if (nLevel == 40)
        {
            FloatingTextStringOnCreature("Cannot be used by level 40 characters.", oUser, TRUE);
            return;
        }
        GemUse(oUser, SPELL_GREATER_MAGIC_WEAPON, KEG_COST_GRMAGICWEAPON * nLevel, VFX_BEAM_MIND);
        return;
    }
    if (sTag=="SUNDIAL")
    {
        // just as a safeguard
        mainRebootChecker();

        string sPlayer      = "SUNDIAL";
        string sKey         = "TRUE";
        string sUpTime;
        string sBootTime = GetLocalString(oMod, "BOOT_TIME");
        string sBootDate = GetLocalString(oMod, "BOOT_DATE");

        int iCurrentTime = NWNX_Time_GetTimeStamp();
        int iBootTime = GetLocalInt(oMod, "RAW_BOOT_TIME");
        int iUpTime = iCurrentTime - iBootTime;

        int iMin = iUpTime / 60;
        int iSec = iUpTime % 60;
        int iHour = iMin / 60;
        int iTrueMin = iMin % 60;
        string sSec = IntToString(iSec);
        string sHour = IntToString(iHour);
        string sTrueMin = IntToString(iTrueMin);

        if (iUpTime > 3600) {
            sUpTime = sHour + ":" + sTrueMin + ":" + sSec;
        }

        else {
            sUpTime = sTrueMin + ":" + sSec;
        }

        if (GetLocalString(oUser, sPlayer) != sKey) {
            SendMessageToPC(oUser, "<c ออ>DungeonEternalX resets every 24 hours.</c>");
            SendMessageToPC(oUser, "<c ออ>Server was loaded at: <cอออ>" + sBootTime + " (GMT)</c>");

            SendMessageToPC(oUser, "<c ออ>Uptime: <cอออ>" + sUpTime);
            SendMessageToPC(oUser, "<c ออ>The date is <cอออ>" + NWNX_Time_GetSystemDate() + " (GMT)</c>");
            SendMessageToPC(oUser, "<c ออ>The time is <cอออ>" + NWNX_Time_GetSystemTime() + " (GMT)</c>");
            SetLocalString(oUser, sPlayer, sKey);
            DelayCommand(6.0, DeleteLocalString(oUser, sPlayer));
        }
        else {
            SendMessageToPC(oUser, "<cอ  >Wait a few seconds before using Sundial again</c>");
        }
        return;
    }
    else if (sTag=="SERVER_PORTAL")
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_10), oUser);
        DelayCommand(1.0,ExecuteScript("port_other_serv", oUser));
    }
    else if (sTag=="CAVERN_GONG")
    {
        eEffect=EffectVisualEffect(VFX_FNF_SOUND_BURST);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffect,OBJECT_SELF);
        AssignCommand(OBJECT_SELF,PlaySound("as_cv_gongring1"));
        DelayCommand(0.5,AssignCommand(OBJECT_SELF,PlaySound("as_cv_gongring1")));
        DelayCommand(1.0,AssignCommand(OBJECT_SELF,PlaySound("as_cv_gongring1")));
    }
    else
    {
        SendMessageToPC(oUser,"Doh! OnUsedBonusElse!");
    }
}
