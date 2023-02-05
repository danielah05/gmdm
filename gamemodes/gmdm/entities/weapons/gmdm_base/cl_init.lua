

// Variables that are only ever used on the client

SWEP.PrintName			= "GMDM Weapon"			
SWEP.Slot				= 3		// Slot in the weapon selection menu
SWEP.SlotPos			= 6		// Position in the slot
SWEP.DrawAmmo			= true	// Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 	// Should draw the default crosshair

SWEP.Spawnable			= true	// Is spawnable via GMOD's spawn menu
SWEP.AdminSpawnable		= true	// Is spawnable by admins

SWEP.WepSelectIcon			= surface.GetTextureID( "weapons/swep" )	// Weapon Selection Menu texture

function SWEP:DrawHUD()
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
end


function SWEP:PrintWeaponInfo( x, y, alpha )
end


/*---------------------------------------------------------
   Name: SWEP:FreezeMovement()
   Desc: Return true to freeze moving the view
---------------------------------------------------------*/
function SWEP:FreezeMovement()
	return false
end


/*---------------------------------------------------------
   Name: SWEP:ViewModelDrawn()
   Desc: Called straight after the viewmodel has been drawn
---------------------------------------------------------*/
function SWEP:ViewModelDrawn()
end


/*---------------------------------------------------------
   Name: OnRestore
   Desc: Called immediately after a "load"
---------------------------------------------------------*/
function SWEP:OnRestore()
end

/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function SWEP:OnRemove()
end



include('shared.lua')