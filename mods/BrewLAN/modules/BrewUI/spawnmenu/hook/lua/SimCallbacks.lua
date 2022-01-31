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

local function SetWorldCameraToUnitIconAngle(location, zoom)
    local sx = 1/6
    table.insert( Sync.CameraRequests, {
        Name = 'WorldCamera',
        Type = 'CAMERA_UNIT_SPIN',
        Marker = {
            orientation = VECTOR3(math.pi*(1+sx), math.pi*sx, 0),
            position = location,
            zoom = FLOAT(zoom),
        },
        HeadingRate = 0,
        Callback = {
            Func = 'OnCameraFinish',
            Args = 'WorldCamera',
        }
    })
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
        or math.ceil(unitbp[axe] or 1)
    end

    local function RoundToSkirt(axe, val)
        local alignment = math.mod(FootprintSize(axe),2) == 1
        return unitbp.Physics.MotionType ~= 'RULEUMT_None' and val
        or math.floor(val + (alignment and 0 or 0.5)) + (alignment and 0.5 or 0)
    end

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
        local x = RoundToSkirt('x', (data.pos[1]) - startOffsetX + math.mod(i,squareX) * offsetX)
        local z = RoundToSkirt('z', (data.pos[3]) - startOffsetZ + math.mod(math.floor(i/squareX), squareZ) * offsetZ)
        local unit = not data.MeshOnly and CreateUnitHPR(data.bpId, data.army, x, GetTerrainHeight(x,z), z, 0, yaw, 0)--blueprint, army, x, y, z, pitch, yaw, roll
        or SpawnUnitMesh(data.bpId, x, GetTerrainHeight(x,z), z, 0, yaw, 0)

        if unit.SetVeterancy then unit:SetVeterancy(data.veterancy) end
        if data.CreateTarmac and unit.CreateTarmac and unitbp.Display and unitbp.Display.Tarmacs then
            unit:CreateTarmac(true,true,true,false,false)
        end
        if data.count == 1 and data.UnitIconCameraMode then
            local size = math.max(
                (unitbp.SizeX or 1),
                (unitbp.SizeY or 1) * 3,
                (unitbp.SizeZ or 1),
                (unitbp.Physics.SkirtSizeX or 1),
                (unitbp.Physics.SkirtSizeZ or 1)
            ) + math.abs(unitbp.CollisionOffsetY or 0)
            local dist = size / math.tan(60 --[[* (9/16)]] * 0.5 * ((math.pi*2)/360))
            SetWorldCameraToUnitIconAngle({x, GetTerrainHeight(x,z), z}, dist)
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
