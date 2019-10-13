//=============================================================================
// DartFlare.
//=============================================================================
class DartFlare extends Dart;

var float mpDamage;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
		Damage = mpDamage;
}

state Exploding2
{
	ignores ProcessTouch, HitWall, Explode;

   function DamageRing()
   {
		local Pawn apawn;
		local float damageRadius;
		local Vector dist;
      //DEUS_EX AMSD Ignore Line of Sight on the lowest radius check, only in multiplayer
		HurtRadius
		(
			Damage,
			blastRadius,
			damageType,
			MomentumTransfer,
			Location,
			True
		);
		PlayImpactSound();
   }


	function Timer()
	{
		Destroy();
	}

Begin:
	// stagger the HurtRadius outward using Timer()
	// do five separate blast rings increasing in size
	Velocity = vect(0,0,0);
	bHidden = True;
	LightType = LT_None;
	SetCollision(False, False, False);
	DamageRing();
	SetTimer(1, True);
}





auto simulated state Flying
{
	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local bool bDestroy;
         //DEUS_EX AMSD Don't draw effects on dedicated server
		DrawExplosionEffects(HitLocation, HitNormal);
		GotoState('Exploding2');
		PlayImpactSound();
		if (bDestroy)
			Destroy();
	}
}



defaultproperties
{
	 blastRadius=32.000000
     mpDamage=10.000000
     DamageType=Sabot
	 bStickToWall=False
     spawnAmmoClass=Class'DeusEx.AmmoDartFlare'
     ImpactSound=Sound'DeusExSounds.Generic.SmallExplosion1'
     ItemName="Flare Dart"
     Damage=35.000000
     speed=1600.000000
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=16
     LightSaturation=192
     LightRadius=4
	 bExplodes=True
}
