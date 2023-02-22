
include('shared.lua')

local matLight 		= Material( "sprites/magic" )

function ENT:Initialize()	

	self.Entity:SetCollisionBounds( Vector( -50, -50, -50 ), Vector( 50, 50, 5 ) )
	self.Entity:SetSolid( SOLID_NONE )
	
end

function ENT:Draw()
	self.Entity:DrawModel()
	render.SetMaterial( matLight )
	local Pos 		= self.Entity:GetPos() + Vector( 0, 0, 40 )
	local Size 		= 128 + math.sin( CurTime() * 10) * 8
	render.DrawSprite( Pos, Size, Size, Color( 0, 200, 200, 90 ) )
end