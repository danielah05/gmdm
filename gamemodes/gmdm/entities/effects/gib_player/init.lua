

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.Player = data:GetEntity()
	
	// Play headshot sound(s)
	if ( self.Player != NULL ) then
		// I frigging love this sound
		self.Player:EmitSound( "physics/flesh/flesh_bloody_break.wav" )
	end
	
	
	// Make Bloodstream effects
	for i= 0, 16 do
	
		local effectdata = EffectData()
			effectdata:SetOrigin( self.Player:GetPos() + i * Vector(0,0,4) )
			effectdata:SetNormal( data:GetNormal() )
		util.Effect( "bloodstream", effectdata )
		
	end
	
	for i = 0, 16 do
	
		local effectdata = EffectData()
			effectdata:SetOrigin( self.Player:GetPos() + i * Vector(0,0,4) + VectorRand() * 8 )
			effectdata:SetNormal( data:GetNormal() )
		util.Effect( "gib", effectdata )
		
	end
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	// Die instantly
	return false
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	// Do nothing - this effect is only used to spawn the particles in Init
	
end



