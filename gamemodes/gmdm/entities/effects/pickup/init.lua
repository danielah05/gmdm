

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )

	// Keep the start and end pos - we're going to interpolate between them
	local NumParticles = 0
	local Pos = data:GetOrigin() + Vector(0,0,32)
	
	local Velocity = Vector(0,0,0)
	
	local ent = data:GetEntity()
	if ( ent != NULL ) then
	
		Velocity = ent:GetVelocity()
		
		if ( ent == LocalPlayer() ) then
			Velocity = Velocity * 4
			ColorModify[ "$pp_colour_addr" ] = ColorModify[ "$pp_colour_addr" ] + 0.4
			ColorModify[ "$pp_colour_addg" ] = ColorModify[ "$pp_colour_addg" ] + 0.4
		end
		
		ent:EmitSound( "npc/roller/mine/rmine_chirp_quest1.wav", 120 )
		ent:EmitSound( "npc/roller/mine/rmine_chirp_quest1.wav", 120 )
		
	end

	local emitter = ParticleEmitter( Pos )
	
		for i= 0, 16 do
		
			local particle = emitter:Add( "sprites/gmdm_pickups/light", Pos + VectorRand()*16 )
				particle:SetVelocity( (Velocity + VectorRand()*20) * math.Rand( 0.001, 0.2 ) )
				particle:SetDieTime( math.Rand( 2, 5 ) )
				particle:SetStartAlpha( 250 )
				particle:SetEndAlpha( 250 )
				particle:SetStartSize( 32 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -5.5, 5.5 ) )
				particle:SetColor( 255, 255, 255 )
				
		end
				
	emitter:Finish()
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()	
end



