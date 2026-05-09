#include "gs_inc_craft"

int StartingConditional()
{
    SetCustomToken(100, gsCRGetSkillName(GS_CR_SKILL_FORGE));
    SetCustomToken(101, gsCRGetSkillName(GS_CR_SKILL_CARPENTER));
    SetCustomToken(102, gsCRGetSkillName(GS_CR_SKILL_SEW));
    SetCustomToken(103, gsCRGetSkillName(GS_CR_SKILL_MELD));
    SetCustomToken(104, gsCRGetSkillName(GS_CR_SKILL_CRAFT_ART));
    SetCustomToken(105, gsCRGetSkillName(GS_CR_SKILL_COOK));

    return TRUE;
}
