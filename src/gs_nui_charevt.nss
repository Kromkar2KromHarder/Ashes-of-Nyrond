#include "gs_nui_welcome"
#include "gs_nui_charmake"
#include "gs_nui_deities"

string gsGetBackgroundByIndex(int nIdx)
{
    if (nIdx == 0)  return "Appraiser";
    if (nIdx == 1)  return "Bully";
    if (nIdx == 2)  return "Confidant";
    if (nIdx == 3)  return "Devout";
    if (nIdx == 4)  return "Farmer";
    if (nIdx == 5)  return "Flirt";
    if (nIdx == 6)  return "Foreigner";
    if (nIdx == 7)  return "Militia";
    if (nIdx == 8)  return "Natural Leader";
    if (nIdx == 9)  return "Savvy";
    if (nIdx == 10) return "Tale Teller";
    if (nIdx == 11) return "Talent";
    if (nIdx == 12) return "Troublemaker";
    if (nIdx == 13) return "Veteran";
    if (nIdx == 14) return "Wild Child";
    if (nIdx == 15) return "Wizard's Apprentice";
    return "";
}

string gsGetAlignmentDesc(string sId)
{
    if (sId == "LG") return "Lawful Good characters believe in honor, justice, and doing what is right within a structured society. They follow laws and codes, but only insofar as those laws serve the greater good.";
    if (sId == "NG") return "Neutral Good characters do what is good and kind without bias toward law or chaos. They follow their conscience, helping others wherever they can.";
    if (sId == "CG") return "Chaotic Good characters follow their hearts and do what they believe is right, often disregarding laws that they see as unjust or oppressive.";
    if (sId == "LN") return "Lawful Neutral characters believe in order, tradition, and structure above all else. They follow the law without moral bias.";
    if (sId == "TN") return "True Neutral characters avoid taking sides, believing in balance between all forces. They act without strong moral or ethical preferences.";
    if (sId == "CN") return "Chaotic Neutral characters follow their whims and personal freedom above all else. They are unpredictable and value their own liberty.";
    if (sId == "LE") return "Lawful Evil characters use order and structure to further their own selfish ends. They follow rules only when it benefits them.";
    if (sId == "NE") return "Neutral Evil characters do whatever they can get away with to advance themselves. They have no loyalty to others and no compunctions about harming them.";
    if (sId == "CE") return "Chaotic Evil characters act with arbitrary violence, driven by greed, hatred, or bloodlust. They have no regard for rules, others' lives, or any code of conduct.";
    return "";
}

