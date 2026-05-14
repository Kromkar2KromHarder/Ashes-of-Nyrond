#include "x2_inc_spellhook"

void main()
{
    if (! X2PreSpellCastCode()) return;

    object oTarget = GetSpellTargetObject();

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESURRECTION, FALSE));

    if (GetIsDead(oTarget))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectResurrection(),
                            oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectHeal(GetMaxHitPoints(oTarget) + 10),
                            oTarget);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                              EffectVisualEffect(VFX_IMP_RAISE_DEAD),
                              GetLocation(oTarget));
    }
}

