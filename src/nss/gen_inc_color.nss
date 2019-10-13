// Genji Include Color gen_inc_color
// first: 1-4-03

// requires a waypoint called "dm_vault_drop" in a dm only area,
// and genji's coloring book placeable "gen_coloringbook". Which should have been downloaded with this.

// --------------------------------------------------------------[ function prototypes ]

// simple function to use the name of a item holding escape sequences that, though they will not compile,
// they can be interpreted at run time and produce rbg scales between 32 and 255 in increments.
// -- allows 3375 colors to be made.
// for example SendMessageToPC(pc,GetRGB(15,15,1)+ "Help, I'm on fire!") will produce yellow text.
// more examples:
/*
    GetRGB() := WHITE // no parameters, default is white
    GetRGB(15,15,1):= YELLOW
    GetRGB(15,5,1) := ORANGE
    GetRGB(15,1,1) := RED
    GetRGB(7,7,15) := BLUE
    GetRGB(1,15,1) := NEON GREEN
    GetRGB(1,11,1) := GREEN
    GetRGB(9,6,1)  := BROWN
    GetRGB(11,9,11):= LIGHT PURPLE
    GetRGB(12,10,7):= TAN
    GetRGB(8,1,8)  := PURPLE
    GetRGB(13,9,13):= PLUM
    GetRGB(1,7,7)  := TEAL
    GetRGB(1,15,15):= CYAN
    GetRGB(1,1,15) := BRIGHT BLUE
*/
// issues? contact genji@thegenji.com
// special thanks to ADAL-Miko and Rich Dersheimer in the bio forums.

const int CLR_WHITE       =  1;
const int CLR_YELLOW      =  2;
const int CLR_ORANGE      =  3;
const int CLR_RED         =  4;
const int CLR_BLUE        =  5;
const int CLR_NEONGREEN   =  6;
const int CLR_GREEN       =  7;
const int CLR_BROWN       =  8;
const int CLR_LIGHTPURPLE =  9;
const int CLR_TAN         = 10;
const int CLR_PURPLE      = 11;
const int CLR_PLUM        = 12;
const int CLR_AQUA        = 13;
const int CLR_CYAN        = 14;
const int CLR_BRIGHTBLUE  = 15;
const int CLR_TANNER      = 16;
const int CLR_GRAY        = 17;

//Gets the color text for strings. Place before and after strings.
string GetRGBColor(int iColor=CLR_WHITE);

string GetRGB(int red = 15,int green = 15,int blue = 15);



// --------------------------------------------------------------[ function implementations ]
string GetRGB(int red = 15,int green = 15,int blue = 15)
{
    object coloringBook = GetObjectByTag("ColoringBook");
    if (coloringBook == OBJECT_INVALID)
        coloringBook = CreateObject(OBJECT_TYPE_ITEM,"gen_coloring",GetLocation(GetWaypointByTag("dm_vault_drop")));
    string buffer = GetName(coloringBook);
    if(red > 15) red = 15; if(green > 15) green = 15; if(blue > 15) blue = 15;
    return "<c" + GetSubString(buffer, red - 1, 1) + GetSubString(buffer, green - 1, 1) + GetSubString(buffer, blue - 1, 1) +">";
}

////////////////////////


string GetRGBColor(int iColor=CLR_WHITE) {
   switch (iColor) {
      case CLR_YELLOW     : return GetRGB(15,15, 1);
      case CLR_ORANGE     : return GetRGB(15, 5, 1);
      case CLR_RED        : return GetRGB(15, 1, 1);
      case CLR_BLUE       : return GetRGB( 7, 7,15);
      case CLR_NEONGREEN  : return GetRGB( 1,15, 1);
      case CLR_GREEN      : return GetRGB( 1,11, 1);
      case CLR_BROWN      : return GetRGB( 9, 6, 1);
      case CLR_LIGHTPURPLE: return GetRGB(11, 9,11);
      case CLR_TAN        : return GetRGB(12,10, 7);
      case CLR_PURPLE     : return GetRGB( 8, 1, 8);
      case CLR_PLUM       : return GetRGB(13, 9,13);
      case CLR_AQUA       : return GetRGB( 1, 7, 7);
      case CLR_CYAN       : return GetRGB( 1,15,15);
      case CLR_BRIGHTBLUE : return GetRGB( 1, 1,15);
      case CLR_TANNER     : return GetRGB(15,12, 7);
      case CLR_GRAY       : return GetRGB( 6, 6, 6);
   }
   return GetRGB();// no parameters, default is white
}

string RedText(string sText) {
   return GetRGBColor(CLR_RED) + sText + GetRGBColor();
}

string GreenText(string sText) {
   return GetRGBColor(CLR_GREEN) + sText + GetRGBColor();
}

string YellowText(string sText) {
   return GetRGBColor(CLR_YELLOW) + sText + GetRGBColor();
}

