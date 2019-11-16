//::///////////////////////////////////////////////
//:: Resist Elements
//:: NW_S0_ResEle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Offers 20 points of elemental resistance.  If 30
    points of a single elemental type is done to the
    protected creature the spell fades
*/

void main()
{
   ExecuteScript("nw_s0_enebuffer", OBJECT_SELF);
}
