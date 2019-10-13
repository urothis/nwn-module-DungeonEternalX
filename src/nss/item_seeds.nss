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
    int nTime = TS_AdjustCraftingTime(oPC, 90 + d6(), "ts_farming");
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
        AssignCommand(oPC, DelayCommand(8.0, EndPlanting(oPC, locWP, locPC, sPlantTag, sPlantName, oWP)));
    }
}

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

    object oPC = GetItemActivator();
    string sSeed = GetName(GetItemActivated());
    sSeed = GetStringLeft(sSeed, GetStringLength(sSeed) - 6); // "BlaBlaBla Seeds" cut off " Seeds"
    string sTag;

    if      (sSeed == "Dark Cypress")   sTag = "DARK_CYPRESS"; // NEP
    else if (sSeed == "Cornflower")     sTag = "CORN_FLOWER";  // Minor Ele Resist
    else if (sSeed == "Sycamore")       sTag = "SYCAMORE";     // Ext. Aid
    else if (sSeed == "Temple Plant")   sTag = "TEMPLEPLANT";  // Ext. Bless
    else if (sSeed == "Ephedra")        sTag = "EPHEDRA";      // Ext. MA
    else return;

    object oPlant;

    object oWP = GetFirstObjectInShape(SHAPE_SPHERE, 3.0, GetLocation(oPC), FALSE, OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oWP))
    {
        if (GetStringLeft(GetTag(oWP), 10) == "PLANT_POS_") break;
        else oWP = GetNextObjectInShape(SHAPE_SPHERE, 3.0, GetLocation(oPC), FALSE, OBJECT_TYPE_PLACEABLE);
    }

    if (GetIsObjectValid(oWP))
    {
        if (GetIsObjectValid(GetLocalObject(GetArea(oWP), GetTag(oWP))))
        {
            FloatingTextStringOnCreature("There is already something plant here!", oPC, FALSE);
            return;
        }
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionMoveToObject(oWP, TRUE));
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 8.0));
        AssignCommand(oPC, DelayCommand(3.0, StartPlanting(oPC, GetLocation(oWP), sTag, sSeed, oWP)));
    }
    else FloatingTextStringOnCreature("You can not plant this here", oPC, FALSE);
}
