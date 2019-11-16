#include "x2_inc_switches"

void main() {
    int nEvent = GetUserDefinedItemEventNumber();

    int nResult = X2_EXECUTE_SCRIPT_CONTINUE;

    object oPC;          // The caster
    object oItem;        // This item
    object oTarget;      // Target

    if (nEvent == X2_ITEM_EVENT_ACTIVATE) {
        oItem   = GetItemActivated();
        oPC     = GetItemActivator();
        oTarget = GetItemActivatedTarget();

        if (!GetIsPC(oTarget))
        {
            FloatingTextStringOnCreature("You missed!! >.<", oPC, FALSE);
        }
        else if (!GetLocalInt(oTarget, "DmEventNoPort")){ // Enter PC target into event - Send to tavern
            SetLocalInt(oTarget, "DmEventNoPort", 1); // Disables port stones for participating PC character.

            SendMessageToPC(oTarget, "Entered into DM event.");

            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oTarget);
            DelayCommand(1.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), oTarget));
            DelayCommand(2.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oTarget));
            DelayCommand(2.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oTarget));
            DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), oTarget));
            DelayCommand(3.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oTarget));
            DelayCommand(3.5, AssignCommand(oTarget, JumpToLocation(GetStartingLocation())));
        }
        else// Remove PC from event - cleanup local ints
        {
            DeleteLocalInt(oTarget, "DmEventNoPort");
            DeleteLocalInt(oTarget, "OtmanRingTime");
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
