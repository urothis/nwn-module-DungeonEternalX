//::///////////////////////////////////////////////
//:: Name Flel's NPC Item Crafters
//:: FileName flels_crafters
//:: Copyright (c) 2005 Floris Barthel
//:://////////////////////////////////////////////
/*
    Crafter base script. Take a look at the flel_crafter_run script on how to
    implent these on your NPCs. Take a look at flel_crafter_inc for changing
    item rules.

    - The following item properties are not allowed: All Immunities,
      Damage Reduction, Damage Resistance, AC Bonus greater than +6, Enhancement
      or Attack Bonus greater than +4, True Seeing, Freedom of Movement, Holy
      Avenger, Feats & Abilities, Versus Alignment Group (AC Bonus, Enchantment
      Bonus, Attack Bonus, Damage Bonus), and Containers (Weight Reduction or
      otherwise). There are, however, some items that cast spells with these
      properties.
    - AC can be added to all items limited to +6
    - AB/EB can be added to weapons to a max of +4
    - Damage bonuses up to +6 or 2d6
    - Mass crits up to 2d6
    - Mighty up to +6
    - Weapons are allowed a single OnHit property
    - Vamperic regeneration is allowed up to +6
    - Keen is allowed (no restrictions)
    - Stats on items will be limited to +8 on every item (any combo)
    - Skillpoints can be put on items to a max of +4 on each item (any combo)
    - Spellslots can be added on items, limited to one slot each item.
    - Darkvision, haste and light can be added to any items w/o incurring any
      restrictions.
    - Up to +2 regen can be added to any item.
    - Saving throws can be added in the following manner: +1 universal OR +2 vs.
      effects (any combo) OR +3 fort/refl/will (any combo)
    - The following item properties MAY NOT BE COMBINED on a single item:
      On Hit, Ability Bonus, Skill Bonus, Improved Saving Throw, Bonus Spell
      Slot, and Regeneration.
    - Damage, Ability, Skill, and Saving Throw bonuses can be any combination up
      to the limit. For example, you may have Strength +8 on an item or you may
      have Strength +4, Dexterity +2, and Constitution +2 on an item.

      Thanks to:
        - The geniuses behind NWNX for making such a great database interface
        - Genji with his lovely yet powerfull coloring book
          http://nwvault.ign.com/View.php?view=scripts.Detail&id=22
        - Paul Speed for his great and awesome Z-Dialog library that allowed me
          to keep the entire script in just three files.
          http://nwvault.ign.com/View.php?view=scripts.Detail&id=2745
        - Alec Austice for his help via MSN chat
        - BoW for their crazy balanced item rules that for the most part have
          been copied for this crafter script.
        - Lazy Clownfish for hosting the greatest NWN server in history :)
*/

#include "x2_inc_itemprop"
#include "zdlg_include_i"
#include "gen_inc_color"
#include "flel_crafter_inc"
#include "db_inc"
#include "_leto_name"

void SetShowing(int nIProperties = SHOW_ALL)
{
    object oPlayer = GetPcDlgSpeaker();
    SetLocalInt(oPlayer,SHOWING,nIProperties);
}

int GetShowing()
{
    object oPlayer = GetPcDlgSpeaker();
    return GetLocalInt(oPlayer,SHOWING);
}

void ReserveProperty (int nIProperties)
{
    object oPlayer = GetPcDlgSpeaker();
    SetShowing(
        GetShowing() & (nIProperties | SHOW_WEAPON_PROPERTIES));
}

void Init()
{
    object oPlayer = GetPcDlgSpeaker();
    // Initialize some local counter variables
    SetLocalInt(oPlayer,CURRENT_ABILITY_BONUS,0);
    SetLocalInt(oPlayer,CURRENT_SKILL_BONUS,0);
    SetLocalInt(oPlayer,CURRENT_SAVE_BONUS,0);
    SetLocalInt(oPlayer,CURRENT_SAVE_EFFECT_BONUS,0);
    SetLocalInt(oPlayer,CURRENT_BONUS_SPELLSLOTS,0);
    SetLocalInt(oPlayer,CURRENT_REGEN,0);
    SetLocalInt(oPlayer,CURRENT_VAMP_REGEN,0);
    SetLocalInt(oPlayer, "CURRENT_FORT_BONUS", 0);
    SetLocalInt(oPlayer,MAX_DAMAGE_DICE,0);
    SetShowing();
}

int GetMinSpellLevel(object oPlayer)
{
    int nClassSelected = GetLocalInt(oPlayer,SPELLSLOT_CLASS_SELECTED);
    if (nClassSelected == IP_CONST_CLASS_PALADIN || nClassSelected == IP_CONST_CLASS_RANGER)
        return 1;
    else
        return 0;
}

int GetMaxSpellLevel(object oPlayer)
{
    int nCasterLevel;
    int nClassSelected = GetLocalInt(oPlayer,SPELLSLOT_CLASS_SELECTED);
    switch (nClassSelected)
    {
        case IP_CONST_CLASS_BARD:
            nCasterLevel = GetLevelByClass(CLASS_TYPE_BARD,oPlayer);
            if (nCasterLevel >= 2)
                return 1;
            else if (((nCasterLevel-1)/3+1) >= 6)
                return 6;
            else
                return ((nCasterLevel-1)/3+1);
        case IP_CONST_CLASS_CLERIC:
            nCasterLevel = GetLevelByClass(CLASS_TYPE_CLERIC,oPlayer);
            if (((nCasterLevel-1)/2+1) > 9)
                return 9;
            else
                return (nCasterLevel-1)/2+1;
        case IP_CONST_CLASS_DRUID:
            nCasterLevel = GetLevelByClass(CLASS_TYPE_DRUID,oPlayer);
            if (((nCasterLevel-1)/2+1) > 9)
                return 9;
            else
                return (nCasterLevel-1)/2+1;
        case IP_CONST_CLASS_PALADIN:
            nCasterLevel = GetLevelByClass(CLASS_TYPE_PALADIN,oPlayer);
            if (nCasterLevel >= 14)
                return 4;
            else if (nCasterLevel >= 11)
                return 3;
            else if (nCasterLevel >= 8)
                return 2;
            else if (nCasterLevel >= 4)
                return 1;
            else
                return 0;
        case IP_CONST_CLASS_RANGER:
            nCasterLevel = GetLevelByClass(CLASS_TYPE_RANGER,oPlayer);
            if (nCasterLevel >= 14)
                return 4;
            else if (nCasterLevel >= 11)
                return 3;
            else if (nCasterLevel >= 8)
                return 2;
            else if (nCasterLevel >= 4)
                return 1;
            else
                return 0;
        case IP_CONST_CLASS_SORCERER:
            nCasterLevel = GetLevelByClass(CLASS_TYPE_SORCERER,oPlayer);
            if (((nCasterLevel-2)/2+1) > 9)
                return 9;
            else
                return (nCasterLevel-2)/2+1;
        case IP_CONST_CLASS_WIZARD:
            nCasterLevel = GetLevelByClass(CLASS_TYPE_WIZARD,oPlayer);
            if (((nCasterLevel-1)/2+1) > 9)
                return 9;
            else
                return (nCasterLevel-1)/2+1;
    }
    return 0;
}

void BuildReturnButton()
{
    object oPlayer = GetPcDlgSpeaker();
    SetShowing(GetShowing() | SHOW_NAV_RETURN);
    ReplaceIntElement(
        AddStringElement(GetRGB(15,5,1) + "[Return to confirm dialog]", LIST, oPlayer)-1,
        SELECT_NAV_RETURN,LIST,oPlayer);
}

void BuildBackButton()
{
    object oPlayer = GetPcDlgSpeaker();
    SetShowing(GetShowing() | SHOW_NAV_BACK);
    ReplaceIntElement(
        AddStringElement(GetRGB(15,5,1) + "[Back]", LIST, oPlayer)-1,
        SELECT_NAV_BACK,LIST,oPlayer);
    BuildReturnButton();
}

object GetItem ()
{
    return GetLocalObject(GetPcDlgSpeaker(),ITEM);
}

