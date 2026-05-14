#include "gs_inc_common"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oStore   = GetNearestObjectByTag("GS_STORE_" + GetTag(OBJECT_SELF));

    if (GetIsObjectValid(oStore))
    {
        object oModule    = GetModule();
        string sString    = ObjectToString(OBJECT_SELF);
        int nModifierSell = GetLocalInt(oModule, "GS_STORE_MODIFIER_SELL") +
                            GetLocalInt(oStore, "GS_MODIFIER_SELL");
        int nModifierBuy  = GetLocalInt(oModule, "GS_STORE_MODIFIER_BUY") +
                            GetLocalInt(oStore, "GS_MODIFIER_BUY");
        int nIdentifyCost = GetStoreIdentifyCost(oStore);
        int nMaxBuyPrice  = GetStoreMaxBuyPrice(oStore);
        int nAppraise     = gsCMGetBaseSkillRank(SKILL_APPRAISE, IP_CONST_ABILITY_INT, oSpeaker);
        int nValue        = 0;

        if (nAppraise > GetLocalInt(oSpeaker, "GS_STORE_APPRAISE_" + sString))
        {
            nValue = (GetSkillRank(SKILL_APPRAISE) + d10()) - (nAppraise + d10());

            if (nValue > 10)       nValue =  10;
            else if (nValue < -10) nValue = -10;

            SetLocalInt(oSpeaker, "GS_STORE_APPRAISE_" + sString, nAppraise);
            SetLocalInt(oSpeaker, "GS_STORE_VALUE_" + sString, nValue);
        }
        else
        {
            nValue = GetLocalInt(oSpeaker, "GS_STORE_VALUE_" + sString);
        }

        if (nValue > 0)      SendMessageToPC(oSpeaker, "<cþë¦>" + GetStringByStrRef(8963));
        else if (nValue < 0) SendMessageToPC(oSpeaker, "<cþë¦>" + GetStringByStrRef(8965));
        else                 SendMessageToPC(oSpeaker, "<cþë¦>" + GetStringByStrRef(8964));

        if (nIdentifyCost >= 0)
        {
            nIdentifyCost = nIdentifyCost * (100 + nValue) / 100;
            if (nIdentifyCost < 0) nIdentifyCost = 0;
            SetStoreIdentifyCost(oStore, nIdentifyCost);
        }

        if (nMaxBuyPrice >= 0)
        {
            nMaxBuyPrice  = nMaxBuyPrice * (100 - nValue) / 100;
            if (nMaxBuyPrice < 0)  nMaxBuyPrice = 0;
            SetStoreMaxBuyPrice(oStore, nMaxBuyPrice);
        }

        nModifierSell += nValue;
        if (nModifierSell > 100)       nModifierSell =  100;
        else if (nModifierSell < -100) nModifierSell = -100;

        nModifierBuy  -= nValue;
        if (nModifierBuy > 100)        nModifierBuy  =  100;
        else if (nModifierBuy < -99)   nModifierBuy  = -99;

        OpenStore(oStore, GetPCSpeaker(), nModifierSell, nModifierBuy);
    }
}
