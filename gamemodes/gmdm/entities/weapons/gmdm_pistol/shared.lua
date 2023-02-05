
SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "Pistol"			
SWEP.Slot				= 1
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
if (cvars.Bool("gmdm_cmodels", true)) then
	SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
	SWEP.UseHands			= true
else
	SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
	SWEP.UseHands			= false
end
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"


function SWEP:Initialize()

	self:SetHoldType( "pistol" )
	
end



/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 32
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"

function SWEP:PrimaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )

	if ( !self:CanPrimaryAttack() ) then return end

	self:GMDMShootBullet( 14, "Weapon_Pistol.Single", math.Rand( -1, -0.5 ), math.Rand( -1, 1 ) )
	
	self:TakePrimaryAmmo( 1 )

end


/*---------------------------------------------------------
   SECONDARY
   Automatic (Uses Primary Ammo)
---------------------------------------------------------*/

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
	
	if ( !self:CanPrimaryAttack() ) then return end

	self:GMDMShootBullet( 14, "Weapon_Pistol.Single", math.Rand( -1, -0.5 ), math.Rand( -1, 1 ) )
	
	self:TakePrimaryAmmo( 1 )

end