void main()
{
    object oPC    = NuiGetEventPlayer();
    int nToken    = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElem  = NuiGetEventElement();
    string sWndId = NuiGetWindowId(oPC, nToken);

    if (sEvent != "click") return;

    // -- WELCOME WINDOW -----------------------------------------------
    if (sWndId == GS_WELCOME_WINDOW)
    {
        if (sElem == "btn_understood")
        {
            NuiDestroy(oPC, nToken);
            gsOpenSettingWindow(oPC);
        }
        return;
    }

    // -- SETTING WINDOW -----------------------------------------------
    if (sWndId == GS_SETTING_WINDOW)
    {
        if (sElem == "btn_back")
        {
            NuiDestroy(oPC, nToken);
            gsOpenWelcomeWindow(oPC);
        }
        if (sElem == "btn_understood")
        {
            NuiDestroy(oPC, nToken);
            gsOpenOriginWindow(oPC);
        }
        return;
    }

    // -- ORIGIN WINDOW ------------------------------------------------
    if (sWndId == GS_ORIGIN_WINDOW)
    {
        if (sElem == "origin_nyrond")
        {
            SetLocalString(oPC, "GS_SELECTED_ORIGIN", "Nyrond");
            NuiSetBind(oPC, nToken, "sel_nyrond",      JsonBool(TRUE));
            NuiSetBind(oPC, nToken, "sel_foreign",     JsonBool(FALSE));
            NuiSetBind(oPC, nToken, "origin_desc",     JsonString(GS_ORIGIN_NYROND));
            NuiSetBind(oPC, nToken, "confirm_enabled", JsonBool(TRUE));
            return;
        }
        if (sElem == "origin_foreign")
        {
            SetLocalString(oPC, "GS_SELECTED_ORIGIN", "Foreign");
            NuiSetBind(oPC, nToken, "sel_nyrond",      JsonBool(FALSE));
            NuiSetBind(oPC, nToken, "sel_foreign",     JsonBool(TRUE));
            NuiSetBind(oPC, nToken, "origin_desc",     JsonString(GS_ORIGIN_FOREIGN));
            NuiSetBind(oPC, nToken, "confirm_enabled", JsonBool(TRUE));
            return;
        }
        if (sElem == "btn_back")
        {
            NuiDestroy(oPC, nToken);
            gsOpenSettingWindow(oPC);
            return;
        }
        if (sElem == "btn_confirm")
        {
            NuiDestroy(oPC, nToken);
            gsOpenBGWindow(oPC);
            return;
        }
        return;
    }

    // -- BACKGROUND WINDOW --------------------------------------------
    if (sWndId == GS_BG_WINDOW)
    {
        if (GetStringLeft(sElem, 7) == "bg_btn_")
        {
            int nIdx     = StringToInt(GetStringRight(sElem, GetStringLength(sElem) - 7));
            string sName = gsGetBackgroundByIndex(nIdx);
            SetLocalString(oPC, "GS_SELECTED_BG", sName);

            int j;
            for (j = 0; j < 16; j++)
                NuiSetBind(oPC, nToken, "bg_sel_" + IntToString(j), JsonBool(FALSE));
            NuiSetBind(oPC, nToken, "bg_sel_" + IntToString(nIdx), JsonBool(TRUE));

            string sCombined = gsGetBackgroundDesc(sName) + "\n\n---\n\n" + gsGetBackgroundBonus(sName);
            NuiSetBind(oPC, nToken, "selected_bg_text", JsonString(sCombined));
            NuiSetBind(oPC, nToken, "confirm_enabled",  JsonBool(TRUE));
            return;
        }
        if (sElem == "btn_back")
        {
            NuiDestroy(oPC, nToken);
            gsOpenOriginWindow(oPC);
            return;
        }
        if (sElem == "btn_confirm")
        {
            NuiDestroy(oPC, nToken);
            gsOpenDeityWindow(oPC);
            return;
        }
        return;
    }

    // -- DEITY/ALIGNMENT WINDOW ---------------------------------------
    if (sWndId == GS_DEITY_WINDOW)
    {
        if (GetStringLeft(sElem, 10) == "align_btn_")
        {
            string sId = GetStringRight(sElem, GetStringLength(sElem) - 10);
            SetLocalString(oPC, "GS_SELECTED_ALIGN", sId);

            string saIds = "LG|NG|CG|LN|TN|CN|LE|NE|CE";
            string sIdRem = saIds;
            while (sIdRem != "")
            {
                int nP = FindSubString(sIdRem, "|");
                string sCur;
                if (nP == -1) { sCur = sIdRem; sIdRem = ""; }
                else { sCur = GetStringLeft(sIdRem, nP); sIdRem = GetStringRight(sIdRem, GetStringLength(sIdRem) - nP - 1); }
                NuiSetBind(oPC, nToken, "align_sel_" + sCur, JsonBool(sCur == sId));
            }
            NuiSetBind(oPC, nToken, "align_desc", JsonString(gsGetAlignmentDesc(sId)));
            NuiSetBind(oPC, nToken, "finalize_enabled", JsonBool(TRUE));
            return;
        }
        if (sElem == "btn_back")
        {
            NuiDestroy(oPC, nToken);
            gsOpenBGWindow(oPC);
            return;
        }
        if (sElem == "btn_finalize")
        {
            NuiDestroy(oPC, nToken);
            // save to DB and finish — coming next
            FloatingTextStringOnCreature(
                "Origin: "     + GetLocalString(oPC, "GS_SELECTED_ORIGIN") +
                " | BG: "      + GetLocalString(oPC, "GS_SELECTED_BG")     +
                " | Align: "   + GetLocalString(oPC, "GS_SELECTED_ALIGN"),
                oPC, FALSE);
            return;
        }
        return;
    }
}
