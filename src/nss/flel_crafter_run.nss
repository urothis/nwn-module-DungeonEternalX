/*
    Include file to be included in the NPC's OnConversation script. Simply call
    either of the four DoStart...Crafter() functions from within main()

    06/01/15 * Seed       * Change StartDlg to OpenNextDlg
*/
#include "zdlg_include_i"
#include "_functions"

const int CRAFT_ARMOR             = 1;
const int CRAFT_MAGIC             = 2;
const int CRAFT_MELEE             = 4;
const int CRAFT_RANGED            = 8;

// Player was able to craft shifter items
int RemovePolymorphEffectAtCrafters(object oPC);

int RemovePolymorphEffectAtCrafters(object oPC)
{
    effect eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH)
        {
            DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(200), oPC));
            DelayCommand(0.6, RemoveEffect(oPC, eEffect));
            return TRUE;
        }
        eEffect = GetNextEffect(oPC);
    }
    return FALSE;
}

void DoStartArmorCrafter() {
    DefLocalInt(OBJECT_SELF, "CRAFTER_MAX_LEVEL", 5);
    DefLocalInt(OBJECT_SELF, "CRAFTER_TYPE", CRAFT_ARMOR);
    OpenNextDlg(GetLastSpeaker(), OBJECT_SELF,"seed_crafter",TRUE,FALSE);
}

void DoStartProjectileCrafter() {
    DefLocalInt(OBJECT_SELF, "CRAFTER_MAX_LEVEL", 5);
    DefLocalInt(OBJECT_SELF, "CRAFTER_TYPE", CRAFT_RANGED);
    OpenNextDlg(GetLastSpeaker(), OBJECT_SELF,"seed_crafter",TRUE,FALSE);
}

void DoStartMagicItemCrafter() {
    DefLocalInt(OBJECT_SELF, "CRAFTER_MAX_LEVEL", 5);
    DefLocalInt(OBJECT_SELF, "CRAFTER_TYPE", CRAFT_MAGIC);
    OpenNextDlg(GetLastSpeaker(), OBJECT_SELF,"seed_crafter",TRUE,FALSE);
}

void DoStartWeaponCrafter() {
    DefLocalInt(OBJECT_SELF, "CRAFTER_MAX_LEVEL", 5);
    DefLocalInt(OBJECT_SELF, "CRAFTER_TYPE", CRAFT_MELEE);
    OpenNextDlg(GetLastSpeaker(), OBJECT_SELF,"seed_crafter",TRUE,FALSE);
}

//void main(){}
