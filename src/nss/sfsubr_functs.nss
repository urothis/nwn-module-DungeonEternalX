//::///////////////////////////////////////////////
//:: Scarface's Leto Subrace System
//:: Subrace Functions Include
//:: sfsubr_functs
//:://////////////////////////////////////////////
/*
    Written By Scarface

    Thanks to JasonMel and Axe Murderer from
    Bioware forums for help on some of the
    bitwise functions.
*/
//:://////////////////////////////////////////////

#include "sfsubr_leto_inc"
#include "_functions"
#include "nwnx_creature"
#include "inc_traininghall"


object oStorer = GetModule();

void ClearSubRace(object oPC, string sFrom) {
   string sSubRace = GetSubRace(oPC);
   if (sSubRace!="") {
      //SDB_LogMsg("SUBCLEAR", "Clear Subrace " + sSubRace + " - entry point " + sFrom, oPC);
      SetSubRace(oPC, "");
   }
}

//::////////////////////////////////////////////////////////////////////////////
//:: Function Declarations - Do NOT Touch!!!
//::////////////////////////////////////////////////////////////////////////////

//:: This is the main struct for Scarface's Subrace System, do not modify
//:: this in any way. Doing so will probably cause the subrace system to
//:: malfunction.
struct SF_SubraceMods SF_GetSubraceModifications(object oPC, string sSubrace);

//:: This is the struct for retrieving subrace item information,
//:: i.e. hides and claws.
struct SF_SubraceItems SF_GetSubraceItems(object oPC, string sSubrace);

//:: This function is for creating a new subrace.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:            The name of the subrace.
//:: int nAppearanceTypeMale:    The appearance type for males.
//:: int nAppearanceTypeFemale:  The appearance type for females.
//::                             * Use the APPEARANCE_TYPE_* constants, or APPEARANCE_TYPE_INVALID
//::                               to keep the players default appearance.
//:: string sHideResRef:         The ResRef of the creature hide associated with this subrace,
//::                             if no ResRef is specified then a default subrace hide will be used.
//:: string sClawResRef:         The ResRef of the creature claws associated with this subrace.
//:: string sItemResRef:         The ResRef of the creature item associated with this subrace.
//:: int bIsUndead:              If this is an undead subrace, then set this TRUE, otherwise you can
//::                             leave this parameter out because it is set FALSE by default.
//:: int nLevelAcquiredSkin:     The level at which the subrace will acquire a subrace skin if applicable, default is level 1.
void SF_CreateNewSubrace(string sSubrace, int nAppearanceTypeMale = APPEARANCE_TYPE_INVALID, int nAppearanceTypeFemale = APPEARANCE_TYPE_INVALID, string sHideResRef = "", string sClawResRef = "", string sItemresRef = "", int bIsUndead = FALSE, int nLevelAcquiredSkin = 1);

//:: This function is for setting a new head type for a subrace
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:   The name of the subrace.
//:: int nMaleHead:     The head type appearance of a particular male subrace.
//:: int nFemaleHead:   The head type appearance of a particular female subrace.
void SF_SetSubraceHeadType(string sSubrace, int nMaleHead, int nFemaleHead);

//:: This function is for setting wings or a tail for a subrace.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:   The name of the subrace.
//:: int nWingType:     The wing type appearance using the WINGS_TYPE_* constants.
//:: int nTailType:     The wing type appearance using the TAIL_TYPE_* constants.
//void SF_SetSubraceBodyAttatchments(string sSubrace, int nWingType, int nTailType);

//:: This function is for setting the skin and hair color for a subrace.
//:: * This will only work on standard type appearances i.e. human, elf etc.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:   The name of the subrace.
//:: nSkinColor:        The color for the skin.
//void SF_SetSubraceAppearanceColor(string sSubrace, int nSkinColor, int nHairColor);

//:: This function is for setting the portrait for a subrace.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:          The name of the subrace.
//:: string sMalePortrait:     The portrait ResRef for males.
//:: string sFemalePortrait:   The portrait ResRef for females.
//void SF_SetSubracePortrait(string sSubrace, string sMalePortrait, string sFemalePortrait);

//:: This function is for setting the appearance for a subrace.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:       The name of the subrace.
//:: int nMaleVoiceSet:     The voiceset for males.
//:: int nFemaleVoiceset:   The voiceset for females.
//void SF_SetSubraceVoiceSet(string sSubrace, int nMaleVoiceSet, int nFemaleVoiceset);

//:: This function is for adding a feat to a subrace feat list.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:   The name of the subrace.
//:: int nFeatType:     The feat to add to the subrace feat list using the FEAT* constants
//::
//:: *  This function can be used multiple times for the same subrace.
//void SF_SetSubraceFeat(string sSubrace, int nFeatType);

//:: This function is for modifying a subrace's character movement speed.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:   The name of the subrace.
//:: int nNewSpeed:     The movement speed at which the character will be set to
//:: using the CHARACTER_SPEED_* consts.
//void SF_SetSubraceMovementSpeed(string sSubrace, int nNewSpeed);


//:: This function is for setting spell resistance for a subrace.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:   The name of the subrace.
//:: int nSpellResist:  The total spell resistance at level 40, this is progressive
//::                    and will start low, and increase per character level until
//::                    the total SR is reached at level 40.
//void SF_SetSubraceSpellResistance(string sSubrace, int nSpellResist);

//:: This function is for adding a class restriction for a subrace.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:       The name of the subrace.
//:: bAllowUseClasses:        Restrict the subrace to the specified classes?
//::                        ALLOW_USE_TRUE = The subrace can only use the specified classes.
//::                        ALLOW_USE_FALSE = The subrace can't use any of the specified classes.
//:: nRestrictedToClasses:  The class(s) that the subrace is restricted to.
//:: nRestrictUntilLevel:   The level of which the classes are restricted to.
//::
//::                       * Use the CLASS_RESTRICT_* constants seperated by |
//::                         for example, if I wanted a subrace restricted to
//::                         monks and clerics only, I would use the function like
//::                         this:
//::
//::    SF_SetSubraceClassRestriction("Example-Subrace", ALLOW_USE_TRUE, CLASS_RESTRICT_CLERIC | CLASS_RESTRICT_MONK);
//::
//::                       * If I wanted to disallow a subrace to use monk and cleric
//::                         classes, I would use the function like this:
//::
//::    SF_SetSubraceClassRestriction("Example-Subrace", ALLOW_USE_FALSE, CLASS_RESTRICT_CLERIC | CLASS_RESTRICT_MONK);
//::
//::                       * You can do this with as many classes as you like.
//::
//:: If this function isn't used, then the subrace will have no class restrictions
//void SF_SetSubraceClassRestriction(string sSubrace, int bAllowUseClasses, int nRestrictedToClasses, int nRestrictUntilLevel);

//:: This function is for adding a race restriction for a subrace.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:     The name of the subrace.
//:: bAllowUseRaces:      Restrict the subrace to the specified races?
//::                      ALLOW_USE_TRUE = The subrace can only use the specified races.
//::                      ALLOW_USE_FALSE = The subrace can't use any of the specified races.
//:: nRestrictedRaces:    The racial type restrictions:
//::
//::                     * Use the RACE_RESTRICT_* constants seperated by |
//::                       for example, if I wanted a subrace restricted to
//::                       humans and elfs only, I would use the function like
//::                       this:
//::
//::    SF_SetSubraceRaceRestriction("Example-Subrace", ALLOW_USE_TRUE, RACE_RESTRICT_HUMAN | RACE_RESTRICT_ELF);
//::
//::                     * If I wanted to dis-allow a subrace to be racial type
//::                       human or elf, I would use the function like this:
//::
//::    SF_SetSubraceRaceRestriction("Example-Subrace", ALLOW_USE_FALSE, RACE_RESTRICT_HUMAN | RACE_RESTRICT_ELF);
//::
//::                       * You can do this with as many races as you like.
//::
//:: If this function isn't used, then the subrace will have no race restrictions
//void SF_SetSubraceRaceRestriction(string sSubrace, int bAllowUseRaces, int nRestrictedRaces);

