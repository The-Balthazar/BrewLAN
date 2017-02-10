--------------------------------------------------------------------------------
--  Summary:  The Gantry script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
local SAB0401OLD = SAB0401
local timeDiv = 300
local timeExp = 2
local timeCo = .2
local massDiv = 500000
local massExp = 1.5
local massCo = .5

SAB0401 = Class(SAB0401OLD) {
--------------------------------------------------------------------------------
-- AI Start Cheats -- Triggers once on built
--------------------------------------------------------------------------------
    AIStartCheats = function(self)
        SAB0401OLD.AIStartCheats(self)
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
    end,
--------------------------------------------------------------------------------
-- AI Cheats -- This script is triggered each time it starts building
--------------------------------------------------------------------------------
    AICheats = function(self)
        ------------------------------------------------------------------------
        -- Default hax, from BrewLAN actual
        ------------------------------------------------------------------------
        SAB0401OLD.AICheats(self)
        ------------------------------------------------------------------------
        -- AIX cheats
        ------------------------------------------------------------------------
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType != 'Human' and aiBrain.CheatEnabled then
            -- AI supah4x0r
            Buff.ApplyBuff(self, 'GantryAIxIncrementBonus')
            local timeAlive = GetGameTimeSeconds() - self.Time
            local enemyMass = self:CalculateEnemyMass(self)
            local timeMultiplier = timeCo * math.pow(timeAlive / timeDiv, timeExp)
            local massMultiplier = massCo * math.pow(enemyMass / massDiv, massExp)
            local totalMultiplier = 1 + timeMultiplier + massMultiplier
            local buildRate = self:GetBlueprint().Economy.BuildRate * (math.min(totalMultiplier, 16))
            self:SetBuildRate(buildRate) -- I don't know how this interacts with the base buff.
        end
    end,

    CalculateEnemyMass = function(self)
        local totalmass = 0
        for i, brain in ArmyBrains do
            if not IsAlly(self:GetAIBrain():GetArmyIndex(), brain:GetArmyIndex()) then
                totalmass = totalmass + brain:GetArmyStat("Economy_TotalProduced_Mass", 0.0).Value - brain:GetArmyStat("Economy_AccumExcess_Mass", 0.0).Value
            end
        end
        --LOG("Total enemy mass = " .. totalmass)
        return totalmass
    end,
}

TypeClass = SAB0401
end
