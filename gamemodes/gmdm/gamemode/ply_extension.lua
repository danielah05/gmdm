
local meta = FindMetaTable("Player")
if (!meta) then return end 

function meta:GetVar( name, default )

	local Val = self:GetTable()[ name ]
	if ( Val == nil ) then return default end
	
	return Val
	
end

function meta:SetVar( name, value )
	self:GetTable()[ name ] = value
end

// Player should be on fire for the next x seconds
function meta:SetFireTime( add )
	self:SetNetworkedFloat( 0, CurTime() + add )
end

// Returns the amount of seconds left being on fire
function meta:GetFireTime( add )
	return (self:GetNetworkedFloat( 0 ) - CurTime() )
end

function meta:Recoil(pitch, yaw)

	// People shouldn't really be playing in SP
	// But if they are they won't get recoil because the weapons aren't predicted
	// So the clientside stuff never fires the recoil
	if (SERVER && game.SinglePlayer()) then 
	
		// Please don't call SendLua in multiplayer games. This uses a lot of bandwidth
		self:SendLua("LocalPlayer():Recoil("..pitch..","..yaw..")")
		return 
		
	end
	
	self:GetTable().RecoilYaw = self:GetTable().RecoilYaw or 0
	self:GetTable().RecoilPitch = self:GetTable().RecoilPitch or 0
	
	self:GetTable().RecoilYaw = self:GetTable().RecoilYaw 		+ yaw
	self:GetTable().RecoilPitch = self:GetTable().RecoilPitch 	+ pitch

end

// Your head spazzes out when you get headshotted - CS style

function meta:HeadshotAngles()

	self:GetTable().HeadShotStart = self:GetTable().HeadShotStart or 0
	self:GetTable().HeadShotRoll = self:GetTable().HeadShotRoll or 0
	
	self:GetTable().HeadShotRoll = math.Approach( self:GetTable().HeadShotRoll, 0.0, 40.0 * FrameTime() )
	local roll = self:GetTable().HeadShotRoll
	
	local Time = (CurTime() - self:GetTable().HeadShotStart) * 10
	
	return Angle( math.sin( Time ) * roll * 0.5, 0, math.sin( Time * 2 ) * roll * -1 )

end

function meta:HeadShot()

	self:GetTable().HeadShotRoll = 45
	self:GetTable().HeadShotStart = CurTime()
	
	MotionBlur = 0.85
	ColorModify[ "$pp_colour_colour" ] = 0
	ColorModify[ "$pp_colour_addr" ] = 1
//	ColorModify[ "$pp_colour_mulr" ] = 2
	Sharpen = 3

end

function meta:BodyShot()

	self:GetTable().HeadShotRoll = math.Clamp( self:GetTable().HeadShotRoll + 10, 0, 45 )
	self:GetTable().HeadShotStart = CurTime()
	
	Sharpen = 2
	ColorModify[ "$pp_colour_addr" ] = math.Clamp( ColorModify[ "$pp_colour_addr" ] + 0.5, 0, 1 )

end

function meta:AddRecoil( pitch, yaw )

	if ( SERVER ) then return end
	if ( self != LocalPlayer() ) then return end
	
	local pitch 	= self:GetTable().RecoilPitch	or 0
	local yaw 		= self:GetTable().RecoilYaw  	or 0
	
	local pitch_d	= math.Approach( pitch, 0.0, 20.0 * FrameTime() * math.abs(pitch) )
	local yaw_d		= math.Approach( yaw, 0.0, 20.0 * FrameTime() * math.abs(yaw) )
	
	self:GetTable().RecoilPitch 	= pitch_d
	self:GetTable().RecoilYaw 		= yaw_d
		
	// Update eye angles
	local eyes = self:EyeAngles()
		eyes.pitch = eyes.pitch + ( pitch - pitch_d )
		eyes.yaw = eyes.yaw + ( yaw - yaw_d )
		eyes.roll = 0
	self:SetEyeAngles( eyes )

end

function meta:Think( )

	// We spread the recoil out over a few frames to make it less of a shock
	// This function adds the recoil
	self:AddRecoil()

	// We don't use HL2's default on fire stuff, we do it ourselves because
	// we're so awesome.
	self:DoOnFire()

end


function meta:TraceAttack( ply, dmginfo, dir, trace )

	if ( trace.HitGroup == HITGROUP_HEAD ) then
	
		local effectdata = EffectData()
			effectdata:SetEntity( self )
			effectdata:SetOrigin( trace.HitPos )
			effectdata:SetNormal( dir )
		util.Effect( "headshot", effectdata )
		return
		
	end
	
	local effectdata = EffectData()
		effectdata:SetEntity( self )
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
	util.Effect( "bodyshot", effectdata )

end

function meta:OnTakeDamage( vec )
	// Possibly indicate the attack direction	
end

