#include "gs_inc_portal"

const string GS_TEMPLATE_OBJECT = "gs_placeable273";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oObject = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  GS_TEMPLATE_OBJECT,
                                  GetLocation(OBJECT_SELF));

    if (GetIsObjectValid(oObject)) gsPORegisterPortal(oObject);

    DestroyObject(OBJECT_SELF);
}
