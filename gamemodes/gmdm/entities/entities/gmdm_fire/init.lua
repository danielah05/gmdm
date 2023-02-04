
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

// Global to track the number of active fires
NUM_FIRES 		= 0
MAX_NUM_FIRES 	= 128

function ENT:RemoveMe()

	if (!self) then return end
	if (self == NULL) then return end

	self:Remove()

end


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self:SetMoveType( MOVETYPE_NONE )
	self:DrawShadow( false )

	// Make the bbox short so we can jump over it
	// Note that we need a physics object to make it call triggers
	self:SetCollisionBounds( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
	self:PhysicsInitBox( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableCollisions( false )		
	end
	
	local Time = math.Rand( 9, 10 )
	timer.Simple( Time, function() self:RemoveMe() end )
	
	self:SetNetworkedFloat( 0, CurTime() + Time )
	
	NUM_FIRES = NUM_FIRES + 1
	
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetTrigger( true )
	self:SetNotSolid( true )
	
end

/*---------------------------------------------------------
   Name: OnRemove
---------------------------------------------------------*/
function ENT:OnRemove()
	NUM_FIRES = NUM_FIRES - 1
end


/*---------------------------------------------------------
   Name: Touch
---------------------------------------------------------*/
function ENT:Touch( entity )

	if (!entity:IsPlayer()) then return end
	
	entity:GMDM_Ignite( self:GetOwner() )

end

include('shared.lua')