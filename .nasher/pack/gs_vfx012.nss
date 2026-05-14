#include "gs_inc_common"
#include "gs_inc_encounter"

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    if (gsARGetIsAreaActive(oArea))
    {
        object oObject = gsCMGetNearestObject("GS_FX_gs_item310");

        if (! GetIsObjectValid(oObject) ||
            GetDistanceToObject(oObject) > 2.5)
        {
            struct gsENLimit stLimit = gsENGetDefaultLimit(oArea);

            if (stLimit.fRating > 0.0 &&
                stLimit.nCount > 0)
            {
                location lLocation = GetLocation(OBJECT_SELF);

                //spawn
                gsENSpawnAtLocation(stLimit.fRating * 2.0,
                                    stLimit.nCount > 4 ? 4 : stLimit.nCount,
                                    lLocation,
                                    2.5,
                                    VFX_IMP_POLYMORPH,
                                    80);
            }
        }

        DelayCommand(30.0, gsRun());
    }
}
//----------------------------------------------------------------
void main()
{
    gsRun();
}
