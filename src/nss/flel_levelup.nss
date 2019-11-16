#include "zdlg_include_i"
#include "gen_inc_color"

const string LIST = "LEVELUP_LIST";

const string SELECTOR = "LEVELUP_SELECTOR";
const int SELECT_MAIN_MENU = 0;
const int SELECT_SET_LEVEL = 1;
const int SELECT_GIVE_GOLD = 2;

int GetSelector()
{
    return GetLocalInt(GetPcDlgSpeaker(), SELECTOR);
}

void SetSelector(int nSelector)
{
    SetLocalInt(GetPcDlgSpeaker(), SELECTOR, nSelector);
}

void Init()
{
    SetSelector(SELECT_MAIN_MENU);
}

void HandleSelection()
{
    object oPC = GetPcDlgSpeaker();
    switch (GetSelector())
    {
        case SELECT_MAIN_MENU:
            SetSelector(GetIntElement(GetDlgSelection(),LIST,oPC));
            break;
        case SELECT_SET_LEVEL:
            switch(GetIntElement(GetDlgSelection(),LIST,oPC))
            {
                //((nLevel * (nLevel - 1)) / 2) * 1000;
                case 1:
                    SetXP(oPC,0);
                    break;
                case 2:
                    SetXP(oPC,1000);
                    break;
                case 3:
                    SetXP(oPC,3000);
                    break;
                case 4:
                    SetXP(oPC,6000);
                    break;
                case 5:
                    SetXP(oPC,10000);
                    break;
                case 6:
                    SetXP(oPC,15000);
                    break;
                case 7:
                    SetXP(oPC,21000);
                    break;
                case 8:
                    SetXP(oPC,28000);
                    break;
                case 9:
                    SetXP(oPC,36000);
                    break;
                case 10:
                    SetXP(oPC,45000);
                    break;
                case 11:
                    SetXP(oPC,55000);
                    break;
                case 12:
                    SetXP(oPC,66000);
                    break;
                case 13:
                    SetXP(oPC,78000);
                    break;
                case 14:
                    SetXP(oPC,91000);
                    break;
                case 15:
                    SetXP(oPC,105000);
                    break;
                case 16:
                    SetXP(oPC,120000);
                    break;
                case 17:
                    SetXP(oPC,136000);
                    break;
                case 18:
                    SetXP(oPC,153000);
                    break;
                case 19:
                    SetXP(oPC,171000);
                    break;
                case 20:
                    SetXP(oPC,190000);
                    break;
                case 21:
                    SetXP(oPC,210000);
                    break;
                case 22:
                    SetXP(oPC,231000);
                    break;
                case 23:
                    SetXP(oPC,253000);
                    break;
                case 24:
                    SetXP(oPC,276000);
                    break;
                case 25:
                    SetXP(oPC,300000);
                    break;
                case 26:
                    SetXP(oPC,325000);
                    break;
                case 27:
                    SetXP(oPC,351000);
                    break;
                case 28:
                    SetXP(oPC,378000);
                    break;
                case 29:
                    SetXP(oPC,406000);
                    break;
                case 30:
                    SetXP(oPC,435000);
                    break;
                case 31:
                    SetXP(oPC,465000);
                    break;
                case 32:
                    SetXP(oPC,496000);
                    break;
                case 33:
                    SetXP(oPC,528000);
                    break;
                case 34:
                    SetXP(oPC,561000);
                    break;
                case 35:
                    SetXP(oPC,595000);
                    break;
                case 36:
                    SetXP(oPC,630000);
                    break;
                case 37:
                    SetXP(oPC,666000);
                    break;
                case 38:
                    SetXP(oPC,703000);
                    break;
                case 39:
                    SetXP(oPC,741000);
                    break;
                case 40:
                    SetXP(oPC,780000);
                    break;
            }
            break;
        case SELECT_GIVE_GOLD:
            GiveGoldToCreature(oPC,GetIntElement(GetDlgSelection(),LIST,oPC));
            break;
    }
}

void BuildList()
{
    object oPC = GetPcDlgSpeaker();
    DeleteList(LIST,oPC);
    int i;
    switch (GetSelector())
    {
        case SELECT_MAIN_MENU:
            ReplaceIntElement(
                AddStringElement("Set Level",LIST,oPC)-1,
                SELECT_SET_LEVEL,LIST,oPC);
            ReplaceIntElement(
                AddStringElement("Give Gold",LIST,oPC)-1,
                SELECT_GIVE_GOLD,LIST,oPC);
            break;
        case SELECT_SET_LEVEL:
            for (i=1;i<=40;i++)
            {
                ReplaceIntElement(
                    AddStringElement("Level " + IntToString(i),LIST,oPC)-1,
                    i,LIST,oPC);
            }
            break;
        case SELECT_GIVE_GOLD:
            ReplaceIntElement(
                AddStringElement("100.000 GP",LIST,oPC)-1,
                10000,LIST,oPC);
            ReplaceIntElement(
                AddStringElement("500.000 GP",LIST,oPC)-1,
                50000,LIST,oPC);
            ReplaceIntElement(
                AddStringElement("1.000.000 GP",LIST,oPC)-1,
                1000000,LIST,oPC);
            ReplaceIntElement(
                AddStringElement("5.000.000 GP",LIST,oPC)-1,
                5000000,LIST,oPC);
            break;
    }
}

void CleanUp()
{
    object oPC = GetPcDlgSpeaker();
    DeleteList(LIST,oPC);
    DeleteLocalInt(oPC,SELECTOR);
}

void main ()
{
    object oPC = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    switch(iEvent)
    {
        case DLG_INIT:
            Init();
            break;
        case DLG_PAGE_INIT:
            SetDlgPrompt("Hello, what can I do for you?");
            SetShowEndSelection(TRUE);
            BuildList();
            SetDlgResponseList(LIST,oPC);
            break;
        case DLG_SELECTION:
            HandleSelection();
            break;
        case DLG_ABORT:
        case DLG_END:
            CleanUp();
            break;
    }
}
