/*
   =============================================
   PENTAGRAMS & SUMMONING CIRCLES -
   UTILITY FUNCTIONS
   =============================================
   gaoneng                      January 17, 2005
   #include "inc_draw_tools"

   last updated on April 25, 2005

   Library of utility tools for PENTAGRAMS &
   SUMMONING CIRCLES. Already coincluded in
   "inc_draw", so do not include if already
   including "inc_draw".
   =============================================
*/

/*
   =============================================
   GROUP* FUNCTIONS DECLARATIONS
   =============================================
*/
// Set oData's group of objects plot status
void GroupSetPlotFlag(object oData, int bPlotFlag);

// Destroy oData and oData's group of objects (irrevocably) over fOvertime seconds
void GroupDestroyObject(object oData, float fDelay=0.0f, float fOvertime=3.0f, int bReverseOrder=FALSE);

// Apply eEffect to oData's group of objects over fOvertime seconds
void GroupApplyEffectToObject(int nDurationType, effect eEffect, object oData, float fDuration=0.0f, float fOvertime=3.0f, int bReverseOrder=FALSE);

// Make oData's group of objects run sScript over fOvertime seconds and then return execution to the calling script
void GroupExecuteScript(string sScript, object oData, float fOvertime=3.0f, int bReverseOrder=FALSE);

// Cause oData's group of objects to face fDirection / rotate fDirection
// bRelative - FALSE for absolute face fDirection
//           - TRUE for rotate fDirection degrees (DEFAULT : TRUE)
void GroupSetFacing(float fDirection, object oData, int bRelative=TRUE, float fOvertime=3.0f, int bReverseOrder=FALSE);

// Cause oData's group of objects to face vTarget
void GroupSetFacingPoint(vector vTarget, object oData, float fOvertime=3.0f, int bReverseOrder=FALSE);

/*
   =============================================
   GROUP* FUNCTIONS IMPLEMENTATIONS
   =============================================
*/

void GroupExecuteScript(string sScript, object oData, float fOvertime=3.0f, int bReverseOrder=FALSE)
{
   int i;
   int nTotal = GetLocalInt(oData, "storetotal");
   if (nTotal < 1) return;
   float fBreak = fOvertime/IntToFloat(nTotal);
   if (bReverseOrder)
   {
      int j = 0;
      for (i=nTotal-1; i>-1; i--)
      {
         DelayCommand(fBreak*IntToFloat(j), ExecuteScript(sScript, GetLocalObject(oData, "store" + IntToString(i))));
         j++;
      }
   }
   else
   {
      for (i=0; i<nTotal; i++)
      {
         DelayCommand(fBreak*IntToFloat(i), ExecuteScript(sScript, GetLocalObject(oData, "store" + IntToString(i))));
      }
   }
}

void GroupSetPlotFlag(object oData, int bPlotFlag)
{
   int i;
   int nTotal = GetLocalInt(oData, "storetotal");
   for (i=0; i<nTotal; i++)
   {
      SetPlotFlag(GetLocalObject(oData, "store" + IntToString(i)), bPlotFlag);
   }
}

void GroupDestroyObject(object oData, float fDelay=0.0f, float fOvertime=3.0f, int bReverseOrder=FALSE)
{
   int i;
   int nTotal = GetLocalInt(oData, "storetotal");
   if (nTotal < 1) return;
   float fBreak = fOvertime/IntToFloat(nTotal);
   if (bReverseOrder)
   {
      int j = 0;
      for (i=nTotal-1; i>-1; i--)
      {
         DelayCommand(fDelay + fBreak*IntToFloat(j), DestroyObject(GetLocalObject(oData, "store" + IntToString(i))));
         j++;
      }
   }
   else
   {
      for (i=0; i<nTotal; i++)
      {
         DelayCommand(fDelay + fBreak*IntToFloat(i), DestroyObject(GetLocalObject(oData, "store" + IntToString(i))));
      }
   }
   DestroyObject(oData, fDelay + fOvertime + 0.5);
}

void GroupApplyEffectToObject(int nDurationType, effect eEffect, object oData, float fDuration=0.0f, float fOvertime=3.0f, int bReverseOrder=FALSE)
{
   int i;
   int nTotal = GetLocalInt(oData, "storetotal");
   if (nTotal < 1) return;
   float fBreak = fOvertime/IntToFloat(nTotal);
   if (bReverseOrder)
   {
      int j = 0;
      for (i=nTotal-1; i>-1; i--)
      {
         DelayCommand(fBreak*IntToFloat(j), ApplyEffectToObject(nDurationType, eEffect, GetLocalObject(oData, "store" + IntToString(i)), fDuration));
         j++;
      }
   }
   else
   {
      for (i=0; i<nTotal; i++)
      {
         DelayCommand(fBreak*IntToFloat(i), ApplyEffectToObject(nDurationType, eEffect, GetLocalObject(oData, "store" + IntToString(i)), fDuration));
      }
   }
}

void GroupSetFacing(float fDirection, object oData, int bRelative=TRUE, float fOvertime=3.0f, int bReverseOrder=FALSE)
{
   int i;
   int nTotal = GetLocalInt(oData, "storetotal");
   if (nTotal < 1) return;
   float fBreak = fOvertime/IntToFloat(nTotal);
   if (bReverseOrder)
   {
      int j = 0;
      if (bRelative)
      {
         object oNode;
         for (i=nTotal-1; i>-1; i--)
         {
            oNode = GetLocalObject(oData, "store" + IntToString(i));
            DelayCommand(fBreak*IntToFloat(j), AssignCommand(oNode, SetFacing(GetFacing(oNode) + fDirection)));
            j++;
         }
      }
      else
      {
         for (i=nTotal-1; i>-1; i--)
         {
            DelayCommand(fBreak*IntToFloat(j), AssignCommand(GetLocalObject(oData, "store" + IntToString(i)), SetFacing(fDirection)));
            j++;
         }
      }
   }
   else
   {
      if (bRelative)
      {
         object oNode;
         for (i=0; i<nTotal; i++)
         {
            oNode = GetLocalObject(oData, "store" + IntToString(i));
            DelayCommand(fBreak*IntToFloat(i), AssignCommand(oNode, SetFacing(GetFacing(oNode) + fDirection)));
         }
      }
      else
      {
         for (i=0; i<nTotal; i++)
         {
            DelayCommand(fBreak*IntToFloat(i), AssignCommand(GetLocalObject(oData, "store" + IntToString(i)), SetFacing(fDirection)));
         }
      }
   }
}

void GroupSetFacingPoint(vector vTarget, object oData, float fOvertime=3.0f, int bReverseOrder=FALSE)
{
   int i;
   int nTotal = GetLocalInt(oData, "storetotal");
   if (nTotal < 1) return;
   float fBreak = fOvertime/IntToFloat(nTotal);
   if (bReverseOrder)
   {
      int j = 0;
      for (i=nTotal-1; i>-1; i--)
      {
         DelayCommand(fBreak*IntToFloat(j), AssignCommand(GetLocalObject(oData, "store" + IntToString(i)), SetFacingPoint(vTarget)));
         j++;
      }
   }
   else
   {
      for (i=0; i<nTotal; i++)
      {
         DelayCommand(fBreak*IntToFloat(i), AssignCommand(GetLocalObject(oData, "store" + IntToString(i)), SetFacingPoint(vTarget)));
      }
   }
}
