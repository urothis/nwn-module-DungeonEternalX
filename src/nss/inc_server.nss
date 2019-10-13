const string PORTAL_IP_1   = "DungeonEternalX.com:5121";
const string PORTAL_IP_2   = "DungeonEternalX.com:5121";

const string NWN_VAULT_DIR  = "C:/NWNServer/servervault";
const string NWN_SOURCE_DIR = "C:/NWNServer/source";
const string NWN_ROOT_DIR = "C:/NWNServer/";

const string WIN_PORTAL_IP_1   = "DungeonEternalX.com:5121"; //Ness' IP
const string WIN_PORTAL_IP_2   = "DungeonEternalX.com:5121";

const string WIN_NWN_VAULT_DIR  = "C:/NWNServer/servervault/";
const string WIN_NWN_SOURCE_DIR = "C:/NWNServer/source";
const string WIN_NWN_ROOT_DIR = "C:/NWNServer/";

const string SERVER_TIME_LEFT = "SERVER_TIME_LEFT";


int GetServerNumber() {
   return GetLocalInt(GetModule(), "SERVER");
}
string GetServerIP() {
   if (GetLocalInt(GetModule(), "WINDOWS")) {
      return WIN_PORTAL_IP_1;
   }
   if (GetServerNumber()==1) return PORTAL_IP_1;
   return PORTAL_IP_2;
}
string GetOtherServerIP() {
   if (GetLocalInt(GetModule(), "WINDOWS")) {
      return WIN_PORTAL_IP_1;
   }
   if (GetServerNumber()==2) return PORTAL_IP_1;
   return PORTAL_IP_2;
}

string GetRootDir() {
   if (GetLocalInt(GetModule(), "WINDOWS")) {
      return WIN_NWN_ROOT_DIR;
   }
   return NWN_ROOT_DIR;
}

string GetVaultDir() {
   if (GetLocalInt(GetModule(), "WINDOWS")) {
      return WIN_NWN_VAULT_DIR;
   }
   return NWN_VAULT_DIR;
}

string GetSourceDir() {
   if (GetLocalInt(GetModule(), "WINDOWS")) {
      return WIN_NWN_SOURCE_DIR;
   }
   return  NWN_SOURCE_DIR;
}

//void main(){}
