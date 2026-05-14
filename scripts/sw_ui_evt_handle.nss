#include "nw_inc_nui"
#include "x3_inc_string"
#include "sw_inc_json"

float GetRangeForSpell(int iSpellId)
{
    string sRange = Get2DAString("spells", "Range", iSpellId);
    float fRange = 0.0f;
    
    if(sRange == "T" )
    {
        fRange = StringToFloat(Get2DAString("ranges", "PrimaryRange", 1));
    }
    else if(sRange == "S" )
    {
        fRange = StringToFloat(Get2DAString("ranges", "PrimaryRange", 2));
    }
    else if(sRange == "M" )
    {
        fRange = StringToFloat(Get2DAString("ranges", "PrimaryRange", 3));
    }
    else if(sRange == "L" )
    {
        fRange = StringToFloat(Get2DAString("ranges", "PrimaryRange", 4));
    }

    return fRange;
}

void SetTargetModeForSpell(object oPlayer, int iSpellId)
{
    string shape = Get2DAString("spells", "TargetShape", iSpellId);
    float fRange = GetRangeForSpell(iSpellId);
    float fTargetX = StringToFloat(Get2DAString("spells", "TargetSizeX", iSpellId));
    float fTargetY = StringToFloat(Get2DAString("spells", "TargetSizeY", iSpellId));
    int iTargetFlags = StringToInt(Get2DAString("spells", "TargetFlags", iSpellId));
    

    int iShape = SPELL_TARGETING_SHAPE_NONE;

    if(shape == "sphere")
    {
        iShape = SPELL_TARGETING_SHAPE_SPHERE;
    }
    else if (shape == "rectangle")
    {
        iShape = SPELL_TARGETING_SHAPE_RECT;
    }
    else if (shape == "cone")
    {
        iShape = SPELL_TARGETING_SHAPE_CONE;
    }
    else if (shape == "hsphere")
    {
        iShape = SPELL_TARGETING_SHAPE_HSPHERE;
    }
    //FloatingTextStringOnCreature("Shape: " + IntToString(iShape) + " Target X: " + FloatToString(fTargetX) + " Target Y: " + FloatToString(fTargetY) + " Flags: " + IntToString(iTargetFlags), oPlayer, FALSE);
    SetEnterTargetingModeData(oPlayer, iShape, fTargetX, fTargetY, iTargetFlags, fRange, iSpellId);
}

void CastOrTarget(object oPlayer, int iSpellId, int iSpellLevel, int iMetamagic, int iTargetType, int bDomain)
{
    if ((iTargetType & 0x01) && !(iTargetType & 0x02) && !(iTargetType & 0x04))
    {
        int iDomainLevel = 0;
        if (bDomain)
        {
            iDomainLevel = GetLevelBeforeMetaMagic(iSpellLevel, iMetamagic);
        }
        AssignCommand(oPlayer, ActionCastSpellAtObject(iSpellId, oPlayer, iMetamagic, FALSE, iDomainLevel));

        DeleteLocalInt(oPlayer, SW_CAST_SPELL_ID);
        DeleteLocalInt(oPlayer, SW_CAST_METAMAGIC);
        DeleteLocalInt(oPlayer, SW_CAST_TARGETTYPE);
        DeleteLocalInt(oPlayer, SW_CAST_SPELL_LEVEL);
        DeleteLocalInt(oPlayer, SW_CAST_IS_DOMAIN);
    }
    else
    {
        int iValidObjects = 0;

        if ((iTargetType & 0x01) || (iTargetType & 0x02))
        {
            iValidObjects += OBJECT_TYPE_CREATURE;
        }
        if (iTargetType & 0x04)
        {
            iValidObjects += OBJECT_TYPE_TILE;
        }
        if (iTargetType & 0x08)
        {
            iValidObjects += OBJECT_TYPE_ITEM;
        }
        if (iTargetType & 0x10)
        {
            iValidObjects += OBJECT_TYPE_DOOR;
        }
        if (iTargetType & 0x20)
        {
            iValidObjects += OBJECT_TYPE_PLACEABLE;
        }
        SetTargetModeForSpell(oPlayer, iSpellId);
        EnterTargetingMode(oPlayer, iValidObjects);
    }
}

