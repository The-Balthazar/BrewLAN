do
    local oldDamageArea, VDist2Sq = DamageArea, VDist2Sq
    local sqrt, sin, min, log10 = math.sqrt, math.sin, math.min, math.log10

    function DamageArea(inst, pos, rad, damage, dtype, dfriend, dself)
        if damage > 200 and rad >= 1 then
            local sX, sZ = math.floor(pos[1]-rad), math.floor(pos[3]-rad)
            local eX, eZ = math.ceil(pos[1]+rad), math.ceil(pos[3]+rad)

            for x=sX, eX do
                if x<0 or x>ScenarioInfo.size[1] then continue end
                for z=sZ, eZ do
                    if z<0 or z>ScenarioInfo.size[2] then continue end
                    local dSq = VDist2Sq(x, z, pos[1], pos[3])
                    if dSq <= rad*rad then
                        local relD = sin(1-(sqrt(dSq)/rad))
                        local maxD = min(rad*0.5, log10(damage))
                        local curD = GetTerrainHeight(x, z)
                        if curD <= pos[2] then
                            local target = pos[2]-(relD*maxD)
                            if curD > target then
                                FlattenMapRect(x, z, 0, 0, target)
                            end
                        else
                            local extraD = curD-pos[2]
                            local target = pos[2]-(relD*maxD)+(extraD*(1-relD))
                            FlattenMapRect(x, z, 0, 0, target)
                        end
                    end
                end
            end
        end
        return oldDamageArea(inst, pos, rad, damage, dtype, dfriend, dself)
    end
end
