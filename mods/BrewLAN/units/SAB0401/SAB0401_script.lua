--------------------------------------------------------------------------------
--  Summary:  The Independence Engine script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local AAirFactoryUnit = import('/lua/aeonunits.lua').AAirFactoryUnit
--------------------------------------------------------------------------------
local CreateAeonCommanderBuildingEffects = import('/lua/EffectUtilities.lua').CreateAeonCommanderBuildingEffects
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
--------------------------------------------------------------------------------
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local Buff = import(BrewLANPath .. '/lua/legacy/VersionCheck.lua').Buff
local GantryUtils = import(BrewLANPath .. '/lua/GantryUtils.lua')
local BuildModeChange = GantryUtils.BuildModeChange
local AIStartOrders = GantryUtils.AIStartOrders
local AIControl = GantryUtils.AIControl
local AIStartCheats = GantryUtils.AIStartCheats
local AICheats = GantryUtils.AICheats
--------------------------------------------------------------------------------
SAB0401 = Class(AAirFactoryUnit) {
--------------------------------------------------------------------------------
-- Function triggers
--------------------------------------------------------------------------------
    OnCreate = function(self)
        AAirFactoryUnit.OnCreate(self)
        local bp = self:GetBlueprint()
        self:SetCollisionShape(
            'Sphere',
            bp.CollisionSphereOffsetX or 0,
            bp.CollisionSphereOffsetY or 0,
            bp.CollisionSphereOffsetZ or 0,
            bp.SizeSphere
        )
        self.airmode = true
        BuildModeChange(self)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        AIStartCheats(self, Buff)
        AAirFactoryUnit.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(self.PlatformRaisingThread)
        AIStartOrders(self)
    end,

    OnLayerChange = function(self, new, old)
        AAirFactoryUnit.OnLayerChange(self, new, old)
        BuildModeChange(self)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        AICheats(self, Buff)
        AAirFactoryUnit.OnStartBuild(self, unitBeingBuilt, order)
        BuildModeChange(self)
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        AAirFactoryUnit.OnStopBuild(self, unitBeingBuilt)
        AIControl(self, unitBeingBuilt)
        BuildModeChange(self)
    end,
--------------------------------------------------------------------------------
-- Button controls
--------------------------------------------------------------------------------
    OnScriptBitSet = function(self, bit)
        AAirFactoryUnit.OnScriptBitSet(self, bit)
    end,

    OnScriptBitClear = function(self, bit)
        AAirFactoryUnit.OnScriptBitClear(self, bit)
    end,

    OnPaused = function(self)
        AAirFactoryUnit.OnPaused(self)
        self:StopBuildFx(self:GetFocusUnit())
    end,

    OnUnpaused = function(self)
        AAirFactoryUnit.OnUnpaused(self)
        if self:IsUnitState('Building') then
            self:StartBuildFx(self:GetFocusUnit())
        end
    end,
--------------------------------------------------------------------------------
-- Animations
--------------------------------------------------------------------------------
    StartBuildFx = function(self, unitBeingBuilt)
        if not unitBeingBuilt then
            unitBeingBuilt = self:GetFocusUnit()
        end
        local thread = self:ForkThread( self.CreateAeonFactoryBuildingEffects, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, 'Attachpoint', self.BuildEffectsBag )
        unitBeingBuilt.Trash:Add( thread )
    end,

    --StopBuildFx = function(self)
    --end,

    PlatformRaisingThread = function(self)
        --CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,
        --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
        local pSlider = CreateSlider(self, 'Platform', 0, 0, 0, 10)
        --local bRotator = CreateRotator(self, 'Builder_Node', 'y', 0, 1000, 100, 1000)
        local nSliders = {}
        for i = 1, 8 do
            nSliders[i] = CreateSlider(self, 'Builder_00' .. i, 0, 0, 0, 50)
        end
        local pMaxHeight = 32

        local unitBeingBuilt
        local buildState = 'start'
        local uBBF
        local pSliderPos
        local bSliderPos
        while self do
            unitBeingBuilt = self:GetFocusUnit()
            if unitBeingBuilt then
                if buildState == 'start' or buildState == 'active' and EntityCategoryContains(categories.AIR,unitBeingBuilt) then
                    uBBF = math.max(unitBeingBuilt:GetFractionComplete() - 0.8, 0) * 5
                    buildState = 'active'
                elseif EntityCategoryContains(categories.AIR,unitBeingBuilt) then
                    uBBF = 1
                else
                    uBBF = 0
                end
                pSliderPos = uBBF * pMaxHeight
                if math.random(1,15) == 10 then
                    --bRotator:SetGoal(math.random(1,3) * 22.5 - 22.5 )
                    for i, slider in nSliders do
                        if math.random(1,8) != 8 then
                            bSliderPos = pMaxHeight * RandomFloat(0,1) * ((1 - uBBF) * .75)
                            slider:SetGoal(0, bSliderPos ,0)
                        end
                    end
                end
            else
                WaitTicks(3) -- If there is something building after 3 ticks, then assume inf build and stay up.
                if (buildState == 'active' or buildState == 'repeat') and self:GetFocusUnit() then
                    buildState = 'repeat'
                else
                    buildState = 'start'
                    pSliderPos = 0
                end
            end
            pSlider:SetGoal(0,pSliderPos,0)
            WaitTicks(1)
        end
    end,

    CreateAeonFactoryBuildingEffects = function( builder, unitBeingBuilt, BuildEffectBones, BuildBone, EffectsBag )
        local army = builder:GetArmy()
        for kBone, vBone in BuildEffectBones do
            EffectsBag:Add( CreateAttachedEmitter( builder, vBone, army, '/effects/emitters/aeon_build_03_emit.bp' ) )
            for kBeam, vBeam in EffectTemplate.AeonBuildBeams02 do
                local beamEffect = AttachBeamEntityToEntity(builder, vBone, builder, BuildBone, army, vBeam )
                EffectsBag:Add(beamEffect)
            end
        end
    end
}

TypeClass = SAB0401
