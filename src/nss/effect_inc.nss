void StripAllEffects(object oTarget);
int RemoveEffectBySubType(object oPC, int nEffectType, int nEffectSubType=-1, object oCreator=OBJECT_INVALID);
int RemoveEffectByDurationType(object oPC, int nEffectType, int nEffectDurationType);
int RemoveEffectByCreator(object oPC, object oCreator);



void StripAllEffects(object oTarget)
{
    effect eEffect = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEffect))
    {
        RemoveEffect(oTarget, eEffect);
        eEffect = GetNextEffect(oTarget);
    }
}

int RemoveEffectBySubType(object oPC, int nEffectType, int nEffectSubType=-1, object oCreator=OBJECT_INVALID)
{
   int bRemove = FALSE;
   effect eSearch = GetFirstEffect(oPC);
   while (GetIsEffectValid(eSearch))
   { //Check to see if the effect matches a particular type defined below
      if (GetEffectType(eSearch)==nEffectType)
      {
         if (nEffectSubType==-1 || GetEffectSubType(eSearch)==nEffectSubType)
         {
            if (oCreator==OBJECT_INVALID)
            {
               RemoveEffect(oPC, eSearch);
               bRemove = TRUE;
            }
            else
            {
               if (GetEffectCreator(eSearch)==oCreator)
               {
                  RemoveEffect(oPC, eSearch);
                  bRemove = TRUE;
               }
            }
         }
      }
      eSearch = GetNextEffect(oPC);
   }
   return bRemove;
}

int RemoveEffectByDurationType(object oPC, int nEffectType, int nEffectDurationType)
{
    int bRemove = FALSE;
    effect eSearch = GetFirstEffect(oPC);
    while (GetIsEffectValid(eSearch))
    { //Check to see if the effect matches a particular type defined below
        if (GetEffectType(eSearch) == nEffectType)
        {
            if (GetEffectDurationType(eSearch) == nEffectDurationType)
            {
                RemoveEffect(oPC, eSearch);
                bRemove = TRUE;
            }
        }
        eSearch = GetNextEffect(oPC);
   }
   return bRemove;
}

int RemoveEffectByCreator(object oPC, object oCreator)
{
   int bRemove = FALSE;
   effect eSearch = GetFirstEffect(oPC);
   while (GetIsEffectValid(eSearch))
   {
      if (GetEffectCreator(eSearch)==oCreator)
      {
         SendMessageToPC(oPC, "Removed Effect given by " + GetName(oCreator));
         RemoveEffect(oPC, eSearch);
         bRemove = TRUE;
      }
      eSearch = GetNextEffect(oPC);
   }
   return bRemove;
}
