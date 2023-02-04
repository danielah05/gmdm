AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("ply_extension.lua")
AddCSLuaFile("cl_postprocess.lua")

include("shared.lua")

function GM:Initialize( )

	self.BaseClass:Initialize( )

end

function GM:InitPostEntity( )

end

function GM:PlayerInitialSpawn( pl )

	self.BaseClass:PlayerInitialSpawn( pl )

end

function GM:PlayerSpawn( pl )

	self.BaseClass:PlayerSpawn( pl )
	pl:GMDM_Extinguish()
	
	// Make the jump height a bit higher
	pl:SetGravity( 0.75 )
	
	// Set the player's speed
	GAMEMODE:SetPlayerSpeed( pl, 500, 200 )
	
	// Enable Flashlight
	pl:AllowFlashlight( true )

end

function GM:PlayerSetModel(ply)
	ply:SetModel("models/player/kleiner.mdl")
end

function GM:DoPlayerDeath( pl, attacker, dmginfo )

	MsgAll( "Killer Damage: "..dmginfo:GetDamage().."\n")
	MsgAll( "Was Explosion?: "..tostring(dmginfo:IsExplosionDamage()).."\n")
	MsgAll( "Was Bullet?: "..tostring(dmginfo:IsBulletDamage()).."\n\n")

	if ( pl:GetFireTime() > 0 ) then
		
		pl:GMDM_Extinguish()
		pl:DoFireDeath( attacker )
		
	elseif ( dmginfo:GetDamage() > 20 ) then
	
		pl:Gib( dmginfo )
		
	else
		
		pl:CreateRagdoll()
		
	end
	
	pl:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == pl ) then
			attacker:AddFrags( -1 )
		else
			pl:DropSouls()
			attacker:AddSouls( 1 )
			attacker:AddFrags( 1 )
		end
		
	end
	
	
	
	// Drop fire on the floor if we were on fire?
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerLoadout( )
   Desc: Give the player the default spawning weapons/ammo
---------------------------------------------------------*/
function GM:PlayerLoadout( pl )

	pl:GiveAmmo( 54,	"Pistol",		true )
	pl:GiveAmmo( 8, 	"buckshot", 	true )
	
	pl:Give( "gmdm_pistol" )
	pl:Give( "weapon_crowbar" )
	
	pl:SelectWeapon( "gmdm_pistol" ) 

	
	pl:SetCustomAmmo( "tripmine", 0 )
	pl:SetCustomAmmo( "egonenergy", 0 )

end