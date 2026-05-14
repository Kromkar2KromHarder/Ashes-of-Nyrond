

struct ClassSpellData
{
    json jSpells;
    int iClassId;
    string sClassName;
    int iNumLevels;
    int iMaxSpellsPerLevel;
    int bSpellCaster;
    int bMemorizesSpells;
    json jBinds;
    json jTooltipBinds;
    json jSpellsPerDay;
    json jSpellData;
};

struct MetaMagicControls
{
    json jMetaMagic;
    json jBinds;
    int iNumFeats;
};

struct SpellData
{
    int iSpellId;
    int iMetamagic;
    int iSpellLevel;
    int bDomain;
    int iTimesMemorized;
    string sLabel;
};

struct Settings
{
    float fSpellButtonSize;
    float fMetamagicButtonSize;
    float fSubradialButtonSize;
    float fMarginSize;
    int bResizable;
};

const float SW_MIN_WIDGET_WIDTH = 100.0;

//GUI Icon sizes
const float SW_SPELL_ICON_SIZE      = 20.0f;
const float SW_METAMAGIC_BTN_SIZE   = 25.0f;
const float SW_SUBRADIAL_BTN_SIZE   = 50.0f;

//GUI String references
const int EMPOWER_STRREF    = 66762;
const int EXTEND_STRREF     = 66763;
const int MAXIMIZE_STRREF   = 66764;
const int QUICKEN_STRREF    = 66765;
const int SILENT_STRREF     = 66766;
const int STILL_STRREF      = 66767;
const int SPELLS_STRREF     = 2295; //7038 for Spellbook

//Spell casting stored variables
const string SW_CAST_WIN_TOKEN   = "sw_cast_win_token";
const string SW_CAST_SPELL_ID    = "sw_cast_spell_id";
const string SW_CAST_METAMAGIC   = "sw_cast_metamagic";
const string SW_CAST_TARGETTYPE  = "sw_cast_targettype";
const string SW_CAST_SPELL_LEVEL = "sw_cast_spell_level";
const string SW_CAST_IS_DOMAIN   = "sw_cast_is_domain";
const string SW_CAST_BIND_KEY    = "sw_cast_bind_key";
const string SW_TARGET_CLEANUP   = "sw_target_cleanup";

//Script override stored variables
const string SW_OVERRIDDEN_REST_SCRIPT      = "sw_overridden_rest_script";
const string SW_OVERRIDDEN_LVLUP_SCRIPT     = "sw_overridden_lvlup_script";
const string SW_OVERRIDDEN_ACT_ITM_SCRIPT   = "sw_overridden_act_itm_script";
const string SW_OVERRIDDEN_NUI_SCRIPT       = "sw_overridden_nui_script";
const string SW_OVERRIDDEN_PLYR_TRGT_SCRIPT = "sw_overridden_plyr_trgt_script";
const string SW_OVERRIDDEN_SPELL_HOOK       = "sw_overridden_spell_hook";
const string SW_OVERRIDDEN_PLYR_CHAT        = "sw_overridden_plyr_chat_script";
const string SW_OVERRIDE_COMPLETE           = "sw_override_complete";
const string SW_VERSION2_UPGRADE            = "sw_overrridev2_complete";

//Settings storage variables
const string SW_SPELL_ICON_SIZE_STNG    = "sw_spell_icon_size";
const string SW_METAMAGIC_BTN_SIZE_STNG = "sw_metamagic_icon_size";
const string SW_SUBRADIAL_BTN_SIZE_STNG = "sw_subradial_btn_size";
const string SW_SPELL_WIDGET_X_STNG     = "sw_spell_widget_x";
const string SW_SPELL_WIDGET_Y_STNG     = "sw_spell_widget_y";
const string SW_SUBRADIAL_X_STNG        = "sw_subradial_x";
const string SW_SUBRADIAL_Y_STNG        = "sw_subradial_Y";
const string SW_SPELL_WIDGET_W_STNG     = "sw_spell_widget_w_";
const string SW_SPELL_WIDGET_H_STNG     = "sw_spell_widget_h_";
const string SW_SUBRADIAL_W_STNG        = "sw_subradial_w_";
const string SW_SUBRADIAL_H_STNG        = "sw_subradial_h_";
const string SW_MARGIN_SIZE_STNG        = "sw_margin_size";
const string SW_RESIABLE_STNG           = "sw_is_resizable";


//Returns the spell level after being adjusted for metamagic
    //iSpellLevel The base level of the spell
    //iMetaMagic The metamagic applied to the spell
int GetLevelAfterMetaMagic(int iSpellLevel, int iMetaMagic);

//Returns the base spell level before metamaic
    //iSpellLevel The adjusted level of the spell
    //iMetaMagic The metamagic applied to the spell
int GetLevelBeforeMetaMagic(int iSpellLevel, int iMetaMagic);

//Runs a script overridden by the override version
    //sOverriddenScriptVar Variable used to store the script name on the module
    //sDefault Default to run if no script was overridden
void RunOverride(string sOverridenScriptVar, string sDefault = "");

