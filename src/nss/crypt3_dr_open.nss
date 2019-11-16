void main() {
   object oCryptDoor = GetObjectByTag("CRYPT3_GATE");
   if (!GetIsOpen(oCryptDoor)) {
      ActionOpenDoor(oCryptDoor);
      PlaySound("as_dr_metlmedop2");
   } else {
      PlaySound("as_dr_locked1");
   }
}
