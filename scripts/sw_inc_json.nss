#include "nw_inc_gff"
#include "nw_inc_nui"
#include "sw_tools"


int HexToInt(string sHex);
string GetMetaMagicName(int iBitMask);
int GetMetaMagicBitMask(int iMetamagic);
int JsonArrayEmpty(json jArray);
struct MetaMagicControls BuildMetaMagicControls(json jPlayer, json jBinds, struct Settings settings, int iEnabledMM = 0);
void MakeSpellGui(object oPC, int iSelectedClass = -1, int iEnabledMM = 0);
void MakeSubRadialWindow(object oPlayer, int iSubRadial1, int iSubRadial2, int iSubRadial3, int iSubRadial4, int iSubRadial5, int iSubRadial6, int iSubRadial7, int iSubRadial8, struct Settings settings);

int GetHexValue(string sChar)
{
    int iVal = StringToInt(sChar);
    string sCheck = IntToString(iVal);

    if (sCheck != sChar)
    {
        if (sChar == "A" || sChar == "a")
        {
            iVal = 10;
        }
        else if(sChar == "B" || sChar == "b")
        {
            iVal = 11;
        }
        else if(sChar == "C" || sChar == "c")
        {
            iVal = 12;
        }
        else if(sChar == "D" || sChar == "d")
        {
            iVal = 13;
        }
        else if(sChar == "E" || sChar == "e")
        {
            iVal = 14;
        }
        else if(sChar == "F" || sChar == "f")
        {
            iVal = 15;
        }
    }

    return iVal;
}

int HexToInt(string sHex)
{
    string hex = GetStringRight(sHex, 2);
    string left = GetStringLeft(hex, 1);
    string right = GetStringRight(hex, 1);

    int mostSignificant = GetHexValue(left) * 16;
    int leastSignificant = GetHexValue(right);

    return mostSignificant + leastSignificant;
}
string GetMetaMagicName(int iBitMask)
{
    string sMetaMagic = "";

    switch(iBitMask)
    {
        case METAMAGIC_EMPOWER:
            sMetaMagic = GetStringByStrRef(EMPOWER_STRREF);
            break;
        case METAMAGIC_EXTEND:
            sMetaMagic = GetStringByStrRef(EXTEND_STRREF);
            break;
        case METAMAGIC_SILENT:
            sMetaMagic = GetStringByStrRef(SILENT_STRREF);
            break;
        case METAMAGIC_STILL:
            sMetaMagic = GetStringByStrRef(STILL_STRREF);
            break;
        case METAMAGIC_MAXIMIZE:
            sMetaMagic = GetStringByStrRef(MAXIMIZE_STRREF);
            break;
        case METAMAGIC_QUICKEN:
            sMetaMagic = GetStringByStrRef(QUICKEN_STRREF);
            break;
    }

    return sMetaMagic;
}

int GetMetaMagicBitMask(int iMetamagic)
{
    int iMask = 0;

    switch(iMetamagic)
    {
        case FEAT_EMPOWER_SPELL:
            iMask = METAMAGIC_EMPOWER;
            break;
        case FEAT_EXTEND_SPELL:
            iMask = METAMAGIC_EXTEND;
            break;
        case FEAT_SILENCE_SPELL:
            iMask = METAMAGIC_SILENT;
            break;
        case FEAT_STILL_SPELL:
            iMask = METAMAGIC_STILL;
            break;
        case FEAT_MAXIMIZE_SPELL:
            iMask = METAMAGIC_MAXIMIZE;
            break;
        case FEAT_QUICKEN_SPELL:
            iMask = METAMAGIC_QUICKEN;
            break;
    }

    return iMask;
}

int JsonArrayEmpty(json jArray)
{
    int bEmpty = JsonGetType(JsonArrayGet(jArray, 0)) == JSON_TYPE_NULL;

    return bEmpty;
}

json JsonBindData(string sBindKey, int bEnabled)
{
    json jBindData = JsonObject();
    jBindData = JsonObjectSet(jBindData, "bindKey", JsonString(sBindKey));
    jBindData = JsonObjectSet(jBindData, "enabled", JsonBool(bEnabled));

    return jBindData;
}

