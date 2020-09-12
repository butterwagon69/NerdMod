NerdMod V0.0.2
==============

Installation
============

Copy and replace the DeusEx.u file in your game's system folder.


Features
========

* Weapon Control System
    > Weapon aim point is controlled by modelling the weapon as a spring-mass-damper system.
    > This provides more realistic behavior of weapons both for the player and npcs:
    >
    > * 360 No-Scoping causes the weapon to sway away from the center of the screen
    > * Running causes the weapon to sway in time with your steps
    > * Walking causes less weapon sway than running
    > * Dodging NPCs is viable because their aimpoint lags behind their desired aim exactly as yours does
    > * Weapons now have 3 stats that govern accuracy: 
    >     * Base accuracy determines how close the bullet hits to where the weapon's actual aim point
    >     * "Aim Ability" determines how quickly a weapon can be brought on target after the aim point stops moving (analogous to damping ratio)
    >     * "Handle Ability" determines how closely the weapon will follow the point of aim while the aimpoint moves (analogous to natural frequency)
* Other Weapon Enhancements
    * Make weapon skill change bringup/putdown speed
    * Make projectiles turn into ammo so you can pick up darts and throwing knives from bodies
    * Adjust weapon fire rate based on skill so that you can fire faster at higher skill levels
    * Scope mod provides actual range offset information for weapons with drop like the mini crossbow
    * Laser sight shows distance to target (this plays well with the scope mod)
    * Add special magnum ammo for sniper rifle - does extra damage, single load only, can't be silenced, and shoots through thin walls. Get this from lucky NPC drops
    * The PS20 is now a reusable double-barrelled shotgun that's pretty fun to shoot!
    * Sabot rounds are now a single slug instead of a spread
    * Shotgun spread doesn't depend on your skill level or current accuracy
    * Throwing knives travel faster the higher your skill (and even faster with the combat strength aug)
    * Flare darts explode on impact
* Other Tweaks
    * Tweak ammo box sizes
    * Allow special ammo types to drop on npcs
    * Change stun timer based on damage
    * Change skill costs and values
    * Increase shell casing speed
    * Change AugBallistic values
    * Calculate skill based on pawn special skills
    * Make items visible in vision aug (buggy)
    * Make MIBs and Walton more accurate
    * Make pickup ammo count from corpses depend on clip size
    * Make plasma rifle buggy and fun
    * Tweak weapon mods
    * Make AssaultGun grenades require reload
    * Tweak weapon parameters
    * Modify pawn firing behavior


