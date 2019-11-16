#include "enc_inc"

void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;
    if (GetIsDMPossessed(oPC)) return;

    object oArea = OBJECT_SELF;

    ExploreAreaForPlayer(oArea, oPC);
    AssignCommand(oArea, DelayCommand(0.1, EncounterOnAreaEnter(oPC, oArea)));

    DeleteLocalInt(oArea, "PARTY_CNT"); // Used for Dynamic Spawns, SetLocalInt in "give_custom_xp"

    //SDB_OnAreaEnter(oArea); // Ezramun: function checked, can be completely deactivated
    if (GetLocalInt(oPC, "DO_PORT_FX"))
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(471), GetLocation(oPC));
        DeleteLocalInt(oPC, "DO_PORT_FX");
    }
    if (GetLocalInt(oArea, "PORTS_DEACTIVATE")) SetLocalInt(oPC, "PORTS_DEACTIVATE", TRUE);
}
