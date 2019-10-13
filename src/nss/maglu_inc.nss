#include "db_inc"
#include "_functions"

void MagluSpawnStatue(object oWP, int nValue, object oArea)
{
    if (!GetIsObjectValid(oArea) || !GetIsObjectValid(oWP)) return;

    location lCenter = GetLocation(oWP);
    object oStatue = CreateObject(OBJECT_TYPE_PLACEABLE, "maglubiyet_statu", lCenter, FALSE, "MAGLUBIYET_STATUE");
    SetLocalInt(oStatue, "CALL", nValue);
    int i;  vector vPos;    location lPos;  float x, y, f, fAngle;
    vector vCenter = GetPositionFromLocation(lCenter);
    for (i=0; i < 6; i++)
    {
        f = IntToFloat(i);
        fAngle = 60.0*f;
        y = 4.0*sin(fAngle);
        x = 4.0*cos(fAngle);
        vPos = vCenter + Vector(x, y);
        lPos = Location(oArea, vPos, fAngle);
        SetLocalLocation(oStatue, IntToString(i) + "ANGLE", lPos);
        if (i == 0 || i == 3) CreateObject(OBJECT_TYPE_PLACEABLE, "maglubiyet_stone", lPos, FALSE, IntToString(i) + "ANGLE");
    }
}

object MagluGetNewWP()
{
    int nAmountWPs = GetLocalInt(GetModule(), "WP_MAGLUBIYET");
    NWNX_SQL_ExecuteQuery("delete from pwdata where name='MAGLUBIYET'");
    object oWP = GetObjectByTag("WP_MAGLUBIYET", Random(nAmountWPs));
    object oArea = GetArea(oWP);
    string sTag = GetTag(oArea);

    if (!GetIsObjectValid(oArea) || !GetIsObjectValid(oWP)) return OBJECT_INVALID;
    //DelayCommand(1.0, NWNX_SQL_ExecuteQuery("insert into pwdata (player,tag,name,val,expire) values ('~','" + sTag + "','MAGLUBIYET','1',3)"));
    NWNX_SQL_ExecuteQuery("insert into pwdata (player,tag,name,val,expire) values ('~','" + sTag + "','MAGLUBIYET','1',3)");
    return oWP;
}

void DestroyRunes(object oStatue)
{
    if (!GetIsObjectValid(oStatue)) return;

    effect eVis = EffectVisualEffect(VFX_IMP_HARM);
    float fDelay;
    location lPos;
    int nCnt = 0;
    object oRune = GetNearestObjectByTag(IntToString(nCnt) + "ANGLE", oStatue);
    while (nCnt < 6)
    {
        if (GetIsObjectValid(oRune)) DestroyObject(oRune);
        fDelay = IntToFloat(nCnt)/3.0;
        lPos = GetLocalLocation(oStatue, IntToString(nCnt) + "ANGLE");
        DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lPos));
        DelayCommand(fDelay, ActionCreateObject(OBJECT_TYPE_CREATURE, "hobgoblin_40", lPos, FALSE, "BOSS_HOBGOBLIN", 4));
        nCnt++;
        oRune = GetNearestObjectByTag(IntToString(nCnt) + "ANGLE", oStatue);
    }
    DestroyObject(oStatue);
    object oStonehead = GetObjectByTag("STONEHEAD");
    AssignCommand(oStonehead, SpeakString("Noooo! Stop touching my statue!", TALKVOLUME_SHOUT));
    object oWP = MagluGetNewWP();
    DelayCommand(900.0, MagluSpawnStatue(oWP, 1, GetArea(oWP)));
}

void MagluLoadWP()
{
    int nCnt = 0;
    object oWP = GetObjectByTag("WP_MAGLUBIYET", nCnt);
    while (GetIsObjectValid(oWP))
    {
        nCnt++;
        oWP = GetObjectByTag("WP_MAGLUBIYET", nCnt);
    }
    SetLocalInt(GetModule(), "WP_MAGLUBIYET", nCnt);

    oWP = OBJECT_INVALID;
    object oArea;   int nValue = 1;
    NWNX_SQL_ExecuteQuery("select tag, val from pwdata where name='MAGLUBIYET'");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        oArea = GetObjectByTag(NWNX_SQL_ReadDataInActiveRow(0));
        nValue = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
        oWP = GetFirstObjectInArea(oArea);
        if (GetTag(oWP) != "WP_MAGLUBIYET") oWP = GetNearestObjectByTag("WP_MAGLUBIYET", oWP);
    }
    if (!GetIsObjectValid(oWP)) oWP = MagluGetNewWP();

    MagluSpawnStatue(oWP, nValue, oArea);
}

//void main(){}
