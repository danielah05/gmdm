
include('shared.lua')

local matTripmineLaser 		= Material( "tripmine_laser" )
local matLight 				= Material( "sprites/gmdm_pickups/light" )
local colBeam				= Color( 100, 250, 245, 50 )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()		
end

function ENT:Think()

	if ( self:GetActiveTime() == 0 || self:GetActiveTime() > CurTime() ) then return end
	
	self.Entity:SetRenderBoundsWS( self:GetEndPos(), self.Entity:GetPos(), Vector(1, 1, 1)*8 )
	
end

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()

	if ( self:GetActiveTime() == 0 || self:GetActiveTime() > CurTime() ) then return end
	
	render.SetMaterial( matTripmineLaser )
	
	// offset the texture coords so it looks like it's scrolling
	local TexOffset = CurTime() * 3
	
	// Make the texture coords relative to distance so they're always a nice size
	local Distance = self:GetEndPos():Distance( self.Entity:GetPos() )
	
	
	// Draw the beam
	render.DrawBeam( self:GetEndPos(), self.Entity:GetPos(), 8, TexOffset, TexOffset+Distance/8, colBeam )
	render.DrawBeam( self:GetEndPos(), self.Entity:GetPos(), 4, TexOffset, TexOffset+Distance/8, colBeam )
	
	
	// Draw a quad at the hitpoint to fake the laser hitting it
	render.SetMaterial( matLight )
	local Size = math.Rand( 4, 8 )
	local Normal = (self.Entity:GetPos()-self:GetEndPos()):GetNormal() * 0.1
	render.DrawQuadEasy( self:GetEndPos() + Normal, Normal, Size, Size, colBeam, 0 )
	 
end
