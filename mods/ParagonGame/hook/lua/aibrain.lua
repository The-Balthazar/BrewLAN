--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------

AIBrain = Class(AIBrain) {

--------------------------------------------------------------------------------
--  Summary:  The Paragon Decider script
--------------------------------------------------------------------------------

    ParagonOrNotCheck = function(self, strArmy)
        
        -- Checks the teams
        local myteam     
        local teams = {}
        for name,army in ScenarioInfo.ArmySetup do   
            if not army.Civilian then
                if not teams[army.Team] then
                    teams[army.Team] = {}
                end
                table.insert(teams[army.Team],army.ArmyIndex)
                if "ARMY_" .. army.ArmyIndex == strArmy then
                    myteam = army.Team
                end 
                if army.Team > 1 then
                    ScenarioInfo.TeamsDefined = true
                end
            else
                LOG(name)                     
            end
        end
        
        -- Checks the smallest defined team size   
        local minTeamQuantity = 2147483647 -- Arbitrary large number definitely larger than the largest possible team. Not counting mods that allow for most of the population of the planet to play.  
        if ScenarioInfo.Options.TeamLock == 'locked' and ScenarioInfo.TeamsDefined then
            for i, v in teams do
                minTeamQuantity = math.min(minTeamQuantity, self:CountTeamSize(teams, i ))
            end
        end
        
        -- Spawn paragons for everyone if teams aren't locked or aren't defined, or for player(s) on the smallest team(s) if they are
        if ScenarioInfo.Options.TeamLock != 'locked' or not ScenarioInfo.TeamsDefined or ScenarioInfo.TeamsDefined and self:CountTeamSize(teams, myteam) == minTeamQuantity then
            self:SpawnParagonUnits()
        else       
            self:RestrictParagonUnits(strArmy)
        end     
    end,

--------------------------------------------------------------------------------
--  Summary:  The Paragon Spawner script
--------------------------------------------------------------------------------

    SpawnParagonUnits = function(self)
        local factionIndex = self:GetFactionIndex()
        
        local paragonunits = nil
        local landunits = nil
          
        local posX, posY = self:GetArmyStartPos()
        
        if factionIndex == 1 then
            paragonunits = {
                { 'PEB1401', 1 },
                { 'UEB4301', 4 },
            }             
            landunits = {
                { 'UEL0301', 1 },
            }
        elseif factionIndex == 2 then
            paragonunits = {
                { 'XAB1401', 1 },
                { 'UAB4301', 4 },
            }             
            landunits = {
                { 'UAL0301', 1 },
            }
        elseif factionIndex == 3 then
            paragonunits = {
                { 'PRB1401', 1 },
                { 'URB4207', 4 },
            }   
            landunits = {
                { 'URL0301', 1 },
            }
        elseif factionIndex == 4 then
            paragonunits = {
                { 'PSB1401', 1 },
                { 'XSB4301', 4 },
            }    
            landunits = {
                { 'XSL0301', 1 },
            }
        end
        
        if paragonunits then
            for j, u in paragonunits do
                local count = 0
                while count < u[2] do
                    local unit = self:CreateUnitNearSpot(u[1], posX, posY - 20)
                    count = count + 1
                    unit:CreateTarmac(true,true,true,false,false)
                end
            end
        end
        
        if landunits then
            for j, u in landunits do
                local count = 0
                while count < u[2] do
                    local unit = self:CreateUnitNearSpot(u[1], posX, posY)
                    count = count + 1
                end
            end
        end
        
        self.PreBuilt = true
    end,

--------------------------------------------------------------------------------
--  Summary:  The Paragon restricter script
--------------------------------------------------------------------------------    

    RestrictParagonUnits = function(self, strArmy)     
        AddBuildRestriction(strArmy,categories.xab1401)
        AddBuildRestriction(strArmy,categories.peb1401)
        AddBuildRestriction(strArmy,categories.prb1401)
        AddBuildRestriction(strArmy,categories.psb1401)   
    end, 

--------------------------------------------------------------------------------
--  Summary:  The team size counter script
--------------------------------------------------------------------------------    

    CountTeamSize = function(self, teams, myteam)
        if myteam == 1 then
            return 1
        else
            return table.getn(teams[myteam])
        end    
    end,

--------------------------------------------------------------------------------
--  Summary:  The table logger script
--------------------------------------------------------------------------------       

    tprint = function(self, tbl, indent)
        if not indent then indent = 0 end
        for k, v in pairs(tbl) do
            formatting = string.rep("  ", indent) .. k .. ": "
            if type(v) == "table" then
                LOG(formatting)
                self:tprint(v, indent+1)
            elseif type(v) == 'boolean' then
                LOG(formatting .. tostring(v))		
            elseif type(v) == 'string' or type(v) == 'number' then
                LOG(formatting .. v)
            else
                LOG(formatting .. type(v))
            end
        end
    end,
}