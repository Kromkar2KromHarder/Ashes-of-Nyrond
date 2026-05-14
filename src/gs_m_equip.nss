#include "gs_inc_common"
#include "gs_inc_iprop"
#include "gs_inc_text"

void main()
{
    object oEquippedBy      = GetPCItemLastEquippedBy();
    object oEquipped        = GetPCItemLastEquipped();
    itemproperty ipProperty = GetFirstItemProperty(oEquipped);
    int nType               = 0;
    int nSubType            = 0;
    int nCost               = 0;
    int nParam              = 0;
    int nDurationType       = 0;

    //disallowed properties
    while (GetIsItemPropertyValid(ipProperty))
    {
        if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_PERMANENT)
        {
            nType    = GetItemPropertyType(ipProperty);
            nSubType = GetItemPropertySubType(ipProperty);
            nCost    = GetItemPropertyCostTableValue(ipProperty);
            nParam   = GetItemPropertyParam1Value(ipProperty);

            switch (nType)
            {
            case ITEM_PROPERTY_DAMAGE_BONUS:
                if (nSubType == IP_CONST_DAMAGETYPE_MAGICAL)
                    RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_DAMAGE_RESISTANCE:
                if (nSubType == IP_CONST_DAMAGETYPE_MAGICAL)
                {
                    RemoveItemProperty(oEquipped, ipProperty);
                }
                else if (nSubType == IP_CONST_DAMAGETYPE_BLUDGEONING ||
                         nSubType == IP_CONST_DAMAGETYPE_PIERCING ||
                         nSubType == IP_CONST_DAMAGETYPE_SLASHING)
                {
                    RemoveItemProperty(oEquipped, ipProperty);
                    ipProperty = ItemPropertyDamageImmunity(nSubType, IP_CONST_DAMAGEIMMUNITY_5_PERCENT);
                    gsIPAddItemProperty(oEquipped, ipProperty);
                }
                else if (nCost != IP_CONST_DAMAGERESIST_5)
                {
                    RemoveItemProperty(oEquipped, ipProperty);
                    ipProperty = ItemPropertyDamageResistance(nSubType, IP_CONST_DAMAGERESIST_5);
                    gsIPAddItemProperty(oEquipped, ipProperty);
                }
                break;

            case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
                if (nSubType == IP_CONST_DAMAGETYPE_MAGICAL)
                    RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                if (nParam == IP_CONST_DAMAGETYPE_MAGICAL)
                    RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                if (nParam == IP_CONST_DAMAGETYPE_MAGICAL)
                    RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                if (nParam == IP_CONST_DAMAGETYPE_MAGICAL)
                    RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_DAMAGE_REDUCTION:
                RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_SKILL_BONUS:
                if (nCost > 5)
                {
                    RemoveItemProperty(oEquipped, ipProperty);
                    ipProperty = ItemPropertySkillBonus(nSubType, 5);
                    gsIPAddItemProperty(oEquipped, ipProperty);
                }
                break;
            }
        }

        ipProperty = GetNextItemProperty(oEquipped);
    }

    //movement penalty
    int nAC      = gsCMGetItemBaseAC(oEquipped);
    int nPenalty = 0;

    switch (GetBaseItemType(oEquipped))
    {
    case BASE_ITEM_ARMOR:
        if (nAC >= 6)      nPenalty = 30;
        else if (nAC >= 4) nPenalty = 15;
        break;
    }

    if (nPenalty)
    {
        AssignCommand(
            oEquipped,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                ExtraordinaryEffect(
                    EffectMovementSpeedDecrease(nPenalty)),
                oEquippedBy));
        SendMessageToPC(
            oEquippedBy,
            gsCMReplaceString(
                GS_T_16777419,
                IntToString(nPenalty)));
    }
}