//:: This function is for adding alignment restrictions for a subrace.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:         The name of the subrace.
//:: bAllowUseEquip:          Restrict the subrace to the specified alignment?
//::                          ALLOW_USE_TRUE = The subrace can only use the specified alignments.
//::                          ALLOW_USE_FALSE = The subrace can't use any of the specified alignments.
//:: nRestrictedAlignments:   The race(s) the subrace is restricted to.
//::
//::                        * Use the ALIGN_RESTRICT_* constants seperated by |
//::                          for example, if I wanted a subrace restricted to
//::                          chaotic evil only, I would use the function like
//::                          this:
//::
//:: SF_SetSubraceAlignmentRestriction("Example-Subrace", ALLOW_USE_TRUE, ALIGN_RESTRICT_CHAOTIC | ALIGN_RESTRICT_EVIL);
//::
//::                        * If I wanted to disallow a subrace to be
//::                          chaotic evil, I would use the function like
//::                          this:
//::
//:: SF_SetSubraceAlignmentRestriction("Example-Subrace", ALLOW_USE_FALSE, ALIGN_RESTRICT_CHAOTIC | ALIGN_RESTRICT_EVIL);
//::
//::                       * You can do this with as many alignments as you like.
//::
//::                       * ALIGN_RESTRICT_NEUTRAL1 is in between Good/Evil
//::                       * ALIGN_RESTRICT_NEUTRAL2 is in between Lawful/Chaotic
//::
//:: If this function isn't used, then the subrace will have no alignment restrictions
//void SF_SetSubraceAlignmentRestriction(string sSubrace, int bAllowUseAlignment, int nRestrictedAlignments);

//:: This function is for adding equipment restrictions for a subrace.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:    The name of the subrace.
//:: bAllowUseEquip:     Restrict the subrace to the use specified equipment?
//::                     ALLOW_USE_TRUE = The subrace can only use the specified equipment.
//::                     ALLOW_USE_FALSE = The subrace can't use any of the specified equipment.
//:: nRestrictedEquip:   The equipment the subrace is restricted to.
//::
//::                     * Use the EQUIP_RESTRICT_* constants seperated
//::                       by | for example, if I wanted a subrace restricted
//::                       to using only tiny weapons, cloth armour, and small
//::                       shields, I would use the function like this:
//::
//::    SF_SetSubraceEquipmentRestriction("Example-Subrace", ALLOW_USE_TRUE, EQUIP_RESTRICT_WEAPON_TINY | EQUIP_RESTRICT_ARMOUR_CLOTH | EQUIP_RESTRICT_SHIELD_SMALL);
//::
//::                     * If I wanted to disallow a subrace from using
//::                       tiny weapons, cloth armour, and small
//::                       shields, I would use the function like this:
//::
//::    SF_SetSubraceEquipmentRestriction("Example-Subrace", ALLOW_USE_FALSE, EQUIP_RESTRICT_WEAPON_TINY | EQUIP_RESTRICT_ARMOUR_CLOTH | EQUIP_RESTRICT_SHIELD_SMALL);
//::
//::                       * You can do this with as much equip as you like.
//::
//:: If this function isn't used, then the subrace will have no equip restrictions
//void SF_SetSubraceEquipmentRestriction(string sSubrace, int bAllowUseEquip, int nRestrictedEquip);

//:: This function is for adjusting subrace stats.
//::
//:: PARAMETERS:
//:: ***********
//:: string sSubrace:   The name of the subrace.
//:: int nSTR:          The amount of Strength to be adjusted.
//:: int nDEX:          The amount of Dexterity to be adjusted.
//:: int nCON:          The amount of Constitution to be adjusted.
//:: int nINT:          The amount of Intelligence to be adjusted.
//:: int nWIS:          The amount of Wisdom to be adjusted.
//:: int nCHA:          The amount of Charisma to be adjusted.
//::
//:: * These can be positive or negative numbers. It is necessary to - for
//::   negative numbers, but never use + for positive numbers,
//::   for example:
//::
//::   SF_AdjustSubraceStats("Example-Subrace", 2, 4, 0, -2, -6, 2);
//::
//::   Which would mean +2 STR, +4 DEX, CON no change, -2 INT, -6 WIS, +2 CHA.
//void SF_AdjustSubraceStats(string sSubrace, int nSTR, int nDEX, int nCON, int nINT, int nWIS, int nCHA);



// :: Modify a skill a character belonging to a subrace has ::
//
// >>> NEEDS LETO TO WORK (REFER TO THE .PDF GUIDE BOOK FOR MORE DETAILS
//
// :: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
// :: SkillID: Use any  SKILL_* constants.
// :: iModifier: The value to increase or decrease or set the skill by/to.
// :: Set: If set to TRUE, the skill points in the chosen skill will be set to the value of iModifier.
//
// Example of Useage:
//
//    Say I want to increase Spot skill by 15, and decrease Search by 12 at level 10, and set Tumble to 5 at level 16.
//    I would call:
//
//    ModifySubraceSkill("mysubrace", SKILL_SPOT, 15, 10);
//    ModifySubraceSkill("mysubrace", SKILL_SEARCH, -12, 10);
//    ModifySubraceSkill("mysubrace", SKILL_TUMBLE, 5, 16, TRUE);
//void SF_SetSubraceSkill(string sSubrace, int SkillID, int iModifier, int Level = 1, int Set = FALSE);

//:: Apply spell resistance to a subrace.
//void SF_ApplySubraceSpellResistance(object oPC);

//:: Apply necessary subrace items to a subrace.
//void SF_ApplySubraceItems(object oPC, string sSubrace);

//:: Apply a subrace to a player.
//void SF_ApplySubraceToPC(object oPC, string sSubrace);

//:: Capitalize a subrace name for no special reason other than it looks better imo.
//string SF_CapitalizeSubraceName(object oPC);

//:: Check a player Onenter. Return TRUE if new Subrace applying
//int SF_SubraceOnEnter(object oPC);

//:: Check a player OnExit.
//void SF_SubraceOnExit(object oPC);

//:: Checks alignment/class restrictions as well as applying SR
//void SF_SubraceOnLevelUp(object oPC);

//:: Chekcs for equipment restrictions
//void SF_SubraceOnEquipItem(object oPC);

//:: Send necessary subrace messages to a player.
//void SF_SendSubraceMessage(object oPC, string sMessage);

//:: Check if the player's subrace is valid.
//int SF_GetIsSubraceValid(string sSubrace);

//:: Check if the player's class is valid for a subrace.
//int SF_GetIsClassValid(object oPC, int nClassPos, string sSubrace);

//:: Check if the player's race is valid for a subrace.
//int SF_GetIsRaceValid(object oPC, string sSubrace);

//:: Check if the player's alignment is valid for a subrace.
//int SF_GetIsAlignmentValid(object oPC, string sSubrace);

//:: Gets the WEAPON_SIZE_* size of a weapon
int SF_GetWeaponSize(object oItem);

//:: Gets the base type of a piece of armour
int SF_GetArmorBaseType(object oItem);

//:: Returns either TRUE or FALSE whether the subrace is flagged as undead or not.
//int SF_GetIsSubraceUndead(object oPC);

//::////////////////////////////////////////////////////////////////////////////
//:: Main Functions - Do NOT Touch!!!
//::////////////////////////////////////////////////////////////////////////////

//::////////////////////////////////////////////////////////////////////////////
//:: The following functions pertain to flags!!!????????????????????????????????
//::////////////////////////////////////////////////////////////////////////////

//:://///////////////////////
// int SetFlag( int iSet, int iFlag, int bOn = TRUE)
//    Turns a flag or set of flags on or off in a flagset variable.
//:://///////////////////////
// Parameters: int iSet  - the flagset variable.
//             int iFlag - the flags to set or clear.
//             int bOn   - turn flags on if TRUE, off if FALSE
//
// Returns: The value of the iSet flagset with the flag(s) specified in iFlag turned on or off
//          based on the value of bOn.
//:://///////////////////////
int SetFlag( int iSet, int iFlag, int bOn = TRUE);
int SetFlag( int iSet, int iFlag, int bOn = TRUE)
{ return (bOn ? (iSet | iFlag) : (iSet & ~iFlag)); }


//:://///////////////////////
// int ClearFlag( int iSet, int iFlag)
//    Clears a flag or set of flags in a flagset variable.
//:://///////////////////////
// Parameters: int iSet  - the flagset variable.
//             int iFlag - the flags to turn off.
//
// Returns: The value of the iSet flagset with the flag(s) specified in iFlag turned off.
//:://///////////////////////
int ClearFlag( int iSet, int iFlag);
int ClearFlag( int iSet, int iFlag)
{ return SetFlag( iSet, iFlag, FALSE); }


//:://///////////////////////
// int GetFlag( int iSet, int iFlag)
//    Returns the values of the flag(s) specified from the given flagset.
//:://///////////////////////
// Parameters: int iSet  - the flagset variable.
//             int iFlag - the flags to turn off.
//
// Returns: The value of the flag(s) requested in the iFlag parameter from the iSet flagset.
//:://///////////////////////
int GetFlag( int iSet, int iFlag);
int GetFlag( int iSet, int iFlag)
{ return (iSet & iFlag); }


