//=============================================================================
// DeusExAmmo.
//=============================================================================
class DeusExAmmo extends Ammo
	abstract;

var localized String msgInfoRounds;

// True if this ammo can be displayed in the Inventory screen
// by clicking on the "Ammo" button.

var bool bShowInfo;
var int MPMaxAmmo; //Max Ammo in multiplayer.
var() int numSlugs;
var() int HitDamageSpecial; //If this is special ammo give it special damage else 0
var name damageType;
var float fSpreadMult; // Scales the spread of the parent weapon
var() int dropRate; // If special ammo, how rarely does this "drop" on corpses - 0 = Never; 100 = Always

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------
function PostBeginPlay()
{
	Super.PostBeginPlay();
   if (Level.NetMode != NM_Standalone)
   {   
      if (MPMaxAmmo == 0)      
         MPMaxAmmo = AmmoAmount * 3;
      MaxAmmo = MPMaxAmmo;
   }
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);
	winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());

	// number of rounds left
	winInfo.AppendText(Sprintf(msgInfoRounds, AmmoAmount));

	return True;
}

// ----------------------------------------------------------------------
// PlayLandingSound()
// ----------------------------------------------------------------------

function PlayLandingSound()
{
	if (LandSound != None)
	{
		if (Velocity.Z <= -200)
		{
			PlaySound(LandSound, SLOT_None, TransientSoundVolume,, 768);
			AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 768);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     msgInfoRounds="%d Rounds remaining"
     bDisplayableInv=False
     PickupMessage="You found"
     ItemName="DEFAULT AMMO NAME - REPORT THIS AS A BUG"
     ItemArticle=""
     LandSound=Sound'DeusExSounds.Generic.PaperHit1'
	 numSlugs=1
	 damageType='Shot'
	 HitDamageSpecial=0
	 fSpreadMult=1.0
	 dropRate=0
	 bVisionImportant=True
}
