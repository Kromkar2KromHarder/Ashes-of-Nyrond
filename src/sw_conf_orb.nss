#include "sw_inc_conf"

void main()
{
    object oPlayer = GetItemActivator();
    if (oPlayer == OBJECT_INVALID)
    {
        oPlayer = OBJECT_SELF;
    }

    MakeConfigMenu(oPlayer);
}
