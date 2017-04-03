function GetTerrainSlopeAngles(pos, box)
    --Reject if pos isn't a table, or if box isn't a number or table, unless there is no box
    --We are just going to asume pos is a co-ord if its a table.
    if
      type(pos) != "table"
    or not
      (
        type(box) == "nil"
      or
        type(box) == "number"
      or
        type(box) == "table"
      )
    then
        return
    end
    --Sanitise box into a table
    if type(box) == "number" or type(box) == "nil" then
        box = {(box or 1)*0.5, (box or 1)*0.5}
    --If we made it here, we already know its a table
    elseif type(box[1]) == "number" and type(box[2]) == "number" then
        box = {box[1] * 0.5, box[2] * 0.5}
    else
        return
    end
    --Get heights
    local Heights = {
        GetTerrainHeight(pos[1]-box[1],pos[3]), GetTerrainHeight(pos[1],pos[3]-box[2])
    }
    --Get averages if its 2 squares or bigger, bearing in mind the number was halved.
    if math.max(box[1],box[2]) >= 1 then
        Heights[3] = GetTerrainHeight(pos[1]+box[1],pos[3])
        Heights[4] = GetTerrainHeight(pos[1],pos[3]+box[2])
    end
    --Subtract center height
    for i, v in Heights do
        Heights[i] = v - pos[2]
    end
    --Calculate angles
    local Angles = {}
    for i, v in Heights do
        Angles[i] = math.atan(Heights[i]/box[math.mod(i-1,2)+1])
    end
    --Condence down to average if they were calculated
    if table.getn(Angles) == 4 then
        Angles = {(Angles[1]-Angles[3])/2,(Angles[2]-Angles[4])/2}
    end
    return Angles
end

function GetTerrainSlopeAnglesDegrees(pos, box)
    local Angles = GetTerrainSlopeAngles(pos, box)
    for i, v in Angles do
        Angles[i] = math.deg(Angles[i])
    end
    return(Angles)
end

function GetBoneTerrainOffset(unit, bone)
    local pos = 1 pos = unit:GetPosition(bone)
    return GetTerrainHeight(pos[1],pos[3]) - pos[2]
end

function OffsetBoneToTerrain(unit, bone)
    local bp = unit:GetBlueprint()
    local sizemult = 1 / bp.Display.UniformScale
    local direction = unit:GetBoneDirection(bone)
    LOG(direction)
    if not unit.TerrainSlope then unit.TerrainSlope = {} end
    --CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,
    LOG(GetBoneTerrainOffset(unit, bone))
    unit.TerrainSlope[bone] = CreateSlider(unit, bone, 0, 0, GetBoneTerrainOffset(unit, bone) * sizemult, 1000)
end
