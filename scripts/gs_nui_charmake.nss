#include "nw_inc_nui"
#include "gs_nui_origin"

const string GS_ORIGIN_WINDOW = "gs_origincreate";
const string GS_BG_WINDOW     = "gs_charcreate";

string gsGetBackgroundDesc(string sBackground)
{
    if (sBackground == "Appraiser")
        return "Your sharp eye makes you the bane of snake-oil salesmen and second-rate merchants the Realms over: within seconds you can identify fakes, point out faults, and estimate dates of construction. All this attention to detail makes you a bit preoccupied, however, and at times puts you in danger of missing the bigger picture.";
    if (sBackground == "Bully")
        return "Whether through size, confidence, or a sinister appearance, you've always been able to provoke people into doing what you want. When things went wrong, you were tough enough to give as good as you got. Your fearsome presence often lends an unpleasant edge to even friendly conversations.";
    if (sBackground == "Confidant")
        return "You know precisely how to get people to trust you - unfortunately, that same veneer of trustworthiness makes it hard for people to believe any threats.";
    if (sBackground == "Devout")
        return "You have always had strong faith and it's obvious to everyone around you. Your beliefs give you great mental strength, but you can be stubborn and hot-headed in conversations.";
    if (sBackground == "Farmer")
        return "Growing up on a farm taught you the ways of the land and watching over fields gave you keen eyes. Long workdays didn't leave much time for fancy learning.";
    if (sBackground == "Flirt")
        return "More than just an attractive face, you knew how to listen and talk in a way that many found very appealing. Unfortunately, you're so soft around the edges that no one takes you seriously when you try to act tough.";
    if (sBackground == "Foreigner")
        return "You are not from the Kingdom of Nyrond originally, but your knowledge of the outside world comes in handy.";
    if (sBackground == "Militia")
        return "Strict training in the militia gave you excellent discipline, but your spirit was broken as you were forced to rise, march, and fight at the command of superiors.";
    if (sBackground == "Natural Leader")
        return "You were always watching out for others and trying to help them do their best. Your tendency to always keep an eye on everyone else causes you to neglect your own safety at times.";
    if (sBackground == "Savvy")
        return "You know how to make people say \"yes\" - but sometimes that makes you bad at saying \"no.\"";
    if (sBackground == "Tale Teller")
        return "From a young age, you learned that you could command attention and friendship with your tall tales. You become so wrapped up in your imagination that sometimes it's hard to focus on other matters.";
    if (sBackground == "Talent")
        return "You're a shameless show-boater, and you know it. If there's a way to get attention, you can't help yourself - you're compelled to follow it. Unfortunately, this makes you more than a little susceptible to dirty tricks.";
    if (sBackground == "Troublemaker")
        return "Boredom or malice led you to play a variety of tricks on people and consequently get into trouble. Curiosity always got the best of you, and you had difficulty resisting temptation.";
    if (sBackground == "Veteran")
        return "You fought against armies on campaign for years. You're tougher, but the experience has made you more jaded than usual.";
    if (sBackground == "Wild Child")
        return "In your youth, you were a free spirit, often left to wander and explore on your own. Your limited contact with others has left you unaware of the accepted value or significance of many things.";
    if (sBackground == "Wizard's Apprentice")
        return "Long hours spent training with a wizard taught you many esoteric secrets, but your powers of observation and resistance to the everyday plagues of the world suffered.";
    return "";
}

string gsGetBackgroundBonus(string sBackground)
{
    if (sBackground == "Appraiser")           return "+1 Appraise, +1 Lore\n-1 Spot, -1 Bluff, -1 Sleight of Hand";
    if (sBackground == "Bully")               return "+1 Fortitude Saves, +1 Intimidate\n-1 Bluff, -1 Diplomacy";
    if (sBackground == "Confidant")           return "+1 Bluff\n-1 Intimidate, -1 Taunt";
    if (sBackground == "Devout")              return "+1 Will Saves, +1 Concentration\n-1 Diplomacy, -1 Bluff";
    if (sBackground == "Farmer")              return "+1 Survival, +1 Spot\n-1 Lore";
    if (sBackground == "Flirt")               return "+1 Listen, +1 Sense Motive\n-1 Intimidate, -1 Discipline";
    if (sBackground == "Foreigner")           return "+1 Lore\n-1 Diplomacy";
    if (sBackground == "Militia")             return "+1 Parry, +1 Discipline\n-1 Will Saves";
    if (sBackground == "Natural Leader")      return "+2 Discipline, +1 Taunt, +1 Spot\n-1 All Saving Throws";
    if (sBackground == "Savvy")               return "+1 Diplomacy\n-1 Will Saves";
    if (sBackground == "Tale Teller")         return "+1 Lore: History, +1 Bluff\n-1 Concentration";
    if (sBackground == "Talent")              return "+1 Perform\n-1 Will Saves";
    if (sBackground == "Troublemaker")        return "+1 Reflex Saves, +1 Handle Trap, +1 Sleight of Hand\n-2 Will Saves";
    if (sBackground == "Veteran")             return "+1 Fortitude Saves\n-1 Diplomacy";
    if (sBackground == "Wild Child")          return "+1 Survival, +1 Tumble, +1 Stealth\n-1 Lore, -1 Appraise";
    if (sBackground == "Wizard's Apprentice") return "+1 Spellcraft, +1 Lore: Arcana, +1 Concentration\n-1 Perception, -1 Fortitude Saves";
    return "";
}