json JsonBindText(string sBindKey, string sText)
{
    json jBindData = JsonObject();
    jBindData = JsonObjectSet(jBindData, "bindKey", JsonString(sBindKey));
    jBindData = JsonObjectSet(jBindData, "text", JsonString(sText));

    return jBindData;
}

struct ClassSpellData BuildSpellsForClass(json jClass, struct Settings settings, int iEnabledMM = 0)
{
    json row;
    json col = JsonArray();

    json jBinds = JsonArray();
    json jTooltipBinds = JsonArray();

    struct ClassSpellData classData;

    int spellLevel = 0;

    int maxSpells = 0;
    int maxSpellLevel = 0;

    string sListType = "KnownList";
    int iClassIdx = JsonGetInt(GffGetInt(jClass, "Class"));
    int bMemorizes = StringToInt(Get2DAString("classes", "MemorizesSpells", iClassIdx));
    int bSpellCaster = StringToInt(Get2DAString("classes", "SpellCaster", iClassIdx));
    json jSpellsPerDay = JsonArray();
    json jSpellDataMap = JsonObject();
    json jSpellsPerLevel = JsonArray();

    if (bMemorizes)
    {
        sListType = "MemorizedList";
        iEnabledMM = 0;
    }
    else
    {
        jSpellsPerDay = GffGetList(jClass, "SpellsPerDayList");
    }

    while (GetLevelAfterMetaMagic(spellLevel, iEnabledMM) < 10 && bSpellCaster)
    {
        string sMemorized = sListType + IntToString(spellLevel);
        json jMemorized = GffGetList(jClass, sMemorized);

        string sAdjustedSpellList = sListType + IntToString(GetLevelAfterMetaMagic(spellLevel, iEnabledMM));
        json jAdjustedList = GffGetList(jClass, sAdjustedSpellList);
        int bSkipLevel = !bMemorizes && (JsonGetType(jAdjustedList) == JSON_TYPE_NULL);

        int spIdx = 0;

        int spellsPerLevel = 0;

        row = JsonArray();
        json jTimesMemorized = JsonObject();
        json jSpell = JsonArrayGet(jMemorized, spIdx++);
        json jLevelData = JsonObject();

        while(JsonGetType(jSpell) != JSON_TYPE_NULL)
        {
            int iSpellId = JsonGetInt(GffGetWord(jSpell, "Spell"));
            int iMetamagic = JsonGetInt(GffGetByte(jSpell, "SpellMetaMagic"));
            int bIncludeSpell = TRUE;
            if (iEnabledMM > 0)
            {
                string sMM = Get2DAString("spells", "MetaMagic", iSpellId);
                int iAvailableMM = HexToInt(sMM);
                iMetamagic = iAvailableMM & iEnabledMM;
                if (iMetamagic != iEnabledMM)
                {
                    bIncludeSpell = FALSE;
                }
            }

            int bAdjustedLevel = spellLevel;
            if (!bMemorizes)
            {
                bAdjustedLevel = GetLevelAfterMetaMagic(spellLevel, iMetamagic);
            }
            if (bIncludeSpell && !bSkipLevel)
            {
                maxSpellLevel = spellLevel;
                int bReady = JsonGetInt(GffGetByte(jSpell, "Ready"));
                int bDomain = JsonGetInt(GffGetByte(jSpell, "DomainSpell"));

                string sDataKey = "Cast_" + IntToString(iClassIdx) + "_" +IntToString(iSpellId) + 
                "_" + IntToString(iMetamagic) + "_" + IntToString(bAdjustedLevel);
                
                string sSpellLabel = Get2DAString("spells", "Name", iSpellId);
                sSpellLabel = GetStringByStrRef(StringToInt(sSpellLabel));
                if (iMetamagic > 0)
                {
                    sSpellLabel = sSpellLabel + " (" + GetMetaMagicName(iMetamagic) + ")";
                }

                struct SpellData stData;
                json jSpellData = JsonObjectGet(jLevelData, sDataKey);

                if (JsonGetType(jSpellData) != JSON_TYPE_NULL)
                {
                    stData = JsonToSpellData(jSpellData);
                    if(bReady)
                    {
                        stData.iTimesMemorized++;
                    }
                }
                else
                {
                    stData = NewSpellData(iSpellId, iMetamagic, bAdjustedLevel, bDomain, bReady, sSpellLabel);
                    spellsPerLevel++;
                }
                
                jLevelData = JsonObjectSet(jLevelData, sDataKey, SpellDataToJson(stData));
                
            }
            jSpell = JsonArrayGet(jMemorized, spIdx++);
        }

        jSpellsPerLevel = JsonArrayInsert(jSpellsPerLevel, jLevelData);

        if (spellsPerLevel > maxSpells)
        {
            maxSpells = spellsPerLevel;
        }
        spellLevel++;
    }

