//::///////////////////////////////////////////////
//:: Scarface's Leto Functions
//:: Subrace Leto Functions Include
//:: sfsubr_leto_inc
//:://////////////////////////////////////////////
/*

    These are Leto functions I found on the
    LetoScript forums which I have modified to
    suit my needs.

    Scarface

*/
//:://////////////////////////////////////////////
#include "db_inc"
#include "sfsubr_consts"
#include "inc_server"
#include "nwnx_ruby"
#include "nwnx_admin"

//No change. This is pure bridge code, and the syntax there has hardly moved at all.(DS)


// Used to check whether NWNX2-Leto is functioning properly.
// Returns TRUE if Leto is working.
int LetoPingPong();

string LetoScript(string sScript) {
  // Seed - added logging data
    // Stores a var in the module which NWNX LETO then takes and works with.
    WriteTimestampedLogEntry("Leto Subrace Script >: "+sScript);
    string sScriptResult = NWNX_Ruby_Evaluate("(LetoLib.request %q#" + sScript + "#).to_s");
    WriteTimestampedLogEntry("Leto Subrace Results <: "+sScriptResult);
    // Gets the var now changed by NWNX LETO back from the module and returns it.
    return sScriptResult;
}

string LetoSet(string sLocation,string sValue, string sType, int bAdd = TRUE)
{
    if(sType != "byte"
        && sType != "word"
        && sType != "int"
        && sType != "dword"
        && sType != "char"
        && sType != "short"
        && sType != "dword64"
        && sType != "int64"
        && sType != "float"
        && sType != "double"
        && sType != "list")
    {
        sValue = "qq{"+sValue+"}";
    }
    string sReturn = "add /"+sLocation+", ";
        if(sType != "list")
            sReturn += "Value => "+sValue+", ";
        sReturn += "Type => gff"+sType;
        if(bAdd)
            sReturn += ", SetIfExists => TRUE";
        sReturn += "; ";
        return sReturn;
}

void ApplyLetoScriptToPC(string Script, object oPC, int nPortal = FALSE)
{
    string BicPath = NWN_SERVERVAULT_DIR + GetPCPlayerName(oPC) + "/";
    string BicFile;
        Script =
            "$RealFile = q<" + BicPath + "> + FindNewestBic q<" + BicPath + ">;" +
            "$EditFile = $RealFile + '.utc';" +
            "FileRename $RealFile, $EditFile;" +
            "%bic = $EditFile or die;" +
            Script +
            "%bic = '>';" +
            "close %bic;" +
            "FileRename $EditFile, $RealFile;";

    PrintString(Script);
    SetLocalString(oPC, "LetoScript", Script);
    ExportSingleCharacter(oPC);
    DelayCommand(1.0, PopUpDeathGUIPanel(oPC, FALSE, FALSE, FALSE, "You must now relog."));
}

string LetoOpen(string file, string handler = "")
{
    if(handler == "")
    {
        handler = "TEMP";
    }
    return "%"+handler+" = q<"+file+">;";
}

int LetoPingPong()
{
  string Test = LetoScript("print q<PingPong>;");
  if(Test == "PingPong")
  {
      return TRUE;
  }
  return FALSE;
}

string LetoClose(string handler = "")
{
    if(handler == "")
    {
        handler = "TEMP";
    }
    return "close %"+handler+";";
}

string LetoSave(string file, string handler = "")
{
    if(handler == "")
    {
        handler = "TEMP";
    }
    return "%"+handler+" = q?>"+file+"?;";
}

void LetoPCEnter(object oPC)
{
    SetLocalString(oPC, "LetoScript", "");
}

void LetoPCExit(object oPC)
{
    string Script = GetLocalString(oPC, "LetoScript");

    if( Script != "" )
    {
        SetLocalString(oPC, "LetoScript", "");
        LetoScript(Script);
    }
}

string SF_GetBicFileName(object oPC)
{
    string sChar, sBicName;
    string sPCName = GetStringLowerCase(GetName(oPC));
    int i, iNameLength = GetStringLength(sPCName);

    for(i=0; i < iNameLength; i++) {
        sChar = GetSubString(sPCName, i, 1);
        if (TestStringAgainstPattern("(*a|*n|*w|'|-|_)", sChar)) {
            if (sChar != " ") sBicName += sChar;
        }
    }
    return GetStringLeft(sBicName, 15) + ".bic";
}
string SF_GetBicPath(object PC)
{
    string VaultPath = NWN_SERVERVAULT_DIR;
    string Player = GetPCPlayerName(PC);
    string BicPath = VaultPath + Player + "/";
    return LetoScript(
        "print q<" + BicPath + "> + " +
        "FindNewestBic q<" + BicPath + ">;"
    );
}

void DeleteCharacter(object oPC)
{
    if (GetIsObjectValid(oPC))
    {
        string Script = "FileDelete q<" + SF_GetBicPath(oPC) + ">";
        PrintString(Script);
        SetLocalString(oPC, "LetoScript", Script);
        DelayCommand(1.0, BootPC(oPC));
    }
}

string SetSkinColor(int nColor)
{
   return "/Color_Skin = " + IntToString(nColor)+";";
}

