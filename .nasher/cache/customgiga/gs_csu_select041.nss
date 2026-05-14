#include "gs_inc_subrace"

void main()
{
    object oSpeaker  = GetPCSpeaker();
    object oProperty = CreateItemOnObject(GS_SU_TEMPLATE_PROPERTY, oSpeaker);

    if (GetIsObjectValid(oProperty))
        AssignCommand(oSpeaker, ActionEquipItem(oProperty, INVENTORY_SLOT_CARMOUR));

    SetSubRace(oSpeaker, "");
}
