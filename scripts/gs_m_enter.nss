#include "nwnx_sql"
#include "nwnx_creature"
#include "nwnx_player"
#include "gs_inc_state"
#include "gs_inc_common"
#include "gs_inc_text"
#include "gs_inc_resources"

void main()
{
    object oEntering   = GetEnteringObject();
    if (GetIsDM(oEntering)) return;

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
        int nHealth = GetLocalInt(OBJECT_SELF, "GS_HEALTH_" + ObjectToString(oEntering));
        gsCMSetHitPoints(nHealth, oEntering);
        SetLocalInt(oEntering, "GS_ENABLED", -1);
    }

    SetLocalInt(oEntering, "GS_ACTIVE", TRUE);

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
        DelayCommand(5.0, gsRestoreResources(oEntering));
    }

    NWNX_SQL_ExecuteQuery("SELECT area_tag FROM explored_areas WHERE bic='" + sBic + "'");
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        string sTag = NWNX_SQL_ReadDataInActiveRow(0);
        SetLocalInt(oEntering, "GS_EXPLORED_" + sTag, TRUE);
    }

    // apply name layers for this PC vs all online PCs
    object oOther = GetFirstPC();
    while (GetIsObjectValid(oOther))
    {
        if (oOther != oEntering)
        {
            string sOtherBic = NWNX_Player_GetBicFileName(oOther);

            // what does oEntering see oOther as?
            NWNX_SQL_ExecuteQuery(
                "SELECT alias FROM character_aliases WHERE observer_bic='" + sBic + "' AND target_bic='" + sOtherBic + "'");
            if (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                NWNX_Player_SetCreatureNameOverride(oEntering, oOther, NWNX_SQL_ReadDataInActiveRow(0));
            }
            else
            {
                NWNX_SQL_ExecuteQuery(
                    "SELECT display_name FROM character_names WHERE bic='" + sOtherBic + "'");
                if (NWNX_SQL_ReadyToReadNextRow())
                {
                    NWNX_SQL_ReadNextRow();
                    NWNX_Player_SetCreatureNameOverride(oEntering, oOther, NWNX_SQL_ReadDataInActiveRow(0));
                }
                else
                {
                    NWNX_Player_SetCreatureNameOverride(oEntering, oOther, "Stranger");
                }
            }

            // what does oOther see oEntering as?
            NWNX_SQL_ExecuteQuery(
                "SELECT alias FROM character_aliases WHERE observer_bic='" + sOtherBic + "' AND target_bic='" + sBic + "'");
            if (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                NWNX_Player_SetCreatureNameOverride(oOther, oEntering, NWNX_SQL_ReadDataInActiveRow(0));
            }
            else
            {
                NWNX_SQL_ExecuteQuery(
                    "SELECT display_name FROM character_names WHERE bic='" + sBic + "'");
                if (NWNX_SQL_ReadyToReadNextRow())
                {
                    NWNX_SQL_ReadNextRow();
                    NWNX_Player_SetCreatureNameOverride(oOther, oEntering, NWNX_SQL_ReadDataInActiveRow(0));
                }
                else
                {
                    NWNX_Player_SetCreatureNameOverride(oOther, oEntering, "Stranger");
                }
            }
        }
        oOther = GetNextPC();
    }
}