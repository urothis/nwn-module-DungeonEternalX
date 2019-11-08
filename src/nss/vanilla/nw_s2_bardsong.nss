//::///////////////////////////////////////////////
//:: Bard Song
//:: NW_S2_BardSong
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spells applies bonuses to all of the
    bard's allies within 30ft for a set duration of
    10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller Oct 1, 2003
/*
bugfix by Kovi 2002.07.30
- loosing temporary hp resulted in loosing the other bonuses
*/

#include "x0_i0_spells"

void main()
{
    if (GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }
    string sTag = GetTag(OBJECT_SELF);

    if (sTag == "x0_hen_dee" || sTag == "x2_hen_deekin")
    {
        // * Deekin has a chance of singing a doom song
        // * same effect, better tune
        if (Random(100) + 1 > 80)
        {
            // the Xp2 Deekin knows more than one doom song
            if (d3() ==1 && sTag == "x2_hen_deekin")
            {
                DelayCommand(0.0, PlaySound("vs_nx2deekM_050"));
            }
            else
            {
                DelayCommand(0.0, PlaySound("vs_nx0deekM_074"));
                DelayCommand(5.0, PlaySound("vs_nx0deekM_074"));
            }
        }
    }


    //Declare major variables
    int nLevel = GetLevelByClass(CLASS_TYPE_BARD);
    int nRanks = GetSkillRank(SKILL_PERFORM);
    int nChr = GetAbilityModifier(ABILITY_CHARISMA);
    int nPerform = nRanks;
    int nDuration = 10; //+ nChr;

    effect eAttack;
    effect eDamage;
    effect eWill;
    effect eFort;
    effect eReflex;
    effect eHP;
    effect eAC;
    effect eSkill;
    effect eAttack2;
    effect eDamage2;
    effect eWill2;
    effect eFort2;
    effect eReflex2;
    effect eHP2;
    effect eAC2;
    effect eSkill2;

    int nAttack;
    int nDamage;
    int nWill;
    int nFort;
    int nReflex;
    int nHP;
    int nAC;
    int nSkill;
    int nAttack2;
    int nDamage2;
    int nWill2;
    int nFort2;
    int nReflex2;
    int nHP2;
    int nAC2;
    int nSkill2;
    //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nDuration *= 10;
    }

    // lingering song
    if(GetHasFeat(424)) // lingering song
    {
        nDuration += 10;
    }

    //SpeakString("Level: " + IntToString(nLevel) + " Ranks: " + IntToString(nRanks));
    if(nPerform >= 100 && nLevel >= 30)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 48;
                        nAC = 7;
                        nSkill = 19;
                        nAttack2 = 2;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 48;
                        nAC2 = 4;
                        nSkill2 = 4;
                    }
                    else if(nPerform >= 95 && nLevel >= 29)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 46;
                        nAC = 6;
                        nSkill = 18;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 46;
                        nAC2 = 3;
                        nSkill2 = 3;
                    }
                    else if(nPerform >= 90 && nLevel >= 28)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 44;
                        nAC = 6;
                        nSkill = 17;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 44;
                        nAC2 = 3;
                        nSkill2 = 3;
                    }
                    else if(nPerform >= 85 && nLevel >= 27)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 42;
                        nAC = 6;
                        nSkill = 16;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 42;
                        nAC2 = 3;
                        nSkill2 = 3;
                    }
                    else if(nPerform >= 80 && nLevel >= 26)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 40;
                        nAC = 6;
                        nSkill = 15;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 40;
                        nAC2 = 3;
                        nSkill2 = 3;
                    }
                    else if(nPerform >= 75 && nLevel >= 25)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 38;
                        nAC = 6;
                        nSkill = 14;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 38;
                        nAC2 = 3;
                        nSkill2 = 3;
                    }
                    else if(nPerform >= 70 && nLevel >= 24)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 36;
                        nAC = 5;
                        nSkill = 13;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 36;
                        nAC2 = 2;
                        nSkill2 = 2;
                    }
                    else if(nPerform >= 65 && nLevel >= 23)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 34;
                        nAC = 5;
                        nSkill = 12;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 34;
                        nAC2 = 2;
                        nSkill2 = 2;
                    }
                    else if(nPerform >= 60 && nLevel >= 22)
                   {
                       nAttack = 2;
                       nDamage = 3;
                       nWill = 3;
                       nFort = 2;
                       nReflex = 2;
                       nHP = 32;
                       nAC = 5;
                       nSkill = 11;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 32;
                        nAC2 = 2;
                        nSkill2 = 2;
                   }
                   else if(nPerform >= 55 && nLevel >= 21)
                   {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 30;
                        nAC = 5;
                        nSkill = 9;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 30;
                        nAC2 = 2;
                        nSkill2 = 2;
                   }
                   else if(nPerform >= 50 && nLevel >= 20)
                   {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 28;
                        nAC = 5;
                        nSkill = 8;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 28;
                        nAC2 = 2;
                        nSkill2 = 2;
                   }
                   else if(nPerform >= 45 && nLevel >= 19)
                   {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 26;
                        nAC = 5;
                        nSkill = 7;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 26;
                        nAC2 = 2;
                        nSkill2 = 2;
                    }
                    else if(nPerform >= 40 && nLevel >= 18)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 24;
                        nAC = 5;
                        nSkill = 6;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 24;
                        nAC2 = 2;
                        nSkill2 = 2;
                    }
                    else if(nPerform >= 35 && nLevel >= 17)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 22;
                        nAC = 5;
                        nSkill = 5;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 22;
                        nAC2 = 2;
                        nSkill2 = 2;
                    }
                    else if(nPerform >= 30 && nLevel >= 16)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 3;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 20;
                        nAC = 5;
                        nSkill = 4;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 3;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 20;
                        nAC2 = 2;
                        nSkill2 = 2;
                    }
                    else if(nPerform >= 24 && nLevel >= 15)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 2;
                        nFort = 2;
                        nReflex = 2;
                        nHP = 16;
                        nAC = 4;
                        nSkill = 3;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 2;
                        nFort2 = 2;
                        nReflex2 = 2;
                        nHP2 = 16;
                        nAC2 = 1;
                        nSkill2 = 1;
                    }
                    else if(nPerform >= 21 && nLevel >= 14)
                    {
                        nAttack = 2;
                        nDamage = 3;
                        nWill = 1;
                        nFort = 1;
                        nReflex = 1;
                        nHP = 16;
                        nAC = 3;
                        nSkill = 2;
                        nAttack2 = 1;
                        nDamage2 = 3;
                        nWill2 = 1;
                        nFort2 = 1;
                        nReflex2 = 1;
                        nHP2 = 16;
                        nAC2 = 1;
                        nSkill2 = 1;
                    }
                    else if(nPerform >= 18 && nLevel >= 11)
                    {
                        nAttack = 2;
                        nDamage = 2;
                        nWill = 1;
                        nFort = 1;
                        nReflex = 1;
                        nHP = 8;
                        nAC = 2;
                        nSkill = 2;
                        nAttack2 = 1;
                        nDamage2 = 2;
                        nWill2 = 1;
                        nFort2 = 1;
                        nReflex2 = 1;
                        nHP2 = 8;
                        nAC2 = 1;
                        nSkill2 = 1;
                    }
                    else if(nPerform >= 15 && nLevel >= 8)
                    {
                        nAttack = 2;
                        nDamage = 2;
                        nWill = 1;
                        nFort = 1;
                        nReflex = 1;
                        nHP = 8;
                        nAC = 0;
                        nSkill = 1;
                        nAttack2 = 1;
                        nDamage2 = 2;
                        nWill2 = 1;
                        nFort2 = 1;
                        nReflex2 = 1;
                        nHP2 = 8;
                        nAC2 = 0;
                        nSkill2 = 1;
                    }
                    else if(nPerform >= 12 && nLevel >= 6)
                    {
                        nAttack = 1;
                        nDamage = 2;
                        nWill = 1;
                        nFort = 1;
                        nReflex = 1;
                        nHP = 0;
                        nAC = 0;
                        nSkill = 1;
                        nAttack2 = 1;
                        nDamage2 = 2;
                        nWill2 = 1;
                        nFort2 = 1;
                        nReflex2 = 1;
                        nHP2 = 0;
                        nAC2 = 0;
                        nSkill2 = 1;
                    }
                    else if(nPerform >= 9 && nLevel >= 3)
                    {
                        nAttack = 1;
                        nDamage = 2;
                        nWill = 1;
                        nFort = 1;
                        nReflex = 0;
                        nHP = 0;
                        nAC = 0;
                        nSkill = 0;
                        nAttack2 = 1;
                        nDamage2 = 2;
                        nWill2 = 1;
                        nFort2 = 1;
                        nReflex2 = 0;
                        nHP2 = 0;
                        nAC2 = 0;
                        nSkill2 = 0;
                    }
                    else if(nPerform >= 6 && nLevel >= 2)
                    {
                        nAttack = 1;
                        nDamage = 1;
                        nWill = 1;
                        nFort = 0;
                        nReflex = 0;
                        nHP = 0;
                        nAC = 0;
                        nSkill = 0;
                        nAttack2 = 1;
                        nDamage2 = 1;
                        nWill2 = 1;
                        nFort2 = 0;
                        nReflex2 = 0;
                        nHP2 = 0;
                        nAC2 = 0;
                        nSkill2 = 0;
                    }
                    else if(nPerform >= 3 && nLevel >= 1)
                    {
                        nAttack = 1;
                        nDamage = 1;
                        nWill = 0;
                        nFort = 0;
                        nReflex = 0;
                        nHP = 0;
                        nAC = 0;
                        nSkill = 0;
                        nAttack2 = 1;
                        nDamage2 = 1;
                        nWill2 = 0;
                        nFort2 = 0;
                        nReflex2 = 0;
                        nHP2 = 0;
                        nAC2 = 0;
                        nSkill2 = 0;
                    }

    effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);

    eAttack = EffectAttackIncrease(nAttack);
    eAttack2 = EffectAttackIncrease(nAttack2);
    eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING);
    eDamage2 = EffectDamageIncrease(nDamage2, DAMAGE_TYPE_BLUDGEONING);
    effect eLink = EffectLinkEffects(eAttack, eDamage);
    effect eLink2 = EffectLinkEffects(eAttack2, eDamage2);

    if(nWill > 0)
    {
        eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, nWill);
        eLink = EffectLinkEffects(eLink, eWill);
    }
    if(nWill2 > 0)
    {
        eWill2 = EffectSavingThrowIncrease(SAVING_THROW_WILL, nWill2);
        eLink2 = EffectLinkEffects(eLink2, eWill2);
    }
    if(nFort > 0)
    {
        eFort = EffectSavingThrowIncrease(SAVING_THROW_FORT, nFort);
        eLink = EffectLinkEffects(eLink, eFort);
    }
    if(nFort2 > 0)
    {
        eFort2 = EffectSavingThrowIncrease(SAVING_THROW_FORT, nFort2);
        eLink2 = EffectLinkEffects(eLink2, eFort2);
    }
    if(nReflex > 0)
    {
        eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nReflex);
        eLink = EffectLinkEffects(eLink, eReflex);
    }
    if(nReflex2 > 0)
    {
        eReflex2 = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nReflex2);
        eLink2 = EffectLinkEffects(eLink2, eReflex2);
    }
    if(nHP > 0)
    {
        //SpeakString("HP Bonus " + IntToString(nHP));
        eHP = EffectTemporaryHitpoints(nHP);
//        eLink = EffectLinkEffects(eLink, eHP);
    }
    if(nHP2 > 0)
    {
        //SpeakString("HP Bonus " + IntToString(nHP));
        eHP2 = EffectTemporaryHitpoints(nHP2);
//        eLink = EffectLinkEffects(eLink, eHP);
    }
    if(nAC > 0)
    {
        eAC = EffectACIncrease(nAC, AC_DODGE_BONUS);
        eLink = EffectLinkEffects(eLink, eAC);
    }
    if(nAC2 > 0)
    {
        eAC2 = EffectACIncrease(nAC2, AC_DODGE_BONUS);
        eLink2 = EffectLinkEffects(eLink2, eAC2);
    }
    if(nSkill > 0)
    {
        //nSkill = nSkill/2;
        eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nSkill);
        eLink = EffectLinkEffects(eLink, eSkill);
    }
    if(nSkill2 > 0)
    {
        //nSkill = nSkill/2;
        eSkill2 = EffectSkillIncrease(SKILL_ALL_SKILLS, nSkill2);
        eLink2 = EffectLinkEffects(eLink2, eSkill2);
    }
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink2 = EffectLinkEffects(eLink2, eDur);

    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    eHP = ExtraordinaryEffect(eHP);
    eLink = ExtraordinaryEffect(eLink);

    eHP2 = ExtraordinaryEffect(eHP2);
    eLink2 = ExtraordinaryEffect(eLink2);

    while(GetIsObjectValid(oTarget))
    {
        if(!GetHasFeatEffect(FEAT_BARD_SONGS, oTarget) && !GetHasSpellEffect(GetSpellId(),oTarget))
        {
             // * GZ Oct 2003: If we are silenced, we can not benefit from bard song
             if (!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
             {
                if(oTarget == OBJECT_SELF)
                {
                    effect eHealDecrease = EffectSkillDecrease(SKILL_HEAL, nSkill);
                    effect eLinkBard = EffectLinkEffects(eLink, eVis);
                    if (GetLevelByClass(CLASS_TYPE_PALEMASTER, OBJECT_SELF)>9)
                    {
                        eLinkBard = EffectLinkEffects(eHealDecrease, eLinkBard);
                    }
                    eLinkBard = ExtraordinaryEffect(eLinkBard);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, RoundsToSeconds(nDuration));
                    if (nHP > 0)
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds(nDuration));
                    }
                }
                else if(GetFactionEqual(oTarget))
                {

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));
                    if (nHP2 > 0)
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP2, oTarget, RoundsToSeconds(nDuration));
                    }
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 9.144, GetLocation(OBJECT_SELF)); // 30 feet is 9.144 m, not 10 m [RedACE]
    }
}

