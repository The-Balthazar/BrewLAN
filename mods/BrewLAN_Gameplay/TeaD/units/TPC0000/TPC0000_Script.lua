--------------------------------------------------------------------------------
--  Summary:  The teacup script
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
        self.Steam = CreateAttachedEmitter(self,'Liquid',self:GetArmy(), '/mods/brewlan_gameplay/tead/effects/emitters/tead_cuppa_steam_emit.bp'):OffsetEmitter(0,3,0):ScaleEmitter(3)
    end,
    
    LeaksThread = function(self)      
        local aiBrain = self:GetAIBrain()   
        local pos = self:GetPosition()   
        local radius = 5  
        local Units
        local teaslider = CreateSlider(self,'Liquid')
        while true do   
            Units = aiBrain:GetUnitsAroundPoint( categories.CREEP, pos, radius)
            if Units then
                for i,v in Units do 
                    if v:GetEntityId() != self:GetEntityId() then 
                        if not EntityCategoryContains(categories.PATHFINDER + categories.DAMAGETEST, v) then
                            if EntityCategoryContains(categories.BIGBOSS, v) then
                                self:SetHealth(self, self:GetHealth() - 30)
                                if self:GetHealth() > 0 then
                                    --Check we aren't on endless (possible values 'true' 'false' and nil)
                                    if not ScenarioInfo.Options.TeaDEndless == 'true' then
                                        v:GetAIBrain():OnDefeat()
                                        --Survived
                                    end
                                end                            
                            elseif EntityCategoryContains(categories.BOSS, v) then
                                self:SetHealth(self, self:GetHealth() - 5)                            
                            else
                                self:SetHealth(self, self:GetHealth() - 1)
                            end
                            teaslider:SetGoal(0, - (30- math.min(self:GetHealth(),30) )*0.003, 0)  
                            self.Steam:Destroy()  
                        end
                        v:Destroy()
                        if self:GetHealth() < 1 then    
                            self:HideBone('Liquid', true) 
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
         
    ManageDamageEffects = function(self, newHealth, oldHealth)
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)  
        self:GetAIBrain():OnDefeat()
        --SStructureUnit.OnKilled(self,instigator,type,2)
    end,
}
TypeClass = TPC0000