json gsCharInfoPanel(object oPC)
{
    string sName   = GetName(oPC);
    string sRace;
    int nRace = GetRacialType(oPC);
    if      (nRace == RACIAL_TYPE_HUMAN)    sRace = "Human";
    else if (nRace == RACIAL_TYPE_ELF)      sRace = "Elf";
    else if (nRace == RACIAL_TYPE_DWARF)    sRace = "Dwarf";
    else if (nRace == RACIAL_TYPE_GNOME)    sRace = "Gnome";
    else if (nRace == RACIAL_TYPE_HALFLING) sRace = "Halfling";
    else if (nRace == RACIAL_TYPE_HALFELF)  sRace = "Half-Elf";
    else if (nRace == RACIAL_TYPE_HALFORC)  sRace = "Half-Orc";
    else                                    sRace = "Unknown";

    string sBG     = GetLocalString(oPC, "GS_SELECTED_BG");
    string sOrigin = GetLocalString(oPC, "GS_SELECTED_ORIGIN");
    string sDeity  = GetLocalString(oPC, "GS_SELECTED_DEITY");

    json jCol = JsonArray();

    // portrait + details side by side
    json jTopRow = JsonArray();

    // portrait box
    json jPortrait = NuiLabel(JsonString("[Portrait]"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jPortrait = NuiWidth(jPortrait, 120.0f);
    jPortrait = NuiHeight(jPortrait, 160.0f);

    json jPortraitGroup = NuiGroup(
        NuiCol(JsonArrayInsert(JsonArray(), NuiRow(JsonArrayInsert(JsonArray(), jPortrait)))),
        TRUE, NUI_SCROLLBARS_NONE);
    jPortraitGroup = NuiWidth(jPortraitGroup, 130.0f);

    // detail fields
    json jDetailCol = JsonArray();

    json jDetailHeader = NuiLabel(JsonString("= Character Details ="), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jDetailHeader = NuiHeight(jDetailHeader, 28.0f);
    jDetailCol = JsonArrayInsert(jDetailCol, NuiRow(JsonArrayInsert(JsonArray(), jDetailHeader)));

    json jNameField = NuiLabel(JsonString("Name: " + sName), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE));
    jNameField = NuiHeight(jNameField, 28.0f);
    jDetailCol = JsonArrayInsert(jDetailCol, NuiRow(JsonArrayInsert(JsonArray(), jNameField)));

    json jRaceField = NuiLabel(JsonString("Race: " + sRace), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE));
    jRaceField = NuiHeight(jRaceField, 28.0f);
    jDetailCol = JsonArrayInsert(jDetailCol, NuiRow(JsonArrayInsert(JsonArray(), jRaceField)));

    json jBGField = NuiLabel(JsonString("Background: " + sBG), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE));
    jBGField = NuiHeight(jBGField, 28.0f);
    jDetailCol = JsonArrayInsert(jDetailCol, NuiRow(JsonArrayInsert(JsonArray(), jBGField)));

    json jOriginField = NuiLabel(JsonString("Origin: " + sOrigin), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE));
    jOriginField = NuiHeight(jOriginField, 28.0f);
    jDetailCol = JsonArrayInsert(jDetailCol, NuiRow(JsonArrayInsert(JsonArray(), jOriginField)));

    json jDeityField = NuiLabel(JsonString("Deity: " + sDeity), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE));
    jDeityField = NuiHeight(jDeityField, 28.0f);
    jDetailCol = JsonArrayInsert(jDetailCol, NuiRow(JsonArrayInsert(JsonArray(), jDeityField)));

    jDetailCol = NuiCol(jDetailCol);

    jTopRow = JsonArrayInsert(jTopRow, jPortraitGroup);
    jTopRow = JsonArrayInsert(jTopRow, jDetailCol);
    jTopRow = NuiRow(jTopRow);
    jCol = JsonArrayInsert(jCol, jTopRow);

    jCol = NuiCol(jCol);
    json jGroup = NuiGroup(jCol, TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiWidth(jGroup, 320.0f);
    return jGroup;
}

