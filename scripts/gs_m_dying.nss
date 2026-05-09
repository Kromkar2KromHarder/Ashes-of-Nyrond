#include "gs_inc_common"
#include "gs_inc_effect"
#include "gs_inc_flag"
#include "gs_inc_text"

const string GS_TEMPLATE_BLOOD = "plc_bloodstain";

void gsDying(int nHeal = FALSE)
{
    int nHitPoints = GetCurrentHitPoints();

    if (nHitPoints > 0)
    {
        SpeakString("GS_AI_ATTACK_TARGET", TALKVOLUME_SILENT_TALK);
        return;
    }

    if (nHitPoints > -10)
    {
        effect eEffect;

        if (! nHeal && Random(100) >= 90)
        {
            nHeal = TRUE;
            FloatingTextStringOnCreature(GS_T_16777324, OBJECT_SELF, FALSE);
        }

        if (nHeal)
        {
            eEffect = EffectHeal(1);
        }
        else
        {
            eEffect = EffectDamage(1);

            switch (Random(4))
            {
            case 0: PlayVoiceChat(VOICE_CHAT_PAIN1);  break;
            case 1: PlayVoiceChat(VOICE_CHAT_PAIN2);  break;
            case 2: PlayVoiceChat(VOICE_CHAT_PAIN3);  break;
            case 3: PlayVoiceChat(VOICE_CHAT_HEALME); break;
            }
        }

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, OBJECT_SELF);

        DelayCommand(6.0, gsDying(nHeal));
    }
}
//----------------------------------------------------------------
void main()
{
    object oDying = GetLastPlayerDying();

    if (gsFLGetAreaFlag("PVP", oDying))
    {
        gsCMSetHitPoints(1, oDying);
        return;
    }

    AssignCommand(oDying, gsFXBleed());
    AssignCommand(oDying, PlayVoiceChat(VOICE_CHAT_NEARDEATH));

    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_BLOOD, GetLocation(oDying));

    if (GetIsPossessedFamiliar(oDying))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oDying);
    }
    else
    {
        AssignCommand(oDying, DelayCommand(6.0, gsDying()));
    }
}