    int iSpellRowIdx = 0;
    json jSpellRow = JsonArrayGet(jSpellsPerLevel, iSpellRowIdx++);

    while(JsonGetType(jSpellRow) != JSON_TYPE_NULL)
    {
        int iKeyIdx = 0;
        json jKeys = JsonObjectKeys(jSpellRow);
        json row = JsonArray();
        json jSpellsByLevel = JsonArray();

        json jKey = JsonArrayGet(jKeys, iKeyIdx++);
        int iCurrentLevel = 0;
        while (JsonGetType(jKey) == JSON_TYPE_STRING)
        {
            json jData = JsonObjectGet(jSpellRow, JsonGetString(jKey));
            jSpellDataMap = JsonObjectSet(jSpellDataMap, JsonGetString(jKey), jData);
            jSpellsByLevel = JsonArrayInsert(jSpellsByLevel, jData);
            struct SpellData data = JsonToSpellData(jData);
            iCurrentLevel = data.iSpellLevel;
            string sIcon = Get2DAString("spells", "IconResRef", data.iSpellId);
            string sButtonLabel = IntToString(iClassIdx) + "_Cast_." + IntToString(data.iSpellId) + "."
                + IntToString(data.iMetamagic) + "." + IntToString(data.iSpellLevel) + "."
                + IntToString(data.bDomain);


            int bEnabled = data.iTimesMemorized > 0;
            string sBindKey = IntToString(iClassIdx) + "_Cast_." + IntToString(data.iSpellId) + "."
                + IntToString(data.iMetamagic) + "." + IntToString(data.iSpellLevel) + ".enabled";
            string sTooltipKey = IntToString(iClassIdx) + "_Cast_." + IntToString(data.iSpellId) + "."
                + IntToString(data.iMetamagic) + "." + IntToString(data.iSpellLevel) + ".tooltip";
            int iTimesMemorized = data.iTimesMemorized;

            if (!bMemorizes)
            {
                sBindKey = IntToString(iClassIdx) + "_Cast_." + IntToString(data.iSpellLevel);
                json spellsPerDay = JsonArrayGet(jSpellsPerDay, data.iSpellLevel);
                int spellsLeft = JsonGetInt(GffGetByte(spellsPerDay, "NumSpellsLeft"));
                iTimesMemorized = spellsLeft;
                if (spellsLeft > 0)
                {
                    bEnabled = TRUE;
                }
            }
            json jBindData = JsonBindData(sBindKey, bEnabled);
            jBinds = JsonArrayInsert(jBinds, jBindData);

            json jTooltip = JsonBindText(sTooltipKey, data.sLabel + " (" + IntToString(iTimesMemorized) + ")");
            jTooltipBinds = JsonArrayInsert(jTooltipBinds, jTooltip);

            json nButton = NuiButtonImage(JsonString(sIcon));
            nButton = NuiId(nButton, sButtonLabel);
            nButton = NuiHeight(nButton, settings.fSpellButtonSize);
            nButton = NuiWidth(nButton, settings.fSpellButtonSize);
            nButton = NuiEnabled(nButton, NuiBind(sBindKey));
            /*
            json jDrawList = JsonArray();
            json jDrawTest = NuiDrawListText(JsonBool(TRUE), NuiColor(255,255,255), 
                NuiRect(15.0f,15.0f,settings.fSpellButtonSize, settings.fSpellButtonSize), JsonString(IntToString(iTimesMemorized)));
            jDrawList = JsonArrayInsert(jDrawList, jDrawTest);
            nButton =  NuiDrawList(nButton, JsonBool(TRUE), jDrawList);
            nButton = NuiHeight(nButton, settings.fSpellButtonSize);
            nButton = NuiWidth(nButton, settings.fSpellButtonSize);
            */
            nButton = NuiGroup(nButton, FALSE, NUI_SCROLLBARS_NONE);
            nButton = NuiHeight(nButton, settings.fSpellButtonSize);
            nButton = NuiWidth(nButton, settings.fSpellButtonSize);
            nButton = NuiMargin(nButton, settings.fMarginSize);
            nButton = NuiTooltip(nButton, NuiBind(sTooltipKey));

            row = JsonArrayInsert(row, nButton);

            jKey = JsonArrayGet(jKeys, iKeyIdx++);
        }
        
        if (!JsonArrayEmpty(jKeys))
        {
            jSpellDataMap = JsonObjectSet(jSpellDataMap, "SpellsByLevel_" + 
                IntToString(iClassIdx) + "_"  + IntToString(iCurrentLevel), jSpellsByLevel);
            json nRow = NuiRow(row);
            nRow = NuiMargin(nRow, settings.fMarginSize);
            col = JsonArrayInsert(col, nRow);
        }

        jSpellRow = JsonArrayGet(jSpellsPerLevel, iSpellRowIdx++);
    }