void HandleSpellWidgetEvent()
{
    object oPlayer = NuiGetEventPlayer();
    int    nToken  = NuiGetEventWindow();
    string sEvent  = NuiGetEventType();
    string sElem   = NuiGetEventElement();
    int    nIdx    = NuiGetEventArrayIndex();
    string sWndId  = NuiGetWindowId(oPlayer, nToken);

    if(sWndId == "spellwidget")
    {
        if (sEvent == "click")
        {

            string firstPart = StringParse(sElem, ".");
            string remaining = StringRemoveParsed(sElem, firstPart, ".");
            int iSpellId = StringToInt(StringParse(remaining, "."));
            remaining = StringRemoveParsed(remaining, IntToString(iSpellId), ".");
            int iMetamagic = StringToInt(StringParse(remaining, "."));
            remaining = StringRemoveParsed(remaining, IntToString(iMetamagic), ".");
            int iSpellLevel = StringToInt(StringParse(remaining, "."));
            remaining = StringRemoveParsed(remaining, IntToString(iSpellLevel), ".");
            int bDomain = StringToInt(StringParse(remaining, "."));
            remaining = StringRemoveParsed(remaining, IntToString(bDomain), ".");

            string sBindKey = firstPart + "." + IntToString(iSpellId) + "."
                    + IntToString(iMetamagic) + "."
                    + IntToString(iSpellLevel) + ".enabled";

            string sTargetType = Get2DAString("spells", "TargetType", iSpellId);
            int iTargetType = HexToInt(sTargetType);

            int iSubRadial1 = StringToInt(Get2DAString("spells", "SubRadSpell1", iSpellId));


            SetLocalInt(oPlayer, SW_CAST_SPELL_ID, iSpellId);
            SetLocalInt(oPlayer, SW_CAST_METAMAGIC, iMetamagic);
            SetLocalInt(oPlayer, SW_CAST_TARGETTYPE, iTargetType);
            SetLocalInt(oPlayer, SW_CAST_SPELL_LEVEL, iSpellLevel);
            SetLocalInt(oPlayer, SW_CAST_IS_DOMAIN, bDomain);
            SetLocalString(oPlayer, SW_CAST_BIND_KEY, sBindKey);

            if (iSubRadial1 > 0)
            {
                int iSubRadial2 = StringToInt(Get2DAString("spells", "SubRadSpell2", iSpellId));
                int iSubRadial3 = StringToInt(Get2DAString("spells", "SubRadSpell3", iSpellId));
                int iSubRadial4 = StringToInt(Get2DAString("spells", "SubRadSpell4", iSpellId));
                int iSubRadial5 = StringToInt(Get2DAString("spells", "SubRadSpell5", iSpellId));
                int iSubRadial6 = StringToInt(Get2DAString("spells", "SubRadSpell6", iSpellId));
                int iSubRadial7 = StringToInt(Get2DAString("spells", "SubRadSpell7", iSpellId));
                int iSubRadial8 = StringToInt(Get2DAString("spells", "SubRadSpell8", iSpellId));

                MakeSubRadialWindow(oPlayer, iSubRadial1, iSubRadial2, iSubRadial3, iSubRadial4,
                    iSubRadial5, iSubRadial6, iSubRadial7, iSubRadial8, GetSettings(oPlayer));
            }
            else
            {
                CastOrTarget(oPlayer, iSpellId, iSpellLevel, iMetamagic, iTargetType, bDomain);
            }
        }
        else if (sEvent == "watch")
        {
            if (sElem == "selected_class")
            {
                json jPayload = NuiGetBind(oPlayer, nToken, sElem);

                int iSelectedClass = JsonGetInt(jPayload);

                MakeSpellGui(oPlayer, iSelectedClass);
            }
            else if (GetStringLeft(sElem, 10) == "MetaMagic_")
            {
                json jPayload = NuiGetBind(oPlayer, nToken, "selected_class");

                int iSelectedClass = JsonGetInt(jPayload);

                string sMetaMagic = StringRemoveParsed(sElem, "MetaMagic", "_");

                int iActiveMetaMagic = 0;
                if (JsonGetInt(NuiGetBind(oPlayer, nToken, sElem)))
                {
                    iActiveMetaMagic = GetMetaMagicBitMask(StringToInt(sMetaMagic));
                }

                MakeSpellGui(oPlayer, iSelectedClass, iActiveMetaMagic);
            }
            else if(sElem == "geometry")
            {
                json jGeo = NuiGetBind(oPlayer, nToken, "geometry");

                float x = JsonGetFloat(JsonObjectGet(jGeo, "x"));
                float y = JsonGetFloat(JsonObjectGet(jGeo, "y"));

                float w = JsonGetFloat(JsonObjectGet(jGeo, "w"));
                float h = JsonGetFloat(JsonObjectGet(jGeo, "h"));
                json jClass = NuiGetBind(oPlayer, nToken, "selected_class");

                int iSelectedClass = JsonGetInt(jClass);

                SaveWidgetLocation(oPlayer, x, y);
                SaveWidgetSize(oPlayer, iSelectedClass, w, h);
            }
        }
        else if (sEvent == "close")
        {
            DeleteLocalInt(oPlayer, SW_CAST_WIN_TOKEN);
        }
    }
}

