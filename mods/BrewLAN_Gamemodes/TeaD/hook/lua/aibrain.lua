--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
AIBrain = Class(AIBrain) {
--------------------------------------------------------------------------------
--  AIOnlyTeam Check: Returns true if a player is an AI on an AI only team.
--------------------------------------------------------------------------------
    AIOnlyTeam = function(self, strArmy)
        local TeamGame = false
        local AiTeam = true
        --If we are on the free team (-), which is index 1, and an AI, we are a lonely AI
        if
          not (ScenarioInfo.ArmySetup[strArmy].Team == 1 and GetArmyBrain(strArmy).BrainType != 'Human')
          or
          GetArmyBrain(strArmy).BrainType != 'Human' and ScenarioInfo.ArmySetup[strArmy].Team > 1 then
            for name, army in ScenarioInfo.ArmySetup do
                if army.Human == true and army.Team == ScenarioInfo.ArmySetup[strArmy].Team then
                    AiTeam = false
                    break
                end
            end     
        end
        if GetArmyBrain(strArmy).BrainType == 'Human' then
            AiTeam = false
        end
        if ScenarioInfo.TeamGame == true or ScenarioInfo.Options.TeamLock == 'locked' then
            TeamGame = true                        
        end
        return AiTeam, TeamGame
    end,

    SpawnCreepGates = function(self)
        for name, army in ScenarioInfo.ArmySetup do
            if not self:AIOnlyTeam(name) then
                local posX, posY = GetArmyBrain(name):GetArmyStartPos()
                local MapSizeX = ScenarioInfo.size[1]
                local MapSizeY = ScenarioInfo.size[2]
                local distance = math.min(MapSizeX - posX, posX, MapSizeY - posY, posY) * 0.75
                local gate = self:CreateUnitNearSpot('tec0000', posX + math.sin(math.atan2(posX - (MapSizeX / 2),posY - (MapSizeY / 2)))*distance, posY + math.cos(math.atan2(posX - (MapSizeX / 2),posY - (MapSizeY / 2)))*distance)
                gate.Target = name
            end
        end
    end,
    
    SpawnLifeCrystal = function(self)
        local posX, posY = self:GetArmyStartPos()
        local MapSizeX = ScenarioInfo.size[1]*.5
        local MapSizeY = ScenarioInfo.size[2]*.5
        local Dis = 20
        local X = (posX + (MapSizeX * Dis) ) /(Dis + 1)
        local Y = (posY + (MapSizeY * Dis) ) /(Dis + 1)
        local crystal = self:CreateUnitNearSpot('tpc0000', X, Y)
        
        if not crystal then
            crystal = CreateUnitHPR('tpc0000', self:GetArmyIndex(), X, 0, Y,0,0,0)
        end   
        crystal:CreateTarmac(true,true,true,false,false)
        self.LifeCrystalPos = crystal:GetPosition()
    end,
}