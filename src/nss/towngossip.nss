//#include "ginc_wp"
#include "db_inc"

float RandomFloatBetween( float fFloatA, float fFloatB=0.000f )
{
   float fLesserFloat;
   float fGreaterFloat;
   float fDifference;
   float fRandomFloat;
   float fMultiplier = IntToFloat( Random( 32767 ) ) / 32766.f;

   if ( fFloatA <= fFloatB )
   {
      fLesserFloat = fFloatA;
      fGreaterFloat = fFloatB;
   }
   else
   {
      fLesserFloat = fFloatB;
      fGreaterFloat = fFloatA;
   }

   fDifference = fGreaterFloat - fLesserFloat;
   fRandomFloat = ( fDifference * fMultiplier ) + fLesserFloat;

   return ( fRandomFloat );
}

float RandomFloat(float fNum)
{
   float fRet = RandomFloatBetween( fNum );
   return (fRet);
}

int AnimationNeedsWait(int iAnimation)
{
    int iRet = FALSE;
    if ((iAnimation > 100) || (iAnimation == ANIMATION_LOOPING_LISTEN))
        iRet = TRUE;

    return(iRet);
}

void AnimateWithOther(object oOther, float fDurationSeconds=5.0f, int iAnimation=ANIMATION_LOOPING_TALK_NORMAL, int iOtherAnimation=ANIMATION_LOOPING_LISTEN, float fSpeed=1.0f)
{
    ActionPlayAnimation(iAnimation, fSpeed, fDurationSeconds);
    if (AnimationNeedsWait(iAnimation))
        ActionWait(fDurationSeconds);

    AssignCommand(oOther, ActionPlayAnimation(iOtherAnimation, fSpeed, fDurationSeconds));
    if (AnimationNeedsWait(iOtherAnimation))
        AssignCommand(oOther, ActionWait(fDurationSeconds));
}

int RandomTalkAnim()
{
    int nReaction = Random(4) + 1;
    int iAction;
    switch(nReaction)
    {
    case 1:
        iAction = ANIMATION_LOOPING_TALK_PLEADING;
        break;
    case 2:
        iAction = ANIMATION_LOOPING_TALK_FORCEFUL;
        break;
    case 3:
        iAction = ANIMATION_LOOPING_TALK_NORMAL;
        break;
    case 4:
        iAction = ANIMATION_LOOPING_TALK_LAUGHING;
        break;
    }
    return (iAction);
}

void TalkToListener(object oListener, float fDurationSeconds=5.0f, int iTalkerAnimation=ANIMATION_LOOPING_TALK_NORMAL)
{
    AnimateWithOther(oListener, fDurationSeconds, iTalkerAnimation);
}

void ListenToTalker(object oListener, float fDurationSeconds=5.0f, int iTalkerAnimation=ANIMATION_LOOPING_TALK_NORMAL)
{
    AnimateWithOther(oListener, fDurationSeconds, ANIMATION_LOOPING_LISTEN, iTalkerAnimation);
}

int RandomPauseAnim()
{
    int nReaction = Random(6) + 1;
    int iAction;
    switch(nReaction)
    {
    case 1:
        iAction = ANIMATION_LOOPING_PAUSE;
        break;
    case 2:
        iAction = ANIMATION_LOOPING_PAUSE2;
        break;
    case 3:
        iAction = ANIMATION_LOOPING_PAUSE_TIRED;
        break;
    case 4:
        iAction = ANIMATION_LOOPING_PAUSE_DRUNK;
        break;
    case 5:
        iAction = ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD;
        break;
    case 6:
        iAction = ANIMATION_FIREFORGET_PAUSE_BORED;
        break;
    }
    return (iAction);
}

