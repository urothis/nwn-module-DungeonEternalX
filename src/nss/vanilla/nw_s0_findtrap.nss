//::///////////////////////////////////////////////
//:: Find Traps
//:: NW_S0_FindTrap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus    = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_DIVINATION);
    int nPureLevel    = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_DIVINATION) + nPureBonus;
    int nPureDC       = GetSpellSaveDC() + nPureBonus;

    float fPureBonus;
    object oTarget    = GetSpellTargetObject();
    object oItem      = GetSpellCastItem();
    effect eVis       = EffectVisualEffect(VFX_IMP_KNOCK);
    float fDisarmRadius = 20.0;
    float fDist;    location lLoc;
    if (GetLevelByClass(CLASS_TYPE_HARPER, oTarget) > 4)
    { // Increase if Harper use Pots
        if (GetBaseItemType(oItem) == BASE_ITEM_POTIONS) fPureBonus == 8.0;
    }
    else fPureBonus = IntToFloat(nPureBonus);

    int nCnt = 1;
    object oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTrap))
    {
        float fDist = GetDistanceToObject(oTrap);
        if (fDist > fDisarmRadius + fPureBonus) break;

        if (GetIsTrapped(oTrap))
        {
            SetTrapDetectedBy(oTrap, OBJECT_SELF);
            lLoc = GetLocation(oTrap);
            if (fDist <= fDisarmRadius/2 + fPureBonus)
            {

                DelayCommand(fDist/10, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc));
                DelayCommand(fDist/10+2.0, SetTrapDisabled(oTrap));
            }
        }
        nCnt++;
        oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
}

