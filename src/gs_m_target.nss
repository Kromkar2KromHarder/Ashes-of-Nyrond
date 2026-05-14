#include "nwnx_player"

void main()
{
    object oPC = GetLastPlayerToSelectTarget();
    object oTarget = GetTargetingModeSelectedObject();

    if (GetIsObjectValid(oTarget) && GetIsPC(oTarget) && oTarget != oPC)
    {
        string sName = GetLocalString(oPC, "GS_ALIAS_NAME");
        NWNX_Player_SetCreatureNameOverride(oPC, oTarget, sName);
        DeleteLocalString(oPC, "GS_ALIAS_NAME");
        FloatingTextStringOnCreature("You now know this person as: " + sName, oPC, FALSE);
    }
}
