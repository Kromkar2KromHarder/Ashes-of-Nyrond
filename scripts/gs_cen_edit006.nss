#include "gs_inc_encounter"

const int GS_SLOT = 5;

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);
    int nNth     = GetLocalInt(OBJECT_SELF, "GS_EN_OFFSET") + GS_SLOT;

    if (nNth <= GetLocalInt(OBJECT_SELF, "GS_EN_COUNT"))
    {
        nNth = GetLocalInt(OBJECT_SELF, "GS_EN_SLOT_" + IntToString(nNth));

        SetCustomToken(99 + GS_SLOT,
                       gsENGetCreatureName(nNth, oArea) + " (" +
                       "HG=" + FloatToString(gsENGetCreatureRating(nNth, oArea), 0, 1) + ", " +
                       "RV=" + IntToString(gsENGetCreatureChance(nNth, oArea)) + ")");
        return TRUE;
    }

    return FALSE;
}