    classData.jSpells = col;
    classData.iClassId = iClassIdx;
    classData.sClassName = GetStringByStrRef(StringToInt(Get2DAString("classes", "Name", iClassIdx)));
    classData.iNumLevels = maxSpellLevel + 1;
    classData.iMaxSpellsPerLevel = maxSpells;
    classData.bSpellCaster = bSpellCaster;
    classData.bMemorizesSpells = bMemorizes;
    classData.jBinds = jBinds;
    classData.jSpellsPerDay = jSpellsPerDay;
    classData.jTooltipBinds = jTooltipBinds;
    classData.jSpellData = jSpellDataMap;

    return classData;
}

json CreateMetaMagicButton(string sLabel, string sBindKey, float fMargin, float fSize)
{
    json jButton = NuiButtonSelect(JsonString(sLabel), NuiBind(sBindKey));
    jButton = NuiWidth(jButton, fSize);
    jButton = NuiHeight(jButton, fSize);
    jButton = NuiGroup(jButton, FALSE, NUI_SCROLLBARS_NONE);
    jButton = NuiWidth(jButton, fSize);
    jButton = NuiHeight(jButton, fSize);
    jButton = NuiMargin(jButton, fMargin);

    return jButton;
}

struct MetaMagicControls BuildMetaMagicControls(json jPlayer, json jBinds, struct Settings settings, int iEnabledMM = 0)
{
    json jFeats = GffGetList(jPlayer, "FeatList");

    int iFeatIdx = 0;

    json jFeat = JsonArrayGet(jFeats, iFeatIdx++);

    json jRow = JsonArray();

    int iNumFeats = 0;

