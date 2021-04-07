local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local DisarmBeamWeapon = import('/lua/sim/defaultweapons.lua').DisarmBeamWeapon

local GetSkirtTerrainHeights = function(self)
    -- Description: Returns an index-0 grid of heights of the terrain in the skirt.
    -- Author: Sean "Balthazar" Wheeldon
    local skirtdata = {}
    local x0,z0,x1,z1 = self:GetSkirtRect()
    x0,z0,x1,z1 = math.floor(x0),math.floor(z0),math.ceil(x1),math.ceil(z1)
    for i = 0, x1-x0 do
        if not skirtdata[i] then skirtdata[i] = {} end
        for j = 0, z1-z0 do
            skirtdata[i][j] = GetTerrainHeight(x0+i, z0+j)
        end
    end
    return skirtdata
end

local SetSkirtTerrainHeights = function(self, skirtdata)
    -- Description: Sets the heights of terrain in the skirt based on inputs from an index-0 grid of values.
    -- Author: Sean "Balthazar" Wheeldon
    local x0,z0,x1,z1 = self:GetSkirtRect()
    x0,z0,x1,z1 = math.floor(x0),math.floor(z0),math.ceil(x1),math.ceil(z1)
    for i = 0, x1-x0 do
        for j = 0, z1-z0 do
            if skirtdata[i] and skirtdata[i][j] then
                FlattenMapRect(x0+i,z0+j,0,0,skirtdata[i][j])
            end
        end
    end
end

SSB2380 = Class(SStructureUnit) {
    Weapons = {
        MainGun = Class(DisarmBeamWeapon) {},
    },

    OnCreate = function(self)
        SStructureUnit.OnCreate(self)
        self:FlattenSkirt()
    end,

    FlattenSkirt = function(self)
        if not self.SkirtTerrainData then
            self.SkirtTerrainData = GetSkirtTerrainHeights(self)
        end
        local x0,z0,x1,z1 = self:GetSkirtRect()
        x0,z0,x1,z1 = math.floor(x0),math.floor(z0),math.ceil(x1),math.ceil(z1)
        FlattenMapRect(x0, z0, x1-x0, z1-z0, GetTerrainHeight(x0,z0))
    end,

    OnDestroy = function(self)
        SetSkirtTerrainHeights(self,self.SkirtTerrainData)
        SStructureUnit.OnDestroy(self)
    end,
}
TypeClass = SSB2380
