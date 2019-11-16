void main()
{
    string sTag = GetTag(OBJECT_SELF);

    if (sTag == "EVENT_CLANCY")
    {
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneParalyze(), OBJECT_SELF));
    }

}
