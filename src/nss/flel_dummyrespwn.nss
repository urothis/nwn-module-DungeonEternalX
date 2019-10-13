void CreateDummy(location lLocation,string sTag,string sResRef)
{
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2),lLocation);
    CreateObject(OBJECT_TYPE_CREATURE,sResRef,lLocation,TRUE,sTag);
}


void main()
{
    float fRespawnTime = 10.0;
    string sMyResRef = GetResRef(OBJECT_SELF);
    string sMyTag = GetTag(OBJECT_SELF);
    location lMyLocation = GetLocation(OBJECT_SELF);
    AssignCommand(GetArea(OBJECT_SELF), DelayCommand(fRespawnTime, CreateDummy(lMyLocation, sMyTag,sMyResRef)));
}
