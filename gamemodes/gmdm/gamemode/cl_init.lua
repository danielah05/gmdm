

include( 'shared.lua' )
include( 'cl_postprocess.lua' )

function GM:Initialize( )	
	self.BaseClass:Initialize()
end


function GM:PostProcessPermitted( name )
	return false
end