#include "gs_inc_language"
#include "gs_inc_listener"
#include "gs_inc_text"
#include "gs_inc_worship"

void main()
{
    if (! GetListenPatternNumber())
    {
        object oSpeaker = GetLastSpeaker();

        if (oSpeaker == gsLIGetTarget())
        {
            string sString = GetMatchedSubstring(0);

            //activity
            SetLocalInt(oSpeaker, "GS_ACTIVE", TRUE);

            //language
            if (GetStringLeft(sString, 1) == "-")
            {
                string sKey   = GetSubString(sString, 1, 2);
                int nLanguage = gsLAGetLanguageByKey(sKey);

                if (nLanguage)
                {
                    string sName = gsLAGetLanguageName(nLanguage);

                    if (gsLAGetCanSpeakLanguage(nLanguage, oSpeaker))
                    {
                        sString             = GetSubString(sString, 4, 250);

                        gsLISetLastMessage(sString, oSpeaker);

                        string sTranslation = gsLATranslate(sString, nLanguage);
                        sString             = "<cVs·>[" + sName + "] " +
                                              "<cþôh>" + GetName(oSpeaker) + ": " +
                                              "<cþþþ>" + sString;

                        SendMessageToPC(oSpeaker, sString);

                        object oPC          = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,
                                                                 oSpeaker, 1);
                        int nLore           = gsCMGetBaseSkillRank(SKILL_LORE, IP_CONST_ABILITY_INT, oSpeaker);
                        int nNth            = 1;

                        while (GetIsObjectValid(oPC) &&
                               GetDistanceBetween(oSpeaker, oPC) <= 20.0)
                        {
                            if (gsLAGetCanSpeakLanguage(nLanguage, oPC) ||
                                nLore + d20() > 30)
                            {
                                SendMessageToPC(oPC, sString);
                            }

                            oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,
                                                     oSpeaker, ++nNth);
                        }

                        AssignCommand(oSpeaker, SpeakString(sTranslation));
                    }
                    else
                    {
                        SendMessageToPC(oSpeaker, gsCMReplaceString(GS_T_16777342, sName));
                    }
                }
                else
                {
                    SendMessageToPC(
                        oSpeaker,
                        GS_T_16777343 + ":\n" +
                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ABYSSAL,   oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ABYSSAL)     + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ABYSSAL)   + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ANIMAL,    oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ANIMAL)      + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ANIMAL)    + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_CELESTIAL, oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_CELESTIAL)   + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_CELESTIAL) + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_DRACONIC,  oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_DRACONIC)    + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_DRACONIC)  + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_DWARVEN,   oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_DWARVEN)     + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_DWARVEN)   + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ELVEN,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ELVEN)       + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ELVEN)     + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_GNOME,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_GNOME)       + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_GNOME)     + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_GOBLIN,    oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_GOBLIN)      + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_GOBLIN)    + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_HALFLING,  oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_HALFLING)    + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_HALFLING)  + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_INFERNAL,  oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_INFERNAL)    + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_INFERNAL)  + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ORC,       oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ORC)         + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ORC)       + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_SIGN,      oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_SIGN)        + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_SIGN)      + "\n" +

                        (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_THIEF,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                        "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_THIEF)       + " <cþþþ>... " +
                        "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_THIEF));
                }

                return;
            }

            SendMessageToAllDMs("<cVs·>[" + GetName(GetArea(oSpeaker)) + "] " +
                                "<cþôh>" + GetName(oSpeaker) + ": " +
                                "<cÆ±˜>" + sString);
            gsLISetLastMessage(sString, oSpeaker);

            if (GetIsDead(oSpeaker)) return;

            //emote
            if (sString == GS_T_16777404)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 3600.0));
                gsWOGrantFavor(oSpeaker);
            }
            else if (sString == GS_T_16777405)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_VICTORY3));
                PlayVoiceChat(VOICE_CHAT_THREATEN, oSpeaker);
            }
            else if (sString == GS_T_16777406)
            {
                AssignCommand(
                    oSpeaker,
                    ActionForceFollowObject(
                        GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,
                                           oSpeaker, 1,
                                           CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND,
                                           CREATURE_TYPE_IS_ALIVE, TRUE),
                        5.0));
            }
            else if (sString == GS_T_16777407)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_TAUNT));
                PlayVoiceChat(VOICE_CHAT_TAUNT, oSpeaker);
            }
            else if (sString == GS_T_16777408)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 3600.0));
            }
            else if (sString == GS_T_16777409)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_VICTORY2));
                PlayVoiceChat(VOICE_CHAT_CHEER, oSpeaker);
            }
            else if (sString == GS_T_16777410)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 2.0));
                PlayVoiceChat(VOICE_CHAT_LAUGH, oSpeaker);
            }
            else if (sString == GS_T_16777411)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 3600.0));
            }
            else if (sString == GS_T_16777412)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_READ));
            }
            else if (sString == GS_T_16777413)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 3600.0));
            }
            else if (sString == GS_T_16777414)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_GREETING));
                PlayVoiceChat(VOICE_CHAT_GOODBYE, oSpeaker);
            }
            else if (sString == GS_T_16777415)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_BOW));
            }
            else if (sString == GS_T_16777416)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_GREETING));
                PlayVoiceChat(VOICE_CHAT_HELLO, oSpeaker);
            }
            else if (sString == GS_T_16777417)
            {
                AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_SPASM));
            }
        }
    }
}
