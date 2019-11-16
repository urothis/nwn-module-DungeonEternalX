effect eEffect = EffectHaste();
effect dEffect = EffectModifyAttacks(5);

const int EVENT_USER_DEFINED_PRESPAWN = 1510;
const int EVENT_USER_DEFINED_POSTSPAWN = 1511;

#include "x2_inc_switches"
void main()
{

ApplyEffectToObject (DURATION_TYPE_PERMANENT, eEffect, OBJECT_SELF);
    ApplyEffectToObject (DURATION_TYPE_PERMANENT, dEffect, OBJECT_SELF);
    effect eEffect = EffectHaste();
effect dEffect = EffectModifyAttacks(5);


    string sTag;
    object oNPC;
    // User defined OnSpawn event requested?
    int nSpecEvent = GetLocalInt(OBJECT_SELF,"X2_USERDEFINED_ONSPAWN_EVENTS");

    ApplyEffectToObject (DURATION_TYPE_PERMANENT, eEffect, OBJECT_SELF);
    ApplyEffectToObject (DURATION_TYPE_PERMANENT, dEffect, OBJECT_SELF);

    // Pre Spawn Event requested
    if (nSpecEvent == 1  || nSpecEvent == 3  )
    {
    SignalEvent(OBJECT_SELF,EventUserDefined(EVENT_USER_DEFINED_PRESPAWN ));
    ApplyEffectToObject (DURATION_TYPE_PERMANENT, eEffect, OBJECT_SELF);
    ApplyEffectToObject (DURATION_TYPE_PERMANENT, dEffect, OBJECT_SELF);
    }

    sTag=GetLocalString(OBJECT_SELF,"X3_HORSE_OWNER_TAG");
    if (GetStringLength(sTag)>0)
    { // look for master
        oNPC=GetNearestObjectByTag(sTag);
        if (GetIsObjectValid(oNPC)&&GetObjectType(oNPC)==OBJECT_TYPE_CREATURE)
        { // master found
            AddHenchman(oNPC);
        } // master found
        else
        { // look in module
            oNPC=GetObjectByTag(sTag);
            if (GetIsObjectValid(oNPC)&&GetObjectType(oNPC)==OBJECT_TYPE_CREATURE)
            { // master found
                AddHenchman(oNPC);
            } // master found
            else
            { // master does not exist - remove X3_HORSE_OWNER_TAG
                DeleteLocalString(OBJECT_SELF,"X3_HORSE_OWNER_TAG");
            } // master does not exist - remove X3_HORSE_OWNER_TAG
        } // look in module
    } // look for master

    /*  Fix for the new golems to reduce their number of attacks */

    int nNumber = GetLocalInt(OBJECT_SELF,CREATURE_VAR_NUMBER_OF_ATTACKS);
    if (nNumber >0 )
    {
        SetBaseAttackBonus(100, OBJECT_SELF);
    }

    // Execute default OnSpawn script.
    ExecuteScript("nw_c2_default9", OBJECT_SELF);


    //Post Spawn event requeste
    if (nSpecEvent == 2 || nSpecEvent == 3)
    {
    SignalEvent(OBJECT_SELF,EventUserDefined(EVENT_USER_DEFINED_POSTSPAWN));
    ApplyEffectToObject (DURATION_TYPE_PERMANENT, eEffect, OBJECT_SELF);
    ApplyEffectToObject (DURATION_TYPE_PERMANENT, dEffect, OBJECT_SELF);
    }

}
