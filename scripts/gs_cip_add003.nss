int StartingConditional()
{
    //slot 3

    return GetLocalInt(OBJECT_SELF, "GS_SLOT_3_ID") != -1 &&
           GetLocalInt(OBJECT_SELF, "GS_SLOT_3_STRREF") != -1;
}
