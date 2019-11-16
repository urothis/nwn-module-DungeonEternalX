#include "_inc_character"
#include "_inc_port"

void RespawnChar(object oRespawner, string sWP = "Ethereal_Enter");

void DeathDoVFX(object oKilled)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oKilled);
    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), oKilled));
    DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oKilled));
}

void RespawnChar(object oRespawner, string sWP = "Ethereal_Enter")
{
    AssignCommand(oRespawner, ClearAllActions(TRUE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oRespawner);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oRespawner)), oRespawner);
    if (sWP != "")
    {
        object oWP = DefGetObjectByTag(sWP, GetWPHolder());
        DelayCommand(0.1, AssignCommand(oRespawner, JumpToObject(oWP)));
    }
}

void DestroyGrave(object oGrave, string sName)
{
    if (GetIsObjectValid(oGrave)) DestroyObject(oGrave, 1.0);
    DeleteLocalObject(GetModule(), "PC_GRAVE_" + sName);
}

void DeathPenaltyGrave(object oPC, int nHD, int nXP, string sName)
{
    if (!GetIsObjectValid(oPC)) return;
    if (nHD < 5) return;

    int nNewXP = nXP - 50 * nHD;
    int nMin = ((nHD * (nHD - 1)) / 2) * 1000;
    if (nNewXP < nMin)  nNewXP = nMin;

    if (nXP - nNewXP < 1) return;

    if (GetStringLength(sName) >= 20) sName = GetStringLeft(sName, 20);

    SetXP(oPC, nNewXP);

    // Destroy the old one
    object oGrave = GetLocalObject(GetModule(), "PC_GRAVE_" + sName);
    if (GetIsObjectValid(oGrave)) DestroyObject(oGrave, 1.0);

    // Make new grave
    location lGraveLoc = GetLocation(oPC);
    oGrave = CreateObject(OBJECT_TYPE_PLACEABLE, GetStringLowerCase("pc_grave"), lGraveLoc);
    int nRandom = d3();
    string sRip;
    if (nRandom == 3) sRip = "P.W.N.D. ";
    else if (nRandom == 2) sRip = "F.A.I.L. ";
    else sRip = "R.I.P. ";

    SetName(oGrave, sRip + sName);
    SetLocalObject(GetModule(), "PC_GRAVE_" + sName, oGrave);
    SetLocalString(oGrave, "WHICH_GRAVE", "PC_GRAVE_" + sName);
    DelayCommand(IntToFloat(8 * nHD), AssignCommand(GetModule(), DestroyGrave(oGrave, sName)));
}
