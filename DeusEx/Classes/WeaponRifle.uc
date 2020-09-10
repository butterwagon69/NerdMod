//=============================================================================
// WeaponRifle.
//=============================================================================
class WeaponRifle extends DeusExWeapon;

var float	mpNoScopeMult;
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
      bHasMuzzleFlash = True;
      ReloadCount = 1;
      ReloadTime = ShotTime;
	}
    else
    {
        SetReloadCount();
    }

}

simulated function SetReloadCount()
{
    // Sets the correct reload count for sniper rifle
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
            break;
        case 1:
			ReloadCount = 1;
			LowAmmoWaterMark = 4;
            break;
    }
}

// Want to make snipers super dangerous
simulated function float GetWeaponSkill()
{
	if (ScriptedPawn(Owner) != None) {
		return -0.7;
	}
	else
	{
		return Super.GetWeaponSkill();
	}
}

function bool LoadAmmo(int ammoNum)
{
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

function name WeaponDamageType()
{
	local name                    damageType;
	local Class<DeusExProjectile> projClass;
	if (ammoLoadedIndex == 1)
	{
		damageType = 'Sabot';
	}
	else
	{
		damageType = 'Shot';
	}
	return (damageType);
}

simulated function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local float        mult;
	local Vector StartTrace, EndTrace,  NextHitLocation, NextHitNormal;
	local Rotator rot;
	local actor nextTarget;
	local name         damageType;
	local DeusExPlayer dxPlayer;
	local int damage;


	Super.ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);

	if (ammoLoadedIndex == 1)
	{

		StartTrace = HitLocation + 32 * vector(aimActual);
		//EndTrace = StartTrace + (FMax(1024, MaxRange) * HitNormal);
		EndTrace = StartTrace + (FMax(1024, MaxRange) * vector(aimActual));

		nextTarget = Pawn(Owner).TraceShot(NextHitLocation, NextHitNormal, EndTrace, StartTrace);
		if ((nextTarget == Level) || ((nextTarget != None) && nextTarget.IsA('Mover')))
		{
			Super.ProcessTraceHit(nextTarget, NextHitLocation, NextHitNormal, X, Y, Z);
		}
		else
		{
			ProcessTraceHit(nextTarget, NextHitLocation, NextHitNormal, X, Y, Z);
		}
	}

}

function GetAIVolume(out float volume, out float radius)
{
	if (ammoLoadedIndex == 0)
	{
		Super.GetAIVolume(volume, radius);
	}
	else
	{
        // magnum ammo is loud
		volume = NoiseLevel*Pawn(Owner).SoundDampening;
		radius = volume * 4800.0;
	}
}



simulated function PlayFiringSound()
{
	if (ammoLoadedIndex == 0)
	{
		Super.PlayFiringSound();
	}
	else
	{
        // No silencer for magnum ammo
		PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, 2048 );
	}
}

defaultproperties
{
     mpNoScopeMult=0.350000
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=2.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=1.500000
     reloadTime=2.000000
     HitDamage=25
     maxRange=48000
     AccurateRange=28800
     bCanHaveScope=True
     bHasScope=True
     bCanHaveLaser=True
     bCanHaveSilencer=True
     bHasMuzzleFlash=False
     recoilStrength=9.0000
     bUseWhileCrouched=False
     mpReloadTime=2.000000
     mpHitDamage=25
     mpAccurateRange=28800
     mpMaxRange=28800
     mpReloadCount=4
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.Ammo3006'
		 AmmoNames(0)=Class'DeusEx.Ammo3006'
     AmmoNames(1)=Class'DeusEx.Ammo3006Magnum'
	   BaseAccuracy=0.0250000
     ReloadCount=4
     PickupAmmoCount=4
     bInstantHit=True
     FireOffset=(X=-20.000000,Y=2.000000,Z=30.000000)
     shakemag=50.000000
     FireSound=Sound'DeusExSounds.Weapons.RifleFire'
     AltFireSound=Sound'DeusExSounds.Weapons.RifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.RifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.RifleSelect'
     InventoryGroup=5
     ItemName="Sniper Rifle"
     PlayerViewOffset=(X=20.000000,Y=-2.000000,Z=-30.000000)
     PlayerViewMesh=LodMesh'DeusExItems.SniperRifle'
     PickupViewMesh=LodMesh'DeusExItems.SniperRiflePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.SniperRifle3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconRifle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconRifle'
     largeIconWidth=159
     largeIconHeight=47
     invSlotsX=4
     Description="The military sniper rifle is the superior tool for the interdiction of long-range targets. When coupled with the proven 30.06 round, a marksman can achieve tight groupings at better than 1 MOA (minute of angle) depending on environmental conditions."
     beltDescription="SNIPER"
     Mesh=LodMesh'DeusExItems.SniperRiflePickup'
     CollisionRadius=26.000000
     CollisionHeight=2.000000
     Mass=30.000000
	 	 handleAbility=0.4
	 	 aimAbility=2.5
}
