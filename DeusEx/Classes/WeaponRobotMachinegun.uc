//=============================================================================
// WeaponRobotMachinegun.
//=============================================================================
class WeaponRobotMachinegun extends WeaponNPCRanged;

defaultproperties
{
     ShotTime=0.030000
     reloadTime=1.000000
     HitDamage=4
     BaseAccuracy=0.050000
     bHasMuzzleFlash=True
     AmmoName=Class'DeusEx.Ammo762mm'
     PickupAmmoCount=50
     bInstantHit=True
     FireSound=Sound'DeusExSounds.Weapons.HideAGunFire'
     CockingSound=Sound'DeusExSounds.Weapons.AssaultGunReload'
     SelectSound=Sound'DeusExSounds.Weapons.AssaultGunSelect'
	   bAutomatic=False
	   fFireAnimFactor=20.0
}
