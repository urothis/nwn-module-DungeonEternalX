#include "seed_pick_stone"
#include "x2_inc_itemprop"
#include "arres_inc"
#include "_functions"
#include "seed_faction_inc"
#include "fame_inc"
#include "quest_inc"
#include "tradeskills_inc"
#include "dmg_stones_inc"
#include "db_inc"
#include "epic_inc"

void LongswordExploitAcquire(object oItem, object oPC)
{
    if (GetTag(oItem) != "NW_WSWLS001") return;
    dbLogMsg(GetName(oPC)+" "+GetPCPublicCDKey(oPC, TRUE)+" acquired illegal Longsword","EXPLOIT",dbGetTRUEID(oPC),dbGetDEXID(oPC),dbGetLIID(oPC),dbGetPLID(oPC));
}

void main()
{
    object oAquirer = GetModuleItemAcquiredBy();
    if (!GetIsPC(oAquirer)) return;

    object oItem    = GetModuleItemAcquired();
    string sTag     = GetTag(oItem);
    string sName    = GetName(oItem);

    LongswordExploitAcquire(oItem, oAquirer);

    // shifter fix from bioware forums
    // http://nwn.bioware.com/forums/viewtopic.html?topic=308039&forum=56&highlight=shifter+crash
    if (sTag == "PALETTE"          ||
        sTag == "NW_WSWMLS013"     ||
        sTag == "X2_IT_CREWMAZERA" ||
        sTag == "X2_IT_CREWPWH001" ||
        sTag == "x2_it_wplmss011"  ||
        sTag == "x2_it_wplmss012"  ||
        sTag == "X2_WDROWLS002"    ||
        sTag == "X2_IT_CREWPKOBS2" ||
        sTag == "X2_IT_CREWPKOBSW" ||
        sTag == "x2_it_crewprakxb" ||
        sTag == "x2_it_rakstaff"   ||
        sTag == "x2_it_crewpvscyt" )
    {
        Insured_Destroy_Delay(oItem, 0.3);
        return;
    }
    else if (GetStringLeft(GetName(oItem),4)=="Epic")
    {
        EI_UpdateTRUEIDonWeapon(oAquirer,oItem);
        NWNX_SQL_ExecuteQuery("select plid from epic_item where eiid="+IntToString(EI_GetEIID(oItem)));
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            if (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)) != dbGetPLID(oAquirer))
            {
                SetCutsceneMode(oAquirer);
                ActionPutDownItem(oItem);
                ActionFloatingTextStringOnCreature("That item is not bound to you.",oAquirer);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectVisualEffect(VFX_FNF_STORM),oAquirer);
                DelayCommand(5.0f,SetCutsceneMode(oAquirer,FALSE));
            }
        }
    }
    else if (sTag == "ITEM_ONACQUIRE")
    {
        string sType = GetLocalString(oItem, "ACQUIRE_TYPE");
        if (sType == "fame")
        {
            Q_UpdateQuest(oAquirer, "9");
            effect eHeal = EffectHeal(1000);
            effect eVFX = EffectVisualEffect(VFX_IMP_HEALING_X);
            IncFameOnChar(oAquirer, 3.0 + IntToFloat(d3()));
            DelayCommand(0.1, StoreFameOnDB(oAquirer, SDB_GetFAID(oAquirer)));
            DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oAquirer));
            DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oAquirer));
        }
        /*else if (sType == "xmas") // xmas/easter special
        {
            if (Q_GetHasQuest(oAquirer, "1001", FALSE))
            {
                DelayCommand(0.1, AssignCommand(oAquirer, PlaySound("as_cv_bell1")));
                DelayCommand(0.5, AssignCommand(oAquirer, PlaySound("as_cv_claybreak2")));
                DelayCommand(1.0, AssignCommand(oAquirer, PlaySound("as_an_koboldwee")));
                DelayCommand(2.0, Q_UpdateQuest(oAquirer, "1001"));
            }
        }*/
        else if (sType == "tradeskills")
        {
            string sSkill = PickOne("ts_melting", "ts_milling", "ts_brewing", "ts_alchemy", "ts_farming");
            int nAmount = TS_GetLevel(TS_GetSkillPoints(TS_GetVariableHolder(), IntToString(dbGetTRUEID(oAquirer)), sSkill));
            TS_IncreaseSkill(oAquirer, nAmount, sSkill);
            FloatingTextStringOnCreature(GetRGB(11,9,11) + GetName(oAquirer) + " has gained " + IntToString(nAmount) + " " + TS_GetSkillName(sSkill) + " points.", oAquirer);
            AssignCommand(oAquirer, PlaySound("gui_learnspell"));
        }
        Insured_Destroy_Delay(oItem, 0.3);
    }
    // else AssignCommand(oAquirer, DelayCommand(0.1, IPRemoveAllItemProperties(oItem, DURATION_TYPE_TEMPORARY)));

    //doesn't work. deletes everyone's items. change the if statement.
    /*else if (FindSubString(sTag, "DMGS"))
    {
        if (DMGS_UpdateStoneDB(oItem, oAquirer)==TRUE)
            SendMessageToPC(oAquirer, "Damage Stone verification successful.");
        else
            SendMessageToPC(oAquirer, "Damage Stone verification failed. Database could be down or the name on your character is too fucked up.");
    } */
}

