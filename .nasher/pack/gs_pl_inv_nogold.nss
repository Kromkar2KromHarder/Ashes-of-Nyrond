#include "gs_inc_common"
#include "gs_inc_time"

const int GS_TIMEOUT = 10800; //3 hours
const int GS_LIMIT   =     5;

void main()
{
    //timeout
    int nTimestamp = gsTIGetActualTimestamp();
    int nTimeout   = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");
    int nOpened    = ! GetIsObjectValid(GetLastKiller());

    if (nTimeout < nTimestamp)
    {
        if (! GetIsObjectValid(GetFirstItemInInventory()))
        {
            //create inventory
            string sTag       = GetTag(OBJECT_SELF);
            sTag              = "GS_INVENTORY_" + GetStringRight(sTag, GetStringLength(sTag) - 3);
            object oInventory = GetObjectByTag(sTag);

            if (GetIsObjectValid(oInventory))
            {
                object oItem = GetFirstItemInInventory(oInventory);
                object oCopy = OBJECT_INVALID;

                if (GetIsObjectValid(oItem))
                {
                    int nValue  = 0;
                    int nLimit  = Random(GS_LIMIT);
                    int nNth    = 0;

                    do
                    {
                        if (Random(100) >= 90)
                        {
                            if (nOpened)
                            {
                                oCopy  = CopyItem(oItem, OBJECT_SELF);
                                nValue = gsCMGetItemValue(oItem);

                                if (GetIsObjectValid(oCopy))
                                {
                                    SetIdentified(oCopy, nValue <= 100);
                                    SetStolenFlag(oCopy, FALSE);
                                }
                            }

                            if (++nNth > nLimit) break;
                        }

                        oItem = GetNextItemInInventory(oInventory);
                        if (! GetIsObjectValid(oItem)) oItem = GetFirstItemInInventory(oInventory);
                    }
                    while (GetIsObjectValid(oItem));
                }
            }
        }

        if (nOpened)
        {
            nTimestamp += GS_TIMEOUT;
            SetLocalInt(OBJECT_SELF, "GS_TIMEOUT", nTimestamp);
            return;
        }
    }

    if (! nOpened) gsCMCreateRecreator(nTimeout);
}
