#include "nw_i0_generic"

void main()
{
object oSelf = OBJECT_SELF;
int MaxHP = GetMaxHitPoints(oSelf);
float castDelay = 2.0;

if(GetCurrentHitPoints(oSelf)== MaxHP &&
!GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oSelf))
{
ActionCastSpellAtObject(SPELL_GREATER_SPELL_MANTLE, oSelf);
DelayCommand(castDelay, ClearActions());
}
}