void BuildList()
{
    object oPlayer = GetPcDlgSpeaker();
    int nIProperties = GetShowing();
    int i; // Int used for creating for loops in some of the list creators
    DeleteList(LIST,oPlayer);
    DeleteList(RESREF,oPlayer);
    switch (GetLocalInt(oPlayer,SELECTOR))
    {
        case SELECT_CONFIRM_DIALOG:
            AddStringElement("Add item properties", LIST, oPlayer);
            AddStringElement("Examine the item", LIST, oPlayer);
            AddStringElement("Buy the item", LIST, oPlayer);
            return;
        case SELECT_ITEM_PROPERTIES:
            ReplaceIntElement(
                AddStringElement("Armor Class Bonus", LIST, oPlayer)-1,
                SELECT_AC_B,LIST,oPlayer);
            if (nIProperties & SHOW_ABILITY_BONUS)
                ReplaceIntElement(
                    AddStringElement("Ability Bonus", LIST, oPlayer)-1,
                    SELECT_ABILITY_TYPE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Other item properties", LIST, oPlayer)-1,
                SELECT_OTHER_ITEM_PROPS,LIST,oPlayer);
            BuildReturnButton();
            return;
        case SELECT_OTHER_ITEM_PROPS:
                if (nIProperties & SHOW_SKILL_BONUS)
                    ReplaceIntElement(
                        AddStringElement("Skill Bonus", LIST, oPlayer)-1,
                        SELECT_SKILL_TYPE,LIST,oPlayer);

                if (nIProperties & SHOW_SAVE_BONUS)
                    ReplaceIntElement(
                        AddStringElement("Improved Saving Throw (Fort/Refl/Will)", LIST, oPlayer)-1,
                        SELECT_SAVE_TYPE,LIST,oPlayer);

                if (nIProperties & SHOW_SAVE_EFFECT_BONUS)
                    ReplaceIntElement(
                        AddStringElement("Improved Saving Throw vs Effect(death/cold/fear/etc)", LIST, oPlayer)-1,
                        SELECT_SAVE_EFFECT_TYPE,LIST,oPlayer);

                if (nIProperties & SHOW_BONUS_SPELLSLOT)
                    ReplaceIntElement(
                        AddStringElement("Bonus Spell Slot", LIST, oPlayer)-1,
                        SELECT_BONUS_SPELLSLOT,LIST,oPlayer);

                if (nIProperties & SHOW_REGEN)
                    ReplaceIntElement(
                        AddStringElement("Regeneration", LIST, oPlayer)-1,
                        SELECT_REGEN,LIST,oPlayer);

                ReplaceIntElement(
                    AddStringElement("Haste", LIST, oPlayer)-1,
                    SELECT_HASTE,LIST,oPlayer);
                ReplaceIntElement(
                    AddStringElement("Darkvision", LIST, oPlayer)-1,
                    SELECT_DARKVISION,LIST,oPlayer);
                ReplaceIntElement(
                    AddStringElement("Light", LIST, oPlayer)-1,
                    SELECT_LIGHT_BRIGHTNESS,LIST,oPlayer);
            BuildReturnButton();
            return;
        case SELECT_WEAPON_PROPERTIES:
            if (nIProperties & SHOW_EB)
                ReplaceIntElement(
                    AddStringElement("Enchantment Bonus", LIST, oPlayer)-1,
                    SELECT_EB,LIST,oPlayer);
            if (nIProperties & SHOW_AB)
                ReplaceIntElement(
                    AddStringElement("Attack Bonus", LIST, oPlayer)-1,
                    SELECT_AB,LIST,oPlayer);
            if (nIProperties & SHOW_KEEN)
                ReplaceIntElement(
                    AddStringElement("Keen", LIST, oPlayer)-1,
                    SELECT_KEEN,LIST,oPlayer);
            if (nIProperties & SHOW_DAMAGE_BONUS)
                ReplaceIntElement(
                    AddStringElement("Damage Bonus", LIST, oPlayer)-1,
                    SELECT_DAMAGE_TYPE,LIST,oPlayer);
            if (nIProperties & SHOW_MASSCRITS)
                ReplaceIntElement(
                    AddStringElement("Massive Criticals", LIST, oPlayer)-1,
                    SELECT_MASSCRITS,LIST,oPlayer);
            if (nIProperties & SHOW_VAMP_REGEN)
                ReplaceIntElement(
                    AddStringElement("Vamperic Regeneration", LIST, oPlayer)-1,
                    SELECT_VAMP_REGEN,LIST,oPlayer);
            /*if (nIProperties & SHOW_ONHIT)
                ReplaceIntElement(
                    AddStringElement("OnHit Effects", LIST, oPlayer)-1,
                    SELECT_ONHIT_TYPE,LIST,oPlayer);    */
            if (nIProperties & SHOW_MIGHTY)
                ReplaceIntElement(
                    AddStringElement("Mighty", LIST, oPlayer)-1,
                    SELECT_MIGHTY,LIST,oPlayer);
            //if (nIProperties & SHOW_ITEM_PROPERTIES)
                ReplaceIntElement(
                    AddStringElement("Other item properties", LIST, oPlayer)-1,
                    SELECT_ITEM_PROPERTIES,LIST,oPlayer);
           /* else
                ReplaceIntElement(
                    AddStringElement("Other item properties", LIST, oPlayer)-1,
                    SELECT_OTHER_ITEM_PROPS,LIST,oPlayer); */
            BuildReturnButton();
            return;
        case SELECT_WEAPON:
            ReplaceIntElement(
                AddStringElement("Small", LIST, oPlayer)-1,
                SELECT_WEAPON_SMALL,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Medium", LIST, oPlayer)-1,
                SELECT_WEAPON_MEDIUM,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Large", LIST, oPlayer)-1,
                SELECT_WEAPON_LARGE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Ranged", LIST, oPlayer)-1,
                SELECT_WEAPON_RANGED,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Monk Gloves", LIST, oPlayer)-1,
                SELECT_MONK_GLOVES,LIST,oPlayer);
            AddIntElement(MAX_DAMAGE_DICE_SMALL,RESREF,oPlayer);
            AddIntElement(MAX_DAMAGE_DICE_MEDIUM,RESREF,oPlayer);
            AddIntElement(MAX_DAMAGE_DICE_LARGE,RESREF,oPlayer);
            AddIntElement(0,RESREF,oPlayer);
            AddIntElement(MAX_DAMAGE_DICE_GLOVES,RESREF,oPlayer);
            return;
        case SELECT_WEAPON_SMALL:
            AddStringElement("[Dagger BD: 1d4 CR: 19-20x2]", LIST, oPlayer);
            AddStringElement("nw_wswdg001", RESREF, oPlayer);

            AddStringElement("[Handaxe BD: 1d6 CR: 20x3]", LIST, oPlayer);
            AddStringElement("nw_waxhn001", RESREF, oPlayer);

            AddStringElement("[Kama BD: 1d6 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wspka001", RESREF, oPlayer);

            AddStringElement("[Kukri BD: 1d4 CR: 18-20x2]", LIST, oPlayer);
            AddStringElement("nw_wspku001", RESREF, oPlayer);

            AddStringElement("[Light Hammer BD: 1d4 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wblhl001", RESREF, oPlayer);

            AddStringElement("[Mace BD: 1d6 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wblml001", RESREF, oPlayer);

            AddStringElement("[Short Sword BD: 1d6 CR: 19-20x2]", LIST, oPlayer);
            AddStringElement("nw_wswss001", RESREF, oPlayer);

            AddStringElement("[Sickle BD: 1d6 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wspsc001", RESREF, oPlayer);

            AddStringElement("[Whip BD: 1d2 CR: 20x2]", LIST, oPlayer);
            AddStringElement("x2_it_wpwhip", RESREF, oPlayer);
            return;
        case SELECT_WEAPON_MEDIUM:
            AddStringElement("[Bastard Sword BD: 1d10 CR: 19-20x2]", LIST, oPlayer);
            AddStringElement("nw_wswbs001", RESREF, oPlayer);

            AddStringElement("[Battleaxe BD: 1d8 CR: 20x3]", LIST, oPlayer);
            AddStringElement("nw_waxbt001", RESREF, oPlayer);

            AddStringElement("[Club BD: 1d6 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wblcl001", RESREF, oPlayer);

            AddStringElement("[Dwarven Waraxe BD: 1d10 CR: 20x3]", LIST, oPlayer);
            AddStringElement("x2_wdwraxe001", RESREF, oPlayer);

            AddStringElement("[Katana BD: 1d10 CR: 19-20x2]", LIST, oPlayer);
            AddStringElement("nw_wswka001", RESREF, oPlayer);

            AddStringElement("[Light Flail BD: 1d8 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wblfl001", RESREF, oPlayer);

            AddStringElement("[Longsword BD: 1d8 CR: 19-20x2]", LIST, oPlayer);
            AddStringElement("nw_wswls001", RESREF, oPlayer);

            AddStringElement("[Morningstar BD: 1d8 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wblms001", RESREF, oPlayer);

            AddStringElement("[Rapier BD: 1d6 CR: 18-20x2]", LIST, oPlayer);
            AddStringElement("nw_wswrp001", RESREF, oPlayer);

            AddStringElement("[Scimitar BD: 1d6 CR: 18-20x2]", LIST, oPlayer);
            AddStringElement("nw_wswsc001", RESREF, oPlayer);

            AddStringElement("[Warhammer BD: 1d8 CR: 20x3]", LIST, oPlayer);
            AddStringElement("nw_wblhw001", RESREF, oPlayer);
            return;
        case SELECT_WEAPON_LARGE:
            AddStringElement("[Dire Mace BD: 1d8 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wdbma001", RESREF, oPlayer);

            AddStringElement("[Double Axe BD: 1d8 CR: 20x3]", LIST, oPlayer);
            AddStringElement("nw_wdbax001", RESREF, oPlayer);

            AddStringElement("[Greataxe BD: 1d12 CR: 20x3]", LIST, oPlayer);
            AddStringElement("nw_waxgr001", RESREF, oPlayer);

            AddStringElement("[Greatsword BD: 2d6 CR: 19-20x2]", LIST, oPlayer);
            AddStringElement("nw_wswgs001", RESREF, oPlayer);

            AddStringElement("[Halberd BD: 1d10 CR: 20x3]", LIST, oPlayer);
            AddStringElement("nw_wplhb001", RESREF, oPlayer);

            AddStringElement("[Heavy Flail BD: 1d10 CR: 19-20x2]", LIST, oPlayer);
            AddStringElement("nw_wblfh001", RESREF, oPlayer);

            AddStringElement("[Quarterstaff BD: 1d6 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wdbqs001", RESREF, oPlayer);

            AddStringElement("[Scythe BD: 2d4 CR: 20x4]", LIST, oPlayer);
            AddStringElement("nw_wplsc001", RESREF, oPlayer);

            AddStringElement("[Spear BD: 1d8 CR: 20x3]", LIST, oPlayer);
            AddStringElement("nw_wplss001", RESREF, oPlayer);

            AddStringElement("[Two-Bladed Sword BD: 1d8 CR: 19-20x2]", LIST, oPlayer);
            AddStringElement("nw_wdbsw001", RESREF, oPlayer);
            return;
        case SELECT_WEAPON_RANGED:
            AddStringElement("[Heavy Crossbow BD: 1d10 CR: 19-20x2]", LIST, oPlayer);
            AddStringElement("nw_wbwxh001", RESREF, oPlayer);

            AddStringElement("[Light Crossbow BD: 1d8 CR: 19-20x2]", LIST, oPlayer);
            AddStringElement("nw_wbwxl001", RESREF, oPlayer);

            AddStringElement("[Longbow BD: 1d8 CR: 20x3]", LIST, oPlayer);
            AddStringElement("nw_wbwln001", RESREF, oPlayer);

            AddStringElement("[Shortbow BD: 1d6 CR: 20x3]", LIST, oPlayer);
            AddStringElement("nw_wbwsh001", RESREF, oPlayer);

            AddStringElement("[Sling BD: 1d4 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wbwsl001", RESREF, oPlayer);
            return;
        case SELECT_ARMOR:
            ReplaceIntElement(
                AddStringElement("[Arcana Robe AC: 0 ASF: 0 ACP: 0 MDB: 100]", LIST, oPlayer)-1,
                SELECT_ARMOR_ROBES,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Heavy", LIST, oPlayer)-1,
                SELECT_ARMOR_HEAVY,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Medium", LIST, oPlayer)-1,
                SELECT_ARMOR_MEDIUM,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Light", LIST, oPlayer)-1,
                SELECT_ARMOR_LIGHT,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Shield", LIST, oPlayer)-1,
                SELECT_ARMOR_SHIELD,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Helmet", LIST, oPlayer)-1,
                SELECT_ARMOR_HELMET,LIST,oPlayer);
            return;
        case SELECT_ARMOR_HEAVY:
            AddStringElement("[Splint Mail AC: 6 ASF: 40 ACP: -7 MDB: 1]", LIST, oPlayer);
            AddStringElement("nw_aarcl005", RESREF, oPlayer);

            AddStringElement("[Half Plate AC: 7 ASF: 40 ACP: -7 MDB: 1]", LIST, oPlayer);
            AddStringElement("nw_aarcl006", RESREF, oPlayer);

            AddStringElement("[Full Plate AC: 8 ASF: 45 ACP: -8 MDB: 1]", LIST, oPlayer);
            AddStringElement("nw_aarcl007", RESREF, oPlayer);
            return;
        case SELECT_ARMOR_MEDIUM:
            AddStringElement("[Scale Mail AC: 4 ASF: 20 ACP: -2 MDB: 4]", LIST, oPlayer);
            AddStringElement("nw_aarcl003", RESREF, oPlayer);

            AddStringElement("[Chain Mail AC: 5 ASF: 30 ACP: -5 MDB: 2]", LIST, oPlayer);
            AddStringElement("nw_aarcl004", RESREF, oPlayer);

            AddStringElement("[Hide Armor AC: 3 ASF: 20 ACP: -1 MDB: 4]", LIST, oPlayer);
            AddStringElement("nw_aarcl008", RESREF, oPlayer);

            AddStringElement("[Breastplate AC: 5 ASF: 30 ACP: -5 MDB: 2]", LIST, oPlayer);
            AddStringElement("nw_aarcl010", RESREF, oPlayer);
            return;
        case SELECT_ARMOR_LIGHT:
            AddStringElement("[Leather Armor AC: 2 ASF: 10 ACP: 0 MDB: 6]", LIST, oPlayer);
            AddStringElement("nw_aarcl001", RESREF, oPlayer);

            AddStringElement("[Stud. Leather AC: 3 ASF: 20 ACP: -1 MDB: 4]", LIST, oPlayer);
            AddStringElement("nw_aarcl002", RESREF, oPlayer);

            AddStringElement("[Padded Shirt AC: 1 ASF: 5 ACP: 0 MDB: 8]", LIST, oPlayer);
            AddStringElement("nw_aarcl009", RESREF, oPlayer);

            AddStringElement("[Chain Shirt AC: 4 ASF: 20 ACP: -2 MDB: 4]", LIST, oPlayer);
            AddStringElement("nw_aarcl012", RESREF, oPlayer);
            return;
        case SELECT_ARMOR_SHIELD:
            AddStringElement("Small Shield", LIST, oPlayer);
            AddStringElement("nw_ashsw001", RESREF, oPlayer);

            AddStringElement("Large Shield", LIST, oPlayer);
            AddStringElement("nw_ashlw001", RESREF, oPlayer);

            AddStringElement("Tower Shield", LIST, oPlayer);
            AddStringElement("nw_ashto001", RESREF, oPlayer);
            return;
        case SELECT_MAGIC_ITEM:
            AddStringElement("Amulet", LIST, oPlayer);
            AddStringElement("flel_it_amulet", RESREF, oPlayer);

            AddStringElement("Belt", LIST, oPlayer);
            AddStringElement("flel_it_belt", RESREF, oPlayer);

            AddStringElement("Boots", LIST, oPlayer);
            AddStringElement("flel_it_boots", RESREF, oPlayer);

            AddStringElement("Bracers", LIST, oPlayer);
            AddStringElement("flel_it_bracers", RESREF, oPlayer);

            AddStringElement("Cloak", LIST, oPlayer);
            AddStringElement("flel_it_cloak", RESREF, oPlayer);

            AddStringElement("Ring", LIST, oPlayer);
            AddStringElement("flel_it_ring", RESREF, oPlayer);
            return;
        case SELECT_PROJECTILE:
            ReplaceIntElement(
                AddStringElement("Ammunition", LIST, oPlayer)-1,
                SELECT_AMMUNITION,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Throwing Weapon", LIST, oPlayer)-1,
                SELECT_THROWING_WEAPON,LIST,oPlayer);
            AddIntElement(MAX_DAMAGE_DICE_AMMO,RESREF,oPlayer);
            AddIntElement(MAX_DAMAGE_DICE_THROWING_WEAP,RESREF,oPlayer);
            return;
        case SELECT_AMMUNITION:
            AddStringElement("Arrow", LIST, oPlayer);
            AddStringElement("nw_wamar001", RESREF, oPlayer);

            AddStringElement("Bolt", LIST, oPlayer);
            AddStringElement("nw_wambo001", RESREF, oPlayer);

            AddStringElement("Bullet", LIST, oPlayer);
            AddStringElement("nw_wambu001", RESREF, oPlayer);
            return;
        case SELECT_THROWING_WEAPON:
            AddStringElement("[Darts BD: 1d4 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wthdt001", RESREF, oPlayer);

            AddStringElement("[Shurikens BD: 1d3 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wthsh001", RESREF, oPlayer);

            AddStringElement("[Throwing Axes BD: 1d6 CR: 20x2]", LIST, oPlayer);
            AddStringElement("nw_wthax001", RESREF, oPlayer);
            return;
        case SELECT_DAMAGE_TYPE:
            ReplaceIntElement(
                AddStringElement("Bludgeoning",LIST,oPlayer)-1,
                IP_CONST_DAMAGETYPE_BLUDGEONING,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Piercing",LIST,oPlayer)-1,
                IP_CONST_DAMAGETYPE_PIERCING,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Slashing",LIST,oPlayer)-1,
                IP_CONST_DAMAGETYPE_SLASHING,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Acid",LIST,oPlayer)-1,
                IP_CONST_DAMAGETYPE_ACID,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Cold",LIST,oPlayer)-1,
                IP_CONST_DAMAGETYPE_COLD,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Electrical",LIST,oPlayer)-1,
                IP_CONST_DAMAGETYPE_ELECTRICAL,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Fire",LIST,oPlayer)-1,
                IP_CONST_DAMAGETYPE_FIRE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Sonic",LIST,oPlayer)-1,
                IP_CONST_DAMAGETYPE_SONIC,LIST,oPlayer);
            break;
        case SELECT_MASSCRITS:
        case SELECT_DAMAGE_DIE:
            /*ReplaceIntElement(
                AddStringElement("+1",LIST,oPlayer)-1,
                IP_CONST_DAMAGEBONUS_1,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("+2",LIST,oPlayer)-1,
                IP_CONST_DAMAGEBONUS_2,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("+3",LIST,oPlayer)-1,
                IP_CONST_DAMAGEBONUS_3,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("+4",LIST,oPlayer)-1,
                IP_CONST_DAMAGEBONUS_4,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("+5",LIST,oPlayer)-1,
                IP_CONST_DAMAGEBONUS_5,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("+6",LIST,oPlayer)-1,
                IP_CONST_DAMAGEBONUS_6,LIST,oPlayer);*/
            ReplaceIntElement(
                AddStringElement("+1d4",LIST,oPlayer)-1,
                IP_CONST_DAMAGEBONUS_1d4,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("+1d6",LIST,oPlayer)-1,
                IP_CONST_DAMAGEBONUS_1d6,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("+2d4",LIST,oPlayer)-1,
                IP_CONST_DAMAGEBONUS_2d4,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("+2d6",LIST,oPlayer)-1,
                IP_CONST_DAMAGEBONUS_2d6,LIST,oPlayer);
            break;
        case SELECT_ONHIT_TYPE:
            ReplaceIntElement(
                AddStringElement("Ability Drain",LIST,oPlayer)-1,
                IP_CONST_ONHIT_ABILITYDRAIN,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Blindness",LIST,oPlayer)-1,
                IP_CONST_ONHIT_BLINDNESS,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Confusion",LIST,oPlayer)-1,
                IP_CONST_ONHIT_CONFUSION,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Daze",LIST,oPlayer)-1,
                IP_CONST_ONHIT_DAZE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Deafness",LIST,oPlayer)-1,
                IP_CONST_ONHIT_DEAFNESS,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Disease",LIST,oPlayer)-1,
                IP_CONST_ONHIT_DISEASE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Doom",LIST,oPlayer)-1,
                IP_CONST_ONHIT_DOOM,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Fear",LIST,oPlayer)-1,
                IP_CONST_ONHIT_FEAR,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Hold",LIST,oPlayer)-1,
                IP_CONST_ONHIT_HOLD,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Level Drain",LIST,oPlayer)-1,
                IP_CONST_ONHIT_LEVELDRAIN,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Poison",LIST,oPlayer)-1,
                IP_CONST_ONHIT_ITEMPOISON,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Silence",LIST,oPlayer)-1,
                IP_CONST_ONHIT_SILENCE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Sleep",LIST,oPlayer)-1,
                IP_CONST_ONHIT_SLEEP,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Slow",LIST,oPlayer)-1,
                IP_CONST_ONHIT_SLOW,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Stun",LIST,oPlayer)-1,
                IP_CONST_ONHIT_STUN,LIST,oPlayer);
            /*ReplaceIntElement(
                AddStringElement("Vorpal",LIST,oPlayer)-1,
                IP_CONST_ONHIT_VORPAL,LIST,oPlayer);*/
            ReplaceIntElement(
                AddStringElement("Wounding",LIST,oPlayer)-1,
                IP_CONST_ONHIT_WOUNDING,LIST,oPlayer);
            break;
        case SELECT_ONHIT_DC:
            ReplaceIntElement(
                AddStringElement("DC 14",LIST,oPlayer)-1,
                IP_CONST_ONHIT_SAVEDC_14,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("DC 16",LIST,oPlayer)-1,
                IP_CONST_ONHIT_SAVEDC_16,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("DC 18",LIST,oPlayer)-1,
                IP_CONST_ONHIT_SAVEDC_18,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("DC 20",LIST,oPlayer)-1,
                IP_CONST_ONHIT_SAVEDC_20,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("DC 22",LIST,oPlayer)-1,
                IP_CONST_ONHIT_SAVEDC_22,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("DC 24",LIST,oPlayer)-1,
                IP_CONST_ONHIT_SAVEDC_24,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("DC 26",LIST,oPlayer)-1,
                IP_CONST_ONHIT_SAVEDC_26,LIST,oPlayer);
            break;
        case SELECT_ONHIT_DURATION:
            ReplaceIntElement(
                AddStringElement("5%/5 rounds",LIST,oPlayer)-1,
                IP_CONST_ONHIT_DURATION_5_PERCENT_5_ROUNDS,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("10%/4 rounds",LIST,oPlayer)-1,
                IP_CONST_ONHIT_DURATION_10_PERCENT_4_ROUNDS,LIST,oPlayer);
             ReplaceIntElement(
                AddStringElement("25%/3 rounds",LIST,oPlayer)-1,
                IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS,LIST,oPlayer);
             ReplaceIntElement(
                AddStringElement("50%/2 rounds",LIST,oPlayer)-1,
                IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS,LIST,oPlayer);
             ReplaceIntElement(
                AddStringElement("75%/1 round",LIST,oPlayer)-1,
                IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND,LIST,oPlayer);
            break;
        case SELECT_ONHIT_DISEASE:
            ReplaceIntElement(
                AddStringElement("Blinding Sickness",LIST,oPlayer)-1,
                DISEASE_BLINDING_SICKNESS,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Burrow Maggots",LIST,oPlayer)-1,
                DISEASE_BURROW_MAGGOTS,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Cackle Fever",LIST,oPlayer)-1,
                DISEASE_CACKLE_FEVER,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Demon Fever",LIST,oPlayer)-1,
                DISEASE_DEMON_FEVER,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Devil Chills",LIST,oPlayer)-1,
                DISEASE_DEVIL_CHILLS,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Dread Blisters",LIST,oPlayer)-1,
                DISEASE_DREAD_BLISTERS,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Filth Fever",LIST,oPlayer)-1,
                DISEASE_FILTH_FEVER,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Ghoul Rot",LIST,oPlayer)-1,
                DISEASE_GHOUL_ROT,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Mindfire",LIST,oPlayer)-1,
                DISEASE_MINDFIRE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Mummy Rot",LIST,oPlayer)-1,
                DISEASE_MUMMY_ROT,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Red Ache",LIST,oPlayer)-1,
                DISEASE_RED_ACHE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Red Slaad Eggs",LIST,oPlayer)-1,
                DISEASE_RED_SLAAD_EGGS,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Shakes",LIST,oPlayer)-1,
                DISEASE_SHAKES,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Slimy Doom",LIST,oPlayer)-1,
                DISEASE_SLIMY_DOOM,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Soldier Shakes",LIST,oPlayer)-1,
                DISEASE_SOLDIER_SHAKES,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Vermin Madness",LIST,oPlayer)-1,
                DISEASE_VERMIN_MADNESS,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Zombie Creep",LIST,oPlayer)-1,
                DISEASE_ZOMBIE_CREEP,LIST,oPlayer);
            break;
        case SELECT_ONHIT_POISON:
            ReplaceIntElement(
                AddStringElement("1d2 Charisma Damage",LIST,oPlayer)-1,
                IP_CONST_POISON_1D2_CHADAMAGE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("1d2 Constitution Damage",LIST,oPlayer)-1,
                IP_CONST_POISON_1D2_CONDAMAGE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("1d2 Dexterity Damage",LIST,oPlayer)-1,
                IP_CONST_POISON_1D2_DEXDAMAGE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("1d2 Intelligence Damage",LIST,oPlayer)-1,
                IP_CONST_POISON_1D2_INTDAMAGE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("1d2 Strength Damage",LIST,oPlayer)-1,
                IP_CONST_POISON_1D2_STRDAMAGE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("1d2 Wisom Damage",LIST,oPlayer)-1,
                IP_CONST_POISON_1D2_WISDAMAGE,LIST,oPlayer);
            break;
        case SELECT_ABILITY_TYPE:
            ReplaceIntElement(
                AddStringElement("Strength",LIST,oPlayer)-1,
                IP_CONST_ABILITY_STR,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Dexterity",LIST,oPlayer)-1,
                IP_CONST_ABILITY_DEX,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Constitution",LIST,oPlayer)-1,
                IP_CONST_ABILITY_CON,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Wisdom",LIST,oPlayer)-1,
                IP_CONST_ABILITY_WIS,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Intelligence",LIST,oPlayer)-1,
                IP_CONST_ABILITY_INT,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Charisma",LIST,oPlayer)-1,
                IP_CONST_ABILITY_CHA,LIST,oPlayer);
            break;
        case SELECT_SKILL_TYPE:
            ReplaceIntElement(
                AddStringElement("Animal Empathy",LIST,oPlayer)-1,
                SKILL_ANIMAL_EMPATHY,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Concentration",LIST,oPlayer)-1,
                SKILL_CONCENTRATION,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Disable Trap",LIST,oPlayer)-1,
                SKILL_DISABLE_TRAP,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Discipline",LIST,oPlayer)-1,
                SKILL_DISCIPLINE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Heal",LIST,oPlayer)-1,
                SKILL_HEAL,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Hide",LIST,oPlayer)-1,
                SKILL_HIDE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Intimidate",LIST,oPlayer)-1,
                SKILL_INTIMIDATE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Listen",LIST,oPlayer)-1,
                SKILL_LISTEN,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Move Silently",LIST,oPlayer)-1,
                SKILL_MOVE_SILENTLY,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Open Lock",LIST,oPlayer)-1,
                SKILL_OPEN_LOCK,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Parry",LIST,oPlayer)-1,
                SKILL_PARRY,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Perform",LIST,oPlayer)-1,
                SKILL_PERFORM,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Pick Pocket",LIST,oPlayer)-1,
                SKILL_PICK_POCKET,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Search",LIST,oPlayer)-1,
                SKILL_SEARCH,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Set Trap",LIST,oPlayer)-1,
                SKILL_SET_TRAP,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Spellcraft",LIST,oPlayer)-1,
                SKILL_SPELLCRAFT,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Spot",LIST,oPlayer)-1,
                SKILL_SPOT,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Taunt",LIST,oPlayer)-1,
                SKILL_TAUNT,LIST,oPlayer);
            ReplaceIntElement(
                 AddStringElement("Tumble",LIST,oPlayer)-1,
                SKILL_TUMBLE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Use Magic Device",LIST,oPlayer)-1,
                SKILL_USE_MAGIC_DEVICE,LIST,oPlayer);
            break;
        case SELECT_SAVE_TYPE:
            ReplaceIntElement(
                AddStringElement("Fortitude",LIST,oPlayer)-1,
                IP_CONST_SAVEBASETYPE_FORTITUDE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Reflex",LIST,oPlayer)-1,
                IP_CONST_SAVEBASETYPE_REFLEX,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Will",LIST,oPlayer)-1,
                IP_CONST_SAVEBASETYPE_WILL,LIST,oPlayer);
            break;
        case SELECT_SAVE_EFFECT_TYPE:
            ReplaceIntElement(
                AddStringElement("Acid",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_ACID,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Cold",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_COLD,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Death",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_DEATH,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Disease",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_DISEASE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Divine",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_DIVINE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Electrical",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_ELECTRICAL,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Fear",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_FEAR,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Fire",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_FIRE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Mind-affecting",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_MINDAFFECTING,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Negative",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_NEGATIVE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Poison",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_POISON,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Positive",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_POSITIVE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Sonic",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_SONIC,LIST,oPlayer);
            /*ReplaceIntElement(
                AddStringElement("Universal",LIST,oPlayer)-1,
                IP_CONST_SAVEVS_UNIVERSAL,LIST,oPlayer); */
            break;
        case SELECT_BONUS_SPELLSLOT:
            ReplaceIntElement(
                AddStringElement("Bard",LIST,oPlayer)-1,
                IP_CONST_CLASS_BARD,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Cleric",LIST,oPlayer)-1,
                IP_CONST_CLASS_CLERIC,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Druid",LIST,oPlayer)-1,
                IP_CONST_CLASS_DRUID,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Paladin",LIST,oPlayer)-1,
                IP_CONST_CLASS_PALADIN,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Ranger",LIST,oPlayer)-1,
                IP_CONST_CLASS_RANGER,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Sorceror",LIST,oPlayer)-1,
                IP_CONST_CLASS_SORCERER,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Wizard",LIST,oPlayer)-1,
                IP_CONST_CLASS_WIZARD,LIST,oPlayer);
            break;
        case SELECT_LIGHT_COLOR:
            ReplaceIntElement(
                AddStringElement("Blue",LIST,oPlayer)-1,
                IP_CONST_LIGHTCOLOR_BLUE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Green",LIST,oPlayer)-1,
                IP_CONST_LIGHTCOLOR_GREEN,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Orange",LIST,oPlayer)-1,
                IP_CONST_LIGHTCOLOR_ORANGE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Purple",LIST,oPlayer)-1,
                IP_CONST_LIGHTCOLOR_PURPLE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Red",LIST,oPlayer)-1,
                IP_CONST_LIGHTCOLOR_RED,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("White",LIST,oPlayer)-1,
                IP_CONST_LIGHTCOLOR_WHITE,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Yellow",LIST,oPlayer)-1,
                IP_CONST_LIGHTCOLOR_YELLOW,LIST,oPlayer);
            break;
        case SELECT_LIGHT_BRIGHTNESS:
            ReplaceIntElement(
                AddStringElement("Bright",LIST,oPlayer)-1,
                IP_CONST_LIGHTBRIGHTNESS_BRIGHT,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Dim",LIST,oPlayer)-1,
                IP_CONST_LIGHTBRIGHTNESS_DIM,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Low",LIST,oPlayer)-1,
                IP_CONST_LIGHTBRIGHTNESS_LOW,LIST,oPlayer);
            ReplaceIntElement(
                AddStringElement("Normal",LIST,oPlayer)-1,
                IP_CONST_LIGHTBRIGHTNESS_NORMAL,LIST,oPlayer);
            break;
        case SELECT_AC_B:
            //if (
            for (i=1;i<=MAX_AC_BONUS;i++)
                AddStringElement("+" + IntToString(i),LIST,oPlayer);
            break;
        case SELECT_ABILITY_BONUS:
            for (i=1;i<=MAX_ABILITY_BONUS-GetLocalInt(oPlayer,CURRENT_ABILITY_BONUS);i++)
                AddStringElement("+" + IntToString(i),LIST,oPlayer);
            break;
        case SELECT_SKILL_BONUS:
            for (i=1;i<=(MAX_SKILL_BONUS-GetLocalInt(oPlayer,CURRENT_SKILL_BONUS));i++)
                AddStringElement("+" + IntToString(i),LIST,oPlayer);
            break;
        case SELECT_SAVE_BONUS:
            for (i=1;i<=(MAX_SAVE_BONUS-GetLocalInt(oPlayer,CURRENT_SAVE_BONUS));i++)
                AddStringElement("+" + IntToString(i),LIST,oPlayer);
            break;
        case SELECT_SAVE_EFFECT_BONUS:
            for (i=1;i<=(MAX_SAVE_EFFECT_BONUS-GetLocalInt(oPlayer,CURRENT_SAVE_EFFECT_BONUS));i++)
                AddStringElement("+" + IntToString(i),LIST,oPlayer);
            break;
        case SELECT_SPELLSLOT_LEVEL:
            for (i=GetMinSpellLevel(oPlayer);i<=GetMaxSpellLevel(oPlayer);i++)
                AddStringElement("Level " + IntToString(i),LIST,oPlayer);
            break;
        case SELECT_REGEN:
            for (i=0;i<(MAX_REGEN-GetLocalInt(oPlayer,CURRENT_REGEN));i++)
                AddStringElement("+" + IntToString(i+1),LIST,oPlayer);
            break;
        case SELECT_EB:
        case SELECT_AB:
            for (i=1;i<=MAX_AB_EB_BONUS;i++)
                AddStringElement("+" + IntToString(i),LIST,oPlayer);
            break;
        case SELECT_VAMP_REGEN:
            for (i=1;i<=MAX_VAMP_REGEN-GetLocalInt(oPlayer,CURRENT_VAMP_REGEN);i++)
                AddStringElement("+" + IntToString(i),LIST,oPlayer);
            break;
        case SELECT_MIGHTY:
            for (i=1;i<=MAX_MIGHTY;i++)
                AddStringElement("+" + IntToString(i),LIST,oPlayer);
            break;
    }
    BuildBackButton();
}

int GetItemLevelByGold(object oItem)
{
    // Get item value
    int iItemCost = GetGoldPieceValue(oItem);

    // Get items level based on its value from 2da file
    if (iItemCost < 1000)      iItemCost = 1;
    else if (iItemCost < 1500) iItemCost = 2;
    else if (iItemCost < 2500) iItemCost = 3;
    else if (iItemCost < 3500) iItemCost = 4;
    else if (iItemCost < 5000) iItemCost = 5;
    else if (iItemCost < 6500) iItemCost = 6;
    else if (iItemCost < 9000) iItemCost = 7;
    else if (iItemCost < 12000) iItemCost = 8;
    else if (iItemCost < 15000) iItemCost = 9;
    else if (iItemCost < 19500) iItemCost = 10;
    else if (iItemCost < 25000) iItemCost = 11;
    else if (iItemCost < 30000) iItemCost = 12;
    else if (iItemCost < 35000) iItemCost = 13;
    else if (iItemCost < 40000) iItemCost = 14;
    else if (iItemCost < 50000) iItemCost = 15;
    else if (iItemCost < 65000) iItemCost = 16;
    else if (iItemCost < 75000) iItemCost = 17;
    else if (iItemCost < 90000) iItemCost = 18;
    else if (iItemCost < 110000) iItemCost = 19;
    else if (iItemCost < 130000) iItemCost = 20;
    else if (iItemCost < 250000) iItemCost = 21;
    else if (iItemCost < 500000) iItemCost = 22;
    else if (iItemCost < 750000) iItemCost = 23;
    else if (iItemCost < 1000000) iItemCost = 24;
    else if (iItemCost < 1200000) iItemCost = 25;
    else if (iItemCost < 1400000) iItemCost = 26;
    else if (iItemCost < 1600000) iItemCost = 27;
    else if (iItemCost < 1800000) iItemCost = 28;
    else if (iItemCost < 2000000) iItemCost = 29;
    else if (iItemCost < 2200000) iItemCost = 30;
    else if (iItemCost < 2400000) iItemCost = 31;
    else if (iItemCost < 2600000) iItemCost = 32;
    else if (iItemCost < 2800000) iItemCost = 33;
    else if (iItemCost < 3000000) iItemCost = 34;
    else if (iItemCost < 3200000) iItemCost = 35;
    else if (iItemCost < 3400000) iItemCost = 36;
    else if (iItemCost < 3600000) iItemCost = 37;
    else if (iItemCost < 3800000) iItemCost = 38;
    else if (iItemCost < 4000000) iItemCost = 39;
    else if (iItemCost < 4200000) iItemCost = 40;
    else if (iItemCost < 4400000) iItemCost = 41;
    else if (iItemCost < 4600000) iItemCost = 42;
    else if (iItemCost < 4800000) iItemCost = 43;
    else if (iItemCost < 5000000) iItemCost = 44;
    else if (iItemCost < 5200000) iItemCost = 45;
    else if (iItemCost < 5400000) iItemCost = 46;
    else if (iItemCost < 5600000) iItemCost = 47;
    else if (iItemCost < 5800000) iItemCost = 48;
    else if (iItemCost < 6000000) iItemCost = 49;
    else if (iItemCost < 6200000) iItemCost = 50;
    else if (iItemCost < 6400000) iItemCost = 51;
    else if (iItemCost < 6600000) iItemCost = 52;
    else if (iItemCost < 6800000) iItemCost = 53;
    else if (iItemCost < 7000000) iItemCost = 54;
    else if (iItemCost < 7200000) iItemCost = 55;
    else if (iItemCost < 7400000) iItemCost = 56;
    else if (iItemCost < 7600000) iItemCost = 57;
    else if (iItemCost < 7800000) iItemCost = 58;
    else if (iItemCost < 8000000) iItemCost = 59;
    else                          iItemCost = 60;
    // Return the items required level
    return iItemCost;
}

void SetItem (object oItem)
{
    DeleteLocalObject(GetPcDlgSpeaker(),ITEM);
    SetLocalObject(GetPcDlgSpeaker(),ITEM,oItem);
}

int GetSelector()
{
    return GetLocalInt(GetPcDlgSpeaker(), SELECTOR);
}

int GetLastSelector()
{
    return GetLocalInt(GetPcDlgSpeaker(), LAST_SELECTOR);
}

void SetSelector(int nSelector)
{
    object oPlayer = GetPcDlgSpeaker();
    SetLocalInt(oPlayer, LAST_SELECTOR,GetSelector());
    SetLocalInt(oPlayer, SELECTOR, nSelector);
}

void CreateWorkingItem(int nStackSize = 1, string sResRef = "")
{
    object oPlayer = GetPcDlgSpeaker();
    if (sResRef == "")
        sResRef = GetStringElement(GetDlgSelection(),RESREF,oPlayer);
    object oItem = CreateItemOnObject(sResRef, OBJECT_SELF, nStackSize);
    SetDroppableFlag(oItem, FALSE);
    SetLocalObject(oPlayer, ITEM, oItem);
}

void HandleSelection ()
{
    object oPlayer = GetPcDlgSpeaker();
    int nSelector = GetSelector();

    int nSelection = GetDlgSelection(); // The option chosen
    object oItem = GetItem(); // The working object

    // Some vars needed for multiple-optioned item properties
    int nCurrentProperty;
    int nPropertyType;
    int nProperty;

    itemproperty ipLast; // The last itemproperty added

    int nStackSize = 1;

    if ((GetShowing() & SHOW_NAV_RETURN))
    {
        if ((GetShowing() & SHOW_NAV_BACK) && nSelection == GetDlgResponseCount(oPlayer)-2 && GetIntElement(nSelection, GetDlgResponseList(),oPlayer) == SELECT_NAV_BACK)
        {
            SetLocalInt(oPlayer, SELECTOR, GetLastSelector());
            return;
        }
        else if  ( nSelection == GetDlgResponseCount(oPlayer)-1 && GetIntElement(nSelection, GetDlgResponseList(),oPlayer) == SELECT_NAV_RETURN )
        {
            SetLocalInt(oPlayer, SELECTOR, SELECT_CONFIRM_DIALOG);
            return;
        }
    }

    switch (nSelector)
    {
        case SELECT_AMMUNITION:
            SetShowing(SHOW_DAMAGE_BONUS | SHOW_VAMP_REGEN | SHOW_ONHIT);
            CreateWorkingItem(99);
            break;
        case SELECT_THROWING_WEAPON:
            SetShowing(SHOW_ALL^(SHOW_MIGHTY|SHOW_KEEN));
            CreateWorkingItem(99);
            break;
        case SELECT_WEAPON_LARGE:
        case SELECT_WEAPON_SMALL:
        case SELECT_WEAPON_MEDIUM:
            SetShowing(SHOW_ALL^(SHOW_MIGHTY));
            CreateWorkingItem();
            break;
        case SELECT_WEAPON_RANGED:
            SetShowing(SHOW_ALL^(SHOW_KEEN | SHOW_DAMAGE_BONUS | SHOW_VAMP_REGEN | SHOW_ONHIT | SHOW_EB));
            CreateWorkingItem();
            break;
        case SELECT_ARMOR_HEAVY:
        case SELECT_ARMOR_MEDIUM:
        case SELECT_ARMOR_SHIELD:
        case SELECT_ARMOR_LIGHT:
        case SELECT_MAGIC_ITEM:
            SetShowing(SHOW_ITEM_PROPERTIES);
            CreateWorkingItem();
            break;
        case SELECT_WEAPON:
            SetLocalInt(oPlayer,MAX_DAMAGE_DICE, GetIntElement(GetDlgSelection(),RESREF,oPlayer) );
            if (GetIntElement(GetDlgSelection(),GetDlgResponseList(),oPlayer) == SELECT_MONK_GLOVES)
            {
                SetShowing(SHOW_ALL^(SHOW_KEEN | SHOW_EB | SHOW_MASSCRITS));
                CreateWorkingItem(1,"flel_it_mgloves");
                break;
            }
        case SELECT_ARMOR:
            if (GetIntElement(GetDlgSelection(),GetDlgResponseList(),oPlayer) == SELECT_ARMOR_HELMET)
            {
                SetShowing(SHOW_ITEM_PROPERTIES);
                CreateWorkingItem(1,"flel_it_helmet");
                break;
            }
            if (GetIntElement(GetDlgSelection(),GetDlgResponseList(),oPlayer) == SELECT_ARMOR_ROBES)
            {
                SetShowing(SHOW_ITEM_PROPERTIES);
                CreateWorkingItem(1,"flel_it_robe");
                break;
            }
        case SELECT_PROJECTILE:
            SetLocalInt(oPlayer,MAX_DAMAGE_DICE, GetIntElement(GetDlgSelection(),RESREF,oPlayer) );
            SetSelector(GetIntElement(GetDlgSelection(),GetDlgResponseList(),oPlayer));
            return;
        case SELECT_WEAPON_PROPERTIES:
            if (GetIntElement(GetDlgSelection(),LIST,oPlayer) == SELECT_KEEN)
            {
                ipLast = ItemPropertyKeen();
                break;
            }
            SetSelector(GetIntElement(nSelection,LIST,oPlayer));
            return;
        case SELECT_ITEM_PROPERTIES:
            SetSelector(GetIntElement(nSelection,LIST,oPlayer));
            return;
        case SELECT_OTHER_ITEM_PROPS:
            if (GetIntElement(GetDlgSelection(),LIST,oPlayer) == SELECT_HASTE)
                ipLast = ItemPropertyHaste();
            else if (GetIntElement(GetDlgSelection(),LIST,oPlayer) == SELECT_DARKVISION)
                ipLast = ItemPropertyDarkvision();
            else
            {
                SetSelector(GetIntElement(nSelection,LIST,oPlayer));
                return;
            }
            break;
        case SELECT_CONFIRM_DIALOG:
            if (GetDlgSelection() == 1) {
               AssignCommand(oPlayer, ActionExamine(oItem));
               SetSelector(SELECT_CONFIRM_DIALOG);
               return;
            }
            if (GetDlgSelection() == 2)
            {
                oItem = GetItem();
                nPropertyType = GetBaseItemType(oItem); // recycling old vars
                nProperty = GetGoldPieceValue(oItem) * 3;

                if (GetGold(oPlayer) < nProperty)
                {
                    SendMessageToPC(oPlayer,GetRGB(11,9,11) + "You cannot afford this item.");
                    DestroyObject(oItem);
                    EndDlg();
                    return;
                }

                if (nPropertyType == BASE_ITEM_ARROW || nPropertyType == BASE_ITEM_BOLT || nPropertyType == BASE_ITEM_BULLET || nPropertyType == BASE_ITEM_DART || nPropertyType == BASE_ITEM_SHURIKEN || nPropertyType == BASE_ITEM_THROWINGAXE)
                {
                    if (!GetIsObjectValid(GetItemPossessedBy(oPlayer,"flel_it_ammo_crt")))
                    {
                        CreateItemOnObject("flel_it_ammo_crt",oPlayer);
                        if (StoreCampaignObject("AMMO_CREATORS","ACRT_", oItem,oPlayer))
                            SendMessageToPC(oPlayer,GetRGB(11,9,11) + "Successfully created ammo creator");
                        else
                            SendMessageToPC(oPlayer,GetRGB(11,9,11) + "Failed to create ammo creator");
                        nProperty *= 5;
                    }
                    else
                    {
                        SendMessageToPC(oPlayer,GetRGB(11,9,11) + "You already have an ammo creator, sell your old one first.");
                        DestroyObject(oItem);
                        EndDlg();
                        return;
                    }
                }
                else
                    CopyItem(oItem,oPlayer);
                TakeGoldFromCreature(nProperty,oPlayer);
                DestroyObject(oItem);
                EndDlg();
            }
            else
            {
                if (GetShowing() & SHOW_WEAPON_PROPERTIES)
                    SetSelector(SELECT_WEAPON_PROPERTIES);
                else
                    SetSelector(SELECT_ITEM_PROPERTIES);
            }
            return;
        case SELECT_ABILITY_TYPE: // If the user has last chosen an ability (to add points into)
            SetLocalInt(oPlayer, ABILITY_TYPE_SELECTED, GetIntElement(nSelection,GetDlgResponseList(),oPlayer)); // Store the ability chosen
            SetSelector(SELECT_ABILITY_BONUS); // Forward the user to selecting the amounts of points
            return;
        case SELECT_ABILITY_BONUS: // Forwarded to after selecting an ability
            nCurrentProperty = GetLocalInt(oPlayer,CURRENT_ABILITY_BONUS); // The amount of points that already have been added onto the working item
            nPropertyType = GetLocalInt(oPlayer,ABILITY_TYPE_SELECTED); // The ability chosen stored earlier
            nProperty = nSelection+1; // The number of ability points selected to be added
            if (nCurrentProperty < MAX_ABILITY_BONUS) // Double checking if PC not trying to add more ability than allowed
            {
                ipLast = ItemPropertyAbilityBonus(nPropertyType,nProperty); // Create the property and store it
                ReserveProperty(SHOW_ABILITY_BONUS); // Reserve this property so that other properties cant be added any longer
                SetLocalInt(oPlayer,CURRENT_ABILITY_BONUS,nCurrentProperty+nProperty); // Store the amount of properties added
            }
            break; // Break and add the item property
        case SELECT_SKILL_TYPE: // If the user has selected a skill type to add points into
            SetLocalInt(oPlayer, SKILL_TYPE_SELECTED, GetIntElement(nSelection,GetDlgResponseList(),oPlayer)); // Store the skill selected
            SetSelector(SELECT_SKILL_BONUS); // Forward PC to skill bonus selection
            return;
        case SELECT_SKILL_BONUS: // Forwared to after chosing a skill
            nCurrentProperty = GetLocalInt(oPlayer,CURRENT_SKILL_BONUS); // The amount of sp already added to the working object
            nPropertyType = GetLocalInt(oPlayer,SKILL_TYPE_SELECTED); // The skill selected before
            nProperty = GetDlgSelection()+1; // The amount of points selected to add
            if (nCurrentProperty < MAX_SKILL_BONUS) // Double check
            {
                ipLast = ItemPropertySkillBonus(nPropertyType,nProperty); // Make the property
                ReserveProperty(SHOW_SKILL_BONUS); // Reserve the property
                SetLocalInt(oPlayer,CURRENT_SKILL_BONUS,nCurrentProperty+nProperty); // Store the amount of sp added
            }
            break; //Break and add the item prop
        case SELECT_SAVE_TYPE:
            SetLocalInt(oPlayer, SAVE_TYPE_SELECTED, GetIntElement(nSelection,GetDlgResponseList(),oPlayer));
            SetSelector(SELECT_SAVE_BONUS);
            return;
        case SELECT_SAVE_BONUS:
            nCurrentProperty = GetLocalInt(oPlayer,CURRENT_SAVE_BONUS);
            nPropertyType = GetLocalInt(oPlayer,SAVE_TYPE_SELECTED);
            nProperty = GetDlgSelection()+1;
            if (nCurrentProperty < MAX_SAVE_BONUS)
            {
                ipLast = ItemPropertyBonusSavingThrow(nPropertyType,nProperty);
                if (nPropertyType == IP_CONST_SAVEBASETYPE_FORTITUDE)
                {
                    SetLocalInt(oPlayer, "CURRENT_FORT_BONUS", GetLocalInt(oPlayer, "CURRENT_FORT_BONUS")+nProperty);
                    if (GetLocalInt(oPlayer, "CURRENT_FORT_BONUS")>2)
                        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_DEATH,GetLocalInt(oPlayer, "CURRENT_FORT_BONUS")-2), GetItem());
                }
                ReserveProperty(SHOW_SAVE_BONUS);
                SetLocalInt(oPlayer,CURRENT_SAVE_BONUS,nCurrentProperty+nProperty);
            }
            break;
        case SELECT_SAVE_EFFECT_TYPE:
            SetLocalInt(oPlayer, SAVE_EFFECT_TYPE_SELECTED, GetIntElement(nSelection,GetDlgResponseList(),oPlayer));
            SetSelector(SELECT_SAVE_EFFECT_BONUS);
            return;
        case SELECT_SAVE_EFFECT_BONUS:
            nCurrentProperty = GetLocalInt(oPlayer,CURRENT_SAVE_EFFECT_BONUS);
            nPropertyType = GetLocalInt(oPlayer,SAVE_EFFECT_TYPE_SELECTED);
            nProperty = GetDlgSelection()+1;
            if (nCurrentProperty < MAX_SAVE_EFFECT_BONUS)
            {
                ipLast = ItemPropertyBonusSavingThrowVsX(nPropertyType,nProperty);
                ReserveProperty(SHOW_SAVE_EFFECT_BONUS);
                SetLocalInt(oPlayer,CURRENT_SAVE_EFFECT_BONUS,nCurrentProperty+nProperty);
            }
            break;
        case SELECT_BONUS_SPELLSLOT:
            SetLocalInt(oPlayer, SPELLSLOT_CLASS_SELECTED, GetIntElement(nSelection,GetDlgResponseList(),oPlayer));
            SetSelector(SELECT_SPELLSLOT_LEVEL);
            return;
        case SELECT_SPELLSLOT_LEVEL:
            nCurrentProperty = GetLocalInt(oPlayer,CURRENT_BONUS_SPELLSLOTS);
            nPropertyType = GetLocalInt(oPlayer,SPELLSLOT_CLASS_SELECTED);
            nProperty = nSelection+ GetMinSpellLevel(oPlayer);
            // Check if PC is allowed to add more save points
            if (nCurrentProperty < MAX_BONUS_SPELLSLOTS) // Grab the damage type from the local var and add the item property
            {
                ipLast = ItemPropertyBonusLevelSpell(nPropertyType,nProperty);
                ReserveProperty(SHOW_BONUS_SPELLSLOT);
                SetLocalInt(oPlayer,CURRENT_BONUS_SPELLSLOTS,nCurrentProperty+1);
            }
            break;
        case SELECT_LIGHT_BRIGHTNESS:
            SetLocalInt(oPlayer, LIGHT_BRIGHTNESS_SELECTED, GetIntElement(nSelection,GetDlgResponseList(),oPlayer));
            SetSelector(SELECT_LIGHT_COLOR);
            return;
        case SELECT_LIGHT_COLOR:
            ipLast = ItemPropertyLight(
                GetLocalInt(oPlayer,LIGHT_BRIGHTNESS_SELECTED),
                    GetIntElement(nSelection,GetDlgResponseList(),oPlayer));
            break;
        case SELECT_REGEN:
            ipLast = ItemPropertyRegeneration(nSelection+1);
            SetLocalInt(oPlayer,CURRENT_REGEN,GetLocalInt(oPlayer,CURRENT_REGEN)+nSelection+1);
            ReserveProperty(SHOW_REGEN);
            break;
        case SELECT_AC_B:
            IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_AC_BONUS, DURATION_TYPE_PERMANENT); // remove any AC bonus already there to prevent dodge bonus from stacking
            ipLast = ItemPropertyACBonus(nSelection+1);
            break;
        case SELECT_EB:
            IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS, DURATION_TYPE_PERMANENT);
            ipLast = ItemPropertyEnhancementBonus(GetDlgSelection()+1);
            break;
        case SELECT_AB:
            IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ATTACK_BONUS, DURATION_TYPE_PERMANENT);
            ipLast = ItemPropertyAttackBonus(GetDlgSelection()+1);
            break;
        case SELECT_DAMAGE_TYPE:
            SetLocalInt(oPlayer,DAMAGE_TYPE_SELECTED,GetIntElement(GetDlgSelection(),GetDlgResponseList(),oPlayer));
            SetSelector(SELECT_DAMAGE_DIE);
            return;
        case SELECT_DAMAGE_DIE:
            nCurrentProperty = GetLocalInt(oPlayer,CURRENT_DAMAGE_DICE);
            nPropertyType = GetLocalInt(oPlayer,DAMAGE_TYPE_SELECTED);
            nProperty = GetIntElement(GetDlgSelection(),GetDlgResponseList(),oPlayer);
            if (nCurrentProperty < GetLocalInt(oPlayer,MAX_DAMAGE_DICE))
            {
                ipLast = ItemPropertyDamageBonus(nPropertyType,nProperty);
                SetLocalInt(oPlayer,CURRENT_DAMAGE_DICE,nCurrentProperty+1);
                if (nCurrentProperty+1 == GetLocalInt(oPlayer,MAX_DAMAGE_DICE))
                    SetShowing(GetShowing() ^ SHOW_DAMAGE_BONUS);
            }
            break;
        case SELECT_ONHIT_TYPE:
            SetLocalInt(oPlayer,ONHIT_TYPE_SELECTED,GetIntElement(GetDlgSelection(),GetDlgResponseList(),oPlayer));
            SetSelector(SELECT_ONHIT_DC);
            return;
        case SELECT_ONHIT_DC:
            nPropertyType = GetLocalInt(oPlayer, ONHIT_TYPE_SELECTED);
            nCurrentProperty = GetLocalInt(oPlayer,CURRENT_ONHITS);
            nProperty = GetIntElement(GetDlgSelection(),GetDlgResponseList(),oPlayer);
            if (nPropertyType == IP_CONST_ONHIT_VORPAL || nPropertyType == IP_CONST_ONHIT_WOUNDING || nPropertyType == IP_CONST_ONHIT_LEVELDRAIN)
            {
                if (nCurrentProperty < MAX_ONHITS)
                {
                    ipLast = ItemPropertyOnHitProps(nPropertyType,nProperty);
                    SetLocalInt(oPlayer,CURRENT_ONHITS,nCurrentProperty+1);
                }
                break;
            }
            else if (nPropertyType == IP_CONST_ONHIT_ABILITYDRAIN)
                SetSelector(SELECT_ONHIT_ABILITYDRAIN);
            else if (nPropertyType == IP_CONST_ONHIT_ITEMPOISON)
                SetSelector(SELECT_ONHIT_POISON);
            else if (nPropertyType == IP_CONST_ONHIT_DISEASE)
                SetSelector(SELECT_ONHIT_DISEASE);
            else
                SetSelector(SELECT_ONHIT_DURATION);
            SetLocalInt(oPlayer,ONHIT_DC_SELECTED,nProperty);
            return;
        case SELECT_ONHIT_DISEASE:
        case SELECT_ONHIT_POISON:
        case SELECT_ONHIT_ABILITYDRAIN:
        case SELECT_ONHIT_DURATION:
            nCurrentProperty = GetLocalInt(oPlayer,CURRENT_ONHITS);
            nPropertyType = GetLocalInt(oPlayer,ONHIT_TYPE_SELECTED);
            nProperty = GetIntElement(GetDlgSelection(),GetDlgResponseList(),oPlayer);
            if (nCurrentProperty < MAX_ONHITS)
            {
                ipLast = ItemPropertyOnHitProps(nPropertyType,GetLocalInt(oPlayer,ONHIT_DC_SELECTED),nProperty);
                SetLocalInt(oPlayer,CURRENT_ONHITS,nCurrentProperty+1);
            }
            break;
        case SELECT_MASSCRITS:
            IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_MASSIVE_CRITICALS, DURATION_TYPE_PERMANENT);
            ipLast = ItemPropertyMassiveCritical(GetIntElement(GetDlgSelection(),GetDlgResponseList(),oPlayer));
            break;
        case SELECT_VAMP_REGEN:
            ipLast = ItemPropertyVampiricRegeneration(GetDlgSelection()+1);
            SetLocalInt(oPlayer,CURRENT_VAMP_REGEN,GetLocalInt(oPlayer,CURRENT_VAMP_REGEN)+GetDlgSelection()+1);
            break;
        case SELECT_MIGHTY:
            IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_MIGHTY, DURATION_TYPE_PERMANENT);
            ipLast = ItemPropertyMaxRangeStrengthMod(GetDlgSelection()+1);
            break;
    }
    // If break was used to exit the loop (in cases where ipLast has been defined) add the item property to the item and show the confirm dialog
    if (GetIsItemPropertyValid(ipLast))
        AddItemProperty(DURATION_TYPE_PERMANENT, ipLast, GetItem());
    SetSelector(SELECT_CONFIRM_DIALOG);
}

