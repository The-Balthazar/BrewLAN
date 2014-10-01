#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0309/UAL0309_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Unit Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
#
# AEON TECH 3 ENGINEER
#
local AConstructionUnit = import('/lua/aeonunits.lua').AConstructionUnit
SAL0319 = Class(AConstructionUnit) {
    
    ShieldEffects = {
        --'/effects/emitters/aeon_shield_generator_t2_01_emit.bp',
        --'/effects/emitters/aeon_shield_generator_t2_02_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',
        --'/effects/emitters/aeon_shield_generator_t3_04_emit.bp',
    },
    
    OnCreate = function( self ) 
        AConstructionUnit.OnCreate(self)
    end,

    OnStopBeingBuilt = function(self,builder,layer) 
        AConstructionUnit.OnStopBeingBuilt(self,builder,layer)
        for i = 1, 3 do
           CreateRotator(self, 'Tube00' .. i , 'x', nil, 0, 45, -45)
           CreateRotator(self, 'Tube00' .. i , 'y', nil, 0, 45, -45)
           CreateRotator(self, 'Tube00' .. i , 'z', nil, 0, 45, -45)
        end 
	     self.ShieldEffectsBag = {}
    end,  

    OnShieldEnabled = function(self)
        AConstructionUnit.OnShieldEnabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.25):OffsetEmitter(0,-.8,0) )
        end
    end,
   
    OnShieldDisabled = function(self)
        AConstructionUnit.OnShieldDisabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
    end,
}

TypeClass = SAL0319

