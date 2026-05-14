#include "sw_tools"


int Is2daValid()
{
    string sWizardMemorizes = Get2DAString("classes", "MemorizesSpells", CLASS_TYPE_WIZARD);
    string sWizardSpellTable = Get2DAString("classes", "MemorizesSpells", CLASS_TYPE_WIZARD);

    return (sWizardMemorizes != "" && sWizardSpellTable !="");
}

void main()
{
    if (Is2daValid())
    {
        SendMessageToPC(OBJECT_SELF, "Confirmed valid 2DA file, continuing override script.");
        int bOverriddenAlready = GetLocalInt(GetModule(), SW_OVERRIDE_COMPLETE);
        int bVersion2Upgrade = GetLocalInt(GetModule(), SW_VERSION2_UPGRADE);

        if (!bOverriddenAlready)
        {
            SaveWidgetLocation(OBJECT_SELF, 10.0f, 420.0f);
            SaveSubradialLocation(OBJECT_SELF, -1.0f, -1.0f);

            string sExistingRestScript = GetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_REST);
            string sExistingLevelUpScript = GetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_LEVEL_UP);
            string sExistingItemActScript = GetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_ACTIVATE_ITEM);
            string sExistingPlayerTarget = GetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_TARGET);
            string sExistingNuiScript = GetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_NUI_EVENT);

            string sExistingSpellHook = GetLocalString(GetModule(), "X2_S_UD_SPELLSCRIPT");
            string sTagPrefix = GetLocalString(GetModule(),"MODULE_VAR_TAGBASED_SCRIPT_PREFIX");

            if (sExistingRestScript != "")
            {
                SetLocalString(GetModule(), SW_OVERRIDDEN_REST_SCRIPT, sExistingRestScript);
            }
            SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_REST, "sw_on_plyr_rest");

            if (sExistingLevelUpScript != "")
            {
                SetLocalString(GetModule(), SW_OVERRIDDEN_LVLUP_SCRIPT, sExistingLevelUpScript);
            }
            SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_LEVEL_UP, "sw_on_plyr_lvl");

            if (sExistingItemActScript != "x2_mod_def_act" || sTagPrefix != "")
            {
                SetLocalString(GetModule(), SW_OVERRIDDEN_ACT_ITM_SCRIPT, sExistingItemActScript);
                SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_ACTIVATE_ITEM, "sw_mod_def_act");
            }

            if (sExistingPlayerTarget != "")
            {
                SetLocalString(GetModule(), SW_OVERRIDDEN_PLYR_TRGT_SCRIPT, sExistingPlayerTarget);
            }
            SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_TARGET, "sw_plyr_trgt");

            if (sExistingNuiScript != "")
            {
                SetLocalString(GetModule(), SW_OVERRIDDEN_NUI_SCRIPT, sExistingNuiScript);
            }
            SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_NUI_EVENT, "sw_ui_evt_handle");

            if (sExistingSpellHook != "")
            {
                SetLocalString(GetModule(), SW_OVERRIDDEN_SPELL_HOOK, sExistingSpellHook);
            }
            SetLocalString(GetModule(), "X2_S_UD_SPELLSCRIPT", "sw_spell_hook");

            SetLocalInt(GetModule(), SW_OVERRIDE_COMPLETE, TRUE);

        }
        else
        {
            SendMessageToPC(OBJECT_SELF, "Override script already run, skipping script setup");
        }

        if (!bVersion2Upgrade)
        {
            string sExistingChatScript = GetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_CHAT);
            if (sExistingChatScript != "")
            {
                SetLocalString(GetModule(), SW_OVERRIDDEN_PLYR_CHAT, sExistingChatScript);
            }
            SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_CHAT, "sw_on_plyr_chat");
            SetLocalInt(GetModule(), SW_VERSION2_UPGRADE, TRUE);
            CreateItemOnObject("sw_conf_orb");

            SendMessageToPC(OBJECT_SELF, "Version 2 upgrade completed");
        }

        CreateItemOnObject("sw_it_mbook");
    }
    else 
    {
        SendMessageToPC(OBJECT_SELF, "Invalid classes.2da file, override script aborted");
    }
}