int RandomVictoryAnim()
{
    int nReaction = Random(3) + 1;
    int iAction;
    switch(nReaction)
    {
    case 1:
        iAction = ANIMATION_FIREFORGET_VICTORY1;
        break;
    case 2:
        iAction = ANIMATION_FIREFORGET_VICTORY2;
        break;
    case 3:
        iAction = ANIMATION_FIREFORGET_VICTORY3;
        break;
    }
    return (iAction);
}

int RandomInteractionAnim()
{
    int nReaction = Random(5) + 1;
    int iAction;
    switch(nReaction)
    {
    case 1:
        iAction = RandomPauseAnim();
        break;
    case 2: //cheer
        iAction = RandomVictoryAnim();
        break;
    case 3: //nod
        iAction = ANIMATION_FIREFORGET_READ;
        break;
    case 4: //bow
        iAction = ANIMATION_FIREFORGET_BOW;
        break;
    case 5:
        iAction = RandomTalkAnim();
        break;
    }
    return (iAction);
}
void RandomInteractionExchange(object oOther, int iFreq=3, int iRand=7, int iDelta=3)
{
    if(Random(iFreq) == 0)
    {
        float fDurationSeconds = RandomFloat(IntToFloat(iRand))+ iDelta;
        TalkToListener(oOther, fDurationSeconds, RandomTalkAnim());
        fDurationSeconds = RandomFloat(IntToFloat(iRand))+ iDelta;
        ListenToTalker(oOther, fDurationSeconds, RandomInteractionAnim());
    }
}

void StandardExchange(object oOther, int iAnimation, int iRand=7, int iDelta=3)
{
    float fDurationSeconds = RandomFloat(IntToFloat(iRand))+ iDelta;
    TalkToListener(oOther, fDurationSeconds, iAnimation);
    fDurationSeconds = RandomFloat(IntToFloat(iRand)) + iDelta;
    ListenToTalker(oOther, fDurationSeconds, iAnimation);
    RandomInteractionExchange(oOther);
}


object PickNPCInArea(object oNPC=OBJECT_SELF)
{
   object oPick = OBJECT_INVALID;
   object oArea = GetArea(oNPC);
   object oLast = GetLocalObject(oNPC, "LASTTALK");
   object oLoop = GetFirstObjectInArea(oArea);
   while(GetIsObjectValid(oLoop))
   {
      if (GetObjectType(oLoop)==OBJECT_TYPE_CREATURE && !GetIsPC(oLoop) && oNPC!=oLoop && oNPC!=oLast)
      { // ONLY CREATURES, NOT PC'S, NOT SELF, AND NOT THE LAST GUY I TALKED TO
         if (oPick==OBJECT_INVALID) oPick = oLoop; // ALWAYS SAVE THE FIRST ONE SO WE RETURN SOMETHING
         else if (d4()==1) oPick = oLoop; // THEN PICK A RANDOM ONE IN THE LIST
      }
      oLoop = GetNextObjectInArea(oArea);
    }
    SetLocalObject(oNPC, "LASTTALK", oPick);
    return oPick;
}

