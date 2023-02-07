
include('shared.lua')

surface.CreateFont( "GMDMPickup", {
	font = "coolvetica",
	size = 24,
	weight = 500,
	antialias = true,
	additive = false,
})

local rtName 		= GetRenderTarget( "gmdmname", 128, 32 )

local matLight 		= Material( "sprites/gmdm_pickups/light" )
local matCubeWall 	= Material( "sprites/gmdm_pickups/base_health" )
local matRefraction	= Material( "sprites/gmdm_pickups/base_r" )
local matStar		= Material( "sprites/gmdm_pickups/over_health" )
local matName		= Material( "sprites/gmdm_pickups/name" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()	

	self.Entity:SetCollisionBounds( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
	self.Entity:SetSolid( SOLID_NONE )
	
end


local FADETIME = 0.5

local function DrawBox( pos, size, rot, angrot )

	local Fwd = Vector( math.sin( rot ), math.cos( rot ), 0 )
	local Lft = Vector( math.sin( rot + math.pi/2 ), math.cos( rot + math.pi/2 ), 0 )
	
	render.DrawQuadEasy( pos - Fwd * size/2, Fwd, size, size, color_white, angrot )
	render.DrawQuadEasy( pos + Fwd * size/2, Fwd, size, size, color_white, angrot )
	render.DrawQuadEasy( pos - Lft * size/2, Lft, size, size, color_white, angrot )
	render.DrawQuadEasy( pos + Lft * size/2, Lft, size, size, color_white, angrot )
	
end


/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()

	if ( self:GetActiveTime() > CurTime() ) then return end
	
	
	// Render text to our texture
	// We could optimize this by having a texture for each item and only drawing it once
	// Also, note that it's additive.
	// I really wanted to get the alpha working - but it doesn't work with the drawtext methods I'm using in the engine.
	// The alpha from the vgui text draw blends with the alpha from the render target - so rendering to a 0 alpha texture
	// produces no output. Which sucks and I haven't found a way around it yet.
	
	--local OldRT = render.GetRenderTarget();
	render.PushRenderTarget( rtName )
	
		render.SetViewPort( 0, 0, 128, 32 )	
		render.Clear( 0, 0, 0, 255, true )
			
			cam.Start2D()
				draw.SimpleText( self:GetNiceName(), "GMDMPickup", 64, 0, color_white, TEXT_ALIGN_CENTER )
			cam.End2D()
			
		render.SetViewPort( 0, 0, ScrW(), ScrH() )
		
	render.PopRenderTarget()
	
	local Pos = self.Entity:GetPos() + Vector( 0, 0, 32 )
	
	// Distance from eye to pos
	local Distance = ( 1.0 - EyePos():Distance( Pos ) / 512 )
	
	// Bend the background *-1
	if ( Distance > 0 ) then
			
		// The refraction behind the box
		local RefractAmount = 0.00
		RefractAmount = RefractAmount + ( math.sin( CurTime() * 2 ) * 0.05 ) // Make the refraction bounce
		RefractAmount = RefractAmount *  Distance// Refract less the further away you are
		matRefraction:SetFloat( "$refractamount", RefractAmount * -1 )
		render.SetMaterial( matRefraction )
		render.UpdateScreenEffectTexture()
		render.DrawSprite( Pos, 180, 190 )
		
		render.SetMaterial( matLight )
		local size = 120
		render.DrawSprite( Pos, size, size, Color( 255, 255, 255, Distance * 255 ) )
		size = 70 + math.sin( CurTime() * 30 ) * 16
		render.DrawSprite( Pos, size, size, Color( 255, 255, 200, Distance * 255 ) )
		size = 60 + math.sin( CurTime() * 10 ) * 32
		render.DrawSprite( Pos, size, size, Color( 255, 255, 255, Distance * 255 ) )
		
	end
	
	
	
	// Draw the base of the box
	// Having 2 boxes here gives a cool looking inside of the box
	render.SetMaterial( matCubeWall )
	DrawBox( Pos, 30, CurTime(), 180 )
	DrawBox( Pos, 31, CurTime(), 180 )
	
	// Draw the 'Skin' on top of the box
	render.SetMaterial( matStar )
	DrawBox( Pos, 38 + math.sin( CurTime() * 20 ) * 5, CurTime(), 180 )
	
	render.SetMaterial( matName )	
	matName:SetTexture( "$basetexture", rtName )
	local rot = CurTime()
	local Fwd = Vector( math.sin( rot ), math.cos( rot ), 0 )
	local Lft = Vector( math.sin( rot + math.pi/2 ), math.cos( rot + math.pi/2 ), 0 )
	
	render.DrawQuadEasy( Vector(0,0,-11) + Pos - Fwd * 36/2, Fwd*-1, 32, 8, color_white, 180 )
	render.DrawQuadEasy( Vector(0,0,-11) + Pos + Fwd * 36/2, Fwd, 32, 8, color_white, 180 )
	render.DrawQuadEasy( Vector(0,0,-11) + Pos - Lft * 36/2, Lft*-1, 32, 8, color_white, 180 )
	render.DrawQuadEasy( Vector(0,0,-11) + Pos + Lft * 36/2, Lft, 32, 8, color_white, 180 )
	
					 
end
