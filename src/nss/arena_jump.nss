void main() {
   object oUser = GetLastUsedBy();
   string sTag = GetTag(OBJECT_SELF);
   object oLocator = GetObjectByTag(sTag + "_WP");
   AssignCommand(oUser, JumpToObject(oLocator));
}
