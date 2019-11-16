// Dispel Magic/Breach Override
// roll D20 + nPureLevel Against 15 + Target Arcane Level

const int BREACH_SPELL_COUNT_MORDS = 26;
const int BREACH_SPELL_COUNT_GREATER = 23;
const int BREACH_SPELL_COUNT_LESSER = 16;

#include "inc_tokenizer"
#include "x0_i0_spells"
#include "inc_castrlvl"
#include "pure_caster_inc"
#include "arres_inc"

int GetSchool(string sSchool)
{
    if (sSchool=="A") return SPELL_SCHOOL_ABJURATION;   if (sSchool=="C") return SPELL_SCHOOL_CONJURATION  ;
    if (sSchool=="D") return SPELL_SCHOOL_DIVINATION;   if (sSchool=="E") return SPELL_SCHOOL_ENCHANTMENT  ;
    if (sSchool=="V") return SPELL_SCHOOL_EVOCATION ;   if (sSchool=="I") return SPELL_SCHOOL_ILLUSION     ;
    if (sSchool=="N") return SPELL_SCHOOL_NECROMANCY;   if (sSchool=="T") return SPELL_SCHOOL_TRANSMUTATION;
    return SPELL_SCHOOL_GENERAL;
}

int AltGetSpellBreachProtectionMords(int nLastChecked)
{
    if      (nLastChecked== 0) return SPELL_GREATER_SPELL_MANTLE;
    else if (nLastChecked== 1) return SPELL_SPELL_MANTLE;
    else if (nLastChecked== 2) return SPELL_LESSER_SPELL_MANTLE;
    else if (nLastChecked== 3) return SPELL_MIND_BLANK;
    else if (nLastChecked== 4) return SPELL_LESSER_MIND_BLANK;
    else if (nLastChecked== 5) return SPELL_NEGATIVE_ENERGY_PROTECTION;
    else if (nLastChecked== 6) return SPELL_SHADOW_SHIELD;
    else if (nLastChecked== 7) return SPELL_GLOBE_OF_INVULNERABILITY;
    else if (nLastChecked== 8) return SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
    else if (nLastChecked== 9) return SPELL_ETHEREAL_VISAGE;
    else if (nLastChecked==10) return SPELL_ELEMENTAL_SHIELD;
    else if (nLastChecked==11) return SPELL_GHOSTLY_VISAGE;
    else if (nLastChecked==12) return SPELL_DEATH_ARMOR;
    else if (nLastChecked==13) return SPELL_MESTILS_ACID_SHEATH;
    else if (nLastChecked==14) return SPELL_SHIELD_OF_FAITH;
    else if (nLastChecked==15) return SPELL_MAGE_ARMOR;
    else if (nLastChecked==16) return SPELL_PREMONITION;
    else if (nLastChecked==17) return SPELL_GREATER_STONESKIN;
    else if (nLastChecked==18) return SPELL_STONESKIN;
    else if (nLastChecked==19) return SPELL_ENERGY_BUFFER;
    else if (nLastChecked==20) return SPELL_ENDURE_ELEMENTS;
    else if (nLastChecked==21) return SPELL_PROTECTION_FROM_ELEMENTS;
    else if (nLastChecked==22) return SPELL_RESIST_ELEMENTS;
    else if (nLastChecked==23) return SPELL_SPELL_RESISTANCE;
    else if (nLastChecked==24) return SPELL_CLARITY;
    else if (nLastChecked==25) return SPELL_IRONGUTS;
    else if (nLastChecked==26) return SPELL_RESISTANCE;

    return SPELL_SPELL_RESISTANCE;
}

