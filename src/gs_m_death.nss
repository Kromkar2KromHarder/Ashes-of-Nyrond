#include "gs_inc_chain"
#include "gs_inc_flag"
#include "gs_inc_worship"
#include "gs_inc_xp"

const string GS_TEMPLATE_CORPSE = "gs_placeable017";
const int GS_PENALTY_PER_LEVEL  = 10;

void gsDeath()
{
    //reward
    object oObject = GetLastKiller();

    if (GetIsObjectValid(oObject) &&
        GetObjectType(oObject) == OBJECT_TYPE_CREATURE &&
        oObject != OBJECT_SELF)
    {
        gsXPRewardKill(oObject);
    }

    //state
    gsSTSetInitialState();

    //deity
    if (gsWOGrantResurrection()) return;

    //apply penalty
    gsXPApplyPenalty(OBJECT_SELF, GS_PENALTY_PER_LEVEL, TRUE);

    //chain
    if (gsCHGetHasChain())       gsCHRemoveChain(gsCHGetChain());

    //teleport
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints() + 10), OBJECT_SELF);
    ClearAllActions(TRUE);
    ActionJumpToObject(GetObjectByTag("GS_TARGET_DEATH"));

    //create corpse
    oObject        = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  GS_TEMPLATE_CORPSE,
                                  GetLocation(OBJECT_SELF));

    if (GetIsObjectValid(oObject))
    {
        int nGold = GetGold();

        if (nGold)
        {
            TakeGoldFromCreature(nGold, OBJECT_SELF, TRUE);
            SetLocalInt(oObject, "GS_GOLD", nGold);
        }

        SetLocalObject(oObject, "GS_TARGET", OBJECT_SELF);
        SetLocalObject(OBJECT_SELF, "GS_CORPSE", oObject);
    }
}
//----------------------------------------------------------------
void main()
{
    object oDied = GetLastPlayerDied();

    if (gsFLGetAreaFlag("PVP", oDied) &&
        GetLastKiller() != oDied)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oDied);
    }
    else
    {
        AssignCommand(oDied, gsDeath());
    }
}
