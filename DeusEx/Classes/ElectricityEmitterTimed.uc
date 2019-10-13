//=============================================================================
// ElectricityEmitterTimed
//=============================================================================
class ElectricityEmitterTimed extends ElectricityEmitter;

var float TimeLimit;
var float TimeActive;

simulated function Tick(float deltaTime)
{
	Super.Tick(deltaTime);
	TimeActive += deltaTime;
	if (TimeActive >= TimeLimit)
	{
		Destroy();
	}
}

defaultproperties
{
	TimeLimit=5.0
	TimeActive=0.0
	damageType=Stunned
}
