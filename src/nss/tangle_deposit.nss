void main()
{
    object oUser = GetLastUsedBy();
    ActionStartConversation(oUser, "mine",TRUE);

}
