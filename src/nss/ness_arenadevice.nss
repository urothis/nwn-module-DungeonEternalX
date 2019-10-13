#include "gen_inc_color"

    // There are 3 devices associated with the porting. The device its self in loft. tavern and the
    // two switches in the stadium to enable/disable it.


//Only a DM can enable the port device, but the oPC sets the local int
//of the tavern's port device to TRUE.
void portDeviceEnable(object oPC, object oPortDevice);

//Only a DM can enable the port device, but the oPC sets the local int
//of the tavern's port device to FALSE.
void portDeviceDisable(object oPC, object oPortDevice);

//Ports DMs to the stadium. If the oPC is a player and the localint is TRUE,
//then it ports the oPC to the stadium, or specified waypoint.
void portToStadium(object oPC, object oDevice, location lWaypoint);



void main()
{
    object oPC        = GetLastUsedBy();
    object oStadiumWP = GetWaypointByTag("STADIUM_PORT");
    location lStadium = GetLocation(oStadiumWP);

    //This is the Loftendwood Tavern Port device
    object oTavernDevice = GetObjectByTag("arena_port_device");

    //These are the switches in the DeX Stadium
    object oOnSwitch  = GetObjectByTag("StadiumPortOn");
    object oOffSwitch = GetObjectByTag("StadiumPortOff");

    if (oTavernDevice == OBJECT_SELF)
    {
        portToStadium(oPC, oTavernDevice, lStadium);
    }
    else if (oOnSwitch == OBJECT_SELF)
    {
        portDeviceEnable(oPC, oTavernDevice);
    }
    else if (oOffSwitch == OBJECT_SELF)
    {
        portDeviceDisable(oPC, oTavernDevice);
    }

    return;
}

void portDeviceEnable(object oPC, object oPortDevice)
{
    if (GetIsDM(oPC))
    {
        if (GetLocalInt(OBJECT_SELF,"tourneyport"))
        {
            SetLocalInt(oPortDevice, "portEnable", TRUE);
            //DelayCommand(300.0f, SetLocalInt(oPortDevice, "portEnable", FALSE));

            string tourney = GetRGBColor(CLR_BLUE) + GetName(oPC) + " is holding a tourney. Go to Loftenwood tavern and use the portal device to be ported." + GetRGBColor();
            SpeakString(tourney, TALKVOLUME_SHOUT);
        }
    }
}

void portDeviceDisable(object oPC, object oPortDevice)
{
    if (GetIsDM(oPC))
    {
        SetLocalInt(oPortDevice, "portEnable", FALSE);

        string tourney = GetRGBColor(CLR_BLUE) + "Tourney porting is now closed." + GetRGBColor();
        SpeakString(tourney, TALKVOLUME_SHOUT);
    }
}

void portToStadium(object oPC, object oDevice, location lWaypoint)
{
    if (GetIsDM(oPC))
    {
        AssignCommand(oPC, ActionJumpToLocation(lWaypoint));
    }
    else if (GetIsPC(oPC) && GetLocalInt(oDevice, "portEnable") && GetHitDice(oPC)==40)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_FIRE), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION), oPC);
        DelayCommand(1.0f, AssignCommand(oPC, ActionJumpToLocation(lWaypoint)));
    }
    else
    {
        SendMessageToPC(oPC, GetRGBColor(CLR_RED)+"There is no tourney right now, or the tourney is closed."+GetRGBColor());
    }
}
