#include "x0_i0_position"

string VFXStr(string sFilterBase)
{
    string sFilterWord="";

    if (sFilterBase == "A")
        sFilterWord = "All Effect";
    else
    if (sFilterBase == "B")
        sFilterWord = "Beam";
    else
    if (sFilterBase == "D")
        sFilterWord = "Duration";
    else
    if (sFilterBase == "F")
        sFilterWord = "Fire-and-Forget";
    else
    if (sFilterBase == "P")
        sFilterWord = "Projectile";

    return sFilterWord;
}

void FireEffect(object oUser, int iFireVFX, string sFireType, string sFireFilter, string sFireName, int iRandomFire = FALSE)
{
    effect eEffect;
    if (iRandomFire == FALSE)
    {
        if (sFireType == "B")
            eEffect = EffectBeam(iFireVFX, GetNearestObjectByTag("Emitter"), BODY_NODE_HAND, iRandomFire);
        else
            eEffect = EffectVisualEffect(iFireVFX);

        if (sFireType == "D")
        {
            if ((iFireVFX==358)||(iFireVFX==508)||(iFireVFX==509))
            {
              //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(iFireVFX), GetLocation(oUser));
            }
            else
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oUser, 6.0);
                DelayCommand(6.0, RemoveEffect(oUser, eEffect));
            }
        }
        else if (sFireType == "B")
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, GetNearestObjectByTag("Target"), 6.0);
        else if (sFireType == "P")
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, GetNearestObjectByTag("Target"));
        else if (iFireVFX!=120) // "F"
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, GetNearestObjectByTag("Target"));

        FloatingTextStringOnCreature("VFX # "+IntToString(iFireVFX)+" ("+VFXStr(sFireType)+") "+sFireName+" (View "+VFXStr(sFireFilter)+"s)",oUser, FALSE);
    }
    else //VFX Storm
    {
        int iRnd =0;
        object oTarget = GetObjectByTag("Target");
        object oEmitter = GetObjectByTag("Emitter");
        while (iRnd<10)
        {
            if (sFireType == "B")
                eEffect = EffectBeam(iFireVFX, oEmitter, BODY_NODE_HAND, TRUE);
            else
                eEffect = EffectVisualEffect(iFireVFX);

            if (sFireType == "D")
                DelayCommand(IntToFloat(iRnd)*0.5,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eEffect, GetRandomLocation(GetArea(OBJECT_SELF),oTarget), 6.0));
            else if (sFireType == "B")
                DelayCommand(IntToFloat(iRnd)*0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEffect,oTarget,6.0));
            else if (sFireType == "P")
                DelayCommand(IntToFloat(iRnd)*0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget));
            else if (iFireVFX!=120) // "F"
                DelayCommand(IntToFloat(iRnd)*0.5,ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, GetRandomLocation(GetArea(OBJECT_SELF),oTarget)));
            iRnd++;
        }

        FloatingTextStringOnCreature("VFX Storm # "+IntToString(iFireVFX)+" ("+VFXStr(sFireType)+") "+sFireName+" (View "+VFXStr(sFireFilter)+"s)",oUser, FALSE);
    }
}

int GetNext2DAItem(int iInd, string sCatagory)
{
    int iIndex = iInd;
    if (iIndex >671) iIndex = 0; else iIndex++;
    string sNextType = Get2DAString("visualeffects","Type_FD", iIndex);

    if (sCatagory == "A")
    {
        while (sNextType == "****")
        {
            if (iIndex >671) iIndex = 0; else iIndex++;
            sNextType = Get2DAString("visualeffects","Type_FD", iIndex);
        }
    }
    else
    {
        while (sNextType != sCatagory)
        {
            if (iIndex >671) iIndex = 0; else iIndex++;
            sNextType = Get2DAString("visualeffects","Type_FD", iIndex);
        }
    }

    return iIndex;
}

