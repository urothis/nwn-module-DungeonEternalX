#include "random_loot_inc"
#include "dmg_stones_inc"
#include "pc_inc"


object GetOhnos(object oBag, int nLevel);

object GetOhnos(object oBag, int nLevel)
{
    if (!GetIsObjectValid(oBag)) return OBJECT_INVALID;
    object oArea = GetArea(oBag);
    object oOhnos = GetLocalObject(oArea, "OHNOS");
    if (!GetIsObjectValid(oOhnos))
    {
        location lBag = GetLocation(oBag);
        oOhnos = CreateObject(OBJECT_TYPE_CREATURE, "ohnos_kobold", lBag, FALSE, "OHNOS");
        SetLocalInt(oOhnos, "XP_BONUS", 3);
        SetLocalObject(oArea, "OHNOS", oOhnos);
        SetLocalObject(oOhnos, "OHNOS_AREA", oArea);
        effect eHP = ExtraordinaryEffect(EffectTemporaryHitpoints(nLevel*nLevel));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHP, oOhnos);
    }
    else AssignCommand(oOhnos, JumpToObject(oBag));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(471), oBag);
    int nVoice;
    nVoice = (d2() == 1) ?  VOICE_CHAT_THANKS : VOICE_CHAT_ENCUMBERED;
    AssignCommand(oOhnos, DelayCommand(2.0, PlayVoiceChat(nVoice, oOhnos)));
    AssignCommand(oOhnos, ActionMoveAwayFromObject(oBag, TRUE));
    DelayCommand(1.0, DestroyObject(oBag));
    return oOhnos;
}

void main()
{
    object oBag = OBJECT_SELF;
    object oPC = GetLastUsedBy();
    object oLootCache = GetObjectByTag("LOOT_CACHE");
    object oItem;

    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;
    if (GetIsDMPossessed(oPC)) return;
    if (!GetIsObjectValid(oPC)) return;

    if (GetTag(oBag) != "LOOTBAG") return; // DM created?

    //SetLocalInt(oBag, "OPENED", TRUE);
    if (GetLocalInt(oBag, GetPCPublicCDKey(oPC)))
    {
        ActionFloatingTextStringOnCreature("You have already looted that bag.", oPC);
        return;
    }
    SetLocalInt(oBag, GetPCPublicCDKey(oPC), 1); //records the player looting on the bag.
    if (!GetLocalInt(oBag, GetPCPublicCDKey(oPC)))
        ActionFloatingTextStringOnCreature("There is a problem with the loot system. DEBUG: NO VAR SET", oPC);

    // to prevent high level player steal all items in no-pvp from low lvls
    int nLootCR = LootGetBagCR(oBag);
    int nLevel = pcGetRealLevel(oPC);
    if (nLootCR)
    {
        if (nLevel > nLootCR + 5) return;
    }

    ////////////////////////////////////////////////////////////////////////////
    object oArea = GetArea(oBag);
    //SetLocalInt(oBag, "OPENED", TRUE);
    int nRoll = Random(100) + 1;

    // ------------------ General encounter loot -----------------------------

    if (GetLocalInt(oArea, "OHNOS")) oBag = GetOhnos(oBag, nLevel);

    if (nRoll >= 85) // loot container potions and scrolls 15%
    {
        LootCreateScrollPot(oPC, (d4() == 1)); // always Pots, unless rolled 1
        return;
    }

    if (nRoll >= 45) // area loot 40%
    {
        //SendMessageToPC(oPC,"DEBUG: AREA LOOT");
        string sAreaTag = GetTag(oArea);
        string sAreaTag5 = GetStringLeft(sAreaTag, 5);
        object oAreaItem;
        if (sAreaTag == "NIBEL_BASTION")
        {
            LootMoveFromContainer(oPC, LootCreateCharges(oLootCache, d2(), "CHARGE_NUBFIST"));
            return;
        }
        else if (sAreaTag5 == "MTMOO")
        {
            LootMoveFromContainer(oPC, LootCreateCharges(oLootCache, 3 + d2(), "CHARGE_MAGMA"));
            return;
        }
        else if (sAreaTag5 == "GRAAZ")
        {
            nRoll = d3();
            if (nRoll == 1)
            {
                oAreaItem = CreateItemOnObject("item_seeds", oPC);
                SetItemCharges(oAreaItem, 2 + d2());
                SetName(oAreaItem, "Dark Cypress Seeds");
                return;
            }
        }
        else if (sAreaTag5 == "CRYPT")
        {
            nRoll = d3();
            if (nRoll == 1)
            {
                CreateItemOnObject("skeleton_knuckle", oPC, 1, "SKELETON_KNUCKLE");
                return;
            }
        }
        else if (sAreaTag5 == "DOPKA")
        {
            nRoll = d2();
            if (nRoll == 1)
            {
                CopyItem(LootGetItemByTag("POT_ICYIRONGUTS"), oPC, TRUE);
                return;
            }
            else
            {
                oAreaItem = CreateItemOnObject("onhit_bullets", oLootCache, 24 + d4(), "onhit_coldbullet");
                SetName(oAreaItem, "Frost Bullets");
                LootMoveFromContainer(oPC, oAreaItem);
                return;
            }
        }
        else if (sAreaTag5 == "MSEWE")
        {
            oAreaItem = CreateItemOnObject("onhit_bullets", oLootCache, 24 + d4(), "onhit_acidbullet");
            SetName(oAreaItem, "Acidic Bullets");
            LootMoveFromContainer(oPC, oAreaItem);
            return;
        }
        else if (sAreaTag5 == "STING")
        {
            oAreaItem = CreateItemOnObject("onhit_bullets", oLootCache, 24 + d4(), "onhit_firebullet");
            SetName(oAreaItem, "Flaming Bullets");
            LootMoveFromContainer(oPC, oAreaItem);
            return;
        }
        /*else if (sAreaTag5 == "GNOLL")
        {
            oAreaItem = CreateItemOnObject("onhit_bullets", oPC, 24 + d4(), "onhit_elecbullet");
            SetName(oAreaItem, "Lightning Bullets");
            return;
        }*/
    }

    if (nRoll <= 7) // damage stones 7%
    {
        oItem=DMGS_CreateStone(oLootCache);
        LootMoveFromContainer(oPC, oItem);
        //SendMessageToPC(oPC,"DEBUG: DMG STONE");

        return;
    }

    if (nRoll <= 14)
    {
        if (d3() != 1) // at 2 or 3
        {
            LootCreateRareLoot(oPC);
            //SendMessageToPC(oPC,"DEBUG: RARE LOOT");
            return;
        }
        else if (nLevel > 5)
        {
            if (GetHasTimePassed(oArea, 15, "OHNOS"))
            {
                SetLocalInt(oArea, "OHNOS", TRUE);
            }
        }
    }

    // else this
    nRoll = d3();
    if (nRoll == 1) LootCreateStoreLoot(oPC);
    else if (nRoll == 2) LootCreateGold(oPC, 50000, 30000);
    else LootCreateGems(oPC, 50000, 30000);

    //if (d2() == 1) XMas_Special(oPC, oPC);
}
