#****************************************************************************
#**
#**  File     :  /data/units/XSL0201/XSL0201_script.lua
#**  Author(s):  Jessica St. Croix, Greg Kohne, Aaron Lundquist
#**
#**  Summary  :  Seraphim Medium Tank Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SConstructionUnit = import('/lua/seraphimunits.lua').SConstructionUnit
local SDFOhCannon = import('/lua/seraphimweapons.lua').SDFOhCannon

SSL0319 = Class(SConstructionUnit) {
    Weapons = {
        MainGun = Class(SDFOhCannon) {}
    },          
    OnStartBuild = function(self, unitBeingBuilt, order)
        --Disable the gun while building something
        self:SetWeaponEnabledByLabel('MainGun', false)
        SConstructionUnit.OnStartBuild(self, unitBeingBuilt, order)
    end,
    
    OnStopBuild = function(self)
        --Re-enable the gun after done building
        self:SetWeaponEnabledByLabel('MainGun', true)
        SConstructionUnit.OnStopBuild(self)
    end,
    
    OnStartReclaim = function(self, target)
        SConstructionUnit.OnStartReclaim(self, target)
        self:SetAllWeaponsEnabled(false)
    end,
    
    OnStopReclaim = function(self, target)
        SConstructionUnit.OnStopReclaim(self, target)
        self:SetAllWeaponsEnabled( true)
    end,
}
TypeClass = SSL0319
