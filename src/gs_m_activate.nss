#include "gs_inc_chain"
#include "gs_inc_common"
#include "gs_inc_encounter"
#include "gs_inc_forum"
#include "gs_inc_iprop"
#include "gs_inc_state"
#include "gs_inc_text"
#include "gs_inc_time"

void main()
{
    object oActivator  = GetItemActivator();
    object oItem       = GetItemActivated();
    object oTarget     = GetItemActivatedTarget();
    location lLocation = GetItemActivatedTargetLocation();
    string sTag        = GetTag(oItem);

    //firewood
    if (sTag == "GS_FIREWOOD")
    {
        CreateObject(OBJECT_TYPE_PLACEABLE, "gs_placeable177", lLocation);
        return;
    }
//campfire kit
if (sTag == "GS_CAMPFIRE_KIT")
{
    object oCampfire = GetNearestObjectByTag("GS_CAMPFIRE", oActivator);
    if (GetIsObjectValid(oCampfire) && GetDistanceBetween(oActivator, oCampfire) <= 5.0)
    {
        FloatingTextStringOnCreature("You already have a campfire nearby.", oActivator, FALSE);
        return;
    }
    object oNewCampfire = CreateObject(OBJECT_TYPE_PLACEABLE, "campfr001", lLocation);
    DelayCommand(1200.0, DestroyObject(oNewCampfire));
    effect eRing = EffectAreaOfEffect(AOE_MOB_ELECTRICAL);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eRing, lLocation, 1200.0);
    return;
}

    //craft
    if (sTag == "GS_CR_RECIPE")
    {

    //craft
    if (sTag == "GS_CR_RECIPE")
    {
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_cr_recipe", TRUE, FALSE));
        return;
    }

    //worship
    if (sTag == "GS_WO_SELECT")
    {
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_wo_select", TRUE, FALSE));
        return;
    }

    //write message
    if (sTag == "GS_ME_WRITE")
    {
        SetLocalObject(oActivator, "GS_TARGET", oItem);
        AssignCommand(oTarget, SpeakString(GS_T_16777234));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_me_write", TRUE, FALSE));
        return;
    }

    //food
    if (GetStringLeft(sTag, 10) == "GS_ST_FOOD")
    {
        float fValue = StringToFloat(GetStringRight(sTag, GetStringLength(sTag) - 11));
        AssignCommand(oTarget, SpeakString(GS_T_16777235));
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_FOOD, fValue));
        return;
    }

    //water
    if (GetStringLeft(sTag, 11) == "GS_ST_WATER")
    {
        float fValue = StringToFloat(GetStringRight(sTag, GetStringLength(sTag) - 12));
        AssignCommand(oTarget, SpeakString(GS_T_16777236));
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_WATER, fValue));
        return;
    }

    //message
    if (GetStringLeft(sTag, 6) == "GS_ME_")
    {
        if (GetIsObjectValid(oTarget))
        {
            switch (GetObjectType(oTarget))
            {
            case OBJECT_TYPE_CREATURE:

                //read message public
                if (oTarget == oActivator)
                {
                    SetLocalObject(oActivator, "GS_TARGET", oItem);
                    AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
                    AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_me_read", FALSE, FALSE));
                }
                break;

            case OBJECT_TYPE_ITEM:

                //copy message
                if (GetTag(oTarget) == "GS_ME_WRITE" &&
                    GetIsObjectValid(CopyItem(oItem, oActivator)))
                {
                    SetPlotFlag(oTarget, FALSE);
                    DestroyObject(oTarget);
                }
                break;

            case OBJECT_TYPE_PLACEABLE:

                //post message
                if (GetStringLeft(GetTag(oTarget), 8) == "GS_FORUM" &&
                    gsFOPostMessage(GetStringRight(sTag, 16), oActivator, oTarget))
                {
                    SetPlotFlag(oItem, FALSE);
                    DestroyObject(oItem);
                }
                break;
            }
            return;
        }

        //read message private
        SetLocalObject(oActivator, "GS_TARGET", oItem);
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_me_read", TRUE, FALSE));
        return;
    }

    //item property
    if (GetStringLeft(sTag, 6) == "GS_IP_")
    {
        if (GetIsObjectValid(oTarget) &&
            GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
        {
            //GS_IP_{type}_{subtype}_{cost}_{param}_{duration}
            int nType = StringToInt(GetSubString(sTag, 6, 3));

            if (gsIPGetIsValid(oTarget, nType))
            {
                int nSubType            = StringToInt(GetSubString(sTag, 10, 3));
                int nCost               = StringToInt(GetSubString(sTag, 14, 3));
                int nParam              = StringToInt(GetSubString(sTag, 18, 3));
                float fDuration         = HoursToSeconds(StringToInt(GetSubString(sTag, 22, 3)));
                itemproperty ipProperty = gsIPGetItemProperty(nType, nSubType, nCost, nParam);

                switch (nType)
                {
                case ITEM_PROPERTY_DAMAGE_BONUS:
                case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                    gsIPAddDamageBonus(oTarget, ipProperty, fDuration);
                    break;

                default:
                    gsIPAddItemProperty(oTarget, ipProperty, fDuration, fDuration == 0.0);
                    break;
                }

                ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                    EffectVisualEffect(VFX_IMP_HOLY_AID),
                                    oActivator);
            }
            else
            {
                SendMessageToPC(oActivator, GS_T_16777237);
            }
        }

        return;
    }

    if (! (GetIsDM(oActivator) ||
           GetIsDMPossessed(oActivator)))
        return;

    //soulcatcher
    if (GetResRef(oItem) == "gs_item018" &&
        GetStringLeft(sTag, 6) == "GS_BA_")
    {
        if (GetIsObjectValid(oTarget) &&
            oTarget != oActivator)
        {
            if (GetIsPC(oTarget) &&
                GetIsObjectValid(CopyObject(oItem,
                                            GetLocation(oActivator),
                                            oActivator,
                                            "GS_BA_" + GetPCPublicCDKey(oTarget))))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DEMON_HAND), oTarget);
                SetPlotFlag(oItem, FALSE);
                gsCMDestroyObject(oItem);
            }
        }
        else
        {
            if (sTag == "GS_BA_VOID")
            {
                SendMessageToPC(oActivator, GS_T_16777424);
            }
            else
            {
                SendMessageToPC(
                    oActivator,
                    gsCMReplaceString(
                        GS_T_16777423,
                        GetSubString(sTag, 6, GetStringLength(sTag) - 6)));
            }
        }
        return;
    }

    if (oActivator == oTarget) return;

    //chain
    if (sTag == "GS_CHAIN")
    {
        gsCHRemoveChain(oItem);
        gsCHApplyChain(oItem, oTarget);
        return;
    }

    //bonus/punishment
    if (sTag == "GS_XP_APPLY")
    {
        if (GetIsObjectValid(oTarget) && GetIsPC(oTarget))
        {
            SetLocalObject(oActivator, "GS_TARGET", oTarget);
            AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_xp_apply", TRUE, FALSE));
        }
        return;
    }

    //value
    if (sTag == "GS_DM_VALUE")
    {
        if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
            SendMessageToPC(oActivator,
                            GetName(oTarget) + ": " +
                            "<cþë¦>" + IntToString(gsCMGetItemValue(oTarget)) + " Gold");
        return;
    }

    //spawn encounter
    if (sTag == "GS_EN_CREATE")
    {
        SetLocalLocation(oActivator, "GS_TARGET", lLocation);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_en_create", TRUE, FALSE));
        return;
    }

    //edit encounter
    if (sTag == "GS_EN_EDIT")
    {
        if (GetIsObjectValid(oTarget)) gsENSetCreature(oTarget, 5, GetArea(oTarget));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_en_edit", TRUE, FALSE));
        return;
    }
}
}
