#include "sw_inc_json"
#include "nw_inc_nui"
#include "sw_inc_conf"

void main()
{
    object oPlayer = GetPCChatSpeaker();
    string sMessage = GetStringLowerCase(GetPCChatMessage());

    if (sMessage == "sw:toggle")
    {
        SetPCChatVolume(TALKVOLUME_SILENT_TALK);
        int nToken = GetLocalInt(oPlayer, SW_CAST_WIN_TOKEN);
        if (nToken > 0)
        {
            NuiDestroy(oPlayer, nToken);
            DeleteLocalInt(oPlayer, SW_CAST_WIN_TOKEN);
        }
        else
        {
            MakeSpellGui(oPlayer);
        }
    }
    else if (sMessage == "sw:config")
    {
        SetPCChatVolume(TALKVOLUME_SILENT_TALK);
        MakeConfigMenu(oPlayer);
    }

    RunOverride(SW_OVERRIDDEN_PLYR_CHAT);
}