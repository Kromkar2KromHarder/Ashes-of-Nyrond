#include "gs_inc_time"
#include "nwnx_sql"
#include "nwnx_feedback"
#include "nwnx_util"
#include "nwnx_events"

void main()
{
    //time
    SetLocalInt(OBJECT_SELF, "GS_YEAR", GetCalendarYear());

    // load time from MySQL
    NWNX_SQL_ExecuteQuery("SELECT year, month, day, hour, minute, real_time, epoch_real, epoch_day FROM server_time WHERE id=1");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        int nYear      = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        int nMonth     = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
        int nDay       = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
        int nHour      = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
        int nMinute    = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
        int nRealTime  = StringToInt(NWNX_SQL_ReadDataInActiveRow(5));
        int nEpochReal = StringToInt(NWNX_SQL_ReadDataInActiveRow(6));
        int nEpochDay  = StringToInt(NWNX_SQL_ReadDataInActiveRow(7));

        int nNow = NWNX_Util_GetHighResTimeStamp().seconds;

        // calculate current greyhawk day of year from epoch
        int nDaysSinceEpoch = (nNow - nEpochReal) / 86400;
        int nCurrentDayOfYear = (nEpochDay + nDaysSinceEpoch) % 336;
        nMonth = nCurrentDayOfYear / 28 + 1;
        nDay   = nCurrentDayOfYear % 28 + 1;
        if (nMonth > 12) nMonth = 12;

        // calculate elapsed time of day
        int nElapsed = nNow - nRealTime;
        int nSecondsInCycle = (nNow % 14400);
        nHour   = nSecondsInCycle * 24 / 14400;
        nMinute = (nSecondsInCycle * 24 % 14400) * 60 / 14400;

        SetCalendar(nYear, nMonth, nDay);
        SetTime(nHour, nMinute, 0, 0);
    }
    else
    {
        // first ever run - set epoch to today
        int nNow      = NWNX_Util_GetHighResTimeStamp().seconds;
        int nEpochDay = 127; // May 8 = day 128 of year, Planting 16
        int nMonth    = 4;   // Planting
        int nDay      = 16;
        int nYear     = 400;

        int nSecondsInCycle = nNow % 14400;
        int nHour   = nSecondsInCycle * 24 / 14400;
        int nMinute = (nSecondsInCycle * 24 % 14400) * 60 / 14400;

        NWNX_SQL_ExecuteQuery("INSERT INTO server_time (id, year, month, day, hour, minute, real_time, epoch_real, epoch_day) VALUES (1, " +
            IntToString(nYear) + ", " +
            IntToString(nMonth) + ", " +
            IntToString(nDay) + ", " +
            IntToString(nHour) + ", " +
            IntToString(nMinute) + ", " +
            IntToString(nNow) + ", " +
            IntToString(nNow) + ", " +
            IntToString(nEpochDay) + ")");

        SetCalendar(nYear, nMonth, nDay);
        SetTime(nHour, nMinute, 0, 0);
    }

    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS player_data (bic VARCHAR(64) PRIMARY KEY, area_tag VARCHAR(32), pos_x FLOAT, pos_y FLOAT, pos_z FLOAT, gold INT, rest_meter FLOAT)");
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS explored_areas (bic VARCHAR(64), area_tag VARCHAR(32), PRIMARY KEY (bic, area_tag))");
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS server_time (id INT PRIMARY KEY, year INT, month INT, day INT, hour INT, minute INT, real_time INT, epoch_real INT, epoch_day INT)");
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS player_resources (bic VARCHAR(64), resource_key VARCHAR(64), resource_value INT, PRIMARY KEY (bic, resource_key))");
    NWNX_Feedback_SetFeedbackMessageHidden(NWNX_FEEDBACK_REST_BEGINNING_REST, TRUE);
    NWNX_Feedback_SetFeedbackMessageHidden(NWNX_FEEDBACK_REST_CANCEL_REST, TRUE);

    ExecuteScript("gs_time_advance", OBJECT_SELF);
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_ENTER_AFTER", "gs_after_enter");
    WriteTimestampedLogEntry("DEBUG: Subscribed to NWNX_ON_CLIENT_ENTER_AFTER");
}
