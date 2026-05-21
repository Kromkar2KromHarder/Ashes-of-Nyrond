#include "nwnx_player"
#include "nwnx_sql"
#include "gs_inc_chain"
#include "gs_inc_encounter"
#include "gs_inc_xp"
#include "gs_inc_finance"
#include "gs_inc_fixture"
#include "gs_inc_flag"
#include "gs_inc_listener"
#include "gs_inc_text"
#include "gs_inc_worship"
#include "gs_inc_resources"

const int GS_TIMEOUT         = 3600; //1 hour
const int GS_EXPERIENCE_BASE = 1000; //level 2

void gsCreateBaseInventory(object oPC)
{
    object oInventory = GetObjectByTag("GS_INVENTORY_PLAYER");

    if (GetIsObjectValid(oInventory))
    {
        object oItem  = GetFirstItemInInventory(oInventory);
        object oCopy  = OBJECT_INVALID;
        object oDress = OBJECT_INVALID;

        while (GetIsObjectValid(oItem))
        {
            oCopy = CopyItem(oItem, oPC);

            if (GetIsObjectValid(oCopy))
            {
                SetIdentified(oCopy, TRUE);
                SetStolenFlag(oCopy, FALSE);

                if (! GetIsObjectValid(oDress) &&
                    GetBaseItemType(oCopy) == BASE_ITEM_ARMOR)
                {
                    oDress = oCopy;
                }
            }

            oItem = GetNextItemInInventory(oInventory);
        }

        if (GetIsObjectValid(oDress))
            AssignCommand(oPC, ActionEquipItem(oDress, INVENTORY_SLOT_CHEST));
    }
}
//----------------------------------------------------------------
void gsActivateRecreator(object oRecreator)
{
    object oObject = CreateObject(GetLocalInt(oRecreator, "GS_TYPE"),
                                  GetLocalString(oRecreator, "GS_TEMPLATE"),
                                  GetLocation(oRecreator));

    if (GetIsObjectValid(oObject)) SetLocalInt(oObject, "GS_STATIC", TRUE);

    SetPlotFlag(oRecreator, FALSE);
    DestroyObject(oRecreator);
}
//----------------------------------------------------------------
void gsActivateActivator(object oObject)
{
    ExecuteScript(GetLocalString(oObject, "GS_SCRIPT"), oObject);
}
//----------------------------------------------------------------
void main()
{
    object oEntering   = GetEnteringObject();
    if (! GetIsPC(oEntering)) return;
    string sMessage    = "";
    int nTimestamp     = GetLocalInt(GetModule(), "GS_TIMESTAMP");
    int nTimestampArea = GetLocalInt(OBJECT_SELF, "GS_TIMESTAMP");
    int nTimeout       = nTimestamp - nTimestampArea > GS_TIMEOUT;
    int nEnabled       = GetLocalInt(OBJECT_SELF, "GS_ENABLED");
    int nOverrideDeath = gsFLGetAreaFlag("OVERRIDE_DEATH", oEntering);

    //area flags
    if (gsFLGetAreaFlag("EXPLORE_MAP", oEntering))         ExploreAreaForPlayer(OBJECT_SELF, oEntering);
    if (gsFLGetAreaFlag("PVP", oEntering))                 sMessage += " [" + GS_T_16777291 + "]";
    if (gsFLGetAreaFlag("REST", oEntering))                sMessage += " [" + GS_T_16777292 + "]";
    if (! gsFLGetAreaFlag("OVERRIDE_STATE", oEntering))    sMessage += " [" + GS_T_16777293 + "]";
    if (! gsFLGetAreaFlag("OVERRIDE_TELEPORT", oEntering)) sMessage += " [" + GS_T_16777294 + "]";
    if (! nOverrideDeath)                                  sMessage += " [" + GS_T_16777295 + "]";
    if (sMessage != "")                                    SendMessageToPC(oEntering, GS_T_16777296 + ":" + sMessage);

    //area description
    sMessage = GetLocalString(OBJECT_SELF, "GS_TEXT");
    if (sMessage != "") DelayCommand(2.5, SendMessageToPC(oEntering, "<c???>" + sMessage));

    //load area
    if (! nEnabled)
    {
        gsENLoadArea();
        gsFXLoadFixture(GetTag(OBJECT_SELF));
    }

    //clean up area
    if (nTimestampArea != nTimestamp)
    {
        object oObject = GetFirstObjectInArea(OBJECT_SELF);
        string sTag    = "";

        while (GetIsObjectValid(oObject))
        {
            sTag = GetTag(oObject);

            switch (GetObjectType(oObject))
            {
            case OBJECT_TYPE_AREA_OF_EFFECT:
                if (nTimeout)
                {
                    DestroyObject(oObject);
                }
                break;

            case OBJECT_TYPE_CREATURE:
                if (GetIsDead(oObject))
                {
                    if (gsFLGetFlag(GS_FL_MORTAL, oObject))
                    {
                        gsCMDestroyObject(oObject);
                    }
                    else if (nTimeout &&
                             GetLocalInt(oObject, "GS_TIMEOUT") < nTimestamp)
                    {
                        gsCMResurrect(oObject);
                    }
                }
                else if (nTimeout &&
                         gsENGetIsEncounterCreature(oObject) &&
                         GetLocalInt(oObject, "GS_TIMEOUT") < nTimestamp)
                {
                    gsCMDestroyObject(oObject);
                }
                else
                {
                    SetAILevel(oObject, AI_LEVEL_LOW);
                }
                break;

            case OBJECT_TYPE_DOOR:
                if (nTimeout &&
                    GetIsOpen(oObject))
                {
                    AssignCommand(oObject, ActionCloseDoor(oObject));
                }
                if (GetLockLockable(oObject))
                {
                    SetLocked(oObject, TRUE);
                }
                break;

            case OBJECT_TYPE_ENCOUNTER:
                break;

            case OBJECT_TYPE_ITEM:
                if (nTimeout)
                {
                    gsCMDestroyObject(oObject);
                }
                break;

            case OBJECT_TYPE_PLACEABLE:
                if (sTag == "GS_RECREATOR")
                {
                    if (nTimeout &&
                        GetLocalInt(oObject, "GS_TIMEOUT") < nTimestamp)
                    {
                        DelayCommand(0.5, gsActivateRecreator(oObject));
                    }
                }
                else if (sTag == "GS_ACTIVATOR")
                {
                    DelayCommand(0.5, gsActivateActivator(oObject));
                }
                else if (nEnabled)
                {
                    if (nTimeout)
                    {
                        if (! GetLocalInt(oObject, "GS_STATIC"))
                        {
                            SetPlotFlag(oObject, FALSE);
                            gsCMDestroyObject(oObject);
                            break;
                        }

                        if (GetIsOpen(oObject))
                        {
                            AssignCommand(oObject, ActionCloseDoor(oObject));
                        }
                    }

                    if (GetLockLockable(oObject))
                    {
                        SetLocked(oObject, TRUE);
                    }
                }
                else
                {
                    SetLocalInt(oObject, "GS_STATIC", TRUE);
                }
                break;

            case OBJECT_TYPE_STORE:
                break;

            case OBJECT_TYPE_TRIGGER:
                break;

            case OBJECT_TYPE_WAYPOINT:
                break;
            }

            oObject = GetNextObjectInArea(OBJECT_SELF);
        }
    }

    SetLocalInt(OBJECT_SELF, "GS_TIMESTAMP", nTimestamp);
    SetLocalInt(OBJECT_SELF, "GS_ENABLED",   TRUE);

    if (GetIsPossessedFamiliar(oEntering)) return;
    if (GetIsDMPossessed(oEntering))       return;
    if (GetIsDM(oEntering))
    {
        if (! GetLocalInt(oEntering, "GS_ENABLED"))
        {
            object oTarget = GetObjectByTag("GS_TARGET_DM");

            if (GetIsObjectValid(oTarget))
                AssignCommand(oEntering, JumpToLocation(GetLocation(oTarget)));
            SetLocalInt(oEntering, "GS_ENABLED", TRUE);
        }

        return;
    }

    //mortality
    SetImmortal(oEntering, nOverrideDeath);

    switch (GetLocalInt(oEntering, "GS_ENABLED"))
    {
case TRUE:
    ExportSingleCharacter(oEntering);
    WriteTimestampedLogEntry("DEBUG: case TRUE hit for " + GetName(oEntering));
    DelayCommand(3.0, gsRestoreResources(oEntering));
    break;

    case -1:
        //listener
        gsLICreateListener(oEntering);
        //player activation
        if (! gsPCGetIsPlayerActive(oEntering))
        {
            if (GetHitDice(oEntering) == 1)
            {
                //remove gold
                AssignCommand(oEntering,
                              TakeGoldFromCreature(GetGold(oEntering),
                                                   oEntering,
                                                   TRUE));
                //remove inventory
                gsCMDestroyInventory(oEntering);
                //give base experience
                if (GetXP(oEntering) < GS_EXPERIENCE_BASE)
                    GiveXPToCreature(oEntering, GS_EXPERIENCE_BASE);
            }
            //create base inventory
            DelayCommand(0.5, gsCreateBaseInventory(oEntering));
            //open bank account
            gsFIOpenAccount(oEntering);
            gsPCActivatePlayer(oEntering);
        }
        //chain
        if (gsCHGetHasChain())
        {
            object oChain = gsCHGetChain(oEntering);
            gsCHRemoveChain(oChain);
            gsCHApplyChain(oChain, oEntering);
        }
        SendMessageToPC(oEntering, GS_T_16777216);
        DelayCommand(3.0, gsRestoreResources(oEntering));
        SetLocalInt(oEntering, "GS_ENABLED", TRUE);
        break;
    }

//exploration XP
if (GetLocalInt(oEntering, "GS_ENABLED") == TRUE)
{
    string sAreaTag = GetTag(OBJECT_SELF);
    if (! GetLocalInt(oEntering, "GS_EXPLORED_" + sAreaTag))
    {
        SetLocalInt(oEntering, "GS_EXPLORED_" + sAreaTag, TRUE);
        NWNX_SQL_ExecuteQuery("INSERT INTO explored_areas (bic, area_tag) VALUES ('" + NWNX_Player_GetBicFileName(oEntering) + "', '" + sAreaTag + "')");
        SendMessageToPC(oEntering, "<c???>You have discovered a new area.");
        gsXPGiveExperience(oEntering, 15 + Random(26));
    }
}
    //verify deity
    string sDeity = GetDeity(oEntering);
    if (sDeity != "" &&
        ! gsWOGetDeityByName(sDeity))
    {
        SetDeity(oEntering, "");
        SendMessageToPC(oEntering, GS_T_16777297);
    }
    //encounter
    if ((nTimeout || ! nEnabled) &&
        gsENGetEncounterChance())
    {
        int nNth = 0;
        for (; nNth < 5; nNth++)
        {
            DelayCommand(1.0 + IntToFloat(nNth) * 0.5,
                         gsENSpawnByChance());
        }
    }
}

