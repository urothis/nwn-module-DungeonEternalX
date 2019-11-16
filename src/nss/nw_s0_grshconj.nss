//::///////////////////////////////////////////////
//:: Greater Shadow Conjuration
//:: NW_S0_GrShConj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the opponent is clicked on Shadow Bolt is cast.
    If the caster clicks on himself he will cast
    Clarity and Mirror Image.  If they click on
    the ground they will summon a Shadow Assassin.
*/

void main () {
   ExecuteScript("nw_s0_shades", OBJECT_SELF);
}
