local timeDiv = 300
local timeExp = 2
local timeCo = .2
local massDiv = 500000
local massExp = 1.5
local massCo = .5

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
        if not Buffs['GantryAIxIncrementBonus'] then
            BuffBlueprint {
                Name = 'GantryAIxIncrementBonus',
                DisplayName = 'GantryAIxIncrementBonus',
                BuffType = 'GANTRYINCREMENTBONUS',
                Stacks = 'ALWAYS',
                Duration = -1,
                Affects = {
                    EnergyActive = {
                        Add = 0,
                        Mult = 0.975,
                    },
                    MassActive = {
                        Add = 0,
                        Mult = 0.975,
                    },
                },
            }
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
            Buff.ApplyBuff(self, 'GantryAIxIncrementBonus')
            local timeAlive = GetGameTimeSeconds() - self.Time
            local enemyMass = CalculateEnemyMass(self)
            local timeMultiplier = timeCo * math.pow(timeAlive / timeDiv, timeExp)
            local massMultiplier = massCo * math.pow(enemyMass / massDiv, massExp)
            local totalMultiplier = 1 + timeMultiplier + massMultiplier
            local buildRate = self:GetBlueprint().Economy.BuildRate * (math.min(totalMultiplier, 16))
            self:SetBuildRate(buildRate) -- I don't know how this interacts with the base buff.
        end
    end
end