//Saves the x, y coord of the spell widget
    //oPlayer Player using the widget
    //x The x coord
    //y The y coord
void SaveWidgetLocation(object oPlayer, float x, float y);

//Saves the x, y coord of the subradial menu
    //oPlayer Player using the widget
    //x The x coord
    //y The y coord
void SaveSubradialLocation(object oPlayer, float x, float y);

//Returns the saved value of the location
    //oPlayer Player using the widget
vector GetWidgetLocation(object oPlayer);

//Returns the saved value of the location
    //oPlayer Player using the widget
vector GetSubradialLocation(object oPlayer);

float GetXPadding(object oPlayer);

float GetYPadding(object oPlayer);

void SaveWidgetSize(object oPlayer, int iClass, float fWidth, float fHeight);

vector GetWidgetSize(object oPlayer, int iClass);

float GetMargin(object oPlayer);

void Debug(string sMessage);

struct SpellData NewSpellData(int iSpellId, int iMetamagic, int iSpellLevel, int bDomain, int iTimesMemorized, string sLabel);

json SpellDataToJson(struct SpellData stData);

struct SpellData JsonToSpellData(json jSpellData);

struct Settings GetSettings(object oPlayer);

void SaveSettings(object oPlayer, struct Settings settings);

int GetLevelAfterMetaMagic(int iSpellLevel, int iMetaMagic)
{
    int level = iSpellLevel;

    if (iMetaMagic & METAMAGIC_EXTEND)
    {
        level += 1;
    }
    if (iMetaMagic & METAMAGIC_EMPOWER)
    {
        level += 2;
    }
    if (iMetaMagic & METAMAGIC_QUICKEN)
    {
        level += 4;
    }
    if (iMetaMagic & METAMAGIC_MAXIMIZE)
    {
        level += 3;
    }
    if (iMetaMagic & METAMAGIC_SILENT)
    {
        level += 1;
    }
    if (iMetaMagic & METAMAGIC_STILL)
    {
        level += 1;
    }

    return level;
}

int GetLevelBeforeMetaMagic(int iSpellLevel, int iMetaMagic)
{
    int level = iSpellLevel;

    if (iMetaMagic & METAMAGIC_EXTEND)
    {
        level -= 1;
    }
    if (iMetaMagic & METAMAGIC_EMPOWER)
    {
        level -= 2;
    }
    if (iMetaMagic & METAMAGIC_QUICKEN)
    {
        level -= 4;
    }
    if (iMetaMagic & METAMAGIC_MAXIMIZE)
    {
        level -= 3;
    }
    if (iMetaMagic & METAMAGIC_SILENT)
    {
        level -= 1;
    }
    if (iMetaMagic & METAMAGIC_STILL)
    {
        level -= 1;
    }

    return level;
}

void RunOverride(string sOverridenScriptVar, string sDefault = "")
{
    string sOverridenScript = GetLocalString(GetModule(), sOverridenScriptVar);
    if (sOverridenScript != "")
    {
        ExecuteScript(sOverridenScript);
    }
    else if (sDefault != "")
    {
        ExecuteScript(sDefault);
    }
}

void SaveWidgetLocation(object oPlayer, float x, float y)
{
    SetLocalFloat(oPlayer, SW_SPELL_WIDGET_X_STNG, x);
    SetLocalFloat(oPlayer, SW_SPELL_WIDGET_Y_STNG, y);
}

void SaveSubradialLocation(object oPlayer, float x, float y)
{
    SetLocalFloat(oPlayer, SW_SUBRADIAL_X_STNG, x);
    SetLocalFloat(oPlayer, SW_SUBRADIAL_Y_STNG, y);
}

vector GetWidgetLocation(object oPlayer)
{
    float x = GetLocalFloat(oPlayer, SW_SPELL_WIDGET_X_STNG);
    float y = GetLocalFloat(oPlayer, SW_SPELL_WIDGET_Y_STNG);

    return Vector(x, y, 0.0f);
}

vector GetSubradialLocation(object oPlayer)
{
    float x = GetLocalFloat(oPlayer, SW_SUBRADIAL_X_STNG);
    float y = GetLocalFloat(oPlayer, SW_SUBRADIAL_Y_STNG);

    return Vector(x, y, 0.0f);
}

float GetXPadding(object oPlayer)
{
    int iScale = GetPlayerDeviceProperty(oPlayer, PLAYER_DEVICE_PROPERTY_GUI_SCALE);
    float fPadding = 5.0f;
    if (iScale >= 300)
    {
        fPadding = 3.0f;
    }
    else if (iScale >= 200)
    {
        fPadding = 4.3f;
    }
    else if (iScale >= 100)
    {
        fPadding = 6.5f;
    }


    return fPadding;
}

float GetYPadding(object oPlayer)
{
    int iScale = GetPlayerDeviceProperty(oPlayer, PLAYER_DEVICE_PROPERTY_GUI_SCALE);
    float fPadding = 5.0f;
    if (iScale >= 300)
    {
        fPadding = 5.7f;
    }
    else if (iScale >= 200)
    {
        fPadding = 7.2f;
    }
    else if (iScale >= 100)
    {
        fPadding = 12.5f;
    }


    return fPadding;
}