    while (JsonGetType(jFeat) != JSON_TYPE_NULL)
    {
        int iFeat = JsonGetInt(GffGetWord(jFeat, "Feat"));
        string sBindKey = "MetaMagic_" + IntToString(iFeat);
        json jButton;
        json jBindData;

        switch (iFeat)
        {
            case FEAT_EMPOWER_SPELL:
                jButton = CreateMetaMagicButton("Em", sBindKey, settings.fMarginSize, settings.fMetamagicButtonSize);
                jBindData = JsonBindData(sBindKey, iEnabledMM & METAMAGIC_EMPOWER);
                jBinds = JsonArrayInsert(jBinds, jBindData);
                jRow = JsonArrayInsert(jRow, jButton);
                iNumFeats++;
                break;
            case FEAT_EXTEND_SPELL:
                jButton = CreateMetaMagicButton("Ex", sBindKey, settings.fMarginSize, settings.fMetamagicButtonSize);
                jBindData = JsonBindData(sBindKey, iEnabledMM & METAMAGIC_EXTEND);
                jBinds = JsonArrayInsert(jBinds, jBindData);
                jRow = JsonArrayInsert(jRow, jButton);
                iNumFeats++;
                break;
            case FEAT_MAXIMIZE_SPELL:
                jButton = CreateMetaMagicButton("Mx", sBindKey, settings.fMarginSize, settings.fMetamagicButtonSize);
                jBindData = JsonBindData(sBindKey, iEnabledMM & METAMAGIC_MAXIMIZE);
                jBinds = JsonArrayInsert(jBinds, jBindData);
                jRow = JsonArrayInsert(jRow, jButton);
                iNumFeats++;
                break;
            case FEAT_QUICKEN_SPELL:
                jButton =CreateMetaMagicButton("Qu", sBindKey, settings.fMarginSize, settings.fMetamagicButtonSize);
                jBindData = JsonBindData(sBindKey, iEnabledMM & METAMAGIC_QUICKEN);
                jBinds = JsonArrayInsert(jBinds, jBindData);
                jRow = JsonArrayInsert(jRow, jButton);
                iNumFeats++;
                break;
            case FEAT_SILENCE_SPELL:
                jButton = CreateMetaMagicButton("Si", sBindKey, settings.fMarginSize, settings.fMetamagicButtonSize);
                jBindData = JsonBindData(sBindKey, iEnabledMM & METAMAGIC_SILENT);
                jBinds = JsonArrayInsert(jBinds, jBindData);
                jRow = JsonArrayInsert(jRow, jButton);
                iNumFeats++;
                break;
            case FEAT_STILL_SPELL:
                jButton = CreateMetaMagicButton("St", sBindKey, settings.fMarginSize, settings.fMetamagicButtonSize);
                jBindData = JsonBindData(sBindKey, iEnabledMM & METAMAGIC_STILL);
                jBinds = JsonArrayInsert(jBinds, jBindData);
                jRow = JsonArrayInsert(jRow, jButton);
                iNumFeats++;
                break;
        }

        jFeat = JsonArrayGet(jFeats, iFeatIdx++);
    }
    struct MetaMagicControls stControls;
    stControls.jBinds = jBinds;
    stControls.jMetaMagic = jRow;
    stControls.iNumFeats = iNumFeats;

    return stControls;
}

