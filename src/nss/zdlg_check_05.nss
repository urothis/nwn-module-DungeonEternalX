/**
 *  $Id: zdlg_check_05.nss,v 1.2 2005/01/26 00:43:01 pspeed Exp $
 *
 *  Entry conditional check for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "zdlg_include_i"

const int ENTRY_NUM = 5;

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    return( _SetupDlgResponse( ENTRY_NUM - 1, oSpeaker ) );
}
