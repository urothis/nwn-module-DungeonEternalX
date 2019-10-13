void main()
{
    object oPC = GetLastUsedBy();
    if (!GetIsPC(oPC)) return;
    ActionStartConversation(oPC, "", TRUE, FALSE);
}
