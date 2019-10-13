//::///////////////////////////////////////////////
//:: NW_S0_Knock
//::
//:: Finds and opens all locks all within 5m+Skill (UMD or SpellCraft).
//::
//:://////////////////////////////////////////////


#include "nw_i0_spells"
#include "x2_inc_spellhook"
void main()
{
    // Spellcast Hook Code : If PreSpellCastHook reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    object oTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);
    effect eFail = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    float fDelay;
    int nResist;

    int nSkill = GetSkillRank(SKILL_SPELLCRAFT, OBJECT_SELF);
    int nUMD;
    int nDC;
    int nRoll;
    string sSkill = "Spellcraft";
    if(GetSpellCastItem() != OBJECT_INVALID) //Was spell cast by an item?
    {
        nUMD = GetSkillRank(SKILL_USE_MAGIC_DEVICE, OBJECT_SELF);
        if(nUMD > nSkill)
        {
            nSkill = nUMD;
            sSkill = "Use Magic Device";
        }
    }
    nSkill = nSkill + GetCasterLevel(OBJECT_SELF)/2;
    nSkill = nSkill + GetSkillRank(SKILL_OPEN_LOCK, OBJECT_SELF)/2;
    float fDistance = 5.0 + IntToFloat(nSkill); // Distance based on skill level
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId()));
        fDelay = GetRandomDelay(0.5, 1.5);
        nResist =  GetDoorFlag(oTarget,DOOR_FLAG_RESIST_KNOCK);
        //Added check for key required and removed check for plotflag.
        //The original spell would not open these locks even if they still could be
        // picked open *without* a proper key.
        if (GetLocked(oTarget))
        {
            if (!GetLockKeyRequired(oTarget) && (nResist == 0))
            {
                nDC = GetLockUnlockDC(oTarget);
                nRoll = d20();
                if(nSkill+nRoll >= nDC) //Successfully unlocked?
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    AssignCommand(oTarget, ActionUnlockObject(oTarget));
                    SendMessageToPC(OBJECT_SELF, sSkill+" : *Success* ("+IntToString(nRoll)+" + "+IntToString(nSkill)+" = "+IntToString(nRoll+nSkill)+" vs. DC: "+IntToString(nDC)+")");
                }
                else //Failed
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFail, oTarget));
                    if(nSkill+20 < nDC) //Success ever possible with skill rank?
                    {
                        SendMessageToPC(OBJECT_SELF, sSkill+" : *Success not possible* (20 + "+IntToString(nSkill)+" = "+IntToString(20+nSkill)+" vs. DC: "+IntToString(nDC)+")");
                    }
                    else //Failed Bad Roll
                    {
                        SendMessageToPC(OBJECT_SELF, sSkill+" : *Failure* ("+IntToString(nRoll)+" + "+IntToString(nSkill)+" = "+IntToString(nRoll+nSkill)+" vs. DC: "+IntToString(nDC)+")");
                    }
                }
            }
            else //Lock *requires* a special key, or blocked with local variable
            {
                SendMessageToPC(OBJECT_SELF, sSkill+" : *Success will never be possible*");
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}


