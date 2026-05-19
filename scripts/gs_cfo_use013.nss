#include "gs_inc_forum"

const string GS_TEMPLATE_LETTER = "gs_item370";

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_MESSAGE");

    if (nNth != -1)
    {
        string sMessageID = gsFOGetMessage(nNth);

        if (sMessageID != "")
        {
            object oSpeaker = GetPCSpeaker();

            if (GetIsDM(oSpeaker) ||
                gsFOGetOwner(sMessageID) == gsPCGetPlayerID(oSpeaker))
            {
                object oObject = CreateObject(OBJECT_TYPE_ITEM,
                                              GS_TEMPLATE_LETTER,
                                              GetLocation(oSpeaker),
                                              FALSE,
                                              "GS_ME_" + sMessageID);

                if (GetIsObjectValid(oObject))
                {
                    AssignCommand(oSpeaker, ActionPickUpItem(oObject));
                    gsFORemoveMessage(sMessageID);
                    DeleteLocalInt(OBJECT_SELF, "GS_MESSAGE");
                }
            }
        }
    }
}
