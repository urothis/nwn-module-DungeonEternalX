// more picky way of getting caster level
// written by RedACE
// originally designed for getting an accurate caster level for dispel scripts
// returns  0-40 for PCs:  no more than PC's highest level class
//          60 for DMs,
//          0-60 for monsters:  no more than monster's highest level class
//          0 for anything else (by virtue of having no classes)
int MyGetCasterLevel(object oCreature=OBJECT_SELF) {

    if (GetIsDM(oCreature)) { return 60; }

    int nCasterLevel = GetCasterLevel(oCreature);

    // if nCasterLevel seems reasonable, use it
    if (nCasterLevel >= 1 && nCasterLevel <= 40) {
        return nCasterLevel;
    }

    int nHighestLevelClass = GetLevelByPosition(1, oCreature);
    int nSlot2 = GetLevelByPosition(2, oCreature);
    int nSlot3 = GetLevelByPosition(3, oCreature);

    if (nSlot2 > nHighestLevelClass) { nHighestLevelClass = nSlot2; }
    if (nSlot3 > nHighestLevelClass) { nHighestLevelClass = nSlot3; }

    // drop caster level to highest level class, if lower
    if (nHighestLevelClass < nCasterLevel) {
        nCasterLevel = nHighestLevelClass;
    }

    if (GetIsPC(oCreature) && nCasterLevel > 40) {
        nCasterLevel = 40;
    }

    if (nCasterLevel > 60) {
        nCasterLevel = 60;
    }

    return nCasterLevel;
}
