void BushPicking(object oPC, object oBush, string sName)
{
    if (!GetIsObjectValid(oPC) || !GetIsObjectValid(oBush)) return;

    if (GetLocalLocation(oBush, "BUSH_PLAYER_LOC") == GetLocation(oPC))
    {
        int nCnt = 1 + d2();
        object oItem;
        string sTag = GetTag(oBush);
        while(nCnt > 0)
        {
            oItem = CreateItemOnObject("picked_plant", oPC, 1, sTag);
            SetName(oItem, sName);
            nCnt--;
        }
        DestroyObject(oBush);
    }
    else return;
}

void main()
{
    object oPC = GetLastUsedBy();
    object oBush = OBJECT_SELF;
    string sName = GetName(oBush);

    if (sName == "Planted Seeds")
    {
        FloatingTextStringOnCreature("You can't pick fresh planted seeds", oPC, FALSE);
        return;
    }
    DelayCommand(1.0, SetLocalLocation(oBush, "BUSH_PLAYER_LOC", GetLocation(oPC)));
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 6.0));
    DelayCommand(5.0, BushPicking(oPC, oBush, sName));
}
