
include('shared.lua')



function SWEP:CustomAmmoDisplay()

	self.AmmoDisplay = self.AmmoDisplay or {}
	
	self.AmmoDisplay.Draw = true
	
	self.AmmoDisplay.PrimaryClip 	= self.Owner:GetCustomAmmo( "tripmine" )
	self.AmmoDisplay.PrimaryAmmo 	= -1
	self.AmmoDisplay.SecondaryAmmo 	= -1
	
	return self.AmmoDisplay

end
