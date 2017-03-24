do
    OldWallStructureUnit = WallStructureUnit
    local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
    local GetTerrainAngles = import(BrewLANPath .. '/lua/TerrainUtils.lua').GetTerrainSlopeAnglesDegrees
    WallStructureUnit = Class(OldWallStructureUnit) {
        OnStopBeingBuilt = function(self,builder,layer)
            OldWallStructureUnit.OnStopBeingBuilt(self,builder,layer)
            local bp = self:GetBlueprint()
            local Angles = GetTerrainAngles(self:GetPosition(),{bp.Footprint.SizeX or bp.Physics.SkirtSizeX, bp.Footprint.SizeZ or bp.Physics.SkirtSizeZ})
            self.TerrainSlope = {
            --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
                CreateRotator(self, 0, 'z', -Angles[1], 1000, 1000, 1000),
                CreateRotator(self, 0, 'x', Angles[2], 1000, 1000, 1000)
            }
        end
    }
end