void EmbarrassPC(object oNPC)
{
   string sMsg1 = "Yo. What up.";
   string sMsg2;
   string sSQL;
   if (d2()==1) {
      sSQL = "select pker.pl_name, pked.pl_name, ar_name, pp_klevel, pp_plevel from playervsplayer, player as pker, player as pked, area  where pker.pl_plid=pp_kplid and pked.pl_plid=pp_plid and pp_arid=ar_arid and pp_klevel<pp_plevel and pp_added > DATE_ADD(NOW(), INTERVAL -1 DAY) order by pp_added";
      if (d2()==1) sSQL += " desc"; // REVERSE THE SORT FOR SOME RANDOMNESS
     sSQL += " LIMIT 1";
      NWNX_SQL_ExecuteQuery(sSQL);
      if (NWNX_SQL_ReadyToReadNextRow())
      {
         NWNX_SQL_ReadNextRow();
         string sPKer = NWNX_SQL_ReadDataInActiveRow(0);
         string sPKed = NWNX_SQL_ReadDataInActiveRow(1);
         string sArea = NWNX_SQL_ReadDataInActiveRow(2);
         string sKlvl = NWNX_SQL_ReadDataInActiveRow(3);
         string sPlvl = NWNX_SQL_ReadDataInActiveRow(4);
         sMsg1 = "Hey did you hear that " + sPKer + " killed " + sPKed + " in " + sArea + "?";
         sMsg2 = "The funny thing is, " + sPKed + " was level " + sPlvl + " and " + sPKer + " was only level " + sKlvl + "!";
      }
   } else {
      sSQL = "select pl_name, mo_prettyname, ar_name from monstervsplayer, player, area, monster where mp_moid=mo_moid and mp_plid=pl_plid and ar_arid=mp_arid order by mp_added desc limit 1";
      NWNX_SQL_ExecuteQuery(sSQL);
      if (NWNX_SQL_ReadyToReadNextRow())
      {
         NWNX_SQL_ReadNextRow();
         string sPC   = NWNX_SQL_ReadDataInActiveRow(0);
         string sMob  = NWNX_SQL_ReadDataInActiveRow(1);
         string sArea = NWNX_SQL_ReadDataInActiveRow(2);
         sMsg1 = "Ouch! I heard that " + sPC + " was just killed in " + sArea + " by " + sMob + "!";
      }
   }
   ActionSpeakString(sMsg1);
   PlayVoiceChat(VOICE_CHAT_LAUGH);
   StandardExchange(oNPC, ANIMATION_LOOPING_TALK_LAUGHING);
   if (sMsg2!="") ActionSpeakString(sMsg2);
   AssignCommand(oNPC, PlayVoiceChat(VOICE_CHAT_LAUGH));
}

void MaybeSpeakGreeting(object oNPC)
{
   string sName = GetName(oNPC);
   int nGreet = d10();
   if      (nGreet==1) ActionSpeakString("How's it going " + sName  + "?");
   else if (nGreet==2) ActionSpeakString(sName  + ", a word if I may...");
   else if (nGreet==3) ActionSpeakString("Well hello there " + sName + "!");
   else if (nGreet==4) ActionSpeakString("Hey " + sName  + ", mind if I bend your ear...");
   else if (nGreet==5) ActionSpeakString("Yo " + sName  + ", have I got some gossip for you!");
}

void DoADance(object oNPC)
{
   PlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK);
   PlayAnimation(ANIMATION_FIREFORGET_DODGE_SIDE);
   PlayAnimation(ANIMATION_FIREFORGET_SPASM);
}

void MutualGreeting(object oOther, float fDurationSeconds=2.0f)
{
    AnimateWithOther(oOther, fDurationSeconds, ANIMATION_FIREFORGET_GREETING, ANIMATION_FIREFORGET_GREETING);
}

void ActionOrientToObject(object oTarget)
{
    ActionDoCommand(SetFacingPoint(GetPosition(oTarget)));
    ActionWait(0.5f);  // need time to change facing
}

void InitiateConversation(object oOther)
{
    // approach
    object oSelf = OBJECT_SELF;
    ActionMoveToObject(oOther);
    AssignCommand(oOther, ActionMoveToObject(oSelf));
    ActionOrientToObject(oOther);
    AssignCommand(oOther, ActionOrientToObject(oSelf));
}

void TypicalTalk(object oOther, int iRand=7, int iDelta=3)
{
    StandardExchange(oOther, RandomTalkAnim());
    RandomInteractionExchange(oOther);
}

void ChatUpNPC()
{
   ClearAllActions();
   object oNPC = PickNPCInArea();
   MutualGreeting(oNPC); // WAVE HELLO
   InitiateConversation(oNPC); // WALK OVER
   MaybeSpeakGreeting(oNPC); // MAYBE SAY SOMETHING
   TypicalTalk(oNPC); // TALK FOR A BIT
   if (d4()==1) EmbarrassPC(oNPC);
   TypicalTalk(oNPC);
   MutualGreeting(oNPC); // WAVE AGAIN
   if (d20()==1) {
      DelayCommand(40.0, DoADance(oNPC));
      DelayCommand(40.0, DoADance(OBJECT_SELF));
   }
}

