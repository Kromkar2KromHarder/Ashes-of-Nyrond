/* EXPERIENCE Library by Gigaschatten */

#include "gs_inc_common"
#include "gs_inc_pc"
#include "gs_inc_subrace"
#include "gs_inc_text"
#include "gs_inc_time"

//void main() {}

const float GS_XP_MODIFIER_EXPERIENCE         =    20.0;
const int GS_XP_ALIGNMENT_SHIFT               =     1;
const int GS_XP_PENALTY_PER_LEVEL             =   100; //death penalty
const int GS_XP_KILL_RESTRICTION_ENABLED      = TRUE;
const int GS_XP_KILL_PER_LEVEL                =   0; //daily kill reward
const int GS_XP_BONUS_HIGH                    =  1000;
const int GS_XP_BONUS_MEDIUM                  =   500;
const int GS_XP_BONUS_LOW                     =   250;
const int GS_XP_BONUS_MINI                    =    25;
const int GS_XP_PUNISHMENT_HIGH               = -1000;
const int GS_XP_PUNISHMENT_MEDIUM             =  -500;
const int GS_XP_PUNISHMENT_LOW                =  -250;

//distribute experience for slaying oVictim to each nearby member in group of oKiller
void gsXPRewardKill(object oKiller, object oVictim = OBJECT_SELF);
//set experience penalty for oCreature
void gsXPSetPenalty(object oCreature = OBJECT_SELF);
//take nPenalty * level experience points from oCreature, if nLevelSafe is TRUE it will not lose levels
void gsXPApplyPenalty(object oCreature, int nPenalty = GS_XP_PENALTY_PER_LEVEL, int nLevelSafe = FALSE);
//give nAmount experience to each member of oCreature's faction nearby
void gsXPDistributeExperience(object oCreature, int nAmount);
//give nAmount experience to oCreature, display floating message if nFloat is TRUE
void gsXPGiveExperience(object oCreature, int nAmount, int nFloat = TRUE, int nKill = FALSE);
//apply nBonus/punishment to oCreature or each member of party oCreature is in if nParty is TRUE
void gsXPApply(object oCreature, int nBonus, int nParty = FALSE);
//set kill limit of oPC to nValue
void gsXPSetKillLimit(object oPC, int nValue);
//return kill limit of oPC
int gsXPGetKillLimit(object oPC);
//set kill timeout of oPC to nValue
void gsXPSetKillTimeout(object oPC, int nValue);
//return kill timeout of oPC
int gsXPGetKillTimeout(object oPC);
//return percentual multi class penalty of oPC having nSubRace
int gsXPGetMultiClassPenalty(object oPC, int nSubRace = FALSE);

