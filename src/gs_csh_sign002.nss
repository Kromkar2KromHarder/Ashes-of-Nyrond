#include "gs_inc_shop"

int StartingConditional()
{
    return gsSHGetIsOwner(OBJECT_SELF, GetPCSpeaker());
}
