#include "gs_inc_iprop"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oModule = GetModule();

    ActionDoCommand(gsIPLoadCostTable(oModule));
    ActionDoCommand(gsIPLoadParamTable(oModule));
    ActionDoCommand(gsIPLoadPropertyTable(oModule));
    ActionDoCommand(gsIPLoadItemCategoryTable(oModule));
    ActionDoCommand(gsIPLoadValidationTable(oModule));

    ActionDoCommand(gsIPLoadAppearanceTable("parts_belt",     ITEM_APPR_ARMOR_MODEL_BELT,      oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_bicep",    ITEM_APPR_ARMOR_MODEL_LBICEP,    oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_bicep",    ITEM_APPR_ARMOR_MODEL_RBICEP,    oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_chest",    ITEM_APPR_ARMOR_MODEL_TORSO,     oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_foot",     ITEM_APPR_ARMOR_MODEL_LFOOT,     oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_foot",     ITEM_APPR_ARMOR_MODEL_RFOOT,     oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_forearm",  ITEM_APPR_ARMOR_MODEL_LFOREARM,  oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_forearm",  ITEM_APPR_ARMOR_MODEL_RFOREARM,  oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_hand",     ITEM_APPR_ARMOR_MODEL_LHAND,     oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_hand",     ITEM_APPR_ARMOR_MODEL_RHAND,     oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_legs",     ITEM_APPR_ARMOR_MODEL_LTHIGH,    oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_legs",     ITEM_APPR_ARMOR_MODEL_RTHIGH,    oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_neck",     ITEM_APPR_ARMOR_MODEL_NECK,      oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_pelvis",   ITEM_APPR_ARMOR_MODEL_PELVIS,    oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_robe",     ITEM_APPR_ARMOR_MODEL_ROBE,      oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_shin",     ITEM_APPR_ARMOR_MODEL_LSHIN,     oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_shin",     ITEM_APPR_ARMOR_MODEL_RSHIN,     oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_shoulder", ITEM_APPR_ARMOR_MODEL_LSHOULDER, oModule));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_shoulder", ITEM_APPR_ARMOR_MODEL_RSHOULDER, oModule));

    ActionDoCommand(SetLocalInt(oModule, "GS_IP_ENABLED", TRUE));

    ActionDoCommand(DestroyObject(OBJECT_SELF));
}
