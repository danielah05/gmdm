
SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "Egon"			
SWEP.Slot				= 4
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
if (cvars.Bool("gmdm_cmodels", true)) then
	SWEP.ViewModel			= "models/weapons/c_superphyscannon.mdl"
	SWEP.UseHands			= true
else
	SWEP.ViewModel			= "models/weapons/v_superphyscannon.mdl"
	SWEP.UseHands			= false
end
SWEP.WorldModel			= "models/weapons/w_physics.mdl"

local sndPowerUp		= Sound("Airboat.FireGunHeavy")
local sndAttackLoop 	= Sound("Airboat_fan_idle")
local sndPowerDown		= Sound("Town.d1_town_02a_spindown")
local sndNoAmmo			= Sound("Weapon_Shotgun.Empty")

function SWEP:Initialize()
	if (cvars.Bool("gmdm_wmodels_holdfix", true)) then
		self:SetHoldType( "physgun" )
	else
		self:SetHoldType( "smg" )
	end
	
end



/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

function SWEP:Think()

	if (!self.Owner || self.Owner == NULL) then return end
	
	if ( self.Owner:GetCustomAmmo( "egonenergy" ) <= 0 ) then
	
		if ( self.Owner:KeyPressed( IN_ATTACK ) ) then
		
			self.Weapon:EmitSound( sndNoAmmo )
		
		end
		
		self:EndAttack( false )
		return
		
	end
	
	if ( self.Owner:KeyPressed( IN_ATTACK ) ) then
	
		self:StartAttack()
		
	elseif ( self.Owner:KeyDown( IN_ATTACK ) ) then
	
		self:UpdateAttack()
		
	elseif ( self.Owner:KeyReleased( IN_ATTACK ) ) then
	
		self:EndAttack( true )
	
	end

end



function SWEP:StartAttack()

	if (SERVER) then
		
		if (!self.Beam) then
			self.Beam = ents.Create( "egon_beam" )
				self.Beam:SetPos( self.Owner:GetShootPos() )
			self.Beam:Spawn()
		end
		
		self.Beam:SetParent( self.Owner )
		self.Beam:SetOwner( self.Owner )
	
	end

	self:UpdateAttack()
	self.Weapon:EmitSound( sndPowerUp )
	self.Weapon:EmitSound( sndAttackLoop )

end

function SWEP:UpdateAttack()
	
	if ( self.Timer && self.Timer > CurTime() ) then return end
	
	self.Timer = CurTime() + 0.05
	
	self.Owner:AddCustomAmmo( "egonenergy", -1 )
	
	// We lag compensate here. This moves all the players back to the spots where they were
	// when this player fired the gun (a ping time ago).
	self.Owner:LagCompensation( true )
	
	local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = trace.start + (self.Owner:GetAimVector() * 4096)
		trace.filter = { self.Owner, self.Weapon }
		
	local tr = util.TraceLine( trace )
	
	if (SERVER && self.Beam) then
		self.Beam:GetTable():SetEndPos( tr.HitPos )
	end
	
	util.BlastDamage( self.Weapon, self.Owner, tr.HitPos, 80, 5 )
	
	if ( tr.Entity && tr.Entity:IsPlayer() ) then
	
		local effectdata = EffectData()
			effectdata:SetEntity( tr.Entity )
			effectdata:SetOrigin( tr.HitPos )
			effectdata:SetNormal( tr.HitNormal )
		util.Effect( "bodyshot", effectdata )
	
	end
	
	self.Owner:LagCompensation( false )
	
end

function SWEP:EndAttack( shutdownsound )
	
	self.Weapon:StopSound( sndAttackLoop )
	
	if ( shutdownsound ) then
		self.Weapon:EmitSound( sndPowerDown )
	end
	
	if ( CLIENT ) then return end
	if ( !self.Beam ) then return end
	
	self.Beam:Remove()
	self.Beam = nil
	
end

function SWEP:Holster()
	self:EndAttack( false )
	return true
end

function SWEP:OnRemove()
	self:EndAttack( false )
	return true
end


function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

