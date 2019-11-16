//::///////////////////////////////////////////////
//:: [Ressurection]
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())  return;

    //Get the spell target
    object oTarget = GetSpellTargetObject();

    //Check to make sure the target is dead first
    //Fire cast spell at event for the specified target
    if (GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESURRECTION, FALSE));
        if (GetIsDead(oTarget))
        {
            if (GetIsPC(oTarget) && !GetFactionEqual(oTarget))
            {
                FloatingTextStringOnCreature("You can not raise target in different party", OBJECT_SELF, FALSE);
            }
            else
            {
                //Declare major variables
                int nCasterLevel = GetLevelByClass(CLASS_TYPE_DRUID)+ GetLevelByClass(CLASS_TYPE_CLERIC);
                int nLevel  = GetLevelByClass(CLASS_TYPE_CLERIC) + GetLevelByClass(CLASS_TYPE_DRUID);
                int nHealed = 6 * nCasterLevel + d2(nCasterLevel);
                effect eRaise = EffectResurrection();
                effect eHeal = EffectHeal(nHealed);
                effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
                //Apply the heal, raise dead and VFX impact effect
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
                DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectHaste()), oTarget));
                if(!GetIsPC(oTarget) && !GetIsDMPossessed(oTarget))
                {
                    // Default AI script
                    ExecuteScript("nw_c2_default3", oTarget);
                }
            }
        }
        else
        {
            if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                int nStrRef = GetLocalInt(oTarget,"X2_L_RESURRECT_SPELL_MSG_RESREF");
                if (nStrRef == 0)
                {
                    nStrRef = 83861; //Don't know what this is :)
                }
                if (nStrRef != -1)
                {
                     FloatingTextStrRefOnCreature(nStrRef,OBJECT_SELF);
                }
            }
        }
    }
}


