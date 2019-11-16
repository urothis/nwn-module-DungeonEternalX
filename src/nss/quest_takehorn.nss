#include "nw_i0_plot"
#include "quest_inc"
#include "_functions"

void main()
{
    object oPC = GetPCSpeaker();
    if (HasItem(oPC, "it_rawhorn"))
    {
        AssignCommand(OBJECT_SELF, SpeakString("Thank you!"));
        object oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
            if (GetTag(oItem) == "it_rawhorn")
            {
                 Insured_Destroy(oItem);
                 Q_UpdateQuest(oPC, "16");
                 return;
            }
            oItem = GetNextItemInInventory(oPC);
        }
    }
    else
    {
        AssignCommand(OBJECT_SELF, SpeakString("Please find some and then come and speak to me."));
    }
}
