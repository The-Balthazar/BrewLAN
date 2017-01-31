--------------------------------------------------------------------------------
--  Summary:  The Gantry script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------

local AAirFactoryUnit = import('/lua/aeonunits.lua').AAirFactoryUnit
--local explosion = import('/lua/defaultexplosions.lua')
--local Utilities = import('/lua/utilities.lua')
--local Buff = import('/lua/sim/Buff.lua')
local CreateAeonCommanderBuildingEffects = import('/lua/EffectUtilities.lua').CreateAeonCommanderBuildingEffects
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

SAB0401 = Class(AAirFactoryUnit) {
--------------------------------------------------------------------------------
-- Function triggers
--------------------------------------------------------------------------------   

    OnCreate = function(self)
        AAirFactoryUnit.OnCreate(self)
    end,
           
    OnStopBeingBuilt = function(self, builder, layer)
        AAirFactoryUnit.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(self.PlatformRaisingThread)
    end,
     
    OnLayerChange = function(self, new, old)
        AAirFactoryUnit.OnLayerChange(self, new, old)
    end,
    
    OnStartBuild = function(self, unitBeingBuilt, order)                    
        AAirFactoryUnit.OnStartBuild(self, unitBeingBuilt, order)
    end,      
           
    OnStopBuild = function(self, unitBeingBuilt)     
        AAirFactoryUnit.OnStopBuild(self, unitBeingBuilt)
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
        local uBBF
        local pSliderPos
        local bSliderPos
        while self do
            unitBeingBuilt = self:GetFocusUnit()
            if unitBeingBuilt then
                uBBF = unitBeingBuilt:GetFractionComplete()
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
                pSliderPos = 0
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
