//::///////////////////////////////////////////////
//:: Invisibilty Purge: On Enter
//:: NW_S0_InvPurgeA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     All invisible creatures in the AOE become
     visible.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//::March 31: Made it so it will actually remove
//  the effects of Improved Invisibility
#include "x0_i0_spells"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();

    effect eInvis = GetFirstEffect(oTarget);

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator))
    {
        RemoveAnySpellEffects(SPELL_IMPROVED_INVISIBILITY, oTarget);
        RemoveAnySpellEffects(SPELL_INVISIBILITY, oTarget);
        RemoveAnySpellEffects(SPELLABILITY_AS_INVISIBILITY, oTarget);
        RemoveAnySpellEffects(SPELLABILITY_AS_IMPROVED_INVISIBLITY, oTarget);

        if(!GetIsReactionTypeFriendly(oTarget, oCreator))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_INVISIBILITY_PURGE));
        }
        else
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_INVISIBILITY_PURGE, FALSE));
        }
    }
}
