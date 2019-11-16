void main() {
    if(!GetLocalInt(OBJECT_SELF, "InUse")) {
        SetLocalInt(OBJECT_SELF, "InUse", 1);
        DelayCommand(0.0, SpeakString("5"));
        DelayCommand(1.0, SpeakString("4"));
        DelayCommand(2.0, SpeakString("3"));
        DelayCommand(3.0, SpeakString("2"));
        DelayCommand(4.0, SpeakString("1"));
        DelayCommand(5.0, SpeakString("GO!"));
        DelayCommand(5.0, PlaySound("as_cv_gongring2"));
        DelayCommand(5.5, DeleteLocalInt(OBJECT_SELF, "InUse"));
    }
}
