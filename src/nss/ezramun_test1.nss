#include "inc_letocommands"
#include "inc_server"

void main()
{
    object oPC = GetLastUsedBy();
    if (GetPCPlayerName(oPC) != "Ezramun") return;
    // testing new DD empowerment, remove this later
    string BicPath = GetVaultDir() + "Ezramun/";
    string BicFile;
    string Script =
            "$RealFile = q<" + BicPath + "> + FindNewestBic q<" + BicPath + ">;" +
            "$EditFile = $RealFile + '.utc';" +
            "FileRename $RealFile, $EditFile;" +
            "%bic = $EditFile or die;" +
            AddSpecialAbility(74, 5, 40) +
            "%bic = '>';" +
            "close %bic;" +
            "FileRename $EditFile, $RealFile;";

    PrintString(Script);
    SetLocalString(oPC, "LetoScript", Script);
    ExportSingleCharacter(oPC);
    DelayCommand(1.0, PopUpDeathGUIPanel(oPC, FALSE, FALSE, FALSE, "You must now relog."));
    //DelayCommand(6.0, ActivatePortal(oPC, LETO_PORTAL_IP_ADDRESS, LETO_PORAL_SERVER_PASSWORD, "", TRUE));
}