int AltGetSpellBreachProtectionGreater(int nLastChecked)
{
    if      (nLastChecked== 0) return SPELL_GREATER_SPELL_MANTLE;
    else if (nLastChecked== 1) return SPELL_SPELL_MANTLE;
    else if (nLastChecked== 2) return SPELL_LESSER_SPELL_MANTLE;
    else if (nLastChecked== 3) return SPELL_MIND_BLANK;
    else if (nLastChecked== 4) return SPELL_LESSER_MIND_BLANK;
    else if (nLastChecked== 5) return SPELL_NEGATIVE_ENERGY_PROTECTION;
    else if (nLastChecked== 6) return SPELL_SHADOW_SHIELD;
    else if (nLastChecked== 7) return SPELL_GLOBE_OF_INVULNERABILITY;
    else if (nLastChecked== 8) return SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
    else if (nLastChecked== 9) return SPELL_ELEMENTAL_SHIELD;
    else if (nLastChecked==10) return SPELL_DEATH_ARMOR;
    else if (nLastChecked==11) return SPELL_MESTILS_ACID_SHEATH;
    else if (nLastChecked==12) return SPELL_SHIELD_OF_FAITH;
    else if (nLastChecked==13) return SPELL_MAGE_ARMOR;
    else if (nLastChecked==14) return SPELL_GREATER_STONESKIN;
    else if (nLastChecked==15) return SPELL_STONESKIN;
    else if (nLastChecked==16) return SPELL_ENDURE_ELEMENTS;
    else if (nLastChecked==17) return SPELL_PROTECTION_FROM_ELEMENTS;
    else if (nLastChecked==18) return SPELL_RESIST_ELEMENTS;
    else if (nLastChecked==19) return SPELL_SPELL_RESISTANCE;
    else if (nLastChecked==20) return SPELL_CLARITY;
    else if (nLastChecked==21) return SPELL_IRONGUTS;
    else if (nLastChecked==22) return SPELL_RESISTANCE;
    else if (nLastChecked==23) return SPELL_GHOSTLY_VISAGE;

    return SPELL_SPELL_RESISTANCE;
}

int AltGetSpellBreachProtectionLesser(int nLastChecked)
{
    if      (nLastChecked== 1) return SPELL_SPELL_MANTLE;
    else if (nLastChecked== 2) return SPELL_LESSER_SPELL_MANTLE;
    else if (nLastChecked== 3) return SPELL_LESSER_MIND_BLANK;
    else if (nLastChecked== 4) return SPELL_NEGATIVE_ENERGY_PROTECTION;
    else if (nLastChecked== 5) return SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
    else if (nLastChecked== 6) return SPELL_ELEMENTAL_SHIELD;
    else if (nLastChecked== 7) return SPELL_GHOSTLY_VISAGE;
    else if (nLastChecked== 8) return SPELL_DEATH_ARMOR;
    else if (nLastChecked== 9) return SPELL_MESTILS_ACID_SHEATH;
    else if (nLastChecked==10) return SPELL_SHIELD_OF_FAITH;
    else if (nLastChecked==11) return SPELL_MAGE_ARMOR;
    else if (nLastChecked==12) return SPELL_STONESKIN;
    else if (nLastChecked==13) return SPELL_ENDURE_ELEMENTS;
    else if (nLastChecked==14) return SPELL_CLARITY;
    else if (nLastChecked==15) return SPELL_IRONGUTS;
    else if (nLastChecked==16) return SPELL_RESISTANCE;
    return SPELL_SPELL_RESISTANCE;
}
////////////////////////////////////////////////////
//////// Scroll Breaches have been nerfed //////////
////////////////////////////////////////////////////
int AltGetSpellBreachProtectionMordsScroll(int nLastChecked)
{
    if      (nLastChecked== 0) return SPELL_GREATER_SPELL_MANTLE;
    else if (nLastChecked== 1) return SPELL_SPELL_MANTLE;
    else if (nLastChecked== 2) return SPELL_LESSER_SPELL_MANTLE;
    else if (nLastChecked== 3) return SPELL_MIND_BLANK;
    else if (nLastChecked== 4) return SPELL_LESSER_MIND_BLANK;
    else if (nLastChecked== 5) return SPELL_NEGATIVE_ENERGY_PROTECTION;
    else if (nLastChecked== 6) return SPELL_SHADOW_SHIELD;
    else if (nLastChecked== 7) return SPELL_GLOBE_OF_INVULNERABILITY;
    else if (nLastChecked== 8) return SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
    else if (nLastChecked== 9) return SPELL_ETHEREAL_VISAGE;
    else if (nLastChecked==10) return SPELL_ELEMENTAL_SHIELD;
    else if (nLastChecked==11) return SPELL_GHOSTLY_VISAGE;
    else if (nLastChecked==12) return SPELL_DEATH_ARMOR;
    else if (nLastChecked==13) return SPELL_MESTILS_ACID_SHEATH;
    else if (nLastChecked==14) return SPELL_SHIELD_OF_FAITH;
    else if (nLastChecked==15) return SPELL_MAGE_ARMOR;
    else if (nLastChecked==16) return SPELL_PREMONITION;
    else if (nLastChecked==17) return SPELL_GREATER_STONESKIN;
    else if (nLastChecked==18) return SPELL_STONESKIN;
    else if (nLastChecked==19) return SPELL_ENERGY_BUFFER;
    else if (nLastChecked==20) return SPELL_ENDURE_ELEMENTS;
    else if (nLastChecked==21) return SPELL_PROTECTION_FROM_ELEMENTS;
    else if (nLastChecked==22) return SPELL_RESIST_ELEMENTS;
    else if (nLastChecked==23) return SPELL_SPELL_RESISTANCE;
    else if (nLastChecked==24) return SPELL_CLARITY;
    else if (nLastChecked==25) return SPELL_IRONGUTS;
    else if (nLastChecked==26) return SPELL_RESISTANCE;
    return SPELL_SPELL_RESISTANCE;
}

