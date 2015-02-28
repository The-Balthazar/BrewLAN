--------------------------------------------------------------------------------
--  Summary:  The Gantry script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------

local TLandFactoryUnit = SEB0401
local Utilities = import('/lua/utilities.lua')    
local Buff = import('/lua/sim/Buff.lua')   

SEB0401 = Class(TLandFactoryUnit) {    
--------------------------------------------------------------------------------
-- AI Cheats -- This script is triggered each time it starts building
--------------------------------------------------------------------------------   
    AIxCheats = function(self)               
        local aiBrain = self:GetAIBrain()    
        ------------------------------------------------------------------------
        -- Default hax, from BrewLAN actual
        ------------------------------------------------------------------------   
        TLandFactoryUnit.AIxCheats(self)     
        ------------------------------------------------------------------------
        -- AIX cheats
        ------------------------------------------------------------------------    
        if aiBrain.BrainType != 'Human' and aiBrain.CheatEnabled then       
            self:ForkThread(
                function()
                    local timealive = GetGameTimeSeconds()-self.Time
                    local timediv = 300
                    local timeexp = 2   
                    local timeco = .2
                    local enemymass = self:CalculatEnemyMass(self)
                    local enemymassdiv = 500000
                    local enemymassexp = 2
                    local enemymassco = .5
                    self:SetBuildRate( self:GetBlueprint().Economy.BuildRate * (math.min(  1  + timeco * math.pow(timealive/timediv,timeexp) + enemymassco * math.pow(enemymass/enemymassdiv, enemymassexp)  , 25) ) )
                    LOG("THIS IS THE WAY WE DIE " .. (math.min(  1  +  math.pow(timealive/timediv,timeexp)  +  math.pow(enemymass/enemymassdiv, enemymassexp)  , 25)) .. " which is time " .. math.pow(timealive/timediv,timeexp) .. " and mass " .. math.pow(enemymass/enemymassdiv, enemymassexp) )
                    while aiBrain:GetEconomyIncome( 'MASS' ) > 0 and aiBrain:GetEconomyIncome( 'ENERGY' ) > 0 do
                        if aiBrain:GetEconomyIncome( 'MASS' ) < aiBrain:GetEconomyRequested('MASS') or aiBrain:GetEconomyIncome( 'ENERGY' ) < aiBrain:GetEconomyRequested('ENERGY') then
                            aiBrain:GiveResource('Mass',100)
                            aiBrain:GiveResource('Energy',1000)
                        end    
                        WaitSeconds(1)
                    end
                end
            )    
        ------------------------------------------------------------------------
        -- Regular minor-ai cheats
        ------------------------------------------------------------------------               
        elseif aiBrain.BrainType != 'Human' and not aiBrain.CheatEnabled then
            self:SetBuildRate( self:GetBlueprint().Economy.BuildRate * 2.5 )  
        end
    end,
    
    CalculatEnemyMass = function(self)
        local totalmass = 0
        for i, brain in ArmyBrains do
            if not IsAlly(self:GetAIBrain():GetArmyIndex(), brain:GetArmyIndex()) then
                totalmass = totalmass + brain:GetArmyStat("Economy_TotalProduced_Mass", 0.0).Value - brain:GetArmyStat("Economy_AccumExcess_Mass", 0.0).Value
            end
        end
        LOG("total mass: " .. totalmass)
        return totalmass
    end,
}

TypeClass = SEB0401