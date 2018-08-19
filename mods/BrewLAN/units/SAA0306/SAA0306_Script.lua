--------------------------------------------------------------------------------
--  Author:  Sean Wheeldon
--  Summary  :  Aeon T3 Transport Script
--------------------------------------------------------------------------------
local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AAATemporalFizzWeapon = import('/lua/aeonweapons.lua').AAATemporalFizzWeapon
local explosion = import('/lua/defaultexplosions.lua')

SAA0306 = Class(AAirUnit) {
    DestroyNoFallRandomChance = 1.1,

    ShieldEffect = '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',

    AirDestructionEffectBones = {
        'Outer1', 'Outer002', 'Outer003', 'Outer004', 'Outer005', 'Outer006',
        'Outer007', 'Outer008', 'Outer009', 'Outer010', 'Outer011', 'Outer012',
        'Torus001', 'Torus002', 'Torus003', 'Torus004', 'Torus005', 'Torus006',
        'Torus007', 'Torus008', 'Torus009', 'Torus010', 'Torus011', 'Torus012',
        'Shutter1', 'Shutter2', 'Shutter3', 'Shutter4', 'Shutter5', 'Shutter6',
        'Disk1', 'Disk2', 'Sphere',
    },

    Weapons = {
        AAFizz = Class(AAATemporalFizzWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
        for i = 1, 6 do
            self:HideBone('Shutter' .. i, true)
        end
    end,

    OnShieldEnabled = function(self)
        AAirUnit.OnShieldEnabled(self)
        if not self.StressMeter then
            self.StressMeter = 45
        else
            self.StressMeter = math.min(45*5, self.StressMeter + 45)
        end
        if not self.Manips then
            self.Manips = {}
            for i, v in {{'Sphere', 'x'}, {'Sphere', 'z'}, {'Disk1', 'x'}, {'Disk2', 'y'}} do
                dir = 1 - 2 * math.random(0,1)
                self.Manips[i] = CreateRotator(self, v[1], v[2], nil, 0, self.StressMeter, self.StressMeter * dir * math.max(1, i - 2))
                self.Trash:Add(self.Manips[i])                                -- The math max makes the last rotator go double speed.
            end
        else
            for i, v in self.Manips do
                dir = 1 - 2 * math.random(0,1)
                v:SetSpinDown(false)
                v:SetTargetSpeed(self.StressMeter * dir * math.max(1, i - 2))
            end
        end
        if not self.ShieldEffectsBag[1] then
            self.ShieldEffectsBag = {CreateAttachedEmitter( self, 0, self:GetArmy(), self.ShieldEffect ):ScaleEmitter(1):OffsetEmitter(0,-3,0)}
    	end
    end,

    OnShieldDisabled = function(self)
        AAirUnit.OnShieldDisabled(self)
        for i, v in self.Manips do
            v:SetSpinDown(true)
            v:SetTargetSpeed(0)
        end
        if self.ShieldEffectsBag[1] then
            self.ShieldEffectsBag[1]:Destroy()
    	end
        self.ShieldEffectsBag = nil
    end,

    OnAttachedKilled = function(self, attached)
        attached:DetachFrom()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        AAirUnit.OnKilled(self, instigator, type, overkillRatio)
        if self:GetCurrentLayer() == 'Air' then
            self.detector = CreateCollisionDetector(self)
            self.Trash:Add(self.detector)
            --Attachpoint01-6 have 2 digits
            --Attachpoint007-72 have 3 digits.
            for i = 1, 14 do
                self.detector:WatchBone('Attachpoint0' .. i * 5)
            end
            self.detector:EnableTerrainCheck(true)
            self.detector:Enable()
            self:TransportDetachAllUnits(true)
        end
    end,

    OnAnimTerrainCollision = function(self, bone, x, y, z)
        DamageArea(self, {x,y,z}, 5, 50, 'Default', true, false)
        explosion.CreateDefaultHitExplosionAtBone( self, bone, 1.0 )
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
    end,
}

TypeClass = SAA0306
