//void main(){}
//::///////////////////////////////////////////////
//:: String Tokenizer v1.2
//:: tokenizer_inc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

   This small library of functions helps you with all kind of data management
   and data consolidation. Be it dynamic arrays, multidimensional arrays or stuff like
   linked lists..

   It uses string-tokens to store data. with the use of data conversion (IntToString etc.),
   any kind of systematic data storage is now very easy. it also helps you to establish a standardized
   way to manipulate data throughout all your scripts.

   with the use of a simple caching algorithm, data access is nearly as fast as
   a normal GetLocal.. function call.

   if you need more imformation, check the bioware forums. tokenizer functions
   are common in most modern compilers, why not using them with the aurora engine ?
   it's key/value based data access is ideally suited for such a system.

   history:
   --------

   v1.2
     - added DeleteStringFromCache(string sTargetString)
         this function gives you much better control over the memory consumption
         of the cache. you can now clear the cache systematically. This should
         help scripters that take use of dynamically created tokenstrings. those
         strings are often not needed throughout the whole module lifespan.
         you can now delete them with a simple call e.g.
           DeleteStringFromCache("EXAMPLE|TOKEN|STRING|THAT|GETS|WIPED|FROM|THE|CACHE");
         you can still wipe out the whole cache with
           DestroyObject(GetTokenCache());

     - some overall speed optimizations (simplified cache)

     - minor cosmetic changes

   v1.1

     - added ReplaceTokenInString
        this function was incorporated on request of the nwn board users.
        it does NOT take use of the cache, so don't use it too heavily.

     - added GetTokenCache()
        you can retrieve the cache object with this command and delete
        it with DestroyObject if you want. it will then auto-create a new
        one if you continue to use the tokenizer.. don't delete it too often
        because it would slow the tokenizer down tremendously.

     - caching does not use the GetModule() object any longer. it auto-creates
       its own special cache object.

     - minor speed optimizations

   v1.0 initial release

*/

//:://////////////////////////////////////////////
//:: Created By:   Knat
//:: Created On:   July 02
//:: Last Change:  February 03
//:://////////////////////////////////////////////

// Declarations
// Tokenizer functions: allround functions for string based arrays/memory-management

// Add delimited Token to String
string AddTokenToString(string sToken, string sTargetString, string Delimiter = "|");
// Delete delimited Token from String
string DeleteTokenFromString(string sToken, string sTargetString, string sDelimiter = "|");
// Get specific Token from String
string GetTokenFromString(int nTokenNumber,string sTargetString, string sDelimiter = "|");
// Get number of Tokens from String
int GetTokenCount(string sTargetString,string sDelimiter = "|");
// Get Token position from String
int GetTokenPosition(string sToken, string sTargetString, string sDelimiter ="|");
// Checks if Token is present
int GetIsTokenInString(string sToken, string sTargetString, string sDelimiter ="|");
// Replace Token in String
string ReplaceTokenInString(string sToken, string sTargetString, string sNewToken, string sDelimiter = "|");
// Returns cache object
object GetTokenCache();
// Delete Tokenstring Index from cache (frees up memory)
void DeleteStringFromTokenCache(string sTargetString);

// auto-create cache if needed
object oCache = GetTokenCache();

/*
----------------------------------------------------------------------------

----------------------------------------------------------------------------
*/

// retrieve cache object
// auto create if non-existant
object GetTokenCache()
{ // ezramun, created in SYSTEM AREA and LocalSet at module load
  /*if(GetLocalObject(GetModule(),"#TOKENIZER_CACHE#") == OBJECT_INVALID)
  {
    // retrieve start area
    object oArea = GetAreaFromLocation(GetStartingLocation());
    // create cache vector ( bottom-left corner )
    vector vCacheVector = Vector(1.0f, 1.0f, 1.0f);
    // create cache location
    location lCacheLocation = Location(oArea, vCacheVector, 1.0f);
    // create invisible object
    object oCache = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lCacheLocation);
    // use it as the cache container
    SetLocalObject(GetModule(),"#TOKENIZER_CACHE#",oCache);
  }*/
  return GetLocalObject(GetModule(),"#TOKENIZER_CACHE#");
}

