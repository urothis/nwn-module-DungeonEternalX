#include "x2_inc_switches"
#include "_functions"
#include "tradeskills_inc"
#include "time_inc"

void SeedChangeName(object oPlant, string sName)
{
    if (GetIsObjectValid(oPlant)) SetName(oPlant, sName);
}

void SeedGrow(object oPC, string sPlantName, string sPlantTag, location locWP, object oWP)
{
    object oPlant = CreateObject(OBJECT_TYPE_PLACEABLE, "crafting_plant", locWP, FALSE, sPlantTag);
    int nTime = TS_AdjustCraftingTime(oPC, 90 + d3(), "ts_farming");
    TS_IncreaseSkill(oPC, 1, "ts_farming");
    object oArea = GetArea(oWP);
    SetLocalObject(oArea, GetTag(oWP), oPlant);

    AssignCommand(oPlant, DelayCommand(1.0, SpeakString("Grown in " + ConvertSecondsToString(nTime))));
    AssignCommand(oArea, DelayCommand(IntToFloat(nTime), SeedChangeName(oPlant, sPlantName)));
}


void EndPlanting(object oPC, location locWP, location locPC, string sPlantTag, string sPlantName, object oWP)
{
    if (GetLocation(oPC) == locPC)
    {
        AssignCommand(GetArea(oPC), SeedGrow(oPC, sPlantName, sPlantTag, locWP, oWP));
    }
}

void StartPlanting(object oPC, location locWP, string sPlantTag, string sPlantName, object oWP)
{
    location locPC = GetLocation(oPC);
    float fDist = GetDistanceBetweenLocations(locPC, locWP);
    if (fDist != 0.0 && fDist < 1.5)
    {
        AssignCommand(oPC, DelayCommand(11.0, EndPlanting(oPC, locWP, locPC, sPlantTag, sPlantName, oWP)));
    }
}

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

    object oPC = GetItemActivator();
    string sSeed = GetName(GetItemActivated());

    object oWP = GetNearestObjectByTag("WP_FISHING", oPC);
    if (GetIsObjectValid(oWP))
    {
        if (GetDistanceBetween(oPC, oWP) < 5.0)
        {
            if (GetIsObjectValid(GetLocalObject(oWP, "FISHING_PC")))
            {
                FloatingTextStringOnCreature("There is allready someone fishing here!", oPC, FALSE);
                return;
            }
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, ActionMoveToObject(oWP, TRUE, 0.0));
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 15.0));
            // AssignCommand(oPC, DelayCommand(3.0, StartPlanting(oPC, GetLocation(oWP), sTag, sSeed, oWP)));
            DelayCommand(2.0, SendMessageToPC(oPC, FloatToString(GetFacing(oPC), 0, 2)));
            return;
        }
    }
    FloatingTextStringOnCreature("You can not use this here", oPC, FALSE);
}
