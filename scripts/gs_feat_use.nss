#include "nwnx_events"
#include "nwnx_creature"
#include "nwnx_player"
#include "nwnx_sql"

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;

    int nFeat = StringToInt(NWNX_Events_GetEventData("FEAT_ID"));
    int nTotal = NWNX_Creature_GetFeatTotalUses(oPC, nFeat);
    if (nTotal <= 0) return;

    int nRemaining = NWNX_Creature_GetFeatRemainingUses(oPC, nFeat);
    string sBic = NWNX_Player_GetBicFileName(oPC);

    NWNX_SQL_ExecuteQuery(
        "INSERT INTO player_resources (bic, resource_key, resource_value) VALUES ('" +
        sBic + "', 'FEAT_" + IntToString(nFeat) + "', " + IntToString(nRemaining) +
        ") ON DUPLICATE KEY UPDATE resource_value=VALUES(resource_value)");
}