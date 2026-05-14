#include "gs_inc_text"
#include "gs_inc_worship"
#include "x2_inc_switches"

void main()
{
    if (GetIsPC(OBJECT_SELF))
    {
        if (GetIsDM(OBJECT_SELF))                 return;
        if (GetIsDMPossessed(OBJECT_SELF))        return;
        if (GetIsObjectValid(GetSpellCastItem())) return;
        if (GetHitDice(OBJECT_SELF) < 5)          return;

        string sDeity = "";

        if (GetIsPossessedFamiliar(OBJECT_SELF)) sDeity = GetDeity(GetMaster());
        else                                     sDeity = GetDeity(OBJECT_SELF);

        if (sDeity == "")
        {
            FloatingTextStringOnCreature(GS_T_16777289, OBJECT_SELF, FALSE);
            SetModuleOverrideSpellScriptFinished();
            return;
        }

        if (! gsWOGetPresence(sDeity))
        {
            FloatingTextStringOnCreature(GS_T_16777290, OBJECT_SELF, FALSE);
            SetModuleOverrideSpellScriptFinished();
            return;
        }
    }
}
