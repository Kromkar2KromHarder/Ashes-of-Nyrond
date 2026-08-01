#include "gs_inc_greyhawk"

void main()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();

    if (GetStringLeft(sMessage, 5) == "!name")
    {
        string sName = GetStringRight(sMessage, GetStringLength(sMessage) - 6);
        SetLocalString(oPC, "GS_ALIAS_NAME", sName);
        EnterTargetingMode(oPC, OBJECT_TYPE_CREATURE);
        SetPCChatMessage("");
    }

    if (GetStringLeft(sMessage, 5) == "!date")
    {
        int nDay   = GetCalendarDay();
        int nMonth = GetCalendarMonth();
        string sDate = "Today is " + gsGWGetDayName(nDay) + ", " + IntToString(nDay) + " " + gsGWGetMonthName(nMonth) + ".";
        SendMessageToPC(oPC, "<cªÕþ>" + sDate);
        SetPCChatMessage("");
    }
    if (GetStringLeft(sMessage, 5) == "!test")
{
    SendMessageToPC(oPC, GetStringByStrRef(16777216));
}
}
