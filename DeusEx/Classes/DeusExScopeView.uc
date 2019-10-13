//=============================================================================
// DeusExScopeView.
//=============================================================================
class DeusExScopeView expands Window;

var bool bActive;		// is this view actually active?

var DeusExPlayer player;
var Color colLines;
var Bool  bBinocs;
var Bool  bViewVisible;
var int   desiredFOV;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	bTickEnabled = true;

	StyleChanged();
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	local Crosshair        cross;
	local DeusExRootWindow dxRoot;

	dxRoot = DeusExRootWindow(GetRootWindow());
	if (dxRoot != None)
	{
		cross = dxRoot.hud.cross;

		if (bActive)
			cross.SetCrosshair(false);
		else
			cross.SetCrosshair(player.bCrosshairVisible);
	}
}

// ----------------------------------------------------------------------
// ActivateView()
// ----------------------------------------------------------------------

function ActivateView(int newFOV, bool bNewBinocs, bool bInstant)
{
	desiredFOV = newFOV;

	bBinocs = bNewBinocs;

	if (player != None)
	{
		if (bInstant)
			player.SetFOVAngle(desiredFOV);
		else
			player.desiredFOV = desiredFOV;

		bViewVisible = True;
		Show();
	}
}

// ----------------------------------------------------------------------
// DeactivateView()
// ----------------------------------------------------------------------

function DeactivateView()
{
	if (player != None)
	{
		Player.DesiredFOV = Player.Default.DefaultFOV;
		bViewVisible = False;
		Hide();
	}
}

// ----------------------------------------------------------------------
// HideView()
// ----------------------------------------------------------------------

function HideView()
{
	if (bViewVisible)
	{
		Hide();
		Player.SetFOVAngle(Player.Default.DefaultFOV);
	}
}

// ----------------------------------------------------------------------
// ShowView()
// ----------------------------------------------------------------------

