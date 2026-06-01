#include "gs_inc_greyhawk"
#include "nwnx_player"
#include "nwnx_sql"

void main()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();

    // handle talkto formatting
    object oTalkTarget = GetLocalObject(oPC, "GS_TALKTO_TARGET");
    if (GetIsObjectValid(oTalkTarget) && GetStringLeft(sMessage, 1) != "!")
    {
        string sBicSpeaker = NWNX_Player_GetBicFileName(oPC);
        string sBicTarget  = NWNX_Player_GetBicFileName(oTalkTarget);

        SetPCChatMessage("");
        DeleteLocalObject(oPC, "GS_TALKTO_TARGET");

        object oOther = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
        while (GetIsObjectValid(oOther))
        {
            if (GetIsPC(oOther) && !GetIsDM(oOther))
            {
                string sBicOther   = NWNX_Player_GetBicFileName(oOther);
                string sTargetName = "";

                NWNX_SQL_ExecuteQuery(
                    "SELECT alias FROM character_aliases WHERE observer_bic='" + sBicOther + "' AND target_bic='" + sBicTarget + "'");
                if (NWNX_SQL_ReadyToReadNextRow())
                {
                    NWNX_SQL_ReadNextRow();
                    sTargetName = NWNX_SQL_ReadDataInActiveRow(0);
                }
                else
                {
                    NWNX_SQL_ExecuteQuery(
                        "SELECT display_name FROM character_names WHERE bic='" + sBicTarget + "'");
                    if (NWNX_SQL_ReadyToReadNextRow())
                    {
                        NWNX_SQL_ReadNextRow();
                        sTargetName = NWNX_SQL_ReadDataInActiveRow(0);
                    }
                    else
                    {
                        sTargetName = "Stranger";
                    }
                }

                string sFormatted = "[To " + sTargetName + "]: " + sMessage;

                if (oOther == oTalkTarget)
                    SendMessageToPC(oOther, "<c\x99\xcc\xff>(!) " + sFormatted + "</c>");
                else
                    SendMessageToPC(oOther, sFormatted);
            }
            oOther = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
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

    else if (GetStringLeft(sMessage, 7) == "!talkto")
    {
        SetLocalInt(oPC, "GS_TALKTO_PENDING", TRUE);
        EnterTargetingMode(oPC, OBJECT_TYPE_CREATURE);
        SetPCChatMessage("");
    }

    else if (GetStringLeft(sMessage, 4) == "/lie")
    {
        string sLie = GetStringRight(sMessage, GetStringLength(sMessage) - 5);
        if (sLie == "") return;

        SetPCChatMessage("");
        AssignCommand(oPC, SpeakString(sLie));

        int nBluff = d20() + GetSkillRank(SKILL_BLUFF, oPC);

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

                    SendMessageToPC(oOther, "<c\x99\xcc\xff>You feel like " + sName + " is being untruthful...</c>");
                }
            }
            oOther = GetNextObjectInShape(SHAPE_SPHERE, 15.0, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
        }
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