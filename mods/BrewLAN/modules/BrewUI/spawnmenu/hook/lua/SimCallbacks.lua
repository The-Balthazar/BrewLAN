local SpawnedMeshes = {}

local function SpawnUnitMesh(id, x, y, z, pitch, yaw, roll)
    local bp = __blueprints[id]
    local bpD = bp.Display
    if __blueprints[bpD.MeshBlueprint] then
        SPEW("Spawning mesh of "..id)
        local entity = import('/lua/sim/Entity.lua').Entity()
        if bp.CollisionOffsetY and bp.CollisionOffsetY < 0 then
            y = y-bp.CollisionOffsetY
        end
        entity:SetPosition(Vector(x,y,z), true)
        entity:SetMesh(bpD.MeshBlueprint)
        entity:SetDrawScale(bpD.UniformScale)
        entity:SetVizToAllies('Intel')
        entity:SetVizToNeutrals('Intel')
        entity:SetVizToEnemies('Intel')
        table.insert(SpawnedMeshes, entity)
    else
        SPEW("Can\' spawn mesh of "..id.." no mesh found")
    end
end

Callbacks.ClearSpawneMeshes = function()
    for i, v in SpawnedMeshes do
        v:Destroy()
    end
    SpawnedMeshes = {}
end

Callbacks.BoxFormationSpawn = function(data)
    if not CheatsEnabled() then return end
    local unitbp = __blueprints[data.bpId]

    local function FootprintSize(axe)
        axe = axe == 'x' and 'SizeX' or 'SizeZ' --local axes = {x='SizeX', z='SizeZ'}
        return unitbp.Footprint
        and unitbp.Footprint[axe]
        or unitbp[axe]
        or 1
    end

    local function RoundToSkirt(axe, val)
        return unitbp.Physics.MotionType ~= 'RULEUMT_None'
        and val
        or math.floor(val) + (math.mod(FootprintSize(axe),2) == 1 and 0.5 or 0)
    end

    local posX = math.floor(data.pos[1])
    local posZ = math.floor(data.pos[3])
    local offsetX = unitbp.SizeX or 1
    local offsetZ = unitbp.SizeZ or 1

    if unitbp.Physics.MotionType == 'RULEUMT_None' then
        offsetX = math.ceil(unitbp.Physics.SkirtSizeX or FootprintSize('x'))
        offsetZ = math.ceil(unitbp.Physics.SkirtSizeZ or FootprintSize('y'))
    end

    local squareX = math.ceil(math.sqrt(data.count))
    local squareZ = math.ceil(data.count/squareX)
    local startOffsetX = (squareX-1) * 0.5 * offsetX
    local startOffsetZ = (squareZ-1) * 0.5 * offsetZ

    local yaw = (data.yaw or 0) / 57.295779513

    for i = 1, data.count do
        local x = RoundToSkirt('x', posX - startOffsetX + math.mod(i,squareX) * offsetX)
        local z = RoundToSkirt('z', posZ - startOffsetZ + math.mod(math.floor(i/squareX), squareZ) * offsetZ)
        local unit = not data.MeshOnly and CreateUnitHPR(data.bpId, data.army, x, GetTerrainHeight(x,z), z, 0, yaw, 0)--blueprint, army, x, y, z, pitch, yaw, roll
        or SpawnUnitMesh(data.bpId, x, GetTerrainHeight(x,z), z, 0, yaw, 0)

        if unit.SetVeterancy then unit:SetVeterancy(data.veterancy) end
        if data.CreateTarmac and unit.CreateTarmac and __blueprints[data.bpId].Display and __blueprints[data.bpId].Display.Tarmacs then
            unit:CreateTarmac(true,true,true,false,false)
        end
    end
end

Callbacks.BoxFormationProp = function(data)
    if not CheatsEnabled() then return end

    local offsetX = data.bpId.SizeX or 1
    local offsetZ = data.bpId.SizeZ or 1

    local squareX = math.ceil(math.sqrt(data.count))
    local squareZ = math.ceil(data.count/squareX)

    local startOffsetX = (squareX-1) * 0.5 * offsetX
    local startOffsetZ = (squareZ-1) * 0.5 * offsetZ

    for i = 1, data.count do
        local x = data.pos[1] - startOffsetX + math.mod(i,squareX) * offsetX
        local z = data.pos[3] - startOffsetZ + math.mod(math.floor(i/squareX), squareZ) * offsetZ
        CreatePropHPR(data.bpId, x, GetTerrainHeight(x,z), z, data.yaw or 0, 0, 0)--blueprint, x, y, z, heading, pitch, roll
    end
end
