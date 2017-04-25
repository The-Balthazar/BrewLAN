--------------------------------------------------------------------------------
-- Description: UEF Experimental Shield
-- Author: Sean 'Balthazar' Wheeldon
-- GPG Authors: John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
--------------------------------------------------------------------------------
local TShieldStructureUnit = import('/lua/terranunits.lua').TShieldStructureUnit
--------------------------------------------------------------------------------
local utilities = import('/lua/Utilities.lua')
local GetRandomFloat = utilities.GetRandomFloat
--------------------------------------------------------------------------------
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ScorchSplatTextures = import('/lua/defaultexplosions.lua').ScorchSplatTextures
--------------------------------------------------------------------------------
SEB4401 = Class(TShieldStructureUnit) {

    ShieldEffects = {
        '/effects/emitters/terran_shield_generator_t2_01_emit.bp',
        '/effects/emitters/terran_shield_generator_t2_02_emit.bp',
        '/effects/emitters/terran_shield_generator_t2_03_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.ShieldEffectsBag = {}
        self.Manipulators = {
            {'Rotator_001', 'z', 15},
            {'Rotator_002', 'z', -30},
            {'Rotator_003', 'z', 45},
            {'Tower_001', 'z', -45},
        }
    end,

    OnShieldEnabled = function(self)
        TShieldStructureUnit.OnShieldEnabled(self)
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
        TShieldStructureUnit.OnShieldDisabled(self)
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

    CreateFirePlumes = function( self, army, bones, yBoneOffset )
        local proj, position, offset, velocity
        local basePosition = self:GetPosition()
        for k, vBone in bones do
            position = self:GetPosition(vBone)
            offset = utilities.GetDifferenceVector( position, basePosition )
            velocity = utilities.GetDirectionVector( position, basePosition )
            velocity.x = velocity.x + GetRandomFloat(-0.3, 0.3)
            velocity.z = velocity.z + GetRandomFloat(-0.3, 0.3)
            velocity.y = velocity.y + GetRandomFloat( 0.0, 0.3)
            proj = self:CreateProjectile('/effects/entities/DestructionFirePlume01/DestructionFirePlume01_proj.bp', offset.x, offset.y + yBoneOffset, offset.z, velocity.x, velocity.y, velocity.z)
            proj:SetBallisticAcceleration(GetRandomFloat(-1, -2)):SetVelocity(GetRandomFloat(3, 4)):SetCollision(false)
            local emitter = CreateEmitterOnEntity(proj, army, '/effects/emitters/destruction_explosion_fire_plume_02_emit.bp')
        end
    end,

    OnAnimTerrainCollision = function(self, bone, x, y, z)
        self:PanelExplosion(bone, {x,y,z})
    end,

    PanelExplosion = function(self, bone, pos)
        local tablei = table.find(self.panels, bone)
        if tablei then
            local radius = 2
            if pos then
                --If we already have pos, then we just hit ground.
                CreateSplat(pos,GetRandomFloat(0,2*math.pi),ScorchSplatTextures[math.random(1,table.getn(ScorchSplatTextures))], radius, radius, GetRandomFloat(200,350), GetRandomFloat(300,600), self:GetArmy() )
            end
            if not pos then
                pos = self:GetPosition(bone)
            end
            explosion.CreateDefaultHitExplosionAtBone( self, bone, 1.0 )
            explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
            self:PlayUnitSound('PanelDestroyed')
            DamageArea(self, pos, radius, 50, 'Default', true, false)
            self:HideBone(bone,true)
            self.panels[tablei] = nil
        end
    end,

    DeathThread = function(self)
        local army = self:GetArmy()
        local pos = self:GetPosition()
        --Not writing all these panel names out.
        self.panels = {}
        for i = 1, 9 do
            table.insert(self.panels, 'Panel_00' .. i)
        end
        for i = 20, 37 do
            table.insert(self.panels, 'Panel_0' .. i)
        end
        --Create Initial explosion effects
            self:PlayUnitSound('Destroyed')
        explosion.CreateFlash( self, 'Tower_002', 4.5, army )
        CreateAttachedEmitter(self, 'Tower_002', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'Tower_002', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
        self:CreateFirePlumes( army, self.panels, 0.5 )
        for i = 1, 3 do
            DamageArea(self, pos, 10, 1, 'Force', true)
            for k, v in EffectTemplate.ExplosionDebrisLrg01 do
                CreateAttachedEmitter( self, 'Tower_002', army, v )
            end
        end
        --Destroy living animations
        if self.Manipulators then
            for i, v in self.Manipulators do
                if v[4] then
                    v[4]:Destroy()
                    v[4] = nil
                end
            end
        end
        --Set up for panels crashing into the ground
        self.detector = CreateCollisionDetector(self)
        self.Trash:Add(self.detector)
        for i, v in self.panels do
            self.detector:WatchBone(v)
        end
        self.detector:EnableTerrainCheck(true)
        self.detector:Enable()
        --Explode panels randomly in the air
        for i = 1, 6 do
            WaitSeconds(Random(1,2))
            for i, panel in self.panels do
                if panel and Random(1,4) == 4 then
                    WaitTicks(Random(1,3))
                    self:PanelExplosion(panel)
                end
            end
        end
        --Kill off any remaining flying panels
        for i, v in self.panels do
            if v then
                self:PanelExplosion(v)
            end
        end
        --Final explosion to wreckage
        self:PlayUnitSound('Destroyed')
        explosion.CreateFlash( self, 'Tower_002', 4.5, army )
        CreateSplat(pos,GetRandomFloat(0,2*math.pi),ScorchSplatTextures[math.random(1,table.getn(ScorchSplatTextures))], 15, 15, GetRandomFloat(200,350), GetRandomFloat(300,600), self:GetArmy() )
        self:CreateWreckage(0.1)
        self:Destroy()
    end,
}

TypeClass = SEB4401
