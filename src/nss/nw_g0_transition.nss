////////////////////////////////////////////////////////////
// OnClick/OnAreaTransitionClick
// NW_G0_Transition.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
// Created By: Sydney Tang
// Created On: 2001-10-26
// Description: This is the default script that is called
//              if no OnClick script is specified for an
//              Area Transition Trigger or
//              if no OnAreaTransitionClick script is
//              specified for a Door that has a LinkedTo
//              Destination Type other than None.
////////////////////////////////////////////////////////////
#include "_inc_port"

void main()
{
    object oTrans   = OBJECT_SELF;
    object oPC      = GetClickingObject();
    object oTarget  = GetTransitionTarget(oTrans);
    string sAreaTag = GetTag(GetArea(oPC));

    if (GetIsPC(oPC))
    {
        if (GetPortMode(oPC) == PORT_NOT_ALLOWED)
        {
            SendMessageToPC(oPC, "You can not transit at this time");
            return;
        }
        if (sAreaTag == "TheFort") // Ignore hostile transition rules in the fort
        {
            AssignCommand(oPC, JumpToObject(oTarget));
            return;
        }
        if (GetIsHostilePcNearby(oPC, GetArea(oTrans), 35.0, 5))
        {
            SendMessageToPC(oPC, "A worthy opponent blocks your path...");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTrueSeeing(), oPC, 1.0);
            SetPortMode(oPC, PORT_NOT_ALLOWED);
            DelayCommand(3.0, SetPortMode(oPC));
            return;
        }
    }
    AssignCommand(oPC, JumpToObject(oTarget));
}
