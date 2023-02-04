
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local sndStick = Sound( "physics/metal/sawblade_stick3.wav" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:DrawShadow( false )
	self.Entity:SetModel( "models/props_interiors/pot01a.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:SetTrigger( true )
	
end

function ENT:Think()

	if ( self.Placed ) then
		
		// Todo: Make it solid so the player can walk on it
		// Requires fixing player getting stuck in it when placing.
		//self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
		self.Placed = nil
	end
	
	if ( self.ExplodeTimer && self.ExplodeTimer < CurTime() ) then
		self:Explode()
	end

end

function ENT:OnTakeDamage( dmginfo )
	
	if ( self.ExplodeTimer ) then return end
	
	self.ExplodeTimer = CurTime() +  0.1
	
end


/*---------------------------------------------------------
   Name: PhysicsCollide
   Desc: Called when physics collides. The table contains 
			data on the collision
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )

	if ( !data.HitEntity:IsWorld() ) then return end
	
	// TODO! DON'T STICK TO SKY!
	
	physobj:EnableMotion( false )
	physobj:Sleep()
	
	self:StartTripmineMode( nil, data.HitNormal:GetNormal() * -1 )
	
end


function ENT:StartTripmineMode( hitpos, forward )
	
	self.Placed = true
	
	if (hitpos) then self.Entity:SetPos( hitpos ) end
	self.Entity:SetAngles( forward:Angle() + Angle( 90, 0, 0 ) )

	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos() + (forward * 4096)
		trace.mask = MASK_NPCWORLDSTATIC
		
	local tr = util.TraceLine( trace )
	
	local ent = ents.Create( "item_tripmine_laser" )
	
		// Offset the position of the laser slightly so it looks like it's coming out of the spout
		// This is a crude estimation. If you're using your own model you should use an attachment
	
		ent:SetPos( self.Entity:LocalToWorld( Vector( 0, -6, 1) ) )
		ent:Spawn()
		ent:Activate()
		ent:GetTable():SetEndPos( tr.HitPos )
		ent:GetTable():SetActiveTime( CurTime() + 2 )		
		ent:SetParent( self.Entity )
		ent:SetOwner( self.Entity )
		
	self.Laser = ent
	
	self.Entity:EmitSound( sndStick )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetNormal( forward )
		effectdata:SetMagnitude( 3 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 4 )
	util.Effect( "Sparks", effectdata )

end

function ENT:Explode()

	if ( self.Exploded ) then return end
	
	self.Exploded = true
	
	local Forward = self.Entity:GetAngles():Forward()

	// I don't like spawning an entity to make an explosion. It feels stupid.
	local ent = ents.Create( "env_explosion" )
	if ( ent && ent != NULL ) then
	
		ent:SetPos( self.Entity:GetPos() + Forward * 16 )
		ent:Spawn()
		ent:Activate()
		ent:SetOwner( self.Thrower )
		ent:SetKeyValue( "iMagnitude", "150" )
		ent:Fire( "Explode", 0, 0 )
		
	end
	
	// Just for good measure
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() + Forward * 16 )
	util.Effect( "Super_Explosion", effectdata, true, true )

	self.Entity:Remove()

end


/*---------------------------------------------------------
   Name: UpdateTransmitState
   Desc: Set the transmit state
---------------------------------------------------------*/
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

