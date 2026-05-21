#include "nwnx_sql"
#include "nwnx_creature"
#include "nwnx_player"

void gsSaveResources(object oPC)
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
            int nRemaining = NWNX_Creature_GetFeatRemainingUses(oPC, nFeat);
            NWNX_SQL_ExecuteQuery(
                "INSERT INTO player_resources (bic, resource_key, resource_value) VALUES ('" +
                sBic + "', 'FEAT_" + IntToString(nFeat) + "', " + IntToString(nRemaining) +
                ") ON DUPLICATE KEY UPDATE resource_value=VALUES(resource_value)");
        }
    }
}

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
                NWNX_Creature_SetFeatRemainingUses(oPC, nFeat, nRemaining);
            }
        }
    }
}