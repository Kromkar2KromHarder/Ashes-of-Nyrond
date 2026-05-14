int StartingConditional()
{
    //slot 2

    return GetLocalInt(OBJECT_SELF, "GS_SLOT_2_ID") == -1 &&
           GetLocalInt(OBJECT_SELF, "GS_SLOT_2_STRREF") != -1;
}
