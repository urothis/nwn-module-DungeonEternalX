/**
 *  $Id: zdlg_end_normal.nss,v 1.2 2005/01/26 00:43:05 pspeed Exp $
 *
 *  Normal conversation end event script for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "zdlg_include_i"


void main()
{
    //PrintString( "End normal." );
    object oSpeaker = GetPCSpeaker();
    _SendDlgEvent( oSpeaker, DLG_END );
    _CleanupDlg( oSpeaker );
}
