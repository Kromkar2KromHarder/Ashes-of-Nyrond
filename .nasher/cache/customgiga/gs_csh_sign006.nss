#include "gs_inc_shop"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nCost       = GetLocalInt(OBJECT_SELF, "GS_COST");
    int nTimeout    = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");

    if (nCost > 0) TakeGoldFromCreature(nCost, oSpeaker, TRUE);

    gsSHSetOwner(OBJECT_SELF, oSpeaker, nTimeout);

    return TRUE;
}
