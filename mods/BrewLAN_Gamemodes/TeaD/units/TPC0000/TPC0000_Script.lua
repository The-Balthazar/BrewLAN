--------------------------------------------------------------------------------
--  Summary:  The neutral crystal script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local WarpIn = import('/units/xsl0001/xsl0001_script.lua').XSL0001.WarpInEffectThread    
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

TPC0000 = Class(SStructureUnit) { 
             
    OnCreate = function(self, builder, layer)
        self:HideBone(0,true)
        self:ForkThread(self.LeaksThread) 
        SStructureUnit.OnCreate(self)  
        self:ForkThread(WarpIn)   
        for i, brain in ArmyBrains do
            VizMarker({
                X = self:GetPosition()[1],
                Z = self:GetPosition()[3],
                Radius = self:GetBlueprint().Intel.VisionRadius or 20,
                LifeTime = -1,
                Army = brain:GetArmyIndex(),
            })
        end
    end,
    
    LeaksThread = function(self)      
        local aiBrain = self:GetAIBrain()   
        local pos = self:GetPosition()   
        local radius = 5  
        local Units
        while true do   
            Units = aiBrain:GetUnitsAroundPoint( categories.CREEP, pos, radius)
            if Units then
                for i,v in Units do 
                    if v:GetEntityId() != self:GetEntityId() then 
                        if not EntityCategoryContains(categories.PATHFINDER, v) then
                            self:SetHealth(self, self:GetHealth() - 1)    
                        end
                        v:Destroy()
                        if self:GetHealth() < 1 then   
                            self:GetAIBrain():OnDefeat()
                        end
                    end
                end
            end
            WaitSeconds(1)
        end
    end,
    
    OnDamage = function()
    end,   
      
    OnKilled = function(self, instigator, type, overkillRatio)  
        self:GetAIBrain():OnDefeat()
    end,
}
TypeClass = TPC0000