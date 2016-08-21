--------------------------------------------------------------------------------
--  Summary:  The neutral crystal script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local WarpIn = import('/units/xsl0001/xsl0001_script.lua').XSL0001.WarpInEffectThread    
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker  
--local Announcement = import('/lua/ui/game/announcement.lua').CreateAnnouncement   
--local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
--local UIUtil = import('/lua/ui/uiutil.lua')

ZPC0002 = Class(SStructureUnit) { 
             
    OnCreate = function(self, builder, layer)
        self:HideBone(0,true)
        local aiBrain = self:GetAIBrain()
        if not ScenarioInfo.Crystal.FirstCapture then
            ScenarioInfo.Crystal = {}
            ScenarioInfo.Crystal.FirstCapture = true
        end
        self:ForkThread(self.TeamChange) 
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
    
    TeamChange = function(self)      
        local aiBrain = self:GetAIBrain()   
        local pos = self:GetPosition()   
        local radius = self:GetBlueprint().Intel.VisionRadius or 20  
        local Units
        while true do   
            Units = aiBrain:GetUnitsAroundPoint( categories.ALLUNITS, pos, radius)       
            while aiBrain:GetNoRushTicks() != 0 do
                -- Just in case the map has a spawn in the middle        
                WaitSeconds(10)
            end          
            if Units then
                for i,v in Units do    
                    local civilian = false
                    for name,data in ScenarioInfo.ArmySetup do
                        if name == v:GetAIBrain().Name then
                            civilian = data.Civilian
                            break
                        end
                    end 
                    if v:GetEntityId() != self:GetEntityId() and not civilian then     
                        pos = self:GetPosition()   
                        CreateUnitHPR('ZPC0001',v:GetArmy(), pos[1],pos[2],pos[3],0,0,0)
                        self:Destroy()
                    end
                end
            end
            WaitSeconds(1)
        end
    end,
    
    OnDamage = function()
    end,   
      
    OnKilled = function(self, instigator, type, overkillRatio)  
    end,
}
TypeClass = ZPC0002
