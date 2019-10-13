void main() {
   object oPC = GetPCSpeaker();
   if (!GetIsObjectValid(oPC) || !GetIsPC(oPC)) return;
   string PCName = GetPCPlayerName(oPC);
   string CharName = GetName(oPC);
   AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 11.0));
   PlayVoiceChat(VOICE_CHAT_CUSS, oPC);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), oPC);
   DelayCommand(1.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), oPC));
   DelayCommand(2.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oPC));
   DelayCommand(2.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oPC));
   DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), oPC));
   DelayCommand(3.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oPC));
   // ExportSingleCharacter(oPC);
   DelayCommand(7.0, BootPC(oPC));
   DelayCommand(10.0, SetLocalString(GetModule(), "NWNX!FUNCTIONS!DELETECHAR", PCName+"?"+CharName+"?"));
}
