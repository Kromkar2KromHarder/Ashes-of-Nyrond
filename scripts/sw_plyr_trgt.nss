#include "sw_tools"

void CastDomainSpellAtLoc(object oPlayer, string sBindKey, int iSpellId, location lTarget, int iMetamagic, int iDomainLevel)
{
    object oDummy = CreateObject(OBJECT_TYPE_PLACEABLE, "sw_spell_target", lTarget);
    SetLocalObject(oPlayer, SW_TARGET_CLEANUP, oDummy);
    AssignCommand(oPlayer, ActionCastSpellAtObject(iSpellId, oDummy, iMetamagic, FALSE, iDomainLevel));
}

void main()
{
    object oPlayer = GetLastPlayerToSelectTarget();
    object oTarget = GetTargetingModeSelectedObject();

    int iSpellId = GetLocalInt(oPlayer, SW_CAST_SPELL_ID);
    int iMetamagic = GetLocalInt(oPlayer, SW_CAST_METAMAGIC);
    int iSpellTargetType = GetLocalInt(oPlayer, SW_CAST_TARGETTYPE);
    int iSpellLevel = GetLocalInt(oPlayer, SW_CAST_SPELL_LEVEL);
    int bDomainSpell = GetLocalInt(oPlayer, SW_CAST_IS_DOMAIN);
    int nToken = GetLocalInt(oPlayer, SW_CAST_WIN_TOKEN);
    string sBindKey = GetLocalString(oPlayer, SW_CAST_BIND_KEY);

    int iDomainLevel = 0;

    if (bDomainSpell)
    {
        iDomainLevel =GetLevelBeforeMetaMagic(iSpellLevel, iMetamagic);
    }

    int iTargetType = GetObjectType(oTarget);

    if (iTargetType == OBJECT_TYPE_TILE)
    {
        location lTarget = Location(oTarget, GetTargetingModeSelectedPosition(), 0.0f);
        if (bDomainSpell)
        {
            CastDomainSpellAtLoc(oPlayer, sBindKey, iSpellId, lTarget, iMetamagic, iDomainLevel);
        }
        else
        {
            AssignCommand(oPlayer, ActionCastSpellAtLocation(iSpellId, lTarget, iMetamagic, FALSE));
        }
    }
    else if( oTarget != OBJECT_INVALID)
    {
        if (iTargetType == 0)
        {
            location lTarget = Location(oTarget, GetTargetingModeSelectedPosition(), 0.0f);
            if (bDomainSpell)
            {
                CastDomainSpellAtLoc(oPlayer, sBindKey, iSpellId, lTarget, iMetamagic, iDomainLevel);
            }
            else
            {
                AssignCommand(oPlayer, ActionCastSpellAtLocation(iSpellId, lTarget, iMetamagic, FALSE));
            }
        }
        else
        {
            AssignCommand(oPlayer, ActionCastSpellAtObject(iSpellId, oTarget, iMetamagic, FALSE, iDomainLevel));
        }
    }
    DeleteLocalInt(oPlayer, SW_CAST_SPELL_ID);
    DeleteLocalInt(oPlayer, SW_CAST_METAMAGIC);
    DeleteLocalInt(oPlayer, SW_CAST_TARGETTYPE);
    DeleteLocalInt(oPlayer, SW_CAST_SPELL_LEVEL);
    DeleteLocalInt(oPlayer, SW_CAST_IS_DOMAIN);

    RunOverride(SW_OVERRIDDEN_PLYR_TRGT_SCRIPT);
}
