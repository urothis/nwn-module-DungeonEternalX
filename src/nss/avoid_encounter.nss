void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;
    if (GetIsDMPossessed(oPC)) return;
    if (!GetIsObjectValid(oPC)) return;

    object oEncounter = GetNearestObject(OBJECT_TYPE_ENCOUNTER);
    if (!GetIsObjectValid(oEncounter)) return;

    string sTag = GetTag(oEncounter);

    string sCR = GetStringRight(sTag, 4); // ENCOUNTER_CR35 -> CR35 , ENCOUNTER_CR5 -> _CR5

    if (GetStringLeft(sCR, 2) == "CR") sCR = GetStringRight(sTag, 2);
    else if (GetStringLeft(sCR, 3) == "_CR") sCR = GetStringRight(sTag, 1);
    else return;

    // PC with more than 5 levels wont spawn mobs
    if (GetHitDice(oPC) > StringToInt(sCR)+5)
    {
        SetEncounterActive(FALSE, oEncounter);
        DelayCommand(30.0, SetEncounterActive(TRUE, oEncounter));
    }
}
