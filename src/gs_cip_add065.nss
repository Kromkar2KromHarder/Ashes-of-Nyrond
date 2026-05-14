int StartingConditional()
{
    //slot 4

    return GetLocalInt(OBJECT_SELF, "GS_SLOT_4_ID") == -1 &&
           GetLocalInt(OBJECT_SELF, "GS_SLOT_4_STRREF") != -1;
}
