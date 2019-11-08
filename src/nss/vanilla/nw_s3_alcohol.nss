//::///////////////////////////////////////////////
//:: NW_S3_Alcohol.nss
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
    //int nSpell = GetSpellId() - 405; // 406=beer, 407=wine, 408=spirits
    object oTarget = GetSpellTargetObject();

    if (GetTag(GetSpellCastItem()) == "POT_FLAMING_BRAZIER")
    {
        DoFlamingBrazier(oTarget);
    }
}
