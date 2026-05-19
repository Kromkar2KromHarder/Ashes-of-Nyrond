/* ENCOUNTER library by Gigaschatten */

//void main() {}

#include "gs_inc_area"

const int GS_EN_LIMIT_SLOT      = 40;
const int GS_EN_LIMIT_ENCOUNTER = 25;
const int GS_EN_LIMIT_SPAWN     =  6;

struct gsENLimit
{
    float fRating;
    int nCount;
};

//spawn creatures in oArea by nChance
void gsENSpawn(object oArea = OBJECT_SELF, int nChance = 100);
//spawn creatures in oArea by encounter chance
void gsENSpawnByChance(object oArea = OBJECT_SELF);
//spawn a maximum of nCount creatures by nChance at fDistance near lLocation depending on fChallenge and playing nEffect
void gsENSpawnAtLocation(float fChallenge, int nCount, location lLocation, float fDistance = 7.5, int nEffect = FALSE, int nChance = 100);
//internally used
void _gsENSpawnAtLocation(string sTemplate, location lLocation, int nEffect = FALSE);
//return default rating and creature limit of oArea
struct gsENLimit gsENGetDefaultLimit(object oArea = OBJECT_SELF);
//return random location in oArea (if possible out of player sight)
location gsENGetRandomLocation(object oArea = OBJECT_SELF);
//set encounter nChance of oArea
void gsENSetEncounterChance(int nChance, object oArea = OBJECT_SELF);
//return encounter chance of oArea
int gsENGetEncounterChance(object oArea = OBJECT_SELF);
//set oCreature for oArea with nChance of appearance
void gsENSetCreature(object oCreature, int nChance = 5, object oArea = OBJECT_SELF);
//set appearance nChance of creature in nSlot of oArea
void gsENSetCreatureChance(int nSlot, int nChance, object oArea = OBJECT_SELF);
//return name of creature in nSlot of oArea
string gsENGetCreatureName(int nSlot, object oArea = OBJECT_SELF);
//return template of creature in nSlot of oArea
string gsENGetCreatureTemplate(int nSlot, object oArea = OBJECT_SELF);
//return challenge rating of creature in nSlot of oArea
float gsENGetCreatureRating(int nSlot, object oArea = OBJECT_SELF);
//return appearance chance of creature in nSlot of oArea
int gsENGetCreatureChance(int nSlot, object oArea = OBJECT_SELF);
//remove creature in nSlot from oArea
void gsENRemoveCreature(int nSlot, object oArea = OBJECT_SELF);
//return TRUE if oCreature is an encounter
int gsENGetIsEncounterCreature(object oCreature = OBJECT_SELF);
//save settings of oArea
void gsENSaveArea(object oArea = OBJECT_SELF);
//load setting of oArea
void gsENLoadArea(object oArea = OBJECT_SELF);

