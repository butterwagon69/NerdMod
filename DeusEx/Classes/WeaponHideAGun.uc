//=============================================================================
// WeaponHideAGun.
//=============================================================================
class WeaponHideAGun extends DeusExWeapon;


state Reload
{
ignores Fire, AltFire;

	function float GetReloadTime()
	{
		local float val;

		val = ReloadTime;

		if (ScriptedPawn(Owner) != None)
		{
			val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		}
		else if (DeusExPlayer(Owner) != None)
		{
			// check for skill use if we are the player
			val = GetWeaponSkill();
			val = ReloadTime + (val*ReloadTime);
		}

		return val;
	}

	function NotifyOwner(bool bStart)
	{
		local DeusExPlayer player;
		local ScriptedPawn pawn;

		player = DeusExPlayer(Owner);
		pawn   = ScriptedPawn(Owner);

		if (player != None)
		{
			if (bStart)
				player.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
			{
				player.DoneReloading(self);
			}
		}
		else if (pawn != None)
		{
			if (bStart)
				pawn.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
				pawn.DoneReloading(self);
		}
	}

Begin:
	FinishAnim();

	// only reload if we have ammo left
	if (AmmoType.AmmoAmount > 0)
	{
		if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
		{
			ClientReload();
			Sleep(GetReloadTime());
			ReadyClientToFire( True );
		}
		else
		{
			bWasZoomed = bZoomed;
			if (bWasZoomed)
				ScopeOff();

			Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin
			PlayAnim('Down', 1.0, 0.05);
			NotifyOwner(True);
			FinishAnim();
			LoopAnim('Reload');
			Sleep(GetReloadTime());
			Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
			PlayAnim('Select',1.0,0.0);
			FinishAnim();
			NotifyOwner(False);

			if (bWasZoomed)
				ScopeOn();

			ClipCount = 0;
		}
	}
	GotoState('Idle');
}





state NormalFire
{
	function AnimEnd()
	{
		if (bAutomatic)
		{
			if ((Pawn(Owner).bFire != 0) && (AmmoType.AmmoAmount > 0))
			{
				if (PlayerPawn(Owner) != None)
					Global.Fire(0);
				else
					GotoState('FinishFire');
			}
			else
				GotoState('FinishFire');
		}
		else
		{
			// if we are a thrown weapon and we run out of ammo, destroy the weapon
			if (bHandToHand && (ReloadCount > 0) && (AmmoType.AmmoAmount <= 0))
				Destroy();
		}
	}
	function float GetShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
			}
			if (bAutomatic){
				sTime = ShotTime;
			} else {
				sTime = ShotTime * mult / GetAnimSpeed();
			}

			return (sTime);
		}
	}

Begin:
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
	{
		bFiring = False;

		if (Owner != None)
		{
			if (Owner.IsA('DeusExPlayer'))
			{
				bFiring = False;

				// should we autoreload?
				if (DeusExPlayer(Owner).bAutoReload)
				{
					// auto switch ammo if we're out of ammo and
					// we're not using the primary ammo
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();
					ReloadAmmo();
				}
				else
				{
					if (bHasMuzzleFlash)
						EraseMuzzleFlashTexture();
					GotoState('Idle');
				}
			}
			else if (Owner.IsA('ScriptedPawn'))
			{
				bFiring = False;
				ReloadAmmo();
			}
		}
		else
		{
			if (bHasMuzzleFlash)
				EraseMuzzleFlashTexture();
			GotoState('Idle');
		}
	}
	Sleep(GetShotTime());
	bFiring = False;

	// if ReloadCount is 0 and we're not hand to hand, then this is a
	// single-use weapon so destroy it after firing once
	ReadyToFire();
Done:
	bFiring = False;
	Finish();
}
function PreBeginPlay()
{
	// I don't know why I have to do this
	Description = "The PS20 is a concealable short-barrel shotgun designed for emergency situations. The massive spread, colossal recoil and slow reload make it impractical for most situations.";
	Super.PreBeginPlay();
}












defaultproperties
{
     LowAmmoWaterMark=3
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.010000
     Concealability=CONC_All
     ShotTime=1.000000
     reloadTime=5.000000
     HitDamage=6
     maxRange=1200
     AccurateRange=600
     BaseAccuracy=0.400000
     bHasMuzzleFlash=False
     bEmitWeaponDrawn=False
     AmmoNames(0)=Class'DeusEx.AmmoShell'
	 AmmoName=Class'DeusEx.AmmoShell'
     ReloadCount=3
     PickupAmmoCount=3
     bInstantHit=True
     FireOffset=(X=-20.000000,Y=10.000000,Z=16.000000)
     shakemag=50.000000
     FireSound=Sound'DeusExSounds.Weapons.SawedOffShotgunFire'
     SelectSound=Sound'DeusExSounds.Weapons.HideAGunSelect'
     AltFireSound=Sound'DeusExSounds.Weapons.HideAGunSelect'
     CockingSound=Sound'DeusExSounds.Weapons.HideAGunSelect'
     ItemName="PS20"
     PlayerViewOffset=(X=20.000000,Y=-10.000000,Z=-16.000000)
     PlayerViewMesh=LodMesh'DeusExItems.HideAGun'
     PickupViewMesh=LodMesh'DeusExItems.HideAGunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.HideAGun3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconHideAGun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconHideAGun'
     largeIconWidth=29
     largeIconHeight=47
     Description="The PS20 is a concealable short-barrel shotgun designed for emergency situations. The massive spread, colossal recoil and slow reload make it impractical for most situations."
     beltDescription="PS20"
     Mesh=LodMesh'DeusExItems.HideAGunPickup'
     CollisionRadius=3.300000
     CollisionHeight=0.600000
     Mass=5.000000
     Buoyancy=2.000000
	 handleAbility=4.0000
	 aimAbility=1.5
	 numSlugsOverride=27
	 ammoConsumption=3
	 recoilStrength=60.00
	 NoiseLevel=5.000000
}
