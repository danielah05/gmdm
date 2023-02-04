
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:DrawShadow( false )
	self.Entity:SetModel( "models/props_c17/doll01.mdl" )
	self.Entity:PhysicsInit( SOLID_BBOX )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )

	self.DieTime = CurTime() + math.Rand( 55, 60 )
	
	// use ent_bbox to see the real bounds
	self.Entity:SetCollisionBounds( Vector( -32, -32, -8 ), Vector( 32, 32, 8 ) )
	
end

function ENT:Think()

	if ( self.DieTime < CurTime() ) then
	
		self:PickedUp( NULL )

	end

end

util.PrecacheSound( "ambient/creatures/town_child_scream1.wav" )

function ENT:PickedUp( ent )

	sound.Play( "ambient/creatures/town_child_scream1.wav", self.Entity:GetPos(), 140, math.Rand( 100, 200 ) )

	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetEntity( ent )
	util.Effect( "soul", effectdata, true, true )

	self.Entity:Remove()
	self.Dead = true
		
end

/*---------------------------------------------------------
   Name: Touch
---------------------------------------------------------*/
function ENT:Touch( entity )

	if ( self.Dead ) then return end
	if (!entity:IsPlayer()) then return end
	
	entity:AddFrags( 1 )
	
	self:PickedUp( entity )

end

function ENT:OnTakeDamage( dmginfo )
	self.Entity:TakePhysicsDamage( dmginfo )
end

