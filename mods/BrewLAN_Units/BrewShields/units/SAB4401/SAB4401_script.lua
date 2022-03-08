--------------------------------------------------------------------------------
-- Description: Shield bubble projection unit
-- Author: Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local AShieldStructureUnit = import('/lua/defaultunits.lua').ShieldStructureUnit
local Shield = import('/lua/shield.lua').Shield
--------------------------------------------------------------------------------
local explosion = import('/lua/defaultexplosions.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
--------------------------------------------------------------------------------
SAB4401 = Class(AShieldStructureUnit) {

    BpId = 'sab4401',

    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',
        '/effects/emitters/aeon_shield_generator_t2_02_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_04_emit.bp',
    },

    OnCreate = function(self)
        AShieldStructureUnit.OnCreate(self)
        self.CachePosition = self:GetPosition()
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        AShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:ForkThread(self.ShieldProjectionThread)
        self.ShieldEffectsBag = {}
        self.Manipulators = {
            {'Ring_1', 'z', 45},
            {'Ring_3', 'z', 45},
            {'Gem', 'z', 45},
            {'Orb', 'x', 45},
            {'Orb', 'z', 45},
        }
        for i, v in self.Manipulators do
            v[4] = CreateRotator(self, v[1], v[2], nil, 0, v[3], v[3])
            self.Trash:Add(v[4])
        end
    end,

    OnShieldEnabled = function(self)
        AShieldStructureUnit.OnShieldEnabled(self)
        self.ShieldProjectionEnabled = true
        for i, v in self.Manipulators do
            v[4]:SetTargetSpeed(v[3])
        end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(1.17) )
        end
    end,

    OnShieldDisabled = function(self)
        AShieldStructureUnit.OnShieldDisabled(self)
        self:ClearShieldProjections()
        self.ShieldProjectionEnabled = false
    end,

    ShieldProjectionThread = function(self)
        local aiBrain = self:GetAIBrain()
        local radius = __blueprints.sab4401.Defense.Shield.ShieldProjectionRadius or 60
        while self and not self.Dead do
            if self.ShieldProjectionEnabled and self:ShieldIsOn() then --Both to cover all bases. Not all deactivation triggers hit the variable, and the function counts charging for activation as 'on'.
                for i, unit in aiBrain:GetUnitsAroundPoint(categories.STRUCTURE, self.CachePosition, radius, 'Ally' ) do
                    self:CreateProjectedShieldBubble(unit)
                end
                coroutine.yield(11)
            else
                if self.ShieldProjectionEnabled and not self:ShieldIsOn() then
                    self:ClearShieldProjections()
                    self.ShieldProjectionEnabled = false
                end
                coroutine.yield(21)
            end
        end
    end,

    CreateProjectedShieldBubble = function(self, target)

        if not target.Projectors then
            target.Projectors = {}
        end

        if not target.Projectors[self.Sync.id] then
            target.Projectors[self.Sync.id] = self
        end

        if not target.MyShield then
            target:CreateProjectedShield(__blueprints.sab4401.Defense.TargetShield)
        elseif target.MyShield.ActivateProjection then
            target.MyShield:ActivateProjection()
        end

        if target.MyShield.SetDamageSplitFunction then
            target.MyShield:SetDamageSplitFunction()
        end

    end,

    ClearShieldProjections = function(self)

        for i, unit in self:GetAIBrain():GetUnitsAroundPoint(categories.STRUCTURE, self.CachePosition, __blueprints.sab4401.Defense.Shield.ShieldProjectionRadius or 60 ) do
            if unit.Projectors and unit.MyShield and unit.MyShield.ClearProjection then
                unit.Projectors[self.Sync.id] = nil
                local keepshield = false
                for index, pillar in unit.Projectors do
                    if pillar then
                        keepshield = true
                        break
                    end
                end
                if not keepshield then
                    unit.MyShield:ClearProjection()
                end
            end
        end

        if not self.Dead then
            for i, v in self.Manipulators do
                v[4]:SetTargetSpeed(0)
            end
        end

        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            if not self.Dead then
                self.ShieldEffectsBag = {}
            end
        end

    end,

    DeathThread = function(self, overkillRatio, instigator)
        local army = self:GetArmy()
        local pos = self.CachePosition
        self:PlayUnitSound('Destroyed')
        explosion.CreateFlash( self, 'Ring_1', 4.5, army )
        for i = 1, 3 do
            DamageArea(self, pos, 10, 1, 'Force', true)
            self:HideBone('Ring_' .. i, false)
            for k, v in EffectTemplate.ExplosionDebrisLrg01 do
                CreateAttachedEmitter( self, 'Base', army, v )
            end
        end
        if self.PlayDestructionEffects then
            self:CreateDestructionEffects( self, overkillRatio )
        end
        for i, v in self.Manipulators do
            if v[4] then
                v[4]:Destroy()
                v[4] = nil
            end
        end
        if overkillRatio <= 1.0 and self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end
        self:PlayUnitSound('Destroyed')
        explosion.CreateFlash( self, 'Ring_1', 4.5, army )
        self:CreateWreckage(overkillRatio)
        self:Destroy()
    end,

    OnDestroy = function(self)
        self:ClearShieldProjections()
        AShieldStructureUnit.OnDestroy(self)
    end,
}

TypeClass = SAB4401
