--------------------------------------------------------------------------------
--  Summary  :  Aeon Heavy Transport
--  Author   :  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AAATemporalFizzWeapon = import('/lua/aeonweapons.lua').AAATemporalFizzWeapon
local explosion = import('/lua/defaultexplosions.lua')

if string.sub(GetVersion(),1,3) == '1.5' and tonumber(string.sub(GetVersion(),5)) > 3603 then--VersionIsFAF then
    AAirUnit = import('/lua/defaultunits.lua').AirTransport
end

SAA0306 = Class(AAirUnit) {
    DestroyNoFallRandomChance = 1.1,

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
        local bp = self:GetBlueprint()
        self:SetCollisionShape( 'Box', 0, 0, 0, bp.SizeUnpackedX * 0.5, bp.SizeUnpackedY * 0.5, bp.SizeUnpackedZ * 0.5)
    end,

    OnShieldEnabled = function(self)
        AAirUnit.OnShieldEnabled(self)
        self:StartRotateManipulators()
        if not self.ShieldEffect then
            self.ShieldEffect = CreateAttachedEmitter( self, 0, self:GetArmy(), '/effects/emitters/aeon_shield_generator_t3_03_emit.bp' ):OffsetEmitter(0, -3, 0)
    	end
    end,

    StartRotateManipulators = function(self)
        -- The math max makes rotator 4 go double speed.
        local function manipMult(i) return (1 - 2 * Random(0,1)) * math.max(1, i-2) end

        self.StressMeter = self.StressMeter and math.min(225, self.StressMeter + 45) or 45
        --self.PermOpenAnimManipulator:SetRate(1)

        if not self.Manips then
            self.Manips = {}
            for i, v in {{'Sphere', 'x'}, {'Sphere', 'z'}, {'Disk1', 'x'}, {'Disk2', 'y'}} do
                self.Manips[i] = CreateRotator(self, v[1], v[2], nil, 0, self.StressMeter, self.StressMeter * manipMult(i) )
                self.Trash:Add(self.Manips[i])
            end
        else
            for i, v in self.Manips do
                v:SetSpinDown(false):SetTargetSpeed(self.StressMeter * manipMult(i)):ClearGoal()
            end
        end
    end,

    StopRotateManipulators = function(self)
        if self.Manips then
            for i, v in self.Manips do
                v:SetSpinDown(true):SetTargetSpeed(0)
            end
        end
    end,

    OnShieldDisabled = function(self)
        AAirUnit.OnShieldDisabled(self)
        self:StopRotateManipulators()
        if self.ShieldEffect then
            self.ShieldEffect:Destroy()
    	end
        self.ShieldEffect = nil
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
