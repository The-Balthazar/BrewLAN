--------------------------------------------------------------------------------
--  Summary:  The Gantry script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
local SEB0401OLD = SEB0401
local Utilities = import('/lua/utilities.lua')
local Buff = import('/lua/sim/Buff.lua')

SEB0401 = Class(SEB0401OLD) {
--------------------------------------------------------------------------------
-- AI Cheats -- This script is triggered each time it starts building
-- Yes, that means a new fork thread is made each time. I know its bad.
--------------------------------------------------------------------------------
    AICheats = function(self)
        local aiBrain = self:GetAIBrain()
        ------------------------------------------------------------------------
        -- Default hax, from BrewLAN actual
        ------------------------------------------------------------------------
        SEB0401OLD.AICheats(self)
        ------------------------------------------------------------------------
        -- AIX cheats
        ------------------------------------------------------------------------
        if aiBrain.BrainType != 'Human' and aiBrain.CheatEnabled then
            self:ForkThread(
                function()
                    self:SetBuildRate( self:GetBlueprint().Economy.BuildRate * (math.min(2.5+(GetGameTimeSeconds()/120-self.Time/120), 25)) )
                    while aiBrain:GetEconomyIncome( 'MASS' ) > 0 and aiBrain:GetEconomyIncome( 'ENERGY' ) > 0 do
                        if aiBrain:GetEconomyIncome( 'MASS' ) < aiBrain:GetEconomyRequested('MASS') or aiBrain:GetEconomyIncome( 'ENERGY' ) < aiBrain:GetEconomyRequested('ENERGY') then
                            aiBrain:GiveResource('Mass',100 * 0.5) --Halved rate because AIx now get a base 50% discount
                            aiBrain:GiveResource('Energy',1000 * 0.5)
                        end
                        WaitSeconds(1)
                    end
                end
            )
        end
    end,
}

TypeClass = SEB0401
end
