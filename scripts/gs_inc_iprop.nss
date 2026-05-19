/* ITEM PROPERTY Library by Gigaschatten */

//void main() {}

const int GS_IP_LIMIT = 250;
const int GS_IP_STOP  =  20;

//buffer tables from 2da on oObject
void gsIPInitialize(object oObject = OBJECT_SELF);
//return id of sTable on oObject
int gsIPGetTableID(string sTable, object oObject = OBJECT_SELF);
//register sTable to oObject and return index
int gsIPRegisterTable(string sTable, object oObject = OBJECT_SELF);
//add nValue to nTableID at row sID/column sName on oObject and return new row id
int gsIPAddValue(int nTableID, string sName, int nValue, object oObject = OBJECT_SELF);
//set nValue in nTableID at row sID/column sName on oObject
void gsIPSetValue(int nTableID, int nID, string sName, int nValue, object oObject = OBJECT_SELF);
//return value from nTableID at row sID/column sName on oObject
int gsIPGetValue(int nTableID, int nID, string sName, object oObject = OBJECT_SELF);
//set number of entries in nTableID on oObject
void gsIPSetCount(int nTableID, int nCount, object oObject = OBJECT_SELF);
//return number of entries in nTableID on oObject
int gsIPGetCount(int nTableID, object oObject = OBJECT_SELF);
//load item property cost table on oObject
void gsIPLoadCostTable(object oObject = OBJECT_SELF);
//internally used
int _gsIPLoadCostTable(string sTable, object oObject = OBJECT_SELF);
//return table id of cost reference nResRef on oObject
int gsIPGetCostTableID(int nResRef, object oObject = OBJECT_SELF);
//load item property param table on oObject
void gsIPLoadParamTable(object oObject = OBJECT_SELF);
//internally used
int _gsIPLoadParamTable(string sTable, object oObject = OBJECT_SELF);
//return table id of param reference nResRef on oObject
int gsIPGetParamTableID(int nResRef, object oObject = OBJECT_SELF);
//load item property param on oObject
void gsIPLoadPropertyTable(object oObject = OBJECT_SELF);
//internally used
int _gsIPLoadPropertyTable(string sTable, object oObject = OBJECT_SELF);
//load item category table on oObject
void gsIPLoadItemCategoryTable(object oObject = OBJECT_SELF);
//return item category of nBaseItemType on oObject
int gsIPGetItemCategory(int nBaseItemType, object oObject = OBJECT_SELF);
//load item property validation table on oObject
void gsIPLoadValidationTable(object oObject = OBJECT_SELF);
//return TRUE if nProperty can be added to oItem on oObject
int gsIPGetIsValid(object oItem, int nProperty, object oObject = OBJECT_SELF);
//load appearance table sTable for nArmorPart on oObject
void gsIPLoadAppearanceTable(string sTable, int nArmorPart, object oObject = OBJECT_SELF);
//internally used
int _gsIPLoadAppearanceTable(string sTable, object oObject = OBJECT_SELF);
//return table id of nArmorPart on oObject
int gsIPGetAppearanceTableID(int nArmorPart, object oObject = OBJECT_SELF);
//return armor class of appearance nValue from table nTableID on oObject
int gsIPGetAppearanceAC(int nTableID, int nValue, object oObject = OBJECT_SELF);
//return cost for adding ipProperty to oItem, return -1 on error
int gsIPGetCost(object oItem, itemproperty ipProperty);
//return itemproperty specified by nProperty, nSubType, nCostValue and nParam1Value
itemproperty gsIPGetItemProperty(int nProperty, int nSubType = 0, int nCostValue = 0, int nParam1Value = 0);
//add ipProperty to oItem for fDuration
void gsIPAddItemProperty(object oItem, itemproperty ipProperty, float fDuration = 0.0, int nSingleSubTypeOnly = FALSE);
//add ipProperty to oItem for fDuration, allows only one physical and one elemental damage type of same duration type
void gsIPAddDamageBonus(object oItem, itemproperty ipProperty, float fDuration = 0.0);
//remove all properties on oItem
void gsIPRemoveAllProperties(object oItem);

