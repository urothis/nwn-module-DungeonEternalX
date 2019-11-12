#include "nw_i0_generic"

void main()
{
object oPC = GetLastKiller();
ExecuteScript("x2_def_ondeath", OBJECT_SELF);

object oModule = GetModule();
SetLocalInt(oModule, "HEX_RARE_MOB_SLAIN", GetLocalInt(oModule, "HEX_RARE_MOB_SLAIN")+1);

if(GetResRef(OBJECT_SELF)=="vagrant" ||
GetResRef(OBJECT_SELF)=="keeperofdarkness" ||
GetResRef(OBJECT_SELF)=="oversoul_necro_h" ||
GetResRef(OBJECT_SELF)=="tachyonthedeceiv" ||
GetResRef(OBJECT_SELF)=="lordofterror2" ||
GetResRef(OBJECT_SELF)=="ancientdemilich" ||
GetResRef(OBJECT_SELF)=="lordofterror" ||
GetResRef(OBJECT_SELF)=="arcanehorror" ||
GetResRef(OBJECT_SELF)=="eijausenightmare" ||
GetResRef(OBJECT_SELF)=="hex_mage_skele" ||
GetResRef(OBJECT_SELF)=="hex_mage_skele2" ||
GetResRef(OBJECT_SELF)=="hex_mage_skele3" ||
GetResRef(OBJECT_SELF)=="hex_mage_skele4" ||
GetResRef(OBJECT_SELF)=="valmirboss" ||
GetResRef(OBJECT_SELF)=="karnohttheredban")
{
effect eVFX = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
SpeakString("A wicked soul has been vanquished!", TALKVOLUME_SHOUT);
}
else if(GetTag(OBJECT_SELF)=="ReassemblingSkeleton")
{
effect eVFX;
effect eRez = EffectResurrection();
DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, OBJECT_SELF));
eVFX = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF));
effect eHeal = EffectHeal(1000);
DelayCommand(3.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF));
}
//MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE
else if(GetTag(OBJECT_SELF)=="MephiticOoze" && GetAppearanceType(OBJECT_SELF)>850)
{
location lLocation = GetLocation(OBJECT_SELF);
object oCreate;
object oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
effect eVFX = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND);

oCreate = CreateObject(OBJECT_TYPE_CREATURE, "mephiticooze", lLocation , TRUE);
DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCreate));
DelayCommand(0.1, SetCreatureAppearanceType(oCreate, GetAppearanceType(OBJECT_SELF)-2));
DelayCommand(1.0, AssignCommand(oCreate, DetermineCombatRound(oEnemy)));

oCreate = CreateObject(OBJECT_TYPE_CREATURE, "mephiticooze", lLocation , TRUE);
DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCreate));
DelayCommand(0.1, SetCreatureAppearanceType(oCreate, GetAppearanceType(OBJECT_SELF)-2));
DelayCommand(1.0, AssignCommand(oCreate, DetermineCombatRound(oEnemy)));

}
else if(GetTag(OBJECT_SELF)=="MephiticOoze" && GetAppearanceType(OBJECT_SELF)==850)
{
return;
}
//MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE MEPHITIC OOZE
else
{
effect eVFX = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
SpeakString("A mighty being has fallen!", TALKVOLUME_SHOUT);
}

if(GetResRef(OBJECT_SELF)=="glimmervoidsentr")
{
DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectVisualEffect(VFX_DUR_ICESKIN)), OBJECT_SELF));
DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectVisualEffect(VFX_DUR_AURA_BLUE_LIGHT)), OBJECT_SELF));
}


// ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL***
if(GetResRef(OBJECT_SELF)=="vagrant")
{

ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION ), GetLocation(OBJECT_SELF));
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION ), GetLocation(OBJECT_SELF));
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION ), GetLocation(OBJECT_SELF));
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION ), GetLocation(OBJECT_SELF));
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION ), GetLocation(OBJECT_SELF));
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION ), GetLocation(OBJECT_SELF));
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_BLINDDEAF ), GetLocation(OBJECT_SELF));
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_BLINDDEAF ), GetLocation(OBJECT_SELF));
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_BLINDDEAF ), GetLocation(OBJECT_SELF));
SetLocalInt(oPC, "PLAYER_KILLED_VAGRANT_MARK", 1);
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+1);

if (!GetIsPC(oPC)) return;

      if ( Random(100) >= 10 )
    {
        SendMessageToPC(oPC, "This creature apparently didn't have anything to drop. Maybe next time!");
        return;
    }

    CreateItemOnObject("hex_archmaguspm", oPC);
}
// ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL*** ***VAGRANT SOUL***

if(GetTag(OBJECT_SELF)=="MephiticOoze")
{
effect eVFX = EffectVisualEffect(VFX_DUR_AURA_BLUE);
DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, OBJECT_SELF));
}

