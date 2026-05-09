#include "gs_inc_iprop"

int StartingConditional()
{
    object oModule    = GetModule();
    int nTableID      = gsIPGetTableID("itempropdef", oModule);
    int nProperty     = GetLocalInt(OBJECT_SELF, "GS_PROPERTY");
    int nParamTableID = gsIPGetValue(nTableID, nProperty, "PARREF", oModule);
    int nID           = GetLocalInt(OBJECT_SELF, "GS_OFFSET_4");
    int nCount        = gsIPGetCount(nParamTableID, oModule);

    return nID + 5 < nCount;
}
