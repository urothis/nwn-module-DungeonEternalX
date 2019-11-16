#include "give_custom_exp"
void main()
{
    location lLocal = GetLocation(OBJECT_SELF);
    object oAttacker = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocal, FALSE, OBJECT_TYPE_CREATURE);
    object oPC;
    object oShar = GetObjectByTag("Shar");
    int iHigh = GetLocalInt(oAttacker, "iDamage");
    int iHigh2;
    while (GetIsObjectValid(oAttacker))
    {
        iHigh2 = GetLocalInt(oAttacker, "iDamage");
        if (iHigh2 >= iHigh && !GetIsDead(oAttacker))
        {
            iHigh = iHigh2;
            oPC = oAttacker;
            oAttacker = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocal, FALSE, OBJECT_TYPE_CREATURE);
        }
        oAttacker = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocal, FALSE, OBJECT_TYPE_CREATURE);
    }
    int nCount = GetLocalInt(GetModule(), "MONSTERCOUNT");
    SetLocalInt(GetModule(), "MONSTERCOUNT", --nCount);
    DEXRewardXP(GetLastKiller(), OBJECT_SELF);
    //object oSparks = CreateObject(OBJECT_TYPE_PLACEABLE, "fac_tear_get", GetLocation(OBJECT_SELF));
    //SetLocalString(oSparks, "TEARDROP", GetTag(OBJECT_SELF));
    DelayCommand(1.0,AssignCommand(oPC,ClearAllActions()));
    DelayCommand(2.5,AssignCommand(oPC,ActionJumpToObject(GetObjectByTag("sharwp"),FALSE)));
    DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), oPC));
}
