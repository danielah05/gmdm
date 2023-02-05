
SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "Shotgun"			
SWEP.Slot				= 2
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
if (cvars.Bool("gmdm_cmodels", true)) then
	SWEP.ViewModel			= "models/weapons/c_shotgun.mdl"
	SWEP.UseHands			= true
else
	SWEP.ViewModel			= "models/weapons/v_shotgun.mdl"
	SWEP.UseHands			= false
end
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"

function SWEP:NeedsPump()
	return self.Weapon:GetNWBool( "NeedsPump" )
end

function SWEP:SetNeedsPump( b )
	self.Weapon:SetNWBool( "NeedsPump", b )
end

function SWEP:Initialize()
	if (cvars.Bool("gmdm_wmodels_holdfix", true)) then
		self:SetHoldType( "shotgun" )
	else
		self:SetHoldType( "smg" )
	end
	self:SetNeedsPump( false )
	
	self.LastTime = 0;
	
end


/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

function SWEP:PrimaryAttack()

	if ( self.LastTime >= CurTime() ) then return end
	self.LastTime = CurTime()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.2 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
	
	if ( self:Ammo1() <= 0 ) then return end
	
	if ( self:NeedsPump() ) then
	
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
		self.Weapon:EmitSound( "Weapon_Shotgun.Special1" )
		self:SetNeedsPump( false )
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
	
	return end

	self:GMDMShootBullet( 12, "Weapon_Shotgun.Single", -5, math.Rand( -5, 5 ), 4, 0.1 )
	
	
	self:TakePrimaryAmmo(1)
	self:SetNeedsPump( true )

end


/*---------------------------------------------------------
   SECONDARY
   Automatic (Uses Primary Ammo)
---------------------------------------------------------*/

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

local sndDblShoot = Sound( "Town.d1_town_01a_shotgun_dbl_fire" )

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

	if ( self:Ammo1() <= 0 ) then return end
	
	if ( self:NeedsPump() ) then
	
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
		self.Weapon:EmitSound( "Weapon_Shotgun.Special1" )
		if (SERVER) then self:SetNeedsPump( false ) end
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
	
	return end

	self:GMDMShootBullet( 8, sndDblShoot, -20, math.Rand( -15, 15 ), 20, 0.2 )
	
	
	self:TakePrimaryAmmo(2)
	self:SetNeedsPump(true)
	
	if ( SERVER ) then
		self.Owner:TakeDamage( 8, self.Owner, self.Owner )
		self.Owner:SetGroundEntity( NULL )
		self.Owner:SetVelocity( self.Owner:GetAimVector() * -100 )
	end
	
	if ( CLIENT ) then
		MotionBlur = 0.6
		ColorModify[ "$pp_colour_addr" ] = 0.1
	end

end



