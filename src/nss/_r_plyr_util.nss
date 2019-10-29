#include "nwnx_admin"
#include "nwnx_redis"

string util_EncodeLocation(location l) {
  object area = GetAreaFromLocation(l);
  vector pos = GetPositionFromLocation(l);
  float facing = GetFacingFromLocation(l);
  string sReturnValue;
  return "#TAG#" + GetTag(area) + "#RESREF#" + GetResRef(area) +
         "#X#" + FloatToString(pos.x, 5, 2) +
         "#Y#" + FloatToString(pos.y, 5, 2) +
         "#Z#" + FloatToString(pos.z, 5, 2) +
         "#F#" + FloatToString(facing,5, 2) + "#";
}

location util_DecodeLocation(string s) {
  float facing, x, y, z;
  int idx, cnt;
  int strlen = GetStringLength(s);

  idx = FindSubString(s, "#TAG#") + 5;
  cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
  string tag = GetSubString(s, idx, cnt);

  idx = FindSubString(s, "#RESREF#") + 8;
  cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
  string resref = GetSubString(s, idx, cnt);

  object area = GetFirstArea();
  while (area != OBJECT_INVALID) {
    if (GetTag(area) == tag && GetResRef(area) == resref)
      break;
    area = GetNextArea();
  }

  idx = FindSubString(s, "#X#") + 3;
  cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
  x = StringToFloat(GetSubString(s, idx, cnt));

  idx = FindSubString(s, "#Y#") + 3;
  cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
  y = StringToFloat(GetSubString(s, idx, cnt));

  idx = FindSubString(s, "#Z#") + 3;
  cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
  z = StringToFloat(GetSubString(s, idx, cnt));

  idx = FindSubString(s, "#F#") + 3;
  cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
  facing = StringToFloat(GetSubString(s, idx, cnt));

  return Location(area, Vector(x, y, z), facing);
}