int AltGetSpellBreachProtectionGreaterScroll(int nLastChecked)
{
    if      (nLastChecked== 0) return SPELL_GREATER_SPELL_MANTLE;
    else if (nLastChecked== 1) return SPELL_SPELL_MANTLE;
    else if (nLastChecked== 2) return SPELL_LESSER_SPELL_MANTLE;
    else if (nLastChecked== 3) return SPELL_MIND_BLANK;
    else if (nLastChecked== 4) return SPELL_LESSER_MIND_BLANK;
    else if (nLastChecked== 5) return SPELL_NEGATIVE_ENERGY_PROTECTION;
    else if (nLastChecked== 6) return SPELL_SHADOW_SHIELD;
    else if (nLastChecked== 7) return SPELL_GLOBE_OF_INVULNERABILITY;
    else if (nLastChecked== 8) return SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
    else if (nLastChecked== 4) return SPELL_ELEMENTAL_SHIELD;
    else if (nLastChecked== 9) return SPELL_GHOSTLY_VISAGE;
    else if (nLastChecked==10) return SPELL_DEATH_ARMOR;
    else if (nLastChecked==11) return SPELL_MESTILS_ACID_SHEATH;
    else if (nLastChecked==12) return SPELL_SHIELD_OF_FAITH;
    else if (nLastChecked==13) return SPELL_MAGE_ARMOR;
    else if (nLastChecked==14) return SPELL_GREATER_STONESKIN;
    else if (nLastChecked==15) return SPELL_STONESKIN;
    else if (nLastChecked==16) return SPELL_ENDURE_ELEMENTS;
    else if (nLastChecked==17) return SPELL_PROTECTION_FROM_ELEMENTS;
    else if (nLastChecked==18) return SPELL_RESIST_ELEMENTS;
    else if (nLastChecked==19) return SPELL_SPELL_RESISTANCE;
    else if (nLastChecked==20) return SPELL_CLARITY;
    else if (nLastChecked==21) return SPELL_IRONGUTS;
    else if (nLastChecked==22) return SPELL_RESISTANCE;
    return SPELL_SPELL_RESISTANCE;
}

int AltGetSpellBreachProtectionLesserScroll(int nLastChecked)
{
    if      (nLastChecked== 1) return SPELL_SPELL_MANTLE;
    else if (nLastChecked== 2) return SPELL_LESSER_SPELL_MANTLE;
    else if (nLastChecked== 3) return SPELL_LESSER_MIND_BLANK;
    else if (nLastChecked== 4) return SPELL_NEGATIVE_ENERGY_PROTECTION;
    else if (nLastChecked== 5) return SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
    else if (nLastChecked== 6) return SPELL_ELEMENTAL_SHIELD;
    else if (nLastChecked== 7) return SPELL_GHOSTLY_VISAGE;
    else if (nLastChecked== 8) return SPELL_DEATH_ARMOR;
    else if (nLastChecked== 9) return SPELL_MESTILS_ACID_SHEATH;
    else if (nLastChecked==10) return SPELL_SHIELD_OF_FAITH;
    else if (nLastChecked==11) return SPELL_MAGE_ARMOR;
    else if (nLastChecked==12) return SPELL_STONESKIN;
    else if (nLastChecked==13) return SPELL_ENDURE_ELEMENTS;
    else if (nLastChecked==14) return SPELL_CLARITY;
    else if (nLastChecked==15) return SPELL_IRONGUTS;
    else if (nLastChecked==16) return SPELL_RESISTANCE;
    return SPELL_SPELL_RESISTANCE;
}