string SetSkill(int iSkill, int iModifier, int Set)
{
    if(Set == 0)
    {
      return "/SkillList/["+IntToString(iSkill)+"]/Rank = /SkillList/["+IntToString(iSkill)+"]/Rank+"+IntToString(iModifier)+";" + "/LvlStatList/[0]/SkillList/["+IntToString(iSkill)+"]/Rank = /SkillList/["+IntToString(iSkill)+"]/Rank+"+IntToString(iModifier)+";";
    }
    else
    {
      return "/SkillList/["+IntToString(iSkill)+"]/Rank = " + IntToString(iModifier) + ";" + "/LvlStatList/[0]/SkillList/["+IntToString(iSkill)+"]/Rank = "+IntToString(iModifier)+";";
    }
}

string SetHairColor(int nColor)
{
   return "/Color_Hair = " + IntToString(nColor)+";";
}

string SetSoundSet(int iSoundSetReference)
{
    if(iSoundSetReference == -1)
    {    return ""; }
    return "/SoundSetFile = " + IntToString(iSoundSetReference)+";";
}

string AddFeat(int iFeat = -1)
{
    string sLeto;
    string sEnd;
    if(iFeat < 0) return "";
    if(iFeat > 763 && iFeat < 824)//Greater Ability Feats
        {
        if(iFeat <= 773)//CHA
            {
            sLeto = "/Cha = /Cha + 1;";
            }
        else if(iFeat <= 783)//CON
            {
            sLeto = "/Con = /Con + 1;";
            }
        else if(iFeat <= 793)//DEX
            {
            sLeto = "/Dex = /Dex + 1;";
            }
        else if(iFeat <= 803)//INT
            {
            sLeto = "/Int = /Int + 1;";
            }
        else if(iFeat <= 813)//WIS
            {
            sLeto = "/Wis = /Wis + 1;";
            }
        else // <= 823 STR
            {
            sLeto = "/Str = /Str + 1;";
            }
        }
    else
        {
        sLeto = "";
        }
        sEnd = "add /FeatList/Feat, type => gffWord, value => " + IntToString(iFeat) + ";" +
               "add /LvlStatList/[0]/FeatList/Feat, type => gffWord, value => " + IntToString(iFeat) + ";";
    return sLeto + sEnd;

}

string AdjustAbility(int iAbility, int iModifier)
{
     string sAbility;
     if (iAbility == ABILITY_STRENGTH)          sAbility = "Str";
     else if (iAbility == ABILITY_DEXTERITY)    sAbility = "Dex";
     else if (iAbility == ABILITY_CONSTITUTION) sAbility = "Con";
     else if (iAbility == ABILITY_INTELLIGENCE) sAbility = "Int";
     else if (iAbility == ABILITY_WISDOM)       sAbility = "Wis";
     else if (iAbility == ABILITY_CHARISMA)     sAbility = "Cha";
     else                                       sAbility = "ABILITY ERROR!";
     return "/" + sAbility + " = /" + sAbility + " + " + IntToString(iModifier) + ";";
}

string ModifyFeat(int iFeat, int Remove)
{
    string sScript;
    if(Remove == 0)
    {
        sScript =  "add /FeatList/Feat, type => gffWord, value => " + IntToString(iFeat) + ";" + "add /LvlStatList/[0]/FeatList/Feat, type => gffWord, value => " + IntToString(iFeat) + ";";
    }
    else
    {
       sScript = "replace 'Feat', "+IntToString(iFeat)+", DeleteParent;";
    }
    return sScript;
}

void SetMaxHitPointsSetMax(object oPC)
{
   int LetoSript = GetLocalInt(oPC, "SF_LetoScript");
   if (!LetoSript)
   {
      SetLocalInt(oPC, "MAX_HP", TRUE);
      string Script = "meta dir => '" + NWN_2DA_DIR + "'; $RDD = 0; for(/LvlStatList) { $HD = lookup 'classes', /~/LvlStatClass, 'HitDie'; if(/~/LvlStatClass == 37) { $RDD++; $HD = $RDD < 4  ? $HD : $RDD < 6  ? 8 : $RDD < 11 ? 10 : 12; } /~/LvlStatHitDie = $HD; }";
      ApplyLetoScriptToPC(Script, oPC);
//      SetPersistentInt(oPC, "MAXHPS", GetMaxHitPoints(oPC), 1);
      SetCampaignInt("MAXHPS", GetName(oPC), GetMaxHitPoints(oPC), oPC);
   }
}

string SetMovement(int nRate)
{
    return LetoSet("MovementRate", IntToString(nRate), "byte");
}

/* void MaxHitPointsPCEnter(object oPC)
{
//    int iOld = GetPersistentInt(oPC, "MAXHPS", "pwdata");
    int iOld = GetCampaignInt("MAXHPS", GetName(oPC), oPC);
    if (iOld > 0)
    {
        int iChange = GetMaxHitPoints(oPC) - iOld;
//        object oPF;
        if (iChange)
        {
//            oPF = GetObjectByTag("MAXHITPOINTS_PASS");
            SendMessageToPC(oPC, "You gained " + IntToString(iChange) + " hit points from the Max Hit Points script.");
            DeleteCampaignVariable("MAXHPS", GetName(oPC), oPC);
        }

        else
        {
//            oPF = GetObjectByTag("MAXHITPOINTS_FAIL");
           SendMessageToPC(oPC, "You failed to gain any hit points from the Max Hit Points script.");
           DeleteCampaignVariable("MAXHPS", GetName(oPC), oPC);
        }

//        if (oPF!=OBJECT_INVALID) DelayCommand(3.0f,AssignCommand(oPC, ActionExamine(oPF)));
//            SetPersistentInt(oPC, "MAXHPS", -1, 1, "pwdata"); // FLAG IT DONE
   }
}
*/


//void main(){}

