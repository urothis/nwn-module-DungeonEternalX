
// First you must lower the defenses of the control defense; takes 60 seconds. Then you can gain control by clicking agin, if no hostiles nearby.

#include "seed_faction_inc"
#include "fame_inc"

// Give rewards to the faction that controls fort
void FactionFameReward(object oControl, int nFortID)
{
    int nFAID = GetLocalInt(GetModule(), "TheFortOwner");

    if (nFAID == nFortID)  // If faction holds fort after 10 minutes
    {
        string sFID = IntToString(nFortID);
        // Give fame
        NWNX_SQL_ExecuteQuery("update faction set fa_fame=fa_fame+" + IntToString(15) + " where fa_faid=" + sFID);

        // Give XP
        int nCurrentXp = GetFactionsXP(sFID);
        int nNewXp = nCurrentXp + 10000;
        SetFactionXP(nNewXp, sFID);

        string sFaction = SDB_FactionGetName(sFID);
        ShoutMsg(sFaction + " holds The Fort and has earned 15 fame and 10k XP.");

        // Continue Giving reward every ten minutes
        //AssignCommand(oControl, DelayCommand(600.0, FactionFameReward(oControl, nFAID)));
    }
}

// Give rewards to the Unfactioned player that controls fort
/*void UnfactionFameReward(object oControl, int nFortID, object oPC)
{
    int nFAID = GetLocalInt(GetModule(), "TheFortOwner");
    int nPcOwner = dbGetTRUEID(oPC);

    if (nPcOwner == nFortID) // If player still owns the fort after 10 mins
    {
        // Give fame
        IncFameOnChar(oPC, 15.0);

        // Give XP
        int nCurrentXp = dbGetBankXP(oPC);
        int nNewXp = nCurrentXp + 10000;
        dbSetBankXP(oPC, nNewXp);

        ShoutMsg(GetName(oPC) + " holds The Fort and has earned 15 fame and 10k bank XP.");

        // Continue Giving reward every ten minutes
        AssignCommand(oControl, DelayCommand(60.0, UnfactionFameReward(oControl, nFAID, oPC)));
    }
}
*/

void ControlAttempt(object oPC, object oArea, object oControl)
{
    string sFAID = GetLocalString(oPC, "FAID");
    string sFaction = SDB_FactionGetName(sFAID);

    int nPcOwner = dbGetTRUEID(oPC);
    int nFAID = StringToInt(sFAID);

    if (!(GetIsHostilePcNearby(oPC, oArea, 10.0, 5))) // Nearby enemy check
    {
        if (nFAID == 0) // If unfactioned, use players name
        {
            ShoutMsg(GetName(oPC) + " Has conquered The Fort.");
            SetLocalInt(GetModule(), "TheFortOwner", nPcOwner);
            SetLocalInt(oControl, "CONTROLDEFENSE", 0);

            effect eLoop = GetFirstEffect(oControl);
            while (GetIsEffectValid(eLoop))
            {
                RemoveEffect(oControl, eLoop);
                eLoop = GetNextEffect(oControl);
            }

            effect eVis = EffectVisualEffect(279, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oControl); // visual cue

            // Begin counter for unfactioned fame and exp bonuses for holding the fort
            //AssignCommand(oControl, DelayCommand(60.0, UnfactionFameReward(oControl, nFAID, oPC)));
        }
        else // Use faction name
        {
            ShoutMsg(sFaction + " has conquered The Fort.");
            SetLocalInt(GetModule(), "TheFortOwner", nFAID);
            SetLocalInt(oControl, "CONTROLDEFENSE", 0);

            effect eLoop = GetFirstEffect(oControl);
            while (GetIsEffectValid(eLoop))
            {
                RemoveEffect(oControl, eLoop);
                eLoop = GetNextEffect(oControl);
            }

            effect eVis = EffectVisualEffect(279, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oControl); // visual cue

            // Begin Counter for faction fame bonus, reward for holding the fort
            AssignCommand(oControl, DelayCommand(600.0, FactionFameReward(oControl, nFAID)));


        }
    }
    else // Cancel control attempt, defenders are near
    {
        FloatingTextStringOnCreature("Enemies Nearby, conquer attempt failed", oPC, FALSE);
    }
}

