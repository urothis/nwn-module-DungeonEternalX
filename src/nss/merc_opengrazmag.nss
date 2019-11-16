/* does a persuade check. If successful, PC gets to use the store
 * otherwise, PC is killed. */
void main() {
  object oPC = GetLastSpeaker();
  object oStore = GetNearestObjectByTag(GetTag(OBJECT_SELF));

  int nSkill = GetSkillRank(SKILL_PERSUADE, oPC) + d20();
//  int nSkillRoll = GetIsSkillSuccessful(oPC, SKILL_PERSUADE, 20);
  if (nSkill >= 20) {
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
      OpenStore(oStore, oPC);
    else
      ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
  } else {
     SpeakString("You fail to impress me. Go away.");
  }
}
