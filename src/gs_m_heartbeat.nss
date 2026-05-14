#include "gs_inc_encounter"
#include "gs_inc_flag"
#include "gs_inc_time"
#include "gs_inc_xp"
#include "nwnx_sql"
#include "nwnx_util"

void main()
{
    object oPC        = OBJECT_INVALID;
    object oArea      = OBJECT_INVALID;
    object oTarget    = OBJECT_INVALID;
    location lLocation;
    int nPreviousDay  = GetLocalInt(OBJECT_SELF, "GS_DAY");
    int nCurrentDay   = GetCalendarDay();
    int nPreviousHour = GetLocalInt(OBJECT_SELF, "GS_HOUR");
    int nCurrentHour  = GetTimeHour();
    int nRound        = GetLocalInt(OBJECT_SELF, "GS_ROUND") + 1;
    int nTimestamp    = gsTIGetActualTimestamp();

    //per day
    if (nPreviousDay != nCurrentDay)
    {
        SetLocalInt(OBJECT_SELF, "GS_DAY", nCurrentDay);
    }

    //per hour
    if (nPreviousHour != nCurrentHour)
    {
        oPC = GetFirstPC();

        while (GetIsObjectValid(oPC))
        {
            if (! GetIsDM(oPC) &&
                GetLocalInt(oPC, "GS_ENABLED") &&
                ! gsFLGetAreaFlag("OVERRIDE_STATE", oPC))
            {
                if (GetLocalInt(oPC, "GS_ACTIVE"))
                {
                    if (! gsFLGetAreaFlag("OVERRIDE_DEATH", oPC))
                        gsXPApply(oPC, gsPCGetRolePlay(oPC));

                    DeleteLocalInt(oPC, "GS_ACTIVE");
                }
                else
                {
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 3600.0));
                }
            }

            oPC = GetNextPC();
        }

        // save time to MySQL
        int nRealTime = NWNX_Util_GetHighResTimeStamp().seconds;
        NWNX_SQL_ExecuteQuery("INSERT INTO server_time (id, year, month, day, hour, minute, real_time, epoch_real, epoch_day) VALUES (1, " +
            IntToString(GetCalendarYear()) + ", " +
            IntToString(GetCalendarMonth()) + ", " +
            IntToString(GetCalendarDay()) + ", " +
            IntToString(nCurrentHour) + ", " +
            IntToString(GetTimeMinute()) + ", " +
            IntToString(nRealTime) + ", 0, 0" +
            ") ON DUPLICATE KEY UPDATE year=VALUES(year), month=VALUES(month), day=VALUES(day), hour=VALUES(hour), minute=VALUES(minute), real_time=VALUES(real_time)");

        SetCampaignInt("GS_SYSTEM", "TIMESTAMP", nTimestamp);
        SetLocalInt(OBJECT_SELF, "GS_HOUR", nCurrentHour);
    }

    //per 5 rounds
    if (nRound > 4)
    {
        oPC    = GetFirstPC();
        nRound = 0;

        while (GetIsObjectValid(oPC))
        {
            if (! GetIsDM(oPC) &&
                GetLocalInt(oPC, "GS_ENABLED"))
            {
                oArea = GetArea(oPC);

                if (GetIsObjectValid(oArea) &&
                    ! GetLocalInt(oArea, "GS_ENCOUNTER"))
                {
                    gsENSpawnByChance(oArea);
                    SetLocalInt(oArea, "GS_ENCOUNTER", TRUE);
                }
            }

            oPC = GetNextPC();
        }
    }

    SetLocalInt(OBJECT_SELF, "GS_ROUND", nRound);
    SetLocalInt(OBJECT_SELF, "GS_TIMESTAMP", nTimestamp);

    //per round
    oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        oArea = GetArea(oPC);

        if (GetIsObjectValid(oArea))
        {
            SetLocalInt(oArea, "GS_TIMESTAMP", nTimestamp);
            DeleteLocalInt(oArea, "GS_ENCOUNTER");
        }

        //pvp guard check
        if (! gsFLGetAreaFlag("PVP", oPC))
        {
            oTarget = GetAttackTarget(oPC);

            if (GetIsPC(oTarget) &&
                ! GetIsDMPossessed(oTarget) &&
                ! GetIsObjectValid(GetLocalObject(oTarget, "GS_PVP_TARGET")))
            {
                SetLocalObject(oPC, "GS_PVP_TARGET", oTarget);
                AssignCommand(oPC, SpeakString("GS_AI_PVP", TALKVOLUME_SILENT_TALK));
            }
            else if (GetIsObjectValid(GetLocalObject(oPC, "GS_PVP_TARGET")))
            {
                DelayCommand(4.0, DeleteLocalObject(oPC, "GS_PVP_TARGET"));
            }
        }

        //activity
        lLocation = GetLocation(oPC);

        if (GetLocalLocation(oPC, "GS_LOCATION") != lLocation)
        {
            SetLocalLocation(oPC, "GS_LOCATION", lLocation);
            SetLocalInt(oPC, "GS_ACTIVE", TRUE);
        }

        oPC = GetNextPC();
    }
}
