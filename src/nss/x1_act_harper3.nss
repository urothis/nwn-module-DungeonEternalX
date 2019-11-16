//::///////////////////////////////////////////////
//:: x1_act_harper3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates the Cat's Grace.
    Take the gold.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
/*
  Flel's Greater Cats Grace Potion (flel_it_grcat see also x1_act_harper3)
  -Aquired through harper scout craft potion feat
  -Adds 1d3 dexterity, +1 ab and +1 to ac
  -The duration is 5 Hours.
*/
void main()
{
    CreateItemOnObject("flel_it_grcat", GetPCSpeaker(),10);
    TakeGoldFromCreature(10000, GetPCSpeaker(), TRUE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetPCSpeaker());
}
