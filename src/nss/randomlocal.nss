location RandomLocation(location Center, int Radius){
    vector vCenterXYZ = GetPositionFromLocation(Center);
    object LArea = GetAreaFromLocation(Center);
    int RsignX = d2();
    int RsignY = d2();
    float RandomX = IntToFloat(Radius) / 10;
    float RandomY = IntToFloat(Radius) / 10;
    if(RsignX == 1)  RandomX = -(RandomX);
    if(RsignY == 1)  RandomY = -(RandomY);
    float vX = vCenterXYZ.x + RandomX;
    float vY = vCenterXYZ.y + RandomY;
    vector VLoc = Vector(vX, vY, 0.0);
    float Pos = IntToFloat(Random(359) + 1);
    return Location(LArea, VLoc, Pos);
}
