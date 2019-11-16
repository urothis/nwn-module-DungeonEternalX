const float CLEANER_TIMER_DELAY = 600.0f;

void CleanArea( object oArea = OBJECT_SELF)
{
    // First check to see if the ExitingObject is a PC or not
    object oPC = GetExitingObject();
    // If not, we'll just exit
    if (!GetIsPC(oPC))
        return;
    // Start up the loop, setting oPC now to the first PC
    oPC = GetFirstPC();
    // Continue looping until there are no more PCs left
    while (oPC != OBJECT_INVALID)
    {
        // Check the Area against the Area of the current PC
        // If they are the same, exit the function, as we do not need to
        // check anymore PCs
        if (OBJECT_SELF == GetArea(oPC))
            return;
        // If not, continue to the next PC
        else oPC = GetNextPC();
    }
    // If we've made it this far, we know that there aren't any PCs in the area
    // Set oObject to the first object in the Area
    object oObject = GetFirstObjectInArea(OBJECT_SELF);
    // Continue looping until there are no more objects left
    while (oObject != OBJECT_INVALID)
    {
        // Test to see if oObject is a creature spawned from an encounter
        // If so, destroy the object
        if (GetIsEncounterCreature(oObject))
            DestroyObject(oObject);
        // Move on to the next object
        oObject = GetNextObjectInArea(OBJECT_SELF);
    }
    DelayCommand(CLEANER_TIMER_DELAY, CleanArea());
}