void gsXPRewardKill(object oKiller, object oVictim = OBJECT_SELF)
{
    if (GetObjectType(oKiller) != OBJECT_TYPE_CREATURE) return;

    object oMember          = OBJECT_INVALID;
    object oAreaKiller      = GetArea(oKiller);
    string sVictimName      = GetName(oVictim);
    int nVictimIsPC         = GetIsPC(oVictim);
    float fRatingVictim     = GetLevelByClass(CLASS_TYPE_COMMONER, oVictim) ?
                              0.0 :
                              (nVictimIsPC ?
                               IntToFloat(GetHitDice(oVictim)) :
                               GetChallengeRating(oVictim));
    float fRating           = 0.0;
    float fRatingMaximum    = 0.0;
    int nExperience         = 0;
    int nAlignmentVictimGE  = GetAlignmentGoodEvil(oVictim);
    int nAlignmentVictimLC  = GetAlignmentLawChaos(oVictim);
    int nAlignmentKillerGE  = 0;
    int nAlignmentKillerLC  = 0;
    int nAlignmentShiftGE   = 0;
    int nAlignmentShiftLC   = 0;

    //compute faction highest rating
    oMember                 = GetFirstFactionMember(oKiller, FALSE);

    while (GetIsObjectValid(oMember))
    {
        if (oMember == oVictim) return;

        if (GetArea(oMember) == oAreaKiller &&
            GetDistanceBetween(oMember, oKiller) <= 40.0)
        {
            fRating       = GetIsPC(oMember) ?
                            IntToFloat(GetHitDice(oMember)) :
                            GetChallengeRating(oMember);
            if (fRating > fRatingMaximum) fRatingMaximum = fRating;
        }

        oMember = GetNextFactionMember(oKiller, FALSE);
    }

    fRating                 = fRatingVictim / fRatingMaximum;
    fRatingVictim          *= 2.0;
    nExperience             = FloatToInt(fRating * GS_XP_MODIFIER_EXPERIENCE);

    //distribute experience
    oMember                 = GetFirstFactionMember(oKiller);

    while (GetIsObjectValid(oMember))
    {
        if (GetIsPC(oMember) &&
            GetArea(oMember) == oAreaKiller &&
            GetDistanceBetween(oMember, oKiller) <= 40.0)
        {
            //adjust alignment
            if (nVictimIsPC)
            {
                nAlignmentKillerGE = GetAlignmentGoodEvil(oMember);
                nAlignmentKillerLC = GetAlignmentLawChaos(oMember);
                nAlignmentShiftGE  = 0;
                nAlignmentShiftLC  = 0;

                switch (nAlignmentVictimGE)
                {
                case ALIGNMENT_GOOD:
                    nAlignmentShiftGE -= 10;
                    break;

                case ALIGNMENT_EVIL:
                    if (nAlignmentKillerGE != ALIGNMENT_EVIL)
                        nAlignmentShiftGE += 10;
                    break;
                }

                switch (nAlignmentVictimLC)
                {
                case ALIGNMENT_LAWFUL:
                    nAlignmentShiftLC -= 10;
                    break;

                case ALIGNMENT_CHAOTIC:
                    if (nAlignmentKillerGE != ALIGNMENT_CHAOTIC)
                        nAlignmentShiftLC += 10;
                    break;
                }

                if (nAlignmentShiftGE > 0)
                    AdjustAlignment(oMember, ALIGNMENT_GOOD, GS_XP_ALIGNMENT_SHIFT);
                else if (nAlignmentShiftGE < 0)
                    AdjustAlignment(oMember, ALIGNMENT_EVIL, GS_XP_ALIGNMENT_SHIFT);

                if (nAlignmentShiftLC > 0)
                    AdjustAlignment(oMember, ALIGNMENT_LAWFUL, GS_XP_ALIGNMENT_SHIFT);
                else if (nAlignmentShiftLC < 0)
                    AdjustAlignment(oMember, ALIGNMENT_CHAOTIC, GS_XP_ALIGNMENT_SHIFT);
            }

            if (IntToFloat(GetHitDice(oMember)) > fRatingVictim)
            {
                SendMessageToPC(oMember, GS_T_16777340);
            }
            else
            {
                gsXPGiveExperience(
                    oMember,
                    oMember == oKiller ? nExperience + 1 : nExperience,
                    TRUE,
                    TRUE);
            }
        }

        oMember = GetNextFactionMember(oKiller);
    }
}
//----------------------------------------------------------------
void gsXPApplyPenalty(object oCreature, int nPenalty = GS_XP_PENALTY_PER_LEVEL, int nLevelSafe = FALSE)
{
    int nHitDice = GetHitDice(oCreature);
    int nXP      = GetXP(oCreature);
    nPenalty     = nHitDice * nPenalty;

    //start safety
    int nLimit   = nXP - 3000; //level 3
    if (nPenalty > nLimit) nPenalty = nLimit;

    //level safety
    if (nLevelSafe)
    {
        nLimit = nXP - nHitDice * (nHitDice - 1) / 2 * 1000;
        if (nPenalty > nLimit) nPenalty = nLimit;
    }

    if (nPenalty > 0)      gsXPGiveExperience(oCreature, -nPenalty);
}
//----------------------------------------------------------------
void gsXPDistributeExperience(object oCreature, int nAmount)
{
    object oArea   = GetArea(oCreature);
    object oMember = GetFirstFactionMember(oCreature);

    while (GetIsObjectValid(oMember))
    {
        if (oArea == GetArea(oMember) &&
            GetDistanceBetween(oCreature, oMember) <= 40.0)
        {
            gsXPGiveExperience(oMember, nAmount);
        }

        oMember = GetNextFactionMember(oCreature);
    }
}
//----------------------------------------------------------------
void gsXPGiveExperience(object oCreature, int nAmount, int nFloat = TRUE, int nKill = FALSE)
{
    if (! nAmount) return;

    string sMessage  = "";
    int nXP          = GetXP(oCreature);

    if (nAmount > 0)
    {
        int nLevel    = GetHitDice(oCreature);
        int nXPLevel  = (nLevel + 1) * nLevel / 2 * 1000;

        if (nXP >= nXPLevel)
        {
            SendMessageToPC(oCreature, GS_T_16777341);
            return;
        }

        if (GS_XP_KILL_RESTRICTION_ENABLED && nKill && nLevel > 4)
        {
            int nTimestamp = gsTIGetActualTimestamp();
            int nTimeout   = gsXPGetKillTimeout(oCreature);
            int nLimit     = 0;

            if (nTimeout < nTimestamp)
            {
                nTimeout = nTimestamp + gsTIGetGameTimestamp(86400); //24 hours
                gsXPSetKillTimeout(oCreature, nTimeout);
            }
            else
            {
                nLimit   = gsXPGetKillLimit(oCreature);

                if (nLimit > nLevel * GS_XP_KILL_PER_LEVEL)
                {
                    SendMessageToPC(oCreature, GS_T_16777314);
                    return;
                }
            }

            gsXPSetKillLimit(oCreature, nLimit + nAmount);
        }

        int nSubRace  = gsSUGetSubRaceByName(GetSubRace(oCreature));
        //int nRolePlay = gsPCGetRolePlay(oCreature);
        nAmount       = nAmount * nLevel / gsSUGetECL(nSubRace, nLevel);
        nAmount       = nAmount * gsXPGetMultiClassPenalty(oCreature, nSubRace) / 100;
        //nAmount       = nAmount * nRolePlay / 50;
        sMessage      = "<cªÕþ>+";
    }
    else
    {
        sMessage      = "<cþ((>";
    }

    SetXP(oCreature, nXP + nAmount);

    sMessage        += IntToString(nAmount) + " " + GS_T_16777315;
    if (nFloat) FloatingTextStringOnCreature(sMessage, oCreature, FALSE);
    else        SendMessageToPC(oCreature, sMessage);
}
//----------------------------------------------------------------
void gsXPApply(object oCreature, int nBonus, int nParty = FALSE)
{
    if (! nBonus) return;

    string sColor   = "";
    string sType    = "";
    string sSubType = "";
    int nDM         = GetIsDM(OBJECT_SELF);

    if (nBonus < 0)
    {
        sColor = "<cþ((>";
        sType  = GS_T_16777316;

        if (nBonus < GS_XP_PUNISHMENT_MEDIUM)   sSubType = GS_T_16777321;
        else if (nBonus < GS_XP_PUNISHMENT_LOW) sSubType = GS_T_16777320;
        else                                    sSubType = GS_T_16777319;
    }
    else
    {
        sColor = "<cªÕþ>";
        sType  = GS_T_16777317;

        if (nBonus <= GS_XP_BONUS_MINI)         sSubType = GS_T_16777318;
        else if (nBonus <= GS_XP_BONUS_LOW)     sSubType = GS_T_16777319;
        else if (nBonus <= GS_XP_BONUS_MEDIUM)  sSubType = GS_T_16777320;
        else                                    sSubType = GS_T_16777321;
    }

    if (nParty)
    {
        object oMember = GetFirstFactionMember(oCreature);

        while (GetIsObjectValid(oMember))
        {
            SendMessageToPC(
                oMember,
                sColor + gsCMReplaceString(GS_T_16777322, sSubType + " " + sType));
            if (nDM)
                SendMessageToAllDMs(
                    gsCMReplaceString(
                        GS_T_16777323,
                        GetName(oMember),
                        sSubType + " " + sType,
                        GetName(OBJECT_SELF)));

            gsXPGiveExperience(oMember, nBonus);

            oMember = GetNextFactionMember(oCreature);
        }
    }
    else
    {
        SendMessageToPC(
            oCreature,
            sColor + gsCMReplaceString(GS_T_16777322, sSubType + " " + sType));
        if (nDM)
            SendMessageToAllDMs(
                gsCMReplaceString(
                    GS_T_16777323,
                    GetName(oCreature),
                    sSubType + " " + sType,
                    GetName(OBJECT_SELF)));

        gsXPGiveExperience(oCreature, nBonus);
    }
}
//----------------------------------------------------------------
void gsXPSetKillLimit(object oPC, int nValue)
{
    SetLocalInt(oPC, "GS_XP_KILL_LIMIT", nValue <= 0 ? -1 : nValue);
    SetCampaignInt("GS_XP_KILL_LIMIT", gsPCGetPlayerID(oPC), nValue);
}
//----------------------------------------------------------------
int gsXPGetKillLimit(object oPC)
{
    int nValue = GetLocalInt(oPC, "GS_XP_KILL_LIMIT");

    if (! nValue)
    {
        nValue = GetCampaignInt("GS_XP_KILL_LIMIT", gsPCGetPlayerID(oPC));
        SetLocalInt(oPC, "GS_XP_KILL_LIMIT", nValue <= 0 ? -1 : nValue);
        return nValue;
    }

    return nValue < 0 ? 0 : nValue;
}
//----------------------------------------------------------------
void gsXPSetKillTimeout(object oPC, int nValue)
{
    SetLocalInt(oPC, "GS_XP_KILL_TIMEOUT", nValue <= 0 ? -1 : nValue);
    SetCampaignInt("GS_XP_KILL_TIMEOUT", gsPCGetPlayerID(oPC), nValue);
}
//----------------------------------------------------------------
int gsXPGetKillTimeout(object oPC)
{
    int nValue = GetLocalInt(oPC, "GS_XP_KILL_TIMEOUT");

    if (! nValue)
    {
        nValue = GetCampaignInt("GS_XP_KILL_TIMEOUT", gsPCGetPlayerID(oPC));
        SetLocalInt(oPC, "GS_XP_KILL_TIMEOUT", nValue <= 0 ? -1 : nValue);
        return nValue;
    }

    return nValue < 0 ? 0 : nValue;
}
//----------------------------------------------------------------
int gsXPGetMultiClassPenalty(object oPC, int nSubRace = FALSE)
{
    int nClass2       = GetClassByPosition(2, oPC);
    if (nClass2 == CLASS_TYPE_INVALID) return 100; //no multi class character
    int nLevel2       = GetLevelByClass(nClass2, oPC);
    int nClass1       = GetClassByPosition(1, oPC);
    int nLevel1       = GetLevelByClass(nClass1, oPC);
    int nClass3       = GetClassByPosition(3, oPC);
    int nLevel3       = nClass3 == CLASS_TYPE_INVALID ? 0 : GetLevelByClass(nClass3, oPC);
    int nFavoredClass = CLASS_TYPE_INVALID;
    int nNth          = 0;

    //order classes by level
    if (nLevel3)
    {
        if (nLevel3 > nLevel1)
        {
            nNth    = nClass1;
            nClass1 = nClass3;
            nClass3 = nNth;
            nNth    = nLevel1;
            nLevel1 = nLevel3;
            nLevel3 = nNth;
        }

        if (nLevel3 > nLevel2)
        {
            nNth    = nClass2;
            nClass2 = nClass3;
            nClass3 = nNth;
            nNth    = nLevel2;
            nLevel2 = nLevel3;
            nLevel3 = nNth;
        }
    }

    if (nLevel2 > nLevel1)
    {
        nNth    = nClass1;
        nClass1 = nClass2;
        nClass2 = nNth;
        nNth    = nLevel1;
        nLevel1 = nLevel2;
        nLevel2 = nNth;
    }

    //favored class
    if (nSubRace)
    {
        nFavoredClass = gsSUGetFavoredClass(nSubRace, GetGender(oPC));
    }
    else
    {
        switch (GetRacialType(oPC))
        {
        case RACIAL_TYPE_DWARF:
            nFavoredClass = CLASS_TYPE_FIGHTER;
            break;

        case RACIAL_TYPE_ELF:
            nFavoredClass = CLASS_TYPE_WIZARD;
            break;

        case RACIAL_TYPE_GNOME:
            nFavoredClass = CLASS_TYPE_WIZARD;
            break;

        case RACIAL_TYPE_HALFELF:
            nFavoredClass = nClass1;
            break;

        case RACIAL_TYPE_HALFLING:
            nFavoredClass = CLASS_TYPE_ROGUE;
            break;

        case RACIAL_TYPE_HALFORC:
            nFavoredClass = CLASS_TYPE_BARBARIAN;
            break;

        case RACIAL_TYPE_HUMAN:
            nFavoredClass = nClass1;
            break;
        }
    }

    if (nLevel3)
    {
        if (nClass1 == nFavoredClass)
        {
            if (nLevel2 - nLevel3 > 1) return 80;
            return 100;
        }

        if (nClass2 == nFavoredClass)
        {
            if (nLevel1 - nLevel3 > 1) return 80;
            return 100;
        }

        if (nClass3 == nFavoredClass)
        {
            if (nLevel1 - nLevel2 > 1) return 80;
            return 100;
        }

        if (nClass1 - nClass2 > 1)
        {
            if (nClass2 - nClass3 > 1) return 60;
            if (nClass1 - nClass3 > 1) return 60;
            return 80;
        }
    }

    if (nClass1 == nFavoredClass) return 100;
    if (nClass2 == nFavoredClass) return 100;
    if (nClass1 - nClass2 > 1)    return  80;
    return 100;
}
