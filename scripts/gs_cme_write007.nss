#include "gs_inc_common"
#include "gs_inc_message"

const string GS_TEMPLATE_LETTER = "gs_item370";

void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        string sTitle     = GetLocalString(OBJECT_SELF, "GS_ME_TITLE");
        string sText      = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_1");
        string sLine      = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_2");

        if (sLine != "")
        {
            sText += "\n" + sLine;
            sLine  = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_3");

            if (sLine != "")
            {
                sText += "\n" + sLine;
                sLine  = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_4");

                if (sLine != "") sText += "\n" + sLine;
            }
        }

        string sMessageID = gsCMCreateRandomID();
        object oObject    = CreateObject(OBJECT_TYPE_ITEM,
                                         GS_TEMPLATE_LETTER,
                                         GetLocation(OBJECT_SELF),
                                         FALSE,
                                         "GS_ME_" + sMessageID);

        if (GetIsObjectValid(oObject))
        {
            gsMESetMessage(sMessageID, sTitle, sText);
            ActionPickUpItem(oObject);
            SetPlotFlag(oTarget, FALSE);
            DestroyObject(oTarget);
        }
    }
}
