//::///////////////////////////////////////////////
//:: x1_act_harper2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates the Eagle's Splendor.
    Take the gold.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
/*
  Flel's Greater Eagle's Splendor Potion (flel_it_greag see also x1_act_harper2)
  -Aquired through harper scout craft potion feat
  -Adds 1d3+1 to charisma, +2 to all saves and increases heal skill by 20%
  -The duration is 5 Hours.
*/
void main()
{
    CreateItemOnObject("flel_it_greag", GetPCSpeaker(),10);
    TakeGoldFromCreature(10000, GetPCSpeaker(), TRUE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetPCSpeaker());

}
