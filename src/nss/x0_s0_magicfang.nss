//::///////////////////////////////////////////////
//:: Magic Fang
//:: x0_s0_magicfang.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +1 enhancement bonus to attack and damage rolls.
 Also applys damage reduction +1; this allows the creature
 to strike creatures with +1 damage reduction.

 Checks to see if a valid summoned monster or animal companion
 exists to apply the effects to. If none exists, then
 the spell is wasted.

*/

void main() {
   ExecuteScript("x0_s0_gmagicfang", OBJECT_SELF);
}