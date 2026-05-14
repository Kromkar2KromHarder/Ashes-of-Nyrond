#include "nw_inc_nui"
#include "sw_tools"

void MakeConfigMenu(object oPlayer);

void SetSliderWatches(object oPlayer, int iToken, string sBindKey, float fInitValue)
{
    NuiSetBind(oPlayer, iToken, "slider." + sBindKey, JsonFloat(fInitValue));
    NuiSetBind(oPlayer, iToken, "slider."+ sBindKey + ".label", 
        JsonString(FloatToString(fInitValue, 3, 1)));
    NuiSetBindWatch(oPlayer, iToken, "slider." + sBindKey, TRUE);

}
void MakeConfigMenu(object oPlayer)
{
    float fControlWidth = 160.0f;
    float fControlHeight = 40.0f;
    struct Settings settings = GetSettings(oPlayer);
    if (settings.fSpellButtonSize == 0.0f)
    {
        settings.fSpellButtonSize       = SW_SPELL_ICON_SIZE;
        settings.fSubradialButtonSize   = SW_SUBRADIAL_BTN_SIZE;
        settings.fMetamagicButtonSize   = SW_METAMAGIC_BTN_SIZE;
        settings.fMarginSize            = GetMargin(oPlayer);
        settings.bResizable             = FALSE;
    }

    json jRow;
    json jCol = JsonArray();
    json jSliderCol = JsonArray();

    jCol = JsonArrayInsert(jCol, NuiSpacer());

    //Spell Icon size controls
    jRow = JsonArray(); //JsonArrayInsert(JsonArray(), NuiSpacer());
    json nText = NuiLabel(JsonString("Spell Icon Size: "), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE));
    nText = NuiWidth(nText, fControlWidth);
    nText = NuiHeight(nText, fControlHeight);

    jRow = JsonArrayInsert(jRow, nText);

    nText = NuiLabel(NuiBind("slider.spell_button_size.label"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    nText = NuiWidth(nText, fControlWidth);
    nText = NuiHeight(nText, fControlHeight / 2.0f);

    jSliderCol = JsonArrayInsert(jSliderCol, nText);

    json nSlider = NuiSliderFloat(NuiBind("slider.spell_button_size"), JsonFloat(10.0f), JsonFloat(50.0f), JsonFloat(0.5f));
    nSlider = NuiWidth(nSlider, fControlWidth);
    nSlider = NuiHeight(nSlider, fControlHeight / 2.0f);

    jSliderCol = JsonArrayInsert(jSliderCol, nSlider);
    jRow = JsonArrayInsert(jRow, NuiCol(jSliderCol));
    jRow = JsonArrayInsert(jRow, NuiSpacer());

    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //Metamagic Icon Size controls
    jRow = JsonArray();//JsonArrayInsert(JsonArray(), NuiSpacer());
    nText = NuiLabel(JsonString("Metamagic Button Size: "), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE));
    nText = NuiWidth(nText, fControlWidth);
    nText = NuiHeight(nText, fControlHeight);

    jRow = JsonArrayInsert(jRow, nText);

    nText = NuiLabel(NuiBind("slider.metamagic_button_size.label"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    nText = NuiWidth(nText, fControlWidth);
    nText = NuiHeight(nText, fControlHeight / 2.0f);

    jSliderCol = JsonArrayInsert(JsonArray(), nText);

    nSlider = NuiSliderFloat(NuiBind("slider.metamagic_button_size"), JsonFloat(10.0f), JsonFloat(50.0f), JsonFloat(0.5f));
    nSlider = NuiWidth(nSlider, fControlWidth);
    nSlider = NuiHeight(nSlider, fControlHeight / 2.0f);

    jSliderCol = JsonArrayInsert(jSliderCol, nSlider);
    jRow = JsonArrayInsert(jRow, NuiCol(jSliderCol));
    jRow = JsonArrayInsert(jRow, NuiSpacer());

    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //Subradial Button Size
    jRow = JsonArray(); //JsonArrayInsert(JsonArray(), NuiSpacer());
    nText = NuiLabel(JsonString("Subradial Button Size: "), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE));
    nText = NuiWidth(nText, fControlWidth);
    nText = NuiHeight(nText, fControlHeight);

    jRow = JsonArrayInsert(jRow, nText);

    nText = NuiLabel(NuiBind("slider.subradial_button_size.label"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    nText = NuiWidth(nText, fControlWidth);
    nText = NuiHeight(nText, fControlHeight / 2.0f);

    jSliderCol = JsonArrayInsert(JsonArray(), nText);

    nSlider = NuiSliderFloat(NuiBind("slider.subradial_button_size"), JsonFloat(10.0f), JsonFloat(75.0f), JsonFloat(0.5f));
    nSlider = NuiWidth(nSlider, fControlWidth);
    nSlider = NuiHeight(nSlider, fControlHeight / 2.0f);

    jSliderCol = JsonArrayInsert(jSliderCol, nSlider);
    jRow = JsonArrayInsert(jRow, NuiCol(jSliderCol));
    jRow = JsonArrayInsert(jRow, NuiSpacer());

    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //Margin controls
    jRow = JsonArray();//JsonArrayInsert(JsonArray(), NuiSpacer());
    nText = NuiLabel(JsonString("Margin Size: "), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE));
    nText = NuiWidth(nText, fControlWidth);
    nText = NuiHeight(nText, fControlHeight);

    jRow = JsonArrayInsert(jRow, nText);

    nText = NuiLabel(NuiBind("slider.margin_size.label"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    nText = NuiWidth(nText, fControlWidth);
    nText = NuiHeight(nText, fControlHeight / 2.0f);

    jSliderCol = JsonArrayInsert(JsonArray(), nText);

    nSlider = NuiSliderFloat(NuiBind("slider.margin_size"), JsonFloat(0.0f), JsonFloat(2.0f), JsonFloat(0.1f));
    nSlider = NuiWidth(nSlider, fControlWidth);
    nSlider = NuiHeight(nSlider, fControlHeight / 2.0f);

    jSliderCol = JsonArrayInsert(jSliderCol, nSlider);
    jRow = JsonArrayInsert(jRow, NuiCol(jSliderCol));
    jRow = JsonArrayInsert(jRow, NuiSpacer());

    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //Resizable setting
    jRow = JsonArrayInsert(JsonArray(), NuiSpacer());

    json nCheck = NuiCheck(JsonString("  Resizable"), NuiBind("checkbox.resizable"));
    nCheck = NuiWidth(nCheck, fControlWidth);
    nCheck = NuiHeight(nCheck, fControlHeight);

    jRow = JsonArrayInsert(jRow, nCheck);
    jRow = JsonArrayInsert(jRow, NuiSpacer());

    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //Save/Cancel buttons
    jRow = JsonArrayInsert(JsonArray(), NuiSpacer());
    json nButton = NuiButton(JsonString("Save"));
    nButton = NuiId(nButton, "sw_conf_save_btn");
    nButton = NuiWidth(nButton, fControlWidth);
    nButton = NuiHeight(nButton, fControlHeight);
    jRow = JsonArrayInsert(jRow, nButton);
    
    nButton = NuiButton(JsonString("Cancel"));
    nButton = NuiId(nButton, "sw_conf_cancel_btn");
    nButton = NuiWidth(nButton, fControlWidth);
    nButton = NuiHeight(nButton, fControlHeight);
    jRow = JsonArrayInsert(jRow, nButton);
    
    jRow = JsonArrayInsert(jRow, NuiSpacer());

    jCol = JsonArrayInsert(jCol, NuiRow(jRow));



    jCol = JsonArrayInsert(jCol, NuiSpacer());
    //
    json jRoot = NuiCol(jCol);
    jRoot = NuiWidth(jRoot, fControlWidth * 2.0f);

    float fWidth = (fControlWidth * 2.0f) + 100.0f;
    float fHeight = (fControlHeight * 5.0f) + 100.0f;

    float fScale = GetPlayerDeviceProperty(oPlayer, PLAYER_DEVICE_PROPERTY_GUI_SCALE) / 100.0;                  

    float fStartX  = (GetPlayerDeviceProperty(oPlayer, PLAYER_DEVICE_PROPERTY_GUI_WIDTH) / fScale) + (fWidth / (2.0f * fScale));
    float fStartY = (GetPlayerDeviceProperty(oPlayer, PLAYER_DEVICE_PROPERTY_GUI_HEIGHT) / fScale) + (fHeight / (2.0f * fScale));

    json jNui = NuiWindow(
                jRoot,
                NuiBind("config_menu"),
                NuiBind("geometry"),
                NuiBind("resizable"),
                NuiBind("collapsed"),
                NuiBind("closable"),
                NuiBind("transparent"),
                NuiBind("border")
            );

    int iToken = NuiCreate(oPlayer, jNui, "sw_config_menu");

    NuiSetBind(oPlayer, iToken, "config_menu", JsonString("Configuration"));
    NuiSetBind(oPlayer, iToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPlayer, iToken, "resizable", JsonBool(TRUE));
    NuiSetBind(oPlayer, iToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPlayer, iToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPlayer, iToken, "border", JsonBool(TRUE));

    NuiSetBind(oPlayer, iToken, "geometry", NuiRect(fStartX, fStartY, fWidth, fHeight));
    NuiSetBindWatch(oPlayer, iToken, "geometry", TRUE);
    
    SetSliderWatches(oPlayer, iToken, "spell_button_size", settings.fSpellButtonSize);
    SetSliderWatches(oPlayer, iToken, "metamagic_button_size", settings.fMetamagicButtonSize);
    SetSliderWatches(oPlayer, iToken, "subradial_button_size", settings.fSubradialButtonSize);
    SetSliderWatches(oPlayer, iToken, "margin_size", settings.fMarginSize);

    NuiSetBind(oPlayer, iToken, "checkbox.resizable", JsonBool(settings.bResizable));

}