#include "gs_inc_iprop"

int StartingConditional()
{
    object oModule = GetModule();
    int nID        = GetLocalInt(OBJECT_SELF, "GS_ID");
    int nTableID   = gsIPGetAppearanceTableID(nID, oModule);
    int nNth       = GetLocalInt(OBJECT_SELF, "GS_OFFSET");
    int nCount     = gsIPGetCount(nTableID, oModule);

    return nNth + 5 < nCount;
}
