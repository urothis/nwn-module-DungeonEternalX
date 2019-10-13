location RandomLocation(location Center, int Radius)
{
    vector vCenterXYZ = GetPositionFromLocation(Center);
    object LArea = GetAreaFromLocation(Center);
    int RsignX = d2();
    int RsignY = d2();
    float RandomX = IntToFloat(Random(Radius)) / 10;
    float RandomY = IntToFloat(Random(Radius)) / 10;
    if(RsignX == 1)  RandomX = -(RandomX);
    if(RsignY == 1)  RandomY = -(RandomY);
    float vX = vCenterXYZ.x + RandomX;
    float vY = vCenterXYZ.y + RandomY;
    vector VLoc = Vector(vX, vY, 0.0);
    float Pos = IntToFloat(Random(359) + 1);
    return Location(LArea, VLoc, Pos);
}

void FXLBolt(object oPC)
{
    location lPC = GetLocation(oPC);
    effect Ligntning = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, Ligntning, RandomLocation(lPC, 170));
}

void FXPortEthereal(object oPC)
{
    effect PortFX1 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND);
    effect PortFX2 = EffectVisualEffect(VFX_IMP_BREACH);
    effect PortFX3 = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect PortFX4 = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    effect PortFX5 = EffectVisualEffect(VFX_IMP_MAGBLUE);
    location lPC = GetLocation(oPC);
    //AssignCommand(GetNearestObjectByTag("nullcaster"), ActionCastFakeSpellAtLocation(SPELL_EARTHQUAKE, lPC));
    //random lightning
    int i;
    for(i = 0; i < 3; i++)
    {
        DelayCommand(IntToFloat(Random(300)) / 100, FXLBolt(oPC));
    }
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, PortFX4, oPC));
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, PortFX3, oPC));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, PortFX2, oPC));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, PortFX1, oPC));
    DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, PortFX5, oPC));
    DelayCommand(1.0, FXLBolt(oPC));
    DelayCommand(2.6, FXLBolt(oPC));
}

//void main(){}
