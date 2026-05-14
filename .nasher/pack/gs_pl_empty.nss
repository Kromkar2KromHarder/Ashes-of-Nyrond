void main()
{
    if (! GetIsObjectValid(GetFirstItemInInventory()))
    {
        SetPlotFlag(OBJECT_SELF, FALSE);
        DestroyObject(OBJECT_SELF);
    }
}
