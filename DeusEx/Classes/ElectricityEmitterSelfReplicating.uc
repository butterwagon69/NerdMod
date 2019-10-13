//=============================================================================
// ElectricityEmitterSelfReplicating
//=============================================================================
class ElectricityEmitterSelfReplicating extends ElectricityEmitterTimed;

var int branchcount;
var int maxbranches;
var int numchildren;
var int maxchildren;
var actor AttachedTo;
var actor Target;
var bool bAttached;


function ProcessActorHit(vector HitLocation, actor HitActor)
{
	local SpawnerElectricityEmitterSelfReplicating EmitterSpawner;
	local ElectricityEmitterSelfReplicating emitter;
	local float distance;

	Super.ProcessActorHit(HitLocation, HitActor);
	distance = VSize(HitLocation - Location);

	if (
		(branchcount < maxbranches)
		&& (numchildren < maxchildren)
		&& (distance < 512)
		&& (distance > 64)
		&& (ScriptedPawn(HitActor) != None)
		)
	{
		numchildren += 1;
		EmitterSpawner = Spawn(
			class'SpawnerElectricityEmitterSelfReplicating',
			,
			,
			HitLocation
		);
		EmitterSpawner.branchcount = branchcount + 1;
		EmitterSpawner.maxbranches = maxbranches;
		EmitterSpawner.maxchildren = maxchildren;
		EmitterSpawner.damageAmount = damageAmount;
		EmitterSpawner.TimeLimit = TimeLimit;
		EmitterSpawner.randomAngle = randomAngle;

		// emitter = Spawn(
		// 	class'ElectricityEmitterSelfReplicating',
		// 	,
		// 	,
		// 	HitLocation,
		// 	Rotator(Location - HitLocation)
		// );
		// emitter.branchcount = branchcount + 1;
		// emitter.maxbranches = maxbranches;
		// emitter.randomAngle = 32768;
		// emitter.damageAmount = damageAmount;
		// emitter.TimeLimit = TimeLimit;
		// emitter.AttachedTo = HitActor;
		// emitter.bAttached = True;
		Destroy();
	} else {
	}
}


simulated function Tick(float deltaTime)
{
	Super.Tick(deltaTime);
	if (Target == None){
		randomAngle = 32768;
	}
	SetRotation(Rotator(Target.Location - Location));
	// if ((HitActor == None) && (bAttached) && (TimeActive < 2 * deltaTime)){
		// Destroy();
	// }
}

defaultproperties
{
	 branchcount=0
	 maxbranches=3
	 numchildren=0
	 maxchildren=3
	 bAttached=False
}