//:://///////////////////////
// int GetIsFlagSet( int iSet, int iFlag, int bAny = TRUE)
//    Returns TRUE or FALSE if the flags specified in iFlag are turned on. The bAny parameter
//    is used to request an ANY or ALL test.
//:://///////////////////////
// Parameters: int iSet  - the flagset variable.
//             int iFlag - the flags to test.
//             int bAny  - TRUE means test for any of the flags being set.
//                         FALSE means test for all of the flags being set.
//
// Returns: TRUE if any or all of the flags specified in iFlag are turned on in the flagset variable.
//:://///////////////////////
int GetIsFlagSet( int iSet, int iFlag, int bAny = TRUE);
int GetIsFlagSet( int iSet, int iFlag, int bAny = TRUE)
{ if( iFlag == 0x00000000) return FALSE;
  return (bAny ? ((iSet & iFlag) != 0x00000000) : ((iSet & iFlag) == iFlag));
}


//:://///////////////////////
// int GetIsFlagClear( int iSet, int iFlag, int bAll = TRUE)
//    Returns TRUE or FALSE if the flags specified in iFlag are turned off. The bAll parameter
//    is used to request an ANY or ALL test.
//:://///////////////////////
// Parameters: int iSet  - the flagset variable.
//             int iFlag - the flags to test.
//             int bAll  - TRUE means test for all of the flags being clear.
//                         FALSE means test for any of the flags being clear.
//
// Returns: TRUE if any or all of the flags specified in iFlag are turned off in the flagset variable.
//:://///////////////////////
int GetIsFlagClear( int iSet, int iFlag, int bAll = TRUE);
int GetIsFlagClear( int iSet, int iFlag, int bAll = TRUE)
{ if( iFlag == 0x00000000) return FALSE;
  return !GetIsFlagSet( iSet, iFlag, !bAll);
}



//:://///////////////////////
// string FlagToString( int iSet)
//    Returns the specified flagset as a string of 1's and 0's in the form:
//    "XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX" where FLAG1 is on the far right and FLAG32 the far left.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//
// Returns: The converted flagset in the form "XXXX XXXX XXXX XXXX XXXX XXXX XXXX"
//:://///////////////////////
string FlagToString( int iSet);
string FlagToString( int iSet)
{ string sSet = "";
  int    iBit = -1;
  while( ++iBit < 32)
  { sSet += (((iSet & (0x80000000 >> iBit)) == 0x00000000) ? "0" : "1");
    if( (iBit % 4) == 3) sSet += ((iBit == 31) ? "" : " ");
  }
  return sSet;
}



//:://///////////////////////
// void SetLocalFlag( object oObject, string sVariable, int iFlag, int bOn = TRUE)
//    Sets a local flag variable on an object.
//:://///////////////////////
// Parameters: object oObject   - the object to have the local flagset attached.
//             string sVariable - the flagset name to set the flag in.
//             int    iFlag     - the flag(s) to set or clear.
//             int    bOn       - turn flags on if TRUE, off if FALSE
//
// Returns: None.
//:://///////////////////////
void SetLocalFlag( object oObject, string sVariable, int iFlag, int bOn = TRUE);
void SetLocalFlag( object oObject, string sVariable, int iFlag, int bOn = TRUE)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return;
  int iSet = GetLocalInt( oObject, sVariable);
  SetLocalInt( oObject, sVariable, SetFlag( iSet, iFlag, bOn));
}


//:://///////////////////////
// void ClearLocalFlag( object oObject, string sVariable, int iFlag)
//    Clears a local flag variable on an object.
//:://///////////////////////
// Parameters: object oObject   - the object to have the local flagset attached.
//             string sVariable - the flagset name to set the flag in.
//             int    iFlag     - the flag(s) to clear.
//
// Returns: None.
//:://///////////////////////
void ClearLocalFlag( object oObject, string sVariable, int iFlag);
void ClearLocalFlag( object oObject, string sVariable, int iFlag)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return;
  int iSet = GetLocalInt( oObject, sVariable);
  SetLocalInt( oObject, sVariable, ClearFlag( iSet, iFlag));
}


//:://///////////////////////
// int GetLocalFlag( object oObject, string sVariable, int iFlag = ALLFLAGS)
//    Returns the value of a local flag(s) from an object.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to retrieve the flag(s) from.
//             int    iFlag     - the flag(s) to be retrieved.
//
// Returns: The requested flag(s) is/are returned as a flagset.
//:://///////////////////////
int GetLocalFlag( object oObject, string sVariable, int iFlag = 0xFFFFFFFF);
int GetLocalFlag( object oObject, string sVariable, int iFlag = 0xFFFFFFFF)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return 0;
  int iSet = GetLocalInt( oObject, sVariable);
  return GetFlag( iSet, iFlag);
}


//:://///////////////////////
// int GetIsLocalFlagSet( object oObject, string sVariable, int iFlag = ALLFLAGS)
//    Returns TRUE if the flag(s) in the flagset named by sVariable on oObject are set.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to retrieve the flag(s) from.
//             int    iFlag     - the flag(s) to be retrieved.
//
// Returns: TRUE if all specified flags are set, FALSE otherwise.
//:://///////////////////////
int GetIsLocalFlagSet( object oObject, string sVariable, int iFlag = 0xFFFFFFFF);
int GetIsLocalFlagSet( object oObject, string sVariable, int iFlag = 0xFFFFFFFF)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return 0;
  int iSet = GetLocalInt( oObject, sVariable);
  return GetIsFlagSet( iSet, iFlag);
}


//:://///////////////////////
// int GetIsLocalFlagClear( object oObject, string sVariable, int iFlag = ALLFLAGS)
//    Returns TRUE if the flag(s) in the flagset named by sVariable on oObject is not set.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to retrieve the flag(s) from.
//             int    iFlag     - the flag(s) to be retrieved.
//
// Returns: TRUE if all specified flags are cleared, FALSE otherwise.
//:://///////////////////////
int GetIsLocalFlagClear( object oObject, string sVariable, int iFlag = 0xFFFFFFFF);
int GetIsLocalFlagClear( object oObject, string sVariable, int iFlag = 0xFFFFFFFF)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return 0;
  int iSet = GetLocalInt( oObject, sVariable);
  return GetIsFlagClear( iSet, iFlag);
}


//:://///////////////////////
// void DeleteLocalFlag( object oObject, string sVariable, int iFlag)
//    Removes the specified flag(s) from the given local flagset variable.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to delete the flag(s) from.
//             int    iFlag     - the flag(s) to be deleted.
//
// Returns: None.
//:://///////////////////////
void DeleteLocalFlag( object oObject, string sVariable, int iFlag = 0xFFFFFFFF);
void DeleteLocalFlag( object oObject, string sVariable, int iFlag = 0xFFFFFFFF)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return;
  if( iFlag == 0xFFFFFFFF) DeleteLocalInt( oObject, sVariable);
  else SetLocalFlag( oObject, sVariable, iFlag, FALSE);
}




//:://///////////////////////
// int SetGroupFlag( int iSet, int iFlag, int iGroup, int bOn = TRUE)
//    Turns a flag or set of flags on or off in a flag group of a flagset variable.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iFlag  - the flags to set or clear.
//             int iGroup - the flag group to apply the changes to.
//             int bOn    - turn flags on if TRUE, off if FALSE
//
// Returns: The value of the iSet flagset with the flag(s) specified in iFlag turned on or off
//          based on the value of bOn in the flag group specified by iGroup.
//:://///////////////////////
int SetGroupFlag( int iSet, int iFlag, int iGroup, int bOn = TRUE);
int SetGroupFlag( int iSet, int iFlag, int iGroup, int bOn = TRUE)
{ if( (iFlag == 0x00000000) || (iGroup == 0x00000000)) return iSet;

  int iShift = 0;
  int iLimit = iGroup;
  while( (iLimit != 0x00000000) && GetIsFlagClear( iLimit, 0x00000001))
  { ++iShift;
    iLimit >>= 1;
  }
  return ((iLimit == 0x00000000) ? iSet : SetFlag( iSet, ((iFlag & iLimit) << iShift), bOn));
}


//:://///////////////////////
// int SetGroupFlagValue( int iSet, int iValue, int iGroup)
//    Sets the group value for a group flag.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iValue - the value to set.
//             int iGroup - the flag group to apply the changes to.
//
// Returns: The iSet flagset with the value specified in iValue set as the group value for the
//          group specified by iGroup.
//:://///////////////////////
int SetGroupFlagValue( int iSet, int iValue, int iGroup);
int SetGroupFlagValue( int iSet, int iValue, int iGroup)
{ if( iGroup == 0x00000000) return iSet;
  return SetGroupFlag( SetGroupFlag( iSet, iValue, iGroup), ~iValue, iGroup, FALSE);
}


