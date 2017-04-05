local timeDiv = 300
local timeExp = 2
local timeCo = .2
local massDiv = 500000
local massExp = 1.5
local massCo = .5
local massIncrement = 100
local energyIncrement = 1000

function CalculateEnemyMass(self)
    local totalmass = 0
    for i, brain in ArmyBrains do
        if not IsAlly(self:GetAIBrain():GetArmyIndex(), brain:GetArmyIndex()) then
            totalmass = totalmass + brain:GetArmyStat("Economy_TotalProduced_Mass", 0.0).Value - brain:GetArmyStat("Economy_AccumExcess_Mass", 0.0).Value
        end
    end
    --LOG("Total enemy mass = " .. totalmass)
    return totalmass
end

do
    local OldAIStartCheats = AIStartCheats
    function AIStartCheats(self, Buff)
        OldAIStartCheats(self, Buff)
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType != 'Human' and aiBrain.CheatEnabled then
            self.massIncome = 0
            self.energyIncome = 0
            self:ForkThread(
                function()
                    while true do
                        if aiBrain:GetEconomyIncome('MASS') > 0 and aiBrain:GetEconomyIncome('ENERGY') > 0
                                and (aiBrain:GetEconomyIncome('MASS') < aiBrain:GetEconomyRequested('MASS')
                                or aiBrain:GetEconomyIncome('ENERGY') < aiBrain:GetEconomyRequested('ENERGY')) then
                            aiBrain:GiveResource('Mass', self.massIncome)
                            aiBrain:GiveResource('Energy', self.energyIncome)
                        end
                        WaitSeconds(1)
                    end
                end
            )
        end
    end

    local OldAICheats = AICheats
    function AICheats(self, Buff)
        ------------------------------------------------------------------------
        -- Default hax, from BrewLAN actual
        ------------------------------------------------------------------------
        OldAICheats(self, Buff)
        ------------------------------------------------------------------------
        -- AIX cheats
        ------------------------------------------------------------------------
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType != 'Human' and aiBrain.CheatEnabled then
            -- AI supah4x0r
            self.massIncome = (self.massIncome or 0) + massIncrement
            self.energyIncome = (self.energyIncome or 0) + energyIncrement
            local timeAlive = GetGameTimeSeconds() - self.Time
            local enemyMass = CalculateEnemyMass(self)
            local timeMultiplier = timeCo * math.pow(timeAlive / timeDiv, timeExp)
            local massMultiplier = massCo * math.pow(enemyMass / massDiv, massExp)
            local totalMultiplier = 1 + timeMultiplier + massMultiplier
            local buildRate = self:GetBlueprint().Economy.BuildRate * (math.min(totalMultiplier, 16))
            self:SetBuildRate(buildRate)
        end
    end
end