void CleanUp()
{
    object oPlayer = GetPcDlgSpeaker();
    DeleteLocalObject(oPlayer,ITEM);

    DeleteLocalObject(oPlayer,CURRENT_ABILITY_BONUS);
    DeleteLocalObject(oPlayer,CURRENT_SKILL_BONUS);
    DeleteLocalObject(oPlayer,CURRENT_SAVE_BONUS);
    DeleteLocalObject(oPlayer,CURRENT_SAVE_EFFECT_BONUS);
    DeleteLocalObject(oPlayer,CURRENT_BONUS_SPELLSLOTS);

    DeleteLocalInt(oPlayer,CURRENT_ABILITY_BONUS);
    DeleteLocalInt(oPlayer,CURRENT_SKILL_BONUS);
    DeleteLocalInt(oPlayer,CURRENT_SAVE_BONUS);
    DeleteLocalInt(oPlayer,CURRENT_SAVE_EFFECT_BONUS);
    DeleteLocalInt(oPlayer,CURRENT_BONUS_SPELLSLOTS);
    DeleteLocalInt(oPlayer,CURRENT_REGEN);
    DeleteLocalInt(oPlayer,CURRENT_VAMP_REGEN);
    DeleteLocalInt(oPlayer,CURRENT_DAMAGE_DICE);
    DeleteLocalInt(oPlayer,CURRENT_ONHITS);
    DeleteLocalInt(oPlayer, "CURRENT_FORT_BONUS");

    DeleteLocalInt(oPlayer,MAX_DAMAGE_DICE);

    DeleteLocalInt(oPlayer,ABILITY_TYPE_SELECTED);
    DeleteLocalInt(oPlayer,SKILL_TYPE_SELECTED);
    DeleteLocalInt(oPlayer,DAMAGE_TYPE_SELECTED);
    DeleteLocalInt(oPlayer,SAVE_TYPE_SELECTED);
    DeleteLocalInt(oPlayer,SAVE_EFFECT_TYPE_SELECTED);
    DeleteLocalInt(oPlayer,SPELLSLOT_CLASS_SELECTED);
    DeleteLocalInt(oPlayer,LIGHT_BRIGHTNESS_SELECTED);
    DeleteLocalInt(oPlayer,ONHIT_TYPE_SELECTED);
    DeleteLocalInt(oPlayer,ONHIT_DC_SELECTED);

    DeleteLocalInt(oPlayer,SELECTOR);
    DeleteLocalInt(oPlayer,LAST_SELECTOR);

    DeleteList(LIST, oPlayer);
    DeleteList(RESREF, oPlayer);
}

