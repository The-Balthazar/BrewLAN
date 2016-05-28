#****************************************************************************
#**
#**  Summary  :  Aeon Defence Engineer Unit Script
#**
#****************************************************************************

local AConstructionUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/units/sal0319/sal0319_script.lua').SAL0319

SAL0209 = Class(AConstructionUnit) { 
    OnCreate = function( self ) 
        AConstructionUnit.OnCreate(self)
        self:HideBone('Tube003', true)
    end,
}

TypeClass = SAL0209

