#****************************************************************************
#**
#**  File     :  /cdimage/units/URB2301/URB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CDFHeavyMicrowaveLaserGeneratorCom = CybranWeaponsFile.CDFHeavyMicrowaveLaserGeneratorCom

SRB2306 = Class(CStructureUnit) {
    Weapons = {
        MainGun = Class(CDFHeavyMicrowaveLaserGeneratorCom) {

	    IdleState = State(CDFHeavyMicrowaveLaserGeneratorCom.IdleState) {
	        Main = function(self)
	            if self.RotatorManip then
	                self.RotatorManip:SetSpeed(0)
	            end
	            if self.SliderManip then
	                self.SliderManip:SetGoal(0,0,0)
	                self.SliderManip:SetSpeed(2)
	            end
	            CDFHeavyMicrowaveLaserGeneratorCom.IdleState.Main(self)
	        end,
	    },

	    CreateProjectileAtMuzzle = function(self, muzzle)
	        if not self.SliderManip then
	            self.SliderManip = CreateSlider(self.unit, 'Center_Turret_Barrel')
	            self.unit.Trash:Add(self.SliderManip)
	        end
	        if not self.RotatorManip then
	            self.RotatorManip = CreateRotator(self.unit, 'Center_Turret_Barrel', 'z')
	            self.unit.Trash:Add(self.RotatorManip)
	        end
	        self.RotatorManip:SetSpeed(180)
	        self.SliderManip:SetPrecedence(11)
	        self.SliderManip:SetGoal(0, 0, -1)
	        self.SliderManip:SetSpeed(-1)
	        CDFHeavyMicrowaveLaserGeneratorCom.CreateProjectileAtMuzzle(self, muzzle)
	    end,
	},
    },
}

TypeClass = SRB2306