void AltSpellBreach(object oCaster, object oTarget, int nBreachMax, int nSR, int nSpellID = SPELL_GREATER_SPELL_BREACH)
{
    int nBreachCnt = 0;
    int nCheckSpell = 0;

    string sSpellName; // Spell name
    string sSuccess = "   *Success* -- these protections were breached:";

    if      (nSpellID==SPELL_LESSER_SPELL_BREACH)       sSpellName = "Lesser Spell Breach";
    else if (nSpellID==SPELL_GREATER_SPELL_BREACH)      sSpellName = "Greater Spell Breach";
    else if (nSpellID==SPELL_MORDENKAINENS_DISJUNCTION) sSpellName = "Mordenkainen's Breach";

    SendMessageToPC(oTarget, GetName(oCaster) + " casts " + sSpellName);
    SendMessageToPC(oCaster, sSpellName + " cast on " + GetName(oTarget));
    int nNextSpellID;
    if (1/*!GetIsFriend(oTarget)*/)
    {
        if (nSpellID != SPELL_MORDENKAINENS_DISJUNCTION) SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));

        if ((nSpellID == SPELL_MORDENKAINENS_DISJUNCTION)) //&& GetCasterLevel(oCaster)>17)// Enter Mords Breach list
        {
            while (nCheckSpell <= BREACH_SPELL_COUNT_MORDS && nBreachCnt < nBreachMax)
            {
                nNextSpellID = AltGetSpellBreachProtectionMords(nCheckSpell);
                if (GetHasSpellEffect(nNextSpellID, oTarget))
                {
                    int bRemoved = FALSE;
                    int bSpecialDone = FALSE;
                    effect eProtection = GetFirstEffect(oTarget);
                    while (GetIsEffectValid(eProtection))
                    {
                        if (GetEffectSpellId(eProtection)==nNextSpellID)
                        {
                            RemoveEffect(oTarget, eProtection);
                        }
                        eProtection = GetNextEffect(oTarget);
                    }
                    nBreachCnt++;
                    sSpellName = Get2DAString("spells", "Label", nNextSpellID);
                    if (sSpellName == "") sSpellName = "Unknown Protection";
                    sSuccess  += "\n   --> " + sSpellName;
                }
                nCheckSpell++;
            }
        }
/*        else if ((nSpellID == SPELL_MORDENKAINENS_DISJUNCTION) && GetCasterLevel(oCaster)<18)// Scroll Mords Breach list
        {
            while (nCheckSpell <= BREACH_SPELL_COUNT && nBreachCnt < nBreachMax)
            {
                nNextSpellID = AltGetSpellBreachProtectionMordsScroll(nCheckSpell);
                if (GetHasSpellEffect(nNextSpellID, oTarget))
                {
                    int bRemoved = FALSE;
                    int bSpecialDone = FALSE;
                    effect eProtection = GetFirstEffect(oTarget);
                    while (GetIsEffectValid(eProtection))
                    {
                        if (GetEffectSpellId(eProtection)==nNextSpellID)
                        {
                            RemoveEffect(oTarget, eProtection);
                        }
                        eProtection = GetNextEffect(oTarget);
                    }
                    nBreachCnt++;
                    sSpellName = Get2DAString("spells", "Label", nNextSpellID);
                    if (sSpellName == "") sSpellName = "Unknown Protection";
                    sSuccess  += "\n   --> " + sSpellName;
                }
                nCheckSpell++;
            }
        }
*/
        if ((nSpellID == SPELL_GREATER_SPELL_BREACH)) //&& GetCasterLevel(oCaster)>11)// Enter Greater Breach list
        {
            while (nCheckSpell <= BREACH_SPELL_COUNT_GREATER && nBreachCnt < nBreachMax)
            {
                nNextSpellID = AltGetSpellBreachProtectionGreater(nCheckSpell);
                if (GetHasSpellEffect(nNextSpellID, oTarget))
                {
                    int bRemoved = FALSE;
                    int bSpecialDone = FALSE;
                    effect eProtection = GetFirstEffect(oTarget);
                    while (GetIsEffectValid(eProtection))
                    {
                        if (GetEffectSpellId(eProtection)==nNextSpellID)
                        {
                            RemoveEffect(oTarget, eProtection);
                        }
                        eProtection = GetNextEffect(oTarget);
                    }
                    nBreachCnt++;
                    sSpellName = Get2DAString("spells", "Label", nNextSpellID);
                    if (sSpellName == "") sSpellName = "Unknown Protection";
                    sSuccess  += "\n   --> " + sSpellName;
                }
                nCheckSpell++;
            }
        }
