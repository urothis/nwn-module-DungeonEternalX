#include "x2_inc_switches"
#include "_functions"
#include "db_inc"

int i;

void IncStack(object oPC, int nInc = 1, int nStackLimit = 3) {
   int nStack = GetMax(0, GetLocalInt(oPC, "ls_spellstack") + nInc);
   SetLocalInt(oPC, "ls_spellstack", nStack);
   if (nInc < 0) FloatingTextStringOnCreature("AOE Spell Limit " + IntToString(nStack) + " of " + IntToString(nStackLimit) + ".", oPC, FALSE);
}

void ClearSpells()
{
   i++;
   if(i > 15) return; // SHORT CIRCUIT LOOP AFTER 15 CHECKS
   int nAction = GetCurrentAction();
   if (nAction == ACTION_CASTSPELL)
   {
       DelayCommand(0.1, ClearSpells()); // CHECK AGAIN IN .10 SEC FOR COUNTER SPELL ACTION
   }
   else if (nAction == ACTION_COUNTERSPELL)
   {
      string sName = GetName(OBJECT_SELF);
      ClearAllActions(TRUE);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), OBJECT_SELF);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints()+1000, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY), OBJECT_SELF);
      SetModuleOverrideSpellScriptFinished();
      WriteTimestampedLogEntry(sName + " was killed while attempting to chain cast or bullet cast. Public CD Key: " + GetPCPublicCDKey(OBJECT_SELF));
      SendMessageToAllDMs(sName + " was killed while attempting to chain cast or bullet cast. Public CD Key: " + GetPCPublicCDKey(OBJECT_SELF));
      if (GetLocalInt(OBJECT_SELF, "PUSHINGIT"))
      {
         dbApplyBan(OBJECT_SELF, BAN_TYPE_TEMP, 1, "Counterspell Exploit");
         SpeakString("SINNER! " + sName + " was killed by Counterspell exploit script and auto banned.", TALKVOLUME_SHOUT);
      }
      else
      {
         SetLocalInt(OBJECT_SELF, "PUSHINGIT", 1);
         SpeakString("WARNING! " + sName + " was killed by Counterspell exploit script. Next attempt will result in a ban.", TALKVOLUME_SHOUT);
      }
   }
}

int RemoveMyOtherAOEs(object oCaster)
{
    int nNth = 1;
    location nLoc1 = GetSpellTargetLocation();
    location nLoc2;
    int nRemoved;
    object oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oCaster, nNth);
    if (GetIsObjectValid(oAOE))
    {
        nLoc2 = GetLocation(oAOE);
        if (GetDistanceBetweenLocations(nLoc1, nLoc2) > 10.0) return nRemoved;
        if (GetAreaOfEffectCreator(oAOE) == oCaster)
        {
            DestroyObject(oAOE);
            nRemoved = TRUE;
        }
        nNth++;
        oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oCaster, nNth);
    }
    return nRemoved;
}

void SpellStack(int iSpell, object oPC)
{
    if (iSpell == SPELL_BLADE_BARRIER           ||        iSpell == SPELL_CREEPING_DOOM           ||
        iSpell == SPELL_DARKNESS                ||        iSpell == SPELL_TIME_STOP               ||
        iSpell == SPELL_STORM_OF_VENGEANCE      ||        iSpell == SPELL_DELAYED_BLAST_FIREBALL  ||
        iSpell == SPELL_ENTANGLE                ||        iSpell == SPELL_EVARDS_BLACK_TENTACLES  ||
        iSpell == SPELL_ACID_FOG                ||        iSpell == SPELL_GLYPH_OF_WARDING        ||
        iSpell == SPELL_CLOUD_OF_BEWILDERMENT   ||        iSpell == SPELL_CLOUDKILL               ||
        iSpell == SPELL_GREASE                  ||        iSpell == SPELL_MIND_FOG                ||
        iSpell == SPELL_STINKING_CLOUD          ||        iSpell == SPELL_STONEHOLD               ||
        iSpell == SPELL_WALL_OF_FIRE            ||        iSpell == SPELL_INCENDIARY_CLOUD        ||
        iSpell == SPELL_WEB                     ||        iSpell == SPELL_HORRID_WILTING)
    {
        /*int nStack = GetLocalInt(oPC, "ls_spellstack");//GetPersistentInt(oPC, "ls_spellstack");
        int nStackLimit = 3;
        int nDur = 10;

        if (nStack >= nStackLimit)
        {
           SetModuleOverrideSpellScriptFinished();
           SendMessageToPC(oPC, "Your concentration is strained with the currently active area spells...");
        }
        else
        {
            if (RemoveMyOtherAOEs(oPC)) SendMessageToPC(oPC, "To close to your last AOE, it will be removed...");
            IncStack(oPC, 1, nStackLimit);
            AssignCommand(oPC, DelayCommand(RoundsToSeconds(nDur), IncStack(oPC, -1, nStackLimit)));
        }*/
        if (RemoveMyOtherAOEs(oPC)) SendMessageToPC(oPC, "To close to your last AOE, it will be removed...");
    }
}

void main()
{
    if (GetIsPC(OBJECT_SELF))
    {
        //      ClearSpells();
        SpellStack(GetSpellId(), OBJECT_SELF);
    }
}
