#include "sw_tools"
#include "x2_inc_switches"
#include "utl_i_spells"

int GetSpellLevel(int iClassId, int iSpellId)
{
    int iLevel = GetSpellSaveDC() - 10;
    string sAbility = Get2DAString("classes", "SpellcastingAbil", iClassId);
    int iAbility = FindSubString("SD_IWC", GetSubString(sAbility, 0, 1));
    if (sAbility == "CON")
    {
        iAbility = ABILITY_CONSTITUTION;
    }
    
    iLevel -= GetAbilityModifier(iAbility);

    int iSchool = SpellSchoolIDFromString(Get2DAString("spells", "School", iSpellId));

    switch (iSchool)
    {
        case SPELL_SCHOOL_ABJURATION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION))
            {
                iLevel -= 2;
            }
            break;
        case SPELL_SCHOOL_CONJURATION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION))
            {
                iLevel -= 2;
            }
            break;
        case SPELL_SCHOOL_DIVINATION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION))
            {
                iLevel -= 2;
            }
            break;
        case SPELL_SCHOOL_ENCHANTMENT:
            if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT))
            {
                iLevel -= 2;
            }
            break;
        case SPELL_SCHOOL_EVOCATION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION))
            {
                iLevel -= 2;
            }
            break;
        case SPELL_SCHOOL_ILLUSION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION))
            {
                iLevel -= 2;
            }
            break;
        case SPELL_SCHOOL_NECROMANCY:
            if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY))
            {
                iLevel -= 2;
            }
            break;
        case SPELL_SCHOOL_TRANSMUTATION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION))
            {
                iLevel -= 2;
            }
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION))
            {
                iLevel -= 2;
            }
            break;
    }

    return iLevel;
}

