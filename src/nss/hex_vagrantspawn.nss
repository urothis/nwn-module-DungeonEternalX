#include "nw_i0_generic"
void main()
{
SetAILevel(OBJECT_SELF, AI_LEVEL_HIGH);
//SetIsDestroyable(FALSE, TRUE, TRUE);
effect eSwing = EffectModifyAttacks(5);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSwing, OBJECT_SELF);

if(GetTag(OBJECT_SELF)=="VagrantSoul")
{

    if(GetLocalInt(OBJECT_SELF, "DO_ONCE")!=1)
    {
    SetLocalInt(OBJECT_SELF, "DO_ONCE", 1);
        if(d2(1)==1)
        {
        SetLocalInt(OBJECT_SELF, "DESTROYER_VAGRANT", 1);
        }
        else
        {
        SetLocalInt(OBJECT_SELF, "DESTROYER_VAGRANT", 0);
        }
}



ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_DUR_ANTI_LIGHT_10  )), OBJECT_SELF);

ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_DUR_PROTECTION_EVIL_MAJOR)), OBJECT_SELF);

ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_DUR_AURA_PULSE_GREY_BLACK)), OBJECT_SELF);
}

if(GetResRef(OBJECT_SELF)=="oversoul_necro_h")
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_DUR_ANTI_LIGHT_10  )), OBJECT_SELF);
}

if(GetTag(OBJECT_SELF)=="FIRE")
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_DUR_AURA_ORANGE)), OBJECT_SELF);

ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_EYES_ORG_HUMAN_MALE)), OBJECT_SELF);
}

if(GetTag(OBJECT_SELF)=="ZAP")
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_DUR_AURA_PURPLE)), OBJECT_SELF);

ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_EYES_PUR_HUMAN_MALE)), OBJECT_SELF);
}

if(GetTag(OBJECT_SELF)=="COLD")
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_DUR_AURA_BLUE_LIGHT)), OBJECT_SELF);

ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_EYES_CYN_HUMAN_MALE)), OBJECT_SELF);
}

if(GetTag(OBJECT_SELF)=="DEATH")
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_DUR_AURA_PULSE_GREY_BLACK)), OBJECT_SELF);

ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_DUR_PROT_SHADOW_ARMOR)), OBJECT_SELF);

ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectVisualEffect(
VFX_EYES_GREEN_HUMAN_MALE)), OBJECT_SELF);
}

if(GetTag(OBJECT_SELF)=="GreaterSuccubus")
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectVisualEffect(VFX_DUR_AURA_PULSE_MAGENTA_RED)), OBJECT_SELF);
ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectVisualEffect(VFX_EYES_RED_FLAME_HUMAN_FEMALE)), OBJECT_SELF);
effect eDMG = EffectDamage(10, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eDMG, OBJECT_SELF);
}

if(GetTag(OBJECT_SELF)=="ArcaneHorror")
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectVisualEffect(VFX_DUR_AURA_PULSE_GREY_BLACK)), OBJECT_SELF);
ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectVisualEffect(VFX_EYES_GREEN_HUMAN_MALE)), OBJECT_SELF);
effect eDMG = EffectDamage(10, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eDMG, OBJECT_SELF);
}

    if(GetResRef(OBJECT_SELF)=="hex_mage_skele" || GetResRef(OBJECT_SELF)=="hex_mage_skele2" || GetResRef(OBJECT_SELF)=="hex_mage_skele3" || GetResRef(OBJECT_SELF)=="hex_mage_skele4")
    {
    if(d100(1)<=5)
    {
    CreateItemOnObject("ringofstalwartne", OBJECT_SELF, 1);
    }
    if(d100(1)<=5)
    {
    CreateItemOnObject("lirngoflichsi", OBJECT_SELF, 1);
    }
    if(d100(1)<=5)
    {
    CreateItemOnObject("ringofgreaterreg", OBJECT_SELF, 1);
    }
    if(d100(1)<=5)
    {
    CreateItemOnObject("lichring", OBJECT_SELF, 1);
    }
    if(d100(1)<=5)
    {
    CreateItemOnObject("firespike", OBJECT_SELF, 1);
    }
    if(d100(1)<=5)
    {
    CreateItemOnObject("skirmisherslance", OBJECT_SELF, 1);
    }
    }

    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=3)
    {
    CreateItemOnObject("spectersnoncorpo", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=10)
    {
    CreateItemOnObject("warlocksarmguard", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=7)
    {
    CreateItemOnObject("deathcheater", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=7)
    {
    CreateItemOnObject("brawlersplate", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=10)
    {
    CreateItemOnObject("armoroftheunseen", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=12)
    {
    CreateItemOnObject("baubleofpurge", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=12)
    {
    CreateItemOnObject("elementalnegatio", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=12)
    {
    CreateItemOnObject("idolofrenewal", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=12)
    {
    CreateItemOnObject("mindreorienter", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=12)
    {
    CreateItemOnObject("roguesbane", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=5)
    {
    CreateItemOnObject("tomeoflessertran", OBJECT_SELF, 1);
    }
    if(GetResRef(OBJECT_SELF)=="oversoul_necro_h" && d100(1)<=5)
    {
    CreateItemOnObject("vermithraxsgrimo", OBJECT_SELF, 1);
    }

}