//:://///////////////////////
// int ClearGroupFlag( int iSet, int iFlag, int iGroup)
//    Turns a flag or set of flags off in a flag group of a flagset variable.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iFlag  - the flags to clear.
//             int iGroup - the flag group to apply the changes to.
//             int bOn    - turn flags on if TRUE, off if FALSE
//
// Returns: The value of the iSet flagset with the flag(s) specified in iFlag turned off in the
//          flag group specified by iGroup.
//:://///////////////////////
int ClearGroupFlag( int iSet, int iFlag, int iGroup);
int ClearGroupFlag( int iSet, int iFlag, int iGroup)
{ return SetGroupFlag( iSet, iFlag, iGroup, FALSE); }


//:://///////////////////////
// int GetGroupFlag( int iSet, int iFlag, int iGroup)
//    Returns the values of the flag(s) specified from the specified flag group of the given flagset.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iFlag  - the flags to return.
//             int iGroup - the flag group to get the flags from.
//
// Returns: The value of the flag(s) requested by the iFlag parameter from the flag group
//          specified in the iGroup parameter from the iSet flagset.
//:://///////////////////////
int GetGroupFlag( int iSet, int iFlag, int iGroup);
int GetGroupFlag( int iSet, int iFlag, int iGroup)
{ if( (iFlag == 0x00000000) || (iGroup == 0x00000000)) return 0x00000000;

  int iShift = 0;
  int iLimit = iGroup;
  while( (iLimit != 0x00000000) && GetIsFlagClear( iLimit, 0x00000001))
  { ++iShift;   iLimit >>= 1; }
  return ((iLimit == 0x00000000) ? 0x00000000 : (GetFlag( iSet, ((iFlag & iLimit) << iShift)) >> iShift));
}


//:://///////////////////////
// int GetGroupFlagValue( int iSet, int iGroup)
//    Returns the group value of the specified group in the iSet flagset.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iGroup - the flag group to get the value of.
//
// Returns: The group value of the group specified by iGroup from the iSet flagset.
//:://///////////////////////
int GetGroupFlagValue( int iSet, int iGroup);
int GetGroupFlagValue( int iSet, int iGroup)
{ if( iGroup == 0x00000000) return 0x00000000;
  return GetGroupFlag( iSet, 0xFFFFFFFF, iGroup);
}


//:://///////////////////////
// int GetIsGroupFlagSet( int iSet, int iFlag, int iGroup, int bAny = TRUE)
//    Returns TRUE or FALSE if the flags specified in iFlag are turned on in the flag group
//    specified by iGroup. The bAny parameter is used to request an ANY or ALL test.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iFlag  - the flags to test.
//             int iGroup - the flag group to get the flags from.
//             int bAny   - TRUE means test for any of the flags being set.
//                          FALSE means test for all of the flags being set.
//
// Returns: TRUE if any or all of the flags specified in iFlag are turned on in the specified
//          flag group of the given flagset variable.
//:://///////////////////////
int GetIsGroupFlagSet( int iSet, int iFlag, int iGroup, int bAny = TRUE);
int GetIsGroupFlagSet( int iSet, int iFlag, int iGroup, int bAny = TRUE)
{ if( (iFlag == 0x00000000) || (iGroup == 0x00000000)) return FALSE;

  int iShift = 0;
  int iLimit = iGroup;
  while( (iLimit != 0x00000000) && GetIsFlagClear( iLimit, 0x00000001))
  { ++iShift;   iLimit >>= 1; }
  return ((iLimit == 0x00000000) ? FALSE : GetIsFlagSet( iSet, ((iFlag & iLimit) << iShift), bAny));
}


//:://///////////////////////
// int GetIsGroupFlagClear( int iSet, int iFlag, int iGroup, int bAll = TRUE)
//    Returns TRUE or FALSE if the flags specified in iFlag are turned off in the flag group
//    specified by iGroup. The bAll parameter is used to request an ANY or ALL test.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iFlag  - the flags to test.
//             int iGroup - the flag group to get the flags from.
//             int bAll   - TRUE means test for all of the flags being cleared.
//                          FALSE means test for any of the flags being cleared.
//
// Returns: TRUE if any or all of the flags specified in iFlag are turned off in the specified
//          flag group of the given flagset variable.
//:://///////////////////////
int GetIsGroupFlagClear( int iSet, int iFlag, int iGroup, int bAll = TRUE);
int GetIsGroupFlagClear( int iSet, int iFlag, int iGroup, int bAll = TRUE)
{ if( (iFlag == 0x00000000) || (iGroup == 0x00000000)) return FALSE;
  return !GetIsGroupFlagSet( iSet, iFlag, iGroup, !bAll);
}



//:://///////////////////////
// string GroupFlagToString( int iSet, int iGroup)
//    Returns the specified flag group from the given flagset as a string of 1's and 0's in the form:
//    "XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX" where FLAG1 is on the far right and FLAG32 the far left.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iGroup - the flag group to get the flags from.
//
// Returns: The converted flag group from the flagset in the form "XXXX XXXX XXXX XXXX XXXX XXXX XXXX"
//:://///////////////////////
string GroupFlagToString( int iSet, int iGroup);
string GroupFlagToString( int iSet, int iGroup)
{ if( iGroup == 0x00000000) return "0000 0000 0000 0000 0000 0000 0000 0000";
  iSet &= iGroup;
  while( (iGroup & 0x00000001) != 0x00000001)
  { iSet >>= 1;   iGroup >>= 1; }
  return FlagToString( iSet);
}
//:://///////////////////////
// void SetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup, int bOn = TRUE)
//    Sets a local group flag variable on an object.
//:://///////////////////////
// Parameters: object oObject   - the object to have the local flagset attached.
//             string sVariable - the flagset name to set the flag in.
//             int    iFlag     - the flag(s) to set or clear.
//             int    iGroup    - the group to set or clear the flags in.
//             int    bOn       - turn flags on if TRUE, off if FALSE
//
// Returns: None.
//:://///////////////////////
void SetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup, int bOn = TRUE);
void SetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup, int bOn = TRUE)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == 0x00000000)) return;
  int iSet = GetLocalInt( oObject, sVariable);
  SetLocalInt( oObject, sVariable, SetGroupFlag( iSet, iFlag, iGroup, bOn));
}


//:://///////////////////////
// void ClearLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
//    Clears a local group flag variable on an object.
//:://///////////////////////
// Parameters: object oObject   - the object to have the local flagset attached.
//             string sVariable - the flagset name to set the flag in.
//             int    iFlag     - the flag(s) to clear.
//             int    iGroup    - the group to set or clear the flags in.
//
// Returns: None.
//:://///////////////////////
void ClearLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup);
void ClearLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == 0x00000000)) return;
  int iSet = GetLocalInt( oObject, sVariable);
  SetLocalInt( oObject, sVariable, ClearGroupFlag( iSet, iFlag, iGroup));
}


//:://///////////////////////
// void SetLocalGroupFlagValue( object oObject, string sVariable, int iFlag, int iGroup)
//    Sets a local group flag variable on an object as a value.
//:://///////////////////////
// Parameters: object oObject   - the object to have the local flagset attached.
//             string sVariable - the flagset name to set the flag in.
//             int    iValue    - the value to set.
//             int    iGroup    - the group to set the value in.
//
// Returns: None.
//:://///////////////////////
void SetLocalGroupFlagValue( object oObject, string sVariable, int iValue, int iGroup);
void SetLocalGroupFlagValue( object oObject, string sVariable, int iValue, int iGroup)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == 0x00000000)) return;
  int iSet = GetLocalInt( oObject, sVariable);
  SetLocalInt( oObject, sVariable, SetGroupFlagValue( iSet, iValue, iGroup));
}


//:://///////////////////////
// int GetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
//    Returns the value(s) of a local group flag(s) from an object.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to retrieve the flag(s) from.
//             int    iFlag     - the flag(s) to be retrieved.
//             int    iGroup    - the group to get the flags from.
//
// Returns: The requested group flag(s) is/are returned as a flagset group.
//:://///////////////////////
int GetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup);
int GetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == 0x00000000)) return 0;
  int iSet = GetLocalInt( oObject, sVariable);
  return GetGroupFlag( iSet, iFlag, iGroup);
}


