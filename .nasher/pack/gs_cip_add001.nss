int StartingConditional()
{
    //slot 1

    return GetLocalInt(OBJECT_SELF, "GS_SLOT_1_ID") != -1 &&
           GetLocalInt(OBJECT_SELF, "GS_SLOT_1_STRREF") != -1;
}
