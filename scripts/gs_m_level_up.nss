#include "gs_inc_common"
#include "gs_inc_subrace"
#include "gs_inc_text"

void main()
{
    object oPC   = GetPCLevellingUp();
    int nLevel   = GetHitDice(oPC);

    if (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC))
    {
        int nXP      = GetXP(oPC);
        int nXPLevel = nLevel * (nLevel - 1) / 2 * 1000;

        SetXP(oPC, nXPLevel - 1);
        SetXP(oPC, nXP);

        FloatingTextStringOnCreature(GS_T_16777326, oPC, FALSE);
        return;
    }

    int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));

    if (nSubRace)
    {
        //property
        object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
        if (GetIsObjectValid(oItem)) gsSUApplyProperty(oItem, nSubRace, nLevel);

        //ability
        oItem        = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
        if (GetIsObjectValid(oItem)) gsSUApplyAbility(oItem, nSubRace, nLevel);
    }

    gsCMSendMessageToAllPCs(gsCMReplaceString(GS_T_16777325, GetName(oPC), IntToString(nLevel)));
}
