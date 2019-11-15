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

void SetPageText(object oPC, string sTitle, int nOffset = 0) {
    int nEntryCount = NWNX_Data_Array_Size(3, oPC, "convo");
    int nTopIndex = nOffset * 6;
    int nBotIndex = nTop + 6;
    int nToken = 4201;

    // set the title
    SetCustomToken(nToken,sTitle);

    string sText;
    int nCount;
    int i = nTopIndex;
    while (i < nBotIndex) {
        nToken++;        
        // every convo position will be iterated here
        sText = NWNX_Data_Array_At_Str(oPC,"conv",i);        
        if (sText != "") SetCustomToken(nToken,sText);
        else SetEntryHidden(oObject,nCount);        
        // for all 6 indexes
        nCount++;
        i++;
    }

    // previous
    if (!nOffset) SetEntryHidden(oObject,7);
    else SetCustomToken(4207,"Prev");

    // next
    if (NWNX_Data_Array_At_Str(oPC,"conv",i) != "") SetEntryHidden(oObject,8);
    else SetCustomToken(4208,"Next");

    // exit
    SetCustomToken(4209,"Exit");
}
