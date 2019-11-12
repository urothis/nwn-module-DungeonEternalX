void main()
{

//object oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);

object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN | PERCEPTION_HEARD);
if(GetLastPerceived()==oTarget)
{
effect eDamage = EffectDamage(1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF);
effect eHeal = EffectHeal(1);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
}

object oDeadAlly = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, FALSE, OBJECT_SELF, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND);
if(GetIsObjectValid(oDeadAlly))
{
effect eDamage = EffectDamage(1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF);
effect eHeal = EffectHeal(1);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
}

if(GetTag(OBJECT_SELF)=="ReanimatedCorpse")
{
ActionAttack(oTarget, FALSE);
}

}
