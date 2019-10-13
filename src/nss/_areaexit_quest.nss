#include "_functions"

void DestroyAllNPC(object oArea)
{
    float fDelay;
    object oCreature = GetFirstObjectInArea(oArea);
    while (GetIsObjectValid(oCreature))
    {
        if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE)
        {
            if (!GetIsPC(oCreature))
            {
                fDelay += 0.5;
                DestroyObject(oCreature, fDelay);
            }
        }
        oCreature = GetNextObjectInArea(oArea);
    }
}

void main()
{
    object oPC = GetExitingObject();
    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;
    if (GetIsDMPossessed(oPC)) return;
    object oArea = OBJECT_SELF;

    string sTag = GetTag(oArea);

    if (sTag == "ENCHASSARA_CAVE_2")
    {
        DelayCommand(1.0, DestroyAllNPC(oArea));
        return;
    }
}
