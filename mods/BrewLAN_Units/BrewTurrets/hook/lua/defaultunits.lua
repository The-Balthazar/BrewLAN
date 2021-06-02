FactoryAdjacentNode = Class(StructureUnit) {
    NoStackAdjacencyEffect = false,

    OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
        if self:IsBeingBuilt() then return end
        if adjacentUnit:IsBeingBuilt() then return end
        if self.AdjacentFactoryOnStopBuild and self:HookAdjacentFactoryFunctions(adjacentUnit) then
            StructureUnit.CreateAdjacentEffect(self, adjacentUnit)
        end
        StructureUnit.OnAdjacentTo(self, adjacentUnit, triggerUnit)
    end,

    OnNotAdjacentTo = function(self, adjacentUnit)
        if self.AdjacentFactoryOnStopBuild then
            self:HookAdjacentFactoryFunctions(adjacentUnit, true)
            StructureUnit.DestroyAdjacentEffects(self, adjacentUnit)
        end
        StructureUnit.OnNotAdjacentTo(self, adjacentUnit)
    end,

    HookAdjacentFactoryFunctions = function(self, adjacentUnit, remove)
        if EntityCategoryContains(categories.FACTORY, adjacentUnit) then
            if not remove then
                --If the factories never been touched before, change it's function
                if not adjacentUnit.NodeOnStopBuildFunctions then
                    adjacentUnit.NodeOnStopBuildFunctions = {}
                    local oldOnStopBuild = adjacentUnit.OnStopBuild
                    adjacentUnit.OnStopBuild = function(self, unitBeingBuilt, order, ...)
                        --Do the old stuff first,
                        oldOnStopBuild(self, unitBeingBuilt, order, unpack(arg))
                        if unitBeingBuilt and unitBeingBuilt:GetFractionComplete() == 1 then
                            --Pairs to make sure it'S not using ipairs, which will cause issues for a non-sequential array
                            for nodeID, fun in pairs(self.NodeOnStopBuildFunctions) do
                                --Get node functions and run them
                                fun(self, unitBeingBuilt, nodeID)
                            end
                        end
                    end
                end
                --Some effects don't need to stack, or shouldn't
                if self.NoStackAdjacencyEffect then
                    for nodeID, fun in adjacentUnit.NodeOnStopBuildFunctions do
                        local node = GetEntityById(nodeID)
                        if (node.BpId and __blueprints[node.BpId] or node:GetBlueprint().BlueprintId) == (self.BpId and __blueprints[self.BpId] or self:GetBlueprint().BlueprintId) then
                            --Return for the adjacency connection check
                            return false
                        end
                    end
                end
                --Keep track of each nodes function, so we can remove them easily
                adjacentUnit.NodeOnStopBuildFunctions[self:GetEntityId()] = self.AdjacentFactoryOnStopBuild
            elseif adjacentUnit and adjacentUnit.NodeOnStopBuildFunctions then
                --Remove this nodes function. If this is the last one, there's no harm in
                --leaving the factory's hooked function the same for future possible nodes
                adjacentUnit.NodeOnStopBuildFunctions[self:GetEntityId()] = nil
            end
            --If we got here, we did what needed to be done.
            return true
        end
        --If we got here, nothing was to be done, so just return nil.
    end,

    --AdjacentFactoryOnStopBuild = function(self, unitBeingBuilt, nodeID)
    --end,
}
