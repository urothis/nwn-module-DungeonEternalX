#include "mk_inc_body"

void main()
{
    object oPC =GetPCSpeaker();
    MK_NewBodyPart(oPC, MK_CRAFTBODY_PREV);
}
