//::///////////////////////////////////////////////
//:: Craft Harper Item
//:: x0_s2_HarpItem
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "zdlg_include_i"
void main()
{
    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, 479, FALSE));
    StartDlg(OBJECT_SELF, GetFirstItemInInventory(OBJECT_SELF), "harper_feat_conv", TRUE, FALSE);
    //ActionStartConversation(OBJECT_SELF, "x1_harper", FALSE, FALSE);
}
