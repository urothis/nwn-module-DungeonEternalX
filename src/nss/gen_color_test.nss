
#include "gen_inc_color"
void main()
{
    // examples sent to pc
    SendMessageToPC(GetLastUsedBy(),GetRGB()        + "WHITE ");
    SendMessageToPC(GetLastUsedBy(),GetRGB(15,15,1) + "YELLOW");
    SendMessageToPC(GetLastUsedBy(),GetRGB(15,5,1)  + "ORANGE");
    SendMessageToPC(GetLastUsedBy(),GetRGB(15,1,1)  + "RED" );
    SendMessageToPC(GetLastUsedBy(),GetRGB(7,7,15)  + "BLUE" );
    SendMessageToPC(GetLastUsedBy(),GetRGB(1,15,1)  + "NEON GREEN" );
    SendMessageToPC(GetLastUsedBy(),GetRGB(1,11,1)  + "GREEN" );
    SendMessageToPC(GetLastUsedBy(),GetRGB(9,6,1)   + "BROWN" );
    SendMessageToPC(GetLastUsedBy(),GetRGB(11,9,11) + "LIGHT PURPLE");
    SendMessageToPC(GetLastUsedBy(),GetRGB(12,10,7) + "TAN");
    SendMessageToPC(GetLastUsedBy(),GetRGB(8,1,8)   + "PURPLE");
    SendMessageToPC(GetLastUsedBy(),GetRGB(13,9,13) + "PLUM");
    SendMessageToPC(GetLastUsedBy(),GetRGB(1,7,7)   + "TEAL");
    SendMessageToPC(GetLastUsedBy(),GetRGB(1,15,15) + "CYAN");
    SendMessageToPC(GetLastUsedBy(),GetRGB(1,1,15)  + "BRIGHT BLUE");
}
