#include "gs_inc_shop"
#include "gs_inc_text"

void main()
{
    if (gsSHGetIsVacant(OBJECT_SELF)) return;

    object oDisturbed = GetLastDisturbed();
    object oItem      = GetInventoryDisturbItem();
    string sTag       = GetTag(oItem);

    switch (GetInventoryDisturbType())
    {
    case INVENTORY_DISTURB_TYPE_ADDED:
        if (GetIsDM(oDisturbed) ||
            gsSHGetIsOwner(OBJECT_SELF, oDisturbed))
        {
            gsSHImportItem(oItem, OBJECT_SELF);
        }
        else
        {
            ActionGiveItem(oItem, oDisturbed);
            SendMessageToPC(oDisturbed, GS_T_16777420);
        }
        break;

    case INVENTORY_DISTURB_TYPE_REMOVED:
    case INVENTORY_DISTURB_TYPE_STOLEN:
        if (GetStringLeft(sTag, 6) == "GS_SH_")
        {
            if (GetIsDM(oDisturbed) ||
                gsSHGetIsOwner(OBJECT_SELF, oDisturbed))
            {
                gsSHExportItem(oItem, oDisturbed);
            }
            else
            {
                SetLocalObject(oDisturbed, "GS_SH_ITEM", oItem);
                ActionTakeItem(oItem, oDisturbed);
                ActionStartConversation(oDisturbed, "", TRUE, FALSE);
            }
        }
        break;
    }
}
