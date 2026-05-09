#include "gs_inc_quarter"

int StartingConditional()
{
    return gsQUGetIsOwner(OBJECT_SELF, GetPCSpeaker());
}
