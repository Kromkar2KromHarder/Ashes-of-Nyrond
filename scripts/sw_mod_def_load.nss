
void main()
{
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_NUI_EVENT, "sw_ui_evt_handle");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_TARGET, "sw_plyr_trgt");
    SetLocalString(GetModule(), "X2_S_UD_SPELLSCRIPT", "sw_spell_hook");
     
    ExecuteScript("x2_mod_def_load");
}