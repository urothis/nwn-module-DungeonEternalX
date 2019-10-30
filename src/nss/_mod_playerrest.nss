#include "rune_include"
#include "db_inc"
#include "seed_faction_inc"
#include "artifact_inc"
#include "inc_wep_ac_bon"
#include "arres_inc"
#include "fame_inc"
#include "fame_charvalue"
#include "no_tumble"
#include "wm_bonus"

void OnPCRest(object oPC, int nLevel)
{
    dbUpdatePlayerStatus(oPC); // SAVE PC STATUS
    if (nLevel < 40)
    {
        int nXP = GetXP(oPC) - GetLocalInt(oPC, "XP");
        nXP = nLevel + 1;
        nXP = ((nXP * (nXP - 1)) / 2) * 1000 - GetXP(oPC);
        SendMessageToPC(oPC, "Since log in, you gained " + IntToString(nXP) + " xp.");
        FloatingTextStringOnCreature(IntToString(nXP) + " xp to next level.", oPC, TRUE);
    }
}

void NoobDoBuff(object oPC, int nLevel, string sFAID)
{
    if (!StringToInt(sFAID) && nLevel < 38)
    {
        int nFame = GetTotalFame(oPC);
        if (nFame < 100)
        {
            int nConceal = 60;
            if (nFame < 50)
            {
                if (nLevel < 20) nConceal = 80;
                else nConceal = 70;
            }
            effect eEffect = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
            eEffect = EffectLinkEffects(eEffect, EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_POSITIVE));
            eEffect = EffectLinkEffects(eEffect, EffectConcealment(nConceal));
            eEffect = EffectLinkEffects(eEffect, EffectTrueSeeing());
            eEffect = ExtraordinaryEffect(eEffect);

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
            SendMessageToPC(oPC, "Applied new player special buffs");
        }
    }
}

//::///////////////////////////////////////////////
//:: Basic Resting Script
//:://////////////////////////////////////////////

/////////////// START SEED
// Counting the actual date from Year0 Month0 Day0 Hour0 in hours
int GetHourTimeZero(int iYear = 99999, int iMonth = 99, int iDay = 99, int iHour = 99)
{
  // Check if a specific Date/Time is forwarded to the function.
  // If no or invalid values are forwarded to the function, the current Date/Time will be used
  if (iYear > 30000)
    iYear = GetCalendarYear();
  if (iMonth > 12)
    iMonth = GetCalendarMonth();
  if (iDay > 28)
    iDay = GetCalendarDay();
  if (iHour > 23)
    iHour = GetTimeHour();

  //Calculate and return the "HourTimeZero"-TimeIndex
  int iHourTimeZero = (iYear)*12*28*24 + (iMonth-1)*28*24 + (iDay-1)*24 + iHour;
  return iHourTimeZero;
}
/////////////// END SEED

void stopResting( object Master )
{
    AssignCommand (Master, ClearAllActions()); // Prevent Resting of master-char

    // stop resting of associates

    object assoc=GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, Master);
    if(assoc!=OBJECT_INVALID)
        AssignCommand(assoc, ClearAllActions());

    assoc = GetAssociate(ASSOCIATE_TYPE_DOMINATED, Master);
    if(assoc!=OBJECT_INVALID)
        AssignCommand(assoc, ClearAllActions());

    assoc = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, Master);
    if(assoc!=OBJECT_INVALID)
        AssignCommand(assoc, ClearAllActions());

    assoc = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, Master);
    if(assoc!=OBJECT_INVALID)
        AssignCommand(assoc, ClearAllActions());

    assoc = GetAssociate(ASSOCIATE_TYPE_SUMMONED, Master);
    if(assoc!=OBJECT_INVALID)
        AssignCommand(assoc, ClearAllActions());

}

