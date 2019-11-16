#include "mk_inc_body"

void main()
{
    object oPC = GetPCSpeaker();

    if (MK_GetBodyPartToBeModified(oPC)==MK_CRAFTBODY_SAVERESTORE)
    {
        MK_RestoreBody(oPC, 0);
    }
    else
    {
        MK_RestoreBodyPart(oPC);
    }
    MK_CleanUpBodyPart(oPC);
}
