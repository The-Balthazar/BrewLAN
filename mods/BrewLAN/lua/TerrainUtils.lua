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
    local height = GetTerrainHeight(pos[1],pos[3])
    for i, v in Heights do
        Heights[i] = v - height
    end
    --Calculate angles
    local Angles = {}
    for i, v in Heights do
        Angles[i] = math.atan(Heights[i]/box[i])
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
