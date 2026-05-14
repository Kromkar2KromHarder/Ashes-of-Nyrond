/* PC Library by Gigaschatten */

//void main() {}

//return unique id of oPC
string gsPCGetPlayerID(object oPC);
//return index of oPC
int gsPCGetPlayerIndex(object oPC);
//return player by sID
object gsPCGetPlayerByID(string sID);
//return player by nIndex
object gsPCGetPlayerByIndex(int nIndex);
//return player by sCDKey
object gsPCGetPlayerByCDKey(string sCDKey);
//return TRUE if oPC is active
int gsPCGetIsPlayerActive(object oPC);
//activate oPC
void gsPCActivatePlayer(object oPC);
//return roleplay state of oPC (0-100)
int gsPCGetRolePlay(object oPC);
//set roleplay state of oPC to nState (0-100)
void gsPCSetRolePlay(object oPC, int nState);

string gsPCGetPlayerID(object oPC)
{
    string sID = "";

    if (GetIsObjectValid(oPC) &&
        GetIsPC(oPC))
    {
        sID = GetLocalString(oPC, "GS_PC_ID");

        if (sID == "")
        {
            sID = GetStringLeft(GetPCPublicCDKey(oPC) + "_" + GetName(oPC), 32);

            SetLocalString(oPC, "GS_PC_ID", sID);
        }
    }

    return sID;
}
//----------------------------------------------------------------
int gsPCGetPlayerIndex(object oPC)
{
    int nIndex = FALSE;

    if (GetIsObjectValid(oPC) &&
        GetIsPC(oPC))
    {
        nIndex = GetLocalInt(oPC, "GS_PC_INDEX");

        if (! nIndex)
        {
            string sPlayerID = gsPCGetPlayerID(oPC);

            if (sPlayerID != "")
            {
                nIndex = GetCampaignInt("GS_PC_INDEX", sPlayerID);

                if (! nIndex)
                {
                    nIndex = GetCampaignInt("GS_PC_INDEX", "COUNT") + 1;

                    SetCampaignInt("GS_PC_INDEX", sPlayerID, nIndex);
                    SetCampaignInt("GS_PC_INDEX", "COUNT", nIndex);
                    SetLocalInt(oPC, "GS_PC_INDEX", nIndex);
                }
            }
        }
    }

    return nIndex;
}
//----------------------------------------------------------------
object gsPCGetPlayerByID(string sID)
{
    object oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        if (gsPCGetPlayerID(oPC) == sID) return oPC;

        oPC = GetNextPC();
    }

    return OBJECT_INVALID;
}
//----------------------------------------------------------------
object gsPCGetPlayerByIndex(int nIndex)
{
    object oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        if (gsPCGetPlayerIndex(oPC) == nIndex) return oPC;

        oPC = GetNextPC();
    }

    return OBJECT_INVALID;
}
//----------------------------------------------------------------
object gsPCGetPlayerByCDKey(string sCDKey)
{
    object oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        if (GetPCPublicCDKey(oPC) == sCDKey) return oPC;

        oPC = GetNextPC();
    }

    return OBJECT_INVALID;
}
//----------------------------------------------------------------
int gsPCGetIsPlayerActive(object oPC)
{
    return GetCampaignInt("GS_PC_ACTIVITY", gsPCGetPlayerID(oPC));
}
//----------------------------------------------------------------
void gsPCActivatePlayer(object oPC)
{
    SetCampaignInt("GS_PC_ACTIVITY", gsPCGetPlayerID(oPC), TRUE);
}
//----------------------------------------------------------------
int gsPCGetRolePlay(object oPC)
{
    if (GetIsPossessedFamiliar(oPC)) oPC = GetMaster(oPC);
    if (! GetIsPC(oPC))              return FALSE;
    if (GetIsDM(oPC))                return FALSE;
    if (GetIsDMPossessed(oPC))       return FALSE;

    int nState = GetLocalInt(oPC, "GS_PC_ROLEPLAY");

    if (! nState)
    {
        string sCDKey = GetPCPublicCDKey(oPC);
        nState        = GetCampaignInt("GS_PC_ROLEPLAY", sCDKey);

        if (! nState)
        {
            nState = 1;
            SetCampaignInt("GS_PC_ROLEPLAY", sCDKey, nState);
        }

        SetLocalInt(oPC, "GS_PC_ROLEPLAY", nState);
    }

    return nState - 1;
}
//----------------------------------------------------------------
void gsPCSetRolePlay(object oPC, int nState)
{
    if (GetIsPossessedFamiliar(oPC)) oPC = GetMaster(oPC);
    if (! GetIsPC(oPC))              return;
    if (GetIsDM(oPC))                return;
    if (GetIsDMPossessed(oPC))       return;

    nState += 1;

    if (nState < 1)        nState =   1;
    else if (nState > 101) nState = 101;

    SetLocalInt(oPC, "GS_PC_ROLEPLAY", nState);
    SetCampaignInt("GS_PC_ROLEPLAY", GetPCPublicCDKey(oPC), nState);
}