function ShowView()
{
	if (bViewVisible)
	{
		Player.SetFOVAngle(desiredFOV);
		Show();
	}
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	local float			fromX, toX;
	local float			fromY, toY;
	local float			scopeWidth, scopeHeight;
	local DeusExWeapon weap;
	local int i, j;
	local float dist, y, ang, g, speed;
	local int tickCount, minTickCount;
	local float yFirst, yLast, yMid;
	local float maxDist;
	local float tickWidth;
	local float maxY, maxAng;
	local float logDist, distMult;
	local int firstDigit;
	local float majTickDistance, minTickDistance;

	weap = DeusExWeapon(Player.inHand);
	speed = weap.ProjectileSpeed;
	Super.DrawWindow(gc);

	if (GetRootWindow().parentPawn != None)
	{
		if (player.IsInState('Dying'))
			return;
	}

	// Figure out where to put everything
	if (bBinocs)
		scopeWidth  = 512;
	else
		scopeWidth  = 512;

	scopeHeight = 512;

	fromX = (width-scopeWidth)/2;
	fromY = (height-scopeHeight)/2;
	toX   = fromX + scopeWidth;
	toY   = fromY + scopeHeight;

	// Draw the black borders
	gc.SetTileColorRGB(0, 0, 0);
	gc.SetStyle(DSTY_Normal);
	// This blocks out the area around the scope texture
	if ( Player.Level.NetMode == NM_Standalone )	// Only block out screen real estate in single player
	{
		gc.DrawPattern(0, 0, width, fromY, 0, 0, Texture'Solid');
		gc.DrawPattern(0, toY, width, fromY, 0, 0, Texture'Solid');
		gc.DrawPattern(0, fromY, fromX, scopeHeight, 0, 0, Texture'Solid');
		gc.DrawPattern(toX, fromY, fromX, scopeHeight, 0, 0, Texture'Solid');
	}
	// Draw the center scope bitmap
	// Use the Header Text color

//	gc.SetStyle(DSTY_Masked);
	if (bBinocs)
	{
		gc.SetStyle(DSTY_Modulated);
		gc.DrawTexture(fromX,       fromY, 256, scopeHeight, 0, 0, Texture'HUDBinocularView_1');
		gc.DrawTexture(fromX + 256, fromY, 256, scopeHeight, 0, 0, Texture'HUDBinocularView_2');

		gc.SetTileColor(colLines);
		gc.SetStyle(DSTY_Masked);
		gc.DrawTexture(fromX,       fromY, 256, scopeHeight, 0, 0, Texture'HUDBinocularCrosshair_1');
		gc.DrawTexture(fromX + 256, fromY, 256, scopeHeight, 0, 0, Texture'HUDBinocularCrosshair_2');
	}
	else
	{
		// Crosshairs - Use new scope in multiplayer, keep the old in single player
		if ( Player.Level.NetMode == NM_Standalone )
		{

			//gc.DrawStretchedTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeCrosshair');
			// gc.DrawStretchedTexture(fromX, fromY,
				// scopeWidth, scopeHeight,
				// 0, 0,
				// 256, 256,
				// Texture'HUDScopeCrosshair'
			// );

			gc.SetTileColor(colLines);
			gc.SetStyle(DSTY_Masked);
			// This check doesn't work yet!
			if (!weap.bProjectileGravity || weap.bProjectileGravity){

				// Factor of 0.9 is magical and seem to work
				g = - 0.9 * player.Region.Zone.ZoneGravity.Z ;

				tickWidth = 12;
				gc.SetFont(Font'FontTiny');
				gc.SetAlignments(HALIGN_Left, VALIGN_Center);
				gc.EnableWordWrap(false);
				maxY = height * 0.75;
				maxAng = 0.5 * desiredFOV * (maxY / (height)) / 57.295;
				maxDist = Tan(maxAng) * 2 * speed * speed / g;
				// Tried to get this to work with logariths and rounding
				// but the round function doesn't seem to work.
				// We only need to check a few orders of magnitude.
				if(maxDist < 160){
					distMult = 1.0;
				} else if (maxDist < 1600){
					distMult = 10.0;
				} else if (maxDist < 16000) {
					distMult = 100.0;
				} else if (maxDist < 160000){
					distMult = 1000.0;
				} else {
					distMult = 10000.0;
				}
				firstDigit = maxDist / 16 / distMult;
				switch (firstDigit){
					case 1:
						majTickDistance = distMult * 0.1;
						minTickDistance = majTickDistance / 5;
						minTickCount = 5;
						break;
					case 2:
						majTickDistance = distMult * 0.2;
						minTickDistance = majTickDistance / 5;
						minTickCount = 5;
						break;
					case 3:
						majTickDistance = distMult * 0.25;
						minTickDistance = majTickDistance / 5;
						minTickCount = 5;
						break;
					case 4:
					case 5:
						majTickDistance = distMult * 0.5;
						minTickDistance = majTickDistance / 5;
						minTickCount = 5;
						break;
					case 6:
					case 7:
					case 8:
						majTickDistance = distMult;
						minTickDistance = majTickDistance / 5;
						minTickCount = 5;
						break;
					case 9:

				}
				majTickDistance *= 16.0;
				minTickDistance *= 16.0;
				tickCount = (int(maxDist) / int(majTickDistance));
				maxDist = tickCount * int(majTickDistance);
				for  (i=1; i<=tickCount; i++){

					dist = (maxDist * i) / tickCount;
					ang =  ATan(0.5 * g / (speed * speed) * dist); // radians
					// Get the actual position on the screen
					y = (height / 2.0) + (height / 2.0) * ((ang * 57.295) / (desiredFOV / 2.0));
					if (i == 1){
						yFirst = y;
					}
					if (i > 1 && tickCount < 15){
							yMid = yLast + ((y - yLast) * 1) / 2.0;
							gc.DrawBox((width - tickWidth / 2.0) / 2.0, yMid , tickWidth / 2.0, 1, 0, 0, 1, Texture'Solid');
					}
					yLast = y;
					gc.DrawBox((width - tickWidth) / 2.0, y , tickWidth, 1, 0, 0, 1, Texture'Solid');
					gc.DrawText((width + tickWidth) / 2.0, y-4, 20, 9, int(dist / 16));
					// gc.DrawText((width + tickWidth) / 2.0 + 20, y, 20, 9, ((ang * 57.295)));
					// gc.DrawText((width + tickWidth) / 2.0 + 40, y, 20, 9, speed);
				}
				gc.DrawBox((width / 2.0), yFirst, 1, yLast - yFirst , 0, 0, 1, Texture'Solid');
			}
			gc.SetStyle(DSTY_Modulated);
			//gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView');
			gc.DrawStretchedTexture(fromX, fromY,
				scopeWidth, scopeHeight,
				0, 0,
				256, 256,
				Texture'HUDScopeView'
			);


			// for (i=1; i>=0; i--)
			// {
				// // Top vertical line
				// gc.DrawBox(x+i, y-mult-corner+i, 1, corner, 0, 0, 1, Texture'Solid');
				// // Bottom Vertical line
				// gc.DrawBox(x+i, y+mult+i, 1, corner, 0, 0, 1, Texture'Solid');

				// gc.DrawBox(x-(corner-1)/2+i, y-mult-corner+i, corner, 1, 0, 0, 1, Texture'Solid');
				// gc.DrawBox(x-(corner-1)/2+i, y+mult+corner+i, corner, 1, 0, 0, 1, Texture'Solid');

				// gc.DrawBox(x-mult-corner+i, y+i, corner, 1, 0, 0, 1, Texture'Solid');
				// gc.DrawBox(x+mult+i, y+i, corner, 1, 0, 0, 1, Texture'Solid');
				// gc.DrawBox(x-mult-corner+i, y-(corner-1)/2+i, 1, corner, 0, 0, 1, Texture'Solid');
				// gc.DrawBox(x+mult+corner+i, y-(corner-1)/2+i, 1, corner, 0, 0, 1, Texture'Solid');

				// gc.SetTileColor(crossColor);
			// }

		}
		else
		{
			if ( WeaponRifle(Player.inHand) != None )
			{
				gc.SetStyle(DSTY_Modulated);
				gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView3');
			}
			else
			{
				gc.SetStyle(DSTY_Modulated);
				gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView2');
			}
		}
	}
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colLines = theme.GetColorFromName('HUDColor_HeaderText');
}

defaultproperties
{
}
