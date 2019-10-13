void DespawnBankGuards(object oGuard)
{
    if (GetIsObjectValid(oGuard))
    {
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oGuard);
        if (GetArea(oPC) == GetArea(oGuard)) return;
        DestroyObject(oGuard);
        DeleteLocalInt(GetModule(), "PlayersOnMap");
    }
}

void main()
{
    //give em 6 attacks a round
    //and give em see invis, and UV
    object oGuard = OBJECT_SELF;
    effect eTempEffect = EffectSeeInvisible();
    eTempEffect = EffectLinkEffects(eTempEffect, EffectUltravision());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTempEffect, OBJECT_SELF);
    SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, TRUE);
    SetBaseAttackBonus(6);
    //these bad-boys should poon....

    AssignCommand(GetArea(OBJECT_SELF), DelayCommand(300.0, DespawnBankGuards(oGuard)));
}
