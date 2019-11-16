#include "random_loot_inc"
#include "x0_i0_position"
#include "quest_inc"

void DoDynamicBuff(object oCreature, object oArea);

int CountEncounter(object oArea, location lLoc)
{
    int nCnt = GetLocalInt(oArea, "ENCOUNTER");
    if (nCnt) return nCnt;

    nCnt = 1;
    object oEncounter = GetNearestObjectToLocation(OBJECT_TYPE_ENCOUNTER, lLoc, nCnt);
    while (GetIsObjectValid(oEncounter))
    {
        nCnt++;
        oEncounter = GetNearestObjectToLocation(OBJECT_TYPE_ENCOUNTER, lLoc, nCnt);
    }
    SetLocalInt(oArea, "ENCOUNTER", nCnt - 1);
    return nCnt - 1;
}

void DoDynamicBuff(object oCreature, object oArea)
{
    int nPartyCnt = GetLocalInt(oArea, "PARTY_CNT");
    if (nPartyCnt < 2) return;
    int nMod = (nPartyCnt - 1) * 2; // +2 for each player, starting at 2nd player
    effect eEffect = EffectAbilityIncrease(ABILITY_CONSTITUTION, nMod);
    // constitution increased, keep fort save same by decreasing it
    eEffect = EffectLinkEffects(eEffect, EffectSavingThrowDecrease(SAVING_THROW_FORT, nMod/2));
    eEffect = ExtraordinaryEffect(eEffect);
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oCreature));
}

void SpawnChampion(object oKiller, object oCreature, int nPartyCnt)
{
    if (!GetIsObjectValid(oCreature) || !GetIsObjectValid(oKiller)) return;
    object oArea = GetArea(oKiller);
    if (!GetIsObjectValid(oArea)) return;
    if (!GetHasTimePassed(oArea, 15, "CHAMPION")) return;
    if (GetStringLeft(GetTag(oCreature), 5) == "UDELF") return;

    oCreature = CreateObject(OBJECT_TYPE_CREATURE, GetResRef(oCreature), GetLocation(oCreature), TRUE);
    SetName(oCreature, GetName(oCreature) + " (Champion)");
    SetLocalString(oCreature, "ONDEATH_EVENT", "CHAMPION");
    SetLocalInt(oCreature, "XP_BONUS", 5);
    int nMaxHP = GetMaxHitPoints(oCreature);
    int nHP = nMaxHP * (1 + nPartyCnt * 2);
    if (nHP + nMaxHP > 28000) nHP = 28000 - nMaxHP; // some cap will bug the game if HP > 30000
    effect eHP = EffectTemporaryHitpoints(nHP);
    effect eEffect = EffectAbilityIncrease(ABILITY_STRENGTH, 12);
    eEffect = EffectLinkEffects(eEffect, EffectAttackIncrease(7 + nPartyCnt));
    eEffect = EffectLinkEffects(eEffect, EffectHaste());
    eEffect = EffectLinkEffects(eEffect, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
    eEffect = EffectLinkEffects(eEffect, EffectTrueSeeing());
    eEffect = EffectLinkEffects(eEffect, EffectDamageIncrease(DAMAGE_BONUS_2d12, DAMAGE_TYPE_POSITIVE));
    eEffect = EffectLinkEffects(eEffect, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
    eEffect = EffectLinkEffects(eEffect, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
    eEffect = EffectLinkEffects(eEffect, EffectImmunity(IMMUNITY_TYPE_DEATH));
    eEffect = EffectLinkEffects(eEffect, EffectSkillIncrease(SKILL_CONCENTRATION, 50));
    eEffect = EffectLinkEffects(eEffect, EffectSkillIncrease(SKILL_DISCIPLINE, 50));
    eEffect = EffectLinkEffects(eEffect, EffectSavingThrowIncrease(SAVING_THROW_ALL, 20));
    eEffect = ExtraordinaryEffect(eEffect);
    eHP = ExtraordinaryEffect(eHP);
    AssignCommand(oCreature, DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_STONEHOLD), oCreature, 2.0)));
    AssignCommand(oCreature, DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHP, oCreature)));
    AssignCommand(oCreature, DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oCreature)));
    AssignCommand(oCreature, DelayCommand(1.0, SetAILevel(oCreature, AI_LEVEL_NORMAL)));
    AssignCommand(oCreature, DelayCommand(300.0, Despawn(oCreature)));
}

void DoExtraSpawn(string sResRef, location lLoc, object oArea)
{
    if (GetIsObjectValid(GetLocalObject(oArea, "SCOUT"))) return; // check if one spawn active at a time
    int nEncounter = CountEncounter(oArea, lLoc);
    if (!nEncounter) return;

    object oEncounter = GetNearestObjectToLocation(OBJECT_TYPE_ENCOUNTER, lLoc, Random(nEncounter) + 1);
    lLoc = GetLocation(oEncounter);

    object oPC = GetNearestCreatureToLocation(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lLoc);
    if (!GetIsObjectValid(oPC)) return;

    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLoc);
    SetLocalObject(oArea, "SCOUT", oCreature); // to check if one spawn active at a time
    effect eEffect = EffectSeeInvisible();
    eEffect = ExtraordinaryEffect(eEffect);
    DoDynamicBuff(oCreature, oArea);
    string sName = GetName(oCreature);
    SetName(oCreature, sName + " (Scout)");
    SetLocalString(oCreature, "ONDEATH_EVENT", "SCOUT");
    DelayCommand(90.0, Despawn(oCreature));
    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oCreature));
    DelayCommand(3.0, AssignCommand(oCreature, ActionForceMoveToObject(oPC, TRUE, 3.0)));
}

