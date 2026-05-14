#include "sw_inc_json"

void main()
{
    object oPlayer = GetItemActivator();

    MakeSpellGui(oPlayer);
}