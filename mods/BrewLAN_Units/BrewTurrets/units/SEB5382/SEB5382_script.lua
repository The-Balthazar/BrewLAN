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
    --[[
    --When we're adjacent, try to all all the possible bonuses.
    OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
        if self:IsBeingBuilt() then return end
        if adjacentUnit:IsBeingBuilt() then return end
        self:HookAdjacentFactoryFunctions(adjacentUnit)
        TStructureUnit.OnAdjacentTo(self, adjacentUnit, triggerUnit)
    end,

    --When we're not adjacent, try to remove all the possible bonuses.
    OnNotAdjacentTo = function(self, adjacentUnit)
        self:HookAdjacentFactoryFunctions(adjacentUnit, true)
        TStructureUnit.OnNotAdjacentTo(self, adjacentUnit)
    end,

    HookAdjacentFactoryFunctions = function(self, adjacentUnit, remove)
        if EntityCategoryContains(categories.FACTORY, adjacentUnit) then
            --OnStartBuild = function(self, unitBeingBuilt, order )
            -- Proof of concept. This implementation shits the bed if it's used by more than one type of node
            -- Since when one is removed it will remove the most recent hook, not the correct one
            -- As it functions by just stacking hooks
            if not remove then
                local oldOnStartBuild = adjacentUnit.OnStartBuild
                adjacentUnit.OnStartBuild = function(self, unitBeingBuilt, order, revert)
                    if revert then
                        return oldOnStartBuild
                    else
                        oldOnStartBuild(self, unitBeingBuilt, order)
                        Buff.ApplyBuff(unitBeingBuilt, 'FactoryNodeHealthBuff')
                    end
                end
            else
                local fun = adjacentUnit.OnStartBuild(adjacentUnit, nil, nil, true)
                if type(fun) == 'function' then
                    adjacentUnit.OnStartBuild = fun
                end
            end
        end
    end,]]
}

TypeClass = SEB5382
