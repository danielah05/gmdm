

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Player 	= data:GetEntity()
	local Normal 	= data:GetNormal()
	
	if ( Player == LocalPlayer() ) then
		LocalPlayer():BodyShot()
		LocalPlayer():OnTakeDamage( data:GetStart() )
	end
	
	Player:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 120, 100 )
	
	// Keep the start and end pos - we're going to interpolate between them
	local Pos = data:GetOrigin() + Normal * 8
	local Dist = Pos:Distance( EyePos() )
	
	local SizeMul = Dist / 1024
	
	local NumParticles = 0
	
	local emitter = ParticleEmitter( Pos )
	
		// Big fast splash
		local particle = emitter:Add( "effects/blood_core", Pos + Normal * 4 )
			particle:SetDieTime( 0.2 )
			particle:SetStartAlpha( 250 )
			particle:SetStartSize( 4 )
			particle:SetEndSize( math.Clamp( 255*SizeMul, 32, 255 )  )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetColor( 120, 0, 0 )
	
		local particle = emitter:Add( "effects/blood_core", Pos + Normal * 4 )
			particle:SetDieTime( 0.4 )
			particle:SetStartAlpha( 250 )
			particle:SetStartSize( 4 )
			particle:SetEndSize( math.Clamp( 255*SizeMul, 32, 255 ) )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetColor( 40, 0, 0 )
			
		local particle = emitter:Add( "effects/blood_core", Pos + Normal * 8 )
			particle:SetDieTime( 0.5 )
			particle:SetStartAlpha( 250 )
			particle:SetStartSize( 4 )
			particle:SetEndSize( 32 )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetColor( 130, 0, 0 )
					
		local particle = emitter:Add( "effects/blood_core", Pos + Normal * 6 )
			particle:SetDieTime( 0.5 )
			particle:SetStartAlpha( 250 )
			particle:SetStartSize( 32 )
			particle:SetEndSize( 4 )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetColor( 30, 0, 0 )
		
		// Persistent blood cloud
		local particle = emitter:Add( "particles/smokey", Pos )
			particle:SetDieTime( math.Rand( 10, 30 ) )
			particle:SetStartAlpha( 100 )
			particle:SetStartSize( math.Rand( 4, 8 ) )
			particle:SetEndSize( math.Rand( 32, 128 ) )
			particle:SetRollDelta( math.Rand( -0.2, 0.2 ) )
			particle:SetColor( 30, 0, 0 )
				
	emitter:Finish()
	
	
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



