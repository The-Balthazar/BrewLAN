
local UnitOld = Unit

Unit = Class(UnitOld) {

    StopBeingBuiltEffects = function(self, builder, layer)
        local bp = self:GetBlueprint().Display
        local useTerrainType = false
        if bp then
            if bp.TerrainMeshes then
                local bpTM = bp.TerrainMeshes
                local pos = self:GetPosition()
                local terrainType = GetTerrainType( pos[1], pos[3] )
                if bpTM[terrainType.Style] then
                    self:SetMesh(bpTM[terrainType.Style], true)
                    useTerrainType = true
                end
            end
            if not useTerrainType then
                self:SetMesh(bp.MeshBlueprint, true)
            end
        end
        self.OnBeingBuiltEffectsBag:Destroy()
    end,

}
