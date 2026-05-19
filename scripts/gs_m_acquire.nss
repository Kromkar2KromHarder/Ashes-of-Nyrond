#include "gs_inc_text"

void main()
{
    object oAcquiredBy   = GetModuleItemAcquiredBy();
    object oAcquired     = GetModuleItemAcquired();
    string sTag          = GetTag(oAcquired);

    if (sTag == "GS_BLADEORB")
    {
        if (GetStolenFlag(oAcquired))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_IMP_DISEASE_S),
                                oAcquiredBy);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                EffectAbilityDecrease(ABILITY_CONSTITUTION, d6(1)),
                                oAcquiredBy);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                EffectAbilityDecrease(ABILITY_DEXTERITY, d6(1)),
                                oAcquiredBy);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                EffectAbilityDecrease(ABILITY_STRENGTH, d6(1)),
                                oAcquiredBy);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                EffectLinkEffects(EffectLinkEffects(EffectCutsceneParalyze(),
                                                                    EffectVisualEffect(VFX_DUR_PARALYZED)),
                                                  EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE)),
                                oAcquiredBy,
                                RoundsToSeconds(10));

            DestroyObject(oAcquired);
        }
        return;
    }

    if (sTag == "GS_FX_gs_placeable181") //voidstone
    {
        if (! FortitudeSave(oAcquiredBy, 25))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectLinkEffects(EffectVisualEffect(VFX_IMP_DEATH),
                                                  EffectDeath()),
                                oAcquiredBy);
            SendMessageToPC(oAcquiredBy, GS_T_16777418);
        }
        return;
    }
}
