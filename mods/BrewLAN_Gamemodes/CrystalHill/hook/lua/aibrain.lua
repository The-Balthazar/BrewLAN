--------------------------------------------------------------------------------
--  Summary:  Initial Crystal Spawner, and AI interest in said Crystal
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
local OldBuildScoutLocations = AIBrain.BuildScoutLocations
local OldBuildScoutLocationsSorian = AIBrain.BuildScoutLocationsSorian
local CystalInterest = {
    Position = {ScenarioInfo.size[1]/2, 0, ScenarioInfo.size[2]/2},
    Type = 'StructuresNotMex',
    LastScouted = 0,
    LastUpdate = 0,
    Threat = 75,
    Permanent = true,
}
AIBrain = Class(AIBrain) {
    SpawnCrystal = function(self)
        local posX = ScenarioInfo.size[1]/2
        local posY = 0
        local posZ = ScenarioInfo.size[2]/2
        
        self:ForkThread(function()
            WaitSeconds(1)   
            local civs = self:GetUnitsAroundPoint(categories.STRUCTURE, Vector(posX, 0, posZ), 3)
            if civs[1] then
                for i, v in civs do
                    --LOG(v:GetAIBrain().Nickname)
                    if v:GetAIBrain().Nickname == "civilian" then
                        if i == 1 then
                            posX, posY, posZ = unpack(v:GetPosition())
                        end 
                        v:Destroy()
                    end
                end
            end
            CreateUnitHPR('ZPC0002', self:GetArmyIndex(), posX, posY, posZ, 0, 0, 0):CreateTarmac(true,true,true,false,false)
        end)
        self.PreBuilt = true
    end,
    
    BuildScoutLocations = function(self)
        OldBuildScoutLocations(self)   
        if not self.InterestList then self.InterestList = {} end
        if not self.InterestList.HighPriority then self.InterestList.HighPriority = {} end
        table.insert(self.InterestList.HighPriority,CystalInterest)   
        --AIBrain:AICrystalTactical(self)  
    end,
       
    BuildScoutLocationsSorian = function(self)
        OldBuildScoutLocationsSorian(self)
        if not self.InterestList then self.InterestList = {} end
        if not self.InterestList.HighPriority then self.InterestList.HighPriority = {} end
        table.insert(self.InterestList.HighPriority,CystalInterest)
        --AIBrain:AICrystalTactical(self)   
    end,
    
    AICrystalTactical = function(self)
        local SIS = ScenarioInfo.size
        for x = -40, 40, 20 do
            for z = -40, 40, 20 do
                if not (x == 0 and z == 0) then  
                    --LOG("THIS IS THE WAY WE LOG, THIS IS THE WAY WE LOG, NOT WITH A BANG, BUT WITH A")  
                    if not AIBrain.TacticalBases then AIBrain.TacticalBases = {} end
                    --LOG(AIBrain.TacticalBases)                               
                    local nextbase = (table.getn(AIBrain.TacticalBases) + 1)
                    local tempPos = Vector((SIS[1]/2) + x, 0, (SIS[2]/2) + z)
                    table.insert(AIBrain.TacticalBases,
                        {
                        Position = tempPos,
                        Name = 'TacticalBase'..nextbase,
                        }
                    )
                end
            end
        end            
    end,  
          
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
end
