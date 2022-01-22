local FactoryAdjacentNode = import('/lua/defaultunits.lua').FactoryAdjacentNode
local Buff = import(import( '/lua/game.lua' ).BrewLANPath .. '/lua/legacy/VersionCheck.lua').Buff

if not Buffs['FactoryNodeHealthBuff'] then
    BuffBlueprint {
        Name = 'FactoryNodeHealthBuff',
        DisplayName = 'FactoryNodeHealthBuff',
        BuffType = 'FactoryNodeHealthBuff',
        Stacks = 'ALWAYS',
        Duration = -1,
        Affects = {
            MaxHealth = {Add = 0, Mult = 1.05},
        },
    }
end

SEB5382 = Class(FactoryAdjacentNode) {
    NoStackAdjacencyEffect = false,

    AdjacentFactoryOnStopBuild = function(self, unitBeingBuilt, nodeID)
        Buff.ApplyBuff(unitBeingBuilt, 'FactoryNodeHealthBuff')
    end,
}

TypeClass = SEB5382
