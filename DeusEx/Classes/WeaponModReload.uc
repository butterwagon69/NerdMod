//=============================================================================
// WeaponModReload
//
// Decreases reload time
//=============================================================================
class WeaponModReload extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	if (weapon != None)
	{
		weapon.ReloadTime    += (weapon.Default.ReloadTime * WeaponModifier);
		if (weapon.ReloadTime < 0.0)
			weapon.ReloadTime = 0.0;
        weapon.handleAbility -= (weapon.Default.HandleAbility * weaponModifier);
		weapon.ModReloadTime += WeaponModifier;
	}
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveModReloadTime && !weapon.HasMaxReloadMod());
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WeaponModifier=-0.100000
     ItemName="Weapon Modification (Handling)"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModReload'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModReload'
     Description="A handling upgrade allows faster reload and improves dynamic weapon handling"
     beltDescription="MOD HNDLNG"
     Skin=Texture'DeusExItems.Skins.WeaponModTex6'
}
