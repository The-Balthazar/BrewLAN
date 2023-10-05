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
        entity:SetVizToAllies'Intel'
        entity:SetVizToNeutrals'Intel'
        entity:SetVizToEnemies'Intel'
        table.insert(SpawnedMeshes, entity)
        return entity
    else
        SPEW("Can\' spawn mesh of "..id.." no mesh found")
    end
end

local function ShowRaisedPlatforms(self)
    local plats = self:GetBlueprint().Physics.RaisedPlatforms
    if not plats then return end
    local pos = self:GetPosition()
    local entities = {}
    for i=1, (table.getn(plats)/12) do
        entities[i]={}
        for b=1,4 do
            entities[i][b] = import('/lua/sim/Entity.lua').Entity{Owner = self}
            self.Trash:Add(entities[i][b])
            entities[i][b]:SetPosition(Vector(
                pos[1]+plats[((i-1)*12)+(b*3)-2],
                pos[2]+plats[((i-1)*12)+(b*3)],
                pos[3]+plats[((i-1)*12)+(b*3)-1]
            ), true)
        end
        self.Trash:Add(AttachBeamEntityToEntity(entities[i][1], -2, entities[i][2], -2, self:GetArmy(), '/effects/emitters/build_beam_01_emit.bp'))
        self.Trash:Add(AttachBeamEntityToEntity(entities[i][1], -2, entities[i][3], -2, self:GetArmy(), '/effects/emitters/build_beam_01_emit.bp'))
        self.Trash:Add(AttachBeamEntityToEntity(entities[i][4], -2, entities[i][2], -2, self:GetArmy(), '/effects/emitters/build_beam_01_emit.bp'))
        self.Trash:Add(AttachBeamEntityToEntity(entities[i][4], -2, entities[i][3], -2, self:GetArmy(), '/effects/emitters/build_beam_01_emit.bp'))
    end
end

local function SetWorldCameraToUnitIconAngle(location, zoom)
    local sx = 1/6
    local th = 1 + (location[2] - GetSurfaceHeight(location[1], location[3]))
    --_ALERT(location[2], GetSurfaceHeight(location[1], location[3]), th)
    --_ALERT(zoom, th)
    table.insert( Sync.CameraRequests, {
        Name = 'WorldCamera',
        Type = 'CAMERA_UNIT_SPIN',
        Marker = {
            orientation = VECTOR3(math.pi*(1+sx), math.pi*sx, 0),
            position = location,
            zoom = FLOAT(zoom*th),
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

--[[Callbacks.BoxFormationSpawn = function(data)
    if not CheatsEnabled() then return end
    if data.army < 0 then return end
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
        offsetX = math.ceil(unitbp.Physics.SkirtSizeX or FootprintSize'x')
        offsetZ = math.ceil(unitbp.Physics.SkirtSizeZ or FootprintSize'y')
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
        if data.count == 1 and data.UnitIconCameraMode and unit then
            local size = math.max(
                (unitbp.SizeX or 1),
                (unitbp.SizeY or 1) * 3,
                (unitbp.SizeZ or 1),
                (unitbp.Physics.SkirtSizeX or 1),
                (unitbp.Physics.SkirtSizeZ or 1)
            ) + math.abs(unitbp.CollisionOffsetY or 0)
            local dist = size / math.tan(60 --[=[* (9/16)]=] * 0.5 * ((math.pi*2)/360))
            SetWorldCameraToUnitIconAngle(unit:GetPosition(), dist)
        end
    end
end]]

Callbacks.BoxFormationProp = function(data)
    if not CheatsEnabled() then return end

    local offsetX = data.bpId.SizeX or 1
    local offsetZ = data.bpId.SizeZ or 1

    local squareX = math.ceil(math.sqrt(data.count or 1))
    local squareZ = math.ceil((data.count or 1)/squareX)

    local startOffsetX = (squareX-1) * 0.5 * offsetX
    local startOffsetZ = (squareZ-1) * 0.5 * offsetZ

    for i = 1, (data.count or 1) do
        local x = data.pos[1] - startOffsetX + math.mod(i,squareX) * offsetX
        local z = data.pos[3] - startOffsetZ + math.mod(math.floor(i/squareX), squareZ) * offsetZ
        if data.rand and data.rand ~= 0 then
            x = (x - data.rand*0.5) + data.rand*Random()
            z = (z - data.rand*0.5) + data.rand*Random()
            if math.mod(data.yaw or 0, 360) == 0 then
                data.yaw = 360*Random()
            end
        end
        CreatePropHPR(data.bpId, x, GetTerrainHeight(x,z), z, data.yaw or 0, 0, 0)--blueprint, x, y, z, heading, pitch, roll
    end
end

--[[local function TemplateAxisOffset(unitbp, axe)
    return (math.mod(math.ceil(unitbp.Footprint and unitbp.Footprint[axe] or unitbp[axe] or 1), 2) == 1 and 0 or 0.5)
end]]

--[[Callbacks.CheatSpawnTemplate = function(data)
    local templateData = data.bpId.templateData
    local basePos = data.pos
    --_ALERT(repr(basePos))
    local firstbp = __blueprints[ templateData[3][1] ]

    --This is the same offset added by the save script, because what fixes the build command mode, breaks this.
    local offsetX, offsetZ = TemplateAxisOffset(firstbp, 'SizeX'), TemplateAxisOffset(firstbp, 'SizeZ')
    for i = 3, table.getn(templateData) do
        local id = templateData[i][1]
        local x, z = basePos[1] + templateData[i][3] - offsetX, basePos[3] + templateData[i][4] - offsetZ

        local unit = CreateUnitHPR(id, data.army, x, GetTerrainHeight(x,z), z, 0, 0, 0)

        local unitbp = __blueprints[id]
        if data.CreateTarmac and unit.CreateTarmac and unitbp.Display and unitbp.Display.Tarmacs then
            unit:CreateTarmac(true,true,true,false,false)
        end
    end
end]]

Callbacks.CheatSpawnUnit = function(data)
    if not CheatsEnabled() then return end

    local pos = data.pos
    if data.MeshOnly then
        SpawnUnitMesh(data.bpId, pos[1], pos[2], pos[3], 0, data.yaw, 0)
    else
        local unit = CreateUnitHPR(data.bpId, data.army, pos[1], pos[2], pos[3], 0, data.yaw, 0)
        local unitbp = __blueprints[data.bpId]
        if data.CreateTarmac and unit.CreateTarmac and unitbp.Display and unitbp.Display.Tarmacs then
            unit:CreateTarmac(true,true,true,false,false)
        end
        if data.UnitIconCameraMode then
            local size = math.max(
                (unitbp.SizeX or 1),
                (unitbp.SizeY or 1) * 3,
                (unitbp.SizeZ or 1),
                (unitbp.Physics.SkirtSizeX or 1),
                (unitbp.Physics.SkirtSizeZ or 1)
            ) + math.abs(unitbp.CollisionOffsetY or 0)
            local dist = size / math.tan(60 --[[* (9/16)]] * 0.5 * ((math.pi*2)/360))
            SetWorldCameraToUnitIconAngle(pos, dist)
        end
        if data.veterancy and data.veterancy ~= 0 and unit.SetVeterancy then
            unit:SetVeterancy(data.veterancy)
        end
        if data.ShowRaisedPlatforms then
            ShowRaisedPlatforms(unit)
        end
    end
end
