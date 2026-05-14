void main()
{
    //slot 3

    object oPC   = GetPCSpeaker();
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    if (GetIsObjectValid(oItem))
    {
        int nID      = GetLocalInt(OBJECT_SELF, "GS_ID");
        int nValue   = GetLocalInt(OBJECT_SELF, "GS_SLOT_3");

        object oCopy = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, nID, nValue, TRUE);

        if (GetIsObjectValid(oCopy))
        {
            AssignCommand(oPC, ActionEquipItem(oCopy, INVENTORY_SLOT_CHEST));
            DestroyObject(oItem);
        }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL),
                            oPC,
                            0.25);
    }
}
