ENT.Type = "anim"

function ENT:SetPlayerVelocity( name )
	self.Entity:SetNWInt( "playervelocity", name )
end

function ENT:GetPlayerVelocity()
	return self.Entity:GetNWInt( "playervelocity" )
end