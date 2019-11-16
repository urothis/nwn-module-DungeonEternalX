#include "inc_traininghall"
#include "gen_inc_color"

void DamageTest(object oPC, object oDummy, int nMaxHP, float fDur);

void DamageTest(object oPC, object oDummy, int nMaxHP, float fDur)
{
    DelayCommand(2.0, DeleteLocalInt(oDummy, "DMG_TEST_RUNNING"));
    int nHP = GetCurrentHitPoints(oDummy);
    int nDmgTotal = nMaxHP - nHP;
    int nDur = FloatToInt(fDur);
    int nDmgSec = nDmgTotal/nDur;
    AssignCommand(oPC, ClearAllActions());
    DelayCommand(2.0, AssignCommand(oPC, ActionSpeakString(IntToString(nDur) +
                    GetRGB(1,7,7) + " seconds damage test on: " + GetRGB() + GetName(oDummy) +
                    GetRGB(1,7,7) + " - Damage Total: " + GetRGB() + IntToString(nDmgTotal) +
                    GetRGB(1,7,7) + " - Damage per second: " + GetRGB() + IntToString(nDmgSec))));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nMaxHP), oDummy);
}


void main()
{
    object oDummy = OBJECT_SELF;
    object oPC = GetLastDamager(oDummy);
    if (!GetIsTestChar(oPC)) return;
    if (GetLocalInt(oDummy, "DMG_TEST_RUNNING")) return;
    SetLocalInt(oDummy, "DMG_TEST_RUNNING", TRUE);
    FloatingTextStringOnCreature("Damage test has been started, keep attacking...", oPC, FALSE);
    int nMaxHP = GetMaxHitPoints(oDummy);
    float fDur = 24.0;
    DelayCommand(fDur, DamageTest(oPC, oDummy, nMaxHP, fDur+0.3));

}
