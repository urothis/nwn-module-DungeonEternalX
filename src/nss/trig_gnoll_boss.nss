#include "_functions"

void main()
{
    object oPlayer = GetEnteringObject();
    if (!GetIsPlayer(oPlayer)) return;

    object oEncounter = OBJECT_SELF;
    if (GetLocalInt(oEncounter, "ENC_WAIT")) return;
    SetLocalInt(oEncounter, "ENC_WAIT", TRUE);
    int nEncDelay = GetLocalInt(oEncounter, "ENC_DELAY"); // SET IN TOOLSET
    AssignCommand(GetArea(oEncounter), DelayCommand(IntToFloat(nEncDelay), DeleteLocalInt(oEncounter, "ENC_WAIT")));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), oPlayer);
    object oWP1 = GetNearestObjectByTag("WP_GNOLL_BOSS");
    object oBoss = CreateObject(OBJECT_TYPE_CREATURE, "gnoll_priest", GetLocation(oWP1), FALSE, "BOSS_GNOLL");
}
