#include "pg_lists_i"

void main()
{
    object oPC = GetLastUsedBy();
    if (GetPCPlayerName(oPC) != "Ezramun") return;

    object oArea = GetArea(OBJECT_SELF);

    SetLocalObject(oArea, "DRYAD_BOSS_PLAYER", oPC);

    object oNPC_WP = GetNearestObjectByTag("WP_DRYAD_BOSS", oPC);
    object oBoss = CreateObject(OBJECT_TYPE_CREATURE, "epimeliad", GetLocation(oNPC_WP), FALSE, "DRYAD_BOSS_2");
    ChangeToStandardFaction(oBoss, STANDARD_FACTION_HOSTILE);
    effect eVFX = EffectVisualEffect(448);
    effect eShield = EffectDamageShield(50, DAMAGE_BONUS_2d12, DAMAGE_TYPE_ACID);
    AssignCommand(oBoss, DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, oBoss)));
    AssignCommand(oBoss, DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShield, oBoss)));

    object oGoblin = CreateObject(OBJECT_TYPE_CREATURE, "goblin_witchdoct", GetLocation(GetNearestObjectByTag("WP_DRYAD_GOBLINS1")), FALSE, "WITCH_DOCTOR");
    AssignCommand(oGoblin, DelayCommand(1.0, ActionAttack(oBoss, TRUE)));
    SetLocalObject(oGoblin, "DRYAD_BOSS_2", oBoss);
    oGoblin = CreateObject(OBJECT_TYPE_CREATURE, "goblin_witchdoct", GetLocation(GetNearestObjectByTag("WP_DRYAD_GOBLINS2")), FALSE, "WITCH_DOCTOR");
    AssignCommand(oGoblin, DelayCommand(1.0, ActionAttack(oBoss, TRUE)));
    SetLocalObject(oGoblin, "DRYAD_BOSS_2", oBoss);

    object oGuard = CreateObject(OBJECT_TYPE_CREATURE, "dryad_hulk", GetLocation(GetNearestObjectByTag("WP_DRYAD_GUARDS1")), FALSE, "DRYAD_HULK");
    SetLocalObject(oGuard, "DRYAD_BOSS_2", oBoss);
    //AssignCommand(oGoblin, DelayCommand(1.0, ActionAttack(oBoss, TRUE)));
    oGuard = CreateObject(OBJECT_TYPE_CREATURE, "dryad_hulk", GetLocation(GetNearestObjectByTag("WP_DRYAD_GUARDS2")), FALSE, "DRYAD_HULK");
    SetLocalObject(oGuard, "DRYAD_BOSS_2", oBoss);
    //AssignCommand(oGoblin, DelayCommand(1.0, ActionAttack(oBoss, TRUE)));

}