function meta:TraceLine( distance )

	local vStart = self:GetShootPos()
	local vForward = self:GetAimVector()

	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + (vForward * distance)
	trace.filter = self
		
	return util.TraceLine( trace )

end


function meta:GMDM_Extinguish()

	self:SetFireTime( -1 )
	self:SetVar( "FireAttacker", NULL )

end


function meta:GMDM_Ignite( attacker )

	self:SetFireTime( 5 )
	self:SetVar( "FireAttacker", attacker )

end


function meta:DoOnFire()

	local OnFire = self:GetVar( "OnFire", false )

	if ( self:GetFireTime() <= 0 ) then
		if (OnFire) then
		
			self:SetVar( "OnFire", false )
			self:SetMaterial( "" )
			
		end
	return end
	
	
	if (!OnFire) then
		self:SetVar( "OnFire", true )
		self:SetMaterial( "models/onfire" )
	end
	
	
	// Do server effects (take damage)
	if (SERVER && self:GetVar( "LastFire", 0 ) < CurTime()) then
	
		self:SetVar( "LastFire", CurTime() + 0.1 )
		self:TakeDamage( 1, self:GetVar( "FireAttacker", NULL ), self:GetVar( "FireAttacker", NULL ) )
		
	end
	
	// Do clientside effects (move the view and spawn particles)
	if (CLIENT && self:GetVar( "LastFire", 0 ) < CurTime()) then
	
		if (self == LocalPlayer()) then
			self:Recoil( math.Rand( -3, 3 ), math.Rand( -15, 15 ) )
		end
	
		self:SetVar( "LastFire", CurTime() + 0.02 )
		local Velocity 	= Vector( 0, 0, 1 )
		local emitter = ParticleEmitter( self:GetPos() )
		
		for i=0, 8 do
		
			local Pos = self:GetPos() + self:OBBMaxs() * math.Rand(0,1) + self:OBBMins() * math.Rand(0,1)
			
			// If we're the local player then put the flames in front of the view more
			if ( self == LocalPlayer() ) then
				Pos = Pos + self:GetAngles():Forward() * 16
			end
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos )

				particle:SetVelocity( Velocity * math.Rand( 10, 200 ) )
				particle:SetDieTime( math.Rand( 0.1, 0.2 ) )
				particle:SetStartAlpha( math.Rand( 150, 250 ) )
				particle:SetStartSize( math.Rand( 8, 16 ) )
				particle:SetEndSize( math.Rand( 16, 32 ) )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
				particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
			
		end
				
		emitter:Finish()
	
	end
	

end


function meta:DoFireDeath( attacker )

	local trace = {}
		trace.start = self:GetPos()
		trace.endpos = self:GetPos() + Vector( 0, 0, -1 )
		trace.filter = self
	local tr =  util.TraceLine( trace )
	
	
	if ( tr.Hit ) then
	
		// Only lay fire on flat(ish) ground
		if ( Vector( 0, 0, 1 ):Dot( tr.HitNormal ) > 0.25 ) then
	
			local fire = ents.Create( "gmdm_fire" )
				fire:SetPos( tr.HitPos + tr.HitNormal * 32 )
				fire:SetAngles( tr.HitNormal:Angle() )
				fire:SetOwner( attacker )
				fire:Spawn()
				fire:Activate()
				
		end
	
	end
	

	self:CreateRagdoll()
/*
	local effectdata = EffectData()
		effectdata:SetEntity( self )
	util.Effect( "fire_death", effectdata )
	*/
end


function meta:Gib( dmginfo )

	local effectdata = EffectData()
		effectdata:SetEntity( self )
		effectdata:SetNormal( dmginfo:GetDamageForce() )
	util.Effect( "gib_player", effectdata )

end



function meta:GetSouls()
	return self:GetVar( "souls", 1 )
end

function meta:SetSouls( num )
	return self:SetVar( "souls", num )
end

function meta:AddSouls( num )
	return self:SetSouls( self:GetSouls() + num )
end

function meta:DropSouls()
	
	// Don't spawn any more than 64 souls
	local num = math.Clamp( self:GetSouls(), 1, 64 )
			
	for i=1, num do
	
		local soul = ents.Create( "gmdm_soul" )
		if ( soul && soul != NULL ) then
			soul:SetPos( self:GetPos() + Vector(0,0,48) * math.Rand(0.3, 1.0 ) )
			soul:Spawn()
			soul:Activate()
			
			local Vel = VectorRand() * 700
			Vel.z = math.abs( Vel.z )
			
			soul:GetPhysicsObject():SetVelocity( Vel )
		end
		
	end
	

	self:SetSouls( 1 )

end


function meta:GetCustomAmmo( name )
	return self:GetNWInt( "ammo_" .. name )
end

function meta:SetCustomAmmo( name, num )
	return self:SetNWInt( "ammo_" .. name, num )
end

function meta:AddCustomAmmo( name, num )
	return self:SetCustomAmmo( name, self:GetCustomAmmo( name ) + num )
end
