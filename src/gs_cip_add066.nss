int StartingConditional()
{
    //slot 5

    return GetLocalInt(OBJECT_SELF, "GS_SLOT_5_ID") == -1 &&
           GetLocalInt(OBJECT_SELF, "GS_SLOT_5_STRREF") != -1;
}
