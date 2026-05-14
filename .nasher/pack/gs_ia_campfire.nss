void main()
{
object oPC = GetItemActivator();
location lLocation = GetLocation(oPC);
object oCampfire = GetNearestObjectByTag("GS_CAMPFIRE", oPC);

if (GetIsObjectValid(oCampfire) && GetDistanceBetween(oPC, oCampfire) <= 5.0)
{
FloatingTextStringOnCreature("You already have a campfire nearby.", oPC, FALSE);
}
else
{
CreateObject(OBJECT_TYPE_PLACEABLE, "GS_CAMPFIRE", lLocation);
}
}