/*        else if ((nSpellID == SPELL_GREATER_SPELL_BREACH) && GetCasterLevel(oCaster)<12)// Scroll Greater Breach list
        {
            while (nCheckSpell <= BREACH_SPELL_COUNT && nBreachCnt < nBreachMax)
            {
                nNextSpellID = AltGetSpellBreachProtectionMords(nCheckSpell);
                if (GetHasSpellEffect(nNextSpellID, oTarget))
                {
                    int bRemoved = FALSE;
                    int bSpecialDone = FALSE;
                    effect eProtection = GetFirstEffect(oTarget);
                    while (GetIsEffectValid(eProtection))
                    {
                        if (GetEffectSpellId(eProtection)==nNextSpellID)
                        {
                            RemoveEffect(oTarget, eProtection);
                        }
                        eProtection = GetNextEffect(oTarget);
                    }
                    nBreachCnt++;
                    sSpellName = Get2DAString("spells", "Label", nNextSpellID);
                    if (sSpellName == "") sSpellName = "Unknown Protection";
                    sSuccess  += "\n   --> " + sSpellName;
                }
                nCheckSpell++;
            }
        }
*/
        if ((nSpellID == SPELL_LESSER_SPELL_BREACH))//&& GetCasterLevel(oCaster)>17)// Enter Lesser Breach list
        {
            while (nCheckSpell <= BREACH_SPELL_COUNT_LESSER && nBreachCnt < nBreachMax)
            {
                nNextSpellID = AltGetSpellBreachProtectionLesser(nCheckSpell);
                if (GetHasSpellEffect(nNextSpellID, oTarget))
                {
                    int bRemoved = FALSE;
                    int bSpecialDone = FALSE;
                    effect eProtection = GetFirstEffect(oTarget);
                    while (GetIsEffectValid(eProtection))
                    {
                        if (GetEffectSpellId(eProtection)==nNextSpellID)
                        {
                            RemoveEffect(oTarget, eProtection);
                        }
                        eProtection = GetNextEffect(oTarget);
                    }
                    nBreachCnt++;
                    sSpellName = Get2DAString("spells", "Label", nNextSpellID);
                    if (sSpellName == "") sSpellName = "Unknown Protection";
                    sSuccess  += "\n   --> " + sSpellName;
                }
                nCheckSpell++;
            }
        }
/*        else if ((nSpellID == SPELL_LESSER_SPELL_BREACH) && GetCasterLevel(oCaster)<18)// Scroll Lesser Breach list
        {
            while (nCheckSpell <= BREACH_SPELL_COUNT && nBreachCnt < nBreachMax)
            {
                nNextSpellID = AltGetSpellBreachProtectionMords(nCheckSpell);
                if (GetHasSpellEffect(nNextSpellID, oTarget))
                {
                    int bRemoved = FALSE;
                    int bSpecialDone = FALSE;
                    effect eProtection = GetFirstEffect(oTarget);
                    while (GetIsEffectValid(eProtection))
                    {
                        if (GetEffectSpellId(eProtection)==nNextSpellID)
                        {
                            RemoveEffect(oTarget, eProtection);
                        }
                        eProtection = GetNextEffect(oTarget);
                    }
                    nBreachCnt++;
                    sSpellName = Get2DAString("spells", "Label", nNextSpellID);
                    if (sSpellName == "") sSpellName = "Unknown Protection";
                    sSuccess  += "\n   --> " + sSpellName;
                }
                nCheckSpell++;
            }
       }
*/
      int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_ABJURATION, TRUE); // 3rd paramter set to TRUE to not display floating text
      int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_ABJURATION) + nPureBonus;

      effect eSR = EffectSpellResistanceDecrease(nSR);
      effect eLink = ExtraordinaryEffect(eSR);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nPureLevel));
      if (!nBreachCnt) sSuccess += "None";

      SendMessageToPC(oTarget, sSuccess);
      SendMessageToPC(oCaster, sSuccess);

   }
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oTarget);
}

