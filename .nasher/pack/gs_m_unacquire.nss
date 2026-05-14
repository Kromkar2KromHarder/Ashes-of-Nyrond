#include "gs_inc_chain"
#include "gs_inc_fixture"

const string GS_TEMPLATE_CORPSE = "gs_placeable017";

void main()
{
    object oLostBy = GetModuleItemLostBy();
    object oItem   = GetModuleItemLost();
    string sTag    = GetTag(oItem);

    //chain
    if (sTag == "GS_CHAIN")
    {
        gsCHRemoveChain(oItem);
        return;
    }

    //corpse
    if (sTag == "GS_CORPSE")
    {
        object oTarget = GetLocalObject(oItem, "GS_TARGET");

        if (GetIsObjectValid(oTarget))
        {
            object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE,
                                          GS_TEMPLATE_CORPSE,
                                          GetLocation(oLostBy));

            if (GetIsObjectValid(oCorpse))
            {
                SetLocalObject(oCorpse, "GS_TARGET", oTarget);
                SetLocalObject(oTarget, "GS_CORPSE", oCorpse);
                SetLocalInt(oCorpse, "GS_GOLD", GetLocalInt(oItem, "GS_GOLD"));
            }
        }

        SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
        return;
    }

    //fixture
    if (GetStringLeft(sTag, 6) == "GS_FX_")
    {
        if (! GetIsObjectValid(GetItemPossessor(oItem)))
        {
            vector vPosition    = GetPosition(oLostBy);
            float fFacing       = GetFacing(oLostBy);
            vPosition          += AngleToVector(fFacing);
            location lLocation  = Location(GetArea(oLostBy), vPosition, fFacing);
            sTag                = GetStringRight(sTag, GetStringLength(sTag) - 6);
            object oFixture     = CreateObject(OBJECT_TYPE_PLACEABLE, sTag, lLocation);

            if (GetIsObjectValid(oFixture))
            {
                gsFXSaveFixture(GetTag(GetArea(oFixture)), oFixture);
                SetPlotFlag(oItem, FALSE);
                DestroyObject(oItem);
            }
        }

        return;
    }
}
