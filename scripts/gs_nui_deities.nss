#include "nw_inc_nui"
#include "gs_nui_charmake"

const string GS_DEITY_WINDOW = "gs_deitycreate";

void gsOpenDeityWindow(object oPC)
{
    int nExisting = NuiFindWindow(oPC, GS_DEITY_WINDOW);
    if (nExisting != 0) NuiDestroy(oPC, nExisting);

    // -- TOP ROW: character panel left, alignment right ---------------
    json jTopRow = JsonArray();

    // left: character info panel
    json jLeftPanel = gsCharInfoPanel(oPC);

    // right: alignment grid + description
    json jAlignCol = JsonArray();

    json jAlignHeader = NuiLabel(JsonString("= Alignment Selection ="), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jAlignHeader = NuiHeight(jAlignHeader, 36.0f);
    jAlignCol = JsonArrayInsert(jAlignCol, NuiRow(JsonArrayInsert(JsonArray(), jAlignHeader)));

    // 3x3 grid
    string saLabels = "Lawful Good|Neutral Good|Chaotic Good|Lawful Neutral|True Neutral|Chaotic Neutral|Lawful Evil|Neutral Evil|Chaotic Evil";
    string saIds    = "LG|NG|CG|LN|TN|CN|LE|NE|CE";
    int nRow;
    for (nRow = 0; nRow < 3; nRow++)
    {
        json jGridRow = JsonArray();
        int nCol;
        for (nCol = 0; nCol < 3; nCol++)
        {
            int nIdx = nRow * 3 + nCol;

            string sLabel = "";
            string sId    = "";
            string sLR = saLabels;
            string sIR = saIds;
            int nC = 0;
            while (sLR != "" && nC <= nIdx)
            {
                int nP = FindSubString(sLR, "|");
                if (nP == -1) { sLabel = sLR; sLR = ""; }
                else { sLabel = GetStringLeft(sLR, nP); sLR = GetStringRight(sLR, GetStringLength(sLR) - nP - 1); }
                nC++;
            }
            nC = 0;
            while (sIR != "" && nC <= nIdx)
            {
                int nP = FindSubString(sIR, "|");
                if (nP == -1) { sId = sIR; sIR = ""; }
                else { sId = GetStringLeft(sIR, nP); sIR = GetStringRight(sIR, GetStringLength(sIR) - nP - 1); }
                nC++;
            }

            json jBtn = NuiId(NuiButtonSelect(JsonString(sLabel), NuiBind("align_sel_" + sId)), "align_btn_" + sId);
            jBtn = NuiHeight(jBtn, 36.0f);
            jGridRow = JsonArrayInsert(jGridRow, jBtn);
        }
        jAlignCol = JsonArrayInsert(jAlignCol, NuiRow(jGridRow));
    }

    // alignment description box
    json jAlignDescRow = JsonArray();
    json jAlignDesc = NuiText(NuiBind("align_desc"), FALSE, NUI_SCROLLBARS_NONE);
    jAlignDesc = NuiHeight(jAlignDesc, 160.0f);
    jAlignDescRow = JsonArrayInsert(jAlignDescRow, jAlignDesc);
    jAlignCol = JsonArrayInsert(jAlignCol, NuiRow(jAlignDescRow));

    jAlignCol = NuiCol(jAlignCol);
    json jAlignGroup = NuiGroup(jAlignCol, TRUE, NUI_SCROLLBARS_NONE);

    jTopRow = JsonArrayInsert(jTopRow, jLeftPanel);
    jTopRow = JsonArrayInsert(jTopRow, jAlignGroup);
    jTopRow = NuiRow(jTopRow);

    // -- BOTTOM ROW: deity list left, deity desc right (50/50) --------
    json jBotRow = JsonArray();

    // deity list (left)
    json jDeityCol = JsonArray();

    json jDeityHeader = NuiLabel(JsonString("= Deity Selection ="), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jDeityHeader = NuiHeight(jDeityHeader, 30.0f);
    jDeityCol = JsonArrayInsert(jDeityCol, NuiRow(JsonArrayInsert(JsonArray(), jDeityHeader)));

    json jPrevNextRow = JsonArray();
    json jPrevBtn = NuiId(NuiButton(JsonString("< Previous")), "deity_prev");
    jPrevBtn = NuiWidth(jPrevBtn, 130.0f);
    json jNextBtn = NuiId(NuiButton(JsonString("Next >")), "deity_next");
    jNextBtn = NuiWidth(jNextBtn, 130.0f);
    jPrevNextRow = JsonArrayInsert(jPrevNextRow, jPrevBtn);
    jPrevNextRow = JsonArrayInsert(jPrevNextRow, NuiSpacer());
    jPrevNextRow = JsonArrayInsert(jPrevNextRow, jNextBtn);
    jDeityCol = JsonArrayInsert(jDeityCol, NuiRow(jPrevNextRow));

    json jDeityListRow = JsonArray();
    json jDeityList = NuiText(JsonString("Deity list coming soon."), FALSE, NUI_SCROLLBARS_NONE);
    jDeityList = NuiHeight(jDeityList, 200.0f);
    jDeityListRow = JsonArrayInsert(jDeityListRow, jDeityList);
    jDeityCol = JsonArrayInsert(jDeityCol, NuiRow(jDeityListRow));

    jDeityCol = NuiCol(jDeityCol);
    json jDeityGroup = NuiGroup(jDeityCol, TRUE, NUI_SCROLLBARS_NONE);

    // deity description (right)
    json jDeityDescCol = JsonArray();

    json jDeityDescHeader = NuiLabel(JsonString("= Deity Description ="), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jDeityDescHeader = NuiHeight(jDeityDescHeader, 30.0f);
    jDeityDescCol = JsonArrayInsert(jDeityDescCol, NuiRow(JsonArrayInsert(JsonArray(), jDeityDescHeader)));

    json jDeityDescRow = JsonArray();
    json jDeityDesc = NuiText(NuiBind("deity_desc"), FALSE, NUI_SCROLLBARS_NONE);
    jDeityDesc = NuiHeight(jDeityDesc, 240.0f);
    jDeityDescRow = JsonArrayInsert(jDeityDescRow, jDeityDesc);
    jDeityDescCol = JsonArrayInsert(jDeityDescCol, NuiRow(jDeityDescRow));

    jDeityDescCol = NuiCol(jDeityDescCol);
    json jDeityDescGroup = NuiGroup(jDeityDescCol, TRUE, NUI_SCROLLBARS_NONE);

    jBotRow = JsonArrayInsert(jBotRow, jDeityGroup);
    jBotRow = JsonArrayInsert(jBotRow, jDeityDescGroup);
    jBotRow = NuiRow(jBotRow);

    // -- BOTTOM BAR ---------------------------------------------------
    json jBottomBar = JsonArray();
    json jBackBtn = NuiId(NuiButton(JsonString("< Back")), "btn_back");
    jBackBtn = NuiWidth(jBackBtn, 100.0f);
    jBottomBar = JsonArrayInsert(jBottomBar, jBackBtn);
    jBottomBar = JsonArrayInsert(jBottomBar, NuiSpacer());
    json jFinalBtn = NuiId(NuiButton(JsonString("Finalize Selections")), "btn_finalize");
    jFinalBtn = NuiWidth(jFinalBtn, 200.0f);
    jFinalBtn = NuiEnabled(jFinalBtn, NuiBind("finalize_enabled"));
    jBottomBar = JsonArrayInsert(jBottomBar, jFinalBtn);
    jBottomBar = NuiRow(jBottomBar);

    // -- ROOT ---------------------------------------------------------
    json jRoot = JsonArray();
    jRoot = JsonArrayInsert(jRoot, jTopRow);
    jRoot = JsonArrayInsert(jRoot, jBotRow);
    jRoot = JsonArrayInsert(jRoot, jBottomBar);
    jRoot = NuiCol(jRoot);

    json jWindow = NuiWindow(
        jRoot,
        JsonString("Character Creation - Deity & Alignment"),
        NuiBind("geometry"),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE)
    );

    int nToken = NuiCreate(oPC, jWindow, GS_DEITY_WINDOW);

    NuiSetBind(oPC, nToken, "geometry",         NuiRect(-1.0f, -1.0f, 900.0f, 760.0f));
    NuiSetBind(oPC, nToken, "align_desc",       JsonString(""));
    NuiSetBind(oPC, nToken, "deity_desc",       JsonString(""));
    NuiSetBind(oPC, nToken, "finalize_enabled", JsonBool(FALSE));

    string sIR = saIds;
    while (sIR != "")
    {
        int nP = FindSubString(sIR, "|");
        string sId;
        if (nP == -1) { sId = sIR; sIR = ""; }
        else { sId = GetStringLeft(sIR, nP); sIR = GetStringRight(sIR, GetStringLength(sIR) - nP - 1); }
        NuiSetBind(oPC, nToken, "align_sel_" + sId, JsonBool(FALSE));
    }

    string sPrevAlign = GetLocalString(oPC, "GS_SELECTED_ALIGN");
    if (sPrevAlign != "")
    {
        NuiSetBind(oPC, nToken, "align_sel_" + sPrevAlign, JsonBool(TRUE));
        NuiSetBind(oPC, nToken, "finalize_enabled", JsonBool(TRUE));
    }
}