void AltspellsDispelMagic(object oTarget, object oCaster, effect eVis, int nPureLevel, int nLimit = 999)
{


    // Visual Special Effect
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)));

    int nCount = 0;

    int nDC;           // 15+Effect creator level
    int nSpellID = GetSpellId();      // Spell ID
    int nSpellSchool;  // Spell School
    string sSpellName; // Spell name
    string sSpellList = ""; // LIST OF SPELLS CHECKED
    string sSuccess = "   *Success* -- these effects were dispelled:";
    string sFailure = "   *Failure* -- these effects were not dispelled:";
    string sMessage;
    string fMessage;   // final message
    int nSuccessCnt = 0;
    int nFailureCnt = 0;
    int nCreatorBonus, nRoll, nCreatorLevel;
    object oCreator;

    if      (nSpellID==SPELL_LESSER_DISPEL) sSpellName = "Lesser Dispel";
    else if (nSpellID==SPELL_DISPEL_MAGIC)  sSpellName = "Dispel";
    else if (nSpellID==SPELL_GREATER_DISPELLING) sSpellName = "Greater Dispel";
    else if (nSpellID==SPELL_MORDENKAINENS_DISJUNCTION) sSpellName = "Mordenkainen's Disjunction";

    SendMessageToPC(oTarget, GetName(oCaster) + " casts " + sSpellName);
    SendMessageToPC(oCaster, sSpellName + " cast on " + GetName(oTarget));

    int nRollBonus = 0;
    if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oCaster))         nRollBonus += 2;
    if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCaster)) nRollBonus += 2;
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCaster))    nRollBonus += 2;

    int nDCBonus      = GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oTarget) ? 2 : 0;
    int nReapplyHaste;
    effect eEffect = GetFirstEffect(oTarget);

    while (GetIsEffectValid(eEffect))
    {
        if(GetEffectSubType(eEffect) == SUBTYPE_MAGICAL)
        {
            if (nSpellID == SPELL_CREEPING_DOOM ||
                nSpellID == SPELL_GREASE ||
                nSpellID == SPELL_MASS_HASTE ||
                nSpellID == SPELL_NEGATIVE_ENERGY_BURST ||
                nSpellID == SPELL_SLOW ||
                nSpellID == SPELL_WEB) nReapplyHaste = TRUE;

            nSpellID        = GetEffectSpellId(eEffect);
            nSpellSchool    = GetSchool(Get2DAString("spells", "School", nSpellID));
            sSpellName      = Get2DAString("spells", "Label", nSpellID);
            if (sSpellName == "") sSpellName = "Unknown Effect";
            nRoll       = d20();
            oCreator   = GetEffectCreator(eEffect);

            nCreatorBonus = GetPureCasterBonus(oCreator, nSpellSchool, TRUE); // 3rd paramter set to TRUE to not display floating text
            nCreatorLevel = GetPureCasterLevel(oCreator, nSpellSchool) + nCreatorBonus;

            nDC           = d20();
            if (!GetIsTokenInString(IntToString(nSpellID), sSpellList))
            {
                sSpellList = AddTokenToString(IntToString(nSpellID), sSpellList);
                sMessage  = "\n   --> " + sSpellName;
                sMessage += " (" + IntToString(nPureLevel) + " + " + IntToString(nRoll) + " + " + IntToString(nRollBonus);
                sMessage += " = " + IntToString(nPureLevel + nRollBonus + nRoll);
                sMessage += " vs DC " + IntToString(nDC) + " + " + IntToString(nCreatorLevel) + " + " + IntToString(nDCBonus);
                sMessage += " = " + IntToString(nDC + nDCBonus + nCreatorLevel) + ")";

                //Remove effect if DC Failed
                if ((nRollBonus + nRoll + nPureLevel >= nDC + nCreatorLevel + nDCBonus || nRoll == 20) && nRoll != 1 && nCount < nLimit)
                {
                    nSuccessCnt++;
                    sSuccess += sMessage;
                    RemoveEffect(oTarget, eEffect);
                    nCount++;         // Increment effects dispelled count
                    if(nCount == nLimit) sSuccess += "Maximum Dispel Limit Reached: " + IntToString(nLimit);
                }
                else
                {
                    nFailureCnt++;
                    sFailure += sMessage;
                }
            }
        }
        eEffect = GetNextEffect(oTarget);
    }
    if (nReapplyHaste) DelayCommand(0.1, ReapplyPermaHaste(oTarget));
    if (!nSuccessCnt) sSuccess += "\nNone";
    if (!nFailureCnt) sFailure += "\nNone";
    if (!nSuccessCnt && !nFailureCnt) fMessage = "Target has no magic effects.";
    else                              fMessage = sSuccess + "\n" + sFailure;

    if(oTarget != oCaster) SendMessageToPC(oTarget, fMessage);
    SendMessageToPC(oCaster, fMessage);
}
