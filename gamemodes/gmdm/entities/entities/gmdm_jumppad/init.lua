
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetModel( "models/gmdm_jumppad.mdl" )
	self.Entity:DrawShadow( false )
	
	// Make the bbox short so we can jump over it
	// Note that we need a physics object to make it call triggers
	self.Entity:SetCollisionBounds( Vector( -50, -50, -50 ), Vector( 50, 50, 5 ) )
	self.Entity:PhysicsInitBox( Vector( -50, -50, -50 ), Vector( 50, 50, 5 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableCollisions( false )		
	end
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	
end

function ENT:KeyValue( key, value )
	if ( key == "velocity" ) then
		self:SetPlayerVelocity( value )
	end
end

function ENT:StartTouch( entity )
	
	if (!entity:IsPlayer()) then return end
	
	entity:SetVelocity( Vector(0, 0, self:GetPlayerVelocity()) ) -- smallest number that seems to work is 249 for some reason
	
end