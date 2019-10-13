#include "seed_enc_inc"

void main()
{
    object oEncounter = OBJECT_SELF;

    if (GetLocalInt(oEncounter, "ENC_WAIT")) return;
    SetLocalInt(oEncounter, "ENC_WAIT", TRUE);

    int nEncDelay = GetLocalInt(oEncounter, "ENC_DELAY"); // SET IN TOOLSET
    if (!nEncDelay) nEncDelay = 90;

    AssignCommand(GetArea(oEncounter), DelayCommand(IntToFloat(nEncDelay), DeleteLocalInt(oEncounter, "ENC_WAIT")));

    object oEnteredBy = GetEnteringObject();
    object oMinion, oLocator, oItem, oObject;

    string sWhich = GetTag(oEncounter);
    if (sWhich == "NECRODEL_BOSS")
    {
        oLocator = GetNearestObjectByTag("WP_NECRODEL");
        oMinion = SpawnBoss("colossalskeleton", oLocator);

        oLocator = GetNearestObjectByTag("WP_NECRODEL_WAR", oEncounter, 1);
        oMinion = MakeCreature("necguardwar", oLocator, 600.0);
        oLocator = GetNearestObjectByTag("WP_NECRODEL_WAR", oEncounter, 2);
        oMinion = MakeCreature("necguardwar", oLocator, 600.0);
        oLocator = GetNearestObjectByTag("WP_NECRODEL_PRIEST");
        oMinion = MakeCreature("necguardpriest", oLocator, 600.0);
        DestroyObject(GetNearestObjectByTag("NECRODEL_PORTAL"));
    }
}
