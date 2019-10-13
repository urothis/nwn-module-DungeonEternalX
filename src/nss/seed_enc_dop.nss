#include "seed_enc_inc"
#include "pc_inc"

// CHANGED/FIXED BY EZRAMUN

void main()
{
    object oEncounter = OBJECT_SELF;

    if (GetLocalInt(oEncounter, "ENC_WAIT")) return;
    SetLocalInt(oEncounter, "ENC_WAIT", TRUE);

    int nEncDelay = GetLocalInt(oEncounter, "ENC_DELAY"); // SET IN TOOLSET
    if (!nEncDelay) nEncDelay = 90;

    AssignCommand(GetArea(oEncounter), DelayCommand(IntToFloat(nEncDelay), DeleteLocalInt(oEncounter, "ENC_WAIT")));

    object oEnteredBy = GetEnteringObject();
    object oMinion, oLocator, oItem, oObject;
    int i, j, k, nPartyCnt, nCount;
    itemproperty ipAdd;
    location lSpawn;
    effect eEffect;
    float l;
    string sRef;

    string sWhich = GetTag(oEncounter);
    if (sWhich == "DOT_BARREL_ENC")
    {
        oLocator = GetNearestObjectByTag("DOT_BARREL");
        oMinion = MakeCreature("dopkalfar",oLocator);
        HideWeapons(oMinion);
        AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0f, 900.0));
        oLocator = GetNearestObjectByTag("DOT_CRATE");
        oMinion = MakeCreature("dopkalfarwarrior",oLocator);
        HideWeapons(oMinion);
        AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0f, 900.0));
    }
    else if (sWhich=="DIF_MAIN_ENC")
    {
        if (d3() != 1) return;
        for (i = 0; i < 2; i++)
        {
            oLocator = GetNearestObjectByTag("DIF_MAGE_WP", oEncounter, i);
            oMinion = MakeCreature("dopkalfar",oLocator);
            AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0f, 900.0));
        }
        if (pcCountParty(oEnteredBy) > 1)
        {
            oLocator = GetNearestObjectByTag("DIF_WARRIOR_WP");
            oMinion = MakeCreature("dopkalfarcom",oLocator);
            AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 1.0f, 900.0));
            oLocator = GetNearestObjectByTag("DIF_BOSS_WP");
            oMinion = MakeCreature("dopkalfarwarrior",oLocator);
            AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0f, 900.0));
        }
    }
    else if (sWhich=="DIF_CUTTER_ENC")
    {
        oLocator = GetNearestObjectByTag("DIF_CUTTER_WP");
        nCount = 1;
        while (nCount <= nPartyCnt)
        {
            voidMakeCreature("frosttiger", oLocator, oEnteredBy);
            nCount++;
        }
    }
    else if (sWhich=="DOC_HOUND_ENC")
    {
        oLocator = GetNearestObjectByTag("DOC_ENC_WP", oEncounter);
        nPartyCnt = pcCountParty(oEnteredBy);
        nCount = 1;
        while (nCount <= nPartyCnt)
        {
            voidMakeCreature("arcticicehound", oLocator, oEnteredBy);
            nCount++;
        }
    }
    else if (sWhich=="DOC_CHEST_ENC")
    {
        oLocator = GetNearestObjectByTag("DOC_CHEST_WP", oEncounter);
        nPartyCnt = pcCountParty(oEnteredBy);
        nCount = 1;
        while (nCount <= nPartyCnt)
        {
            if (d3()==1) voidMakeCreature("dopkalfarminstre", oLocator, oEnteredBy);
            else voidMakeCreature("dopkalfarwar003", oLocator, oEnteredBy);
            voidMakeCreature("arcticicehound", oLocator, oEnteredBy);
            nCount++;
        }
    }
    else if (sWhich=="DOS_JAIL_ENC")
    {
        nPartyCnt = pcCountParty(oEnteredBy)+1;
        nCount = 1;
        oLocator = GetNearestObjectByTag("DOS_JAIL_WP", oEncounter, nCount);
        while(GetIsObjectValid(oLocator) && nCount <= nPartyCnt)
        {
            MakeCreature("dopkalfarwar003", oLocator);
            sWhich = PickOne("feyfemale","felinehunter001","felinehunter", "ancientbeetle");
            sWhich = PickOne(sWhich, "trog002","trog003","trog004", "svirfneblin002", "svirfneblin003");
            oMinion = MakeCreature(sWhich, oLocator);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR), oMinion, RoundsToSeconds(5));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oMinion, RoundsToSeconds(5));
            nCount++;
            oLocator = GetNearestObjectByTag("DOS_JAIL_WP", oEncounter, nCount);
        }
    }
    else if (GetStringLeft(sWhich,4)=="DOD_")
    {
        nPartyCnt = pcCountParty(oEnteredBy);
        nCount = 1;
        oLocator = GetNearestObjectByTag(sWhich+"_WP", oEncounter, nCount);
        while(GetIsObjectValid(oLocator) && nCount <= nPartyCnt)
        {
            if (d3() == 1) MakeCreature("dopkalfar002", oLocator);
            else if (d3() == 1) MakeCreature("dopkalfarminstre", oLocator);
            else MakeCreature("dopkalfarwar003", oLocator);
            nCount++;
            oLocator = GetNearestObjectByTag(sWhich+"_WP", oEncounter, nCount);
        }
    }
    else if (sWhich=="DTH_MAIN_ENC")
    {
        nPartyCnt = pcCountParty(oEnteredBy);
        nCount = 1;
        oLocator = GetNearestObjectByTag("DTH_BENCH", oEncounter, nCount);
        while(GetIsObjectValid(oLocator) && nCount <= nPartyCnt)
        {
            if (d3() == 1) oMinion = MakeCreature("dopkalfar002",oLocator);
            else if (d3() == 1) oMinion = MakeCreature("dopkalfarminstre",oLocator);
            else oMinion = MakeCreature("dopkalfarwar003",oLocator);
            HideWeapons(oMinion);
            AssignCommand(oMinion, ActionMoveToObject(oLocator));
            AssignCommand(oMinion, ActionSit(oLocator));
            nCount++;
            oLocator = GetNearestObjectByTag("DTH_BENCH", oEncounter, nCount);
        }
        nCount = 1;
        oLocator = GetNearestObjectByTag("DTH_CHAIR", oEncounter, nCount);
        while(GetIsObjectValid(oLocator) && nCount <= nPartyCnt+1)
        {
            if (d3() == 1) oMinion = MakeCreature("dopkalfar002",oLocator);
            else if (d3() == 1) oMinion = MakeCreature("dopkalfarminstre",oLocator);
            else oMinion = MakeCreature("dopkalfarwar003",oLocator);
            HideWeapons(oMinion);
            AssignCommand(oMinion, ActionMoveToObject(oLocator));
            AssignCommand(oMinion, ActionSit(oLocator));
            nCount++;
            oLocator = GetNearestObjectByTag("DTH_BENCH", oEncounter, nCount);
        }

        if (d3() != 1) return;
        MakeCreature("arcticicehound", GetNearestObjectByTag("DTH_TIGER_WP", oEncounter, 1));
        MakeCreature("arcticicehound", GetNearestObjectByTag("DTH_TIGER_WP", oEncounter, 2));
        oLocator = GetNearestObjectByTag("DTH_BOSS_WP");
        oMinion = SpawnBoss("lilith", oLocator);
        SetLocalInt(oMinion, "COUNT_PLAYER_SPAWNED", nPartyCnt);
        HideWeapons(oMinion);
        oLocator = GetNearestObjectByTag("DTH_THRONE");
        AssignCommand(oMinion, ActionMoveToObject(oLocator));
        AssignCommand(oMinion, ActionSit(oLocator));
    }
}
