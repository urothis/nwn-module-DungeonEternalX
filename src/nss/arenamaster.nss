
void main()
{
    int nGold = 50;
    object oPC = GetPCSpeaker();
    if (GetGold(oPC)>=nGold)
    {
        TakeGoldFromCreature(nGold, oPC, TRUE);
        object oTarget = GetWaypointByTag ("TELE_Arena");
        ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_GLOBE_INVULNERABILITY), oPC);
        AssignCommand (oPC,JumpToObject(oTarget));
    }
    else
    ActionSpeakString("Sorry, you cannot afford to see these wonders!");
}
