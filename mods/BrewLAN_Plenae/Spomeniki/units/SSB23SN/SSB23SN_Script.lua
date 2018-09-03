local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SDFExperimentalPhasonProj = import ('/lua/seraphimweapons.lua').SDFExperimentalPhasonProj
local Entity = import('/lua/sim/Entity.lua').Entity

SSB23SN = Class(SStructureUnit) {
    Weapons = {
        EyeWeapon = Class(SDFExperimentalPhasonProj) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        local bp = self:GetBlueprint()
        local path = string.gsub(bp.Source, 'unit.bp', 'wing')
        local drawscale = bp.Display.UniformScale or 1
        local entity, lastent
        for i = 1, 3 do
            entity = Entity({Owner = self})
            if lastent then
                entity:AttachBoneTo( -1, lastent, 0 )
            else
                entity:AttachBoneTo( -1, self, 'Head' )
            end
            entity:SetMesh(path .. i .. '_mesh')
            entity:SetDrawScale(drawscale)
            entity:SetVizToAllies('Intel')
            entity:SetVizToNeutrals('Intel')
            entity:SetVizToEnemies('Intel')
            self.Trash:Add(entity)
            lastent = entity
        end
        SStructureUnit.OnStopBeingBuilt(self, builder, layer)
    end,
}

TypeClass = SSB23SN
