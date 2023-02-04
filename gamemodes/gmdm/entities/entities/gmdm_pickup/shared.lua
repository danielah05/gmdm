ENT.Type = "anim"

local PickupTypes = {}

PickupTypes[0] = { name="gmdm_smg", 
					nicename="smg",
					ammogive="Pistol",
					ammoamount="128" }
					
PickupTypes[1] = { name="gmdm_flamethrower", 
					nicename="flamethrower",
					ammogive="SMG1",
					ammoamount="25" }
					
PickupTypes[2] = { name="gmdm_tripmine", 
					nicename="tripmine",
					customammo="tripmine",
					ammoamount=3 }

PickupTypes[3] = { name="gmdm_shotgun", 
					nicename="sh0tgun",
					ammogive="buckshot",
					ammoamount=32 }
					
PickupTypes[4] = { name="gmdm_egon", 
					nicename="egon",
					customammo="egonenergy",
					ammoamount=50 }
					
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

	for k, v in pairs(PickupTypes) do
	
		if ( v.name == name ) then
			self.Entity:SetNWInt( "pickuptype", k )
		return end
	
	end
	
	Msg("Warning: gm_pickup - unhandled pickup type "..name.."\n")
	self.Entity:SetNWInt( "pickuptype", 0 )

end


function ENT:GetPickupName()
	return PickupTypes[ self:GetPickupType() ].name
end

function ENT:GetPickupType()
	return self.Entity:GetNWInt( "pickuptype" )
end

function ENT:GetNiceName()
	return "" .. PickupTypes[ self:GetPickupType() ].nicename
end

function ENT:DoAmmoGive( ply )

	if ( PickupTypes[ self:GetPickupType() ].customammo ) then
		
		ply:AddCustomAmmo( PickupTypes[ self:GetPickupType() ].customammo, PickupTypes[ self:GetPickupType() ].ammoamount )
		return 
		
	end

	ply:GiveAmmo( PickupTypes[ self:GetPickupType() ].ammoamount, PickupTypes[ self:GetPickupType() ].ammogive )
	
end


