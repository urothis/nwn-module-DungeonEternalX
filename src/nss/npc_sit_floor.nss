void main()
{
    string sMyTagName = GetTag(OBJECT_SELF);
    string sFloorTag = "FLOOR_" + sMyTagName;
    object oSitplace = GetNearestObject();
    if (GetTag (oSitplace) == sFloorTag)
        {
            int nChair = 1;
            object oChair;
            oChair = GetNearestObjectByTag(sFloorTag, OBJECT_SELF, nChair);
            ActionDoCommand( ActionPlayAnimation( ANIMATION_LOOPING_SIT_CROSS,0.0,4000.0) ) ;
}
}