void gsENSpawn(object oArea = OBJECT_SELF, int nChance = 100)
{
    struct gsENLimit stLimit = gsENGetDefaultLimit(oArea);

    if (stLimit.fRating > 0.0 &&
        stLimit.nCount > 0)
    {
        location lLocation = gsENGetRandomLocation(oArea);

        //spawn
        gsENSpawnAtLocation(stLimit.fRating,
                            stLimit.nCount,
                            lLocation,
                            7.5,
                            FALSE,
                            nChance);
    }
}
//----------------------------------------------------------------
void gsENSpawnByChance(object oArea = OBJECT_SELF)
{
    int nChance = gsENGetEncounterChance(oArea);

    if (nChance > 0 &&
        nChance + Random(100) >= 100)
    {
        gsENSpawn(oArea, nChance);
    }
}
//----------------------------------------------------------------
void gsENSpawnAtLocation(float fChallenge, int nCount, location lLocation, float fDistance = 7.5, int nEffect = FALSE, int nChance = 100)
{
    object oArea       = GetAreaFromLocation(lLocation);
    object oCreature   = OBJECT_INVALID;
    vector vPosition   = GetPositionFromLocation(lLocation);
    vector _vPosition;
    string sTemplate   = "";
    float fSizeX       = gsARGetSizeX(oArea) - 5.0;
    float fSizeY       = gsARGetSizeY(oArea) - 5.0;
    float _fChallenge  = fChallenge * 1.5;
    float fRating      = 0.0;
    int _nChance       = 0;

    int _nCount        = 0;
    int nLimit         = 0;
    int nRandom        = 0;
    int nSlot          = 0;

    string sNth        = "";
    int nNth1          = 0;
    int nNth2          = 0;

    //preselection
    for (nNth1 = 1; nNth1 <= GS_EN_LIMIT_SLOT; nNth1++)
    {
        sTemplate = gsENGetCreatureTemplate(nNth1, oArea);
        fRating   = gsENGetCreatureRating(nNth1, oArea);
        _nChance  = gsENGetCreatureChance(nNth1, oArea);

        if (sTemplate != "" &&
            fRating > 0.0 &&
            _nChance > 0 &&
            (fRating <= fChallenge ||
             Random(100) >= 98))
        {
            _nChance = fRating > fChallenge ?
                       FloatToInt(IntToFloat(_nChance) * _fChallenge / fRating) :
                       FloatToInt(IntToFloat(_nChance) * fRating * 1.5 / fChallenge);

            if (_nChance < 1)       _nChance =  1;
            else if (_nChance > 10) _nChance = 10;

            sNth    = IntToString(++_nCount);
            nLimit += _nChance;

            SetLocalInt(oArea, "GS_EN_SLOT_"  + sNth, nNth1);
            SetLocalInt(oArea, "GS_EN_LIMIT_" + sNth, nLimit);
        }
    }

    //spawn encounter
    fRating            = 0.0;
    nNth1              = 0;

    if (nCount > GS_EN_LIMIT_SPAWN) nCount = GS_EN_LIMIT_SPAWN;

    while (fRating < _fChallenge &&
           ++nNth1 <= nCount)
    {
        nRandom = Random(nLimit);

        for (nNth2 = 1; nNth2 <= _nCount; nNth2++)
        {
            sNth = IntToString(nNth2);

            if (nRandom < GetLocalInt(oArea, "GS_EN_LIMIT_" + sNth))
            {
                _vPosition  = vPosition + AngleToVector(IntToFloat(Random(360))) * fDistance;

                if (_vPosition.x > fSizeX)   _vPosition.x = fSizeX;
                else if (_vPosition.x < 5.0) _vPosition.x = 5.0;
                if (_vPosition.y > fSizeY)   _vPosition.y = fSizeY;
                else if (_vPosition.y < 5.0) _vPosition.y = 5.0;

                //spawn creature
                lLocation   = Location(oArea, _vPosition, 0.0);
                nSlot       = GetLocalInt(oArea, "GS_EN_SLOT_" + sNth);
                sTemplate   = gsENGetCreatureTemplate(nSlot, oArea);
                fRating    += gsENGetCreatureRating(nSlot, oArea);

                DelayCommand(IntToFloat(nNth1) / 10,
                             _gsENSpawnAtLocation(sTemplate, lLocation, nEffect));
                break;
            }
        }

        if (Random(100) > nChance) break;
    }
}
//----------------------------------------------------------------
void _gsENSpawnAtLocation(string sTemplate, location lLocation, int nEffect = FALSE)
{
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sTemplate, lLocation);

    if (GetIsObjectValid(oCreature))
    {
        SetLocalInt(oCreature, "GS_EN_ENCOUNTER", TRUE);

        if (nEffect) ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                                           EffectVisualEffect(nEffect),
                                           GetLocation(oCreature));
    }
}
//----------------------------------------------------------------
struct gsENLimit gsENGetDefaultLimit(object oArea = OBJECT_SELF)
{
    struct gsENLimit stLimit;
    object oObject        = OBJECT_INVALID;
    object oMaster        = OBJECT_INVALID;
    object oEquipment     = OBJECT_INVALID;
    float fChallenge      = 0.0;
    float fRating         = 0.0;
    float fRatingMaximum  = 0.0;
    int nEquipmentValue   = 0;
    int nCount            = 0;

    stLimit.fRating       = 0.0;
    stLimit.nCount        = 0;

