#include "gs_inc_portal"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    DeleteLocalInt(OBJECT_SELF, "GS_PAGE_START");
    return GetIsPC(oSpeaker) && ! gsPOGetIsPortalActive(OBJECT_SELF, oSpeaker);
}
