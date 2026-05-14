#include "gs_inc_common"
#include "gs_inc_xp"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetFirstItemInInventory(oSpeaker);

    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == "GS_HEAD_EVIL")
        {
            gsCMCreateGold(gsCMGetItemValue(oItem), oSpeaker);
            gsXPDistributeExperience(oSpeaker, 25);
            SetPlotFlag(oItem, FALSE);
            DestroyObject(oItem);
        }

        oItem = GetNextItemInInventory(oSpeaker);
    }
}
