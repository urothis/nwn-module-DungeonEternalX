void SetPlayerID(object oPC, string sPlayerID)
{
    // Player ID
    SetLocalString(oPC, "PI", sPlayerID);
}
string GetPlayerID(object oPC)
{
    string nPlayerID = GetLocalString(oPC, "PI");
    if(nPlayerID == "")
        nPlayerID = "0";
    return nPlayerID;

}
void SetCharacterID(object oPC, string sCharacterID)
{
    // Character ID
    SetLocalString(oPC, "CI", sCharacterID);
}
string GetCharacterID(object oPC)
{
    string nCharID = GetLocalString(oPC, "CI");
    if(nCharID == "")
        nCharID = "0";
    return nCharID;
}
object GetObjectByCharacterID(string sID)
{
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        if(GetCharacterID(oPC) == sID)
            return oPC;
        oPC = GetNextPC();
    }
    return OBJECT_INVALID;
}

