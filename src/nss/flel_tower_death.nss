void CreatePortal(location lLocation,string sTag,string sResRef)
{
    CreateObject(OBJECT_TYPE_PLACEABLE,sResRef,lLocation,TRUE,sTag);
}

void main()
{
    string sMyResRef = "flel_port_bind";
    string sMyTag = "FLEL_PORT_BIND";
    location lMyLocation = GetLocation(GetWaypointByTag("FLEL_TOWER_BINDPORT"));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_IMPLOSION),lMyLocation);
    AssignCommand(GetArea(OBJECT_SELF), DelayCommand(1.5, CreatePortal(lMyLocation, sMyTag,sMyResRef)));
}
