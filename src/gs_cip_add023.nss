#include "gs_inc_iprop"

int StartingConditional()
{
    object oModule  = GetModule();
    int nTableID    = gsIPGetTableID("itempropdef", oModule);
    int nProperty   = GetLocalInt(OBJECT_SELF, "GS_PROPERTY");
    int nSubTableID = gsIPGetValue(nTableID, nProperty, "SUBREF", oModule);
    int nID         = GetLocalInt(OBJECT_SELF, "GS_OFFSET_2");
    int nCount      = gsIPGetCount(nSubTableID, oModule);

    return nID + 5 < nCount;
}
