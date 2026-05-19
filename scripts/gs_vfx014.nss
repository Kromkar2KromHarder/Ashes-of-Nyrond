#include "gs_inc_area"

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    if (gsARGetIsAreaActive(oArea))
    {
        object oObject  = GetFirstObjectInArea(oArea);
        int nRacialType = RACIAL_TYPE_INVALID;

        while (GetIsObjectValid(oObject))
        {
            if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE &&
                ! GetIsDM(oObject))
            {
                nRacialType = GetRacialType(oObject);

                if (! (nRacialType == RACIAL_TYPE_CONSTRUCT ||
                       nRacialType == RACIAL_TYPE_UNDEAD))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                        EffectDamage(d6(),
                                                     DAMAGE_TYPE_NEGATIVE,
                                                     DAMAGE_POWER_ENERGY),
                                        oObject);
                }
            }

            oObject = GetNextObjectInArea(oArea);
        }

        DelayCommand(6.0, gsRun());
    }
}
//----------------------------------------------------------------
void main()
{
    gsRun();
}