void main ()
{
    object oPlayer = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    object oItem;
    //SendMessageToPC(oPlayer,IntToString(GetShowing()));
    switch(iEvent)
    {
        case DLG_INIT:
            Init();
            break;
        case DLG_PAGE_INIT:
            SetDlgPrompt("Hello, what can I do for you?");
            SetShowEndSelection(TRUE);
            BuildList();
            if (GetSelector() == SELECT_CONFIRM_DIALOG)
            {
                oItem = GetItem();
                int nPrice = GetGoldPieceValue(oItem)*3;
                int nPropertyType = GetBaseItemType(oItem);
                if (nPropertyType == BASE_ITEM_ARROW || nPropertyType == BASE_ITEM_BOLT || nPropertyType == BASE_ITEM_BULLET || nPropertyType == BASE_ITEM_DART || nPropertyType == BASE_ITEM_SHURIKEN || nPropertyType == BASE_ITEM_THROWINGAXE)
                    nPrice *= 5;
                SetDlgPrompt("The current item costs " + IntToString(nPrice) + " GP and is level " + IntToString(GetItemLevelByGold(oItem)));
                //if (IPGetNumberOfItemProperties(oItem) > 0) AssignCommand(oPlayer, ActionExamine(oItem));
            }
            SetDlgResponseList(LIST,oPlayer);
            break;
        case DLG_SELECTION:
            HandleSelection();
            break;
        case DLG_ABORT:
        case DLG_END:
            CleanUp();
            break;
    }
}

