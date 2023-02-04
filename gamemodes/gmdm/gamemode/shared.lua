include('ply_extension.lua')

GM.Name = "gmod deathmatch"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

local WalkTimer = 0
local VelSmooth = 0

// Global holding all our human gibs!
HumanGibs = {}

	table.insert(HumanGibs, "models/gibs/antlion_gib_medium_2.mdl")
	table.insert(HumanGibs, "models/gibs/Antlion_gib_Large_1.mdl")
	//table.insert(HumanGibs, "models/gibs/gunship_gibs_eye.mdl")
	table.insert(HumanGibs, "models/gibs/Strider_Gib4.mdl")
	table.insert(HumanGibs, "models/gibs/HGIBS.mdl")
	table.insert(HumanGibs, "models/gibs/HGIBS_rib.mdl")
	table.insert(HumanGibs, "models/gibs/HGIBS_scapula.mdl")
	table.insert(HumanGibs, "models/gibs/HGIBS_spine.mdl")


	for k, v in pairs(HumanGibs) do
		util.PrecacheModel(v)
	end

function GM:PlayerShouldTakeDamage(ply, attacker)
	return true
end

function GM:CalcView( ply, origin, angle, fov )

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	VelSmooth = VelSmooth * 0.9 + vel:Length() * 0.1
	
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05
	
	// Roll on strafe
	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.01
	

	// Roll on steps
	if ( ply:GetGroundEntity() != NULL ) then	
	
		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
		angle.pitch = angle.pitch + math.sin( WalkTimer * 0.5 ) * VelSmooth * 0.001
		
	end
	
	angle = angle + ply:HeadshotAngles()
		
	return self.BaseClass:CalcView( ply, origin, angle, fov )

end

function GM:SetupMove( ply, mv )

	return false

end

function GM:Move( ply, mv )

	return false

end


function GM:PlayerTraceAttack( ply, dmginfo, dir, trace )

	ply:TraceAttack( ply, dmginfo, dir, trace )
	return false
	
end


function GM:Think( )

	local PlayerList = player.GetAll()
	for  k, pl in pairs(PlayerList) do
		pl:Think()
	end

end