void main()
{
    object oPC = GetClickingObject();
    if (!GetIsObjectValid(oPC)) return;
    if (!GetIsPC(oPC)) return;

    ActionStartConversation(oPC, "", TRUE);
}
