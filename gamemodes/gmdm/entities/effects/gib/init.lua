

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	// HumanGibs is defined in gamemode shared 
	// (because we need to precache the models on the server before we can use the physics)
	local iCount = table.Count( HumanGibs )
	
	
	self.Entity:SetModel( HumanGibs[ math.random( iCount ) ] )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMaterial( "models/flesh" )
	
	// Only collide with world/static
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	if ( phys && phys:IsValid() ) then
	
		phys:Wake()
		phys:SetAngles( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
		phys:SetVelocity( data:GetNormal() * math.Rand( 100, 300 ) + VectorRand() * math.Rand( 10, 100 ) )
	
	end
	
	self.LifeTime = CurTime() + math.Rand( 10, 20 )
	
	
	local emitter = ParticleEmitter( data:GetOrigin() )
	
		local particle = emitter:Add( "effects/blood_core", data:GetOrigin() )
			particle:SetVelocity( data:GetNormal() * math.Rand( 5, 20 ) )
			particle:SetDieTime( math.Rand( 1.0, 2.0 ) )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.Rand( 8, 32 ) )
			particle:SetEndSize( math.Rand( 48, 64 ) )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetColor( 40, 0, 0 )
				
	emitter:Finish()
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	return ( self.LifeTime > CurTime() ) 
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	self.Entity:DrawModel()

end



