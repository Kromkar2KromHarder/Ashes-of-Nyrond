const int GS_DAMAGE = 25;

void main()
{
    object oDamager  = GetLastDamager();
    if (! GetIsPC(oDamager))              return;
    if (GetIsPossessedFamiliar(oDamager)) return;
    string sTemplate = GetLocalString(OBJECT_SELF, "GS_TEMPLATE");
    if (sTemplate == "")                  return;
    int nChance      = GetLocalInt(OBJECT_SELF, "GS_CHANCE");
    if (nChance < 1)                      return;
    int nDamage      = GetLocalInt(OBJECT_SELF, "GS_DAMAGE") +
                       GetTotalDamageDealt();

    while (nDamage >= GS_DAMAGE)
    {
        object oItem = OBJECT_INVALID;

        if (nChance + Random(100) >= 100)
        {
            oItem = CreateItemOnObject(sTemplate, oDamager);
            SetIdentified(oItem, TRUE);
            SetStolenFlag(oItem, FALSE);
        }

        nDamage -= GS_DAMAGE;
    }

    SetLocalInt(OBJECT_SELF, "GS_DAMAGE", nDamage);
}
