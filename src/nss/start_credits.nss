void main()
{
    object oUser = GetLastUsedBy();
    ActionStartConversation(oUser, "credits",TRUE);

}