void ChatUpPC(object oPC)
{ // SAYS SOMETHING PERSONAL TO THE NEAREST PC
   ClearAllActions();
   MutualGreeting(oPC); // WAVE HELLO
   ActionMoveToObject(oPC);
   string sSQL;
   sSQL = "select pl_name, ar_name, pp_klevel-pp_plevel from playervsplayer, player, area where pl_plid=pp_kplid and pp_arid=ar_arid and pp_added > DATE_ADD(NOW(), INTERVAL -2 DAY) and pp_plid=" + IntToString(dbGetPLID(oPC)) + " order by pp_added desc limit 1";
   NWNX_SQL_ExecuteQuery(sSQL);
   if (NWNX_SQL_ReadyToReadNextRow())
   {
      NWNX_SQL_ReadNextRow();
      string sPKer = NWNX_SQL_ReadDataInActiveRow(0);
      string sArea = NWNX_SQL_ReadDataInActiveRow(1);
      int nDiff = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
      string sFair = " killed";
      string sInterject = " A fair enough fight I guess...";
      if (nDiff>3)
      {
         sFair = " ganked";
         sInterject = " You never had a chance.";
      } else if (nDiff<-3)
      {
         sFair = " spanked";
         sInterject = " Dude, You got pwned!";
      }
      ActionSpeakString("Hey " + GetName(oPC) + ", I heard " + sPKer + sFair + " you in " + sArea + "." + sInterject);
   } else {
      sSQL = "select mo_prettyname, ar_name from monstervsplayer, area, monster where mp_moid=mo_moid and ar_arid=mp_arid and mp_plid=" + IntToString(dbGetPLID(oPC)) + " order by mp_added desc limit 1";
      NWNX_SQL_ExecuteQuery(sSQL);
      if (NWNX_SQL_ReadyToReadNextRow())
      {
         NWNX_SQL_ReadNextRow();
         string sMob  = NWNX_SQL_ReadDataInActiveRow(0);
         string sArea = NWNX_SQL_ReadDataInActiveRow(1);
         string sExtra = "! " + PickOne("Looks like your face took the worst of it.", "At least you have your dignity.", "I'm sure you landed a blow or two.");
         ActionSpeakString("So " + GetName(oPC) + ", I hear you got mangled up pretty bad in " + sArea + " by " + sMob + sExtra);
      }
   }
}

void SendGossipHome()
{
   object oHome = GetObjectByTag("WP_" + GetTag(OBJECT_SELF));
   if (oHome!=OBJECT_INVALID) DelayCommand(10.0, ActionMoveToObject(oHome, (d3()==1)));
}

void TownGossip()
{ // SETS AN NPC TO RANDOMLY WANDER AROUND TOWN TALKING TO OTHER NPC'S
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
   if (oPC!=OBJECT_INVALID)
   { // SOMEONE IS IN THE AREA, SO DO SOME STUFF OTHERWISE JUST SLEEP
      if (!IsInConversation(OBJECT_SELF))
      { // NOT TALKING TO ANYONE, LET'S TAKE A WALK
         if (d3()==1) ChatUpPC(oPC);  // SOMETIMES WE TALK TO PC'S
         else ChatUpNPC();            // OTHER TIMES WE TALK TO OUR NPC BUDDIES
         if (d2()==1) SendGossipHome();
      }
   }
   if (d20()==1) DelayCommand(30.0+d20(3), DoADance(OBJECT_SELF));
   DelayCommand(180.0, TownGossip()); // AFTER 3 MINUTES MOVE ALONG TO NEXT NPC
}

void main()
{
   DelayCommand(60.0, TownGossip());
}
