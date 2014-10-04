#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB1301/UAB1301_script.lua
#**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Power Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local AEnergyCreationUnit = import('/lua/aeonunits.lua').AEnergyCreationUnit

SAB1311 = Class(AEnergyCreationUnit) {
    AmbientEffects = 'AT3PowerAmbient',
      
    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',
        --'/effects/emitters/aeon_shield_generator_t2_02_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_04_emit.bp',
    },
    
    OnStopBeingBuilt = function(self, builder, layer)
        AEnergyCreationUnit.OnStopBeingBuilt(self, builder, layer)
        self.Trash:Add(CreateRotator(self, 'Sphere', 'x', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere', 'y', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere', 'z', nil, 0, 15, 80 + Random(0, 20)))     
	     self.ShieldEffectsBag = {}
    end,
    
    OnShieldEnabled = function(self)
        AEnergyCreationUnit.OnShieldEnabled(self)
        if not self.Spinner then
            self.Spinner = CreateRotator(self, 'Ring', 'y', nil, 0, 45, -45)
            self.Trash:Add(self.OrbManip1)
        else
            self.Spinner:SetSpinDown(false)
            self.Spinner:SetTargetSpeed(-45)
        end
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.55) )
        end
    end,
   
    OnShieldDisabled = function(self)
        AEnergyCreationUnit.OnShieldDisabled(self)
        if self.Spinner then
            self.Spinner:SetSpinDown(true)
            self.Spinner:SetTargetSpeed(0)
        end
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
    end,
}

TypeClass = SAB1311