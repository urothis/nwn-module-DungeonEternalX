

// Return the name of the Class bye nPosition (1-2-3)
string GetStringClassByPosition(object oPC, int nPosition);
// This will return your build string + levels by class
// exemple : Fighter (1) Monk (3) Sorcerer (10)
// This function support custom 2da's for those who
// start with prestige classes for example, and support
// aswell monsters' classes.
string GetCharacterBuild(object oPC);


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
string GetClassStringByPosition(object oPC, int nPosition)
{
 string sClass;
 int    nPositionFinder=GetClassByPosition(nPosition, oPC);

 switch (nPositionFinder)
 {
 case CLASS_TYPE_ABERRATION      : sClass = "Aberration";       break;
 case CLASS_TYPE_ANIMAL          : sClass = "Animal";           break;
 case CLASS_TYPE_ARCANE_ARCHER   : sClass = "Arcane Archer";    break;
 case CLASS_TYPE_ASSASSIN        : sClass = "Assassin";         break;
 case IP_CONST_CLASS_BARBARIAN   : sClass = "Barbarian";        break;
 case IP_CONST_CLASS_BARD        : sClass = "Bard";             break;
 case CLASS_TYPE_BEAST           : sClass = "Beast";            break;
 case CLASS_TYPE_BLACKGUARD      : sClass = "Blackguard";       break;
 case IP_CONST_CLASS_CLERIC      : sClass = "Cleric";           break;
 case CLASS_TYPE_COMMONER        : sClass = "Commoner";         break;
 case CLASS_TYPE_CONSTRUCT       : sClass = "Construct";        break;
 case CLASS_TYPE_DRAGON          : sClass = "Dragon";           break;
 case CLASS_TYPE_DRAGON_DISCIPLE : sClass = "Dragon Disciple";  break;
 case IP_CONST_CLASS_DRUID       : sClass = "Druid";            break;
 case CLASS_TYPE_DWARVEN_DEFENDER: sClass = "Dwarven Defender"; break;
 case CLASS_TYPE_ELEMENTAL       : sClass = "Elemental";        break;
 case CLASS_TYPE_EYE_OF_GRUUMSH  : sClass = "Eye of Gruumsh";   break;
 case CLASS_TYPE_FEY             : sClass = "Fey";              break;
 case IP_CONST_CLASS_FIGHTER     : sClass = "Fighter";          break;
 case CLASS_TYPE_HARPER          : sClass = "Harper";           break;
 case CLASS_TYPE_HUMANOID        : sClass = "Humanoid";         break;
 case CLASS_TYPE_INVALID         : sClass = "Invalid";          break;
 case CLASS_TYPE_MAGICAL_BEAST   : sClass = "Magical Beast";    break;
 case IP_CONST_CLASS_MONK        : sClass = "Monk";             break;
 case CLASS_TYPE_MONSTROUS       : sClass = "Monstrous";        break;
 case CLASS_TYPE_OOZE            : sClass = "Ooze";             break;
 case CLASS_TYPE_OUTSIDER        : sClass = "Outsider";         break;
 case IP_CONST_CLASS_PALADIN     : sClass = "Paladin";          break;
 case CLASS_TYPE_PALE_MASTER     : sClass = "Pale Master";      break;
 case IP_CONST_CLASS_RANGER      : sClass = "Ranger";           break;
 case IP_CONST_CLASS_ROGUE       : sClass = "Rogue";            break;
 case CLASS_TYPE_SHADOWDANCER    : sClass = "Shadow Dancer";    break;
 case CLASS_TYPE_SHAPECHANGER    : sClass = "Shape Changer";    break;
 case CLASS_TYPE_SHIFTER         : sClass = "Shape Shifter";    break;
 case CLASS_TYPE_SHOU_DISCIPLE   : sClass = "Shou Disciple";    break;
 case IP_CONST_CLASS_SORCERER    : sClass = "Sorcerer";         break;
 case CLASS_TYPE_UNDEAD          : sClass = "Undead";           break;
 case CLASS_TYPE_VERMIN          : sClass = "Vermin";           break;
 case CLASS_TYPE_WEAPON_MASTER   : sClass = "Weapon Master";    break;
 case IP_CONST_CLASS_WIZARD      : sClass = "Wizard";           break;
 }
 return sClass;
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
string GetCharacterBuild(object oPC)
{
 string sCharacterBuild;

 int nLevelByPosition1=GetLevelByPosition(1, oPC);
 int nLevelByPosition2=GetLevelByPosition(2, oPC);
 int nLevelByPosition3=GetLevelByPosition(3, oPC);


 string sPosition1 = GetClassStringByPosition(oPC, 1);
 string sPosition2 = GetClassStringByPosition(oPC, 2);
 string sPosition3 = GetClassStringByPosition(oPC, 3);

 string sLevelPosition1 = IntToString(nLevelByPosition1);
 string sLevelPosition2 = IntToString(nLevelByPosition2);
 string sLevelPosition3 = IntToString(nLevelByPosition3);

 string sMessage1="";
 string sMessage2="";
 string sMessage3="";

 if (nLevelByPosition1>0){sMessage1=sPosition1+" ("+sLevelPosition1+") ";}
 if (nLevelByPosition2>0){sMessage2=sPosition2+" ("+sLevelPosition2+") ";}
 if (nLevelByPosition3>0){sMessage3=sPosition3+" ("+sLevelPosition3+") ";}

 return sMessage1+sMessage2+sMessage3;

}


