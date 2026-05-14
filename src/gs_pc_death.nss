#include "gs_inc_common"

const string GS_TEMPLATE_CORPSE = "gs_placeable016";

void main()
{
    object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  GS_TEMPLATE_CORPSE,
                                  GetLocation(OBJECT_SELF));

    if (GetIsObjectValid(oCorpse))
    {
        gsCMCreateGold(GetLocalInt(OBJECT_SELF, "GS_GOLD"), oCorpse);
    }
}
