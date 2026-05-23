#include "nwnx_player"
#include "nwnx_rename"
#include "nwnx_sql"

void main()
{
    object oPC     = GetLastPlayerToSelectTarget();
    object oTarget = GetTargetingModeSelectedObject();
    string sName   = GetLocalString(oPC, "GS_ALIAS_NAME");

    if (!GetIsObjectValid(oTarget) || sName == "") return;
    if (!GetIsPC(oTarget)) return;

    string sObsBic    = NWNX_Player_GetBicFileName(oPC);
    string sTargetBic = NWNX_Player_GetBicFileName(oTarget);

    if (oTarget == oPC)
    {
        // setting own display name
        NWNX_SQL_ExecuteQuery(
            "INSERT INTO character_names (bic, display_name) VALUES ('" + sObsBic + "', '" + sName + "') " +
            "ON DUPLICATE KEY UPDATE display_name=VALUES(display_name)");

        // update nameplate for all currently online players who don't have a personal alias
        object oOther = GetFirstPC();
        while (GetIsObjectValid(oOther))
        {
            if (oOther != oPC)
            {
                string sOtherBic = NWNX_Player_GetBicFileName(oOther);
                NWNX_SQL_ExecuteQuery(
                    "SELECT alias FROM character_aliases WHERE observer_bic='" + sOtherBic + "' AND target_bic='" + sObsBic + "'");
                if (!NWNX_SQL_ReadyToReadNextRow())
                {
                    NWNX_Rename_SetPCNameOverride(oPC, sName, "", "", NWNX_RENAME_PLAYERNAME_DEFAULT, oOther);
                }
            }
            oOther = GetNextPC();
        }
        FloatingTextStringOnCreature("Your nameplate is now: " + sName, oPC, FALSE);
    }
    else
    {
        // setting alias for another PC
        NWNX_SQL_ExecuteQuery(
            "INSERT INTO character_aliases (observer_bic, target_bic, alias) VALUES ('" + sObsBic + "', '" + sTargetBic + "', '" + sName + "') " +
            "ON DUPLICATE KEY UPDATE alias=VALUES(alias)");

        NWNX_Rename_SetPCNameOverride(oTarget, sName, "", "", NWNX_RENAME_PLAYERNAME_DEFAULT, oPC);
        FloatingTextStringOnCreature("You now know this person as: " + sName, oPC, FALSE);
    }

    DeleteLocalString(oPC, "GS_ALIAS_NAME");
}