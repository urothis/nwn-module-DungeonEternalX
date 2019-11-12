// player object stuff

void SetEntryHidden(object oObject, int nIndex) {
    SetLocalInt(oObject,"hide_convo_entry_" + IntToString(nIndex),1);
}

// structs bb
struct Entry{
    int index;
    string text;
    string script;
    string link;
};

struct Entry convoEntry(int nIndex, string sText, string sScript, string sPageLink){
    struct Entry entry;
    entry.index = nIndex;
    entry.text = sText;
    entry.script = sScript;
    entry.link = sPageLink;
    return entry;
}

struct Page{
    string header;
    string entry1text;
    string entry1script;
    string entry1link;
    string entry2text;
    string entry2script;
    string entry2link;
    string entry3text;
    string entry3script;
    string entry3link;
    string entry4text;
    string entry4script;
    string entry4link;
    string entry5text;
    string entry5script;
    string entry5link;
    string entry6text;
    string entry6script;
    string entry6link;
};

struct Page PageEntry(struct Entry entry1, struct Entry entry2, struct Entry entry3, struct Entry entry4, struct Entry entry5, struct Entry entry6, string sHeader = ""){
    struct Page page;
    page.header = sHeader;
    page.entry1text = entry1.text;
    page.entry1script = entry1.script;
    page.entry1link = entry1.link;
    page.entry2text = entry2.text;
    page.entry2script = entry1.script;
    page.entry2link = entry1.link;
    page.entry3text = entry3.text;
    page.entry3script = entry1.script;
    page.entry3link = entry1.link;
    page.entry4text = entry4.text;
    page.entry4script = entry1.script;
    page.entry4link = entry1.link;
    page.entry5text = entry5.text;
    page.entry5script = entry1.script;
    page.entry5link = entry1.link;
    page.entry6text = entry6.text;
    page.entry6script = entry1.script;
    page.entry6link = entry1.link;
    return page;
}

void SetPageText(struct Page convo, object oObject) {
    // not pretty, but it should work
    SetCustomToken(4200,convo.header);

    string text1 = convo.entry1text;
    if(text1 == "") SetEntryHidden(oObject,1);
    SetCustomToken(4201,text1);

    string text2 = convo.entry2text;
    if(text2 == "") SetEntryHidden(oObject,2);
    SetCustomToken(4202,text2);

    string text3 = convo.entry3text;
    if(text3 == "") SetEntryHidden(oObject,3);
    SetCustomToken(4203,text3);

    string text4 = convo.entry4text;
    if(text4 == "") SetEntryHidden(oObject,4);
    SetCustomToken(4204,text4);

    string text5 = convo.entry5text;
    if(text5 == "") SetEntryHidden(oObject,5);
    SetCustomToken(4205,text5);

    string text6 = convo.entry6text;
    if(text6 == "") SetEntryHidden(oObject,6);
    SetCustomToken(4206,text6);
}