// auto caching function
// translates tokenstring into separate variables for fastest possible access.
void BuildCache(string sTargetString, string sDelimiter = "|")
{
  string s = sTargetString;
  if(s == "") return;

  int c = 0;
  int pos = 0;
  string sToken;

  while(pos != -1)
  {
    c++;
    pos = FindSubString(s,sDelimiter);
    if(pos == -1) // last token ?
    {
      SetLocalInt(oCache,"#C#"+sTargetString+s, c);
      SetLocalString(oCache,"#C#"+sTargetString+IntToString(c),s);
      SetLocalInt(oCache,"#C#"+sTargetString,c);
      return;
    }
    sToken = GetStringLeft(s,pos);
    SetLocalInt(oCache,"#C#"+sTargetString+sToken, c);
    SetLocalString(oCache,"#C#"+sTargetString+IntToString(c),sToken);
    s = GetStringRight(s,GetStringLength(s)-(pos+1)); // cut off leading token+delimiter
  }
}

// delete a tokenstring (e.g. "A|B|C|D|E") from the cache
// this will completely clean up memory for that specific string
// use this in conjunction with dynamic tokenstrings for better
// memory control.
void DeleteStringFromTokenCache(string sTargetString)
{
  if(GetLocalInt(oCache,"#C#"+sTargetString) == 0) return;

  int i, nSize = GetLocalInt(oCache,"#C#"+sTargetString);
  string sToken;

  for(i=1;i<=nSize;i++)
  {
    sToken = GetLocalString(oCache,"#C#"+sTargetString+IntToString(i));
    DeleteLocalInt(oCache,"#C#"+sTargetString+sToken);
    DeleteLocalString(oCache,"#C#"+sTargetString+IntToString(i));
  }
  DeleteLocalInt(oCache,"#C#"+sTargetString);
}

string AddTokenToString(string sToken, string sTargetString, string sDelimiter = "|")
{
  return (sTargetString != "") ? sTargetString + sDelimiter + sToken : sToken;
}

string DeleteTokenFromString(string sToken, string sTargetString, string sDelimiter = "|")
{
  string s;
  int nTokenPos = FindSubString(sDelimiter+sTargetString+sDelimiter,sDelimiter+sToken+sDelimiter);
  if(nTokenPos >= 0) // Token Found
  {
    s = GetStringLeft(sTargetString, nTokenPos-1) + GetStringRight(sTargetString, GetStringLength(sTargetString) - (nTokenPos + GetStringLength(sToken)));
    if(GetStringLeft(s,1) == sDelimiter) s = GetStringRight(s,GetStringLength(s)-1); // cut additional Delimiter if first token got deleted
    return s;
  }
  else
    return sTargetString; // Token not found
}

string ReplaceTokenInString(string sToken, string sTargetString, string sNewToken, string sDelimiter = "|")
{
    string sLeft, sRight;
    int nTokenPos = FindSubString(sDelimiter+sTargetString+sDelimiter, sDelimiter+sToken+sDelimiter);
    if (nTokenPos >= 0) // Token found
    {
      sLeft = GetStringLeft(sTargetString, nTokenPos);
      sRight = GetStringRight(sTargetString, GetStringLength(sTargetString) - ( nTokenPos + GetStringLength(sToken) ) );
      return sLeft + sNewToken + sRight;
    }
    else
      return sTargetString;
}

string GetTokenFromString(int nTokenNumber,string sTargetString, string sDelimiter = "|")
{
  // tokenstring not cached ?
  if(GetLocalInt(oCache,"#C#"+sTargetString) == 0) BuildCache(sTargetString, sDelimiter);
  return GetLocalString(oCache,"#C#"+sTargetString+IntToString(nTokenNumber));
}

int GetTokenCount(string sTargetString,string sDelimiter = "|")
{
  // tokenstring not cached ?
  if(GetLocalInt(oCache,"#C#"+sTargetString) == 0) BuildCache(sTargetString, sDelimiter);
  return GetLocalInt(oCache,"#C#"+sTargetString);
}

int GetTokenPosition(string sToken, string sTargetString, string sDelimiter ="|")
{
  // tokenstring not cached ?
  if(GetLocalInt(oCache,"#C#"+sTargetString) == 0) BuildCache(sTargetString, sDelimiter);
  // get token from cache
  return GetLocalInt(oCache,"#C#"+sTargetString+sToken);
}

int GetIsTokenInString(string sToken, string sTargetString, string sDelimiter ="|")
{
  return (FindSubString(sDelimiter+sTargetString+sDelimiter,sDelimiter+sToken+sDelimiter) >= 0 ) ? TRUE : FALSE;
}