//:://///////////////////////
// int GetLocalGroupFlagValue( object oObject, string sVariable, int iGroup)
//    Returns the value of a local group flag number from an object.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to retrieve the value from.
//             int    iGroup    - the group to get the value from.
//
// Returns: The requested group's value is returned as a number.
//:://///////////////////////
int GetLocalGroupFlagValue( object oObject, string sVariable, int iGroup);
int GetLocalGroupFlagValue( object oObject, string sVariable, int iGroup)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == 0x00000000)) return 0;
  int iSet = GetLocalInt( oObject, sVariable);
  return GetGroupFlagValue( iSet, iGroup);
}


//:://///////////////////////
// void DeleteLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
//    Removes the specified flag(s) from the specified group of the given local flagset variable.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to delete the flag(s) from.
//             int    iFlag     - the flag(s) to be deleted.
//             int    iGroup    - the group to delete the flags from.
//
// Returns: None.
//:://///////////////////////
void DeleteLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup);
void DeleteLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == 0x00000000)) return;
  if( (iFlag == 0xFFFFFFFF) && (iGroup == 0xFFFFFFFF)) DeleteLocalInt( oObject, sVariable);
  else ClearLocalGroupFlag( oObject, sVariable, iFlag, iGroup);
}
////////////////////////////////////////////////////////////////////////////////
//:: END FLAG CALLS!
//::////////////////////////////////////////////////////////////////////////////

struct SF_SubraceMods
{
    string Portrait;
    string Appearance;
    string Head;
    int    VoiceSet;
    int    HairColor;
    int    SkinColor;
    string Wings;
    string Tail;
    string IsUndead;
    int    Speed;
    string STR;
    string DEX;
    string CON;
    string INT;
    string WIS;
    string CHA;
};


struct SF_SubraceMods SF_GetSubraceModifications(object oPC, string sSubrace)
{
    struct SF_SubraceMods Subrace;
    sSubrace = GetStringUpperCase(sSubrace);

    if (GetGender(oPC) == GENDER_MALE)
    {
        Subrace.Head = GetLocalString(MODULE, "SUBR_HEAD_M_" + sSubrace);
        Subrace.Portrait = GetLocalString(MODULE, "SUBR_POR_M_" + sSubrace);
        Subrace.VoiceSet = GetLocalInt(MODULE, "SUBR_VOI_M_" + sSubrace);
        Subrace.Appearance = GetLocalString(MODULE, "SUBR_APP_M_" + sSubrace);
    }
    else
    {
        Subrace.Head = GetLocalString(MODULE, "SUBR_HEAD_F_" + sSubrace);
        Subrace.Portrait = GetLocalString(MODULE, "SUBR_POR_F_" + sSubrace);
        Subrace.VoiceSet = GetLocalInt(MODULE, "SUBR_VOI_F_" + sSubrace);
        Subrace.Appearance = GetLocalString(MODULE, "SUBR_APP_F_" + sSubrace);
    }

    Subrace.STR = GetLocalString(MODULE, "SUBR_STR_" + sSubrace);
    Subrace.DEX = GetLocalString(MODULE, "SUBR_DEX_" + sSubrace);
    Subrace.CON = GetLocalString(MODULE, "SUBR_CON_" + sSubrace);
    Subrace.INT = GetLocalString(MODULE, "SUBR_INT_" + sSubrace);
    Subrace.WIS = GetLocalString(MODULE, "SUBR_WIS_" + sSubrace);
    Subrace.CHA = GetLocalString(MODULE, "SUBR_CHA_" + sSubrace);
    Subrace.Wings = GetLocalString(MODULE, "SUBR_WINGS_" + sSubrace);
    Subrace.Tail = GetLocalString(MODULE, "SUBR_TAIL_" + sSubrace);
    Subrace.IsUndead = GetLocalString(MODULE, "SUBR_UNDEAD_" + sSubrace);
    Subrace.HairColor = GetLocalInt(MODULE, "SUBR_HAIR_" + sSubrace);
    Subrace.SkinColor = GetLocalInt(MODULE, "SUBR_SKIN_" + sSubrace);
    Subrace.Speed = GetLocalInt(MODULE, "SUBR_SPEED_" + sSubrace);

    return Subrace;
}

struct SF_SubraceItems
{
    string HideResRef;
    string ClawResRef;
    string ItemResRef;
    int AcquireSkinLevel;
};

struct SF_SubraceItems SF_GetSubraceItems(object oPC, string sSubrace)
{
    struct SF_SubraceItems Subrace;

    Subrace.HideResRef = GetLocalString(MODULE, "SUBR_HIDE_" + sSubrace);
    Subrace.ClawResRef = GetLocalString(MODULE, "SUBR_CLAW_" + sSubrace);
    Subrace.ItemResRef = GetLocalString(MODULE, "SUBR_ITEM_" + sSubrace);
    Subrace.AcquireSkinLevel = GetLocalInt(MODULE, "SUBR_LVLSKIN_" + sSubrace);

    return Subrace;
}

struct SF_SubraceFeats
{
    string Feats;
};

//struct SF_SubraceFeats SF_GetSubraceFeats(object oPC, string sSubrace)
void SF_ApplySubraceFeats(object oPC, string sSubrace)
{
    //struct SF_SubraceFeats Subrace;
    //string sFeat = "";
    int nFeatsAdded = GetLocalInt(MODULE, "SUBR_FEAT_" + sSubrace);
    int nLoop = 1;
    //sFeat = GetLocalString(MODULE, "SUBR_FEAT_" + IntToString(nLoop) + sSubrace);

    for (nLoop; nLoop <= nFeatsAdded; nLoop++)
    {

        NWNX_Creature_AddFeat(oPC, GetLocalInt(MODULE, "SUBR_FEAT_" + sSubrace + IntToString(nLoop)));
    }

    /*
    while (sFeat != "")
    {
        Subrace.Feats += AddFeat(StringToInt(sFeat));
        nLoop ++;
        sFeat = GetLocalString(MODULE, "SUBR_FEAT_" + IntToString(nLoop) + sSubrace);
    }
    */
    return;
}

void SF_CreateNewSubrace(string sSubrace, int nAppearanceTypeMale = APPEARANCE_TYPE_INVALID, int nAppearanceTypeFemale = APPEARANCE_TYPE_INVALID, string sHideResRef = "", string sClawResRef = "", string sItemResRef = "", int bIsUndead = FALSE, int nLevelAcquiredSkin = 1)
{
    sSubrace = GetStringUpperCase(sSubrace);

    if (sHideResRef != "")
    {
        SetLocalString(MODULE, "SUBR_HIDE_" + sSubrace, sHideResRef);
    }
    if (sClawResRef != "")
    {
        SetLocalString(MODULE, "SUBR_CLAW_" + sSubrace, sClawResRef);
    }
    if (sItemResRef != "")
    {
        SetLocalString(MODULE, "SUBR_ITEM_" + sSubrace, sItemResRef);
    }
    if (bIsUndead)
    {
        SetLocalString(MODULE, "SUBR_UNDEAD_" + sSubrace, "1");
    }

    SetLocalInt(MODULE, "SUBR_LVLSKIN_" + sSubrace, nLevelAcquiredSkin);
    SetLocalInt(MODULE, "SUBR_NAME_" + sSubrace, TRUE);

    if (nAppearanceTypeMale != APPEARANCE_TYPE_INVALID)
    {
        SetLocalString(MODULE, "SUBR_APP_M_" + sSubrace, IntToString(nAppearanceTypeMale));
    }
    if (nAppearanceTypeFemale != APPEARANCE_TYPE_INVALID)
    {
        SetLocalString(MODULE, "SUBR_APP_F_" + sSubrace, IntToString(nAppearanceTypeFemale));
    }

}

void SF_SetSubraceHeadType(string sSubrace, int nMaleHead, int nFemaleHead)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalString(MODULE, "SUBR_HEAD_M_" + sSubrace, IntToString(nMaleHead));
    SetLocalString(MODULE, "SUBR_HEAD_F_" + sSubrace, IntToString(nFemaleHead));
}

void SF_SetSubraceBodyAttatchments(string sSubrace, int nWingType, int nTailType)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalString(MODULE, "SUBR_WINGS_" + sSubrace, IntToString(nWingType));
    SetLocalString(MODULE, "SUBR_TAIL_" + sSubrace, IntToString(nTailType));
}

void SF_SetSubraceAppearanceColor(string sSubrace, int nSkinColor, int nHairColor)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalInt(MODULE, "SUBR_SKIN_" + sSubrace, nSkinColor);
    SetLocalInt(MODULE, "SUBR_HAIR_" + sSubrace, nHairColor);
}

