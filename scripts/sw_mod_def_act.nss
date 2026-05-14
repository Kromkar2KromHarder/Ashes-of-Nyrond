#include "sw_tools"

void main()
{
    object oPlayer = GetItemActivator();
    object oItem = GetItemActivated();
    string sTag = GetTag(oItem);

    if (sTag == "sw_it_mbook" || sTag == "sw_conf_orb")
    {
        ExecuteScript(sTag);
    }
    else 
    {
        RunOverride(SW_OVERRIDDEN_ACT_ITM_SCRIPT);
    }
}
