-- line 1532
CityData = {
    {   --UEF
        BlueprintId = 'UEF_SquareBlockCity',
        FunctionName = 'CreateSquareBlockCity',
        BlockDummy = 'zzcityblock9',
        BlockSpacing = {10,10},
        CityRadius = {6,12}, --generation will stop between these two numbers from centre
        Wall = 'seb5101',
        Turrets = {
            {'ueb2101', Weight = 1 },
            {'ueb2104', Weight = 1 },
        },
        T1AA = 'ueb2104',
        T2AA = 'ueb2204',
        T1PD = 'ueb2101',
        TMD = 'ueb4201',
        Power = {
            'ueb1301',--65 + cities
            'ueb1201',--13 + cities
            'seb1201',--7 + cities (if exists)
            'ueb1101',--Else
        },
        Structures3x3 = {
            {'uec1101', Weight = 6 },
            {'uec1201', Weight = 2 },
            {'uec1301', Weight = 2 },
            {'uec1501', Weight = 2 },
            {'xec1401', Weight = 1 },
        },
        Structures3x3Tall = {
            {'sec1201', Weight = 2 },
            {'sec1202', Weight = 2 },
            {'sec1203', Weight = 1 },
        },
        Structures7x7 = {
            {'uec1401', Weight = 8 },
            {'xec1301', Weight = 4 },
            {'sec1101', Weight = 3 },
            {'xec1501', Weight = 1 },
        },
        LargeStructureBlocks = {5, 4}, -- a 5th to a 4th of all full blocks
        RoadPath = '/mods/BrewLAN_Plenae/CityGeneration/env/UEF/Decals/UEF_Road_Black_',
        RoadSize = 10.66,
        RoadLOD = 500,
        RoadTiles = {
            --left right up down 1 2 4 8
            --[['0000']] [ 0] = {0,       '0W_01'}, --0 road
            --[['0001']] [ 1] = {0,       '1W_01'}, --1 way down
            --[['0010']] [ 2] = {math.pi, '1W_01'}, --1 way up
            --[['0011']] [ 3] = {1.57,    '2WS_01'},--stright |
            --[['0100']] [ 4] = {1.57,    '1W_01'}, --1 way right?
            --[['0101']] [ 5] = {0,       '2WC_01'},--corner bottom right
            --[['0110']] [ 6] = {1.57,    '2WC_01'},--corner up right
            --[['0111']] [ 7] = {1.57,    '3W_01'}, --3 way right (no path left)
            --[['1000']] [ 8] = {-1.57,   '1W_01'}, --1 way left?
            --[['1001']] [ 9] = {-1.57,   '2WC_01'},--corner bottom left
            --[['1010']] [10] = {math.pi, '2WC_01'},--corner top left
            --[['1011']] [11] = {-1.57,   '3W_01'}, --3 way left (no path right)
            --[['1100']] [12] = {0,       '2WS_01'},--stright --
            --[['1101']] [13] = {0,       '3W_01'}, --3 way down (no path up)
            --[['1110']] [14] = {math.pi, '3W_01'}, --3 way up (no path down)
            --[['1111']] [15] = {0,       '4W_01'}, --4 way intersection
        },
        Streetlight = '/env/UEF/Props/UEF_Streetlight_01_prop.bp',
        Fence = '/env/uef/props/uef_fence_prop.bp',
        Vehicles = {
            {'/env/uef/props/uef_car1_prop.bp', Weight = 14 },
            {'/env/uef/props/uef_bus_prop.bp', Weight = 4 },
            {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_truck_prop.bp', Weight = 3 },
            {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_cybertruck_prop.bp', Weight = 1 },
        },
    },
}

function GetRandomCityFactionGenerator()
    if CityData[1] then
        local no = math.random(1, table.getn(CityData) )
        return __modules['/lua/sim/scenarioutilities.lua'][CityData[no].FunctionName], CityData[no]
    end
end

function CreateSquareBlockCity(AIbrain, FUnits, CityCentrePos, CityRadius)
    CityRadius = CityRadius or FUnits.CityRadius
    coroutine.yield(1)
    --------------------------------------------------------------------
    -- Find potential city locations
    --------------------------------------------------------------------
    local cityI = {}
    --------------------------------------------------------------------
    -- Plan cities
    --------------------------------------------------------------------
    --place the city centre
    local centreUnit = AIbrain:CreateUnitNearSpot(FUnits.BlockDummy, CityCentrePos[1], CityCentrePos[3])
    if centreUnit and IsUnit(centreUnit) then
        cityI[0] = {}
        cityI[0][0] = centreUnit
        CityCentrePos = cityI[0][0]:GetPosition()
        --function to crawl for a good area for the city
        local CrawlIntersections
        CrawlIntersections = function(refPos, refGrid, total)
            local dirs = {}
            for i, v in {{-1, 0}, {0, -1}, {1, 0}, {0, 1}} do
                table.insert(dirs, math.random(1,table.getn(dirs)), v)
            end
            --table.sort(dirs, function(a,b) return math.random() > 0.5 end)
            for i, dir in dirs do
                local blockSX, blockSZ = refPos[1] + dir[1] * FUnits.BlockSpacing[1], refPos[3] + dir[2] * FUnits.BlockSpacing[2]
                local newGX, newGZ = refGrid[1] + dir[1], refGrid[2] + dir[2]
                local postest
                --Don't try if we're doubling up anyway
                if not (cityI[newGX] and cityI[newGX][newGZ]) then
                    postest = AIbrain:CreateUnitNearSpot(FUnits.BlockDummy, blockSX, blockSZ)
                end

                if postest and IsUnit(postest) then
                    local pos = postest:GetPosition()

                    if not cityI[newGX] then
                        cityI[newGX] = {}
                    end

                    if pos[1] == blockSX and pos[3] == blockSZ then
                        --LOG("SAFE!")
                        cityI[newGX][newGZ] = postest
                        if total < math.random(CityRadius[1], CityRadius[2]) then
                            CrawlIntersections(pos, {newGX, newGZ}, total + 1)
                        end
                    else
                        cityI[newGX][newGZ] = 'bad'
                        postest:Destroy()
                        coroutine.yield(1)
                    end
                end
            end
        end

        CrawlIntersections(CityCentrePos, {0,0}, 0)

        --table.insert(Cities, cityI)
    end

    if AIbrain.PopCapReached then return end
    --------------------------------------------------------------------
    -- Cleanup city areas
    --------------------------------------------------------------------
    for x, xtable in cityI do
        for y, sectionunit in xtable do
            if sectionunit == 'bad' then
                cityI[x][y] = nil
            end
        end
    end

    local CityData = { Grids2 = {} }
    --for i, cityI in Cities do
    for x, xtable in cityI do
        for y, sectionunit in xtable do
            local pos = sectionunit:GetPosition()
            sectionunit:Destroy()
            cityI[x][y] = pos

            --Data stuff

            --Count the number of grid cells
            CityData.NoGrids = (CityData.NoGrids or 0) + 1

            --make a list of all the 2x2 grid areas, track the bottom corner grid, and count them
            --if            -- left up             up                  left
            if (cityI[x-1] and cityI[x-1][y-1] and cityI[x-1][y] ) and cityI[x][y-1] then
                --pre-randomise the order
                table.insert(CityData.Grids2, math.random(1,table.getn(CityData.Grids2)), {x,y})
                CityData.NoGrids2 = (CityData.NoGrids2 or 0) + 1
            end

            --Clear props from the road
            for i, v in { {1.5, 5}, {5, 1.5} } do
                for i, v in GetReclaimablesInRect( Rect(pos[1]-v[1], pos[3]-v[2], pos[1]+v[1], pos[3]+v[2]) ) or {} do
                    if v and IsProp(v) then --and not string.find(v:GetBlueprint().BlueprintId, 'uef') then--SetPropCollision
                        v:Destroy()
                    end
                end
            end
        end
    end
    --end
    --Wait to prevent deleting the panning units from removing the path blocking of future structures spawned this tick.
    coroutine.yield(1)

    if AIbrain.PopCapReached then return end
    --------------------------------------------------------------------
    -- Util data and functions
    --------------------------------------------------------------------
    local army = AIbrain:GetArmyIndex()

    -- For creating loops around square or rectangular offsets
    -- returns an array of co-ord offsets
    -- expects one or two numbers (x, z)
    local Corners = function(d, b) return { {d,-(b or d)}, {-d,-(b or d)}, {-d,(b or d)}, {d,(b or d)} } end
    local Edges = function(d, b) return { {-d, 0}, {d, 0}, {0, -(b or d)}, {0, (b or d)} } end
    local Ring = function(d, b)
        b = b or d
        local array = {}
        for i = -d + 1, d - 1 do
            table.insert(array, {i,b})
            table.insert(array, {i,-b})
        end
        for i = -b, b do
            table.insert(array, {d,i})
            table.insert(array, {-d,i})
        end
        return array
    end
    -- returns a weighted blueprint from an array
    -- Expects an array with entries like {'bp', Weight = [int]}
    local ChooseWeightedBp = function(selection)
        local totWeight = 0
                    --specify ipairs so we can have keys not part of this.
        for k, v in ipairs(selection) do if v.Weight then totWeight = totWeight + v.Weight end end
        local val = 1
        local num = Random(0, totWeight)
        for k, v in ipairs(selection) do if v.Weight then val = val + v.Weight end if num < val then return v[1] end end
    end
    -- returns the next blueprint from an array
    -- Expects the same as weighted, but doesn't use .Weight
    local ChooseCyclingBp = function(selection)
        if not selection.Cycle then selection.Cycle = 0 end
        selection.Cycle = selection.Cycle + 1
        if selection.Cycle > table.getn(selection) then
            selection.Cycle = math.mod(selection.Cycle, table.getn(selection))
        end
        return selection[selection.Cycle][1]
    end

    -- returns a random position within given distances of a fixed offset of a position
    -- returns {x,y,z} where x and z are semi-random, and y just pos[2]
    -- expects a 3 point vector of start pos, a 2 point vector of the fixed offset, and a 2 point vector of the variation random bounds
    local rOOP = function(pos, off, ran)
        local x = pos[1] + off[1] + (math.random()*2-1)*ran[1]
        local z = pos[3] + off[2] + (math.random()*2-1)*ran[2]
        return {x, pos[2], z}
    end

    local SafeProp = function(bp, pos, dir, ...)
        if type(bp) == 'table' then
            bp = ChooseWeightedBp(bp)
        end
        local v1,v2 = 0,0
        if arg then
            for i, v in ipairs(arg) do
                v1 = v1 + v[1]
                v2 = v2 + v[2]
            end
        end
        return CreatePropHPR(
            bp,
            pos[1]+v1, GetTerrainHeight(pos[1]+v1, pos[3]+v2), pos[3]+v2,
            dir or Random(0,360), 0, 0
        )
    end

    -- Places and returns a unit from a bp or a weighted list of bps
    -- expects [string or table] [vector2 pos] [0-3 number]
    local SafeSpawn = function(unitbp, pos, dir)
        while type(unitbp) == 'table' do
            unitbp = ChooseWeightedBp(unitbp)
        end
        if string.sub(unitbp, 1, 1) == '/' then
            return SafeProp(unitbp, pos, dir or Random(0,3) * 90)
        else
            local k, unit = pcall(CreateUnitHPR, unitbp, army,
                pos[1], 0, pos[3], -- GetTerrainHeight(pos[1],pos[3]) --units don't care about height
                0, (dir or Random(0,3)) * 1.57, 0
            )
            if k then
                if unit.CreateTarmac then unit.CreateTarmac = function() end end
                return unit
            else
                AIbrain.PopCapReached = true
            end
        end
    end

    -- Calls SafeSpawn after checking noting already has the exact same target position
    -- expectes [number], [number], [string or table], [number or nil]
    local SpawnNoOverlap = function(X, Y, unitID, dir)
        for i, unit in GetUnitsInRect(X,Y,X,Y) or {} do
            local upos = unit:GetPosition()
            if upos[1] == X and upos[3] == Y then
                return false
            end
        end
        SafeSpawn(unitID, {X, nil, Y}, dir or 0)
    end

    -- Spawns a ring of walls with gaps in the middle of the edges, 1 TMD, and up to of each 2 AA and PD
    --expects [vector] [number] [number]
    local SmallRingDefense = function(pos, wall, turret)
        for i, v in Ring(wall) do
            if v[1] ~= 0 and v[2] ~= 0 then
                SafeSpawn(FUnits.Wall, {pos[1]+v[1], nil, pos[3]+v[2]}, 0)
            end
        end
        local tmd = math.random(1,4)
        for i, v in Corners(turret) do
            if i == tmd then
                SafeSpawn(FUnits.TMD, {pos[1]+v[1], nil, pos[3]+v[2]})
            elseif v[1] == v[2] then
                SafeSpawn(FUnits.T1PD, {pos[1]+v[1], nil, pos[3]+v[2]})
            else
                SafeSpawn(FUnits.T2AA, {pos[1]+v[1], nil, pos[3]+v[2]})
            end
        end
    end

    local RingFence = function(pos, d, b, gap)
        if not FUnits.Fence then return end
        for i, v in Ring(d, b) do
            local gapt
            if gap then
                gapt = {
                    v[2] == -(b or d),
                    v[1] == d,
                    v[2] == (b or d),
                    v[1] == -d,
                }
            end
            if not (v[1] == v[2] or v[1] == -v[2] ) and not (gap and gapt[gap]) then
                local x,y,z = unpack(pos)
                x = x + v[1]
                z = z + v[2]
                y = GetTerrainHeight(x,z)
                local ori = 0
                if v[1] == d or v[1] == -d then
                    ori = 90
                end
                CreatePropHPR( FUnits.Fence, x, y, z, ori, 0, 0 )
            end
        end
    end

    local SpawnCarparkCars = function(pos, dir, scale, ratio)
        for i, v in Ring(2) do
            if math.abs(v[dir]) > 1 and math.random(1,5) ~= 5 then
                v[1] = v[1] * (scale or 0.55) + (math.random()-0.5) * 0.2
                v[2] = v[2] * (scale or 0.55) + (math.random()-0.5) * 0.2
                v[dir] = v[dir] * (ratio or 0.8)
                local ori = (dir + 2 * math.random(0,1)) * 90 + math.random(-5,5)
                SafeProp(FUnits.Vehicles, pos, ori, v)
            end
        end
    end

    --------------------------------------------------------------------
    -- Spawn large structures
    --------------------------------------------------------------------
    --for i, cityI in Cities do
    --local army = AIbrain:GetArmyIndex()
    local num = CityData.NoGrids2 or 0
    num = math.max(math.ceil(math.random(num/FUnits.LargeStructureBlocks[1], num/FUnits.LargeStructureBlocks[2])), math.min(1,num) )
    for gi, grid in CityData.Grids2 do
        if gi <= num then
            local x, y = grid[1], grid[2]
            local pos = table.copy(cityI[x][y]); pos[1] = pos[1]-5; pos[3] = pos[3]-5
            local unit
            if not CityData.PowerPlant and CityData.NoGrids > 64 then
                unit = SafeSpawn(FUnits.Power[1], pos)
                if not unit then return end -- abort if this fails. We're at pop cap and will be defencesless.
                CityData.PowerPlant = unit
                SmallRingDefense(pos, 3, 3)
            elseif not CityData.PowerPlant and CityData.NoGrids > 12 then
                unit = SafeSpawn(FUnits.Power[2], pos)
                if not unit then return end -- abort if this fails. We're at pop cap and will be defencesless.
                CityData.PowerPlant = unit
                SmallRingDefense(pos, 3, 2)
            else
                unit = SafeSpawn(FUnits.Structures7x7, pos)
                local unitbp = unit:GetBlueprint()
                if unitbp.SizeX < 6 and unitbp.SizeZ < 6 and math.random(1,3) ~= 3 then
                    RingFence(pos, 3)
                end
            end
            if unit then unit.LargeStructure = true end
        else
            CityData.Grids2[gi] = nil
        end
    end
    --WARN(repr(CityData.Grid2Map))
    --end

    --------------------------------------------------------------------
    -- Spawn roads, small structures, and props
    --------------------------------------------------------------------
    --for i, cityI in Cities do
    for x, xtable in cityI do
        for y, pos in xtable do

            -- spawn structures before roads so that we an abort if we fail to make a generator before we've made a mark.
            for _, v in Corners(1) do
                --local position of this structure? centre
                local cbpos = {pos[1] + v[1]*3, pos[2], pos[3] + v[2]*3}
                --Make sure we didn't already spawn a big thing here
                local r1,r2,r3,r4 = pos[1] + v[1]*5, pos[3] + v[2]*5, pos[1] + v[1]*5, pos[3] + v[2]*5
                local units = table.cat(GetUnitsInRect(r1,r2,r3,r4) or {}, GetReclaimablesInRect(Rect(r1,r2,r3,r4)) or {})
                local check = true
                if units then
                    for i, unit in units do
                        if unit.LargeStructure then
                            check = false
                            break
                        end
                    end
                end

                if check and math.random(1,10) ~= 10 then
                    --Assuming we're not at pop cap (rare, but can happen here), try to spawn a power gen if we don't have one
                    if not CityData.PowerPlant and not AIbrain.PopCapReached then
                        local RDPG = FUnits.Power[3]
                        --Just in case something else gave alternatives to it.
                        if type(RDPG) ~= 'string' then
                            RDPG = ChooseWeightedBp(RDPG)
                        end
                        -- Small city power generator selection
                        if CityData.NoGrids > 6 and __blueprints[RDPG] then
                            CityData.PowerPlant = SafeSpawn(RDPG, cbpos)
                        elseif CityData.NoGrids > 1 then
                            for _, j in Corners(0.75) do
                                CityData.PowerPlant = SafeSpawn(FUnits.Power[4], {cbpos[1]+j[1], nil, cbpos[3]+j[2]})
                            end
                        else
                            CityData.PowerPlant = SafeSpawn(FUnits.Power[4], cbpos)
                        end
                        -- Fence around the generators.
                        if CityData.PowerPlant then
                            RingFence(cbpos, 1.5)
                        end
                    else
                        -- Spawn a regular ass structure
                        if (CityData.NoGrids / 10) - math.abs(x) - math.abs(y) > math.random(1,5) then
                            SafeSpawn(FUnits.Structures3x3Tall, cbpos)
                        else
                            SafeSpawn(FUnits.Structures3x3, cbpos)
                        end
                    end
                elseif check and math.random(1,4) == 4 then
                    --If we decided to leave this blank, spawn a carpark
                    local dir = math.random(1,2)
                    SpawnCarparkCars(cbpos, dir)
                    RingFence(cbpos, 1.5, nil, dir + 2 * math.random(0,1))
                end
            end

            ----------------------------------------------------------------
            -- Spawn roads
            ----------------------------------------------------------------
            local CreateRoad = function(pos, rot, nom, army)
                local ds, lod = FUnits.RoadSize, FUnits.RoadLOD --decal size, lod cutoff
                CreateDecal(pos, rot or 0, FUnits.RoadPath .. nom .. '_Albedo.dds', '', 'Albedo', ds, ds, lod, 0, army, 0)
                CreateDecal(pos, rot or 0, FUnits.RoadPath .. nom .. '_Normals.dds', '', 'Alpha Normals', ds, ds, lod, 0, army, 0)
            end

            local binarySwitch = function(a,b,c,d) return (a and 8 or 0) + (b and 4 or 0) + (c and 2 or 0) + (d and 1 or 0) end
            local bin = binarySwitch((cityI[x-1] and cityI[x-1][y]), (cityI[x+1] and cityI[x+1][y]), cityI[x][y-1], cityI[x][y+1])
            CreateRoad(pos, FUnits.RoadTiles[bin][1], FUnits.RoadTiles[bin][2],  army)

            ----------------------------------------------------------------
            -- Spawn street lights
            ----------------------------------------------------------------
            if FUnits.Streetlight then
                local lamp = function(pos, v)
                    SafeProp(FUnits.Streetlight,{pos[1]+v[1], nil, pos[3]+v[2]}, 0)
                end
                for _, v in Corners(1.66) do
                    lamp(pos, v)
                end
                if (cityI[x+1] and cityI[x+1][y]) then
                    for i, v in {{5, 1.66}, {5, -1.66}} do lamp(pos, v) end
                end
                if cityI[x][y+1] then
                    for i, v in {{-1.66, 5}, {1.66, -5}} do lamp(pos, v) end
                end
            end
            ----------------------------------------------------------------
            -- Spawn street cars
            ----------------------------------------------------------------
            if FUnits.Vehicles then
                for _, v in Edges(3) do
                    if math.random() > 0.6 then
                        SafeProp(FUnits.Vehicles, rOOP(pos,v,{2,1}))
                    end
                end
                if bin == 1 or bin == 2 then
                    SpawnCarparkCars(pos, 1, 0.4, 1.6)
                elseif bin == 4 or bin == 8 then
                    SpawnCarparkCars(pos, 2, 0.4, 1.6)
                end
            end
            ----------------------------------------------------------------
            -- Wall perimetre
            ----------------------------------------------------------------
            for _, v in Edges(1) do
                if not (cityI[x+v[1] ] and cityI[x+v[1] ][y+v[2] ]) then
                    for i = -4, 4 do
                        SafeSpawn(FUnits.Wall, {pos[1] + (v[1]*5) + (i*v[2]), nil, pos[3] + (v[2]*5) + (i*v[1])}, 0)
                    end
                end
            end
            --Wall corner parts
            for i, v in Corners(1) do
                if not (cityI[x+v[1] ] and cityI[x+v[1] ][y+v[2] ]) then
                    local X, Y = pos[1] + (v[1]*5), pos[3] + (v[2]*5)
                    SpawnNoOverlap(X+v[1], Y+v[2], FUnits.Wall)
                    SpawnNoOverlap(X, Y, ChooseCyclingBp(FUnits.Turrets), i)
                    for k, j in Edges(1) do
                        if not (cityI[x+j[1] ] and cityI[x+j[1] ][y+j[2] ]) then
                            SpawnNoOverlap(X+j[1], Y+j[2], FUnits.Wall)
                        end
                    end
                end
            end
        end
    end
end