void OnRestDeleteLocal(object oPC)
{
    DeleteLocalInt(oPC, "ls_spellstack"); // CLEAR AOE FLAG
    DeleteLocalInt(oPC, "DEATHSPAM"); // CLEAR DEATH SPELL SPAM FLAG
    // DeleteLocalInt(oPC, "FRENZY"); // CLEAR WARLORD FRENZY
    DeleteLocalInt(oPC, "TERRIFYPULSE");  // clear pulse variable on rest
    DeleteLocalInt(oPC, "PDKHeroicTracking"); // Set PDK heroic sheild use to able
    DeleteLocalInt(oPC, "RangerDodgeCount"); //Clear ranger dodge use on rest.
    DeleteLocalInt(oPC, "RangerDodgeActive"); //Clear ranger dodge and fighter dodge stack check.
    DeleteLocalInt(oPC, "FeatEnhancerActive"); //Clears fighter feat enhancer on rest.
    DeleteLocalInt(oPC, "BgPulseCount"); // Clears Blackguard Bull's Strength pulse
    DeleteLocalInt(oPC, "TumbleAcBonus"); // Clears bonus ac availability from non-tumble class
    DeleteLocalInt(oPC, "DarknessCooldown"); // Assassin Darkness Cooldown
    DeleteLocalInt(oPC, "HasAprBonus"); // Ranger APR bonus check
    DeleteLocalInt(oPC, "HasWmAc"); // Cory - Check for WM ac bonus
    DeleteLocalInt(oPC, "HasBgAb"); // Cory - Clears int that prevents bg buff stacking
    DeleteLocalInt(oPC, "BgRepPenalty"); // Cory - Clears BG epic reputation check
    DeleteLocalInt(oPC, "wrath_uses"); // Divine Wrath uses check
}

void main()
{
    int iRestDelay = 2;       // The ammount of hours a player must wait between Rests (Default = 8 hours)
    int iHostileRange = 20;   // The radius around the players that must be free of hostiles in order to rest.
                            // iHostileRange = 0: Hostile Check disabled
                            // iHostileRange = x; Radius of Hostile Check (x meters)
                            // This can be abused as some sort of "monster radar".

    // Variable Declarations
    object oPC      = GetLastPCRested(); // This Script only affects Player Characters. Familiars, summoned creatures and probably henchmen WILL rest!
    int nEventType  = GetLastRestEventType();
    int nLevel      = GetHitDice(oPC);

    // ---------- Rest Event started ----------
    if (nEventType == REST_EVENTTYPE_REST_STARTED)
    {
    // Check if since the last rest more than <iRestDelay> hours have passed.
        if ((GetHourTimeZero() < GetLocalInt (oPC, "i_TI_LastRest") + iRestDelay)) // i_TI_LastRest is 0 when the player enters the module
        {    // Resting IS NOT allowed
            stopResting(oPC); // stops master char and familiars
            SendMessageToPC(oPC, "You must wait " + IntToString (iRestDelay - (GetHourTimeZero() - GetLocalInt (oPC, "i_TI_LastRest"))) + " hour(s) before resting again.");
            return;
        }
        else // Resting IS possible
        {
            object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
            if (iHostileRange == 0 || (iHostileRange != 0 && GetDistanceToObject(oCreature) <= IntToFloat(iHostileRange)))
            { // If Hostile Check disabled or no Hostiles within Hostile Radius: Initiate Resting
                SetLocalInt (oPC, "i_TI_LastRest", GetHourTimeZero()); // Set Last Rest Time
            }
            else
            { // Resting IS NOT allowed
                AssignCommand (oPC, ClearAllActions()); // Prevent Resting
                SendMessageToPC (oPC, "You can't rest. Hostiles nearby");
                return;
            }
        }
    }

    // ---------- Rest Event finished or aborted ----------
    if (nEventType == REST_EVENTTYPE_REST_FINISHED || nEventType == REST_EVENTTYPE_REST_CANCELLED)
    {
        AssignCommand(oPC, DestroyControlledCreatures(oPC));

        if (nEventType == REST_EVENTTYPE_REST_FINISHED)
        {
            if (!GetIsDM(oPC) && !GetIsDMPossessed(oPC))
            {
                //string sCDKey  = GetPCPublicCDKey(oPC);
                string sFAID   = SDB_GetFAID(oPC);
                object oModule = GetModule();

                OnRestDeleteLocal(oPC);
                DropRune(oPC);
                OnPCRest(oPC, nLevel);
                SDB_FactionOnPCRest(oPC);
                Artifact_GiveBonuses(sFAID, oPC); // GIVE FACTION ARTIFACT BONUSES
                CheckAllItems(oPC);
                StoreTimeOnDB(oPC, sFAID); // "fame_inc"
                StoreFameOnDB(oPC, sFAID); // "fame_inc"
                WeaponAcBonus(oPC);
                DelayCommand(0.1, NoobDoBuff(oPC, nLevel, sFAID));
                PartyGiveID(oPC);
                WeaponMasterBonus(oPC); // Cory - Weapon Master Modifications
                NoTumbleAcBonus(oPC); // Cory - Non-tumble build AC bonus
                DecrementRemainingFeatUses(oPC, FEAT_PALADIN_SUMMON_MOUNT); // Disable Summon Mount Horses (FPS issues)
            }
            SendMessageToPC(oPC, "Next reboot in " + RemainingUpTime());
            effect eHaste = ExtraordinaryEffect(EffectHaste());
            DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHaste, oPC));
        }
    }
}
