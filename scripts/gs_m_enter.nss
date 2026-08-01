#include "nwnx_sql"
#include "nwnx_creature"
#include "nwnx_player"
#include "gs_inc_state"
#include "gs_inc_common"
#include "gs_inc_text"
void main()
{
    object oEntering   = GetEnteringObject();
    if (GetIsDM(oEntering)) return;
    //check if cd key is banned
    object oBanishment = GetLocalObject(OBJECT_SELF, "GS_BANISHMENT");
    if (GetIsObjectValid(oBanishment))
    {
        string sBanCDKey = GetPCPublicCDKey(oEntering);
        if (GetIsObjectValid(GetItemPossessedBy(oBanishment, "GS_BA_" + sBanCDKey)))
        {
            SendMessageToAllDMs(
                gsCMReplaceString(
                    GS_T_16777425,
                    GetName(oEntering),
                    GetPCPlayerName(oEntering),
                    sBanCDKey));
            BootPC(oEntering);
            return;
        }
    }
    AddJournalQuestEntry("GS_DIARY_001", 1, oEntering, FALSE);
    AddJournalQuestEntry("GS_DIARY_002", 1, oEntering, FALSE);
    if (GetLocalInt(oEntering, "GS_ENABLED"))
    {
        //restore health
        int nHealth = GetLocalInt(OBJECT_SELF, "GS_HEALTH_" + ObjectToString(oEntering));
        gsCMSetHitPoints(nHealth, oEntering);
        SetLocalInt(oEntering, "GS_ENABLED", -1);
    }
    //activity
    SetLocalInt(oEntering, "GS_ACTIVE", TRUE);
    //load player data
    string sBic = NWNX_Player_GetBicFileName(oEntering);
    NWNX_SQL_ExecuteQuery("SELECT area_tag, pos_x, pos_y, pos_z, gold, rest_meter FROM player_data WHERE bic='" + sBic + "'");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        string sAreaTag = NWNX_SQL_ReadDataInActiveRow(0);
        float fX = StringToFloat(NWNX_SQL_ReadDataInActiveRow(1));
        float fY = StringToFloat(NWNX_SQL_ReadDataInActiveRow(2));
        float fZ = StringToFloat(NWNX_SQL_ReadDataInActiveRow(3));
        int nGold = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
        float fRest = StringToFloat(NWNX_SQL_ReadDataInActiveRow(5));
        object oArea = GetObjectByTag(sAreaTag);
        location lLoc = Location(oArea, Vector(fX, fY, fZ), 0.0);
        AssignCommand(oEntering, DelayCommand(1.0, ActionJumpToLocation(lLoc)));
        NWNX_Creature_SetGold(oEntering, nGold);
        gsSTAdjustState(GS_ST_REST, fRest);
    }
    //load explored areas
    NWNX_SQL_ExecuteQuery("SELECT area_tag FROM explored_areas WHERE bic='" + sBic + "'");
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        string sTag = NWNX_SQL_ReadDataInActiveRow(0);
        SetLocalInt(oEntering, "GS_EXPLORED_" + sTag, TRUE);
    }
}
