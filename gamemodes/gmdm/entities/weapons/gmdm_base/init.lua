
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local ActIndex = {}
ActIndex[ "pistol" ] 	= ACT_HL2MP_IDLE_PISTOL
ActIndex[ "smg" ] 		= ACT_HL2MP_IDLE_SMG1
ActIndex[ "grenade" ] 	= ACT_HL2MP_IDLE_GRENADE

/*---------------------------------------------------------
   Name: weapon:TranslateActivity( )
   Desc: Translate a player's Activity into a weapon's activity
		 So for example, ACT_HL2MP_RUN becomes ACT_HL2MP_RUN_PISTOL
		 Depending on how you want the player to be holding the weapon
---------------------------------------------------------*/
function SWEP:TranslateActivity( act )

	if ( self.ActivityTranslate[ act ] != nil ) then
		return self.ActivityTranslate[ act ]
	end
	
	return -1

end

/*---------------------------------------------------------
   Name: OnRestore
   Desc: The game has just been reloaded. This is usually the right place
		to call the GetNetworked* functions to restore the script's values.
---------------------------------------------------------*/
function SWEP:OnRestore()
end


/*---------------------------------------------------------
   Name: AcceptInput
   Desc: Accepts input, return true to override/accept input
---------------------------------------------------------*/
function SWEP:AcceptInput( name, activator, caller )
	return false
end


/*---------------------------------------------------------
   Name: KeyValue
   Desc: Called when a keyvalue is added to us
---------------------------------------------------------*/
function SWEP:KeyValue( key, value )
end


/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function SWEP:OnRemove()
end

