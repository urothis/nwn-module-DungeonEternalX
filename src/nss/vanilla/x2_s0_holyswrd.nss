//::///////////////////////////////////////////////
//:: Holy Sword
//:: X2_S0_HolySwrd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "x2_inc_toollib"

void main() {

    if (!X2PreSpellCastCode()) return;

    //Declare major variables
    int nCasterLvl   = GetCasterLevel(OBJECT_SELF);;
    object oMyWeapon = IPGetTargetedOrEquippedMeleeWeapon();
    object oTarget   = GetItemPossessor(oMyWeapon);

    // weapon is valid
    if (!GetIsObjectValid(oMyWeapon))
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
        return;
    }
    // weapon possessor is valid
    else if (!GetIsObjectValid(oTarget))
    {
        FloatingTextStringOnCreature("Someone must be in possession of this weapon", OBJECT_SELF);
        return;
    }
    // weapon possessor is same as caster (can't cast on others)
    else if (oTarget != OBJECT_SELF)
    {
        FloatingTextStringOnCreature("You may only cast this spell on yourself.", OBJECT_SELF);
        return;
    }

    SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    int nDuration  = nCasterLvl;
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

    effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);

    if (nCasterLvl <= 20) nDamage = DAMAGE_BONUS_1d6;
    else if (nCasterLvl <= 30) nDamage = DAMAGE_BONUS_1d8;
    else  nDamage = DAMAGE_BONUS_1d10;

    effect eLink = EffectDamageIncrease(nDamage, DAMAGE_TYPE_DIVINE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}
