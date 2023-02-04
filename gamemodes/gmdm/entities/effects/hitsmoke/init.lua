

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
	local Norm = data:GetNormal()
	
	local SurfaceColor = render.GetSurfaceColor( Pos+Norm, Pos-Norm*100 ) * 255
	
	SurfaceColor.r = math.Clamp( SurfaceColor.r+40, 0, 255 )
	SurfaceColor.g = math.Clamp( SurfaceColor.g+40, 0, 255 )
	SurfaceColor.b = math.Clamp( SurfaceColor.b+40, 0, 255 )
		
	local emitter = ParticleEmitter( Pos )
	
		local particle = emitter:Add( "particles/smokey", Pos + Norm * 16 )
			particle:SetVelocity( Norm * math.Rand( 1, 5 ) )
			particle:SetDieTime( math.Rand( 15, 60 ) )
			particle:SetStartAlpha( math.Rand( 50, 150 ) )
			particle:SetStartSize( math.Rand( 16, 32 ) )
			particle:SetEndSize( math.Rand( 128, 512 ) )
			particle:SetRoll( 0 )
			particle:SetColor( SurfaceColor.r, SurfaceColor.g, SurfaceColor.b )

		local particle = emitter:Add( "particles/smokey", Pos + Norm * 32 )
			particle:SetVelocity( Norm * 100 )
			particle:SetDieTime( 0.4 )
			particle:SetStartAlpha( 200 )
			particle:SetStartSize( 32 )
			particle:SetEndSize( math.Rand( 50, 140 ) )
			particle:SetRoll( 0 )
			particle:SetColor( SurfaceColor.r, SurfaceColor.g, SurfaceColor.b )
				
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