void SF_SetSubracePortrait(string sSubrace, string sMalePortrait, string sFemalePortrait)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalString(MODULE, "SUBR_POR_M_" + sSubrace, sMalePortrait);
    SetLocalString(MODULE, "SUBR_POR_F_" + sSubrace, sFemalePortrait);
}

void SF_SetSubraceVoiceSet(string sSubrace, int nMaleVoiceSet, int nFemaleVoiceset)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalInt(MODULE, "SUBR_VOI_M_" + sSubrace, nMaleVoiceSet);
    SetLocalInt(MODULE, "SUBR_VOI_F_" + sSubrace, nFemaleVoiceset);
}

void SF_SetSubraceFeat(string sSubrace, int nFeat)
{
    sSubrace = GetStringUpperCase(sSubrace);
    int nFeatCount = GetLocalInt(MODULE, "SUBR_FEAT_" + sSubrace) + 1;
    //SetLocalString(MODULE, "SUBR_FEAT_" + IntToString(nFeat) + sSubrace, IntToString(nFeatType));
    SetLocalInt(MODULE, "SUBR_FEAT_" + sSubrace + IntToString(nFeatCount), nFeat);
    SetLocalInt(MODULE, "SUBR_FEAT_" + sSubrace, nFeatCount);  //Count of feats added.
}

void SF_SetSubraceMovementSpeed(string sSubrace, int nNewSpeed)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalInt(MODULE, "SUBR_SPEED_" + sSubrace, nNewSpeed);
}

void SF_SetSubraceSpellResistance(string sSubrace, int nSpellResist)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalInt(MODULE, "SUBR_SR_" + sSubrace, nSpellResist);
}

void SF_SetSubraceClassRestriction(string sSubrace, int bAllowUseClasses, int nRestrictedToClasses, int nRestrictUntilLevel)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalInt(MODULE, "SUBR_CLASS_" + sSubrace, nRestrictedToClasses | bAllowUseClasses);
    SetLocalInt(MODULE, "SUBR_CL_TIL_" + sSubrace, nRestrictUntilLevel);
}

void SF_SetSubraceRaceRestriction(string sSubrace, int bAllowUseRaces, int nRestrictedToRaces)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalInt(MODULE, "SUBR_RACE_" + sSubrace, nRestrictedToRaces | bAllowUseRaces);
}

void SF_SetSubraceAlignmentRestriction(string sSubrace, int bAllowUseAlignment, int nRestrictedAlignments)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalInt(MODULE, "SUBR_ALIGN_" + sSubrace, nRestrictedAlignments | bAllowUseAlignment);
}

void SF_SetSubraceEquipmentRestriction(string sSubrace, int bAllowUseEquipment, int nRestrictedEquip)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalInt(MODULE, "SUBR_EQUIP_" + sSubrace, nRestrictedEquip | bAllowUseEquipment);
}

void SF_SetSubraceSkill(string subraceName, int SkillID, int iModifier, int Level = 1, int Set = FALSE)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   SubraceTag = SubraceTag + "_" + IntToString(Level);
   int SkillCount = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BONUS_SKILL_COUNT);
   SkillCount++;
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, SkillID, SUBRACE_BONUS_SKILL_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, Set, SUBRACE_BONUS_SKILL_REMOVE_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, iModifier, SUBRACE_BONUS_SKILL_MODIFIER_FLAG);
   SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BONUS_SKILL_COUNT, SkillCount);
}

void SF_AdjustSubraceStats(string sSubrace, int nSTR, int nDEX, int nCON, int nINT, int nWIS, int nCHA)
{
    sSubrace = GetStringUpperCase(sSubrace);
    SetLocalString(MODULE, "SUBR_STR_" + sSubrace, IntToString(nSTR));
    SetLocalString(MODULE, "SUBR_DEX_" + sSubrace, IntToString(nDEX));
    SetLocalString(MODULE, "SUBR_CON_" + sSubrace, IntToString(nCON));
    SetLocalString(MODULE, "SUBR_INT_" + sSubrace, IntToString(nINT));
    SetLocalString(MODULE, "SUBR_WIS_" + sSubrace, IntToString(nWIS));
    SetLocalString(MODULE, "SUBR_CHA_" + sSubrace, IntToString(nCHA));
}

void SF_SendSubraceMessage(object oPC, string sMessage)
{
    FloatingTextStringOnCreature(sMessage, oPC, FALSE);
}

void SF_ApplySubraceSpellResistance(object oPC)
{
    string sSubrace = GetStringUpperCase(GetSubRace(oPC));

    if (sSubrace == "")
    {
        return;
    }

    int nSpellResist = GetLocalInt(MODULE, "SUBR_SR_" + sSubrace);

    if (!nSpellResist)
    {
        return;
    }

    SF_SendSubraceMessage(oPC, APPLYING_SPELL_RESISTANCE);

    effect eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectType(eEffect) == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE &&
            GetEffectSubType(eEffect) == SUBTYPE_SUPERNATURAL)
        {
            RemoveEffect(oPC, eEffect);
            break;
        }
        eEffect = GetNextEffect(oPC);
    }

    nSpellResist = nSpellResist / 40 * GetHitDice(oPC);

    if (!nSpellResist)
    {
        return;
    }

    effect eSpellResist = SupernaturalEffect(EffectSpellResistanceIncrease(nSpellResist));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellResist, oPC);

}

void SF_ApplySubraceItems(object oPC, string sSubrace)
{
    AssignCommand(oPC, ClearAllActions());
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
    struct SF_SubraceItems Subrace = SF_GetSubraceItems(oPC, sSubrace);

    int nLevel = GetHitDice(oPC);
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    object oClaw1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    object oClaw2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);

    string sSubrace = GetStringUpperCase(GetSubRace(oPC));
    if (sSubrace == "") { return; }
    int nHasHideAllready;
    if (GetIsObjectValid(oHide))
    {
        if (GetResRef(oHide) == Subrace.HideResRef) nHasHideAllready = TRUE;
        else Insured_Destroy(oHide);
    }
    if (GetIsObjectValid(oClaw1))
    {
        Insured_Destroy(oClaw1);
    }
    if (GetIsObjectValid(oClaw2 ))
    {
        Insured_Destroy(oClaw2);
    }

    if (nLevel >= Subrace.AcquireSkinLevel && !nHasHideAllready)
    {
        SF_SendSubraceMessage(oPC, APPLYING_SUBRACE_SKIN);

        if (Subrace.HideResRef == "")
        {
            oHide = GetItemPossessedBy(oPC, DEFAULT_SUBRACE_HIDE);

            if (GetIsObjectValid(oHide))
            {
                Insured_Destroy(oHide);
            }

            oHide = CreateItemOnObject(DEFAULT_SUBRACE_HIDE, oPC);
            AssignCommand(oPC, ActionEquipItem(oHide, INVENTORY_SLOT_CARMOUR));
        }
        else
        {
            oHide = GetItemPossessedBy(oPC, Subrace.HideResRef);

            if (GetIsObjectValid(oHide))
            {
                Insured_Destroy(oHide);
            }

            oHide = CreateItemOnObject(Subrace.HideResRef, oPC);
            AssignCommand(oPC, ActionEquipItem(oHide, INVENTORY_SLOT_CARMOUR));
        }
    }
    if (Subrace.ClawResRef != "")
    {
        AssignCommand(oPC, ActionDoCommand(SF_SendSubraceMessage(oPC, APPLYING_SUBRACE_CLAW)));
        oClaw1 = CreateItemOnObject(Subrace.ClawResRef, oPC);
        oClaw2 = CreateItemOnObject(Subrace.ClawResRef, oPC);
        AssignCommand(oPC, ActionEquipItem(oClaw1, INVENTORY_SLOT_CWEAPON_L));
        AssignCommand(oPC, ActionEquipItem(oClaw2, INVENTORY_SLOT_CWEAPON_R));
    }
    if (Subrace.ItemResRef != "" && !GetIsObjectValid(GetItemPossessedBy(oPC, Subrace.ItemResRef)))
    {
        CreateItemOnObject(Subrace.ItemResRef, oPC);
    }

    AssignCommand(oPC, ActionDoCommand(SF_SendSubraceMessage(oPC, SUBRACE_ITEMS_APPLIED)));
    //AssignCommand(oPC, ActionDoCommand(SetCutsceneMode(oPC, FALSE, TRUE)));
    //AssignCommand(oPC, ActionDoCommand(SetPlotFlag(oPC, FALSE)));
    AssignCommand(oPC, DelayCommand(3.0, ExecuteScript("tk_playertools", oPC)));
}

