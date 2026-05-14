#include "gs_inc_common"

const int GS_LIMIT_GOLD = 5000;

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED"))      return;
    if (GetIsObjectValid(GetFirstItemInInventory())) return;

    //create inventory
    string sTag       = GetTag(OBJECT_SELF);
    sTag              = "GS_INVENTORY_" + GetStringRight(sTag, GetStringLength(sTag) - 3);
    object oInventory = GetObjectByTag(sTag);
    int nOpened       = ! GetIsObjectValid(GetLastKiller());

    if (GetIsObjectValid(oInventory))
    {
        object oItem = GetFirstItemInInventory(oInventory);
        object oCopy = OBJECT_INVALID;

        if (GetIsObjectValid(oItem))
        {
            int nGold  = gsCMGetItemValue(oItem);
            int nNth   = 0;

            do
            {
                nGold = (nGold + gsCMGetItemValue(oItem)) / 2;

                if (Random(100) >= 95)
                {
                    if (nOpened)
                    {
                        oCopy = CopyItem(oItem, OBJECT_SELF);

                        if (GetIsObjectValid(oCopy))
                        {
                            SetIdentified(oCopy, FALSE);
                            SetStolenFlag(oCopy, FALSE);

                            SetPlotFlag(oItem, FALSE);
                            DestroyObject(oItem);
                            ExecuteScript("gs_co_close", oInventory);
                        }
                    }

                    break;
                }

                oItem = GetNextItemInInventory(oInventory);
                if (! GetIsObjectValid(oItem)) oItem = GetFirstItemInInventory(oInventory);
            }
            while (GetIsObjectValid(oItem));

            //create gold
            nGold     /= 10;
            if (nGold > GS_LIMIT_GOLD) nGold = GS_LIMIT_GOLD;
            gsCMCreateGold(Random(nGold));
        }
    }

    if (nOpened) SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
}
