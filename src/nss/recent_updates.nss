// Starts conversation about recent server changes with PC
void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

ActionStartConversation(oPC, "update_convo");

}