void gsOpenOriginWindow(object oPC)
{
    int nExisting = NuiFindWindow(oPC, GS_ORIGIN_WINDOW);
    if (nExisting != 0) NuiDestroy(oPC, nExisting);

    // -- LEFT PANEL ---------------------------------------------------
    json jLeftPanel = gsCharInfoPanel(oPC);

    // -- RIGHT PANEL --------------------------------------------------
    json jRightCol = JsonArray();

    json jHeaderRow = JsonArray();
    json jHeader = NuiLabel(JsonString("= Origin ="), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jHeader = NuiHeight(jHeader, 36.0f);
    jHeaderRow = JsonArrayInsert(jHeaderRow, jHeader);
    jRightCol = JsonArrayInsert(jRightCol, NuiRow(jHeaderRow));

    // spacer above buttons to push them toward center
    jRightCol = JsonArrayInsert(jRightCol, NuiRow(JsonArrayInsert(JsonArray(), NuiSpacer())));

    json jNyrondRow = JsonArray();
    jNyrondRow = JsonArrayInsert(jNyrondRow, NuiSpacer());
    json jNyrondBtn = NuiId(NuiButtonSelect(JsonString("Nyrond"), NuiBind("sel_nyrond")), "origin_nyrond");
    jNyrondBtn = NuiWidth(jNyrondBtn, 280.0f);
    jNyrondBtn = NuiHeight(jNyrondBtn, 40.0f);
    jNyrondRow = JsonArrayInsert(jNyrondRow, jNyrondBtn);
    jNyrondRow = JsonArrayInsert(jNyrondRow, NuiSpacer());
    jRightCol = JsonArrayInsert(jRightCol, NuiRow(jNyrondRow));

    json jForeignRow = JsonArray();
    jForeignRow = JsonArrayInsert(jForeignRow, NuiSpacer());
    json jForeignBtn = NuiId(NuiButtonSelect(JsonString("Foreign"), NuiBind("sel_foreign")), "origin_foreign");
    jForeignBtn = NuiWidth(jForeignBtn, 280.0f);
    jForeignBtn = NuiHeight(jForeignBtn, 40.0f);
    jForeignRow = JsonArrayInsert(jForeignRow, jForeignBtn);
    jForeignRow = JsonArrayInsert(jForeignRow, NuiSpacer());
    jRightCol = JsonArrayInsert(jRightCol, NuiRow(jForeignRow));

    // spacer below buttons
    jRightCol = JsonArrayInsert(jRightCol, NuiRow(JsonArrayInsert(JsonArray(), NuiSpacer())));

    jRightCol = NuiCol(jRightCol);
    json jRightGroup = NuiGroup(jRightCol, TRUE, NUI_SCROLLBARS_NONE);

    // -- TOP ROW ------------------------------------------------------
    json jTopRow = JsonArray();
    jTopRow = JsonArrayInsert(jTopRow, jLeftPanel);
    jTopRow = JsonArrayInsert(jTopRow, jRightGroup);
    jTopRow = NuiRow(jTopRow);

    // -- DESCRIPTION SECTION ------------------------------------------
    json jDescCol = JsonArray();

    json jDescHeaderRow = JsonArray();
    json jDescHeader = NuiLabel(JsonString("= Origin Description ="), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jDescHeader = NuiHeight(jDescHeader, 30.0f);
    jDescHeaderRow = JsonArrayInsert(jDescHeaderRow, jDescHeader);
    jDescCol = JsonArrayInsert(jDescCol, NuiRow(jDescHeaderRow));

    json jDescRow = JsonArray();
    json jDescBox = NuiText(NuiBind("origin_desc"), FALSE, NUI_SCROLLBARS_NONE);
    jDescBox = NuiHeight(jDescBox, 280.0f);
    jDescRow = JsonArrayInsert(jDescRow, jDescBox);
    jDescCol = JsonArrayInsert(jDescCol, NuiRow(jDescRow));

    jDescCol = NuiCol(jDescCol);
    json jDescGroup = NuiGroup(jDescCol, TRUE, NUI_SCROLLBARS_NONE);

    // -- BOTTOM BAR ---------------------------------------------------
    json jBottomRow = JsonArray();
    json jBackBtn = NuiId(NuiButton(JsonString("< Back")), "btn_back");
    jBackBtn = NuiWidth(jBackBtn, 100.0f);
    jBottomRow = JsonArrayInsert(jBottomRow, jBackBtn);
    jBottomRow = JsonArrayInsert(jBottomRow, NuiSpacer());
    json jConfirmBtn = NuiId(NuiButton(JsonString("Confirm Origin Selection")), "btn_confirm");
    jConfirmBtn = NuiWidth(jConfirmBtn, 220.0f);
    jConfirmBtn = NuiEnabled(jConfirmBtn, NuiBind("confirm_enabled"));
    jBottomRow = JsonArrayInsert(jBottomRow, jConfirmBtn);
    jBottomRow = NuiRow(jBottomRow);

    // -- ROOT ---------------------------------------------------------
    json jRoot = JsonArray();
    jRoot = JsonArrayInsert(jRoot, jTopRow);
    jRoot = JsonArrayInsert(jRoot, jDescGroup);
    jRoot = JsonArrayInsert(jRoot, jBottomRow);
    jRoot = NuiCol(jRoot);

    json jWindow = NuiWindow(
        jRoot,
        JsonString("Character Creation - Origin"),
        NuiBind("geometry"),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE)
    );

    int nToken = NuiCreate(oPC, jWindow, GS_ORIGIN_WINDOW);

    NuiSetBind(oPC, nToken, "geometry",        NuiRect(-1.0f, -1.0f, 900.0f, 760.0f));
    NuiSetBind(oPC, nToken, "origin_desc",     JsonString(""));
    NuiSetBind(oPC, nToken, "sel_nyrond",      JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "sel_foreign",     JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "confirm_enabled", JsonBool(FALSE));

    string sPrev = GetLocalString(oPC, "GS_SELECTED_ORIGIN");
    if (sPrev == "Nyrond")
    {
        NuiSetBind(oPC, nToken, "sel_nyrond",      JsonBool(TRUE));
        NuiSetBind(oPC, nToken, "origin_desc",     JsonString(GS_ORIGIN_NYROND));
        NuiSetBind(oPC, nToken, "confirm_enabled", JsonBool(TRUE));
    }
    else if (sPrev == "Foreign")
    {
        NuiSetBind(oPC, nToken, "sel_foreign",     JsonBool(TRUE));
        NuiSetBind(oPC, nToken, "origin_desc",     JsonString(GS_ORIGIN_FOREIGN));
        NuiSetBind(oPC, nToken, "confirm_enabled", JsonBool(TRUE));
    }
}

void gsOpenBGWindow(object oPC)
{
    int nExisting = NuiFindWindow(oPC, GS_BG_WINDOW);
    if (nExisting != 0) NuiDestroy(oPC, nExisting);

    // -- LEFT PANEL ---------------------------------------------------
    json jLeftPanel = gsCharInfoPanel(oPC);

    // -- RIGHT PANEL: background buttons -----------------------------
    json jRightCol = JsonArray();

    json jHeaderRow = JsonArray();
    json jHeader = NuiLabel(JsonString("= Background ="), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jHeader = NuiHeight(jHeader, 36.0f);
    jHeaderRow = JsonArrayInsert(jHeaderRow, jHeader);
    jRightCol = JsonArrayInsert(jRightCol, NuiRow(jHeaderRow));

    string sRemaining = "Appraiser|Bully|Confidant|Devout|Farmer|Flirt|Foreigner|Militia|Natural Leader|Savvy|Tale Teller|Talent|Troublemaker|Veteran|Wild Child|Wizard's Apprentice";
    int i = 0;
    while (sRemaining != "")
    {
        int nPipe = FindSubString(sRemaining, "|");
        string sName;
        if (nPipe == -1) { sName = sRemaining; sRemaining = ""; }
        else
        {
            sName      = GetStringLeft(sRemaining, nPipe);
            sRemaining = GetStringRight(sRemaining, GetStringLength(sRemaining) - nPipe - 1);
        }
        json jBtnRow = JsonArray();
        jBtnRow = JsonArrayInsert(jBtnRow, NuiSpacer());
        json jBtn = NuiId(NuiButtonSelect(JsonString(sName), NuiBind("bg_sel_" + IntToString(i))), "bg_btn_" + IntToString(i));
        jBtn = NuiWidth(jBtn, 280.0f);
        jBtn = NuiHeight(jBtn, 32.0f);
        jBtnRow = JsonArrayInsert(jBtnRow, jBtn);
        jBtnRow = JsonArrayInsert(jBtnRow, NuiSpacer());
        jRightCol = JsonArrayInsert(jRightCol, NuiRow(jBtnRow));
        i++;
    }

    jRightCol = NuiCol(jRightCol);
    json jRightGroup = NuiGroup(jRightCol, TRUE, NUI_SCROLLBARS_AUTO);

    // -- TOP ROW ------------------------------------------------------
    json jTopRow = JsonArray();
    jTopRow = JsonArrayInsert(jTopRow, jLeftPanel);
    jTopRow = JsonArrayInsert(jTopRow, jRightGroup);
    jTopRow = NuiRow(jTopRow);

    // -- DESCRIPTION SECTION ------------------------------------------
    json jDescCol = JsonArray();

    json jDescHeaderRow = JsonArray();
    json jDescHeader = NuiLabel(JsonString("= Background Description ="), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jDescHeader = NuiHeight(jDescHeader, 30.0f);
    jDescHeaderRow = JsonArrayInsert(jDescHeaderRow, jDescHeader);
    jDescCol = JsonArrayInsert(jDescCol, NuiRow(jDescHeaderRow));

    json jDescRow = JsonArray();
    json jDescBox = NuiText(NuiBind("selected_bg_text"), FALSE, NUI_SCROLLBARS_NONE);
    jDescBox = NuiHeight(jDescBox, 280.0f);
    jDescRow = JsonArrayInsert(jDescRow, jDescBox);
    jDescCol = JsonArrayInsert(jDescCol, NuiRow(jDescRow));

    jDescCol = NuiCol(jDescCol);
    json jDescGroup = NuiGroup(jDescCol, TRUE, NUI_SCROLLBARS_NONE);

    // -- BOTTOM BAR ---------------------------------------------------
    json jBottomRow = JsonArray();
    json jBackBtn = NuiId(NuiButton(JsonString("< Back")), "btn_back");
    jBackBtn = NuiWidth(jBackBtn, 100.0f);
    jBottomRow = JsonArrayInsert(jBottomRow, jBackBtn);
    jBottomRow = JsonArrayInsert(jBottomRow, NuiSpacer());
    json jConfirmBtn = NuiId(NuiButton(JsonString("Choose a Background")), "btn_confirm");
    jConfirmBtn = NuiWidth(jConfirmBtn, 240.0f);
    jConfirmBtn = NuiEnabled(jConfirmBtn, NuiBind("confirm_enabled"));
    jBottomRow = JsonArrayInsert(jBottomRow, jConfirmBtn);
    jBottomRow = NuiRow(jBottomRow);

    // -- ROOT ---------------------------------------------------------
    json jRoot = JsonArray();
    jRoot = JsonArrayInsert(jRoot, jTopRow);
    jRoot = JsonArrayInsert(jRoot, jDescGroup);
    jRoot = JsonArrayInsert(jRoot, jBottomRow);
    jRoot = NuiCol(jRoot);

    json jWindow = NuiWindow(
        jRoot,
        JsonString("Character Creation - Background"),
        NuiBind("geometry"),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE)
    );

    int nToken = NuiCreate(oPC, jWindow, GS_BG_WINDOW);

    NuiSetBind(oPC, nToken, "geometry",         NuiRect(-1.0f, -1.0f, 900.0f, 760.0f));
    NuiSetBind(oPC, nToken, "selected_bg_text", JsonString(""));
    NuiSetBind(oPC, nToken, "confirm_enabled",  JsonBool(FALSE));

    int j;
    for (j = 0; j < 16; j++)
        NuiSetBind(oPC, nToken, "bg_sel_" + IntToString(j), JsonBool(FALSE));

    string sPrev = GetLocalString(oPC, "GS_SELECTED_BG");
    if (sPrev != "")
    {
        string sRem = "Appraiser|Bully|Confidant|Devout|Farmer|Flirt|Foreigner|Militia|Natural Leader|Savvy|Tale Teller|Talent|Troublemaker|Veteran|Wild Child|Wizard's Apprentice";
        int nIdx = 0;
        while (sRem != "")
        {
            int nP = FindSubString(sRem, "|");
            string sN;
            if (nP == -1) { sN = sRem; sRem = ""; }
            else { sN = GetStringLeft(sRem, nP); sRem = GetStringRight(sRem, GetStringLength(sRem) - nP - 1); }
            if (sN == sPrev)
            {
                NuiSetBind(oPC, nToken, "bg_sel_" + IntToString(nIdx), JsonBool(TRUE));
                string sCombined = gsGetBackgroundDesc(sPrev) + "\n\n---\n\n" + gsGetBackgroundBonus(sPrev);
                NuiSetBind(oPC, nToken, "selected_bg_text", JsonString(sCombined));
                NuiSetBind(oPC, nToken, "confirm_enabled",  JsonBool(TRUE));
                break;
            }
            nIdx++;
        }
    }
}