void HandleSubRadialWidgetEvent()
{
    object oPlayer = NuiGetEventPlayer();
    int    nToken  = NuiGetEventWindow();
    string sEvent  = NuiGetEventType();
    string sElem   = NuiGetEventElement();
    int    nIdx    = NuiGetEventArrayIndex();
    string sWndId  = NuiGetWindowId(oPlayer, nToken);

    if(sWndId == "subradialspells")
    {
        if (sEvent == "click")
        {
            string firstPart = StringParse(sElem, ".");
            int iSpellId = StringToInt(StringRemoveParsed(sElem, firstPart, "."));

            int iTargetType = GetLocalInt(oPlayer, SW_CAST_TARGETTYPE);
            int iMetamagic = GetLocalInt(oPlayer, SW_CAST_METAMAGIC);
            int iSpellLevel = GetLocalInt(oPlayer, SW_CAST_SPELL_LEVEL);
            int bDomain = GetLocalInt(oPlayer, SW_CAST_IS_DOMAIN);

            SetLocalInt(oPlayer, SW_CAST_SPELL_ID, iSpellId);

            CastOrTarget(oPlayer, iSpellId, iSpellLevel, iMetamagic, iTargetType, bDomain);

            NuiDestroy(oPlayer, nToken);
        }
        else if (sEvent == "watch" && sElem == "geometry")
        {
            json jGeo = NuiGetBind(oPlayer, nToken, "geometry");

            float x = JsonGetFloat(JsonObjectGet(jGeo, "x"));
            float y = JsonGetFloat(JsonObjectGet(jGeo, "y"));

            SaveSubradialLocation(oPlayer, x, y);
        }
    }
}

void HandleConfWindowEvents()
{
    object oPlayer = NuiGetEventPlayer();
    int    nToken  = NuiGetEventWindow();
    string sEvent  = NuiGetEventType();
    string sElem   = NuiGetEventElement();
    int    nIdx    = NuiGetEventArrayIndex();
    string sWndId  = NuiGetWindowId(oPlayer, nToken);

    if (sWndId == "sw_config_menu")
    {
        if (sEvent == "click")
        {
            if (sElem == "sw_conf_save_btn")
            {
                struct Settings settings;
                settings.fSpellButtonSize       = JsonGetFloat(NuiGetBind(oPlayer, nToken, "slider.spell_button_size"));
                settings.fMetamagicButtonSize   = JsonGetFloat(NuiGetBind(oPlayer, nToken, "slider.metamagic_button_size"));
                settings.fSubradialButtonSize   = JsonGetFloat(NuiGetBind(oPlayer, nToken, "slider.subradial_button_size"));
                settings.fMarginSize            = JsonGetFloat(NuiGetBind(oPlayer, nToken, "slider.margin_size"));
                settings.bResizable             = JsonGetInt(NuiGetBind(oPlayer, nToken, "checkbox.resizable"));

                SaveSettings(oPlayer, settings);
                NuiDestroy(oPlayer, nToken);
            }
            else if (sElem == "sw_conf_cancel_btn")
            {
                NuiDestroy(oPlayer, nToken);
            }
        }
        else if (sEvent == "watch")
        {
            if (GetStringLeft(sElem, 7) == "slider.")
            {
                float fNewSize = JsonGetFloat(NuiGetBind(oPlayer, nToken, sElem));

                NuiSetBind(oPlayer, nToken, sElem + ".label",
                        JsonString(FloatToString(fNewSize, 3, 1)));
            }
        }
    }
}

void main()
{
    HandleSpellWidgetEvent();
    HandleSubRadialWidgetEvent();
    HandleConfWindowEvents();

    RunOverride(SW_OVERRIDDEN_NUI_SCRIPT);
}
