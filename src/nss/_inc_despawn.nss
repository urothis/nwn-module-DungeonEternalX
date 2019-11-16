void Despawn(object oToDespawn);

void DestroySpawn(object oToDespawn)
{
    if (!GetIsObjectValid(oToDespawn)) return;

    if (GetIsObjectValid(GetMaster(oToDespawn)))
    {
        AssignCommand(GetArea(oToDespawn), DelayCommand(600.0, DestroySpawn(oToDespawn)));
    }
    else DestroyObject(oToDespawn);
}

void Despawn(object oToDespawn)
{
    if (!GetIsObjectValid(oToDespawn)) return;

    if (GetIsInCombat(oToDespawn))
    {
        AssignCommand(GetArea(oToDespawn), DelayCommand(120.0, DestroySpawn(oToDespawn)));
        return;
    }
    else DestroySpawn(oToDespawn);
}
