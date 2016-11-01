--------------------------------------------------------------------------------
--  Summary:  The victory crystal script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker  

ZPC0001 = Class(SStructureUnit) { 
             
    OnCreate = function(self, builder, layer)
        LOG(repr(ScenarioInfo.Options))
        local aiBrain = self:GetAIBrain()
        if ScenarioInfo.Crystal.FirstCapture then
            --Get defaults from blueprint
            ScenarioInfo.Crystal = self:GetBlueprint().ScenarioInfo
            --Get overrides from lobby options, if they exist
            if ScenarioInfo.Options.CrystalVictoryLength then
                ScenarioInfo.Crystal.WinTimeMinsReq = math.max(tonumber(ScenarioInfo.Options.CrystalVictoryLength), (tonumber(ScenarioInfo.Options.CrystalOvertime)/60))
                ScenarioInfo.Crystal.ResetTimeMinimum = tonumber(ScenarioInfo.Options.CrystalResetTime)
                ScenarioInfo.Crystal.OvertimeGraceSeconds = tonumber(ScenarioInfo.Options.CrystalOvertime)
            end
            --Calculate the end time 
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
                local Units = aiBrain:GetUnitsAroundPoint(categories.SELECTABLE - categories.WALL - categories.SATELLITE - categories.UNTARGETABLE, pos, radius) 
                if Units[1] and IsUnit(Units[1]) and Units[1]:GetArmy() != self:GetArmy() then
                    ChangeUnitArmy(self,Units[1]:GetArmy())
                end
            end 
            local remaining = (ScenarioInfo.Crystal.EndTimeMins * 60) - GetGameTimeSeconds()
            local overtimeremaining = ((ScenarioInfo.Crystal.EndTimeOvertimeMins or ScenarioInfo.Crystal.EndTimeMins) * 60) - GetGameTimeSeconds()
            if remaining < 10 and self.Count(self, 'Enemy') != 0 then
                ScenarioInfo.Crystal.EndTimeOvertimeMins = (GetGameTimeSeconds() + ScenarioInfo.Crystal.OvertimeGraceSeconds) / 60
                Sync.CrystalEndTimeOvertimeMins = ScenarioInfo.Crystal.EndTimeOvertimeMins
            elseif remaining < 0 and self.Count(self, 'Enemy') == 0 and overtimeremaining < 0 then   
                local allies = -1
                if ScenarioInfo.Options.TeamLock == "locked" then
                    for i, brain in ArmyBrains do
                        if not IsAlly(self:GetArmy(), brain:GetArmyIndex()) then
                            brain:OnDefeat()
                        else
                            allies = allies + 1
                        end
                    end
                elseif ScenarioInfo.Options.TeamLock == "unlocked" then
                    for i, brain in ArmyBrains do
                        if self:GetArmy() != brain:GetArmyIndex() then
                            brain:OnDefeat()
                        else
                            allies = allies + 1
                        end
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
        local AIUtils = import('/lua/ai/aiutilities.lua')   
        local searchCat = categories.ALLUNITS
        local units = {}
        if ScenarioInfo.Options.TeamLock == "locked" then
            -- Normal team search on locked teams
            if fealty then
                units = aiBrain:GetUnitsAroundPoint( searchCat, pos, radius, fealty)
            else
                units = aiBrain:GetUnitsAroundPoint( searchCat, pos, radius)
            end
        elseif ScenarioInfo.Options.TeamLock == "unlocked" then
            -- Treat only self as ally on unteamed games. 
            if fealty == "Ally" then
                -- Only self units
                units = AIUtils.GetOwnUnitsAroundPoint( aiBrain, searchCat, pos, radius)
            elseif fealty == "Enemy" then
                -- Only non-self units
                for index, brain in ArmyBrains do
                    if brain:GetArmyIndex() != self:GetArmy() then
                        for i, unit in AIUtils.GetOwnUnitsAroundPoint(brain, searchCat, pos, radius) do
                            table.insert(units, unit)
                        end
                    end
                end
            else
                -- Any units
                units = aiBrain:GetUnitsAroundPoint( searchCat, pos, radius)
            end
        end
        local count = 0
        for k, v in units do
            if v:GetEntityId() != self:GetEntityId() and not v:IsDead() and not EntityCategoryContains( categories.WALL + categories.SATELLITE + categories.UNTARGETABLE, v ) and EntityCategoryContains(categories.SELECTABLE, v) then
                count = count + 1
            end
        end
        return count
    end,
    
    OnDamage = function()
    end,     
    
    OnKilled = function(self, instigator, type, overkillRatio)  
    end,
}
TypeClass = ZPC0001
