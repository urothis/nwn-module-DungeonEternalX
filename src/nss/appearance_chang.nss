   void main()
{
    object oPC = GetItemActivator();
    if(GetItemActivated() != OBJECT_INVALID)
        {
        AssignCommand(oPC, ClearAllActions(TRUE));
        AssignCommand(oPC, ActionStartConversation(oPC, "appearancecon", TRUE));
        }
}

