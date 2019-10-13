int StartingConditional() {
   string sAlign = "";
   int nWork = GetAlignmentLawChaos(GetPCSpeaker());
   if (nWork==ALIGNMENT_LAWFUL)  sAlign="Lawful ";
   if (nWork==ALIGNMENT_CHAOTIC) sAlign="Chaotic ";
   if (nWork==ALIGNMENT_NEUTRAL) sAlign="Neutral ";
   nWork = GetAlignmentGoodEvil(GetPCSpeaker());
   if (nWork==ALIGNMENT_EVIL)    sAlign+="Evil";
   if (nWork==ALIGNMENT_GOOD)    sAlign+="Good";
   if (nWork==ALIGNMENT_NEUTRAL) sAlign+="Neutral";
   if (sAlign=="Neutral Neutral") sAlign="True Neutral";
   SetCustomToken(12300, sAlign);
    return TRUE;
}
