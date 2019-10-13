// Drop in - EffectAppear used on us, IF we are a flying creature.
// Uses the SoU "spellsIsFlying" so is updated with new updates, and makes sure
// it doesn't make things spawn in that shouldn't.

// It also is pretty clever and executes the default On Spawn file after
// the appear animation.

#include "X0_I0_SPELLS"

void main()
{
    // Are we flying?
    if(spellsIsFlying(OBJECT_SELF))
    {
        // Generate effect
        effect eAppear = EffectAppear();

        // Apply it to us instantly.
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eAppear, OBJECT_SELF);
    }
    // Execute the default On Spawn file.
    ExecuteScript("nw_c2_default9", OBJECT_SELF);
}
