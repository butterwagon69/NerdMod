//=============================================================================
// SpawnerElectricityEmitterSelfReplicating
//=============================================================================
class SpawnerElectricityEmitterSelfReplicating extends Actor;
var int branchcount;
var int maxbranches;
var int maxchildren;
var() int damageAmount;				// how much damage does this do?
var float TimeLimit;
var int randomAngle;

simulated function PreBeginPlay()
{
  local actor Target;
  local int i;
  local rotator direction;
  local ElectricityEmitterSelfReplicating emitter;

	Super.PreBeginPlay();
  foreach VisibleActors(class'Actor', Target, 512)
  {
    if ((ScriptedPawn(Target) != None) && (i < maxchildren))
    {
      i++;
      direction = rotator(Target.Location - Location);
      emitter = Spawn(
          class'ElectricityEmitterSelfReplicating',
          ,
          ,
          Location,
          direction
        );
        emitter.randomAngle = randomAngle; // 32768;
        emitter.damageAmount = damageAmount;
        emitter.TimeLimit = TimeLimit;
        emitter.branchcount = branchcount + 1;
        emitter.maxbranches = maxbranches;
        emitter.maxchildren = maxchildren;
        emitter.Target = Target;

    }
  }

}

simulated function Tick(float deltaTime)
{
	Super.Tick(deltaTime);
  Destroy();
}


defaultproperties
{
  branchcount=0
  maxbranches=4
  maxchildren=2
  TimeLimit=6
  damageAmount=2
  randomAngle=2048
}
