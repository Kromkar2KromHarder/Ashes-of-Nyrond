#include "sw_tools"

void main()
{
    object oPlayer = GetLastPCRested();
    int nToken = GetLocalInt(oPlayer, SW_CAST_WIN_TOKEN);

    if (nToken > 0)
    {
        NuiDestroy(oPlayer, nToken);
    }

    RunOverride(SW_OVERRIDDEN_REST_SCRIPT, "x2_mod_def_rest");
}
