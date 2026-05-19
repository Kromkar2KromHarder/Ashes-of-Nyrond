#include "gs_inc_combat"
#include "gs_inc_event"

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_CONVERSATION));

    object oSpeaker = GetLastSpeaker();

    SetListening(OBJECT_SELF, FALSE);

    switch (GetListenPatternNumber())
    {
    case -1:
        if (! gsCBGetHasAttackTarget())
        {
            ClearAllActions(TRUE);
            BeginConversation();
        }
        break;

    case 10000: //GS_AI_ATTACK_TARGET
        if (! (GetLevelByClass(CLASS_TYPE_COMMONER) ||
               gsCBGetHasAttackTarget()))
        {
            gsCBDetermineAttackTarget(oSpeaker);
        }
        break;

    case 10001: //GS_AI_PVP
        if (! gsCBGetHasAttackTarget())
        {
            object oTarget = GetLocalObject(oSpeaker, "GS_PVP_TARGET");

            if (GetIsObjectValid(oTarget) &&
                ! GetIsEnemy(oTarget))
            {
                gsCBDetermineCombatRound(oSpeaker);
            }
        }
        break;
    }

    SetListening(OBJECT_SELF, TRUE);
}
