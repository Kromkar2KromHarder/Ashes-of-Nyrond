#include "gs_inc_encounter"

int StartingConditional()
{
    int nSlot    = GetLocalInt(OBJECT_SELF, "GS_EN_SLOT");
    object oArea = GetArea(OBJECT_SELF);

    SetCustomToken(100,
                   gsENGetCreatureName(nSlot, oArea) + " (" +
                   "HG=" + FloatToString(gsENGetCreatureRating(nSlot, oArea), 0, 1) + ", " +
                   "RV=" + IntToString(gsENGetCreatureChance(nSlot, oArea)) + ")");

    return TRUE;
}
