//=============================================================================
// WeaponModRecoil
//
// Decreases recoil amount
//=============================================================================
class WeaponModRecoil extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	if (weapon != None)
	{
		weapon.recoilStrength    += (weapon.Default.recoilStrength * WeaponModifier);
		if (weapon.recoilStrength < 0.0)
			weapon.recoilStrength = 0.0;
        weapon.aimAbility        -= (weapon.Default.aimAbility * WeaponModifier);
		weapon.ModRecoilStrength += WeaponModifier;
	}
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveModRecoilStrength && !weapon.HasMaxRecoilMod());
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WeaponModifier=-0.100000
     ItemName="Weapon Modification (Aiming)"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModRecoil'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModRecoil'
     Description="Harmonic dampeners improve weapon stability for static aiming. A stock cushioned with polycellular shock absorbing material will significantly reduce perceived recoil."
     beltDescription="MOD AIM"
     Skin=Texture'DeusExItems.Skins.WeaponModTex5'
}
