--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------

AIBrain = Class(AIBrain) {

--------------------------------------------------------------------------------
--  Summary:  The Paragon Decider script
--------------------------------------------------------------------------------

    ParagonOrNotCheck = function(self, strArmy)
        
        -- Checks the teams
        if not ScenarioInfo.ParagonChoicesMade then
            local myteam     
            local teams = {}
            
            --Make a table of teams with what players are in then
            for name,army in ScenarioInfo.ArmySetup do   
                if not army.Civilian then
                    if not teams[army.Team] then
                        teams[army.Team] = {}
                    end                  
                    table.insert(teams[army.Team],army.ArmyIndex) 
                end
            end
            
            -- Checks the smallest defined team size   
            local minTeamQuantity = 2147483647
            for i, v in teams do
                minTeamQuantity = math.min(minTeamQuantity, self:CountTeamSize(teams, i ))
            end
            
            --Picking who should get a paragon
            for name, army in ScenarioInfo.ArmySetup do    
                if not army.Civilian then
                    if self:CountTeamSize(teams, army.Team ) == minTeamQuantity or ScenarioInfo.Options.TeamLock != 'locked' then
                        army.ShouldGetParagon = true
                        LOG("HELLO MY NAME IS ARMY_" .. army.ArmyIndex .. " and i am on one of the smallest teams, or teams aren't locked" )
                    end     
                end
            end
            ScenarioInfo.ParagonChoicesMade = true
        end
        if ScenarioInfo.ArmySetup[strArmy].ShouldGetParagon then
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
                    local distance = math.min(60, math.max(20, ScenarioInfo.size[1]/50))
                    local dangerzone = distance + 10
                
                    local MapSizeX = ScenarioInfo.size[1]
                    local MapSizeY = ScenarioInfo.size[2]
                    
                    local unit
                    
                    if posY < dangerzone or posX < dangerzone or posY > (MapSizeY - dangerzone) or posX > (MapSizeX - dangerzone) then 
                        --build towards the center if we are too close to the edge
                        unit = self:CreateUnitNearSpot(u[1], posX - math.sin(math.atan2(posX - (MapSizeX / 2),posY - (MapSizeY / 2)))*distance, posY - math.cos(math.atan2(posX - (MapSizeX / 2),posY - (MapSizeY / 2)))*distance)
                    elseif VDist2(MapSizeX / 2, MapSizeY / 2, posX, posY) / 2 < distance then
                        --build between here and center if we are within the 'distance' of the center
                        unit = self:CreateUnitNearSpot(u[1], (posX + (MapSizeX/2) ) / 2, (posY + (MapSizeY/2) ) / 2 )
                    else
                        --build away from the center
                        unit = self:CreateUnitNearSpot(u[1], posX + math.sin(math.atan2(posX - (MapSizeX / 2),posY - (MapSizeY / 2)))*distance, posY + math.cos(math.atan2(posX - (MapSizeX / 2),posY - (MapSizeY / 2)))*distance)
                    end
                
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
    
}