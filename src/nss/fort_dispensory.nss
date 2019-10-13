// Distributes rewards to players who control The Fort
#include "seed_faction_inc"
#include "inc_traininghall"
#include "fame_inc"


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

// Give each member of the users party a reward
void GivePartyReward(object oPC)
{
    object oMember = GetFirstFactionMember(oPC);

    while (GetIsObjectValid(oMember)) // Cycle through party
    {
        string sFAIDMember = GetLocalString(oMember, "FAID");
        int nAllyCheck = StringToInt(sFAIDMember);

        if (GetArea(oMember) == GetArea(oPC)) // In the same area
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oMember);
            CreateTrainingToken(oMember, 1);
            IncFameOnChar(oMember, 10.0);
            SendMessageToPC(oMember, "Aqcuired Fame: 10");
        }
        oMember = GetNextFactionMember(oPC);
    }
}

void main()
{
    object oPC = GetLastUsedBy();
    object oControl = OBJECT_SELF;
    object oArea = GetArea(oPC);

    string sFAID = GetLocalString(oPC, "FAID");
    string sFaction = SDB_FactionGetName(sFAID);

    int nPcUse = dbGetTRUEID(oPC);  //

    if (GetIsHostilePcNearby(oPC, oArea, 35.0, 5)) // Check for hostiles before rewards given
    {
        FloatingTextStringOnCreature("Enemies Nearby.", oPC, FALSE);
        return;
    }
    if (!GetLocalInt(oControl, "DispensoryUsed"))
    {
        int nFAID = StringToInt(sFAID);
        int nPcOwner = dbGetTRUEID(oPC);

        // Check if player already has control
        if (GetLocalInt(GetModule(), "TheFortOwner") == nFAID) // Faction has control
        {
            FloatingTextStringOnCreature("Distributing reward to your nearby party members.", oPC, FALSE);
            GivePartyReward(oPC);
            SetLocalInt(oControl, "DispensoryUsed", TRUE);   // prevent spam
            SetLocalInt (oControl, "LastUsed", GetHourTimeZero()); // Shows timer for next use
            DelayCommand(960.0, DeleteLocalInt(oControl, "DispensoryUsed"));
        }
        else if (GetLocalInt(GetModule(), "TheFortOwner") == nPcOwner)// For unfactioned players with control
        {
            FloatingTextStringOnCreature("Distributing reward to your nearby party members.", oPC, FALSE);
            GivePartyReward(oPC);
            SetLocalInt(oControl, "DispensoryUsed", TRUE);   // prevent spam
            SetLocalInt (oControl, "LastUsed", GetHourTimeZero()); // Shows timer for next use
            DelayCommand(960.0, DeleteLocalInt(oControl, "DispensoryUsed"));
        }
        else // Player has no control of dispensory
        {
            FloatingTextStringOnCreature("You currently do not own The Fort and cannot activate this object.", oPC, FALSE);
        }
    }
    else
    {
         //FloatingTextStringOnCreature("You must wait 300 seconds between each use of the reward distribution orb.", oPC, FALSE);
         SendMessageToPC(oPC, "You must wait " + IntToString (8 - (GetHourTimeZero() - GetLocalInt(oControl, "LastUsed"))) + " game hour(s) before using this device.");
    }
}