void main()
{
    RunOverride(SW_OVERRIDDEN_SPELL_HOOK);

    object oDummy = GetLocalObject(OBJECT_SELF, SW_TARGET_CLEANUP);
    if (oDummy != OBJECT_INVALID)
    {
        DeleteLocalObject(OBJECT_SELF, SW_TARGET_CLEANUP);
        DestroyObject(oDummy);
    }

    if (GetModuleOverrideSpellScriptFinished())
    {
        SetModuleOverrideSpellScriptFinished();
        return;
    }

    object oPlayer = OBJECT_SELF;
    int nToken = GetLocalInt(oPlayer, SW_CAST_WIN_TOKEN);

    if (nToken > 0)
    {
        int iSpellId = GetSpellId();
        int iClassId = GetLastSpellCastClass();
        int iMetamagic = GetMetaMagicFeat();
        
        string sBindKey = GetLocalString(oPlayer, SW_CAST_BIND_KEY);
        int bMemorizesSpells = StringToInt(Get2DAString("classes", "MemorizesSpells", iClassId));

        int iBaseSpellLevel = GetSpellLevel(iClassId, iSpellId);
        
        int iSpellLevel = GetLevelAfterMetaMagic(iBaseSpellLevel, iMetamagic);

        string sDataKey = "Cast_" + IntToString(iClassId) + "_" +IntToString(iSpellId) + 
                "_" + IntToString(iMetamagic) + "_" + IntToString(iSpellLevel);

        json jUserData = NuiGetUserData(oPlayer, nToken);
        json jSpellData = JsonObjectGet(jUserData, sDataKey);
        struct SpellData data;

        string sTooltipKey = "";
        string sUpdatedTooltip = "";
        int bIconEnabled = TRUE;



        if (JsonGetType(jSpellData) != JSON_TYPE_NULL)
        {
            data = JsonToSpellData(jSpellData);
            sTooltipKey =  IntToString(iClassId) + "_Cast_." + IntToString(data.iSpellId) + "."
                + IntToString(data.iMetamagic) + "." + IntToString(data.iSpellLevel) + ".tooltip";
            if( bMemorizesSpells)
            {
                data.iTimesMemorized--;
                if ( sBindKey == "")
                {
                    sBindKey =  IntToString(iClassId) + "_Cast_." + IntToString(data.iSpellId) + "."
                    + IntToString(data.iMetamagic) + "." + IntToString(data.iSpellLevel) + ".enabled";
                }
                sUpdatedTooltip = data.sLabel + " (" + IntToString(data.iTimesMemorized ) + ")";
                bIconEnabled = data.iTimesMemorized > 0;
            }
            else 
            {
                sUpdatedTooltip = data.sLabel;
                sBindKey = IntToString(iClassId) + "_Cast_." + IntToString(iSpellLevel);
            }
            jSpellData = SpellDataToJson(data);
            jUserData = JsonObjectSet(jUserData, sDataKey, jSpellData);
            NuiSetUserData(oPlayer, nToken, jUserData);
        }

        if (sBindKey != "")
        {
            if(bMemorizesSpells)
            {
                NuiSetBind(oPlayer, nToken, sBindKey, JsonBool(bIconEnabled));
                SetLocalInt(oPlayer, sBindKey, bIconEnabled);
                NuiSetBind(oPlayer, nToken, sTooltipKey, JsonString(sUpdatedTooltip));
            }
            else
            {
                int spellsLeft = GetLocalInt(oPlayer, "NumSpellsLeft" + IntToString(iSpellLevel)) - 1;
                if (spellsLeft < 1)
                {
                    NuiSetBind(oPlayer, nToken, sBindKey, JsonBool(FALSE));
                }
                sUpdatedTooltip = sUpdatedTooltip + " (" + IntToString(spellsLeft) + ")";
                SetLocalInt(oPlayer, "NumSpellsLeft" + IntToString(iSpellLevel), spellsLeft);
                json jSpellsByLevel = JsonObjectGet(jUserData, "SpellsByLevel_" + 
                    IntToString(iClassId) + "_"  + IntToString(iSpellLevel));

                int iSpellLvlIdx = 0;
                jSpellData = JsonArrayGet(jSpellsByLevel, iSpellLvlIdx++);
                while (JsonGetType(jSpellData) != JSON_TYPE_NULL)
                {
                    data = JsonToSpellData(jSpellData);
                    sTooltipKey =  IntToString(iClassId) + "_Cast_." + IntToString(data.iSpellId) + "."
                        + IntToString(data.iMetamagic) + "." + IntToString(data.iSpellLevel) + ".tooltip";
                    sUpdatedTooltip = data.sLabel + " (" + IntToString(spellsLeft) + ")";
                    NuiSetBind(oPlayer, nToken, sTooltipKey, JsonString(sUpdatedTooltip));
                    jSpellData = JsonArrayGet(jSpellsByLevel, iSpellLvlIdx++);
                }
            }

            DeleteLocalString(oPlayer, SW_CAST_BIND_KEY);
        }
        /*else
        {
            //No bind key set, spell not cast from widget

            string sBindStart = IntToString(iClassId) + "_Cast_." + IntToString(iSpellId) + "."
                + IntToString(iMetamagic) + ".";

            int iBindStartLength = GetStringLength(sBindStart);

            int iBindIdx = 0;
            int bFound = FALSE;

            string sBinding = NuiGetNthBind(oPlayer, nToken, FALSE, iBindIdx++);

            while (sBinding != "" && !bFound)
            {
                string sBindCheck = GetStringLeft(sBinding, iBindStartLength);
                if ( sBindStart == sBindCheck)
                {
                    int bEnabled = GetLocalInt(oPlayer, sBinding);
                    if (bEnabled)
                    {
                        NuiSetBind(oPlayer, nToken, sBinding, JsonBool(FALSE));
                        SetLocalInt(oPlayer, sBinding, FALSE);
                        bFound = TRUE;
                        break;
                    }
                }
                sBinding = NuiGetNthBind(oPlayer, nToken, FALSE, iBindIdx++);
            }
        }*/
    }
}