    //step 1: compute area highest rating
    oObject               = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE &&
            ! (GetIsDM(oObject) || GetIsDMPossessed(oObject)))
        {
            if (GetIsPC(oObject))
            {
                fRating          = IntToFloat(GetHitDice(oObject));
                fRating         += fRating * 0.25;
                nEquipmentValue  = 0;

                oEquipment       = GetItemInSlot(INVENTORY_SLOT_ARMS, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_BELT, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_BOOTS, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_CHEST, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_CLOAK, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_HEAD, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_NECK, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oObject);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);

                fRating         += IntToFloat(nEquipmentValue) / 10000.0;
            }
            else
            {
                oMaster = GetMaster(oObject);

                if (GetIsObjectValid(oMaster) &&
                    GetIsPC(oMaster))
                {
                    fRating = GetChallengeRating(oObject);
                }
                else
                {
                    fRating = 0.0;

                    if (gsENGetIsEncounterCreature(oObject))
                    {
                        nCount++;
                        fChallenge += GetChallengeRating(oObject);
                    }
                }
            }

            if (fRating > fRatingMaximum) fRatingMaximum = fRating;
            SetLocalFloat(oObject, "GS_EN_RATING", fRating);
        }

        oObject = GetNextObjectInArea(oArea);
    }

    if (fRatingMaximum == 0.0) return stLimit;
    fRatingMaximum       *= 1.25;

    //step 2: compute area modified average rating
    oObject               = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE &&
            ! (GetIsDM(oObject) || GetIsDMPossessed(oObject)))
        {
            fRating          = GetLocalFloat(oObject, "GS_EN_RATING");
            stLimit.fRating += fRating * fRating / fRatingMaximum;
        }

        oObject = GetNextObjectInArea(oArea);
    }

    if (stLimit.fRating == 0.0)                 return stLimit;
    if (fChallenge > stLimit.fRating * 2.0)     return stLimit;

    //encounter limit
    stLimit.nCount        = FloatToInt(gsARGetSizeX(oArea) + gsARGetSizeY(oArea)) *
                            gsENGetEncounterChance(oArea) / 1000 -
                            nCount;

    if (stLimit.nCount > GS_EN_LIMIT_ENCOUNTER) stLimit.nCount = GS_EN_LIMIT_ENCOUNTER;
    else if (stLimit.nCount < 0)                stLimit.nCount = 0;

    return stLimit;
}
//----------------------------------------------------------------
location gsENGetRandomLocation(object oArea = OBJECT_SELF)
{
    object oObject   = OBJECT_INVALID;
    location lLocation1;
    location lLocation2;
    float fDistance1 = 0.0;
    float fDistance2 = 0.0;
    int nSizeX       = FloatToInt(gsARGetSizeX(oArea)) - 10;
    int nSizeY       = FloatToInt(gsARGetSizeY(oArea)) - 10;
    int nNth         = 0;

    //try to find location out of player sight
    for (; nNth < 5; nNth++)
    {
        lLocation1 = Location(oArea,
                              Vector(IntToFloat(Random(nSizeX) + 5),
                                     IntToFloat(Random(nSizeY) + 5)),
                              0.0);
        oObject    = GetNearestCreatureToLocation(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,
                                                  lLocation1, 1);

        if (GetIsObjectValid(oObject))
        {
            fDistance1 = GetDistanceBetweenLocations(lLocation1, GetLocation(oObject));

            if (fDistance1 > fDistance2)
            {
                lLocation2 = lLocation1;
                fDistance2 = fDistance1;
            }

            if (fDistance1 >= 25.0) break;
        }
        else
        {
            lLocation2 = lLocation1;
            break;
        }
    }

    return lLocation2;
}
//----------------------------------------------------------------
void gsENSetEncounterChance(int nChance, object oArea = OBJECT_SELF)
{
    SetLocalInt(oArea, "GS_EN_CHANCE", nChance);
}
//----------------------------------------------------------------
int gsENGetEncounterChance(object oArea = OBJECT_SELF)
{
    return GetLocalInt(oArea, "GS_EN_CHANCE");
}
//----------------------------------------------------------------
void gsENSetCreature(object oCreature, int nChance = 5, object oArea = OBJECT_SELF)
{
    if (! GetIsObjectValid(oCreature))                    return;
    if (GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return;
    if (GetIsPC(oCreature))                               return;
    if (nChance < 0 || nChance > 10)                      return;
    if (! GetIsObjectValid(oArea))                        return;

    string sTemplate = GetResRef(oCreature);
    if (sTemplate == "")                                  return;
    string sResRef   = "";
    int nSlot        = FALSE;
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_EN_LIMIT_SLOT; nNth++)
    {
        sResRef = gsENGetCreatureTemplate(nNth, oArea);

        if (sResRef == sTemplate)
        {
            nSlot = nNth;
            break;
        }
        else if (! nSlot &&
                 sResRef == "")
        {
            nSlot = nNth;
        }
    }

    if (nNth)
    {
        string sNth = IntToString(nSlot);

        SetLocalString(oArea, "GS_EN_NAME_" + sNth, GetName(oCreature));
        SetLocalString(oArea, "GS_EN_RESREF_" + sNth, sTemplate);
        SetLocalFloat(oArea, "GS_EN_RATING_" + sNth, GetChallengeRating(oCreature));
        SetLocalInt(oArea, "GS_EN_CHANCE_" + sNth, nChance);
    }
}
//----------------------------------------------------------------
void gsENSetCreatureChance(int nSlot, int nChance, object oArea = OBJECT_SELF)
{
    SetLocalInt(oArea, "GS_EN_CHANCE_" + IntToString(nSlot), nChance);
}
//----------------------------------------------------------------
string gsENGetCreatureName(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalString(oArea, "GS_EN_NAME_" + IntToString(nSlot));
}
//----------------------------------------------------------------
string gsENGetCreatureTemplate(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalString(oArea, "GS_EN_RESREF_" + IntToString(nSlot));
}
//----------------------------------------------------------------
float gsENGetCreatureRating(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalFloat(oArea, "GS_EN_RATING_" + IntToString(nSlot));
}
//----------------------------------------------------------------
int gsENGetCreatureChance(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalInt(oArea, "GS_EN_CHANCE_" + IntToString(nSlot));
}
//----------------------------------------------------------------
void gsENRemoveCreature(int nSlot, object oArea = OBJECT_SELF)
{
    string sNth = IntToString(nSlot);

    DeleteLocalString(oArea, "GS_EN_NAME_" + sNth);
    DeleteLocalString(oArea, "GS_EN_RESREF_" + sNth);
    DeleteLocalFloat(oArea, "GS_EN_RATING_" + sNth);
    DeleteLocalInt(oArea, "GS_EN_CHANCE_" + sNth);
}
//----------------------------------------------------------------
int gsENGetIsEncounterCreature(object oCreature = OBJECT_SELF)
{
    return GetIsEncounterCreature(oCreature) ||
           GetLocalInt(oCreature, "GS_EN_ENCOUNTER");
}
//----------------------------------------------------------------
void gsENSaveArea(object oArea = OBJECT_SELF)
{
    string sDatabase = "GS_EN_" + GetTag(oArea);
    string sNth      = "";
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_EN_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);

        SetCampaignString(sDatabase,
                          "NAME_" + sNth,
                          gsENGetCreatureName(nNth, oArea));
        SetCampaignString(sDatabase,
                          "RESREF_" + sNth,
                          gsENGetCreatureTemplate(nNth, oArea));
        SetCampaignFloat(sDatabase,
                         "RATING_" + sNth,
                         gsENGetCreatureRating(nNth, oArea));
        SetCampaignInt(sDatabase,
                       "CHANCE_" + sNth,
                       gsENGetCreatureChance(nNth, oArea));
    }

    SetCampaignInt(sDatabase, "CHANCE", gsENGetEncounterChance(oArea));
}
//----------------------------------------------------------------
void gsENLoadArea(object oArea = OBJECT_SELF)
{
    string sDatabase = "GS_EN_" + GetTag(oArea);
    string sNth      = "";
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_EN_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);

        SetLocalString(oArea,
                       "GS_EN_NAME_" + sNth,
                       GetCampaignString(sDatabase, "NAME_" + sNth));
        SetLocalString(oArea,
                       "GS_EN_RESREF_" + sNth,
                       GetCampaignString(sDatabase, "RESREF_" + sNth));
        SetLocalFloat(oArea,
                      "GS_EN_RATING_" + sNth,
                      GetCampaignFloat(sDatabase, "RATING_" + sNth));
        SetLocalInt(oArea,
                    "GS_EN_CHANCE_" + sNth,
                    GetCampaignInt(sDatabase, "CHANCE_" + sNth));
    }

    SetLocalInt(oArea, "GS_EN_CHANCE", GetCampaignInt(sDatabase, "CHANCE"));
}
