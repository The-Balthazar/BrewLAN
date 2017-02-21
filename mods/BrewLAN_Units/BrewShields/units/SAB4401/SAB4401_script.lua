--------------------------------------------------------------------------------
-- Description: Shield bubble projection unit
-- Author: Sean 'Balthazar' Wheeldon 
--------------------------------------------------------------------------------
local AShieldStructureUnit = import('/lua/aeonunits.lua').AShieldStructureUnit
local Shield = import('/lua/shield.lua').Shield

SAB4401 = Class(AShieldStructureUnit) {
    
    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',
        '/effects/emitters/aeon_shield_generator_t2_02_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_04_emit.bp',
    },

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
    end,

    OnShieldEnabled = function(self)
        AShieldStructureUnit.OnShieldEnabled(self)
        self.ShieldProjectionEnabled = true

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
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(1.17) )
        end
    end,

    OnShieldDisabled = function(self)
        AShieldStructureUnit.OnShieldDisabled(self)
        self:ClearShieldProjections()
        self.ShieldProjectionEnabled = false

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
    
    ShieldProjectionThread = function(self)
        while not self:IsDead() do
            if self.ShieldProjectionEnabled then --self:ShieldIsOn() enables too early
                local aiBrain = self:GetAIBrain()
                local targetunits = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE, self:GetPosition(), self:GetBlueprint().Defense.Shield.ShieldProjectionRadius or 60, 'Ally' )
                for i, unit in targetunits do
                    -- not self                                     -- not already targetted by this                  --is finished                        -- Not units with shields, except where created by Pillars but not already targeted by this
                    if unit:GetEntityId() != self:GetEntityId() and not unit.PillarShieldNode[self:GetEntityId()] and unit:GetFractionComplete() == 1 and (not unit.MyShield or unit.PillarShieldNode and not unit.PillarShieldNode[self:GetEntityId()]) then
                        self:CreateProjectedShieldBubble(unit)
                    end 
                end   
            else
                WaitTicks(10)
            end
            WaitTicks(10)
        end
    end,
    
    CreateProjectedShieldBubble = function(self, target) 
        local Bp = self:GetBlueprint()

        --Targeted-by beam data
        if not target.PillarShieldNode then target.PillarShieldNode = {} end

        --Targeted-by beam effects
        --target.PillarShieldNode[self:GetEntityId()] = AttachBeamEntityToEntity(self, 'Gem', target, 0, self:GetArmy(), Bp.Defense.Shield.ShieldTargetBeam)

        --Define targets shield
        local spec = Bp.Defense.TargetShield
        local tBp = target:GetBlueprint()
        spec.ShieldSize = math.max(tBp.Footprint.SizeX or 0, tBp.Footprint.SizeZ or 0, tBp.SizeX or 0, tBp.SizeX or 0, tBp.SizeY or 0, tBp.SizeZ or 0, tBp.Physics.MeshExtentsX or 0, tBp.Physics.MeshExtentsY or 0, tBp.Physics.MeshExtentsZ or 0) * 1.414

        --Create shield
        target:CreateProjectedShield(spec)

        --Define self as projector of shield
        target.MyShield.Projectors[self:GetEntityId()] = self
        --target.MyShield:TurnOn()
        --target.MyShield:CreateShieldMesh()
    end,
    
    ClearShieldProjections = function(self) 
        local aiBrain = self:GetAIBrain()
        local targetunits = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE, self:GetPosition(), self:GetBlueprint().Defense.Shield.ShieldProjectionRadius or 60 )
        for i, unit in targetunits do
            if unit:GetEntityId() != self:GetEntityId() and unit.PillarShieldNode[self:GetEntityId()] then
                unit.PillarShieldNode[self:GetEntityId()]:Destroy()
                unit.PillarShieldNode[self:GetEntityId()] = nil
                unit.MyShield.Projectors[self:GetEntityId()] = nil
                local keepshield = false
                for index, pillar in unit.PillarShieldNode do
                    if pillar then
                        keepshield = true
                        break
                    end
                end
                if not keepshield then
                    unit:DestroyShield()
                end
            end
        end
    end,
}

TypeClass = SAB4401
