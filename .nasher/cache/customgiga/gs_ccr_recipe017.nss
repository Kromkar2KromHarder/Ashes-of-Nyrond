#include "gs_inc_craft"

int StartingConditional()
{
    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE && GetHasInventory(OBJECT_SELF)) return FALSE;

    object oSpeaker = GetPCSpeaker();

    DeleteLocalInt(OBJECT_SELF, "GS_PAGE_START_1");

    SetCustomToken(100, IntToString(GetLocalInt(GetModule(), "GS_CR_RECIPE_COUNT")));
    SetCustomToken(101, gsCRGetSkillName(GS_CR_SKILL_FORGE));
    SetCustomToken(102, gsCRGetSkillName(GS_CR_SKILL_CARPENTER));
    SetCustomToken(103, gsCRGetSkillName(GS_CR_SKILL_SEW));
    SetCustomToken(104, gsCRGetSkillName(GS_CR_SKILL_MELD));
    SetCustomToken(105, gsCRGetSkillName(GS_CR_SKILL_CRAFT_ART));
    SetCustomToken(106, gsCRGetSkillName(GS_CR_SKILL_COOK));
    SetCustomToken(107, IntToString(gsCRGetSkillRank(GS_CR_SKILL_FORGE,     oSpeaker)));
    SetCustomToken(108, IntToString(gsCRGetSkillRank(GS_CR_SKILL_CARPENTER, oSpeaker)));
    SetCustomToken(109, IntToString(gsCRGetSkillRank(GS_CR_SKILL_SEW,       oSpeaker)));
    SetCustomToken(110, IntToString(gsCRGetSkillRank(GS_CR_SKILL_MELD,      oSpeaker)));
    SetCustomToken(111, IntToString(gsCRGetSkillRank(GS_CR_SKILL_CRAFT_ART, oSpeaker)));
    SetCustomToken(112, IntToString(gsCRGetSkillRank(GS_CR_SKILL_COOK,      oSpeaker)));

    return TRUE;
}
