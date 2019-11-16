#include "seed_enc_inc"

void main() {
   if (d6()==1) {
     MakeCreature("trogpet", OBJECT_SELF);
   }
   ExecuteScript("nw_c2_default9", OBJECT_SELF);
}
