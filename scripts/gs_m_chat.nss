#include "gs_inc_greyhawk"
#include "nwnx_player"
#include "nwnx_sql"

void main()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();

    // handle pending lie
    string sLiePending = GetLocalString(oPC, "GS_LIE_PENDING");
    if (sLiePending != "" && GetStringLeft(sMessage, 1) != "/")
    {
        DeleteLocalString(oPC, "GS_LIE_PENDING");
        SetPCChatMessage("");

        // speak the lie text as normal dialogue
        AssignCommand(oPC, SpeakString(sLiePending));

        // liar always sees their own flavor text
        SendMessageToPC(oPC, "<c\x99\xcc\xff>" + sMessage + "</c>");

        // bluff roll
        int nBluff = d20() + GetSkillRank(SKILL_BLUFF, oPC);

        // sense motive checks for nearby PCs
        object oOther = GetFirstObjectInShape(SHAPE_SPHERE, 15.0, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
        while (GetIsObjectValid(oOther))
        {
            if (GetIsPC(oOther) && !GetIsDM(oOther) && oOther != oPC)
            {
                int nSenseMotive = d20() + GetSkillRank(31, oOther);
                if (nSenseMotive >= nBluff)
                {
                    string sBicLiar  = NWNX_Player_GetBicFileName(oPC);
                    string sBicOther = NWNX_Player_GetBicFileName(oOther);
                    string sName     = "";

                    NWNX_SQL_ExecuteQuery(
                        "SELECT alias FROM character_aliases WHERE observer_bic='" + sBicOther + "' AND target_bic='" + sBicLiar + "'");
                    if (NWNX_SQL_ReadyToReadNextRow())
                    {
                        NWNX_SQL_ReadNextRow();
                        sName = NWNX_SQL_ReadDataInActiveRow(0);
                    }
                    else
                    {
                        NWNX_SQL_ExecuteQuery(
                            "SELECT display_name FROM character_names WHERE bic='" + sBicLiar + "'");
                        if (NWNX_SQL_ReadyToReadNextRow())
                        {
                            NWNX_SQL_ReadNextRow();
                            sName = NWNX_SQL_ReadDataInActiveRow(0);
                        }
                        else
                        {
                            sName = "Stranger";
                        }
                    }

                    SendMessageToPC(oOther, "<c\x99\xcc\xff>" + sMessage + "</c>");
                }
            }
            oOther = GetNextObjectInShape(SHAPE_SPHERE, 15.0, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
        }
        return;
    }

    if (GetStringLeft(sMessage, 5) == "!name")
    {
        string sName = GetStringRight(sMessage, GetStringLength(sMessage) - 6);
        SetLocalString(oPC, "GS_ALIAS_NAME", sName);
        EnterTargetingMode(oPC, OBJECT_TYPE_CREATURE);
        SetPCChatMessage("");
    }

    else if (GetStringLeft(sMessage, 4) == "/lie")
    {
        string sLie = GetStringRight(sMessage, GetStringLength(sMessage) - 5);
        if (sLie == "") return;

        SetPCChatMessage("");
        SetLocalString(oPC, "GS_LIE_PENDING", sLie);
        SendMessageToPC(oPC, "(Lie queued. Your next message will trigger it.)");
    }

    else if (GetStringLeft(sMessage, 5) == "!date")
    {
        int nDay   = GetCalendarDay();
        int nMonth = GetCalendarMonth();
        string sDate = "Today is " + gsGWGetDayName(nDay) + ", " + IntToString(nDay) + " " + gsGWGetMonthName(nMonth) + ".";
        SendMessageToPC(oPC, "<c\x99\xcc\xff>" + sDate + "</c>");
        SetPCChatMessage("");
    }

    else if (GetStringLeft(sMessage, 5) == "!test")
    {
        SendMessageToPC(oPC, GetStringByStrRef(16777216));
    }
}