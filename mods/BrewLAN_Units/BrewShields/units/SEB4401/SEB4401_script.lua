--------------------------------------------------------------------------------
-- Description: UEF Experimental Shield
-- Author: Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local AShieldStructureUnit = import('/lua/terranunits.lua').TShieldStructureUnit

SEB4401 = Class(AShieldStructureUnit) {

    ShieldEffects = {
        '/effects/emitters/terran_shield_generator_t2_01_emit.bp',
        '/effects/emitters/terran_shield_generator_t2_02_emit.bp',
        '/effects/emitters/terran_shield_generator_t2_03_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        AShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.ShieldEffectsBag = {}
        self.Manipulators = {
            {'Rotator_001', 'z', 15},
            {'Rotator_002', 'z', -30},
            {'Rotator_003', 'z', 45},
            {'Tower_001', 'z', -45},
        }
    end,

    OnShieldEnabled = function(self)
        AShieldStructureUnit.OnShieldEnabled(self)

        if not self.Manipulators[1][4] then
            for i, v in self.Manipulators do
                v[4] = CreateRotator(self, v[1], v[2], nil, 0, v[3], v[3])
                self.Trash:Add(v[4])
            end
        end

        for i, v in self.Manipulators do
            v[4]:SetTargetSpeed(v[3])
        end

        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(1.3):OffsetEmitter(0,3.3,-4.2) )
        end
    end,

    OnShieldDisabled = function(self)
        AShieldStructureUnit.OnShieldDisabled(self)

        for i, v in self.Manipulators do
            --v[4]:SetSpinDown(true)
            v[4]:SetTargetSpeed(0)
        end

        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
    end,
}

TypeClass = SEB4401
