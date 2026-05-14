#include "gs_inc_common"
#include "gs_inc_state"
#include "gs_inc_text"
#include "nwnx_creature"
#include "nwnx_player"
#include "nwnx_util"

void gsRestTick(object oPC, int nTick)
{
    object oCampfire = GetNearestObjectByTag("GS_CAMPFIRE", oPC);
    if (! GetIsObjectValid(oCampfire) || GetDistanceBetween(oPC, oCampfire) > 10.0)
    {
        DeleteLocalInt(oPC, "GS_RESTING");
        NWNX_Player_StopGuiTimingBar(oPC);
        FloatingTextStringOnCreature("You have moved too far from the campfire. Rest cancelled.", oPC, FALSE);
        return;
    }

    if (nTick >= 20)
    {
        DeleteLocalInt(oPC, "GS_RESTING");
        SetLocalInt(oPC, "GS_LAST_REST", NWNX_Util_GetHighResTimeStamp().seconds);
        SetLocalInt(oPC, "GS_REST_COMPLETE", TRUE);
        NWNX_Player_SetRestDuration(oPC, 10);
        NWNX_Player_SetRestAnimation(oPC, 0);
        AssignCommand(oPC, ActionRest());
        NWNX_Creature_RestoreFeats(oPC);
        NWNX_Creature_RestoreSpecialAbilities(oPC);
        NWNX_Creature_RestoreItems(oPC);
        FloatingTextStringOnCreature("You feel well rested.", oPC, FALSE);
        return;
    }

    DelayCommand(6.0, gsRestTick(oPC, nTick + 1));
}
//----------------------------------------------------------------
void main()
{
    object oRested = GetLastPCRested();

    switch (GetLastRestEventType())
    {
    case REST_EVENTTYPE_REST_STARTED:
    {
        if (GetLocalInt(oRested, "GS_REST_COMPLETE"))
        {
            DeleteLocalInt(oRested, "GS_REST_COMPLETE");
            break;
        }

        object oCampfire = GetNearestObjectByTag("GS_CAMPFIRE", oRested);
        if (! GetIsObjectValid(oCampfire) || GetDistanceBetween(oRested, oCampfire) > 10.0)
        {
            FloatingTextStringOnCreature("You must be near a campfire to rest.", oRested, FALSE);
            SetLocalInt(oRested, "GS_SUPPRESS_CANCEL", TRUE);
            AssignCommand(oRested, ClearAllActions());
            break;
        }

        int nLastRest = GetLocalInt(oRested, "GS_LAST_REST");
        int nNow = NWNX_Util_GetHighResTimeStamp().seconds;
        if (nLastRest > 0 && nNow - nLastRest < 1200)
        {
            int nRemaining = (1200 - (nNow - nLastRest)) / 60;
            FloatingTextStringOnCreature("You must wait approximately " + IntToString(nRemaining) + " minutes before resting again.", oRested, FALSE);
            SetLocalInt(oRested, "GS_SUPPRESS_CANCEL", TRUE);
            AssignCommand(oRested, ClearAllActions());
            break;
        }

        if (GetLocalInt(oRested, "GS_RESTING"))
        {
            FloatingTextStringOnCreature("You are already resting.", oRested, FALSE);
            SetLocalInt(oRested, "GS_SUPPRESS_CANCEL", TRUE);
            AssignCommand(oRested, ClearAllActions());
            break;
        }

        SetLocalInt(oRested, "GS_SUPPRESS_CANCEL", TRUE);
        AssignCommand(oRested, ClearAllActions());
        SetLocalInt(oRested, "GS_RESTING", TRUE);
        FloatingTextStringOnCreature("You begin resting.", oRested, FALSE);
        DelayCommand(0.5, NWNX_Player_StartGuiTimingBar(oRested, 120.0, "", NWNX_PLAYER_TIMING_BAR_REST));
        DelayCommand(6.0, gsRestTick(oRested, 1));
        break;
    }

    case REST_EVENTTYPE_REST_CANCELLED:
        if (GetLocalInt(oRested, "GS_SUPPRESS_CANCEL"))
            DeleteLocalInt(oRested, "GS_SUPPRESS_CANCEL");
        else
            SendMessageToPC(oRested, "Cancelled Rest.");
        break;

    case REST_EVENTTYPE_REST_FINISHED:
        break;
    }
}
