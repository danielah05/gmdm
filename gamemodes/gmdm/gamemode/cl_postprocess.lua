
local matBlurEdges		= Material( "bluredges" )
local tex_MotionBlur	= render.GetMoBlurTex0()

MotionBlur = 0.0
ColorModify = {}
ColorModify[ "$pp_colour_addr" ] 		= 0
ColorModify[ "$pp_colour_addg" ] 		= 0
ColorModify[ "$pp_colour_addb" ] 		= 0
ColorModify[ "$pp_colour_brightness" ] 	= -0.03
ColorModify[ "$pp_colour_contrast" ] 	= 1.2
ColorModify[ "$pp_colour_colour" ] 		= 1
ColorModify[ "$pp_colour_mulr" ] 		= 0
ColorModify[ "$pp_colour_mulg" ] 		= 1
ColorModify[ "$pp_colour_mulb" ] 		= 1

Sharpen = 0

local function DrawInternal()

	if (MotionBlur > 0) then
		DrawMotionBlur( 1 - MotionBlur, 1.0, 0.0 )
		MotionBlur = MotionBlur - 0.3 * FrameTime()
	end
	
	ColorModify[ "$pp_colour_mulr" ] 	= math.Approach( ColorModify[ "$pp_colour_mulr" ], 0, FrameTime() * 1 )
	ColorModify[ "$pp_colour_mulg" ]	= math.Approach( ColorModify[ "$pp_colour_mulg" ], 0, FrameTime() * 1 )
	ColorModify[ "$pp_colour_mulb" ] 	= math.Approach( ColorModify[ "$pp_colour_mulb" ], 0, FrameTime() * 1 )
	ColorModify[ "$pp_colour_colour" ] 	= math.Approach( ColorModify[ "$pp_colour_colour" ], 1, FrameTime() * 1 )
	ColorModify[ "$pp_colour_addr" ] 	= math.Approach( ColorModify[ "$pp_colour_addr" ], 0.00, FrameTime() * 1 )
	ColorModify[ "$pp_colour_addg" ] 	= math.Approach( ColorModify[ "$pp_colour_addg" ], 0.01, FrameTime() * 1 )
	ColorModify[ "$pp_colour_addb" ] 	= math.Approach( ColorModify[ "$pp_colour_addb" ], 0.00, FrameTime() * 1 )
	
	DrawColorModify( ColorModify )
	
	if ( Sharpen > 0 ) then
	
		DrawSharpen( Sharpen, 0.5 )
		Sharpen = math.Approach( Sharpen, 0, FrameTime() * 0.5 )
		
	end
	
	
	//DrawBloom( 0.1, 0.3, 4, 4, 1, 1, 1, 1, 1 )
	
	// This looping ain't no good. Need to make my own blur shader
	//;matBlurEdges:SetMaterialFloat( "$refractamount", math.sin( CurTime() * 2 ) * 0.5 )
	render.SetMaterial( matBlurEdges )	
//	for i=1, 2 do
		render.UpdateScreenEffectTexture()
		render.DrawScreenQuad()
//	end

end

hook.Add( "RenderScreenspaceEffects", "GMDMPostProcess", DrawInternal )