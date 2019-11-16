#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    int nResult = X2_EXECUTE_SCRIPT_CONTINUE;
    if (nEvent == X2_ITEM_EVENT_ACTIVATE)
    {
        object oItem  = GetItemActivated();
        object oPC    = GetItemActivator();
        object nPC    = GetFirstPC();

        while (GetIsObjectValid(nPC))
        {
            SetPCDislike(oPC, nPC);
            nPC = GetNextPC();
        }

       int nSpeak = d6();
       if      (nSpeak==1) nSpeak = VOICE_CHAT_BATTLECRY1;
       else if (nSpeak==2) nSpeak = VOICE_CHAT_BATTLECRY2;
       else if (nSpeak==3) nSpeak = VOICE_CHAT_BATTLECRY3;
       else if (nSpeak==4) nSpeak = VOICE_CHAT_TAUNT;
       else if (nSpeak==5) nSpeak = VOICE_CHAT_ATTACK;
       else if (nSpeak==6) nSpeak = VOICE_CHAT_THREATEN;
       PlayVoiceChat(nSpeak, oPC);
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR), oPC, 2.0);
    }
    SetExecutedScriptReturnValue(nResult);
}
