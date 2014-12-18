--------------------------------------------------------------------------------
--  Summary:  The neutral crystal spawner script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
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
                    LOG(v:GetAIBrain().Nickname)
                    if v:GetAIBrain().Nickname == "civilian" then
                        if i == 1 then
                            posX, posY, posZ = unpack(v:GetPosition())
                        end 
                        v:Destroy()
                    end
                end
            end
            CreateUnitHPR('ZPC0002', self:GetArmyIndex(), posX, posY, posZ, 0, 0, 0)
            --self:CreateUnitNearSpot('ZPC0002', posX, posZ)
        end)
        self.PreBuilt = true
    end,
}