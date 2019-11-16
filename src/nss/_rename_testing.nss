/*
On logout if dead
string sOrigLastName = NWNX_Creature_GetOriginalName(oPC, TRUE);
SaveOriginalLastName(oPC, sOrigLastName); // your persistent function
NWNX_Creature_SetOriginalName(oPC, sOrigLastName + " <dead>", TRUE);


Player logs back in on_client_enter:
string sOrigLastName = RetrieveOriginalLastName(oPC); //your persistent function
NWNX_Creature_SetOriginalName(oPC, sOrigLastName, TRUE);
NWNX_Rename_SetPCNameOverride(oPC, GetName(oPC, TRUE));
NWNX_Rename_ClearPCNameOverride(oPC);         */
