#include "sw_tools"

void main()
{
    object oPlayer = GetPCLevellingUp();
    int nToken = GetLocalInt(oPlayer, SW_CAST_WIN_TOKEN);

    if (nToken > 0)
    {
        NuiDestroy(oPlayer, nToken);
    }
    RunOverride(SW_OVERRIDDEN_LVLUP_SCRIPT);
}
