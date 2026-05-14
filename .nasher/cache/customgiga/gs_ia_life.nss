#include "gs_inc_common"
#include "gs_inc_respawn"
#include "gs_inc_xp"

void main()
{
    object oUsedBy     = GetLastUsedBy();
    location lLocation = gsREGetRespawnLocation(oUsedBy);

    //penalty
    gsXPApplyPenalty(oUsedBy);

    //teleport
    switch (GetAlignmentGoodEvil(oUsedBy))
    {
    case ALIGNMENT_GOOD:
    case ALIGNMENT_NEUTRAL:
        gsCMTeleportToLocation(oUsedBy, lLocation, VFX_IMP_HEALING_X);
        break;

    case ALIGNMENT_EVIL:
        gsCMTeleportToLocation(oUsedBy, lLocation, VFX_IMP_HARM);
        break;
    }

    //destroy corpse
    object oCorpse = GetLocalObject(oUsedBy, "GS_CORPSE");

    if (GetIsObjectValid(oCorpse)) DestroyObject(oCorpse);
    DeleteLocalObject(oUsedBy, "GS_CORPSE");
}
