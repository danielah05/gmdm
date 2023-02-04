
/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:GMDMShootBullet( dmg, snd, pitch, yaw, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	self.Weapon:EmitSound( snd )
	self:GMDMShootBulletEx( dmg, numbul, cone, 1 )
	self.Owner:Recoil( pitch, yaw )
	
	// Make gunsmoke
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetShootPos() )
		effectdata:SetEntity( self.Weapon )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetNormal( self.Owner:GetAimVector() )
		effectdata:SetAttachment( 1 )
	util.Effect( "gunsmoke", effectdata )

end

/*---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
---------------------------------------------------------*/
function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
end


/*---------------------------------------------------------
   Name: SWEP:Think( )
   Desc: Called every frame
---------------------------------------------------------*/
function SWEP:Think()
end


/*---------------------------------------------------------
   Name: SWEP:Holster( weapon_to_swap_to )
   Desc: Weapon wants to holster
   RetV: Return true to allow the weapon to holster
---------------------------------------------------------*/
function SWEP:Holster( wep )
	return true
end

/*---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
---------------------------------------------------------*/
function SWEP:Deploy()
	return true
end

local function RicochetCallback( bouncenum, attacker, tr, dmginfo )

	local DoDefaultEffect = false;
	if ( !tr.HitWorld ) then DoDefaultEffect = true end
	
	if ( tr.MatType != MAT_METAL ) then

		 if ( !tr.HitSky && tr.MatType != MAT_FLESH ) then
		 
			local effectdata = EffectData()
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "hitsmoke", effectdata, true )
			
		end

	return end
	
	if ( CLIENT ) then return end
	if ( bouncenum > 5 ) then return end
	
	
	local DotProduct = tr.HitNormal:Dot( tr.Normal * -1 )
	local bullet = 
	{	
		Num 		= 1,
		Src 		= tr.HitPos,
		Dir 		= ( 2 * tr.HitNormal * DotProduct ) + tr.Normal,	// Bounce vector (Don't worry - I don't understand the maths either :x)
		Spread 		= Vector( 0.05, 0.05, 0 ),
		Tracer		= 1,
		TracerName 	= "rico_trace",
		Force		= 5,
		Damage		= damage,
		AmmoType 	= "Pistol" 
	}
		
	// Continue bouncing on the server only
	if (SERVER) then
		bullet.Callback    = function( a, b, c ) RicochetCallback( bouncenum+1, a, b, c ) end
	end
	
	timer.Simple( 0.05 + 0.03 * bouncenum, function() attacker.FireBullets(attacker, bullet) end )

		
			
	// If you don't want to do default damage or 
	// effects you can return false here
	return { damage = true, effects = DoDefaultEffect }
		
end


/*---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:GMDMShootBulletEx( damage, num_bullets, aimcone, tracerfreq )
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )		// Aim Cone
	bullet.Tracer	= tracerfreq						// Show a tracer on every x bullets 
	bullet.Force	= 10								// Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback    = function ( a, b, c ) RicochetCallback( 0, a, b, c ) end
	
	self.Owner:FireBullets( bullet )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()							// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )			// 3rd Person Animation
	
end

