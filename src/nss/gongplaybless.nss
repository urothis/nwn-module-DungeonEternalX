void main()
{
PlaySound("as_cv_gongring2");
object oPC = GetLastUsedBy();
int cSpell = SPELL_BLESS;
int bCheat = 1;
int bInstantSpell = 1;
string sSpeakString = "You feel the blessings of the gods upon you.";
{
ActionSpeakString(sSpeakString);
ActionCastSpellAtObject(cSpell, oPC, bCheat, bInstantSpell);
}
}
