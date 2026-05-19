#include "gs_inc_shop"

int StartingConditional()
{
    if (! gsSHGetIsVacant(OBJECT_SELF))
    {
        SetCustomToken(100, gsSHGetOwnerName(OBJECT_SELF));
        return TRUE;
    }

    return FALSE;
}
