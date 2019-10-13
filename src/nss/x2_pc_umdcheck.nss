//------------------------------------------------------------------------------
//
// Use Magic Device Check.
//
//------------------------------------------------------------------------------

#include "x2_inc_switches"
#include "x2_inc_itemprop"

// nType 1 = UMD, 2 = Arcane, 3 = Divine
int DoScrollCheck(object oCaster, int nRanks, int nInnate, int nType)
{
    string sRank;
    int nRank;
    int nDC;
    if (nType == 1)
    {
        nDC = nInnate * 11;
        sRank = "Use Magical Device ";
    }
    else if (nType == 2)
    {
        nDC = nInnate * 4;
        sRank = "Innate (Arcane) ";
    }
    else if (nType == 3)
    {
        nDC = nInnate * 2;
        sRank = "Innate (Divine) ";
    }
    else
    {
        SendMessageToPC(oCaster, "Scroll Usage: SCRIPT ERROR");
        return FALSE;
    }
    int nRoll = !GetIsInCombat(oCaster) ? 20 : d20();

    string sMessage = sRank + IntToString(nRanks) + " + " + IntToString(nRoll) + " vs DC" + IntToString(nDC);
    if (nRanks + nRoll >= nDC)
    {
        SendMessageToPC(oCaster, sMessage + ": Success!");
        return TRUE;
    }

    SendMessageToPC(oCaster, sMessage + ": Failure!");
    return FALSE;
}

int X2_UMD()
{
    object oItem = GetSpellCastItem();
    if (!GetIsObjectValid(oItem)) return TRUE; // Spell not cast by item, UMD not required

    int nBase = GetBaseItemType(oItem);
    if (nBase != BASE_ITEM_SPELLSCROLL) return TRUE; // spell not cast from a scroll

    if (!IPGetHasUseLimitation(oItem)) return TRUE; // Ignore scrolls that have no use limitations (i.e. raise dead)

    object oCaster = OBJECT_SELF;
    int nSpellID = GetSpellId();

    int nInnate = StringToInt(Get2DAString("des_crft_spells", "Level", nSpellID));

    int nUMDRanks = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oCaster);
    if (nUMDRanks > 0) // First do UMD check if got ranks
    {
        nUMDRanks += GetLevelByClass(CLASS_TYPE_ROGUE, oCaster);
        nUMDRanks += GetLevelByClass(CLASS_TYPE_BARD, oCaster);
        nUMDRanks += GetLevelByClass(CLASS_TYPE_ASSASSIN, oCaster);
        if (DoScrollCheck(oCaster, nUMDRanks, nInnate, 1)) return TRUE;
    }

    // UMD failed or got no Ranks, try Arcane innate
    int nArcaneRanks = GetLevelByClass(CLASS_TYPE_WIZARD,oCaster);
    nArcaneRanks += GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
    if (GetLevelByClass(CLASS_TYPE_BARD, oCaster)) nArcaneRanks += 1; // add 1 Bard
    int nPm = GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster);
    // All classes halfed if 10 or more PM
    nArcaneRanks = (nPm >= 10) ? (nArcaneRanks + nPm)/2 : nArcaneRanks + nPm;


    if (nArcaneRanks) // Try Arcane innate if got ranks
    {
        if (DoScrollCheck(oCaster, nArcaneRanks, nInnate, 2)) return TRUE;
    }

    if (!nArcaneRanks && nUMDRanks < 1) // Got no arcane class and no UMD, Divine Innate allowed
    {
        int nDivineRanks = GetLevelByClass(CLASS_TYPE_DRUID,oCaster);
        nDivineRanks += GetLevelByClass(CLASS_TYPE_RANGER, oCaster);
        nDivineRanks += GetLevelByClass(CLASS_TYPE_PALADIN, oCaster);
        nDivineRanks += GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);
        if (nDivineRanks) // Try Divine innate if got ranks
        {
            nDivineRanks = nDivineRanks / 2 + 1;
            if (DoScrollCheck(oCaster, nDivineRanks, nInnate, 3)) return TRUE;
        }
        else SendMessageToPC(oCaster, "Scroll Usage: SCRIPT ERROR"); // got no UMD, Arcane and Divine classes, something wrong here
    }

    effect ePuff = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, ePuff, oCaster);
    return FALSE;
}

void main()
{
    //--------------------------------------------------------------------------
    // Reset
    //--------------------------------------------------------------------------
    if (GetLocalInt(GetModule(),"X2_L_STOP_EXPERTISE_ABUSE") == TRUE)
    {
         SetActionMode(OBJECT_SELF,ACTION_MODE_EXPERTISE,FALSE);
         SetActionMode(OBJECT_SELF,ACTION_MODE_IMPROVED_EXPERTISE,FALSE);
    }

    //--------------------------------------------------------------------------
    // Do use magic device check
    //--------------------------------------------------------------------------
    int nRet = X2_UMD();
    SetExecutedScriptReturnValue(nRet);
}
