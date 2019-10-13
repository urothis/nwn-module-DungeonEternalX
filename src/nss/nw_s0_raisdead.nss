//::///////////////////////////////////////////////
//:: [Raise Dead]
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
void main()
{
    if (!X2PreSpellCastCode()) return;

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eRaise  = EffectResurrection();
    effect eVis    = EffectVisualEffect(VFX_IMP_RAISE_DEAD);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAISE_DEAD, FALSE));

    if(GetIsDead(oTarget))
    {
        if (GetIsPC(oTarget) && !GetFactionEqual(oTarget))
        {
            FloatingTextStringOnCreature("You can not raise target in different party", OBJECT_SELF, FALSE);
        }
        else
        {
            //Apply raise dead effect and VFX impact
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);
            DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectHaste()), oTarget));
            AssignCommand(oTarget, SpeakString("I AM ALIVE!", TALKVOLUME_SILENT_TALK));
            if(!GetIsPC(oTarget) && !GetIsDMPossessed(oTarget))
            {
                // Default AI script
                ExecuteScript("nw_c2_default3", oTarget);
            }
        }
    }
}


