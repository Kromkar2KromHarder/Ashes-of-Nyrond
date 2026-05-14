#include "nwnx_sql"
#include "gs_inc_state"
#include "gs_inc_common"
#include "nwnx_player"

void main()
{
    object oExiting = GetExitingObject();

    //store health
    SetLocalInt(GetModule(),
                "GS_HEALTH_" + ObjectToString(oExiting),
                GetCurrentHitPoints(oExiting));

//save player data
string sCDKey = NWNX_Player_GetBicFileName(oExiting);
string sAreaTag = GetTag(GetArea(oExiting));
vector vPos = GetPosition(oExiting);
int nGold = GetGold(oExiting);
float fRest = gsSTGetState(GS_ST_REST, oExiting);

NWNX_SQL_ExecuteQuery("INSERT INTO player_data (bic, area_tag, pos_x, pos_y, pos_z, gold, rest_meter) VALUES ('" + sCDKey + "', '" + sAreaTag + "', " + FloatToString(vPos.x) + ", " + FloatToString(vPos.y) + ", " + FloatToString(vPos.z) + ", " + IntToString(nGold) + ", " + FloatToString(fRest) + ") ON DUPLICATE KEY UPDATE area_tag=VALUES(area_tag), pos_x=VALUES(pos_x), pos_y=VALUES(pos_y), pos_z=VALUES(pos_z), gold=VALUES(gold), rest_meter=VALUES(rest_meter)");
}
