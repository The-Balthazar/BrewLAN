local AConstructionUnit = import(import( '/lua/game.lua' ).BrewLANPath .. '/units/sal0319/sal0319_script.lua').SAL0319

SAL0119 = Class(AConstructionUnit) {
    OnCreate = function( self )
        AConstructionUnit.OnCreate(self)
        self:HideBone('Tube002', true)
        self:HideBone('Tube003', true)
    end,
}

TypeClass = SAL0119
