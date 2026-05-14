/* EFFECT Library by Gigaschatten */

//void main() {}

//apply blood effect on caller
void gsFXBleed();
//remove effects of nType and nSubType applied by oCreator from oObject
void gsFXRemoveEffect(object oObject, object oCreator = OBJECT_INVALID, int nType = FALSE, int nSubType = FALSE);

void gsFXBleed()
{
    int nDamage     = GetTotalDamageDealt();
    if (nDamage == 0) return;

    int nHitPoints  = GetCurrentHitPoints();
    int nColor      = 0;
    int nEffect     = EFFECT_TYPE_INVALIDEFFECT;

    switch (GetRacialType(OBJECT_SELF))
    {
    //bone
    case RACIAL_TYPE_UNDEAD:
        nColor = 0;
        break;

    //green
    case RACIAL_TYPE_DRAGON:
    case RACIAL_TYPE_HUMANOID_GOBLINOID:
    case RACIAL_TYPE_HUMANOID_ORC:
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
    case RACIAL_TYPE_OOZE:
    case RACIAL_TYPE_VERMIN:
        nColor = 1;
        break;

    //red
    default:
    case RACIAL_TYPE_ABERRATION:
    case RACIAL_TYPE_ANIMAL:
    case RACIAL_TYPE_BEAST:
    case RACIAL_TYPE_DWARF:
    case RACIAL_TYPE_ELF:
    case RACIAL_TYPE_FEY:
    case RACIAL_TYPE_GIANT:
    case RACIAL_TYPE_GNOME:
    case RACIAL_TYPE_HALFELF:
    case RACIAL_TYPE_HALFLING:
    case RACIAL_TYPE_HALFORC:
    case RACIAL_TYPE_HUMAN:
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
    case RACIAL_TYPE_MAGICAL_BEAST:
    case RACIAL_TYPE_OUTSIDER:
    case RACIAL_TYPE_SHAPECHANGER:
        nColor = 2;
        break;

    //white
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_ELEMENTAL:
        nColor = 3;
        break;

    //yellow
        nColor = 4;
        break;
    }

    if (nDamage <= 10)
    {
        switch (nColor)
        {
        case 0: if (nHitPoints <= 0) nEffect = VFX_COM_CHUNK_BONE_MEDIUM;                            break;
        case 1: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_REG_GREEN  : VFX_COM_CHUNK_GREEN_SMALL;   break;
        case 2: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_REG_RED    : VFX_COM_CHUNK_RED_SMALL;     break;
        case 3: nEffect =                    VFX_COM_BLOOD_REG_WIMP;                                 break;
        case 4: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_REG_YELLOW : VFX_COM_CHUNK_YELLOW_SMALL;  break;
        }
    }
    else if (nDamage <= 20)
    {
        switch (nColor)
        {
        case 0: if (nHitPoints <= 0) nEffect = VFX_COM_CHUNK_BONE_MEDIUM;                            break;
        case 1: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_LRG_GREEN  : VFX_COM_CHUNK_GREEN_MEDIUM;  break;
        case 2: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_LRG_RED    : VFX_COM_CHUNK_RED_MEDIUM;    break;
        case 3: nEffect =                    VFX_COM_BLOOD_LRG_WIMP;                                 break;
        case 4: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_LRG_YELLOW : VFX_COM_CHUNK_YELLOW_MEDIUM; break;
        }
    }
    else
    {
        switch (nColor)
        {
        case 0: if (nHitPoints <= 0) nEffect = VFX_COM_CHUNK_BONE_MEDIUM;                            break;
        case 1: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_CRT_GREEN  : VFX_COM_CHUNK_GREEN_MEDIUM;  break;
        case 2: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_CRT_RED    : VFX_COM_CHUNK_RED_LARGE;     break;
        case 3: nEffect =                    VFX_COM_BLOOD_CRT_WIMP;                                 break;
        case 4: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_CRT_YELLOW : VFX_COM_CHUNK_YELLOW_MEDIUM; break;
        }
    }

    if (nEffect != EFFECT_TYPE_INVALIDEFFECT)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nEffect), OBJECT_SELF);
    }

    if (nHitPoints > 0)
    {
        switch (Random(3))
        {
        case 0: PlayVoiceChat(VOICE_CHAT_PAIN1); break;
        case 1: PlayVoiceChat(VOICE_CHAT_PAIN2); break;
        case 2: PlayVoiceChat(VOICE_CHAT_PAIN3); break;
        }
    }
    else
    {
        PlayVoiceChat(VOICE_CHAT_DEATH);
    }
}
//----------------------------------------------------------------
void gsFXRemoveEffect(object oObject, object oCreator = OBJECT_INVALID, int nType = FALSE, int nSubType = FALSE)
{
    effect eEffect = GetFirstEffect(oObject);

    while (GetIsEffectValid(eEffect))
    {
        if ((oCreator == OBJECT_INVALID ||
             GetEffectCreator(eEffect) == oCreator) &&
            (nType == FALSE ||
             GetEffectType(eEffect) == nType) &&
            (nSubType == FALSE ||
             GetEffectSubType(eEffect) == nSubType))
        {
            RemoveEffect(oObject, eEffect);
        }

        eEffect = GetNextEffect(oObject);
    }
}
