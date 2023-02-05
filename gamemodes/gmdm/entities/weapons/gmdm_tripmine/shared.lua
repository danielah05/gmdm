
SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "Tripmine"			
SWEP.Slot				= 5
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
if (cvars.Bool("gmdm_cmodels", true)) then
	SWEP.ViewModel			= "models/weapons/c_grenade.mdl"
	SWEP.UseHands			= true
else
	SWEP.ViewModel			= "models/weapons/v_grenade.mdl"
	SWEP.UseHands			= false
end
SWEP.WorldModel			= "models/weapons/w_grenade.mdl"

function SWEP:Initialize()

	self:SetWeaponHoldType( "grenade" )
	
end



/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

local function FinishGrenadeThrow( swep )

	if (!swep || swep == NULL ) then return end
	swep:FinishGrenadeThrow()

end

function SWEP:Deploy()
	self:Think()
end

function SWEP:Think()

	if ( SERVER ) then
	
		self.Owner:DrawViewModel( self.Owner:GetCustomAmmo( "tripmine" ) > 0 )
	
	end

end


function SWEP:PrimaryAttack()

	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_LOW )

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.1 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.1 )
	
	if ( self.Owner:GetCustomAmmo( "tripmine" ) <= 0 ) then return end
	
	self.Owner:AddCustomAmmo( "tripmine", -1 )

	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_HIGH )
	
	if ( SERVER ) then
		timer.Simple( 0.1, function() self:FinishGrenadeThrow() end )
	end
	
	// Throw Animation

end

function SWEP:FinishGrenadeThrow()

	local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64
		trace.mask = MASK_NPCWORLDSTATIC
		trace.filter = self.Owner
		
	local tr = util.TraceLine( trace )
	
	local ent = ents.Create( "item_tripmine" )
	if ( ent && ent != NULL ) then
	
		ent:SetPos( trace.endpos )
		ent:Spawn()
		ent:Activate()
		ent:SetVar( "Thrower", self.Owner )
		
		if ( tr.Hit ) then
		
			// If we're close enougfh to place it straight on the wall then place
			ent:GetTable():StartTripmineMode( tr.HitPos + tr.HitNormal*4, tr.HitNormal )
		else
			// Else throw it
			ent:GetPhysicsObject():SetVelocity( self.Owner:GetAimVector() * 2000 + self.Owner:GetVelocity() )
		end
		
		
	end
	
	self.Weapon:SendWeaponAnim( ACT_VM_THROW )

end

/*---------------------------------------------------------
   SECONDARY
   Same
---------------------------------------------------------*/

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:SecondaryAttack()

	self:PrimaryAttack()

end


