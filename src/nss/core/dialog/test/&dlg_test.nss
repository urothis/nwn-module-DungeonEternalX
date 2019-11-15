#include "_dlg_inc"

void main() {
    object oPC = OBJECT_SELF;
    object oNPC = GetLocalObject(oPC, "convo_npc");
    int nPage = GetLocalInt(oPC, "convo_page");
    //////
    // required starter
    //////


    // set title of page
    string sTitle = "";

    // do logic for entries below

    DLG_addEntry(oPC,"text for entry");


    //////
    // required ender
    //////
    SetPageText(oPC, sTitle, nPage);
}