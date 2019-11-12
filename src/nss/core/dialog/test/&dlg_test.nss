#include "conv_inc"

void main() {
    object oPC;
    object oConversationPartner;
    int Caller_Type = GetObjectType(OBJECT_SELF);
    if (Caller_Type == OBJECT_TYPE_CREATURE) {
        oPC = GetLastSpeaker();
        oConversationPartner = OBJECT_SELF;
    } else {
        oPC = GetLastUsedBy();
        oConversationPartner = oPC;
    }

    struct Entry entry1,entry2,entry3,entry4,entry5,entry6;

    // get the player specific object
    // this won't compile until uuid is hooked in x64
    // object oObject = getPersistantPlayerObject(oPC, "convo")

    // all of this above is shit we will have in every node click and conversation start
    ////////////////////
    // template start //
    ////////////////////

    // define header / what the object/item is saying to player
    string sHeader = "This is a test conversation!";


    // defining text entries and the page to link to and what script to trigger
    entry1 = convoEntry(1, "trigger dlg_test2", "some_script", "dlg_page_test2");
    entry2 = convoEntry(1, "trigger dlg_test3", "some_other_script", "dlg_page_test3");

    // easy way to hide a previously set entry
    if (GetIsDM(oPC)) SetEntryHidden(oPC, 1); // if oPC is dm, hide entry 1;

    //////////////////
    // template end //
    //////////////////
    // this should apply everything we designed earlier
    struct Page page = PageEntry(entry1,entry2,entry3,entry4,entry5,entry6, sHeader);

    SetPageText(page, oPC); // this wont use oPC, testing, just waiting for db
}