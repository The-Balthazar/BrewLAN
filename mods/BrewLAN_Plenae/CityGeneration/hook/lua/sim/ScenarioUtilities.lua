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
            {'sec1102', Weight = 3 },
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

        BlockDummyWater = 'zzcityblock9w',
        PierData = {
            TexPath = '/mods/BrewLAN_Plenae/CityGeneration/env/UEF/Decals/UEF_Road_Black_Pier_',
            TexSize = {20.66, 10.66},
            TexLOD = 500,
            Directional = {
                [0] = {x=-5, z= 0, xa =-1, za= 0, x0=-14.5, z0= -1.5, w=19, h= 3},
                [1] = {x= 0, z= 5, xa = 0, za= 1, x0= -1.5, z0= -4.5, w= 3, h=19},
                [2] = {x= 5, z= 0, xa = 1, za= 0, x0= -4.5, z0= -1.5, w=19, h= 3},
                [3] = {x= 0, z=-5, xa = 0, za=-1, x0= -1.5, z0=-14.5, w= 3, h=19},
            },
            Pier = '/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_wharf_prop.bp',
            PierHeight = 0.25,
            Dock = '/env/uef/props/uef_dock_prop.bp',
            Containers = {
                {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_containers_7_001_prop.bp', Weight = 1 },
                {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_containers_7_002_prop.bp', Weight = 1 },
                {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_containers_7_003_prop.bp', Weight = 1 },
                {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_containers_7_004_prop.bp', Weight = 1 },
                {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_containers_7_005_prop.bp', Weight = 1 },
                {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_containers_7_006_prop.bp', Weight = 1 },
                {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_containers_7_007_prop.bp', Weight = 1 },
                {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_containers_7_008_prop.bp', Weight = 1 },
                {'/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_containers_7_009_prop.bp', Weight = 1 },
            },
            ContainerCranes = '/mods/BrewLAN_Plenae/CityGeneration/env/uef/props/uef_container_crane_prop.bp',
            Ships = {
                { nil,      Weight = 8 },
                {'xes0307', Weight = 1 },
                {'ues0302', Weight = 1 },
            },
            Boats = {
                {'xes0205', Weight = 1 },
                {'xes0102', Weight = 2 },
                {'ues0103', Weight = 2 },
                {'ues0201', Weight = 2 },
                {'ues0202', Weight = 2 },
            },
        }
    }
}

function GetRandomCityFactionGenerator()
    if CityData[1] then
        local no = math.random(1, table.getn(CityData) )
        return __modules['/lua/sim/scenarioutilities.lua'][CityData[no].FunctionName], CityData[no]
    end
end

local LastCityGenTick

function CreateSquareBlockCity(AIbrain, FUnits, CityCentrePos, CityRadius)
    CityCentrePos[1] = math.floor(CityCentrePos[1])+0.5
    CityCentrePos[3] = math.floor(CityCentrePos[3])+0.5
    CityCentrePos[2] = GetTerrainHeight(CityCentrePos[1], CityCentrePos[3])

    while LastCityGenTick == GetGameTick() do
        coroutine.yield(1)
        if AIbrain.PopCapReached then
            return
        end
    end
    LastCityGenTick = GetGameTick()

    local cityI = {} --For storing city blocks and their positions

    local function CityGrid(x,z)
        return cityI[x] and cityI[x][z]
    end

    local function SetCityGrid(x,z,val)
        if not cityI[x] then cityI[x] = {} end
        cityI[x][z] = val
    end

    local function SetEmptyCityGrid(x,z,val)
        if not CityGrid(x,z) then
            SetCityGrid(x,z,val)
        end
    end

    local function insertRandom(t, val)
        return table.insert(t, math.random(1,table.getn(t)), val)
    end

    local function randomOrder(t)
        local tr = {}
        for i, v in t do insertRandom(tr, v) end
        return tr
    end

    local function dirAxis(dir)
        return (math.abs(dir[1]) == 1) and 'X' or (math.abs(dir[2]) == 1) and 'Y'
    end

    local CrawlIntersections
    CrawlIntersections = function(refPos, refGrid, total)
        for i, dir in randomOrder{{-1, 0}, {0, -1}, {1, 0}, {0, 1}} do
            local newGX, newGZ = refGrid[1] + dir[1], refGrid[2] + dir[2]
            local pos = {refPos[1] + dir[1] * FUnits.BlockSpacing[1], 0, refPos[3] + dir[2] * FUnits.BlockSpacing[2]}

            if not CityGrid(newGX, newGZ) and AIbrain:CanBuildStructureAt(FUnits.BlockDummy, pos) then
                SetCityGrid(newGX, newGZ, pos)
                if total < math.random((CityRadius or FUnits.CityRadius)[1], (CityRadius or FUnits.CityRadius)[2]) then
                    CrawlIntersections(pos, {newGX, newGZ}, total + 1)
                end
            else -- Pier block
                local pos2 = {refPos[1] + dir[1] * FUnits.BlockSpacing[1] * 2, 0, refPos[3] + dir[2] * FUnits.BlockSpacing[2] * 2}
                pos2[2] = GetSurfaceHeight(pos2[1], pos2[3])
                local newGX2, newGZ2 = refGrid[1] + dir[1] * 2, refGrid[2] + dir[2] * 2

                if FUnits.BlockDummyWater and AIbrain:GetMapWaterRatio() > 0.3
                and not CityGrid(newGX2, newGZ2)
                and GetTerrainHeight(pos2[1], pos2[3]) < pos2[2]
                and AIbrain:CanBuildStructureAt(FUnits.BlockDummyWater, pos2) then

                    SetCityGrid(newGX2, newGZ2, pos2)
                    SetCityGrid(newGX, newGZ, 'pier'..dirAxis(dir))
                else
                    SetEmptyCityGrid(newGX, newGZ, 'bad')
                end
            end
        end
    end

    if AIbrain:CanBuildStructureAt(FUnits.BlockDummy, CityCentrePos) then
        SetCityGrid(0,0,CityCentrePos)
    else
        local centreUnit = AIbrain:CreateUnitNearSpot(FUnits.BlockDummy, CityCentrePos[1], CityCentrePos[3])
        if centreUnit and IsUnit(centreUnit) then
            SetCityGrid(0,0,centreUnit:GetPosition())
            centreUnit:Destroy()
        end
    end

    if CityGrid(0,0) then
        CrawlIntersections(CityGrid(0,0), {0,0}, 0)
    else
        return
    end


    --------------------------------------------------------------------
    -- Cleanup city areas
    --------------------------------------------------------------------
    for x, xtable in cityI do
        for z, blok in xtable do
            if blok == 'bad' then
                cityI[x][z] = nil
            end
        end
    end

    local CityData = { Grids2 = {} }

    for x, xtable in cityI do
        for y, pos in xtable do
            if type(pos) == 'table' then

                CityData.NoGrids = (CityData.NoGrids or 0) + 1

                --make a list of all the 2x2 grid areas
                if type(CityGrid(x-1,y-1)) == 'table'
                and type(CityGrid(x-1,y)) == 'table'
                and type(CityGrid(x,y-1)) == 'table' then
                    insertRandom(CityData.Grids2, {x,y})
                    CityData.NoGrids2 = (CityData.NoGrids2 or 0) + 1
                end

                --Clear props from the road
                for i, v in { {1.5, 5}, {5, 1.5} } do
                    for i, v in GetReclaimablesInRect( Rect(pos[1]-v[1], pos[3]-v[2], pos[1]+v[1], pos[3]+v[2]) ) or {} do
                        if v and IsProp(v) then
                            v:Destroy()
                        end
                    end
                end
            end
        end
    end

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

    local randomOffsetOfOffsetPosition = function(position, fixedOffset, maxRandomOffset)
        return {
            position[1] + fixedOffset[1] + (math.random()*2-1)*maxRandomOffset[1],
            position[2],
            position[3] + fixedOffset[2] + (math.random()*2-1)*maxRandomOffset[2]
        }
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
            pos[1]+v1, GetSurfaceHeight(pos[1]+v1, pos[3]+v2), pos[3]+v2,
            dir or Random(0,360), 0, 0
        )
    end

    -- Places and returns a unit from a bp or a weighted list of bps
    -- expects [string or table] [vector2 pos] [0-3 number]
    local SafeSpawn = function(unitbp, pos, dir)
        while type(unitbp) == 'table' do
            unitbp = ChooseWeightedBp(unitbp)
        end
        if not unitbp then
            return
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
        return SafeSpawn(unitID, {X, nil, Y}, dir or 0)
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

    --------------------------------------------------------------------
    -- Spawn roads, small structures, and props
    --------------------------------------------------------------------
    for x, xtable in cityI do
        for y, pos in xtable do
            if type(pos) == 'table' then
                ----------------------------------------------------------------
                -- Land stuff
                ----------------------------------------------------------------
                if GetTerrainHeight(pos[1], pos[3]) >= GetSurfaceHeight(pos[1], pos[3]) then
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
                    local bin = binarySwitch(
                        CityGrid(x-1,y) and CityGrid(x-1,y) ~= 'pierY',
                        CityGrid(x+1,y) and CityGrid(x+1,y) ~= 'pierY',
                        CityGrid(x,y-1) and CityGrid(x,y-1) ~= 'pierX',
                        CityGrid(x,y+1) and CityGrid(x,y+1) ~= 'pierX'
                    )
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
                        if CityGrid(x+1,y) then
                            for i, v in {{5, 1.66}, {5, -1.66}} do lamp(pos, v) end
                        end
                        if CityGrid(x,y+1) then
                            for i, v in {{-1.66, 5}, {1.66, -5}} do lamp(pos, v) end
                        end
                    end
                    ----------------------------------------------------------------
                    -- Spawn street cars
                    ----------------------------------------------------------------
                    if FUnits.Vehicles then
                        for _, v in Edges(3) do
                            if math.random() > 0.6 then
                                SafeProp(FUnits.Vehicles, randomOffsetOfOffsetPosition(pos,v,{2,1}))
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
                        if not CityGrid(x+v[1], y+v[2]) then
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

                ----------------------------------------------------------------
                -- Water stuff
                ----------------------------------------------------------------
                elseif FUnits.PierData then
                    local FlattenCeilMapRect = function(x,z,w,h,y)
                        for i = 0, w do
                            for j = 0, h do
                                if GetTerrainHeight(x+i,z+j) < y then
                                    FlattenMapRect(x+i,z+j,0,0,y)
                                end
                            end
                        end
                    end
                    local FlattenGradientMapRect = function(x,z,w,h)
                        --a1,a2
                        --b1,b2
                        local a1, a2, b1, b2 = GetTerrainHeight(x,z), GetTerrainHeight(x+w,z), GetTerrainHeight(x,z+h), GetTerrainHeight(x+w,z+h)
                        for i = 0, w do
                            for j = 0, h do
                                FlattenMapRect(x+i,z+j,0,0,
                                    (
                                        ((a1*(w-i)+a2*(i))/w)*(h-j) +
                                        ((b1*(w-i)+b2*(i))/w)*(j)
                                    )/h
                                    --+ 20
                                )
                            end
                        end
                    end
                    local DoPierDecor = function(pos, pierData, pierDir, p, h)
                        for i=-5, 6 do
                            --Spawn containers
                            local d = math.random(0,1)*2
                            local x = pos[1]+(p.x*0.9)+(p.xa*i*1.33)
                            local z = pos[3]+(p.z*0.9)+(p.za*i*1.33)
                            if GetTerrainHeight(x,z) == pos[2] + h then
                                local containers = SafeProp(pierData.Containers, {x, pos[2], z}, (pierDir+1+d)*90)
                                local ran = math.random()
                                if (containers.MassReclaim or containers.MaxMassReclaim) and containers.SetReclaimValues then
                                    containers:SetReclaimValues(ran, ran, (containers.MassReclaim or containers.MaxMassReclaim) * ran, (containers.EnergyReclaim or containers.MaxEnergyReclaim) * ran)
                                end
                                if containers.MaxMassReclaim and containers.SetMaxReclaimValues then
                                    containers:SetMaxReclaimValues(ran, ran, containers.MaxMassReclaim * ran, containers.MaxEnergyReclaim * ran)
                                end
                            else
                                --Flatten the last container location
                                FlattenMapRect(
                                    math.floor(pos[1]+(p.x*0.9)+(p.xa*i*1.33) -math.abs(1*p.xa+3*p.za)/2 ),
                                    math.floor(pos[3]+(p.z*0.9)+(p.za*i*1.33) -math.abs(1*p.za+3*p.xa)/2 ),
                                    math.abs(1*p.xa+3*p.za),
                                    math.abs(1*p.za+3*p.xa),
                                    pos[2]+h
                                )

                                --Spawn the container crane over a random container
                                local cOverC = math.random(-5, i-1)

                                SafeProp(pierData.ContainerCranes, {
                                    pos[1]+(p.x*0.9)+(p.xa*cOverC*1.33),
                                    h,
                                    pos[3]+(p.z*0.9)+(p.za*cOverC*1.33)
                                }, (pierDir+1)*90)


                                --At this point I've kinda forgotten half the things that are in p, so this might be more complicated than it needs to be.
                                -- offset at crate
                                local offsetcx = (p.xa*(i-0.5)*1.33)
                                local offsetcz = (p.za*(i-0.5)*1.33)
                                -- offset at road
                                local offsetrx = (p.xa*(8-0.5)*1.33)
                                local offsetrz = (p.za*(8-0.5)*1.33)

                                local w = math.ceil(math.abs(p.xa*(offsetcx - offsetrx)+(3*p.za)))
                                local h = math.ceil(math.abs(p.za*(offsetcz - offsetrz)+(3*p.xa)))

                                local posx = pos[1]+(p.x*0.9)+(offsetcx+offsetrx)/2
                                local posz = pos[3]+(p.z*0.9)+(offsetcz+offsetrz)/2

                                FlattenGradientMapRect(
                                    math.floor(posx-(w/2)),
                                    math.floor(posz-(h/2)),
                                    w,
                                    h
                                )
                                break
                            end
                        end
                    end
                    local SpawnSmallDockShips = function(pos, off, pierData, d, ori)
                        for i=-2,2 do
                            if math.random() > 0.6 then
                                local x,y,z = unpack(pos)
                                local bpid = ChooseWeightedBp(pierData.Boats)
                                local bp = __blueprints[bpid].SizeZ
                                -- Aligning the back's of the ships and spreading along the dock bays
                                x = x + bp/2*off[1] + i*2*off[2]
                                z = z + bp/2*off[2] + i*2*off[1]

                                -- Adjusting for the dodgy shape of two of the bays
                                if ori == 1 and i == -2 then z=z+1 end
                                if ori == 1 and i == -1 then z=z+0.4 x=x+1.05 end
                                if ori == -1 and i == -2 then z=z-1 end
                                if ori == -1 and i == -1 then z=z-0.4 x=x-1.05 end

                                if ori == 0 and i == 2 then x=x-1 end
                                if ori == 0 and i == 1 then x=x-0.4 z=z+1.05 end

                                if ori == 2 and i == 2 then x=x+1 end
                                if ori == 2 and i == 1 then x=x+0.4 z=z-1.05 end

                                SafeSpawn(bpid, {x,y,z}, d+math.random(0,1)*2)
                            end
                        end
                    end

                    local pierData = FUnits.PierData
                    local pierDir = (CityGrid(x-1,y) == 'pierX') and 0
                                 or (CityGrid(x,y+1) == 'pierY') and 1
                                 or (CityGrid(x+1,y) == 'pierX') and 2
                                 or (CityGrid(x,y-1) == 'pierY') and 3

                    local p = FUnits.PierData.Directional[pierDir]

                    FlattenCeilMapRect(pos[1]+p.x0, pos[3]+p.z0, p.w, p.h, GetSurfaceHeight(pos[1], pos[3])+pierData.PierHeight)

                    CreateDecal({ pos[1]+p.x, pos[2], pos[3]+p.z }, pierDir*1.57, pierData.TexPath .. (p.Tex or '') .. 'Albedo.dds', '', 'Albedo',         pierData.TexSize[1], pierData.TexSize[2], pierData.TexLOD, 0, army, 0)
                    CreateDecal({ pos[1]+p.x, pos[2], pos[3]+p.z }, pierDir*1.57, pierData.TexPath .. (p.Tex or '') .. 'Normals.dds', '', 'Alpha Normals', pierData.TexSize[1], pierData.TexSize[2], pierData.TexLOD, 0, army, 0)

                    SafeSpawn(pierData.Pier, pos, (pierDir+1)*90)

                    DoPierDecor(pos, pierData, pierDir, p, pierData.PierHeight)

                    if pierDir == 1 or pierDir == 3 then
                        if not CityGrid(x+1,y) then
                            SafeProp(pierData.Dock, {pos[1]+2, pos[2], pos[3]}, 90)
                            SpawnSmallDockShips({pos[1]+3, pos[2], pos[3]-0.5}, {1, 0}, pierData, pierDir, 1)
                        else
                            SafeSpawn(pierData.Ships, {pos[1]+5, pos[2], pos[3]}, 0)
                        end
                        if not CityGrid(x-1,y) then
                            SafeProp(pierData.Dock, {pos[1]-2, pos[2], pos[3]}, -90)
                            SpawnSmallDockShips({pos[1]-3, pos[2], pos[3]+0.5}, {-1, 0}, pierData, pierDir, -1)
                        end
                    end
                    if pierDir == 0 or pierDir == 2 then
                        if not CityGrid(x,y-1) then
                            SafeProp(pierData.Dock, {pos[1], pos[2], pos[3]-2}, 180)
                            SpawnSmallDockShips({pos[1]-0.5, pos[2], pos[3]-3}, {0, -1}, pierData, pierDir, 2)
                        end
                        if not CityGrid(x,y+1) then
                            SafeProp(pierData.Dock, {pos[1], pos[2], pos[3]+2}, 0)
                            SpawnSmallDockShips({pos[1]+0.5, pos[2], pos[3]+3}, {0, 1}, pierData, pierDir, 0)
                        else
                            SafeSpawn(pierData.Ships, {pos[1], pos[2], pos[3]+5}, 1)
                        end
                    end
                end
            end
        end
    end
end
