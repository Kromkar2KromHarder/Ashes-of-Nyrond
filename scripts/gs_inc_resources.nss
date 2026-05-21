#include "nwnx_sql"
#include "nwnx_creature"
#include "nwnx_player"

void gsRestoreResources(object oPC)
{
    string sBic = NWNX_Player_GetBicFileName(oPC);

    int nFeatCount = NWNX_Creature_GetFeatCount(oPC);
    int i;
    for (i = 0; i < nFeatCount; i++)
    {
        int nFeat  = NWNX_Creature_GetFeatByIndex(oPC, i);
        int nTotal = NWNX_Creature_GetFeatTotalUses(oPC, nFeat);
        if (nTotal > 0)
        {
            string sKey = "FEAT_" + IntToString(nFeat);
            NWNX_SQL_ExecuteQuery(
                "SELECT resource_value FROM player_resources WHERE bic='" +
                sBic + "' AND resource_key='" + sKey + "'");
            if (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                int nRemaining = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
                WriteTimestampedLogEntry("DEBUG: Setting feat " + IntToString(nFeat) + " to " + IntToString(nRemaining) + " for " + GetName(oPC));
                NWNX_Creature_SetFeatRemainingUses(oPC, nFeat, nRemaining);
            }
        }
    }
}