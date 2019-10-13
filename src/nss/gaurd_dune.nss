void main()
{
    object oPercep = GetLastPerceived();
    if (GetHitDice(oPercep) > 5) return;
    string sSpeak = "This area is for experienced warriors only, new players should head *North* to fight Undead or *West* to fight Goblins and Lizards.";
    PlayVoiceChat(VOICE_CHAT_STOP, OBJECT_SELF);
    SpeakString(sSpeak, TALKVOLUME_TALK);


}
