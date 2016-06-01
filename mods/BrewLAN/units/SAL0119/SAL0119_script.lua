#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0105/UAL0105_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon T1 Engineer Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AConstructionUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/units/sal0319/sal0319_script.lua').SAL0319

SAL0119 = Class(AConstructionUnit) { 
    OnCreate = function( self ) 
        AConstructionUnit.OnCreate(self)
        self:HideBone('Tube002', true)
        self:HideBone('Tube003', true)
    end,
}

TypeClass = SAL0119
