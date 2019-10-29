// Distributes rewards to players who control The Fort
#include "seed_faction_inc"
#include "inc_traininghall"
#include "fame_inc"

// Give each member of the users party a reward
void GivePartyReward(object oPC) {
    object oMember = GetFirstFactionMember(oPC);
     // Cycle through party
    while (GetIsObjectValid(oMember)) {
        // In the same area
        if (GetArea(oMember) == GetArea(oPC)) {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oMember);
            CreateTrainingToken(oMember, 1);
            IncFameOnChar(oMember, 10.0);
            SendMessageToPC(oMember, "Aqcuired Fame: 10");
        }
        oMember = GetNextFactionMember(oPC);
    }
}

void main() {
    object oPC = GetLastUsedBy();
    object oObject = OBJECT_SELF;
    object oArea = GetArea(oPC);
    object oModule = GetModule();

    string sFAID = GetLocalString(oPC, "FAID");
    string sFaction = SDB_FactionGetName(sFAID);

    int nPcUse = dbGetTRUEID(oPC);

    // Check for hostiles before rewards given
    if (GetIsHostilePcNearby(oPC, oArea, 35.0, 5)) {
        FloatingTextStringOnCreature("Enemies Nearby.", oPC, FALSE);
        return;
    }

    // timer
    int nLastUsed = NWNX_Time_GetTimeStamp() - GetLocalInt(oObject,"LAST_USED");
    if ( nLastUsed >= 960 ) {
        // Faction/Player has control
        if (GetLocalInt(oModule, "TheFortOwner") == StringToInt(sFAID) || GetLocalInt(oModule, "TheFortOwner") == dbGetTRUEID(oPC)) {
            SetLocalInt(oObject,"LAST_USED",NWNX_Time_GetTimeStamp());
            FloatingTextStringOnCreature("Distributing reward to your nearby party members.", oPC, FALSE);
            GivePartyReward(oPC);
            return;
        }

        // Player has no control of dispensory
        FloatingTextStringOnCreature("You currently do not own The Fort and cannot activate this object.", oPC, FALSE);
        return;
    }

    // not ready yet
    else {
        int iMin = nLastUsed / 60;
        int iSec = nLastUsed % 60;
        int iTrueMin = iMin % 60;
        SendMessageToPC(oPC, "You must wait " + IntToString(iTrueMin) + ":" + IntToString(iSec) + " seconds before using this device.");
        return;
    }
}
