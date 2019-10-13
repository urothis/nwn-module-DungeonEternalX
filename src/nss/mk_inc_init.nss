// ----------------------------------------------------------------------------
// Reads the 2da initialization file mk_init.2da
// ----------------------------------------------------------------------------
void MK_init();

/*
        Key                   Value              Variable                        TypeID         Type
0       ColorGroups           11                 MK_NUMBER_OF_COLOR_GROUPS       1              INTEGER
1       ColorsPerGroup        16                 MK_NUMBER_OF_COLORS_PER_GROUP   1              INTEGER
2       ColorHighlight        "<cþ¥ >"           14436                           4              TOKEN
3       ColorBack             "<cþ þ>"           14437                           4              TOKEN
4       ColorModelName        "<c ¿þ>"           14438                           4              TOKEN
5       ColorMakeChanges      "<cþþ >"           14439                           4              TOKEN
6       ColorMaterialToDye    "<c ¿þ>"           MK_TOKEN_COLOR1                 3              STRING
7       ColorMaterial         "<c¥¥¥>"           MK_TOKEN_COLOR2                 3              STRING
8       PortraitDelay         0.2                MK_PORTRAIT_DELAY               2              FLOAT
9       ****                  ****               ****                            ****           ****
*/

const string MK_INIT_2DA_FILE = "mk_init";
const string MK_INIT_COL_NAME = "Variable";
const string MK_INIT_COL_VALUE = "Value";
const string MK_INIT_COL_TYPEID = "TypeID";

const int MK_INIT_TYPE_INT = 1;
const int MK_INIT_TYPE_FLOAT = 2;
const int MK_INIT_TYPE_STRING = 3;
const int MK_INIT_TYPE_TOKEN = 4;


int MK_ProcessLine(int nLine)
{
    string sVariable = Get2DAString(MK_INIT_2DA_FILE, MK_INIT_COL_NAME,nLine);
    if (sVariable=="") return FALSE;

    string sValue = Get2DAString(MK_INIT_2DA_FILE, MK_INIT_COL_VALUE,nLine);
    int nTypeID = StringToInt(Get2DAString(MK_INIT_2DA_FILE, MK_INIT_COL_TYPEID,nLine));

    switch (nTypeID)
    {
    case MK_INIT_TYPE_INT:
        SetLocalInt(OBJECT_SELF, sVariable, StringToInt(sValue));
        break;
    case MK_INIT_TYPE_FLOAT:
        SetLocalFloat(OBJECT_SELF, sVariable, StringToFloat(sValue));
        break;
    case MK_INIT_TYPE_STRING:
        SetLocalString(OBJECT_SELF, sVariable, sValue);
        break;
    case MK_INIT_TYPE_TOKEN:
        SetCustomToken(StringToInt(sVariable), sValue);
        break;
    }
    return TRUE;
}

void MK_init()
{
    int nLine=0;
    while (MK_ProcessLine(nLine++)) {}

/*
    SetCustomToken(14435, "</c>"); // CLOSE tag



    string s2DA = "mk_init";
    string sColumn = "Value";

    // Read number of color groups and set number of colors per group;
    int nGroups = StringToInt(Get2DAString(s2DA, sColumn, 0));
    if ((nGroups>0) && (nGroups<=22))
    {
        SetLocalInt(OBJECT_SELF, "MK_NUMBER_OF_COLOR_GROUPS", nGroups);
        SetLocalInt(OBJECT_SELF, "MK_NUMBER_OF_COLORS_PER_GROUP", 176 / nGroups);
    }

    // Read color tokens;
    int iToken;
    for (iToken=0; iToken<4; iToken++)
    {
        SetCustomToken(14436+iToken, Get2DAString(s2DA,sColumn, 10+iToken));
    }

    SetLocalString(OBJECT_SELF, "MK_TOKEN_COLOR1", Get2DAString(s2DA, sColumn, 20));
    SetLocalString(OBJECT_SELF, "MK_TOKEN_COLOR2", Get2DAString(s2DA, sColumn, 21));
*/
}



/*
void main()
{

}
/**/