void MakeSpellGui(object oPC, int iSelectedClass = -1, int iEnabledMM = 0)
{
    int iToken = GetLocalInt(oPC, SW_CAST_WIN_TOKEN);

    vector vStartLocation = GetWidgetLocation(oPC);
    float fStartX = vStartLocation.x;
    float fStartY = vStartLocation.y;
    struct Settings settings = GetSettings(oPC);

    json jPC = ObjectToJson(oPC);

    json jClasses = GffGetList(jPC, "ClassList");

    int idx = 0;

    json jClass = JsonArrayGet(jClasses, idx++);

    json col = JsonArray();
    json jBinds = JsonArray();
    json jTextBinds = JsonArray();
    json jSpellData = JsonObject();

    int iLevels = 0;

    int iSpells = 0;

    json jSpellsPerDay = JsonArray();

    json jSpellClasses = JsonArray();

    json jSpellPanel = JsonNull("");
    int iFirstClass = 0;

    int iCasterClasses = 0;

    int bMemorizes = 0;

    while (JsonGetType(jClass) != JSON_TYPE_NULL)
    {
        struct ClassSpellData classData = BuildSpellsForClass(jClass, settings, iEnabledMM);
        if (classData.bSpellCaster)
        {
            iCasterClasses++;
            if (JsonGetType(jSpellPanel) == JSON_TYPE_NULL || iSelectedClass == classData.iClassId)
            {
                jSpellPanel = classData.jSpells;
                iFirstClass = classData.iClassId;
                bMemorizes = classData.bMemorizesSpells;

                if (!bMemorizes)
                {
                    jSpellsPerDay = classData.jSpellsPerDay;
                }

                jBinds = classData.jBinds;
                jTextBinds = classData.jTooltipBinds;
                jSpellData = classData.jSpellData;

                if (classData.iNumLevels > iLevels)
                {
                    iLevels = classData.iNumLevels;
                }

                if (classData.iMaxSpellsPerLevel > iSpells)
                {
                    iSpells = classData.iMaxSpellsPerLevel;
                }
            }

            jSpellClasses = JsonArrayInsert(jSpellClasses, NuiComboEntry(classData.sClassName, classData.iClassId));
        }

        jClass = JsonArrayGet(jClasses, idx++);
    }

    float fWidth = (IntToFloat(iSpells) * (settings.fSpellButtonSize + 2.5f));
    float fHeight = (IntToFloat(iLevels) * (settings.fSpellButtonSize + 10.0f)) + 4.0f;

    json jMMRow = JsonArray();
    json jMetaMagicBinds = JsonArray();

    if (!bMemorizes)
    {
        struct MetaMagicControls stControls = BuildMetaMagicControls(jPC, jMetaMagicBinds, settings, iEnabledMM);
        jMMRow = stControls.jMetaMagic;
        jMetaMagicBinds = stControls.jBinds;

        float fMetaRowWidth = (IntToFloat(stControls.iNumFeats) * (SW_METAMAGIC_BTN_SIZE +2.0f)) + 2.0f;
        if (fWidth < fMetaRowWidth)
        {
            fWidth = fMetaRowWidth;
        }
    }

    if (fWidth < SW_MIN_WIDGET_WIDTH)
    {
        fWidth = SW_MIN_WIDGET_WIDTH;
    }

    if (iCasterClasses > 1)
    {
        json combo = NuiCombo(jSpellClasses, NuiBind("selected_class"));
        combo = NuiHeight(combo, 25.0f);
        combo = NuiWidth(combo, fWidth - 10.0f);
        combo = NuiId(combo, "ClassSelectCmb");
        combo = NuiGroup(combo, FALSE, NUI_SCROLLBARS_NONE);
        combo = NuiHeight(combo, 25.0f);
        combo = NuiWidth(combo, fWidth - 10.0f);
        combo = NuiMargin(combo, settings.fMarginSize);
        json jHeaderRow = JsonArray();
        jHeaderRow = JsonArrayInsert(jHeaderRow, combo);
        json nHeaderRow = NuiRow(jHeaderRow);
        col = JsonArrayInsert(col, nHeaderRow);

        fHeight += 32.0f;
    }

    if (!JsonArrayEmpty(jMMRow))
    {
        json nMetaRow = NuiRow(jMMRow);
        nMetaRow = NuiMargin(nMetaRow, 1.0f);
        col = JsonArrayInsert(col, nMetaRow);
        fHeight += 32.0f;
    }

    json nSpellPanel = NuiCol(jSpellPanel);
    nSpellPanel = NuiMargin(nSpellPanel, settings.fMarginSize);
    col = JsonArrayInsert(col, nSpellPanel);
    col = JsonArrayInsert(col, NuiSpacer());

    json jRoot = NuiCol(col);
    jRoot = NuiId(jRoot, "sw_root_column");

    json jNui = NuiWindow(
                jRoot,
                NuiBind("spell_widget"),
                NuiBind("geometry"),
                NuiBind("resizable"),
                NuiBind("collapsed"),
                NuiBind("closable"),
                NuiBind("transparent"),
                NuiBind("border")
            );
    iToken = NuiCreate(oPC, jNui, "spellwidget");

    if (iToken == 0)
    {
        WriteTimestampedLogEntry("Error creating NUI window");
        SendMessageToPC(oPC, "Error creating NUI window");
        int iExistingWindow = GetLocalInt(oPC, SW_CAST_WIN_TOKEN);
        if (iExistingWindow)
        {
            NuiDestroy(oPC, iExistingWindow);
            DeleteLocalInt(oPC, SW_CAST_WIN_TOKEN);
        }
    }
    else
    {
        NuiSetBind(oPC, iToken, "spell_widget", JsonString(GetStringByStrRef(SPELLS_STRREF)));
        NuiSetBind(oPC, iToken, "collapsed", JsonBool(FALSE));
        NuiSetBind(oPC, iToken, "resizable", JsonBool(settings.bResizable));
        NuiSetBind(oPC, iToken, "closable", JsonBool(TRUE));
        NuiSetBind(oPC, iToken, "transparent", JsonBool(TRUE));
        NuiSetBind(oPC, iToken, "border", JsonBool(FALSE));
        NuiSetBind(oPC, iToken, "selected_class", JsonInt(iFirstClass));

        vector vDimensions = GetWidgetSize(oPC, iFirstClass);

        if (vDimensions.x > 0.0f && vDimensions.y > 0.0f)
        {
            fWidth = vDimensions.x;
            fHeight = vDimensions.y;
        }

        NuiSetBind(oPC, iToken, "geometry", NuiRect(fStartX, fStartY, fWidth, fHeight));

        NuiSetBindWatch(oPC, iToken, "spell_widget", TRUE);
        NuiSetBindWatch(oPC, iToken, "collapsed", TRUE);
        NuiSetBindWatch(oPC, iToken, "geometry", TRUE);
        NuiSetBindWatch(oPC, iToken, "selected_class", TRUE);

        int iBindIdx = 0;

        json jBindData = JsonArrayGet(jBinds, iBindIdx++);

        while (JsonGetType(jBindData) != JSON_TYPE_NULL)
        {
            string sBindKey = JsonGetString(JsonObjectGet(jBindData, "bindKey"));
            int bEnabled = JsonGetInt(JsonObjectGet(jBindData, "enabled"));

            NuiSetBind(oPC, iToken, sBindKey, JsonBool(bEnabled));

            //TODO find a better way to do this
            //NuiGetBind doesn't work in the spellhook script
            //so need to store bind values where they can be
            //accessed there
            SetLocalInt(oPC, sBindKey, bEnabled);
            jBindData = JsonArrayGet(jBinds, iBindIdx++);
        }

        iBindIdx = 0;

        jBindData = JsonArrayGet(jMetaMagicBinds, iBindIdx++);

        while (JsonGetType(jBindData) != JSON_TYPE_NULL)
        {
            string sBindKey = JsonGetString(JsonObjectGet(jBindData, "bindKey"));
            json bEnabled = JsonObjectGet(jBindData, "enabled");

            NuiSetBind(oPC, iToken, sBindKey, bEnabled);

            NuiSetBindWatch(oPC, iToken, sBindKey, TRUE);
            jBindData = JsonArrayGet(jMetaMagicBinds, iBindIdx++);
        }

        int iSpellsPerDayIdx = 0;
        json jSpells = JsonArrayGet(jSpellsPerDay, iSpellsPerDayIdx);

        while (JsonGetType(jSpells) != JSON_TYPE_NULL)
        {
            int spellsLeft = JsonGetInt(GffGetByte(jSpells, "NumSpellsLeft"));
            SetLocalInt(oPC, "NumSpellsLeft" + IntToString(iSpellsPerDayIdx), spellsLeft);
            iSpellsPerDayIdx++;
            jSpells = JsonArrayGet(jSpellsPerDay, iSpellsPerDayIdx);
        }

        iBindIdx = 0;

        jBindData = JsonArrayGet(jTextBinds, iBindIdx++);

        while (JsonGetType(jBindData) != JSON_TYPE_NULL)
        {
            string sBindKey = JsonGetString(JsonObjectGet(jBindData, "bindKey"));
            json jText = JsonObjectGet(jBindData, "text");

            NuiSetBind(oPC, iToken, sBindKey, jText);

            //NuiSetBindWatch(oPC, iToken, sBindKey, TRUE);
            jBindData = JsonArrayGet(jTextBinds, iBindIdx++);
        }

        NuiSetUserData(oPC, iToken, jSpellData);

        SetLocalInt(oPC, SW_CAST_WIN_TOKEN, iToken);
    }
}

