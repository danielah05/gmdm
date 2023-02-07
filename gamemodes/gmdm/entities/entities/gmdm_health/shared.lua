ENT.Type = "anim"

/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:SetActiveTime( t )
	self.Entity:SetNWFloat( "activetime", t )
end

/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:GetActiveTime()
	return self.Entity:GetNWFloat( "activetime" )
end

function ENT:SetPickupType( name )
	self.Entity:SetNWInt( "pickuptype", name )
end

function ENT:GetPickupType()
	return self.Entity:GetNWInt( "pickuptype" )
end

function ENT:GetNiceName()
	return "" .. self:GetPickupType()
end
