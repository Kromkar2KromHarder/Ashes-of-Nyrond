#include "gs_inc_common"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetLocalObject(oSpeaker, "GS_SH_ITEM");
    int nValue      = gsCMGetItemValue(oItem) * 90 / 100;
    if (nValue < 1) nValue = 1;

    SetCustomToken(100, GetName(oItem));
    SetCustomToken(101, IntToString(nValue));

    return TRUE;
}
