--------------------------------------------------------------------------------
--  Summary:  The victory crystal script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker  

ZPC0001 = Class(SStructureUnit) { 
             
    OnCreate = function(self, builder, layer)
        local aiBrain = self:GetAIBrain()
        if ScenarioInfo.Crystal.FirstCapture then
            --Sanitise no rush time        
            local norushtime
            if ScenarioInfo.Options.NoRushOption == 'Off' then
               norushtime = 0
            else
               norushtime = tonumber(ScenarioInfo.Options.NoRushOption)
            end
            
            ScenarioInfo.Crystal = self:GetBlueprint().ScenarioInfo
            ScenarioInfo.Crystal.EndTimeMins = (GetGameTimeSeconds() + (ScenarioInfo.Crystal.WinTimeMinsReq * 60)) / 60
            Sync.Crystal = {
                EndTimeMins = ScenarioInfo.Crystal.EndTimeMins,
                Player = self:GetArmy(),
                PlayerName = aiBrain.Nickname,
            }
        else
            ScenarioInfo.Crystal.EndTimeMins = math.max(ScenarioInfo.Crystal.EndTimeMins, (GetGameTimeSeconds() + (ScenarioInfo.Crystal.ResetTimeMinimum * 60)) / 60)     
            Sync.Crystal = {
                EndTimeMins = ScenarioInfo.Crystal.EndTimeMins,
                Player = self:GetArmy(),
                PlayerName = aiBrain.Nickname,
            }
        end       
        --Announcement(, controls.objItems[objTag])
        --print(aiBrain.Nickname .. " has the crystal. " .. math.floor((ScenarioInfo.Crystal.EndTimeMins * 60 - GetGameTimeSeconds())/60) .. " mins remaining.") 
        self:ForkThread(self.TeamChange) 
        SStructureUnit.OnCreate(self)
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
        local pos = self:GetPosition()   
        local aiBrain = self:GetAIBrain()
        local radius = self:GetBlueprint().Intel.VisionRadius or 20
        while not self.WinnerMessage do
            if self.Count(self) != 0 and self.Count(self, 'Ally' ) == 0 then
                local Units = aiBrain:GetUnitsAroundPoint( categories.ALLUNITS, pos, radius, 'Enemy') 
                if Units[1] and IsUnit(Units[1]) then
                    ChangeUnitArmy(self,Units[1]:GetArmy())
                end
            end 
            local remaining = (ScenarioInfo.Crystal.EndTimeMins * 60) - GetGameTimeSeconds()
            if remaining < 0 then   
                local allies = -1
                for i, brain in ArmyBrains do
                    if not IsAlly(self:GetArmy(), brain:GetArmyIndex()) then
                        brain:OnDefeat()
                    else
                        allies = allies + 1
                    end
                end
                if allies > 1 and not self.WinnerMessage then
                    Sync.Crystal = {
                        Player = self:GetArmy(),
                        PlayerName = aiBrain.Nickname,
                        Victory = 1,
                    }      
                    -- [Player] and their friends win with the crystal.
                    self.WinnerMessage = true 
                elseif allies == 1 and not self.WinnerMessage then     
                    Sync.Crystal = {
                        Player = self:GetArmy(),
                        PlayerName = aiBrain.Nickname,
                        Victory = 2,
                    }       
                    -- [Player] and their friend win with the crystal.
                    self.WinnerMessage = true 
                elseif not self.WinnerMessage then  
                    Sync.Crystal = {
                        Player = self:GetArmy(),
                        PlayerName = aiBrain.Nickname,
                        Victory = 3,
                    }          
                    -- [Player] has won with the crystal.
                    self.WinnerMessage = true  
                end
            end
            if remaining < 10 and not remaining < 0 then
                --If we are in the last 10 seconds, but not after the end, check ALL THE TIME
                WaitTicks(1)
            else      
                --Otherwise once a second
                WaitSeconds(1)
            end
        end
    end,
    
    Count = function(self, fealty) 
        local pos = self:GetPosition()   
        local aiBrain = self:GetAIBrain()
        local radius = self:GetBlueprint().Intel.VisionRadius or 20   
        local units
        if fealty then
            units = aiBrain:GetUnitsAroundPoint( categories.ALLUNITS, pos, radius, fealty)
        else
            units = aiBrain:GetUnitsAroundPoint( categories.ALLUNITS, pos, radius)
        end
        local count = 0
        for k, v in units do
            if v:GetEntityId() != self:GetEntityId() and not v:IsDead() and not EntityCategoryContains( categories.WALL + categories.SATELLITE + categories.UNTARGETABLE, v ) then
                count = count + 1
            end
        end
        return count
    end,
    
    OnDamage = function()
    end,     
    
    OnKilled = function(self, instigator, type, overkillRatio)  
        local pos = self:GetPosition()               
        for i, brain in ArmyBrains do
            if not brain:IsDefeated() then    
                CreateUnitHPR('ZPC0002',brain:GetArmy(), pos[1],pos[2],pos[3],0,0,0)
                self:Destroy()
            end
        end
    end,
}
TypeClass = ZPC0001