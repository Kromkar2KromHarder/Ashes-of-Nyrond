#include "gs_inc_iprop"
#include "gs_inc_text"

int StartingConditional()
{
    object oModule  = GetModule();
    object oPC      = GetPCSpeaker();
    object oItem    = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nID         = GetLocalInt(OBJECT_SELF, "GS_ID");
    int nTableID    = gsIPGetAppearanceTableID(nID, oModule);
    int nLimit      = gsIPGetCount(nTableID, oModule);
    int nAppearance = 0;
    int nSlot       = 0;
    int nNth        = GetLocalInt(OBJECT_SELF, "GS_OFFSET");
    int nCount      = nNth + 5;

    for (; nNth < nCount; nNth++)
    {
        nSlot++;

        if (nNth < nLimit)
        {
            SetCustomToken(99 + nSlot, IntToString(nNth));

            if (GetIsObjectValid(oItem))
            {
                if (nID != ITEM_APPR_ARMOR_MODEL_TORSO ||
                    gsIPGetAppearanceAC(nTableID,
                                        GetItemAppearance(oItem,
                                                          ITEM_APPR_TYPE_ARMOR_MODEL,
                                                          ITEM_APPR_ARMOR_MODEL_TORSO),
                                        oModule) ==
                    gsIPGetValue(nTableID, nNth, "AC", oModule))
                {
                    SetLocalInt(OBJECT_SELF,
                                "GS_SLOT_" + IntToString(nSlot),
                                gsIPGetValue(nTableID, nNth, "ID", oModule));
                    continue;
                }
            }

            SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), -2);
        }
        else
        {
            SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), -1);
        }
    }

    switch (nID)
    {
    case ITEM_APPR_ARMOR_MODEL_BELT:
        SetCustomToken(105, GS_T_16777244 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_LBICEP:
        SetCustomToken(105, GS_T_16777245 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_LFOOT:
        SetCustomToken(105, GS_T_16777246 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_LFOREARM:
        SetCustomToken(105, GS_T_16777247 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_LHAND:
        SetCustomToken(105, GS_T_16777248 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_LSHIN:
        SetCustomToken(105, GS_T_16777249 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_LSHOULDER:
        SetCustomToken(105, GS_T_16777250 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_LTHIGH:
        SetCustomToken(105, GS_T_16777251 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_NECK:
        SetCustomToken(105, GS_T_16777252 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_PELVIS:
        SetCustomToken(105, GS_T_16777253 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_RBICEP:
        SetCustomToken(105, GS_T_16777254 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_RFOOT:
        SetCustomToken(105, GS_T_16777255 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_RFOREARM:
        SetCustomToken(105, GS_T_16777256 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_RHAND:
        SetCustomToken(105, GS_T_16777257 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_ROBE:
        SetCustomToken(105, GS_T_16777258 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_RSHIN:
        SetCustomToken(105, GS_T_16777259 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_RSHOULDER:
        SetCustomToken(105, GS_T_16777260 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_RTHIGH:
        SetCustomToken(105, GS_T_16777261 + "\n");
        break;

    case ITEM_APPR_ARMOR_MODEL_TORSO:
        SetCustomToken(105, GS_T_16777262 + "\n");
        break;
    }

    return TRUE;
}