void TriggerExtraSpawn(object oCreature, string sResRef, location lLoc, object oArea)
{
    if (!GetIsObjectValid(oCreature)) DoExtraSpawn(sResRef, lLoc, oArea); // if creature not gone, stop here. leveling to slow for some reason
}

// how fast does creature die?
void CheckExtraSpawnSpeed(object oCreature, string sResRef, location lLoc, object oArea)
{
    if (!GetIsObjectValid(oCreature))
    {   // creature gone very fast, stop here. leveling to fast
        if (d6() != 1) return;
    }
    DelayCommand(18.0, TriggerExtraSpawn(oCreature, sResRef, lLoc, oArea));
}

// spawn an extra mob
void CheckExtraSpawn(object oCreature)
{
    object oArea = GetArea(oCreature);
    if (GetIsObjectValid(GetLocalObject(oArea, "SCOUT"))) return; // check if one spawn active at a time
    location lLoc = GetLocation(oCreature);
    string sResRef = GetResRef(oCreature);
    if (sResRef == "undeadelf")
    {
        if (d10() == 1) AssignCommand(oArea, DelayCommand(30.0, DoExtraSpawn(sResRef, lLoc, oArea)));
        return;
    }
    AssignCommand(oArea, DelayCommand(24.0, CheckExtraSpawnSpeed(oCreature, sResRef, lLoc, oArea)));
}

void DoAmbush(object oKiller, string sResRef, int nPartyCnt)
{
    if (!GetIsObjectValid(oKiller)) return;
    object oArea = GetArea(oKiller);
    if (!GetIsObjectValid(oArea)) return;
    if (!GetHasTimePassed(oArea, 15, "AMBUSH")) return;

    location lCenter = GetLocation(oKiller);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), lCenter);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_WEB_MASS), lCenter, 12.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oKiller, 3.0);
    int i;  vector vPos;  location lPos;  float x, y, f, fAngle, fDelay;
    vector vCenter = GetPositionFromLocation(lCenter);
    nPartyCnt += d2();
    if (nPartyCnt > 6) nPartyCnt = 6;
    float fDest = IntToFloat(nPartyCnt)/3.0;
    for (i=0; i < nPartyCnt; i++)
    {
        fDelay += 0.1;
        f = IntToFloat(i);
        fAngle = IntToFloat(360/nPartyCnt) * f;
        y = fDest * sin(fAngle);
        x = fDest * cos(fAngle);
        vPos = vCenter + Vector(x, y);
        lPos = Location(oArea, vPos, fAngle);
        DelayCommand(fDelay, ActionCreateObject(OBJECT_TYPE_CREATURE, sResRef, lPos, TRUE, "", 2, 60));
    }
}

void DoNadia(object oKiller)
{
    if (!GetIsObjectValid(oKiller)) return;
    if (d3(1)==1) return; //I upped the spawn rate of champs and such by 8%, and now I am reducing it by 33%
    object oArea = GetArea(oKiller);
    if (!GetIsObjectValid(oArea)) return;
    if (!GetHasTimePassed(oArea, 15, "NADIA")) return;
    object oNadia = CreateObject(OBJECT_TYPE_CREATURE, "healing_nadia", GetBehindLocation(oKiller), FALSE, "HEALING_NADIA");
    SetLocalObject(oNadia, "MASTER", oKiller);
    SetLocalObject(oNadia, "AREA", oArea);
}

int DoNekrosShadow(object oKiller, object oDead)
{
    if (!GetIsEncounterCreature(oDead)) return FALSE;
    if (d4() != 4) return FALSE;
    if (!GetIsObjectValid(oKiller)) return FALSE;
    object oArea = GetArea(oKiller);
    if (!GetIsObjectValid(oArea)) return FALSE;
    if (!GetHasTimePassed(oArea, 3, "NEKROS_SHADOW")) return FALSE; // 6 minutes
    location lLoc = GetBehindLocation(oKiller);
    AssignCommand(oKiller, DelayCommand(2.0, ActionCreateObject(OBJECT_TYPE_CREATURE, "nekros_shadow", lLoc, FALSE, "NEKROS_SHADOW", 3)));
    return TRUE;
}

void DoRandomEvent(int nCRDiff, int nMaxLevel, int nPartyCnt, int nCR, object oDead, object oKiller)
{
    string sEvent = GetLocalString(oDead, "ONDEATH_EVENT");
    if (sEvent != "")
    {
        if (sEvent == "CHAMPION")
        {
            AssignCommand(oKiller, DelayCommand(1.0, ActionLootCreateBossbag(oDead, "CHAMPION")));
            Q_UpdateQuest(oKiller, "2");
            return;
        }
        else if (sEvent == "NEKROS_SHADOW")
        {
            if (DoNekrosShadow(oKiller, oDead)) return;
        }
        else if (sEvent == "SCOUT") Q_UpdateQuest(oKiller, "1");
    }

    if (GetIsEncounterCreature(oDead))
    {
        int nRandom = Random(100) + 1;
        if (nRandom >= 75)
        {
            AssignCommand(oKiller, DelayCommand(0.5, LootCreateLootbag(oDead, nCR)));
        }
        else if (nRandom <= 3)
        {
            if (nCR >= 20)
            {
                if (d2() == 1) AssignCommand(oKiller, DelayCommand(1.0, SpawnChampion(oKiller, oDead, nPartyCnt)));
            }
            else DoNadia(oKiller);
        }
        else if (nRandom > 3 && nRandom < 7)
        {
            if (nCR >= 20)
            {
                if (nPartyCnt > 1)
                {
                    string sResRef = GetResRef(oDead);
                    AssignCommand(oKiller, DelayCommand(12.0, DoAmbush(oKiller, sResRef, nPartyCnt)));
                }
                else DoNadia(oKiller);
            }
            else DoNadia(oKiller);
        }
    }
}

//void main(){}
