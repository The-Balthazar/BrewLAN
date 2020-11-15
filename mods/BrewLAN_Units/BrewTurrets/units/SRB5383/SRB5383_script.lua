local FactoryAdjacentNode = import('/lua/defaultunits.lua').FactoryAdjacentNode

SEB5382 = Class(FactoryAdjacentNode) {
    NoStackAdjacencyEffect = true,

    AdjacentFactoryOnStopBuild = function(self, unitBeingBuilt, nodeID)
        local node = GetEntityById(nodeID)
        for i, v in {'RULEUTC_StealthToggle', 'RULEUTC_CloakToggle'} do
            if unitBeingBuilt:TestToggleCaps(v) then
                unitBeingBuilt:SetScriptBit(v, node:GetScriptBit(v))
            end
        end
    end,
}

TypeClass = SEB5382
