#include "nwnx_events"
#include "gs_inc_resources"

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;

    SendMessageToPC(oPC, "DEBUG: post-login restore firing");
    gsRestoreResources(oPC);
}
