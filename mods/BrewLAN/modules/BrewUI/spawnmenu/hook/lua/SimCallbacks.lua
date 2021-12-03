
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

    local count = tonumber(data.count) or 1
    local squareX = math.ceil(math.sqrt(count))
    local squareZ = math.ceil(count/squareX)
    local startOffsetX = (squareX-1) * 0.5 * offsetX
    local startOffsetZ = (squareZ-1) * 0.5 * offsetZ

    for i = 1, count do
        local x = RoundToSkirt('x', posX - startOffsetX + math.mod(i,squareX) * offsetX)
        local z = RoundToSkirt('z', posZ - startOffsetZ + math.mod(math.floor(i/squareX), squareZ) * offsetZ)
        CreateUnitHPR(data.bpId, data.army, x, GetTerrainHeight(x,z), z, 0, 0, 0)
    end
end
