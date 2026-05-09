#include "gs_inc_common"
#include "gs_inc_effect"
#include "gs_inc_event"
#include "gs_inc_flag"
#include "gs_inc_time"
#include "gs_inc_xp"

const string GS_TEMPLATE_CORPSE = "gs_placeable016";
const int GS_TIMEOUT            = 21600; //6 hours
const int GS_LIMIT_VALUE        = 10000;

void _gsDropLoot()
{
    SetPlotFlag(OBJECT_SELF, FALSE);

    if (! GetIsObjectValid(GetFirstItemInInventory()))
    {
        DestroyObject(OBJECT_SELF);
    }
}
//----------------------------------------------------------------
void gsDropLoot(object oSource)
{
    object oItem = OBJECT_INVALID;
    int nMortal  = gsFLGetFlag(GS_FL_MORTAL, oSource);
    int nValue   = 0;

    //gold
    TakeGoldFromCreature(GetGold(oSource), oSource);

    //creature slots
    if (nMortal)
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR,   oSource);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oSource);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oSource);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oSource);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);

        oItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_BELT, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_NECK, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oSource);

        if (GetIsObjectValid(oItem))
        {
            nValue = gsCMGetItemValue(oItem);

            if (nValue < GS_LIMIT_VALUE)
            {
                SetIdentified(oItem, nValue <= 100);
                ActionTakeItem(oItem, oSource);
            }
            else
            {
                DestroyObject(oItem);
            }
        }
    }

    //inventory
    oItem = GetFirstItemInInventory(oSource);

    while (GetIsObjectValid(oItem))
    {
        nValue = gsCMGetItemValue(oItem);

        if ((nMortal || GetDroppableFlag(oItem)) &&
            nValue < GS_LIMIT_VALUE)
        {
            SetIdentified(oItem, nValue <= 100);
            ActionTakeItem(oItem, oSource);
        }
        else if (nMortal)
        {
            DestroyObject(oItem);
        }

        oItem = GetNextItemInInventory(oSource);
    }

    ActionDoCommand(_gsDropLoot());
}
//----------------------------------------------------------------
void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_DEATH));

    gsFXBleed();

    SetLocalInt(OBJECT_SELF, "GS_TIMEOUT", gsTIGetActualTimestamp() + GS_TIMEOUT);

    object oKiller = GetLastKiller();
    int nKiller    = GetIsObjectValid(oKiller) &&
                     GetObjectType(oKiller) == OBJECT_TYPE_CREATURE &&
                     oKiller != OBJECT_SELF;
    int nOverride  = gsFLGetAreaFlag("PVP") ||
                     gsFLGetAreaFlag("OVERRIDE_DEATH");

    if (! nOverride)
    {
        if (nKiller)
        {
            gsXPRewardKill(oKiller);

            if (! gsFLGetFlag(GS_FL_DISABLE_CALL))
                SpeakString("GS_AI_ATTACK_TARGET", TALKVOLUME_SILENT_TALK);
        }

        if (! gsFLGetFlag(GS_FL_DISABLE_LOOT))
        {
            //create corpse
            object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE,
                                          GS_TEMPLATE_CORPSE,
                                          GetLocation(OBJECT_SELF));

            if (GetIsObjectValid(oCorpse))
            {
                //transfer inventory
                object oSelf = OBJECT_SELF;

                AssignCommand(oCorpse, gsDropLoot(oSelf));
                return;
            }
        }
    }

    if (gsFLGetFlag(GS_FL_MORTAL)) gsCMDestroyInventory();
}
