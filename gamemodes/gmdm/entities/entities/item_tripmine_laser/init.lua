
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local sndOnline = Sound( "hl1/fvox/activated.wav" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:DrawShadow( false )
	self.Entity:SetSolid( SOLID_BBOX )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:SetTrigger( true )
	
end

function ENT:Think()

	if ( self:GetActiveTime() == 0 || self:GetActiveTime() > CurTime() ) then return end
	if ( self.Activated ) then return end
	
	self.Activated = true
	self.Entity:GetOwner():EmitSound( sndOnline )

end


function ENT:Touch( entity )

	if ( self:GetActiveTime() == 0 || self:GetActiveTime() > CurTime() ) then return end

	// Is the laser touching?
	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self:GetEndPos()
		trace.filter = { self.Entity, self.Entity:GetOwner() }
		
	local tr = util.TraceLine( trace )
	
	if (!tr.Hit) then return end

	self.Entity:GetOwner():GetTable():Explode()

end

