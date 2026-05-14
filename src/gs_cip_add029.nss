#include "gs_inc_iprop"

int StartingConditional()
{
    object oModule   = GetModule();
    int nTableID     = gsIPGetTableID("itempropdef", oModule);
    int nProperty    = GetLocalInt(OBJECT_SELF, "GS_PROPERTY");
    int nCostTableID = gsIPGetValue(nTableID, nProperty, "COSREF", oModule);
    int nID          = GetLocalInt(OBJECT_SELF, "GS_OFFSET_3");
    int nCount       = gsIPGetCount(nCostTableID, oModule);

    return nID + 5 < nCount;
}
