#include "inc_traininghall"
#include "db_inc"

// FALSE - nothing active
// PORT_IS_ALLOWED
// PORT_NOT_ALLOWED
void SetPortMode(object oPC, int nMode=FALSE);
// FALSE - nothing active
// PORT_IS_ALLOWED
// PORT_NOT_ALLOWED
int GetPortMode(object oPC);
// only for portstones, factionport and scrolls
int IsWarpAllowed(object oPC);
// The invisible object in SYSTEM Area where localvariables are stored on
object GetWPHolder();
void PortToBind(object oPC);

//MAP_ETHEREAL_PLANE
const int PORT_IS_ALLOWED  = 1;
const int PORT_NOT_ALLOWED = 2;

object GetWPHolder()
{
    return GetLocalObject(GetModule(), "VARS_WP");
}

object GetBind(object oPC)
{
    return GetLocalObject(GetWPHolder(), GetLocalString(oPC, "BIND"));
}

void PortToBind(object oPC)
{
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToObject(GetBind(oPC)));
}

void SetBind(object oPC, string sWP)
{
    SetLocalString(oPC, "BIND", sWP);
    NWNX_SQL_ExecuteQuery("update player set bind = '" + sWP + "' where plid=" + IntToString(dbGetPLID(oPC)));
}

void SetPortMode(object oPC, int nMode=FALSE)
{
    if (nMode) SetLocalInt(oPC, "PORT_MODE", nMode);
    else DeleteLocalInt(oPC, "PORT_MODE");
}

int GetPortMode(object oPC)
{
    return GetLocalInt(oPC, "PORT_MODE");
}

int IsWarpAllowed(object oPC)
{
    object oArea = GetArea(oPC);

    if (GetIsTestChar(oPC)) return FALSE;
    if (GetTag(oArea) == "MAP_JAIL") return FALSE;
    if (GetIsInCombat(oPC))
    {
        SendMessageToPC(oPC, "You can not port in combat mode");
        return FALSE;
    }
    if (GetLocalInt(oPC, "PORTS_DEACTIVATE"))
    {
        SendMessageToPC(oPC, "You can not port at this time.");
        return FALSE;
    }
    if (GetPortMode(oPC) == PORT_NOT_ALLOWED)
    {
        SendMessageToPC(oPC, "You can not try another port attempt so close to the last one.");
        return FALSE;
    }
    if (GetIsHostilePcNearby(oPC, oArea, 35.0, 5))
    {
        SendMessageToPC(oPC, "You can not port with enemies nearby");
        SetPortMode(oPC, PORT_NOT_ALLOWED);
        DelayCommand(3.0, SetPortMode(oPC));
        return FALSE;
    }

    // Cory - No porting with DM event ring, or during a special event
    if (HasItem(oPC,"GeneralOtmansRing"))
    {
        SendMessageToPC(oPC, "You can not port while holding General Otman's Ring.");
        return FALSE;
    }
    if (GetLocalInt(oPC, "DmEventNoPort")==1)
    {
        SendMessageToPC(oPC, "You can not port while participating in an event.");
        return FALSE;
    }
    return TRUE;
}



//void main(){}
