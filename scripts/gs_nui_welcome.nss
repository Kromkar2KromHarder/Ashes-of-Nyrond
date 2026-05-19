#include "nw_inc_nui"

const string GS_WELCOME_WINDOW = "gs_welcome";
const string GS_SETTING_WINDOW = "gs_setting";

void gsOpenWelcomeWindow(object oPC)
{
    int nExisting = NuiFindWindow(oPC, GS_WELCOME_WINDOW);
    if (nExisting != 0) NuiDestroy(oPC, nExisting);

    json jCol = JsonArray();

    // image placeholder - 50% of height
    json jImgRow = JsonArray();
    json jImg = NuiLabel(JsonString("[Image]"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jImg = NuiHeight(jImg, 350.0f);
    jImgRow = JsonArrayInsert(jImgRow, jImg);
    jCol = JsonArrayInsert(jCol, NuiRow(jImgRow));

    // welcome header
    json jHeaderRow = JsonArray();
    json jHeader = NuiLabel(JsonString("Welcome to Ashes of Nyrond!"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jHeader = NuiHeight(jHeader, 36.0f);
    jHeaderRow = JsonArrayInsert(jHeaderRow, jHeader);
    jCol = JsonArrayInsert(jCol, NuiRow(jHeaderRow));

    // body text - 50% of height
    json jBodyRow = JsonArray();
    json jBody = NuiText(JsonString(""), FALSE, NUI_SCROLLBARS_NONE);
    jBody = NuiHeight(jBody, 310.0f);
    jBodyRow = JsonArrayInsert(jBodyRow, jBody);
    jCol = JsonArrayInsert(jCol, NuiRow(jBodyRow));

    jCol = NuiCol(jCol);

    // bottom bar
    json jBottomRow = JsonArray();
    jBottomRow = JsonArrayInsert(jBottomRow, NuiSpacer());
    json jConfirmBtn = NuiId(NuiButton(JsonString("Understood")), "btn_understood");
    jConfirmBtn = NuiWidth(jConfirmBtn, 200.0f);
    jBottomRow = JsonArrayInsert(jBottomRow, jConfirmBtn);
    jBottomRow = NuiRow(jBottomRow);

    json jRoot = JsonArray();
    jRoot = JsonArrayInsert(jRoot, jCol);
    jRoot = JsonArrayInsert(jRoot, jBottomRow);
    jRoot = NuiCol(jRoot);

    json jWindow = NuiWindow(
        jRoot,
        JsonString("Welcome to Ashes of Nyrond"),
        NuiBind("geometry"),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE)
    );

    int nToken = NuiCreate(oPC, jWindow, GS_WELCOME_WINDOW);
    NuiSetBind(oPC, nToken, "geometry", NuiRect(-1.0f, -1.0f, 900.0f, 760.0f));
}

void gsOpenSettingWindow(object oPC)
{
    int nExisting = NuiFindWindow(oPC, GS_SETTING_WINDOW);
    if (nExisting != 0) NuiDestroy(oPC, nExisting);

    json jCol = JsonArray();

    // image placeholder
    json jImgRow = JsonArray();
    json jImg = NuiLabel(JsonString("[Image]"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    jImg = NuiHeight(jImg, 350.0f);
    jImgRow = JsonArrayInsert(jImgRow, jImg);
    jCol = JsonArrayInsert(jCol, NuiRow(jImgRow));

    // body text
    json jBodyRow = JsonArray();
    json jBody = NuiText(JsonString(""), FALSE, NUI_SCROLLBARS_NONE);
    jBody = NuiHeight(jBody, 350.0f);
    jBodyRow = JsonArrayInsert(jBodyRow, jBody);
    jCol = JsonArrayInsert(jCol, NuiRow(jBodyRow));

    jCol = NuiCol(jCol);

    // bottom bar
    json jBottomRow = JsonArray();
    json jBackBtn = NuiId(NuiButton(JsonString("< Back")), "btn_back");
    jBackBtn = NuiWidth(jBackBtn, 100.0f);
    jBottomRow = JsonArrayInsert(jBottomRow, jBackBtn);
    jBottomRow = JsonArrayInsert(jBottomRow, NuiSpacer());
    json jConfirmBtn = NuiId(NuiButton(JsonString("Understood")), "btn_understood");
    jConfirmBtn = NuiWidth(jConfirmBtn, 200.0f);
    jBottomRow = JsonArrayInsert(jBottomRow, jConfirmBtn);
    jBottomRow = NuiRow(jBottomRow);

    json jRoot = JsonArray();
    jRoot = JsonArrayInsert(jRoot, jCol);
    jRoot = JsonArrayInsert(jRoot, jBottomRow);
    jRoot = NuiCol(jRoot);

    json jWindow = NuiWindow(
        jRoot,
        JsonString("Ashes of Nyrond - Setting Overview"),
        NuiBind("geometry"),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE)
    );

    int nToken = NuiCreate(oPC, jWindow, GS_SETTING_WINDOW);
    NuiSetBind(oPC, nToken, "geometry", NuiRect(-1.0f, -1.0f, 900.0f, 760.0f));
}
