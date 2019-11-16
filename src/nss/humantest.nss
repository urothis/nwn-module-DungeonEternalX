void main()
{
object oPC   = GetPCSpeaker();
int nAppearance;
{
 nAppearance = GetAppearanceType(oPC);
SetLocalInt(oPC, "TRANSFORMED", 1);
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_HUMAN);
}
}
