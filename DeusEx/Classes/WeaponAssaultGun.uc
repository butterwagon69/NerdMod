//=============================================================================
// WeaponAssaultGun.
//=============================================================================
class WeaponAssaultGun extends DeusExWeapon;

var float	mpRecoilStrength;
var int ammoLoadedIndex;


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

		// Tuned for advanced -> master skill system (Monte & Ricardo's number) client-side
		recoilStrength = 0.75;
	}
    else
    {
        SetReloadCount();
    }
}

simulated function SetReloadCount()
{
    // Sets the correct reload count 
    local int numReloadMods;
	local float reloadDiff;
    switch( ammoLoadedIndex )
    {
		case 0:
			numReloadMods = int(ModReloadCount / Class'WeaponModClip'.default.WeaponModifier);
			// Replicating code from WeaponModClip because I am a big dummy

			reloadDiff = Default.ReloadCount * Class'WeaponModClip'.default.WeaponModifier;
			if (reloadDiff < 1)
				reloadDiff = 1;
			ReloadCount = Default.ReloadCount + int(reloadDiff * numReloadMods);
			LowAmmoWaterMark = Default.LowAmmoWaterMark;
			scopeFOV = Default.scopeFOV;
            break;
        case 1:
			ReloadCount = 1;
			LowAmmoWaterMark = 4;
			ammoConsumption = 1;
			scopeFOV = 70;
            break;
    }
}

function bool LoadAmmo(int ammoNum){
    local bool result;
	result = super.LoadAmmo(ammoNum);
	if (result)
	{
		if (ammoNum == 0)
		{
			ammoLoadedIndex = 0;
		}
		else if (ammoNum == 1)
		{
			ammoLoadedIndex = 1;
		}
    }
    SetReloadCount();
	return result;
}

defaultproperties
{
     LowAmmoWaterMark=30
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     bAutomatic=True
     ShotTime=0.100000
     reloadTime=3.000000
     HitDamage=4
     BaseAccuracy=0.100000
     bCanHaveScope=True
     ScopeFOV=45
     bCanHaveLaser=True
     bCanHaveSilencer=True
     AmmoNames(0)=Class'DeusEx.Ammo762mm'
     AmmoNames(1)=Class'DeusEx.Ammo20mm'
     ProjectileNames(1)=Class'DeusEx.HECannister20mm'
     recoilStrength=3.000000
     fFireAnimFactor=5.000000
     handleAbility=1.500000
     aimAbility=1.500000
     bCanShootFaster=False
     MinWeaponAcc=0.200000
     mpReloadTime=0.500000
     mpHitDamage=9
     mpBaseAccuracy=1.000000
     mpAccurateRange=2400
     mpMaxRange=2400
     mpReloadCount=30
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.Ammo762mm'
     ReloadCount=30
     PickupAmmoCount=30
     bInstantHit=True
     FireOffset=(X=-16.000000,Y=5.000000,Z=11.500000)
     shakemag=200.000000
     FireSound=Sound'DeusExSounds.Weapons.AssaultGunFire'
     AltFireSound=Sound'DeusExSounds.Weapons.AssaultGunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.AssaultGunReload'
     SelectSound=Sound'DeusExSounds.Weapons.AssaultGunSelect'
     InventoryGroup=4
     ItemName="Assault Rifle"
     ItemArticle="an"
     PlayerViewOffset=(X=16.000000,Y=-5.000000,Z=-11.500000)
     PlayerViewMesh=LodMesh'DeusExItems.AssaultGun'
     PickupViewMesh=LodMesh'DeusExItems.AssaultGunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.AssaultGun3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconAssaultGun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAssaultGun'
     largeIconWidth=94
     largeIconHeight=65
     invSlotsX=2
     invSlotsY=2
     Description="The 7.62x51mm assault rifle is designed for close-quarters combat, utilizing a shortened barrel and 'bullpup' design for increased maneuverability. An additional underhand 20mm HE launcher increases the rifle's effectiveness against a variety of targets."
     beltDescription="ASSAULT"
     Mesh=LodMesh'DeusExItems.AssaultGunPickup'
     CollisionRadius=15.000000
     CollisionHeight=1.100000
     Mass=30.000000
}
