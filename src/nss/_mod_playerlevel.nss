#include "gen_inc_color"
#include "db_inc"
#include "sfsubr_functs"
#include "inc_traininghall"
#include "fame_charvalue"

void main() {
    object oPC      = GetPCLevellingUp();
    int nLevel      = GetHitDice(oPC);
    int nXP         = GetXP(oPC);

    if ((GetHasFeat(FEAT_EPIC_GREAT_SMITING_3,oPC) && GetHasFeat(FEAT_SMITE_EVIL,oPC) && !GetHasFeat(FEAT_SMITE_GOOD,oPC)) ||
        (GetHasFeat(FEAT_EPIC_GREAT_SMITING_5,oPC) && GetHasFeat(FEAT_SMITE_GOOD,oPC)))
    {
        SetXP(oPC,(nLevel - 1) * (nLevel - 2) * 500);
        DelayCommand(0.0, SetXP (oPC,nLevel * (nLevel - 1) * 500)); // Up again
        FloatingTextStringOnCreature("You are not allowed to take any more greater smiting feats. Character re-leveled.", oPC, FALSE);
        return;
    }
    SetCVRating(oPC, ComputeCVRating(oPC)); // "ness_droppvploot"

    SF_SubraceOnLevelUp(oPC);
    //SDB_OnPCLevelUp(oPC);
    SetLocalInt (oPC, "i_TI_LastRest", 0);
    FloatingTextStringOnCreature(GetRGB(11,9,11) + GetName(oPC)+" has advanced to level "+ IntToString(nLevel), oPC);

    ExportSingleCharacter(oPC); //save them

/////////////////////////////////////////////////////////////////////////////////////////////
    // See file "inc_traininghall" for more informations
    if (GetIsTestChar(oPC)) return; // End this script if character is a testing hall char
/////////////////////////////////////////////////////////////////////////////////////////////

    int nHighestXP  = GetLocalInt(oPC, "HIGHEST_XP");
    int nTakenFirstTime = FALSE;

    if (nHighestXP < nXP) // to check if player was de-lvled
    {
        dbSaveHighestXP(oPC, nXP);
        nTakenFirstTime = TRUE;
    }
    string sPCKey = GetPCPublicCDKey(oPC, TRUE);

    if (nLevel == 40) // Reward PC with a training session
    {
        if (nTakenFirstTime)
        {
            // Cory - Disabled upon DM request (Broken, Bugged?)
            //int nSession = GetTrainingSessions(oPC, sPCKey);
            //SetTrainingSessions(oPC, sPCKey, nSession + 2);
            //DelayCommand(1.0, ActionFloatingTextStringOnCreature(GetRGB(11,9,11) + GetName(oPC) + " has gained 2 training session/s", oPC));
        }
    }

    if (nLevel > 19)
    {
        if (nTakenFirstTime)
        {
            // Make levelup VFX
            effect eVis1 = EffectVisualEffect(407);
            effect eVis2 = EffectVisualEffect(459);
            effect eVis3 = EffectVisualEffect(234);
            effect eVis4 = EffectVisualEffect(496);
            DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oPC));
            DelayCommand(0.7f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC));
            DelayCommand(0.9f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oPC));
            DelayCommand(1.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis4, oPC));
            int nModFame = GetRichModifier(60, 40, 20, SDB_GetFAID(oPC));
            float fFame = IntToFloat(nLevel)*FAME_PER_TAKEN_LEVEL;
            fFame += fFame / 100.0 * IntToFloat(nModFame);
            string sMsg = GetRGB(11,9,11) + GetName(oPC)+" has advanced to level "+IntToString(nLevel) + " and earned " + FloatToString(fFame, 0, 2) + " Fame";
            if (nLevel == 20 || nLevel == 25 || nLevel == 30)
            {
                ShoutMsg(sMsg);
                IncFameOnChar(oPC, fFame);
                DelayCommand(0.1, StoreFameOnDB(oPC, SDB_GetFAID(oPC))); // "fame_inc"
            }
            else if (nLevel == 32 || nLevel == 34 || nLevel == 36)
            {
                ShoutMsg(sMsg);
                IncFameOnChar(oPC, fFame);
                DelayCommand(0.1, StoreFameOnDB(oPC, SDB_GetFAID(oPC))); // "fame_inc"
            }
            else if (nLevel == 38 || nLevel == 39 || nLevel == 40)
            {
                ShoutMsg(sMsg);
                IncFameOnChar(oPC, fFame);
                DelayCommand(0.1, StoreFameOnDB(oPC, SDB_GetFAID(oPC))); // "fame_inc"
            }
        }
    }
}
