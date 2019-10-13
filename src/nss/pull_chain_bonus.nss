#include "inc_draw"
#include "gen_inc_color"
#include "chainwonder_inc"
#include "random_loot_inc"
#include "inc_traininghall"
#include "pc_inc"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "USED")) return;
    SetLocalInt(OBJECT_SELF, "USED", 1);
    object oMod = GetModule();
    object oPC = GetLastUsedBy();
    object oPartyMember = GetFirstFactionMember(oPC, FALSE);
    location lChain = GetLocation(OBJECT_SELF);
    DrawCircle(DURATION_TYPE_TEMPORARY, VFX_IMP_TORNADO, lChain, 10.0, 0.1, 20, 1.0, 0.0f);
    int nLvl;   int nGiveXP;
    if (GetLocalInt(oMod, "CHAIN_OF_WONDER_ACTIVE"))
    {
        int nValue = 10000 + IncLocalInt(oMod, "CHAIN_OF_WONDER_VALUE", -10000);
        string sWinnerList = GetLocalString(oMod, "CHAIN_WINNER_LIST");

        string sPCName = GetPCPlayerName(oPC);
        if (!GetIsTokenInString(sPCName, sWinnerList, ", "))
        {
            sWinnerList = AddTokenToString(sPCName, sWinnerList, ", ");
            SetLocalString(oMod, "CHAIN_WINNER_LIST", sWinnerList);
        }

        if (nValue < 10000)
        {
            DeleteLocalInt(oMod, "CHAIN_OF_WONDER_ACTIVE");
            DeleteLocalInt(oMod, "CHAIN_OF_WONDER_VALUE");
            DeleteLocalString(oMod, "CHAIN_WINNER_LIST");
            object oSnrible = GetObjectByTag("snirble_gemgrip");
            AssignCommand(oSnrible, SpeakString("Super Chain of Wonder has been deactivated, congratulations to: " + GetRGB(15,5,1) + sWinnerList, TALKVOLUME_SHOUT));
            ChainWonderSave();
        }
        else
        {
            int nRemain = nValue / 10000;
            if ((nRemain % 4) == 0)
            {
                ChainWonderSave();
                object oSnrible = GetObjectByTag("snirble_gemgrip");
                AssignCommand(oSnrible, SpeakString("Super Chain of Wonder " + IntToString(nRemain) + " uses left! Congratulations to: " + GetRGB(15,5,1) + sWinnerList, TALKVOLUME_SHOUT));
            }
        }
        CreateTrainingToken(oPC);
    }

    while (GetIsObjectValid(oPartyMember))
    {
        if (GetArea(oPC) == GetArea(oPartyMember) && GetCurrentHitPoints(oPartyMember) > 0 && GetDistanceBetween(OBJECT_SELF, oPartyMember) < 10.0)
        {
            if (GetIsPC(oPartyMember))
            {
                nLvl = pcGetRealLevel(oPC);
                nGiveXP = 4000/nLvl;
                if (nGiveXP > 200) nGiveXP = 200;
                nGiveXP += 50 * nLvl;
                GiveXPToCreature(oPartyMember, nGiveXP);
                FloatingTextStringOnCreature("+" + IntToString(nGiveXP)+"xp", oPartyMember, FALSE);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_YELLOW_BLACK), oPartyMember, 6.0);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPartyMember);
            }
        }
        oPartyMember = GetNextFactionMember(oPC, FALSE);
    }
    CopyItem(LootGetItemByTag("POT_FLAMING_BRAZIER"), oPC, TRUE);
    effect eTrip = EffectKnockdown();
    AssignCommand(oPC, ClearAllActions());
    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oPC, 6.0));
    AssignCommand(oMod, DelayCommand(60.0, CreateChain(lChain)));
    DelayCommand(0.5, DestroyObject(OBJECT_SELF));
}
