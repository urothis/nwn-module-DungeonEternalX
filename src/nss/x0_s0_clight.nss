//::///////////////////////////////////////////////
//:: Continual Flame
//:: x0_s0_clight.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Permanent Light spell

    XP2
    If cast on an item, item will get permanently
    get the property "light".
    Previously existing permanent light properties
    will be removed!

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 18, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
//:: Added XP2 cast on item code: Georg Z, 2003-06-05
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nDuration;
    int nMetaMagic;

    object oTarget = GetSpellTargetObject();

    // Handle spell cast on item....
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && !CIGetIsCraftFeatBaseItem(oTarget))
    {
        // Do not allow casting on not equippable items
        if (!IPGetIsItemEquipable(oTarget))
        {
            // Item must be equipable...
            FloatingTextStrRefOnCreature(83326,OBJECT_SELF);
            return;
        }
        itemproperty ip = ItemPropertyLight (IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_WHITE);
        IPSafeAddItemProperty(oTarget, ip, 0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,TRUE,TRUE);
    }
    else
    {
        effect eVis = SupernaturalEffect(EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20));
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 419, FALSE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
    }
}



