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
    if (sWhich == "ENC_GOLEM_DOOR")
    {
        oLocator = GetNearestObjectByTag("ENC_WP_GOLEM_DOOR");
        voidMakeCreature("stonegolem", oLocator, oEnteredBy);
    }
    else if (sWhich == "ENC_GOLEM_SE")
    {
        oLocator = GetNearestObjectByTag("ENC_WP_GOLEM_SE");
        voidMakeCreature("stonegolem", oLocator, oEnteredBy);
    }
    else if (sWhich == "ENC_GOLEM_NE")
    {
        oLocator = GetNearestObjectByTag("ENC_WP_GOLEM_NE");
        voidMakeCreature("stonegolem", oLocator, oEnteredBy);
    }
    else if (sWhich == "ENC_GOLEM_N")
    {
        oLocator = GetNearestObjectByTag("ENC_WP_GOLEM_N");
        voidMakeCreature("stonegolem", oLocator, oEnteredBy);
    }
    else if (sWhich == "ENC_DUERGAR_SIT")
    {
        int nCount = 1;
        oLocator = GetNearestObjectByTag("ENC_WP_DUERGAR_SIT", oEncounter, nCount);
        while (GetIsObjectValid(oLocator) && nCount < 4)
        {
            oMinion = MakeCreature(PickOne("duergarelite", "duergarbackstab"), oLocator);
            AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 120.0));
            nCount++;
            oLocator = GetNearestObjectByTag("ENC_WP_DUERGAR_SIT", oEncounter, nCount);
        }
    }
    else if (sWhich == "ENC_DUERGAR_SVEIN")
    {
        if (d3() != 1) return;
        oLocator = GetNearestObjectByTag("ENC_WP_DUERGAR_SVEIN");
        oMinion = SpawnBoss("duergarking", oLocator);

        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMinion);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(5), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_2d6), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oItem);

        SetLocalInt(oMinion, "COUNT_PLAYER_SPAWNED", pcCountParty(oEnteredBy));

        HideWeapons(oMinion);
        oLocator = GetNearestObjectByTag("SVEIN_THRONE");
        AssignCommand(oMinion, ActionMoveToObject(oLocator));
        AssignCommand(oMinion, ActionSit(oLocator));

        oLocator = GetNearestObjectByTag("ENC_WP_DUERGAR_GUARD1");
        oMinion = MakeCreature("duergarelite", oLocator);

        AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 120.0));
        oLocator = GetNearestObjectByTag("ENC_WP_DUERGAR_GUARD2");
        oMinion = MakeCreature("duergarelite", oLocator);
        AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 120.0));

        oLocator = GetNearestObjectByTag("ENC_WP_DUERGAR_SLAVE");
        oMinion = MakeCreature("duergarwarrior", oLocator);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oMinion, RoundsToSeconds(5));
    }
}