void SaveWidgetSize(object oPlayer, int iClass, float fWidth, float fHeight)
{
    SetLocalFloat(oPlayer, SW_SPELL_WIDGET_W_STNG + IntToString(iClass), fWidth);
    SetLocalFloat(oPlayer, SW_SPELL_WIDGET_H_STNG + IntToString(iClass), fHeight);
}

vector GetWidgetSize(object oPlayer, int iClass)
{
    float fWidth = GetLocalFloat(oPlayer, SW_SPELL_WIDGET_W_STNG + IntToString(iClass));
    float fHeight = GetLocalFloat(oPlayer, SW_SPELL_WIDGET_H_STNG + IntToString(iClass));

    return Vector(fWidth, fHeight, 0.0f);
}

float GetMargin(object oPlayer)
{
    int iScale = GetPlayerDeviceProperty(oPlayer, PLAYER_DEVICE_PROPERTY_GUI_SCALE);
    float fMargin = 0.0f;
    if (iScale >= 150)
    {
        fMargin = 1.0f;
    }

    return fMargin;
}

void Debug(string sMessage)
{
    //WriteTimestampedLogEntry(sMessage);
}

struct SpellData NewSpellData(int iSpellId, int iMetamagic, int iSpellLevel, int bDomain, int iTimesMemorized, string sLabel)
{
    struct SpellData stData;
    stData.iSpellId = iSpellId;
    stData.iMetamagic = iMetamagic;
    stData.iSpellLevel = iSpellLevel;
    stData.bDomain = bDomain;
    stData.iTimesMemorized = iTimesMemorized;
    stData.sLabel = sLabel;

    return stData;
}

json SpellDataToJson(struct SpellData stData)
{
    json jData = JsonObject();
    jData = JsonObjectSet(jData, "iSpellId", JsonInt(stData.iSpellId));
    jData = JsonObjectSet(jData, "iMetamagic", JsonInt(stData.iMetamagic));
    jData = JsonObjectSet(jData, "iSpellLevel", JsonInt(stData.iSpellLevel));
    jData = JsonObjectSet(jData, "bDomain", JsonBool(stData.bDomain));
    jData = JsonObjectSet(jData, "iTimesMemorized", JsonInt(stData.iTimesMemorized));
    jData = JsonObjectSet(jData, "sLabel", JsonString(stData.sLabel));

    return jData;
}

struct SpellData JsonToSpellData(json jSpellData)
{
    struct SpellData stData;
    stData.iSpellId = JsonGetInt(JsonObjectGet(jSpellData, "iSpellId"));
    stData.iMetamagic = JsonGetInt(JsonObjectGet(jSpellData, "iMetamagic"));
    stData.iSpellLevel = JsonGetInt(JsonObjectGet(jSpellData, "iSpellLevel"));
    stData.bDomain = JsonGetInt(JsonObjectGet(jSpellData, "bDomain"));
    stData.iTimesMemorized = JsonGetInt(JsonObjectGet(jSpellData, "iTimesMemorized"));
    stData.sLabel = JsonGetString(JsonObjectGet(jSpellData, "sLabel"));

    return stData;
}

struct Settings GetSettings(object oPlayer)
{
    struct Settings settings;
    float fSpellButtonSize = GetLocalFloat(oPlayer, SW_SPELL_ICON_SIZE_STNG);
    if (fSpellButtonSize == 0.0f)
    {
        settings.fSpellButtonSize       = SW_SPELL_ICON_SIZE;
        settings.fSubradialButtonSize   = SW_SUBRADIAL_BTN_SIZE;
        settings.fMetamagicButtonSize   = SW_METAMAGIC_BTN_SIZE;
        settings.fMarginSize            = GetMargin(oPlayer);
        settings.bResizable             = FALSE;
    }
    else
    {
        settings.fSpellButtonSize       = fSpellButtonSize;
        settings.fSubradialButtonSize   = GetLocalFloat(oPlayer, SW_SUBRADIAL_BTN_SIZE_STNG);
        settings.fMetamagicButtonSize   = GetLocalFloat(oPlayer, SW_METAMAGIC_BTN_SIZE_STNG);
        settings.fMarginSize            = GetLocalFloat(oPlayer, SW_MARGIN_SIZE_STNG);
        settings.bResizable             = GetLocalInt(oPlayer, SW_RESIABLE_STNG);
    }

    return settings;
}

void SaveSettings(object oPlayer, struct Settings settings)
{
    SetLocalFloat(oPlayer, SW_SPELL_ICON_SIZE_STNG, settings.fSpellButtonSize);
    SetLocalFloat(oPlayer, SW_SUBRADIAL_BTN_SIZE_STNG, settings.fSubradialButtonSize);
    SetLocalFloat(oPlayer, SW_METAMAGIC_BTN_SIZE_STNG, settings.fMetamagicButtonSize);
    SetLocalFloat(oPlayer, SW_MARGIN_SIZE_STNG, settings.fMarginSize);
    SetLocalInt(oPlayer, SW_RESIABLE_STNG, settings.bResizable);
}