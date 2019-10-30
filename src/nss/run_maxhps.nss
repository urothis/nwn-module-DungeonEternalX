#include "nwnx_creature"

void main()
{
    object oPC = GetPCSpeaker();
    int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) + GetLevelByPosition(3, oPC);

    if (GetIsPC(oPC) && GetIsObjectValid(oPC) && !GetIsDM(oPC))
    {
        //HP is already maxed
        if (nLevel < 2)
        {
            SendMessageToPC(oPC, "You are not high enough level to set your HP to max.");
            return;
        }

        int x = 1;
        for (x; x <= nLevel; x++)
        {
            NWNX_Creature_SetMaxHitPointsByLevel(oPC, x, NWNX_Creature_GetMaxHitPointsByLevel(oPC, x));
        }


        ExportSingleCharacter(oPC);
    }
}

/*