void SF_ApplySubraceToPC(object oPC, string sSubrace)
{
    string sLetoScript;
    struct SF_SubraceMods Subrace = SF_GetSubraceModifications(oPC, sSubrace);

    if (Subrace.IsUndead != "")
    {
        SetDeity(oPC, "RACIAL_TYPE_UNDEAD");
        NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_UNDEAD);
    }
    if (Subrace.Head != "")
    {
        SetCreatureBodyPart(CREATURE_PART_HEAD, StringToInt(Subrace.Head), oPC);
    }
    if (Subrace.Appearance != "")
    {
        DelayCommand(2.0, SetCreatureAppearanceType(oPC, StringToInt(Subrace.Appearance)));
    }
    if (Subrace.Wings  != "")
    {
        DelayCommand(2.0, SetCreatureWingType(StringToInt(Subrace.Wings), oPC));
    }
    if (Subrace.Tail  != "")
    {
        DelayCommand(2.0, SetCreatureTailType(StringToInt(Subrace.Tail), oPC));
    }
    if (Subrace.Portrait != "")
    {
        DelayCommand(2.0, SetPortraitResRef(oPC, Subrace.Portrait));
    }
    if (Subrace.SkinColor)
    {
        //sLetoScript += SetSkinColor(StringToInt(Subrace.SkinColor));
        DelayCommand(2.0, SetColor(oPC, COLOR_CHANNEL_SKIN, Subrace.SkinColor));
    }
    if (Subrace.HairColor)
    {
        //sLetoScript += SetHairColor(StringToInt(Subrace.HairColor));
        DelayCommand(2.0, SetColor(oPC, COLOR_CHANNEL_HAIR, Subrace.HairColor));
    }
    if (Subrace.VoiceSet)
    {
        //sLetoScript += SetSoundSet(StringToInt(Subrace.VoiceSet));
        DelayCommand(2.0, NWNX_Creature_SetSoundset(oPC, Subrace.VoiceSet));
    }
    if (Subrace.Speed)
    {
        //sLetoScript += SetMovement(StringToInt(Subrace.Speed));
        DelayCommand(2.0, NWNX_Creature_SetMovementRate(oPC, Subrace.Speed));
    }
    if (Subrace.STR != "0" && Subrace.STR != "")
    {
        //sLetoScript += AdjustAbility(ABILITY_STRENGTH, StringToInt(Subrace.STR));
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, StringToInt(Subrace.STR));
    }
    if (Subrace.DEX != "0" && Subrace.DEX != "")
    {
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, StringToInt(Subrace.DEX));
        //sLetoScript += AdjustAbility(ABILITY_DEXTERITY, StringToInt(Subrace.DEX));
    }
    if (Subrace.CON != "0" && Subrace.CON != "")
    {
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, StringToInt(Subrace.CON));
        //sLetoScript += AdjustAbility(ABILITY_CONSTITUTION, StringToInt(Subrace.CON));
    }
    if (Subrace.INT != "0" && Subrace.INT != "")
    {
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, StringToInt(Subrace.INT));
        //sLetoScript += AdjustAbility(ABILITY_INTELLIGENCE, StringToInt(Subrace.INT));
    }
    if (Subrace.WIS != "0" && Subrace.WIS != "")
    {
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, StringToInt(Subrace.WIS));
        //sLetoScript += AdjustAbility(ABILITY_WISDOM, StringToInt(Subrace.WIS));
    }
    if (Subrace.CHA != "0" && Subrace.CHA != "")
    {
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, StringToInt(Subrace.CHA));
        //sLetoScript += AdjustAbility(ABILITY_CHARISMA, StringToInt(Subrace.CHA));
    }


    SF_ApplySubraceFeats(oPC, sSubrace);
    /*
    struct SF_SubraceFeats SubRace = SF_GetSubraceFeats(oPC, sSubrace);
    if (SubRace.Feats != "")
    {
        sLetoScript += SubRace.Feats;
    }
    */
    //DelayCommand(5.0, ApplyLetoScriptToPC(sLetoScript, oPC));
}

string SF_CapitalizeSubraceName(object oPC)
{
    string sSubrace = GetSubRace(oPC);
    sSubrace = GetStringLeft(sSubrace, 1) + GetStringLowerCase(GetStringRight(sSubrace, GetStringLength(sSubrace) - 1));
    SetSubRace(oPC, sSubrace);
    return sSubrace;
}

int SF_GetIsSubraceValid(string sSubrace)
{
    if (GetLocalInt(MODULE, "SUBR_NAME_" + sSubrace))
    {
        return TRUE;
    }
    return FALSE;
}

int SF_GetIsClassValid(object oPC, int nClassPos, string sSubrace)
{
    int nClassRestrictions = GetLocalInt(MODULE, "SUBR_CLASS_" + sSubrace);
    int nClassType = GetClassByPosition(1, oPC);

    switch(nClassType)
    {
        case CLASS_TYPE_BARBARIAN:
        {
            nClassType = CLASS_RESTRICT_BARBARIAN;
            break;
        }
        case CLASS_TYPE_BARD:
        {
            nClassType = CLASS_RESTRICT_BARD;
            break;
        }
        case CLASS_TYPE_CLERIC:
        {
            nClassType = CLASS_RESTRICT_CLERIC;
            break;
        }
        case CLASS_TYPE_DRUID:
        {
            nClassType = CLASS_RESTRICT_DRUID;
            break;
        }
        case CLASS_TYPE_FIGHTER:
        {
            nClassType = CLASS_RESTRICT_FIGHTER;
            break;
        }
        case CLASS_TYPE_MONK:
        {
            nClassType = CLASS_RESTRICT_MONK;
            break;
        }
        case CLASS_TYPE_PALADIN:
        {
            nClassType = CLASS_RESTRICT_PALADIN;
            break;
        }
        case CLASS_TYPE_RANGER:
        {
            nClassType = CLASS_RESTRICT_RANGER;
            break;
        }
        case CLASS_TYPE_ROGUE:
        {
            nClassType = CLASS_RESTRICT_ROGUE;
            break;
        }
        case CLASS_TYPE_SORCERER:
        {
            nClassType = CLASS_RESTRICT_SORCERER;
            break;
        }
        case CLASS_TYPE_WIZARD:
        {
            nClassType = CLASS_RESTRICT_WIZARD;
            break;
        }
    }

    int nValid = nClassType & nClassRestrictions ? TRUE : FALSE;
    int nAllowUseClasses = nClassRestrictions & ALLOW_USE_TRUE ? TRUE : FALSE;
    return nValid == nAllowUseClasses;
}

int SF_GetIsRaceValid(object oPC, string sSubrace)
{
    int nRaceRestrictions = GetLocalInt(MODULE, "SUBR_RACE_" + sSubrace);
    int nRacialType = GetRacialType(oPC);

    switch(nRacialType)
    {
        case RACIAL_TYPE_DWARF:
        {
            nRacialType = RACE_RESTRICT_DWARF;
            break;
        }
        case RACIAL_TYPE_ELF:
        {
            nRacialType = RACE_RESTRICT_ELF;
            break;
        }
        case RACIAL_TYPE_GNOME:
        {
            nRacialType = RACE_RESTRICT_GNOME;
            break;
        }
        case RACIAL_TYPE_HALFELF:
        {
            nRacialType = RACE_RESTRICT_HALFELF;
            break;
        }
        case RACIAL_TYPE_HALFLING:
        {
            nRacialType = RACE_RESTRICT_HALFLING;
            break;
        }
        case RACIAL_TYPE_HALFORC:
        {
            nRacialType = RACE_RESTRICT_HALFORC;
            break;
        }
        case RACIAL_TYPE_HUMAN:
        {
            nRacialType = RACE_RESTRICT_HUMAN;
            break;
        }
    }

    int nValid = nRacialType & nRaceRestrictions ? TRUE : FALSE;
    int nAllowUseRaces = nRaceRestrictions & ALLOW_USE_TRUE ? TRUE : FALSE;
    return nValid == nAllowUseRaces;
}

