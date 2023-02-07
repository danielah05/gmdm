ENT.Type = "anim"


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:SetEndPos( endpos )

	self.Entity:SetNWVector( "endpos", endpos )	
	self.Entity:SetCollisionBoundsWS( self.Entity:GetPos(), endpos, Vector() * 0.25 )
	
end


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:GetEndPos()
	return self.Entity:GetNWVector( "endpos" )
end


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:SetActiveTime( at )
	self.Entity:SetNWFloat( "activetime", at )
end


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:GetActiveTime()
	return self.Entity:GetNWFloat( "activetime" )
end