void main()
{
    object oPC = GetLastUsedBy();
    object oControl = OBJECT_SELF;
    object oArea = GetArea(oPC);

    string sFAID = GetLocalString(oPC, "FAID");
    string sFaction = SDB_FactionGetName(sFAID);

    int nFAID = StringToInt(sFAID);

    if (GetIsHostilePcNearby(oPC, oArea, 35.0, 5)) // Check for hostiles before gaining control
    {
        FloatingTextStringOnCreature("Enemies Nearby.", oPC, FALSE);
        return;
    }

    if ((GetLocalInt(oControl, "CONTROLDEFENSE")) && (GetLocalInt(GetModule(), "TheFortOwner") != nFAID))  // Defense down, do conquer attempt
    {
        ControlAttempt(oPC, oArea, oControl);
    }
    else if (!GetLocalInt(oControl, "LASTCLICK"))
    {

        int nPcOwner = dbGetTRUEID(oPC);

        // Check if player already has control
        if (GetLocalInt(GetModule(), "TheFortOwner") == nFAID)
        {
            FloatingTextStringOnCreature(sFaction + " already controls The Fort.", oPC, FALSE);
            if (GetLocalInt(oControl, "CONTROLDEFENSE")) // Defenders successful - re-enable control defenses
            {
                SetLocalInt(oControl, "CONTROLDEFENSE", 0);
                FloatingTextStringOnCreature(sFaction + " control defenses re-enabled.", oPC, FALSE);

                effect eLoop = GetFirstEffect(oControl);
                while (GetIsEffectValid(eLoop))
                {
                    RemoveEffect(oControl, eLoop);
                    eLoop = GetNextEffect(oControl);
                }

                effect eVis = EffectVisualEffect(VFX_IMP_KNOCK, FALSE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oControl); // visual cue
            }
            return;
        }
        else if (GetLocalInt(GetModule(), "TheFortOwner") == nPcOwner)// For unfactioned player
        {
            FloatingTextStringOnCreature(GetName(oPC) + " already controls The Fort.", oPC, FALSE);
            if (GetLocalInt(oControl, "CONTROLDEFENSE")) // Defenders successful - re-enable control defenses
            {
                SetLocalInt(oControl, "CONTROLDEFENSE", 0);
                FloatingTextStringOnCreature(sFaction + " control defenses re-enabled.", oPC, FALSE);

                effect eLoop = GetFirstEffect(oControl);
                while (GetIsEffectValid(eLoop))
                {
                    RemoveEffect(oControl, eLoop);
                    eLoop = GetNextEffect(oControl);
                }

                effect eVis = EffectVisualEffect(VFX_IMP_KNOCK, FALSE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oControl); // visual cue
            }
            return;
        }

        // Floating text display of current owner
        if (0 < (GetLocalInt(GetModule(), "TheFortOwner")) <= 5)    // Faction controls
        {
            int nFID = GetLocalInt(GetModule(), "TheFortOwner");  // ID #
            string sFID = IntToString(nFID); // Fort ID # for controller
            string sFFID = SDB_FactionGetName(sFID); // Fort faction controller
            if (sFFID == "")
            {
                FloatingTextStringOnCreature("No one controls The Fort.", oPC, FALSE);
            }
            else
            {
                FloatingTextStringOnCreature(sFFID + " controls The Fort.", oPC, FALSE);
            }
        }
        else if (GetLocalInt(GetModule(), "TheFortOwner") == 123456) // No one controls
        {
            FloatingTextStringOnCreature("No one controls The Fort.", oPC, FALSE);
        }
        else // A non-factioned player controls
        {
            FloatingTextStringOnCreature(GetName(oPC) + " has control of The Fort.", oPC, FALSE);
        }



/*        if (nFAID == 0) // If unfactioned, use player name
        {
            ShoutMsg(GetName(oPC) + " is attempting to conquer The Fort.");
        }
        else // Use faction name
        {
            ShoutMsg(sFaction + " is attempting to conquer The Fort.");
        }
*/
        ShoutMsg("Someone is attempting to conquer The Fort.");
        effect eKnock = EffectVisualEffect(VFX_IMP_KNOCK, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eKnock, oControl); // visual cue

        AssignCommand(oPC, DelayCommand(60.0, SetLocalInt(oControl, "CONTROLDEFENSE", 1))); // Attempt to LOWER CONTROL DEFENSES
        effect eVis = EffectVisualEffect(278, FALSE);
        effect eVis2 = EffectVisualEffect(VFX_DUR_AURA_PULSE_MAGENTA_RED, FALSE);
        AssignCommand(oControl, DelayCommand(60.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oControl))); // visual cue
        AssignCommand(oControl, DelayCommand(60.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis2, oControl))); // visual cue

        SetLocalInt(oControl, "LASTCLICK", TRUE);   // prevent spam
        DelayCommand(60.0, DeleteLocalInt(oControl, "LASTCLICK"));
    }
    else
    {
         FloatingTextStringOnCreature("You must wait 60 seconds between each attempt to gain control.", oPC, FALSE);
    }
}
