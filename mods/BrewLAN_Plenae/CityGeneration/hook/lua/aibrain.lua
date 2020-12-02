local oldAIBrain = AIBrain

AIBrain = Class(oldAIBrain) {
    OnCreateAI = function(self, planName)
        oldAIBrain.OnCreateAI(self, planName)
        --Line 4947
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

            local army = self:GetArmyIndex()

            --------------------------------------------------------------------
            -- Spawn large structures
            --------------------------------------------------------------------
            for i, cityI in Cities do
                --local army = self:GetArmyIndex()
                local num = CityData[i].NoGrids2
                num = math.max(math.ceil(math.random(num/6, num/5)), 1)
                for gi, grid in CityData[i].Grids2 do
                    if gi <= num then
                        local x, y = grid[1], grid[2]
                        local pos = cityI[x][y]
                        local unit = CreateUnitHPR(
                            'uec1401', army,
                            pos[1] - 5, pos[2], pos[3] - 5,
                            0, Random(0,3) * 1.57, 0
                        )
                        unit.CreateTarmac = function()end
                        unit.LargeStructure = true
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
                        local ChooseWeightedBp = function(selection)
                            local totWeight = 0
                            for k, v in selection do if v.Weight then totWeight = totWeight + v.Weight end end
                            local val = 1
                            local num = Random(0, totWeight)
                            for k, v in selection do if v.Weight then val = val + v.Weight end if num < val then return v[1] end end
                        end

                        local Corners = function(d, b) return { {-d,-(b or d)}, {-d,(b or d)}, {d,(b or d)}, {d,-(b or d)} } end
                        local Edges = function(d, b) return { {-d, 0}, {d, 0}, {0, -(b or d)}, {0, (b or d)} } end
                        local rOOP = function(pos, off, ran)
                            local x = pos[1] + off[1] + (math.random()*2-1)*ran[1]
                            local z = pos[3] + off[2] + (math.random()*2-1)*ran[2]
                            return x, GetTerrainHeight(x, z), z
                        end

                        --Spawn basic structures
                        for i, v in Corners(1) do
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
                                --local checkX, checkY = x + math.max(0, v[1]), y + math.max(0, v[2])
                                --WARN(checkX, checkY)
                                if check then--not (CityData[i].Grid2Map[x + math.max(0, v[1])] and CityData[i].Grid2Map[checkX][checkY] then

                                    --Pop cap can screw us here, so lets check just in case
                                    local k, unit = pcall(CreateUnitHPR,
                                        ChooseWeightedBp(Structures3x3), army,
                                        pos[1] + v[1]*3, pos[2], pos[3] + v[2]*3,
                                        0, Random(0,3) * 1.57, 0
                                    )
                                    if k then
                                        unit.CreateTarmac = function()end
                                    end
                                end
                            end
                        end
                        --Spawn street lights
                        for i, v in Corners(1.66) do
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
                        for i, v in Edges(3) do
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
                        for i, v in Edges(1) do
                            if not (cityI[x+v[1] ] and cityI[x+v[1] ][y+v[2] ]) then
                                for i = -4, 4 do
                                    pcall(CreateUnitHPR,
                                        'seb5101', army,
                                        pos[1] + (v[1]*5) + (i*v[2]), pos[2], pos[3] + (v[2]*5) + (i*v[1]),
                                        0, 0, 0
                                    )
                                end
                            end
                        end
                        --Wall corner parts
                        for i, v in Corners(1) do
                            if not (cityI[x+v[1] ] and cityI[x+v[1] ][y+v[2] ]) then
                                local X, Y = pos[1] + (v[1]*5), pos[3] + (v[2]*5)
                                ------------------------------------------------
                                local SpawnNoOverlap = function(X, Y, unitID)
                                    for i, unit in GetUnitsInRect(X,Y,X,Y) or {} do
                                        local upos = unit:GetPosition()
                                        if upos[1] == X and upos[3] == Y then
                                            return false
                                        end
                                    end
                                    pcall(CreateUnitHPR,
                                        unitID, army,
                                        X, GetTerrainHeight(X,Y), Y,
                                        0, 0, 0
                                    )
                                end
                                ------------------------------------------------
                                SpawnNoOverlap(X+v[1], Y+v[2], 'seb5101')
                                SpawnNoOverlap(X, Y, 'ueb2101')
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