/*
CODE: Advanced Data Storage

i have created a set of functions which provide advanced data storage options.
you can create dynamic arrays, multi dimensional arrays and lots of other
storage mechanisms with this small and efficient package.

usage is very easy and even a newbie scripter should be able to understand them. (but you
need to grasp the basic principle behind it)

the idea is to use a string tokenizer. many developers may already know the power
of such a tokenizer and its multitude of possible fields of applications.

any modern language has a tokenizer class and the same is now true for the aurora
script engine.

to make it usable even within the spare processing time of a single command-stack,
i wrapped an auto caching algorithm around the tokenizer to speed it up tremendously.
if your scripts produce TMIs, then you should take a deeper look at this stuff here.

After a tokenstring is cached, TMIs are practically not an issue any longer, because
token access is then nearly as fast as a GetLocal call.

let me go into more detail, here is the list of functions provided by the package:
*/

// Add Token to a String
// string AddTokenToString(string sToken, string sTargetString, string Delimiter = "|");

// Delete Token from a String
// string DeleteTokenFromString(string sToken, string sTargetString, string sDelimiter = "|");

// Get specific Token from String
// string GetTokenFromString(int nTokenNumber,string sTargetString, string sDelimiter = "|");

// Get number of Tokens from String
// int GetTokenCount(string sTargetString,string sDelimiter = "|");

// Get Token position from string
// int GetTokenPosition(string sToken, string sTargetString, string sDelimiter ="|");

// Checks if Token is present, returns TRUE or FALSE
// int GetIsTokenInString(string sToken, string sTargetString, string sDelimiter ="|");

/*
i think some examples will be best suited to explain the power behind those functions:

lets say you want to store some blueprint refs to access them later on in a fast and
flexible way. all you need to do is to build a string token containing those refnames:

string sRefToken = "zombie|ghoul|panther|bear|skeleton"

the character | is called delimiter and it separates the tokens.

now let's access those tokens:
string sRef = GetTokenFromString(3,sRefToken);

this will return "panther" for example.

adding a new token to this string is very easy (dynamic array):
sRefToken = AddTokenToString("zombiemage",sRefToken);

sRefToken now contains: "zombie|ghoul|panther|bear|skeleton|zombiemage"

deleting works the same way:
sRefToken = DeleteTokenFromString("ghoul",sRefToken);

sRefToken now contains: "zombie|panther|bear|skeleton|zombiemage"

Let's switch to a more complex application: multi-dimensional arrays

example tokenstring: "bob_2|edgar_4|william_1|oscar_9"

the first dimension here is delimited with the | character (default delimiter),
the second dimension is delimited with the _ (underscore) character. in this example
the number behind the name represents the number of logins for a player.
now let's retreive all player names and their number of logins:


  #include "tokenizer_inc"

  void main()
  {

    string sPlayers = "bob_2|edgar_4|william_1|oscar_9"; // contains the whole array
    string sPlayerToken; // single 2nd dimension token

    string sPlayerName;  // playername
    int nLogins;  // number of logins
    int i;

    // cycle through the first dimension
    for(i=1;i<=GetTokenCount(sPlayers);i++)
    {
      sPlayerToken = GetTokenFromString(i,sPlayers);

      // we need to override the default delimiter to access the second dimension (which uses underscore as the delimiter)
      sPlayerName = GetTokenFromString(1,sPlayerToken,"_");
      nLogins = StringToInt(GetTokenFromString(2,sPlayerToken,"_"));

      // more code to display or manipulate the extracted data
    }
  }


this small function will iterate through the first dimension, then it accesses
the second dimension with underscore as the delimiter.

here is a semantic description:

i=1 sPlayerToken = "bob_2"
       sName   = "bob"
       nLogins = 2;

i=2 sPlayerToken = edgar_4
       sName   = "edgar"
       nLogins = 4;

i=3 sPlayerToken = william_1
       sName   = "william"
       nLogins = 1;

i=4 sPlayerToken = oscar_9
       sName   = "oscar"
       nLogins = 9;

voila: a multi dimensional, dynamic sized array with cached access !!

i hope you can see how flexible those functions are because i'm not a good
writer (and english is not my native language).

if you plan to develop any kind of complex script stuff, i urge you to use
these functions. they are real fast because of the caching algorithm behind it.
(you trade memory for speed here, but it should not be an issue compared to other
resources within your module which take up a lot more memory).


Knat
*/

