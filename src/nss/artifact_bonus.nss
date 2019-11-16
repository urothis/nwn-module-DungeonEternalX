#include "db_inc"
#include "seed_faction_inc"
#include "artifact_inc"

int EyeEffect(object oPC, int nColor=0) {
   int iGender = GetGender(oPC);
   switch(GetRacialType(oPC)) {
      case RACIAL_TYPE_DWARF:
         if (nColor==1)  {
            if (iGender==GENDER_MALE) return VFX_EYES_RED_FLAME_DWARF_MALE;
            else return VFX_EYES_RED_FLAME_DWARF_FEMALE;
         }
         if (iGender==GENDER_MALE) return VFX_EYES_GREEN_DWARF_MALE;
         else return VFX_EYES_GREEN_DWARF_FEMALE;
      case RACIAL_TYPE_ELF:
         if (nColor==1)  {
            if (iGender==GENDER_MALE) return VFX_EYES_RED_FLAME_ELF_MALE;
            else return VFX_EYES_RED_FLAME_ELF_FEMALE;
         }
         if (iGender==GENDER_MALE) return VFX_EYES_GREEN_ELF_MALE;
         else return VFX_EYES_GREEN_ELF_FEMALE;
      case RACIAL_TYPE_GNOME:
         if (nColor==1)  {
            if (iGender==GENDER_MALE) return VFX_EYES_RED_FLAME_GNOME_MALE;
            else return VFX_EYES_RED_FLAME_GNOME_FEMALE;
         }
         if (iGender==GENDER_MALE) return VFX_EYES_GREEN_GNOME_MALE;
         else return VFX_EYES_GREEN_GNOME_FEMALE;
      case RACIAL_TYPE_HALFELF:
         if (nColor==1)  {
            if (iGender==GENDER_MALE) return VFX_EYES_RED_FLAME_HALFELF_MALE;
            else return VFX_EYES_RED_FLAME_HALFELF_FEMALE;
         }
         if (iGender==GENDER_MALE) return VFX_EYES_GREEN_HALFELF_MALE;
         else return VFX_EYES_GREEN_HALFELF_FEMALE;
      case RACIAL_TYPE_HALFLING:
         if (nColor==1)  {
            if (iGender==GENDER_MALE) return VFX_EYES_RED_FLAME_HALFLING_MALE;
            else return VFX_EYES_RED_FLAME_HALFLING_FEMALE;
         }
         if (iGender==GENDER_MALE) return VFX_EYES_GREEN_HALFLING_MALE;
         else return VFX_EYES_GREEN_HALFLING_FEMALE;
      case RACIAL_TYPE_HALFORC:
         if (nColor==1)  {
            if (iGender==GENDER_MALE) return VFX_EYES_RED_FLAME_HALFORC_MALE;
            else return VFX_EYES_RED_FLAME_HALFORC_FEMALE;
         }
         if (iGender==GENDER_MALE) return VFX_EYES_GREEN_HALFORC_MALE;
         else return VFX_EYES_GREEN_HALFORC_FEMALE;
      case RACIAL_TYPE_HUMAN:
         if (nColor==1)  {
            if (iGender==GENDER_MALE) return VFX_EYES_RED_FLAME_HUMAN_MALE;
            else return VFX_EYES_RED_FLAME_HUMAN_FEMALE;
         }
         if (iGender==GENDER_MALE) return VFX_EYES_GREEN_HUMAN_MALE;
         else return VFX_EYES_GREEN_HUMAN_FEMALE;
   }
   return VFX_FNF_GAS_EXPLOSION_MIND;
}


void ApplyBonus(object oMember, object oBoss, effect eLink, int nCount) {
   //if (RemoveEffectByCreator(oMember, oBoss)) WriteTimestampedLogEntry("Removed Artifact Bonus of Boss Creator");;
   //DelayCommand(1.0f, AssignCommand(oBoss, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oMember)));
   FloatingTextStringOnCreature("+" + IntToString(nCount) + " Artifact Bonus", oMember);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_ODD), oMember);
   int nRace = GetRacialType(oMember);
   if (nCount>=6) ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(EyeEffect(oMember, 1)), oMember);
   else if (nCount>3) ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(EyeEffect(oMember, 0)), oMember);
}

void main () {
   object oBoss = OBJECT_SELF; //GetObjectByTag(sBossTag);
   string sFAID = GetLocalString(GetArea(oBoss), "FAID");
   int nCount = SDB_FactionGetArtifactCount(sFAID);
   effect eLink;
   /*eLink = EffectRegenerate(nCount * 10, 60.0);
   if (nCount>5) {
      eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nCount));
      eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, nCount));
   }
   eLink = ExtraordinaryEffect(eLink);*/
   object oMember = GetLocalObject(oBoss, "MEMBER");
   if (oMember!=OBJECT_INVALID) { // SINGLE PLAYER RESTED
      ApplyBonus(oMember, oBoss, eLink, nCount);
      DeleteLocalObject(oBoss, "MEMBER");
      return;
   }
   oMember = GetFirstPC();
   while (GetIsObjectValid(oMember)) {
      string stFAID = SDB_GetFAID(oMember);
      if (sFAID == stFAID) {
         ApplyBonus(oMember, oBoss, eLink, nCount);
      }
      oMember = GetNextPC();
   }
}
