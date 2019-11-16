string GetLegalCharacterString(string sString, string sLegalCharacters="abcdefghijklmnopqrstuvwxyz1234567890_-")
{
    string sOut, sChar;
    int nCount;
    for (nCount=0; nCount<GetStringLength(sString); nCount++)
    {
        //Is this a legal character?
        sChar=GetSubString(sString, nCount, 1);
        if (TestStringAgainstPattern("**"+sChar+"**", sLegalCharacters))
        //Legal character, add to sOutPut
        sOut=sOut+sChar;
    }
    return sOut;
    }

string Letoname(object oPC)
{
    //name length saved is 16 characters, minus 1 for additional numbered characters.
    string sName = GetStringLowerCase(GetName(oPC));
    int nLength = GetStringLength(sName);
    string sFinal;
    if (nLength > 0)
            sFinal = GetLegalCharacterString(sName);
    return sFinal;
}