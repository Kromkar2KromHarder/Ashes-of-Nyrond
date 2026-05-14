#include "gs_inc_common"
#include "gs_inc_location"
#include "gs_inc_pc"
#include "gs_inc_text"

void gsReboot()
{
    //save location
    object oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        if (! GetIsDM(oPC))
        {
            gsLOSetDBLocation("GS_LOCATION",
                              gsPCGetPlayerID(oPC),
                              oPC);
        }

        oPC = GetNextPC();
    }

    //export
    ExportAllCharacters();

    //restart
    StartNewModule(GetName(GetModule()));
}
//----------------------------------------------------------------
void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;

    gsCMSendMessageToAllPCs(GS_T_16777233);
    DelayCommand(60.0, gsReboot());
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
}
