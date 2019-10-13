// PCDB_Deity include
// Persistent character data stored in character "Deity" field

const string PCDB_IDENTIFIER = "PCDB02";
const int PCDB_SIZE_IDENTIFIER = 6;

// Set a value in the deity DB
void PCDB_SetString(object oCreature, string sVarName, string sValue, string sTypeID = "S")
{
    string sData    = GetStringLeft(GetDeity(oCreature), GetStringLength(GetDeity(oCreature)) - PCDB_SIZE_IDENTIFIER);
    int nPos        = FindSubString(sData, sVarName + sTypeID + "~");

    if(nPos == -1)
        sData += sVarName + sTypeID + "~" + sValue + "@";
    else
    {
        string s1 = GetStringRight(sData, GetStringLength(sData) - nPos);
        sData = GetStringLeft(sData, nPos) + GetStringLeft(s1, FindSubString(s1,"~") + 1) + sValue +
                GetStringRight(s1, GetStringLength(s1) - FindSubString(s1, "@"));
    }
    SetDeity(oCreature, sData + PCDB_IDENTIFIER);
}

// Return a value from the deity DB
string PCDB_GetString(object oCreature, string sVarName, string sTypeID = "S")
{
    string sData    = GetStringLeft(GetDeity(oCreature), GetStringLength(GetDeity(oCreature)) - PCDB_SIZE_IDENTIFIER);
    int nPos        = FindSubString(sData, sVarName+ sTypeID + "~");
    if(nPos != -1)
    {
        string s1 = GetStringRight(sData, GetStringLength(sData) - GetStringLength(GetStringLeft(sData, nPos)));
        string s2 = GetStringLeft(s1, FindSubString(s1,"@"));
        return GetStringRight(s2, GetStringLength(s2) - FindSubString(s2,"~") -1);
    }
    return "";
}

// Delete a value from the deity DB
void PCDB_DeleteString(object oCreature, string sVarName, string sTypeID = "S")
{
    string sData    = GetStringLeft(GetDeity(oCreature), GetStringLength(GetDeity(oCreature)) - PCDB_SIZE_IDENTIFIER);
    int nPos        = FindSubString(sData, sVarName + sTypeID +"~");
    if(nPos != -1)
    {
        string s1 = GetStringRight(sData, GetStringLength(sData) - nPos);
        string s2 = GetStringLeft(sData, nPos);
        string s3 = GetStringRight(s1, GetStringLength(s1) - FindSubString(s1, "@") -1);
        sData = s2 + s3;
        SetDeity(oCreature, sData + PCDB_IDENTIFIER);
    }
}

void PCDB_SetInt(object oCreature, string sVarName, int nValue)
{
    PCDB_SetString(oCreature, sVarName, IntToString(nValue), "I");
}

int PCDB_GetInt(object oCreature, string sVarName)
{
    return StringToInt(PCDB_GetString(oCreature, sVarName, "I"));
}

void PCDB_DeleteInt(object oCreature, string sVarName)
{
    PCDB_DeleteString(oCreature, sVarName,"I");
}

float PCDB_GetFloat(object oCreature, string sVarName)
{
    return StringToFloat(PCDB_GetString(oCreature, sVarName, "F"));
}

void PCDB_SetFloat(object oCreature, string sVarName, float fValue)
{
    PCDB_SetString(oCreature, sVarName, FloatToString(fValue), "F");
}

void PCDB_DeleteFloat(object oCreature, string sVarName)
{
    PCDB_DeleteString(oCreature, sVarName,"F");
}

string PCDB_GetDeity(object oCreature)
{
    return PCDB_GetString(oCreature, "PCDB_D");
}

void PCDB_SetDeity(object oCreature, string sDeity)
{
    PCDB_SetString(oCreature, "PCDB_D", sDeity);
}

void PCDB_Init(object oCreature)
{
    string sDeity       = GetDeity(oCreature);
    string sVersion     = GetStringRight(PCDB_IDENTIFIER,2);

    if(sDeity == "")
    {
        WriteTimestampedLogEntry("(PCDB) Database created, PC: "+GetName(oCreature)+", Version "+sVersion);
        SetDeity(oCreature, PCDB_IDENTIFIER);
    }
    else
    {
        string sIdentifier = GetStringRight(sDeity,6);
        if(GetStringLeft(sIdentifier,4) == "PCDB")
        {
            // placeholder.. data conversion possible
            // if structure changes in future version
        }
        else
        {
            WriteTimestampedLogEntry("(PCDB) Database created, PC: "+GetName(oCreature)+", Version "+sVersion);
            WriteTimestampedLogEntry("(PCDB) Deity converted");
            SetDeity(oCreature, PCDB_IDENTIFIER);
            PCDB_SetDeity(oCreature, sDeity); // deity already used, convert
        }
    }
}

//void main(){}
