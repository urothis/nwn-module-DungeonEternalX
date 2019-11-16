// Make the placeable countdown for duel
void main()
{
    if (GetLocalInt(GetArea(OBJECT_SELF),"COUNTING_DOWN") != 1)
    {
        SetLocalInt(GetArea(OBJECT_SELF),"COUNTING_DOWN", 1);
        DelayCommand(5.0, DeleteLocalInt(GetArea(OBJECT_SELF),"COUNTING_DOWN"));
        // Countdown from 5 and say go
        PlaySound("countdown");
        SpeakString("5", TALKVOLUME_TALK);
        PlaySound("as_cv_barglass1");
        DelayCommand(1.0, SpeakString("4", TALKVOLUME_TALK));
        DelayCommand(1.0, PlaySound("as_cv_barglass1"));
        DelayCommand(2.0, SpeakString("3", TALKVOLUME_TALK));
        DelayCommand(2.0, PlaySound("as_cv_barglass1"));
        DelayCommand(3.0, SpeakString("2", TALKVOLUME_TALK));
        DelayCommand(3.0, PlaySound("as_cv_barglass1"));
        DelayCommand(4.0, SpeakString("1", TALKVOLUME_TALK));
        DelayCommand(4.0, PlaySound("as_cv_barglass1"));
        DelayCommand(5.0, SpeakString("GO!", TALKVOLUME_TALK));
        DelayCommand(5.0, PlaySound("as_cv_gongring2"));
    }
    else SpeakString("You must wait untill the current countdown is completed!");
}

