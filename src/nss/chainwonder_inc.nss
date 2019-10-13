#include "_functions"
#include "inc_tokenizer"
#include "db_inc"

void ChainWonderLoad()
{
    NWNX_SQL_ExecuteQuery("select val from pwdata where name='CHAIN_WONDER'");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        object oMod = GetModule();
        int nValue = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        if (nValue > 90000) nValue = 90000;
        SetLocalInt(oMod, "CHAIN_OF_WONDER_VALUE", nValue);
    }
    else
    {
        NWNX_SQL_ExecuteQuery("insert into pwdata (player,tag,name,val,expire) values ('~','CHAIN_WONDER','CHAIN_WONDER','0',0)");
    }
}

void ChainWonderSave()
{
    int nValue = GetLocalInt(GetModule(), "CHAIN_OF_WONDER_VALUE");
    NWNX_SQL_ExecuteQuery("update pwdata set val='" + IntToString(nValue) + "' where name='CHAIN_WONDER'");
}

void IncChainOfWonder(int nValue)
{
    object oMod = GetModule();
    if (GetLocalInt(oMod, "CHAIN_OF_WONDER_ACTIVE")) return;

    if (nValue > 1000000) nValue = 1000000;
    nValue = nValue/300;
    int nWorth = IncLocalInt(oMod, "CHAIN_OF_WONDER_VALUE", nValue);
    int nNotify = GetLocalInt(oMod, "CHAIN_OF_WONDER_NOTIFY");
    if (nWorth > 90000 + (nNotify * 5000)) // notify at 110k and after each 5k
    {
        nNotify++;
        object oSnirble = GetObjectByTag("snirble_gemgrip");
        if (nNotify < 3)
        {
            AssignCommand(oSnirble, SpeakString(GetCountString(nNotify) + " notify! Super Chain of Wonder will be activated after the third notify. Loot more Gems!", TALKVOLUME_SHOUT));
            SetLocalInt(oMod, "CHAIN_OF_WONDER_NOTIFY", nNotify);
        }
        else
        {
            AssignCommand(oSnirble, SpeakString(GetCountString(nNotify) + " notify! Super Chain of Wonder activated.", TALKVOLUME_SHOUT));
            if (GetLocalInt(oMod, "SERVER_TIME_LEFT") < 60)
            {
                AssignCommand(oSnirble, SpeakString("Server timer increased to 60 minutes", TALKVOLUME_SHOUT));
                SetLocalInt(oMod, "SERVER_TIME_LEFT", 60);
            }
            SetLocalInt(oMod, "CHAIN_OF_WONDER_ACTIVE", TRUE);
            DeleteLocalInt(oMod, "CHAIN_OF_WONDER_NOTIFY");
        }
    }
}

void CreateChain(location lChain)
{
    object oChain = GetObjectByTag("BC_XP_CHAIN");
    if (oChain!=OBJECT_INVALID) return;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);
    effect eTrip = EffectKnockdown();
    oChain = CreateObject(OBJECT_TYPE_PLACEABLE, "bc_xp_chain", lChain);
    object oTarget = GetObjectByTag("BC_PILLAR_TARGET");
    location lTarget = GetLocation(oTarget);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY), lTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, RoundsToSeconds(d3()));
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 8.0, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        AssignCommand(oTarget, ClearAllActions());
        fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oTarget, 6.0));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 8.0, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}

//void main(){}
