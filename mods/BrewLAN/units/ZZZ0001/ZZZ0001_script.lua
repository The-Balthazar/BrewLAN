#****************************************************************************
#**
#**  Author(s):  Sean Wheeldon
#**
#**  Summary  :  Damage test unit
#**
#**  Copyright © 2010 BrewLAN.  All rights reserved.
#****************************************************************************

local AShieldStructureUnit = import('/lua/aeonunits.lua').AShieldStructureUnit

ZZZ0001 = Class(AShieldStructureUnit) {

	OnCreate = function(self)
		AShieldStructureUnit.OnCreate(self)
		LOG("POS: " .. self:GetPosition()[1] .. ", " .. self:GetPosition()[2] .. ", " .. self:GetPosition()[3])
	end,    

}

TypeClass = ZZZ0001