int SF_SubraceOnEnter(object oPC)
{
    LetoPCEnter(oPC);
    string sSubrace = GetStringUpperCase(GetSubRace(oPC));

    SF_CapitalizeSubraceName(oPC);

    if (GetXP(oPC))
    {
        if (sSubrace != "")
        {
            // SF_ApplySubraceSpellResistance(oPC); // ez, no SR on DeX for subraces
            //SetLocalInt(oPC, "APPLY_SKIN");
            SF_ApplySubraceItems(oPC, sSubrace);
        }
    }
    else
    {
        int nError = 0;
        SetXP(oPC, 1);

        if (sSubrace == "")
        {
            return FALSE;
        }

        if (GetCreatureWingType(oPC))
        {
            SetCreatureWingType(WINGS_TYPE_NONE, oPC);
        }

        if (!SF_GetIsSubraceValid(sSubrace))
        {
            DelayCommand(3.0, SF_SendSubraceMessage(oPC, INVALID_SUBRACE));

            SetSubRace(oPC, "");
            {
                return FALSE;
            }
        }
        if (!SF_GetIsClassValid(oPC, 1, sSubrace))
        {
            DelayCommand(3.0, SF_SendSubraceMessage(oPC, INVALID_CLASS));
            nError++;
        }
        if (!SF_GetIsRaceValid(oPC, sSubrace))
        {
            DelayCommand(3.0, SF_SendSubraceMessage(oPC, INVALID_RACE));
            nError++;
        }
        /*if (!SF_GetIsAlignmentValid(oPC, sSubrace)) // no alignment restriction on DeX
        {
            DelayCommand(3.0, SF_SendSubraceMessage(oPC, INVALID_ALIGNMENT));
            nError++;
        }*/
        if (nError)
        {
            SetSubRace(oPC, "");
                { return FALSE; }
        }
        else
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 5.0);
            SF_CapitalizeSubraceName(oPC);
            DelayCommand(2.0, SF_SendSubraceMessage(oPC, APPLYING_SUBRACE));
            DelayCommand(3.0, SF_ApplySubraceToPC(oPC, sSubrace));
            DelayCommand(5.0, SF_SendSubraceMessage(oPC, APPLYING_SUBRACE_COMPLETE));

            // See file "inc_traininghall" for more informations

            return TRUE;
        }
    }
    AssignCommand(oPC, DelayCommand(3.0, ExecuteScript("tk_playertools", oPC)));
    return FALSE;
}

void SF_SubraceOnExit(object oPC)
{
    LetoPCExit(oPC);
}

int SF_GetIsAlignmentValid(object oPC, string sSubrace)
{
    int nRestrictedAlignments = GetLocalInt(MODULE, "SUBR_ALIGN_" + sSubrace);
    int nValidG_E; int nValidL_C;

    switch( GetAlignmentGoodEvil(oPC))
    {
      case ALIGNMENT_GOOD:
      {
          nValidG_E = ALIGN_RESTRICT_GOOD;
          break;
      }
      case ALIGNMENT_EVIL:
      {
          nValidG_E = ALIGN_RESTRICT_EVIL;
          break;
      }
      default:
      {
          nValidG_E = ALIGN_RESTRICT_NEUTRAL1;
          break;
      }
    }
    switch(GetAlignmentLawChaos(oPC))
    {
        case ALIGNMENT_LAWFUL:
        {
            nValidL_C = ALIGN_RESTRICT_LAWFUL;
            break;
        }
        case ALIGNMENT_CHAOTIC:
        {
            nValidL_C = ALIGN_RESTRICT_CHAOTIC;
            break;
        }
        default:
        {
            nValidL_C = ALIGN_RESTRICT_NEUTRAL2;
            break;
        }
    }
    int nValid = nValidG_E + nValidL_C & nRestrictedAlignments ? TRUE : FALSE;
    int nAllowUseAllignment = nRestrictedAlignments & ALLOW_USE_TRUE ? TRUE : FALSE;
    return nValid == nAllowUseAllignment;
}

void SF_SubraceOnLevelUp(object oPC)
{
    string sSubrace = GetStringUpperCase(GetSubRace(oPC));
    int nRestrictedClassToLevel = GetLocalInt(MODULE, "SUBR_CL_TIL_" + sSubrace);
    int nHD = GetHitDice(oPC);
    int nClass2 = GetLevelByPosition(2, oPC);
    int nInvalid;

    if ((nHD <= nRestrictedClassToLevel && !nClass2) || nHD > nRestrictedClassToLevel )
    {
        // nothing
    }
    else
    {
        SF_SendSubraceMessage(oPC, INVALID_CLASS);
        nInvalid = TRUE;
    }

    if (!SF_GetIsAlignmentValid(oPC, sSubrace))
    {
        SF_SendSubraceMessage(oPC, INVALID_ALIGNMENT);
        nInvalid = TRUE;
    }

    if (nInvalid)
    {
        SF_SendSubraceMessage(oPC, RELEVEL_CHARACTER);
        int nHD = GetHitDice(oPC);
        int nNewXP = (nHD * (nHD - 1) * 500) - 1;
        SetXP(oPC, nNewXP);
        DelayCommand(3.0, GiveXPToCreature(oPC, 1));
    }
    else
    {
        //SF_ApplySubraceSpellResistance(oPC);
        SF_ApplySubraceItems(oPC, sSubrace);
    }
}

void SF_SubraceOnEquipItem(object oPC)
{
    string sSubrace = GetStringUpperCase(GetSubRace(oPC));

    if (sSubrace == "")
    {
        return;
    }

    int nEquipRestrictions = GetLocalInt(MODULE, "SUBR_EQUIP_" + sSubrace);
    object oItem = GetPCItemLastEquipped();
    int nItemType = GetBaseItemType(oItem);
    int nValid;
    if (nItemType == BASE_ITEM_BULLET ||
        nItemType == BASE_ITEM_ARROW ||
        nItemType == BASE_ITEM_BOLT ||
        nItemType == BASE_ITEM_RING ||
        nItemType == BASE_ITEM_BRACER ||
        nItemType == BASE_ITEM_CLOAK ||
        nItemType == BASE_ITEM_BELT ||
        nItemType == BASE_ITEM_BOOTS ||
        nItemType == BASE_ITEM_AMULET ||
        nItemType == BASE_ITEM_HELMET ||
        nItemType == BASE_ITEM_GLOVES)
    {
        return;
    }
    if (nItemType == BASE_ITEM_ARMOR)
    {
        nValid = SF_GetArmorBaseType(oItem) & nEquipRestrictions ? TRUE : FALSE;
    }
    else if (nItemType == BASE_ITEM_SMALLSHIELD)
    {
        nValid = EQUIP_RESTRICT_SHIELD_SMALL & nEquipRestrictions ? TRUE : FALSE;
    }
    else if (nItemType == BASE_ITEM_LARGESHIELD)
    {
        nValid = EQUIP_RESTRICT_SHIELD_LARGE & nEquipRestrictions ? TRUE : FALSE;
    }
    else if (nItemType == BASE_ITEM_TOWERSHIELD)
    {
        nValid = EQUIP_RESTRICT_SHIELD_TOWER & nEquipRestrictions ? TRUE : FALSE;
    }
    else
    {
        nValid = SF_GetWeaponSize(oItem) & nEquipRestrictions ? TRUE : FALSE;
    }

    int AllowUseEquipment = nEquipRestrictions & ALLOW_USE_TRUE ? TRUE : FALSE;

    if (nValid != AllowUseEquipment)
    {
        SF_SendSubraceMessage(oPC, INVALID_EQUIPMENT);
        DelayCommand(0.5, AssignCommand(oPC, ClearAllActions(TRUE)));
        DelayCommand(0.6, AssignCommand(oPC, ActionUnequipItem(oItem)));
    }
}

int SF_GetWeaponSize(object oItem)
{
    int nWeaponSize;
    switch (GetBaseItemType(oItem))
    {
        // Tiny Sized Weapons
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_SHURIKEN: nWeaponSize = EQUIP_RESTRICT_WEAPON_TINY; break;

        // Small Sized Weapons
        case BASE_ITEM_DART:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SLING:
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_WHIP: nWeaponSize = EQUIP_RESTRICT_WEAPON_SMALL; break;

        // Medium Sized Weapons
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SHORTSPEAR: nWeaponSize = EQUIP_RESTRICT_WEAPON_MEDIUM; break;

        // Large Sized Weapons
        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_MAGICSTAFF:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_TRIDENT:
        case BASE_ITEM_TWOBLADEDSWORD: nWeaponSize = EQUIP_RESTRICT_WEAPON_LARGE; break;
    }
    return nWeaponSize;
}

int SF_GetArmorBaseType(object oItem)
{
    int nArmourWieght = GetWeight(oItem);

    if (nArmourWieght >= 45)
    {
        return EQUIP_RESTRICT_ARMOUR_HEAVY;
    }
    if (nArmourWieght >= 30)
    {
        return EQUIP_RESTRICT_ARMOUR_MEDIUM;
    }
    if (nArmourWieght >= 5)
    {
        return EQUIP_RESTRICT_ARMOUR_LIGHT;
    }

    return EQUIP_RESTRICT_ARMOUR_CLOTH;
}

int SF_GetIsSubraceUndead(object oPC)
{
    return GetDeity(oPC) == "RACIAL_TYPE_UNDEAD";
}
//void main(){}

