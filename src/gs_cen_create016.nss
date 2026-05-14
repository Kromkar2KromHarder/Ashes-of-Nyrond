#include "gs_inc_encounter"

int StartingConditional()
{
    object oArea             = GetArea(OBJECT_SELF);
    struct gsENLimit stLimit = gsENGetDefaultLimit(oArea);

    SetCustomToken(100, FloatToString(stLimit.fRating, 0, 1));
    return TRUE;
}
