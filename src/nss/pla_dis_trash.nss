#include "dmg_stones_inc"

void main()
{
    object oTrash = GetInventoryDisturbItem();
    object oPC = GetLastDisturbed();
    string sTag = GetTag(oTrash);
    DestroyObject(oTrash);
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SMOKE_PUFF ), OBJECT_SELF );

    string sTag5 = GetStringLeft(sTag, 5);
    string sTag8 = GetStringLeft(sTag, 8);

    if (sTag8 == "EPICITEM" || sTag8 == "EPICCRAF")
    {
        NWNX_SQL_ExecuteQuery("update epic_item set ei_status='trashed' where ei_id=" + GetLocalString(oTrash, "ID"));
    }
    else if (sTag5 == "DMGS_")
    {
        DMGS_UpdateStoneDB(oTrash, oTrash);
    }
}
