#include "_functions"
#include "time_inc"

void main()
{
    object oChest = OBJECT_SELF;
    if (!GetLocked(oChest)) return;

    int nTick = GetLocalInt(oChest, "TICK") - GetTick();
    if (nTick == 0)
    {
        SpeakString("Finished in a few seconds");
    }
    else if (nTick > 0)
    {
        SpeakString("Finished in about " + ConvertSecondsToString(nTick * 120));
    }
}