int GetLast2DAItem(int iInd, string sCatagory)
{
    int iIndex = iInd;
    if (iIndex <1) iIndex = 672; else iIndex--;
    string sLastType = Get2DAString("visualeffects","Type_FD", iIndex);


    if (sCatagory == "A")
    {
        while (sLastType == "****")
            {
                if (iIndex <1) iIndex = 672; else iIndex--;
                sLastType = Get2DAString("visualeffects","Type_FD", iIndex);
            }
    }
    else
    {
        while (sLastType != sCatagory)
        {
            if (iIndex <1) iIndex = 672; else iIndex--;
            sLastType = Get2DAString("visualeffects","Type_FD", iIndex);
        }
    }

    return iIndex;
}

string GetNextEffectType(string sEffectType)
{
    string sNextEffectType = sEffectType;
    if (sNextEffectType == "A") sNextEffectType = "B";
    else if (sNextEffectType == "B") sNextEffectType = "D";
    else if (sNextEffectType == "D") sNextEffectType = "F";
    else if (sNextEffectType == "F") sNextEffectType = "P";
    else if (sNextEffectType == "P") sNextEffectType = "A";
    return sNextEffectType;
}

string GetLastEffectType(string sEffectType)
{
    string sLastEffectType = sEffectType;
    if (sLastEffectType == "A") sLastEffectType = "P";
    else if (sLastEffectType == "B") sLastEffectType = "A";
    else if (sLastEffectType == "D") sLastEffectType = "B";
    else if (sLastEffectType == "F") sLastEffectType = "D";
    else if (sLastEffectType == "P") sLastEffectType = "F";
    return sLastEffectType;
}

void main()
{
    object  oPC = GetLastUsedBy();

    string  sFunction = GetTag(OBJECT_SELF);

    int     iEffect = GetLocalInt(oPC, "VFX");
    string  sFilter = GetLocalString(oPC, "VFX_TYPE");

    if  (sFilter == "") //All Effect Types Shown
        {
            sFilter = "A";
            SetLocalString(oPC, "VFX_TYPE", sFilter);
        }

    string  sName = Get2DAString("visualeffects","Label", iEffect);
    string  sType = Get2DAString("visualeffects","Type_FD", iEffect);

    if (sFunction == "back")
    {
        iEffect = GetLast2DAItem(iEffect, sFilter);
        SetLocalInt(oPC, "VFX", iEffect);
        sName = Get2DAString("visualeffects","Label", iEffect);
        sType = Get2DAString("visualeffects","Type_FD", iEffect);
        FireEffect(oPC, iEffect, sType, sFilter, sName);
    }
    else if (sFunction == "next")
    {
        iEffect = GetNext2DAItem(iEffect,sFilter);
        SetLocalInt(oPC, "VFX", iEffect);
        sName = Get2DAString("visualeffects","Label", iEffect);
        sType = Get2DAString("visualeffects","Type_FD", iEffect);
        FireEffect(oPC, iEffect, sType, sFilter, sName);
    }
    else if (sFunction == "back_type")
    {
        sFilter = GetLastEffectType(sFilter);
        SetLocalString(oPC, "VFX_TYPE", sFilter);
        iEffect = GetLast2DAItem(0,sFilter);
        SetLocalInt(oPC, "VFX", iEffect);
        sName = Get2DAString("visualeffects","Label", iEffect);
        sType = Get2DAString("visualeffects","Type_FD", iEffect);
        FloatingTextStringOnCreature("View "+VFXStr(sFilter)+" Effects",oPC, FALSE);
        FireEffect(oPC, iEffect, sType, sFilter, sName);
    }
    else if (sFunction == "next_type")
    {
        sFilter = GetNextEffectType(sFilter);
        SetLocalString(oPC, "VFX_TYPE", sFilter);
        iEffect = GetNext2DAItem(672,sFilter);
        SetLocalInt(oPC, "VFX", iEffect);
        sName = Get2DAString("visualeffects","Label", iEffect);
        sType = Get2DAString("visualeffects","Type_FD", iEffect);
        FloatingTextStringOnCreature("View "+VFXStr(sFilter)+" Effects",oPC, FALSE);
        FireEffect(oPC, iEffect, sType, sFilter, sName);
    }
    else if (sFunction == "use")
    {
        FireEffect(oPC, iEffect, sType, sFilter, sName);
    }
    else if (sFunction == "random_storm")
    {
        FireEffect(oPC, iEffect, sType, sFilter, sName, TRUE);
    }
}