if(GetTag(OBJECT_SELF)=="KeeperofDarkness")
{
SetLocalInt(oPC, "PLAYER_KILLED_KEEPER_OF_DARKNESS_MARK", 1);
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+2);
}

if(GetResRef(OBJECT_SELF)=="arcanehorror")
{
SetLocalInt(oPC, "PLAYER_KILLED_ARCANE_HORROR_MARK", 1);
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+1);
}

if(GetResRef(OBJECT_SELF)=="ancientdemilich")
{
SetLocalInt(oPC, "PLAYER_KILLED_ANCIENT_DEMILICH_MARK", 1);
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+1);
}

if(GetResRef(OBJECT_SELF)=="babil")
{
SetLocalInt(oPC, "PLAYER_KILLED_BABIL_MARK", 1);
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+1);
}

if(GetResRef(OBJECT_SELF)=="lordofterror2")
{
SetLocalInt(oPC, "PLAYER_KILLED_LORD_OF_TERROR_2_MARK", 1);   //CORRUPTOR
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+3);
}

if(GetResRef(OBJECT_SELF)=="lordofterror")
{
SetLocalInt(oPC, "PLAYER_KILLED_LORD_OF_TERROR_MARK", 1);   //LORD OF TERROR
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+2);
}

if(GetResRef(OBJECT_SELF)=="oversoul_necro_h")
{
SetLocalInt(oPC, "PLAYER_KILLED_OVERSOUL_MARK", 1);
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+2);
}

if(GetTag(OBJECT_SELF)=="KarnaxtheElusive")
{
SetLocalInt(oPC, "PLAYER_KILLED_KARNAX_THE_ELUSIVE_MARK", 1);
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+3);
}

if(GetTag(OBJECT_SELF)=="TachyontheDeceiver")
{
SetLocalInt(oPC, "PLAYER_KILLED_TACHYON_THE_DECEIVER_MARK", 1);
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+3);
}

if(GetTag(OBJECT_SELF)=="CryingWolf")
{
SetLocalInt(oPC, "PLAYER_KILLED_CRYING_WOLF_MARK", 1);
SetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER", GetLocalInt(oPC, "PLAYER_KILLED_MARK_COUNTER")+2);
}

if(GetTag(OBJECT_SELF)=="ValmirBoss")
{
effect eVFX = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
CreateItemOnObject("taintedorb", OBJECT_SELF, 1);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
if(d100(1)>=80)
{
CreateItemOnObject("velmircloak", OBJECT_SELF, 1);
}
if(d100(1)>=80)
{
CreateItemOnObject("velmirhelm", OBJECT_SELF, 1);
}
if(d100(1)>=80)
{
CreateItemOnObject("compactarmguard", OBJECT_SELF, 1);
}
}

if(GetResRef(OBJECT_SELF)=="lavaelemental")
{
effect eVFX = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);

if(d100(1)<=3)
{
CreateItemOnObject("moltenrazer", OBJECT_SELF, 1);
}
if(d100(1)<=3)
{
CreateItemOnObject("searingdeath", OBJECT_SELF, 1);
}
if(d100(1)<=3)
{
CreateItemOnObject("smolderingfists", OBJECT_SELF, 1);
}
if(d100(1)<=3)
{
CreateItemOnObject("twistingflames", OBJECT_SELF, 1);
}

}

if(GetTag(OBJECT_SELF)=="SentryOverlord")
{
effect eVFX = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);

if(d100(1)<=3)
{
CreateItemOnObject("moltenrazer", OBJECT_SELF, 1);
}
if(d100(1)<=3)
{
CreateItemOnObject("searingdeath", OBJECT_SELF, 1);
}
if(d100(1)<=3)
{
CreateItemOnObject("smolderingfists", OBJECT_SELF, 1);
}
if(d100(1)<=3)
{
CreateItemOnObject("twistingflames", OBJECT_SELF, 1);
}

}


if(GetTag(OBJECT_SELF)=="Karnoht")
{
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
CreateItemOnObject("soulgem", OBJECT_SELF, 1);
CreateItemOnObject("voidstonexyyras", OBJECT_SELF, 1);

effect eVFX = EffectVisualEffect(VFX_FNF_UNDEAD_DRAGON);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF));
DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF));

if(d100(1)<=20)
{
CreateItemOnObject("moltenrazer", OBJECT_SELF, 1);
}
if(d100(1)<=20)
{
CreateItemOnObject("searingdeath", OBJECT_SELF, 1);
}
if(d100(1)<=20)
{
CreateItemOnObject("smolderingfists", OBJECT_SELF, 1);
}
if(d100(1)<=20)
{
CreateItemOnObject("twistingflames", OBJECT_SELF, 1);
}

}

}
