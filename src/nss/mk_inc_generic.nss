int MK_GENERIC_DIALOG_NUMBER_OF_VARIABLES = 22;

int MK_GENERIC_DIALOG_INVALID_ACTION = -1;

void MK_GenericDialog_CleanUp();

void MK_GenericDialog_SetState(int nState);

int MK_GenericDialog_GetState(int bClearState=FALSE);

int MK_GenericDialog_IsInState(int nState, int bClearState=FALSE);

void MK_GenericDialog_SetCondition(int nCondition, int bIsTrue);

int MK_GenericDialog_GetCondition(int nCondition);

void MK_GenericDialog_SetObject(int nObject, object oObject);

object MK_GenericDialog_GetObject(int nObject);

void MK_GenericDialog_SetAction(int nAction);

int MK_GenericDialog_GetAction(int bClearAction=TRUE);

void MK_GenericDialog_CleanUp()
{
    int iVar;
    for (iVar=0; iVar<MK_GENERIC_DIALOG_NUMBER_OF_VARIABLES; iVar++)
    {
        DeleteLocalInt(OBJECT_SELF, "MK_CONDITION_"+IntToString(iVar));
        DeleteLocalObject(OBJECT_SELF, "MK_OBJECT_"+IntToString(iVar));
    }
    DeleteLocalInt(OBJECT_SELF, "MK_ACTION");
    DeleteLocalInt(OBJECT_SELF, "MK_STATE");
}

void MK_GenericDialog_SetState(int nState)
{
    SetLocalInt(OBJECT_SELF, "MK_STATE", nState);
}

int MK_GenericDialog_GetState(int bClearState=FALSE)
{
    int nState = GetLocalInt(OBJECT_SELF, "MK_STATE");
    if (bClearState)
    {
        MK_GenericDialog_SetState(-1);
    }
    return nState;
}

int MK_GenericDialog_IsInState(int nState, int bClearState=FALSE)
{
    return MK_GenericDialog_GetState()==nState;
}

void MK_GenericDialog_SetCondition(int nCondition, int bIsTrue)
{
    SetLocalInt(OBJECT_SELF, "MK_CONDITION_"+IntToString(nCondition), bIsTrue);
}

int MK_GenericDialog_GetCondition(int nCondition)
{
    return GetLocalInt(OBJECT_SELF, "MK_CONDITION_"+IntToString(nCondition));
}

void MK_GenericDialog_SetObject(int nObject, object oObject)
{
    SetLocalObject(OBJECT_SELF, "MK_OBJECT_"+IntToString(nObject), oObject);
}

object MK_GenericDialog_GetObject(int nObject)
{
    return GetLocalObject(OBJECT_SELF, "MK_OBJECT_"+IntToString(nObject));
}

void MK_GenericDialog_SetAction(int nAction)
{
    SetLocalInt(OBJECT_SELF, "MK_ACTION", nAction);
}

int MK_GenericDialog_GetAction(int bClearAction=TRUE)
{
    int nAction = GetLocalInt(OBJECT_SELF, "MK_ACTION");
    if (bClearAction)
    {
        MK_GenericDialog_SetAction(MK_GENERIC_DIALOG_INVALID_ACTION);
    }
    return nAction;
}

/*
void main()
{

}
/**/
