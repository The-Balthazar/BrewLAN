--------------------------------------------------------------------------------
--  Summary:  The Gantry script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------

local TLandFactoryUnit = import('/lua/aeonunits.lua').ALandFactoryUnit
local explosion = import('/lua/defaultexplosions.lua')
local Utilities = import('/lua/utilities.lua')    
local Buff = import('/lua/sim/Buff.lua')   

SAB0401 = Class(TLandFactoryUnit) {
--------------------------------------------------------------------------------
-- Function triggers
--------------------------------------------------------------------------------   

    OnCreate = function(self)
        TLandFactoryUnit.OnCreate(self)
    end,
           
    OnStopBeingBuilt = function(self, builder, layer)
        TLandFactoryUnit.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(self.PlatformRaisingThread)
    end,
     
    OnLayerChange = function(self, new, old)
        TLandFactoryUnit.OnLayerChange(self, new, old)
    end,
    
    OnStartBuild = function(self, unitBeingBuilt, order)                    
        TLandFactoryUnit.OnStartBuild(self, unitBeingBuilt, order)
    end,      
           
    OnStopBuild = function(self, unitBeingBuilt)     
        TLandFactoryUnit.OnStopBuild(self, unitBeingBuilt)
    end,      
        
--------------------------------------------------------------------------------
-- Button controls
--------------------------------------------------------------------------------  
          
    OnScriptBitSet = function(self, bit)
        TLandFactoryUnit.OnScriptBitSet(self, bit)
    end,
    
    OnScriptBitClear = function(self, bit)
        TLandFactoryUnit.OnScriptBitClear(self, bit)
    end,
              
    OnPaused = function(self)
        TLandFactoryUnit.OnPaused(self)
        self:StopBuildFx(self:GetFocusUnit())
    end,

    OnUnpaused = function(self)
        TLandFactoryUnit.OnUnpaused(self)
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
    end,
    
    StopBuildFx = function(self)
    end,

    PlatformRaisingThread = function(self)
    --CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,
        local pSlider = CreateSlider(self, 'Platform', 0, 0, 0, 10)
        local pMaxHeight = 35
        local unitBeingBuilt
        while self do
            unitBeingBuilt = self:GetFocusUnit()
            if unitBeingBuilt then
                unitBeingBuilt = unitBeingBuilt:GetFractionComplete() * pMaxHeight
            else
                unitBeingBuilt = 0
            end
            pSlider:SetGoal(0,unitBeingBuilt,0)
            WaitTicks(1)
        end
    end,
}

TypeClass = SAB0401
