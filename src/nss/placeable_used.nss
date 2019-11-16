#include "_functions"

void main()
{
    object oUser = GetLastUsedBy();
    if (!GetIsObjectValid(oUser)) return;

    string sTag = GetTag(OBJECT_SELF);

    if (sTag == "GOBLINTUNNEL_TO_CAMP")
    {
        object oTarget = DefGetObjectByTag("WP_VELNGOBLIN_TO_TUNNEL");
        AssignCommand(oUser, JumpToObject(oTarget));
    }
    else if (sTag == "DELVERS_TO_NIB")
    {
        object oTarget = DefGetObjectByTag("WP_NIB_TO_DELVERS");
        AssignCommand(oUser, JumpToObject(oTarget));
    }
    else if (sTag == "FLAMING_BRAZIER")
    {
        AssignCommand(oUser, ClearAllActions(TRUE));
        AssignCommand(oUser, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
        AssignCommand(oUser, ActionDoCommand(SetCommandable(TRUE)));
        AssignCommand(oUser, SetCommandable(FALSE));
        DelayCommand(1.0, DoFlamingBrazier(oUser));
    }
}
