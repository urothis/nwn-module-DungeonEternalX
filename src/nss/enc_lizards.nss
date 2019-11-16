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

    if (sWhich=="TROGDEN_BOSS_ENC")
    {
        oLocator = GetObjectByTag("TROGDEN_THRONE");
        oMinion = SpawnBoss("swamptrog_boss", oLocator);
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMinion);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d6), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_ELECTRICAL), oItem);
        AssignCommand(oMinion, ActionMoveToObject(oLocator));
        AssignCommand(oMinion, ActionSit(oLocator));
    }
}