json MakeSubRadSpellButton(int iSpellId, struct Settings settings)
{
    string sIcon = Get2DAString("spells", "IconResRef", iSpellId);
    string sButtonLabel = "Cast." + IntToString(iSpellId);
    string sSpellLabel = Get2DAString("spells", "Name", iSpellId);
    sSpellLabel = GetStringByStrRef(StringToInt(sSpellLabel));

    json nButton = NuiButtonImage(JsonString(sIcon));
    nButton = NuiId(nButton, sButtonLabel);
    nButton = NuiHeight(nButton, settings.fSubradialButtonSize);
    nButton = NuiWidth(nButton, settings.fSubradialButtonSize);
    nButton = NuiGroup(nButton, FALSE, NUI_SCROLLBARS_NONE);
    nButton = NuiHeight(nButton, settings.fSubradialButtonSize);
    nButton = NuiWidth(nButton, settings.fSubradialButtonSize);
    nButton = NuiTooltip(nButton, JsonString(sSpellLabel));

    return nButton;
}

void MakeSubRadialWindow(object oPlayer, int iSubRadial1, int iSubRadial2,
    int iSubRadial3, int iSubRadial4, int iSubRadial5, int iSubRadial6, int iSubRadial7, int iSubRadial8, struct Settings settings)
{
    vector vStartLocation = GetSubradialLocation(oPlayer);
    float fStartX = vStartLocation.x;
    float fStartY = vStartLocation.y;

    json jCol = JsonArray();
    json jRow = JsonArray();

    jRow = JsonArrayInsert(jRow, NuiSpacer());
    int iButtonCount = 0;

    json nButton;
    if (iSubRadial1 > 0)
    {
        nButton = MakeSubRadSpellButton(iSubRadial1, settings);
        jRow = JsonArrayInsert(jRow, nButton);
        iButtonCount++;
    }
    if (iSubRadial2 > 0)
    {
        nButton = MakeSubRadSpellButton(iSubRadial2, settings);
        jRow = JsonArrayInsert(jRow, nButton);
        iButtonCount++;
    }
    if (iSubRadial3 > 0)
    {
        nButton = MakeSubRadSpellButton(iSubRadial3, settings);
        jRow = JsonArrayInsert(jRow, nButton);
        iButtonCount++;
    }
    if (iSubRadial4 > 0)
    {
        nButton = MakeSubRadSpellButton(iSubRadial4, settings);
        jRow = JsonArrayInsert(jRow, nButton);
        iButtonCount++;
    }
    if (iSubRadial5 > 0)
    {
        nButton = MakeSubRadSpellButton(iSubRadial5, settings);
        jRow = JsonArrayInsert(jRow, nButton);
        iButtonCount++;
    }
    if (iSubRadial6 > 0)
    {
        nButton = MakeSubRadSpellButton(iSubRadial6, settings);
        jRow = JsonArrayInsert(jRow, nButton);
        iButtonCount++;
    }
    if (iSubRadial7 > 0)
    {
        nButton = MakeSubRadSpellButton(iSubRadial7, settings);
        jRow = JsonArrayInsert(jRow, nButton);
        iButtonCount++;
    }
    if (iSubRadial8 > 0)
    {
        nButton = MakeSubRadSpellButton(iSubRadial8, settings);
        jRow = JsonArrayInsert(jRow, nButton);
        iButtonCount++;
    }

    jRow = JsonArrayInsert(jRow, NuiSpacer());

    jCol = JsonArrayInsert(jCol, NuiRow(jRow));


    float fWidth = (iButtonCount * (settings.fSubradialButtonSize + GetXPadding(oPlayer))) + 30;
    float fHeight = settings.fSubradialButtonSize + 40 + GetYPadding(oPlayer);


    json jRoot = NuiCol(jCol);

    json jNui = NuiWindow(
                jRoot,
                NuiBind("radial_widget"),
                NuiBind("geometry"),
                NuiBind("resizable"),
                NuiBind("collapsed"),
                NuiBind("closable"),
                NuiBind("transparent"),
                NuiBind("border")
            );

    int iToken = NuiCreate(oPlayer, jNui, "subradialspells");

    NuiSetBind(oPlayer, iToken, "radial_widget", JsonString("Select Spell"));
    NuiSetBind(oPlayer, iToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPlayer, iToken, "resizable", JsonBool(settings.bResizable));
    NuiSetBind(oPlayer, iToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPlayer, iToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPlayer, iToken, "border", JsonBool(TRUE));

    NuiSetBind(oPlayer, iToken, "geometry", NuiRect(fStartX, fStartY, fWidth, fHeight));

    NuiSetBindWatch(oPlayer, iToken, "radial_widget", TRUE);
    NuiSetBindWatch(oPlayer, iToken, "collapsed", TRUE);
    NuiSetBindWatch(oPlayer, iToken, "geometry", TRUE);
}
