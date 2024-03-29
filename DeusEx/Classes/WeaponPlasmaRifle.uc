//=============================================================================
// WeaponPlasmaRifle.
//=============================================================================
class WeaponPlasmaRifle extends DeusExWeapon;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		HitDamage = mpHitDamage;
		BaseAccuracy = mpBaseAccuracy;
		ReloadTime = mpReloadTime;
		AccurateRange = mpAccurateRange;
		MaxRange = mpMaxRange;
		ReloadCount = mpReloadCount;
	}
	// I don't know why I have to do this
	Description = "An experimental weapon that is currently being produced"
	@ " as a series of one-off prototypes, the plasma gun superheats slugs"
	@ " of magnetically-doped plastic and accelerates the resulting gas-liquid"
	@ " mix using an array of linear magnets. The resulting plasma stream is "
	@ "deadly when used against slow-moving targets. Also launches "
	@ "super-capacitive bolts when loaded with standard electric prod batteries.";

}

simulated function SetAltProjectileParams(int ammoNum){
	ProjectileClass = ProjectileNames[ammoNum];
	ProjectileSpeed = ProjectileClass.Default.Speed * GetDamageMult();
	bProjectileGravity = !(class<DeusExProjectile>(ProjectileClass).Default.bIgnoresGravity);
	if (ammoNum == 0)
	{
		ammoConsumption = Default.ammoConsumption;
		ReloadCount = Default.ReloadCount;
		LowAmmoWaterMark = Default.LowAmmoWaterMark;
	} 
	else if (ammoNum == 1)
	{
		ammoConsumption = 100;
		ReloadCount = 100;
		LowAmmoWaterMark = 100;
	}
}



defaultproperties
{
     LowAmmoWaterMark=12
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     EnviroEffective=ENVEFF_AirVacuum
     reloadTime=2.000000
     HitDamage=35
     maxRange=24000
     AccurateRange=14400
     BaseAccuracy=2.000000
     bCanHaveScope=True
     ScopeFOV=20
     bCanHaveLaser=True
     AreaOfEffect=AOE_Cone
     bPenetrating=False
     recoilStrength=10.000
     mpReloadTime=0.500000
     mpHitDamage=20
     mpBaseAccuracy=0.500000
     mpAccurateRange=8000
     mpMaxRange=8000
     mpReloadCount=12
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.AmmoPlasma'
     AmmoNames(0)=Class'DeusEx.AmmoPlasma'
     AmmoNames(1)=Class'DeusEx.AmmoBattery'
     ReloadCount=16
     PickupAmmoCount=32
     ProjectileClass=Class'DeusEx.PlasmaBolt'
     ProjectileNames(0)=Class'DeusEx.PlasmaBolt'
     ProjectileNames(1)=Class'DeusEx.ElectroBolt'
     shakemag=50.000000
     FireSound=Sound'DeusExSounds.Weapons.PlasmaRifleFire'
     AltFireSound=Sound'DeusExSounds.Weapons.PlasmaRifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.PlasmaRifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.PlasmaRifleSelect'
     InventoryGroup=8
     ItemName="Plasma Rifle"
     PlayerViewOffset=(X=18.000000,Z=-7.000000)
     PlayerViewMesh=LodMesh'DeusExItems.PlasmaRifle'
     PickupViewMesh=LodMesh'DeusExItems.PlasmaRiflePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.PlasmaRifle3rd'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconPlasmaRifle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconPlasmaRifle'
     largeIconWidth=203
     largeIconHeight=66
     invSlotsX=2
     invSlotsY=2
     Description="An experimental weapon that is currently being produced as a series of one-off prototypes, the plasma gun superheats slugs of magnetically-doped plastic and accelerates the resulting gas-liquid mix using an array of linear magnets. The resulting plasma stream is deadly when used against slow-moving targets."
     beltDescription="PLASMA"
     Mesh=LodMesh'DeusExItems.PlasmaRiflePickup'
     CollisionRadius=15.600000
     CollisionHeight=5.200000
     Mass=50.000000
	 ShotTime=0.2
	 fFireAnimFactor=5.0
	 handleAbility=2.0
	 aimAbility=2.0
	 ammoConsumption=1
}
