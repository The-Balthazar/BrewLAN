local oldAIBrain = AIBrain

AIBrain = Class(oldAIBrain) {
    OnCreateAI = function(self, planName)
        oldAIBrain.OnCreateAI(self, planName)
        --this is Line 4947   --sub 4941
        local civilian = false
        for name,data in ScenarioInfo.ArmySetup do
            if name == self.Name then
                civilian = data.Civilian
                break
            end
        end
        if not civilian then return
        else
            if not ScenarioInfo.City then
                ScenarioInfo.City = true
            else
                return true
            end
        end

        self:ForkThread(function()
            coroutine.yield(1)
            --------------------------------------------------------------------
            -- Find potential city locations
            --------------------------------------------------------------------
            local AIGetMarkerLocations = import('/lua/ai/aiutilities.lua').AIGetMarkerLocations
            local OpenStartZones = {}
            for i, army in AIGetMarkerLocations(nil, 'Start Location') do
                if not ScenarioInfo.ArmySetup[army.Name] then
                    OpenStartZones[army.Name] = army.Position
                end
            end

            --------------------------------------------------------------------
            -- Plan cities
            --------------------------------------------------------------------
            local Cities = {}
            for armyname, MarkerPos in OpenStartZones do
                --place the city centre
                local centreUnit = self:CreateUnitNearSpot('zzcityblock', MarkerPos[1], MarkerPos[3])
                if centreUnit and IsUnit(centreUnit) then
                    local cityI = {}
                    cityI[0] = {}
                    cityI[0][0] = centreUnit
                    local CityCentrePos = cityI[0][0]:GetPosition()
                    --function to crawl for a good area for the city
                    local CrawlIntersections
                    CrawlIntersections = function(refPos, refGrid, total)
                        local dirs = {}
                        for i, v in {{-10, 0}, {0, -10}, {10, 0}, {0, 10}} do
                            table.insert(dirs, math.random(1,table.getn(dirs)), v)
                        end
                        --table.sort(dirs, function(a,b) return math.random() > 0.5 end)
                        for i, dir in dirs do
                            local postest = self:CreateUnitNearSpot('zzcityblock', refPos[1] + dir[1], refPos[3] + dir[2])
                            if postest and IsUnit(postest) then
                                local pos = postest:GetPosition()

                                if pos[1] == refPos[1] + dir[1] and pos[3] == refPos[3] + dir[2] then
                                    --LOG("SAFE!")
                                    if not cityI[refGrid[1] + dir[1] * 0.1] then
                                        cityI[refGrid[1] + dir[1] * 0.1] = {}
                                    end
                                    cityI[refGrid[1] + dir[1] * 0.1][refGrid[2] + dir[2] * 0.1] = postest
                                    if total < math.random(6,12) then
                                        CrawlIntersections(pos, {refGrid[1] + dir[1] * 0.1, refGrid[2] + dir[2] * 0.1}, total + 1)
                                    end
                                else
                                    postest:Destroy()
                                    coroutine.yield(1)
                                end
                            end
                        end
                    end

                    CrawlIntersections(CityCentrePos, {0,0}, 0)

                    table.insert(Cities, cityI)
                end
            end

            --------------------------------------------------------------------
            -- Cleanup city areas
            --------------------------------------------------------------------
            local CityData = {}
            for i, cityI in Cities do
                for x, xtable in cityI do
                    for y, sectionunit in xtable do
                        local pos = sectionunit:GetPosition()
                        sectionunit:Destroy()
                        cityI[x][y] = pos

                        --Data stuff

                        --Count the number of grid cells
                        if not CityData[i] then CityData[i] = {} end
                        CityData[i].NoGrids = (CityData[i].NoGrids or 0) + 1

                        --make a list of all the 2x2 grid areas, track the bottom corner grid, and count them
                        if not CityData[i].Grids2 then CityData[i].Grids2 = {} end
                        --if            -- left up             up                  left
                        if (cityI[x-1] and cityI[x-1][y-1] and cityI[x-1][y] ) and cityI[x][y-1] then
                            --pre-randomise the order
                            table.insert(CityData[i].Grids2, math.random(1,table.getn(CityData[i].Grids2)), {x,y})
                            CityData[i].NoGrids2 = (CityData[i].NoGrids2 or 0) + 1
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
            end
            --Wait to prevent deleting the panning units from removing the path blocking of future structures spawned this tick.
            coroutine.yield(1)

            --------------------------------------------------------------------
            -- Util data and functions
            --------------------------------------------------------------------
            local army = self:GetArmyIndex()

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
            -- returns x,y,z where x and z are semi-random, and y is the terrain height at that position
            -- expects a 3 point vector of start pos, a 2 point vector of the fixed offset, and a 2 point vector of the variation random bounds
            local rOOP = function(pos, off, ran)
                local x = pos[1] + off[1] + (math.random()*2-1)*ran[1]
                local z = pos[3] + off[2] + (math.random()*2-1)*ran[2]
                return x, GetTerrainHeight(x, z), z --used by props, so we want exact 3 point.
            end

            -- Places and returns a unit from a bp or a weighted list of bps
            -- expects [string or table] [vector2 pos] [0-3 number]
            local SafeSpawn = function(unitbp, pos, dir)
                if type(unitbp) == 'table' then
                    unitbp = ChooseWeightedBp(unitbp)
                end
                local k, unit = pcall(CreateUnitHPR, unitbp, army,
                    pos[1], 0, pos[3], -- GetTerrainHeight(pos[1],pos[3]) --units don't care about height
                    0, (dir or Random(0,3)) * 1.57, 0
                )
                if k then
                    unit.CreateTarmac = function()end
                end
                return unit
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
                        SafeSpawn('seb5101', {pos[1]+v[1], nil, pos[3]+v[2]}, 0)
                    end
                end
                local rc = math.random(1,4)
                for i, v in Corners(turret) do
                    if i == rc then
                        SafeSpawn('ueb4201', {pos[1]+v[1], nil, pos[3]+v[2]})
                    elseif v[1] == v[2] then
                        SafeSpawn('ueb2101', {pos[1]+v[1], nil, pos[3]+v[2]})
                    else
                        SafeSpawn('ueb2204', {pos[1]+v[1], nil, pos[3]+v[2]})
                    end
                end
            end

            --------------------------------------------------------------------
            -- Spawn large structures
            --------------------------------------------------------------------
            for i, cityI in Cities do
                --local army = self:GetArmyIndex()
                local num = CityData[i].NoGrids2 or 0
                num = math.max(math.ceil(math.random(num/6, num/5)), math.min(1,num) )
                for gi, grid in CityData[i].Grids2 do
                    if gi <= num then
                        local x, y = grid[1], grid[2]
                        local pos = table.copy(cityI[x][y]); pos[1] = pos[1]-5; pos[3] = pos[3]-5
                        local unit
                        if not CityData[i].PowerPlant and CityData[i].NoGrids > 64 then
                            unit = SafeSpawn('ueb1301', pos)
                            CityData[i].PowerPlant = unit
                            SmallRingDefense(pos, 3, 3)
                        elseif not CityData[i].PowerPlant and CityData[i].NoGrids > 12 then
                            unit = SafeSpawn('ueb1201', pos)
                            CityData[i].PowerPlant = unit
                            SmallRingDefense(pos, 3, 2)
                        else
                            unit = SafeSpawn('uec1401', pos)
                        end
                        if unit then unit.LargeStructure = true end
                        --if not CityData[i].Grid2Map then CityData[i].Grid2Map = {} end
                        --if not CityData[i].Grid2Map[x] then CityData[i].Grid2Map[x] = {} end
                        --CityData[i].Grid2Map[x][y] = unit
                    else
                        CityData[i].Grids2[gi] = nil
                    end
                end
                --WARN(repr(CityData[i].Grid2Map))
            end

            --------------------------------------------------------------------
            -- Spawn roads, small structures, and props
            --------------------------------------------------------------------
            for i, cityI in Cities do
                for x, xtable in cityI do
                    for y, pos in xtable do
                        local CreateRoad = function(pos, rot, nom, army)
                            local path = '/mods/BrewLAN_Plenae/CityGeneration/env/UEF/Decals/UEF_Road_Black_'
                            local ds, lod = 10.66, 500 --decal size, lod cutoff
                            CreateDecal(pos, rot or 0, path .. nom .. '_Albedo.dds', '', 'Albedo', ds, ds, lod, 0, army, 0)
                            CreateDecal(pos, rot or 0, path .. nom .. '_Normals.dds', '', 'Alpha Normals', ds, ds, lod, 0, army, 0)
                        end

                        local RoadTiles = {
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
                        }
                        local binarySwitch = function(a,b,c,d) return (a and 8 or 0) + (b and 4 or 0) + (c and 2 or 0) + (d and 1 or 0) end
                        local bin = binarySwitch((cityI[x-1] and cityI[x-1][y]), (cityI[x+1] and cityI[x+1][y]), cityI[x][y-1], cityI[x][y+1])
                        CreateRoad(pos, RoadTiles[bin][1], RoadTiles[bin][2],  army)

                        local Structures3x3 = {
                            {'uec1101', Weight = 108 },
                            {'uec1201', Weight = 32 },
                            {'uec1301', Weight = 32 },
                            {'uec1501', Weight = 32 },
                            {'xec1401', Weight = 16 },
                            {'xec1501', Weight = 1 },
                        }

                        --Spawn basic structures
                        for _, v in Corners(1) do
                            if math.random(1,10) ~= 10 then
                                --WARN(x + math.max(0, v[1]),y + math.max(0, v[2]) )
                                local units = GetUnitsInRect(pos[1] + v[1]*5, pos[3] + v[2]*5, pos[1] + v[1]*5, pos[3] + v[2]*5)
                                local check = true
                                if units then
                                    for i, unit in units do
                                        if unit.LargeStructure then
                                            check = false
                                            break
                                        end
                                    end
                                end

                                if check then--not (CityData[i].Grid2Map[x + math.max(0, v[1])] and CityData[i].Grid2Map[checkX][checkY] then
                                    if not CityData[i].PowerPlant then
                                        if CityData[i].NoGrids > 6 and __blueprints.seb1201 then
                                            CityData[i].PowerPlant = SafeSpawn('seb1201', {pos[1] + v[1]*3, nil,  pos[3] + v[2]*3})
                                        elseif CityData[i].NoGrids > 1 then
                                            for _, j in Corners(0.75) do
                                                CityData[i].PowerPlant = SafeSpawn('ueb1101', {pos[1]+v[1]*3+j[1], nil, pos[3]+v[2]*3+j[2]})
                                            end
                                        else
                                            CityData[i].PowerPlant = SafeSpawn('ueb1101', {pos[1] + v[1]*3, nil,  pos[3] + v[2]*3})
                                        end
                                    else
                                        SafeSpawn(Structures3x3, {pos[1] + v[1]*3, nil,  pos[3] + v[2]*3})
                                    end
                                end
                            end
                        end
                        --Spawn street lights
                        for _, v in Corners(1.66) do
                            --WARN(pos[1]+v[1], GetTerrainHeight(pos[1]+v[1], pos[3]+v[2]), pos[3]+v[2])
                            CreatePropHPR(
                                '/env/UEF/Props/UEF_Streetlight_01_prop.bp',
                                pos[1]+v[1], GetTerrainHeight(pos[1]+v[1], pos[3]+v[2]), pos[3]+v[2],
                                0, 0, 0
                            )
                        end
                        local Vehicles = {
                            {'/env/uef/props/uef_car1_prop.bp', Weight = 56 },
                            {'/env/uef/props/uef_bus_prop.bp', Weight = 16 },
                            {'/env/uef/props/uef_truck_prop.bp', Weight = 1 },
                        }
                        for _, v in Edges(3) do
                            if math.random() > 0.6 then
                                local x, y, z = rOOP(pos,v,{2,1})
                                CreatePropHPR(
                                    ChooseWeightedBp(Vehicles),
                                    x, y, z,
                                    Random(0,360), 0, 0
                                )
                            end
                        end
                        --wall edges
                        for _, v in Edges(1) do
                            if not (cityI[x+v[1] ] and cityI[x+v[1] ][y+v[2] ]) then
                                for i = -4, 4 do
                                    SafeSpawn('seb5101', {pos[1] + (v[1]*5) + (i*v[2]), nil, pos[3] + (v[2]*5) + (i*v[1])}, 0)
                                end
                            end
                        end
                        local Turrets = {
                            {'ueb2101', Weight = 1 },
                            {'ueb2104', Weight = 1 },
                        }
                        --Wall corner parts
                        for i, v in Corners(1) do
                            if not (cityI[x+v[1] ] and cityI[x+v[1] ][y+v[2] ]) then
                                local X, Y = pos[1] + (v[1]*5), pos[3] + (v[2]*5)
                                SpawnNoOverlap(X+v[1], Y+v[2], 'seb5101')
                                SpawnNoOverlap(X, Y, ChooseCyclingBp(Turrets), i)
                                for k, j in Edges(1) do
                                    if not (cityI[x+j[1] ] and cityI[x+j[1] ][y+j[2] ]) then
                                        SpawnNoOverlap(X+j[1], Y+j[2], 'seb5101')
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end,

}
