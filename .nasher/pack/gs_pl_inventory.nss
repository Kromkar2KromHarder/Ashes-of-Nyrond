#include "gs_inc_common"
#include "gs_inc_time"

const int GS_TIMEOUT    = 21600; //6 hours
const int GS_LIMIT      =     5;
const int GS_LIMIT_GOLD =  2000;

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
                    int nGold   = 0;
                    int nValue  = 0;
                    int nLimit  = Random(GS_LIMIT);
                    int nNth    = 0;

                    do
                    {
                        nValue = gsCMGetItemValue(oItem);
                        nGold  = (nGold + nValue) / 2;

                        if (Random(100) >= 90)
                        {
                            if (nOpened)
                            {
                                oCopy = CopyItem(oItem, OBJECT_SELF);

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

                    //create gold
                    nGold      /= 10;
                    if (nGold > GS_LIMIT_GOLD) nGold = GS_LIMIT_GOLD;
                    gsCMCreateGold(Random(nGold));
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

    if (! nOpened)
    {
        string sTag = GetTag(OBJECT_SELF);

        if (! nTimeout) nTimeout = nTimestamp + gsTIGetTimestamp(0, 0, 0, GS_TIMEOUT);

        if (sTag == "GS_TREASURE_LOW")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_LOW,    nTimeout);
        else if (sTag == "GS_TREASURE_MEDIUM")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_MEDIUM, nTimeout);
        else if (sTag == "GS_TREASURE_HIGH")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_HIGH,   nTimeout);
        else if (sTag == "GS_WEAPON_LOW")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_WEAPON_LOW,      nTimeout);
        else if (sTag == "GS_WEAPON_MEDIUM")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_WEAPON_MEDIUM,   nTimeout);
        else if (sTag == "GS_WEAPON_HIGH")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_WEAPON_HIGH,     nTimeout);
        else if (sTag == "GS_ARMOR_LOW")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_ARMOR_LOW,       nTimeout);
        else if (sTag == "GS_ARMOR_MEDIUM")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_ARMOR_MEDIUM,    nTimeout);
        else if (sTag == "GS_ARMOR_HIGH")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_ARMOR_HIGH,      nTimeout);
        else
            gsCMCreateRecreator(nTimeout);
    }
}
