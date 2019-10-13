//=============================================================================
// ElectroBolt.
//=============================================================================
class ElectroBolt extends DeusExProjectile;

var ParticleGenerator pGen1;
var ParticleGenerator pGen2;

var float mpDamage;
var float mpBlastRadius;

var int branchcount;
var int maxbranches;
var int numchildren;
var float zaptime;
var float zaplimit;
var bool bZapping;
var ElectricityEmitterSelfReplicating emitter;

#exec OBJ LOAD FILE=Effects

state Exploding
{

	ignores ProcessTouch, HitWall, Explode;
Begin:
	Velocity = vect(0,0,0);
	bHidden = True;
	LightType = LT_None;
	SetCollision(False, False, False);
	HurtRadius
	(
		Damage,
		blastRadius,
		damageType,
		MomentumTransfer,
		Location,
		False
	);
}


function SpawnChildren()
{
	local SpawnerElectricityEmitterSelfReplicating EmitterSpawner;
	EmitterSpawner = spawn(
		class'SpawnerElectricityEmitterSelfReplicating',
		,
		,
		Location
	);
	// local int i;
	// local rotator direction;
	// local actor Target;
	// local ElectroBolt child;
	// if (branchcount < maxbranches)
	// {
	// 	bZapping = True;
	// 	zaptime = 0;
	// 	i = 0;
	// 	foreach VisibleActors(class'Actor', Target, 512)
	// 	{
	// 		//if ((Projectile(Target) == None) && (i < numchildren))
	// 		if ((ScriptedPawn(Target) != None) && (i < numchildren))
	// 		{
	// 			i++;
	// 			direction = rotator(Target.Location - Location);
	// 			// child = Spawn(class'ElectroBolt',,, Location, direction);
	// 			// child.branchcount = branchcount + 1;
	// 			emitter = Spawn(
	// 				  class'ElectricityEmitterSelfReplicating',
	// 					,
	// 					,
	// 					Location,
	// 					direction
	// 				);
	// 			  emitter.randomAngle = 8192; // 32768;
	// 			  emitter.damageAmount = 6;
	// 			  emitter.TimeLimit = 10;
	// 		}
	// 	}
	// }
}
simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	SpawnChildren();
}



simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	Damage = mpDamage;
	blastRadius = mpBlastRadius;
}



// DEUS_EX AMSD Should not be called as server propagating to clients.
simulated function SpawnPlasmaEffects()
{
	local Rotator rot;
    rot = Rotation;
	rot.Yaw -= 32768;

    pGen2 = Spawn(class'ParticleGenerator', Self,, Location, rot);
	if (pGen2 != None)
	{
      pGen2.RemoteRole = ROLE_None;
		pGen2.particleTexture = Texture'Effects.Fire.Wepn_Prod_FX';
		pGen2.particleDrawScale = 0.1;
		pGen2.checkTime = 0.04;
		pGen2.riseRate = 0.0;
		pGen2.ejectSpeed = 100.0;
		pGen2.particleLifeSpan = 0.5;
		pGen2.bRandomEject = True;
		pGen2.SetBase(Self);
	}

}



simulated function Destroyed()
{
	if (pGen1 != None)
		pGen1.DelayedDestroy();
	if (pGen2 != None)
		pGen2.DelayedDestroy();

	Super.Destroyed();
}

defaultproperties
{
     mpDamage=8.000000
     mpBlastRadius=300.000000
     bExplodes=True
     DamageType=Stunned
     AccurateRange=14400
     maxRange=24000
     bIgnoresNanoDefense=True
     ItemName="Electro Bolt"
     ItemArticle="a"
     speed=1000.000000
     MaxSpeed=1000.000000
     Damage=5.000000
     MomentumTransfer=5000
     ImpactSound=Sound'DeusExSounds.Weapons.PlasmaRifleHit'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     Mesh=LodMesh'DeusExItems.PlasmaBolt'
     DrawScale=3.000000
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=200
     LightHue=160
     LightSaturation=128
     LightRadius=3
     bFixedRotationDir=True
	   Skin=Texture'Effects.Fire.Wepn_Prod_FX'
	   branchcount=0
	   maxbranches=3
	   numchildren=6
	   zaplimit=5.0
	   bZapping=False
}
