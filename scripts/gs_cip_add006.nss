#include "gs_inc_iprop"

int StartingConditional()
{
    object oModule = GetModule();
    int nTableID   = gsIPGetTableID("itempropdef", oModule);
    int nID        = GetLocalInt(OBJECT_SELF, "GS_OFFSET_1");
    int nCount     = gsIPGetCount(nTableID, oModule);

    return nID + 5 < nCount;
}