void gsIPInitialize(object oObject = OBJECT_SELF)
{
    gsIPLoadCostTable(oObject);
    gsIPLoadParamTable(oObject);
    gsIPLoadPropertyTable(oObject);
    gsIPLoadItemCategoryTable(oObject);
    gsIPLoadValidationTable(oObject);
}
//----------------------------------------------------------------
int gsIPGetTableID(string sTable, object oObject = OBJECT_SELF)
{
    return GetLocalInt(oObject, "GS_IP_ID_" + sTable);
}
//----------------------------------------------------------------
int gsIPRegisterTable(string sTable, object oObject = OBJECT_SELF)
{
    int nTableID = gsIPGetTableID(sTable, oObject);

    if (nTableID) return nTableID; //already registered

    nTableID     = GetLocalInt(oObject, "GS_IP_ID_COUNT") + 1;

    SetLocalInt(oObject, "GS_IP_ID_" + sTable, nTableID);
    SetLocalInt(oObject, "GS_IP_ID_COUNT", nTableID);

    return nTableID;
}
//----------------------------------------------------------------
int gsIPAddValue(int nTableID, string sName, int nValue, object oObject = OBJECT_SELF)
{
    int nCount = gsIPGetCount(nTableID, oObject);

    SetLocalInt(oObject,
                "GS_IP_" +
                IntToString(nTableID) + "_" +
                IntToString(nCount) + "_" +
                sName,
                nValue);

    gsIPSetCount(nTableID, nCount + 1, oObject);
    return nCount;
}
//----------------------------------------------------------------
void gsIPSetValue(int nTableID, int nID, string sName, int nValue, object oObject = OBJECT_SELF)
{
    if (nID >= gsIPGetCount(nTableID, oObject)) return;

    SetLocalInt(oObject,
                "GS_IP_" +
                IntToString(nTableID) + "_" +
                IntToString(nID) + "_" +
                sName,
                nValue);
}
//----------------------------------------------------------------
int gsIPGetValue(int nTableID, int nID, string sName, object oObject = OBJECT_SELF)
{
    return GetLocalInt(oObject,
                       "GS_IP_" +
                       IntToString(nTableID) + "_" +
                       IntToString(nID) + "_" +
                       sName);
}
//----------------------------------------------------------------
void gsIPSetCount(int nTableID, int nCount, object oObject = OBJECT_SELF)
{
    SetLocalInt(oObject, "GS_IP_" + IntToString(nTableID) + "_COUNT", nCount);
}
//----------------------------------------------------------------
int gsIPGetCount(int nTableID, object oObject = OBJECT_SELF)
{
    return GetLocalInt(oObject, "GS_IP_" + IntToString(nTableID) + "_COUNT");
}
//----------------------------------------------------------------
void gsIPLoadCostTable(object oObject = OBJECT_SELF)
{
    string sString = "";
    int nCount     = 0;
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString("iprp_costtable", "Name", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount = 0;

            if (Get2DAString("iprp_costtable", "GS_IP_DISABLED", nNth) == "TRUE") continue;

            SetLocalInt(oObject,
                        "GS_IP_C" + IntToString(nNth),
                        _gsIPLoadCostTable(sString, oObject));
        }
    }
}
//----------------------------------------------------------------
int _gsIPLoadCostTable(string sTable, object oObject = OBJECT_SELF)
{
    sTable         = GetStringLowerCase(sTable);
    int nTableID   = gsIPGetTableID(sTable, oObject);

    if (nTableID) return nTableID;

    nTableID       = gsIPRegisterTable(sTable, oObject);

    string sString = "";
    int nID        = 0;
    int nCount     = 0;
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString(sTable, "Name", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount = 0;

            if (Get2DAString(sTable, "GS_IP_DISABLED", nNth) == "TRUE") continue;

            nID    = gsIPAddValue(nTableID, "ID", nNth, oObject);
            gsIPSetValue(nTableID, nID, "STRREF", StringToInt(sString), oObject);
        }
    }

    return nTableID;
}
//----------------------------------------------------------------
int gsIPGetCostTableID(int nResRef, object oObject = OBJECT_SELF)
{
     return GetLocalInt(oObject, "GS_IP_C" + IntToString(nResRef));
}
//----------------------------------------------------------------
void gsIPLoadParamTable(object oObject = OBJECT_SELF)
{
    string sString = "";
    int nCount     = 0;
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString("iprp_paramtable", "TableResRef", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount = 0;

            if (Get2DAString("iprp_paramtable", "GS_IP_DISABLED", nNth) == "TRUE") continue;

            SetLocalInt(oObject,
                        "GS_IP_P" + IntToString(nNth),
                        _gsIPLoadParamTable(sString, oObject));
        }
    }
}
//----------------------------------------------------------------
int _gsIPLoadParamTable(string sTable, object oObject = OBJECT_SELF)
{
    sTable         = GetStringLowerCase(sTable);
    int nTableID   = gsIPGetTableID(sTable, oObject);

    if (nTableID) return nTableID;

    nTableID       = gsIPRegisterTable(sTable, oObject);

    string sString = "";
    int nID        = 0;
    int nCount     = 0;
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString(sTable, "Name", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount = 0;

            if (Get2DAString(sTable, "GS_IP_DISABLED", nNth) == "TRUE") continue;

            nID    = gsIPAddValue(nTableID, "ID", nNth, oObject);
            gsIPSetValue(nTableID, nID, "STRREF", StringToInt(sString), oObject);
        }
    }

    return nTableID;
}
//----------------------------------------------------------------
int gsIPGetParamTableID(int nResRef, object oObject = OBJECT_SELF)
{
     return GetLocalInt(oObject, "GS_IP_P" + IntToString(nResRef));
}
//----------------------------------------------------------------
void gsIPLoadPropertyTable(object oObject = OBJECT_SELF)
{
    int nTableID   = gsIPGetTableID("itempropdef", oObject);

    if (nTableID) return;

    nTableID       = gsIPRegisterTable("itempropdef", oObject);

    string sString = "";
    int nID        = 0;
    int nCount     = 0;
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString("itempropdef", "Name", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount  = 0;

            if (Get2DAString("itempropdef", "GS_IP_DISABLED", nNth) == "TRUE") continue;

            nID     = gsIPAddValue(nTableID, "ID", nNth, oObject);
            gsIPSetValue(nTableID, nID, "STRREF", StringToInt(sString), oObject);

            sString = Get2DAString("itempropdef", "SubTypeResRef", nNth);

            if (sString != "")
            {
                gsIPSetValue(nTableID,
                             nID,
                             "SUBREF",
                             _gsIPLoadPropertyTable(sString, oObject),
                             oObject);
            }

            sString = Get2DAString("itempropdef", "CostTableResRef", nNth);

            if (sString != "")
            {
                gsIPSetValue(nTableID,
                             nID,
                             "COSREF",
                             gsIPGetCostTableID(StringToInt(sString), oObject),
                             oObject);
            }

            sString = Get2DAString("itempropdef", "Param1ResRef", nNth);

            if (sString != "")
            {
                gsIPSetValue(nTableID,
                             nID,
                             "PARREF",
                             gsIPGetParamTableID(StringToInt(sString), oObject),
                             oObject);
            }
        }
    }
}
//----------------------------------------------------------------
int _gsIPLoadPropertyTable(string sTable, object oObject = OBJECT_SELF)
{
    sTable         = GetStringLowerCase(sTable);
    int nTableID   = gsIPGetTableID(sTable, oObject);

    if (nTableID) return nTableID;

    nTableID       = gsIPRegisterTable(sTable, oObject);

    string sString = "";
    int nCount     = 0;
    int nID        = 0;
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString(sTable, "Name", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount  = 0;

            if (Get2DAString(sTable, "GS_IP_DISABLED", nNth) == "TRUE") continue;

            nID     = gsIPAddValue(nTableID, "ID", nNth, oObject);
            gsIPSetValue(nTableID, nID, "STRREF", StringToInt(sString), oObject);

            sString = Get2DAString(sTable, "Param1ResRef", nNth);

            if (sString != "")
            {
                gsIPSetValue(nTableID,
                             nID,
                             "PARREF",
                             gsIPGetParamTableID(StringToInt(sString), oObject),
                             oObject);
            }
        }
    }

    return nTableID;
}
//----------------------------------------------------------------
void gsIPLoadItemCategoryTable(object oObject = OBJECT_SELF)
{
    string sString = "";
    int nID        = 0;
    int nCount     = 0;

    for (nID = 0; nID < GS_IP_LIMIT; nID++)
    {
        switch (nID)
        {
        case BASE_ITEM_ARMOR:
            sString = "3";
            break;

        case BASE_ITEM_MAGICSTAFF:
            sString = "100";
            break;

        case BASE_ITEM_MAGICROD:
            sString = "101";
            break;

        case BASE_ITEM_CREATUREITEM:
            sString = "102";
            break;

        case BASE_ITEM_CPIERCWEAPON:
        case BASE_ITEM_CSLASHWEAPON:
        case BASE_ITEM_CSLSHPRCWEAP:
            sString = "103";
            break;

        case BASE_ITEM_LARGEBOX:
            sString = "104";
            break;

        case BASE_ITEM_GLOVES:
            sString = "105";
            break;

        default:
            sString = Get2DAString("baseitems", "Category", nID);
        }

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            SetLocalInt(oObject,
                        "GS_IP_IC_" + IntToString(nID),
                        StringToInt(sString));

            nCount = 0;
        }
    }
}
//----------------------------------------------------------------
int gsIPGetItemCategory(int nBaseItemType, object oObject = OBJECT_SELF)
{
    return GetLocalInt(oObject, "GS_IP_IC_" + IntToString(nBaseItemType));
}
//----------------------------------------------------------------
void gsIPLoadValidationTable(object oObject = OBJECT_SELF)
{
    string sTable  = "itemprops";
    string sName   = "";
    string sString = "";
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sName   = "GS_IP_V_" + IntToString(nNth) + "_";

        sString = Get2DAString(sTable, "0_Melee", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "1",   TRUE);
        sString = Get2DAString(sTable, "1_Ranged", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "2",   TRUE);
        sString = Get2DAString(sTable, "2_Thrown", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "7",   TRUE);
        sString = Get2DAString(sTable, "3_Staves", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "100", TRUE);
        sString = Get2DAString(sTable, "4_Rods", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "101", TRUE);
        sString = Get2DAString(sTable, "5_Ammo", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "6",   TRUE);
        sString = Get2DAString(sTable, "6_Arm_Shld", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "3",   TRUE);
        sString = Get2DAString(sTable, "7_Helm", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "5",   TRUE);
        sString = Get2DAString(sTable, "8_Potions", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "9",   TRUE);
        sString = Get2DAString(sTable, "9_Scrolls", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "10",  TRUE);
        sString = Get2DAString(sTable, "10_Wands", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "8",   TRUE);
        sString = Get2DAString(sTable, "11_Thieves", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "11",  TRUE);
        sString = Get2DAString(sTable, "12_TrapKits", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "15",  TRUE);
        sString = Get2DAString(sTable, "13_Hide", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "102", TRUE);
        sString = Get2DAString(sTable, "14_Claw", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "103", TRUE);
        sString = Get2DAString(sTable, "15_Misc_Uneq", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "16",  TRUE);
        sString = Get2DAString(sTable, "16_Misc", nNth);
        if (sString != "")
        {
            SetLocalInt(oObject, sName + "4", TRUE);
            SetLocalInt(oObject, sName + "12", TRUE);
        }
        sString = Get2DAString(sTable, "17_No_Props", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "17",  TRUE);
        sString = Get2DAString(sTable, "18_Containers", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "104", TRUE);
        sString = Get2DAString(sTable, "19_HealerKit", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "19",  TRUE);
        sString = Get2DAString(sTable, "20_Torch", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "20",  TRUE);
        sString = Get2DAString(sTable, "21_Glove", nNth);
        if (sString != "") SetLocalInt(oObject, sName + "105", TRUE);
    }
}
//----------------------------------------------------------------
int gsIPGetIsValid(object oItem, int nProperty, object oObject = OBJECT_SELF)
{
    int nBaseItemType = GetBaseItemType(oItem);
    int nItemCategory = gsIPGetItemCategory(nBaseItemType, oObject);

    return GetLocalInt(oObject,
                       "GS_IP_V_" +
                       IntToString(nProperty) + "_" +
                       IntToString(nItemCategory));
}
//----------------------------------------------------------------
void gsIPLoadAppearanceTable(string sTable, int nArmorPart, object oObject = OBJECT_SELF)
{
    if (gsIPGetAppearanceTableID(nArmorPart)) return;

    SetLocalInt(oObject,
                "GS_IP_A" + IntToString(nArmorPart),
                _gsIPLoadAppearanceTable(sTable, oObject));
}
//----------------------------------------------------------------
int _gsIPLoadAppearanceTable(string sTable, object oObject = OBJECT_SELF)
{
    sTable         = GetStringLowerCase(sTable);
    int nTableID   = gsIPGetTableID(sTable, oObject);

    if (nTableID) return nTableID;

    nTableID       = gsIPRegisterTable(sTable, oObject);

    string sString = "";
    int nCount     = 0;
    int nID        = 0;
    int nNth       = 0;
    int nAC        = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString(sTable, "ACBONUS", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nID     = gsIPAddValue(nTableID, "ID", nNth, oObject);
            nAC     = StringToInt(sString);

            gsIPSetValue(nTableID, nID, "AC", nAC, oObject);
            SetLocalInt(oObject,
                        "GS_IP_AC_" +
                        IntToString(nTableID) + "_" +
                        IntToString(nNth),
                        nAC);

            nCount = 0;
        }
    }

    return nTableID;
}
//----------------------------------------------------------------
int gsIPGetAppearanceTableID(int nArmorPart, object oObject = OBJECT_SELF)
{
    return GetLocalInt(oObject, "GS_IP_A" + IntToString(nArmorPart));
}
//----------------------------------------------------------------
int gsIPGetAppearanceAC(int nTableID, int nValue, object oObject = OBJECT_SELF)
{
    return GetLocalInt(oObject,
                       "GS_IP_AC_" +
                       IntToString(nTableID) + "_" +
                       IntToString(nValue));
}
//----------------------------------------------------------------
int gsIPGetCost(object oItem, itemproperty ipProperty)
{
    object oCopy = CopyObject(oItem, GetLocation(oItem));

    if (GetIsObjectValid(oCopy))
    {
        SetPlotFlag(oCopy, FALSE);
        SetIdentified(oCopy, TRUE);

        int nCost = GetGoldPieceValue(oCopy);
        gsIPAddItemProperty(oCopy, ipProperty);
        nCost     = GetGoldPieceValue(oCopy) - nCost;

        DestroyObject(oCopy);

        return nCost;
    }

    return -1;
}
//----------------------------------------------------------------
itemproperty gsIPGetItemProperty(int nProperty, int nSubType = 0, int nCostValue = 0, int nParam1Value = 0)
{
    itemproperty ipProperty;

    switch (nProperty)
    {
    case 0:
        ipProperty = ItemPropertyAbilityBonus(nSubType, nCostValue);
        break;

    case 1:
        ipProperty = ItemPropertyACBonus(nCostValue);
        break;

    case 2:
        ipProperty = ItemPropertyACBonusVsAlign(nSubType, nCostValue);
        break;

    case 3:
        ipProperty = ItemPropertyACBonusVsDmgType(nSubType, nCostValue);
        break;

    case 4:
        ipProperty = ItemPropertyACBonusVsRace(nSubType, nCostValue);
        break;

    case 5:
        ipProperty = ItemPropertyACBonusVsSAlign(nSubType, nCostValue);
        break;

    case 6:
        ipProperty = ItemPropertyEnhancementBonus(nCostValue);
        break;
    case 7:
        ipProperty = ItemPropertyEnhancementBonusVsAlign(nSubType, nCostValue);
        break;

    case 8:
        ipProperty = ItemPropertyEnhancementBonusVsRace(nSubType, nCostValue);
        break;

    case 9:
        ipProperty = ItemPropertyEnhancementBonusVsSAlign(nSubType, nCostValue);
        break;

    case 10:
        ipProperty = ItemPropertyAttackPenalty(nCostValue);
        break;

    case 11:
        ipProperty = ItemPropertyWeightReduction(nCostValue);
        break;

    case 12:
        ipProperty = ItemPropertyBonusFeat(nSubType);
        break;

    case 13:
        ipProperty = ItemPropertyBonusLevelSpell(nSubType, nCostValue);
        break;

    case 14:
        break;

    case 15:
        ipProperty = ItemPropertyCastSpell(nSubType, nCostValue);
        break;

    case 16:
        ipProperty = ItemPropertyDamageBonus(nSubType, nCostValue);
        break;

    case 17:
        ipProperty = ItemPropertyDamageBonusVsAlign(nSubType, nParam1Value, nCostValue);
        break;

    case 18:
        ipProperty = ItemPropertyDamageBonusVsRace(nSubType, nParam1Value, nCostValue);
        break;

    case 19:
        ipProperty = ItemPropertyDamageBonusVsSAlign(nSubType, nParam1Value, nCostValue);
        break;

    case 20:
        ipProperty = ItemPropertyDamageImmunity(nSubType, nCostValue);
        break;

    case 21:
        ipProperty = ItemPropertyDamagePenalty(nCostValue);
        break;

    case 22:
        ipProperty = ItemPropertyDamageReduction(nSubType, nCostValue);
        break;

    case 23:
        ipProperty = ItemPropertyDamageResistance(nSubType, nCostValue);
        break;

    case 24:
        ipProperty = ItemPropertyDamageVulnerability(nSubType, nCostValue);
        break;

    case 25:
        break;

    case 26:
        ipProperty = ItemPropertyDarkvision();
        break;

    case 27:
        ipProperty = ItemPropertyDecreaseAbility(nSubType, nCostValue);
        break;

    case 28:
        ipProperty = ItemPropertyDecreaseAC(nSubType, nCostValue);
        break;

    case 29:
        ipProperty = ItemPropertyDecreaseSkill(nSubType, nCostValue);
        break;

    case 30:
        break;

    case 31:
        break;

    case 32:
        ipProperty = ItemPropertyContainerReducedWeight(nCostValue);
        break;

    case 33:
        ipProperty = ItemPropertyExtraMeleeDamageType(nSubType);
        break;

    case 34:
        ipProperty = ItemPropertyExtraRangeDamageType(nSubType);
        break;

    case 35:
        ipProperty = ItemPropertyHaste();
        break;

    case 36:
        ipProperty = ItemPropertyHolyAvenger();
        break;

    case 37:
        ipProperty = ItemPropertyImmunityMisc(nSubType);
        break;

    case 38:
        ipProperty = ItemPropertyImprovedEvasion();
        break;

    case 39:
        ipProperty = ItemPropertyBonusSpellResistance(nCostValue);
        break;

    case 40:
        ipProperty = ItemPropertyBonusSavingThrowVsX(nSubType, nCostValue);
        break;

    case 41:
        ipProperty = ItemPropertyBonusSavingThrow(nSubType, nCostValue);
        break;

    case 42:
        break;

    case 43:
        ipProperty = ItemPropertyKeen();
        break;

    case 44:
        ipProperty = ItemPropertyLight(nCostValue, nParam1Value);
        break;

    case 45:
        ipProperty = ItemPropertyMaxRangeStrengthMod(nCostValue);
        break;

    case 46:
        break;

    case 47:
        ipProperty = ItemPropertyNoDamage();
        break;

    case 48:
        ipProperty = ItemPropertyOnHitProps(nSubType, nCostValue, nParam1Value);
        break;

    case 49:
        ipProperty = ItemPropertyReducedSavingThrowVsX(nSubType, nCostValue);
        break;

    case 50:
        ipProperty = ItemPropertyReducedSavingThrow(nSubType, nCostValue);
        break;

    case 51:
        ipProperty = ItemPropertyRegeneration(nCostValue);
        break;

    case 52:
        ipProperty = ItemPropertySkillBonus(nSubType, nCostValue);
        break;

    case 53:
        ipProperty = ItemPropertySpellImmunitySpecific(nCostValue);
        break;

    case 54:
        ipProperty = ItemPropertySpellImmunitySchool(nSubType);
        break;

    case 55:
        ipProperty = ItemPropertyThievesTools(nCostValue);
        break;

    case 56:
        ipProperty = ItemPropertyAttackBonus(nCostValue);
        break;

    case 57:
        ipProperty = ItemPropertyAttackBonusVsAlign(nSubType, nCostValue);
        break;

    case 58:
        ipProperty = ItemPropertyAttackBonusVsRace(nSubType, nCostValue);
        break;

    case 59:
        ipProperty = ItemPropertyAttackBonusVsSAlign(nSubType, nCostValue);
        break;

    case 60:
        ipProperty = ItemPropertyAttackPenalty(nCostValue);
        break;

    case 61:
        ipProperty = ItemPropertyUnlimitedAmmo(nCostValue);
        break;

    case 62:
        ipProperty = ItemPropertyLimitUseByAlign(nSubType);
        break;

    case 63:
        ipProperty = ItemPropertyLimitUseByClass(nSubType);
        break;

    case 64:
        ipProperty = ItemPropertyLimitUseByRace(nSubType);
        break;

    case 65:
        ipProperty = ItemPropertyLimitUseBySAlign(nSubType);
        break;

    case 66:
        break;

    case 67:
        ipProperty = ItemPropertyVampiricRegeneration(nCostValue);
        break;

    case 68:
        break;

    case 69:
        break;

    case 70:
        ipProperty = ItemPropertyTrap(nSubType, nCostValue);
        break;

    case 71:
        ipProperty = ItemPropertyTrueSeeing();
        break;

    case 72:
        ipProperty = ItemPropertyOnMonsterHitProperties(nSubType, nParam1Value);
        break;

    case 73:
        ipProperty = ItemPropertyTurnResistance(nCostValue);
        break;

    case 74:
        ipProperty = ItemPropertyMassiveCritical(nCostValue);
        break;

    case 75:
        ipProperty = ItemPropertyFreeAction();
        break;

    case 76:
        break;

    case 77:
        ipProperty = ItemPropertyMonsterDamage(nCostValue);
        break;

    case 78:
        ipProperty = ItemPropertyImmunityToSpellLevel(nCostValue + 1);
        break;

    case 79:
        ipProperty = ItemPropertySpecialWalk(nSubType);
        break;

    case 80:
        ipProperty = ItemPropertyHealersKit(nCostValue);
        break;

    case 81:
        ipProperty = ItemPropertyWeightIncrease(nParam1Value);
        break;

    case 82:
        ipProperty = ItemPropertyOnHitCastSpell(nSubType, nCostValue + 1);
        break;

    case 83:
        ipProperty = ItemPropertyVisualEffect(nSubType);
        break;

    case 84:
        ipProperty = ItemPropertyArcaneSpellFailure(nCostValue);
        break;
    }

    return ipProperty;
}
//----------------------------------------------------------------
void gsIPAddItemProperty(object oItem, itemproperty ipProperty, float fDuration = 0.0, int nSingleSubTypeOnly = FALSE)
{
    int nType         = GetItemPropertyType(ipProperty);
    int nSubType      = GetItemPropertySubType(ipProperty);
    int nDurationType = 0;

    itemproperty _ipProperty = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(_ipProperty))
    {
        nDurationType = GetItemPropertyDurationType(_ipProperty);

        if (((nDurationType == DURATION_TYPE_PERMANENT && fDuration == 0.0) ||
             (nDurationType == DURATION_TYPE_TEMPORARY && fDuration > 0.0)) &&
            GetItemPropertyType(_ipProperty) == nType &&
            (nSingleSubTypeOnly ||
             nSubType == -1 ||
             GetItemPropertySubType(_ipProperty) == nSubType))
        {
            RemoveItemProperty(oItem, _ipProperty);
        }

        _ipProperty = GetNextItemProperty(oItem);
    }

    AddItemProperty(
        fDuration == 0.0 ? DURATION_TYPE_PERMANENT : DURATION_TYPE_TEMPORARY,
        ipProperty,
        oItem,
        fDuration);
}
//----------------------------------------------------------------
void gsIPAddDamageBonus(object oItem, itemproperty ipProperty, float fDuration = 0.0)
{
    int nType1         = GetItemPropertyType(ipProperty);
    int nSubType1      = GetItemPropertySubType(ipProperty);
    int nDurationType1 = fDuration == 0.0 ? DURATION_TYPE_PERMANENT : DURATION_TYPE_TEMPORARY;
    int nPhysical1     = nSubType1 == IP_CONST_DAMAGETYPE_BLUDGEONING ||
                         nSubType1 == IP_CONST_DAMAGETYPE_PIERCING ||
                         nSubType1 == IP_CONST_DAMAGETYPE_SLASHING;
    int nType2         = 0;
    int nSubType2      = 0;
    int nDurationType2 = 0;
    int nPhysical2     = 0;

    itemproperty _ipProperty = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(_ipProperty))
    {
        nType2         = GetItemPropertyType(_ipProperty);
        nSubType2      = GetItemPropertySubType(_ipProperty);
        nDurationType2 = GetItemPropertyDurationType(_ipProperty);
        nPhysical2     = nSubType2 == IP_CONST_DAMAGETYPE_BLUDGEONING ||
                         nSubType2 == IP_CONST_DAMAGETYPE_PIERCING ||
                         nSubType2 == IP_CONST_DAMAGETYPE_SLASHING;

        if (nType2 == nType1 &&
            nDurationType2 == nDurationType1 &&
            nPhysical2 == nPhysical1)
        {
            RemoveItemProperty(oItem, _ipProperty);
        }

        _ipProperty = GetNextItemProperty(oItem);
    }

    AddItemProperty(nDurationType1, ipProperty, oItem, fDuration);
}
//----------------------------------------------------------------
void gsIPRemoveAllProperties(object oItem)
{
    itemproperty ipProperty = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ipProperty))
    {
        RemoveItemProperty(oItem, ipProperty);
        ipProperty = GetNextItemProperty(oItem);
    }
}
