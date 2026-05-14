#include "x2_inc_spellhook"

void gsTimestop()
{
    object oObject   = GetFirstObjectInArea();
    effect eEffect   = ExtraordinaryEffect(EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION),
                                                             EffectCutsceneParalyze()));
    int nCommandable = FALSE;

    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE &&
            oObject != OBJECT_SELF)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oObject, 9.0);
        }

        oObject = GetNextObjectInArea();
    }
}
//----------------------------------------------------------------
void main()
{
    if (! X2PreSpellCastCode()) return;

    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                          EffectVisualEffect(VFX_FNF_TIME_STOP),
                          GetLocation(OBJECT_SELF));

    DelayCommand(0.75, gsTimestop());
}

