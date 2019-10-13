#include "X0_I0_SPELLS"
#include "chainwonder_inc"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "USED")) return;
    SetLocalInt(OBJECT_SELF, "USED", 1);
    object oPC = GetLastAttacker();
    SendMessageToPC(oPC, "You attacked the chain!");

    int nDamage1, nDamage2, nDamage3, nDamage4;
    float fDelay;
    effect eExplode = EffectVisualEffect(464);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVis2 = EffectVisualEffect(VFX_IMP_ACID_L);
    effect eVis3 = EffectVisualEffect(VFX_IMP_SONIC);

    int nSpellDC = 50;

    effect eDam1, eDam2, eDam3, eDam4, eDam5, eKnock;
    eKnock= EffectKnockdown();
    location lTarget = GetLocation(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    int nTotalDamage;
    while (GetIsObjectValid(oTarget))
    {
        fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20 + 0.5f;
        //Roll damage for each target
        nDamage1 = d6(6);
        nDamage2 = d6(6);
        nDamage3 = d6(6);
        nDamage4 = d6(6);

        nTotalDamage = nDamage1+nDamage2+nDamage3+nDamage4;

        if (MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellDC, SAVING_THROW_TYPE_SPELL, oPC, fDelay)>0)
        {
            nDamage1 /=2;
            nDamage2 /=2;
            nDamage3 /=2;
            nDamage4 /=2;
        }

        nTotalDamage = nDamage1+nDamage2+nDamage3+nDamage4;

        eDam1 = EffectDamage(nDamage1, DAMAGE_TYPE_ACID);
        eDam2 = EffectDamage(nDamage2, DAMAGE_TYPE_POSITIVE);
        eDam3 = EffectDamage(nDamage3, DAMAGE_TYPE_NEGATIVE);
        eDam4 = EffectDamage(nDamage4, DAMAGE_TYPE_SONIC);
        if (nTotalDamage > 0)
        {
            if (nTotalDamage > 50)
            {
                AssignCommand(GetModule(), DelayCommand(fDelay+0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0f)));
            }
            // Apply effects to the currently selected target.
            AssignCommand(GetModule(), DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam1, oTarget)));
            AssignCommand(GetModule(), DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget)));
            AssignCommand(GetModule(), DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam3, oTarget)));
            AssignCommand(GetModule(), DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam4, oTarget)));
            AssignCommand(GetModule(), DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget)));
            AssignCommand(GetModule(), DelayCommand(fDelay+0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget)));
            AssignCommand(GetModule(), DelayCommand(fDelay+0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget)));
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
    location lChain = GetLocation(OBJECT_SELF);
    AssignCommand(GetModule(), DelayCommand(60.0f, CreateChain(lChain)));
    DestroyObject(OBJECT_SELF);
}

