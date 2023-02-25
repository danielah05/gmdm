

include( 'shared.lua' )
include( 'cl_postprocess.lua' )

function GM:Initialize( )	
	self.BaseClass:Initialize()
end


function GM:PostProcessPermitted( name )
	return false
end

function GM:PlayerBindPress( ply, bind, pressed )
	-- switch weapons for whenever using whatever button you normally use for the spawn menu
	if (( bind == "+menu" ) && pressed ) then
		RunConsoleCommand( "lastinv" )
		return true
	end
end