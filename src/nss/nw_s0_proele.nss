//::///////////////////////////////////////////////
//:: Protection from Elements
//:: NW_S0_ProEle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Offers 30 points of elemental resistance.  If 40
    points of a single elemental type is done to the
    protected creature the spell fades
*/

void main()
{
   ExecuteScript("nw_s0_enebuffer", OBJECT_SELF);
}
