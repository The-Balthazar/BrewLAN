local Unit = import('/lua/sim/unit.lua').Unit

ZZZ0004 = Class(Unit) {
    OnCreate = function(self)
        Unit.OnCreate(self)
        --self:ForkThread(self.TranslateAllMarkers)
        self:ForkThread(self.MapTerrainDeltaTable)
    end,

    TranslateAllMarkers = function(self, xtran, ytran)
        coroutine.yield(1)
        xtran, ytran = 128, 128
        local newmarkers = {}
        for mID, mData in Scenario.MasterChain._MASTERCHAIN_.Markers do
            newmarkers[mID] = {}
            for k, v in mData do
                if k == 'position' then --GetTerrainHeight
                    newmarkers[mID]['position'] = {v[1] + xtran, v[2], v[3] + ytran, type = v[type]}
                elseif type(v) == 'table' then
                    newmarkers[mID][k] = table.copy(v)
                else
                    newmarkers[mID][k] = v
                end
            end
        end
        LOG(repr(newmarkers))
    end,

    MapTerrainDeltaTable = function(self)
        coroutine.yield(1)
        ------------------------------------------------------------------------
        -- Debug, testing, and extra info options
        local debugmode = false
        local generateHeightmap = false
        --local log
        ------------------------------------------------------------------------
        -- Input values and options
        local maxGroundVariation = 0.75
        --local maxPlatoonDistance = 140
        local markerCheckDistance = 100
        --local markerMaxOverlapRatio = 0.7
        ------------------------------------------------------------------------
        local pointOfInterestTypes = {'Start Location', 'Mass', 'Hydrocarbon'}
        -- Togles --------------------------------------------------------------
        local doCleanup = true
        local cleanupPasses = 1
        local doDespeckle = true -- removes single unconnected grids of unpassable
        local doDeIsland = false -- removes single unconnected grids of passable
        local doDeAlcove = false -- removes single grids of passable with 3 unpassable grids cardinally adjacent
        local doMinDistCheck = 10
        local doRemoveIsolatedMarkers = true
        ------------------------------------------------------------------------
        -- Data storage
        local deltamap = {} --Populate with the local evalation differencees
        local passmap = {}  --Populate with false for impassible or distance to nearest false
        local voronoimap = {} --Populate with zones around unpassable areas as a voronoi map
        local voronoiedgelist = {} --hashmap of voronoi zone IDs that touch the border
        local markermap = {} --Map of markers
        local markerlist = {} --List of markers
        local pointsOfInterest = {} --Populated with an array of 2 point co-ords of interesting markers
        ------------------------------------------------------------------------
        -- Global functions called potentially over a million times (remove some overhead)
        local GTH, VDist2 = GetTerrainHeight, VDist2
        local max, min, abs, floor = math.max, math.min, math.abs, math.floor
        local insert, remove, getn, copy, find, merged = table.insert, table.remove, table.getn, table.copy, table.find, table.merged
        ------------------------------------------------------------------------
        -- tiny helper functions I use a bunch
        local btb = function(v) return v and 1 or 0 end --bool to binary
        local tcount = function(t) local c=0; for i, j in t do c=c+1 end return c end --more reliable getn
        local tintersect = function(t1,t2) --intersection of tables
            local t3 = {}
            for i, v in t1 do
                t3[i] = t1[i] and t2[i] or nil
            end
            return t3
        end
        local removeByValue = function(t,val) --A variant of table.ect that returns true when it hits something
            for k, v in t do
                if v == val then
                    remove(t,k)
                    return true
                end
            end
        end
        local mergeArray = function(t1, t2)
            t3 = copy(t1)
            for i, v in t2 do
                if not find(t2, v) then
                    insert(t2, v)
                end
            end
        end
        ------------------------------------------------------------------------
        -- Optional extra info gathering

            --------------------------------------------------------------------
            -- Generate a heightmap for testing?
        if generateHeightmap then
            local heightmap = {}
            --(has an off-by-one error in co-ords) not actually used later and optional, so whatever
            for x = 1, ScenarioInfo.size[1]+1 do
                heightmap[x] = {}
                for y = 1, ScenarioInfo.size[2]+1 do
                    heightmap[x][y] = GTH(x-1,y-1)
                end
            end
            return heightmap
        end
        ------------------------------------------------------------------------
        -- DO IT

        ------------------------------------------------------------------------
        -- Identify unpathable areas, and set up for passmap distance calcs
        for x = 0, ScenarioInfo.size[1]+1 do --Start one below and one above map size in order to;
            deltamap[x] = {}
            passmap[x] = {}
            markermap[x] = {}
            voronoimap[x] = {}
            for y = 0, ScenarioInfo.size[2]+1 do
                --Create a ring of unpassable around the outside
                if x == 0 or y == 0 or x == ScenarioInfo.size[1]+1 or y == ScenarioInfo.size[2]+1 then
                    deltamap[x][y] = 255
                    passmap[x][y] = false
                    markermap[x][y] = "border"
                    voronoimap[x][y] = "border"
                else
                    --Get heights around point
                    --Yes, these same points will be checked up to 4 times, but that's a lot to cache
                    local a, b, c, d = GTH(x-1,y-1), GTH(x-1,y), GTH(x,y), GTH(x,y-1)

                    --This takes diagonal difference into account, which is inaccurate
                    --local delta = max(a,b,c,d) - min(a,b,c,d)
                    --This specifically ignores diagonal difference, which appears to be the way it's done in game
                    local delta = max(abs(a-b), abs(b-c), abs(c-d), abs(d-a))

                    deltamap[x][y] = delta
                    if delta <= maxGroundVariation then
                        --previously `passmap[x][y] = delta <= maxGroundVariation`
                        --Set up for the vector check for min dist from false
                        passmap[x][y] = markerCheckDistance
                        markermap[x][y] = 0
                        voronoimap[x][y] = ''
                    else
                        passmap[x][y] = false
                        markermap[x][y] = false
                        voronoimap[x][y] = false
                    end
                end
            end
        end

        ------------------------------------------------------------------------
        -- CLEANUP -- remove a few troublesome artifacts that cause issues, and mean nothing. Probably
        if doCleanup then
            for i = 1, cleanupPasses do
                for x, ydata in passmap do
                    for y, pass in ydata do
                        -- Despeckle; remove isolated single grid impassible areas with no orthoganally adjacent other impassible areas
                        if doDespeckle then
                            if not pass
                            and passmap[x][y-1] and passmap[x-1][y-1] and passmap[x-1][y] and passmap[x-1][y+1]
                            and passmap[x][y+1] and passmap[x+1][y-1] and passmap[x+1][y] and passmap[x+1][y+1]
                            and deltamap[x][y] <= maxGroundVariation * 1.5
                            then
                                --remove isolated false sections unless they are hefty
                                passmap[x][y] = markerCheckDistance
                                voronoimap[x][y] = ''
                                --LOG("removing isolated unpathable grid")
                            end
                        end
                        -- Like despeckle but the other way round, and we don't need to care about intercardinals
                        if doDeIsland then
                            if pass
                            and not passmap[x][y-1]
                            and not passmap[x][y+1]
                            and not passmap[x-1][y]
                            and not passmap[x+1][y]
                            then
                                passmap[x][y] = false
                                voronoimap[x][y] = false
                            end
                        end
                        -- remove alcoves
                        if doDeAlcove then
                            if pass
                            and btb(not passmap[x][y-1])
                            + btb(not passmap[x][y+1])
                            + btb(not passmap[x-1][y])
                            + btb(not passmap[x+1][y])
                            == 3 then
                                passmap[x][y] = false
                                voronoimap[x][y] = false
                            end
                        end
                    end
                end
            end
        end
        ------------------------------------------------------------------------
        -- To do: contiguous area check (sort of done, in the voronoi check, but concentric unpassable areas will cause artifacting)


        ------------------------------------------------------------------------
        -- Generate a Voronoi style map of the... map;
        -- Sweep through all unpassable areas, walking through all contiguous areas and marking them as so,
        -- then mark off distances to high points, and which high point is closer
        do
             -- do block to limit MapDistance function existance
            local MapDistanceVoronoi = function(passmap, voronoimap, xtarget, ytarget, maxdist, blockid)
                --Limit area to loop over to square around the circle that's going to change
                --Could limit more with sin/cos? Would that be more compute than the vdist?
                local xstart = max(xtarget-maxdist,1)
                local xend = min(xtarget+maxdist, getn(passmap))
                local ystart = max(ytarget-maxdist,1)
                local yend = min(ytarget+maxdist, getn(passmap[1]))
                --Within the caclulated bounds
                for x = xstart, xend do
                    for y = ystart, yend do
                        if passmap[x][y] then
                            --Calculate the distance to origin
                            --maxdist is pre-polulated already, so no need to reference here
                            local dist = VDist2(x,y,xtarget,ytarget)
                            if dist < passmap[x][y] then
                                passmap[x][y] = dist
                                voronoimap[x][y] = blockid
                            end
                        end
                    end
                end
            end
            local MapCrawler
            MapCrawler = function(passmap, voronoimap, x, y, markerCheckDistance, blockid)
                for _, adj in {{0,0},{0,-1},{0,1},{-1,-1},{-1,0},{-1,1},{1,-1},{1,0},{1,1}} do
                    --Make a list of areas that touch the border, and shouldn't count towards adjacency
                    if markermap[x+adj[1] ][y+adj[2] ] == 'border' and not voronoiedgelist[blockid] then
                        voronoiedgelist[blockid] = true
                    end
                    if not voronoimap[x+adj[1] ][y+adj[2] ] then -- not passmap[x+adj[1] ][y+adj[2] ] and

                        voronoimap[x+adj[1] ][y+adj[2] ] = blockid

                        if  passmap[x+adj[1]-1][y+adj[2]  ] or
                            passmap[x+adj[1]  ][y+adj[2]-1] or
                            passmap[x+adj[1]+1][y+adj[2]  ] or
                            passmap[x+adj[1]  ][y+adj[2]+1]
                        then
                            MapDistanceVoronoi(passmap, voronoimap, x+adj[1], y+adj[2], markerCheckDistance, blockid)
                        end
                        MapCrawler(passmap, voronoimap, x+adj[1], y+adj[2], markerCheckDistance, blockid)
                    end
                end
            end

            local blockid = 0
            for x, ydata in passmap do
                for y, pass in ydata do
                    if not pass and not voronoimap[x][y] then
                        blockid = blockid + 1
                        MapCrawler(passmap, voronoimap, x, y, markerCheckDistance, blockid)
                    elseif not pass and voronoimap[x][y] == 'border' then
                        MapDistanceVoronoi(passmap, voronoimap, x, y, markerCheckDistance, 'border')
                    end
                end
            end
        end
        --LOG(repr(voronoiedgelist))
        do
            for x = 1, getn(voronoimap) - 1 do
                for y = 1, getn(voronoimap[1]) - 1 do
                    local zones = {
                        [voronoimap[x][y] ] = true,
                        [voronoimap[x][y-1] ] = true,
                        [voronoimap[x-1][y-1] ] = true,
                        [voronoimap[x-1][y] ] = true,
                    }
                    --[[if btb(voronoimap[x][y] ~= voronoimap[x][y-1])
                    + btb(voronoimap[x][y-1] ~= voronoimap[x-1][y-1])
                    + btb(voronoimap[x-1][y-1] ~= voronoimap[x-1][y])
                    + btb(voronoimap[x-1][y] ~= voronoimap[x][y])
                    then
                        LOG(repr(zones))
                        LOG(getn(zones))
                    end]]
                    if tcount(zones) >= 3 then
                        local CreateMarker = function(x, y)
                            local mnum = tcount(markerlist)
                            local markername = 'MARKER_'..mnum
                            markermap[x][y] = markername
                            markerlist[markername] = {
                                color = 'ff00ffff',
                                hint = true,
                                graph = 'DefaultAmphibious',
                                adjacentTo = '',
                                zones = copy(zones),
                                type = 'Amphibious Path Node',--'Land Path Node' - 'Amphibious Path Node',
                                position = { x, GTH(x,y), y },
                                orientation = { 0, 0, 0 },
                                prop = '/env/common/props/markers/M_Blank_prop.bp',
                                adjacentList = {},
                            }

                            return markername, markerlist[markername]
                        end

                        --Filter for nearby markers, like, really near, and move the nearby markers
                        local m1name, m1data
                        if doMinDistCheck then
                            local test = true
                            if tcount(markerlist) > 1 then
                                for m2name, m2data in markerlist do
                                    if abs(x - m2data.position[1]) < doMinDistCheck
                                    and abs(y - m2data.position[3]) < doMinDistCheck
                                    then
                                        markerlist[m2name].position[1] = floor((x + m2data.position[1]) / 2)
                                        markerlist[m2name].position[3] = floor((y + m2data.position[3]) / 2)
                                        markerlist[m2name].zones = merged(m2data.zones, zones)
                                        m1name = m2name
                                        m1data = m2data
                                        test = false
                                        break
                                    end
                                end
                            end
                            if test then
                                m1name, m1data = CreateMarker(x,y)
                            end
                        end
                        if tcount(markerlist) > 1 then
                            --for m1name, m1data in markerlist do
                            for m2name, m2data in markerlist do
                                if m1name ~= m2name then
                                    local zonetest = tintersect(zones, m2data.zones)
                                    --If zonetest is exactly 2 less than the two combined,
                                    --then they were 3 zone nodes that share two zones,
                                    --meaning theoretically one edge of the voronoi away
                                    --Checking less than one less just in case they somehow share more than 1
                                    if tcount(zonetest) > 1 then
                                        local markAdjacent = function(marker, adjname)
                                            if not find(marker.adjacentList, adjname) then
                                                insert(marker.adjacentList, adjname)
                                            end
                                        end

                                        local test = true
                                        if zonetest.border then
                                            for z, b in zonetest do
                                                if z ~= 'border' and voronoiedgelist[z] then
                                                    test = false
                                                    break
                                                end
                                            end
                                        end
                                        if test then
                                            markAdjacent(m2data, m1name)
                                            markAdjacent(m1data, m2name)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        for name, marker in markerlist do
            for i, adjname in marker.adjacentList do
                if marker.adjacentTo == '' then
                    marker.adjacentTo = adjname
                else
                    marker.adjacentTo = marker.adjacentTo .. ' ' .. adjname
                end
            end
        end

        if doMinDistCheck or doRemoveIsolatedMarkers then--the whole thing shit the bed when I tried to have this done before/during the marker production
            for m1name, m1data in markerlist do--[[
                if false and doMinDistCheck then
                    if m1data.adjacentList[1] then
                        for i, m2name in m1data.adjacentList do
                            local m2data = markerlist[m2name]
                            if markerlist[m2name] and markerlist[m1name]
                            and abs(m1data.position[1] - m2data.position[1]) < doMinDistCheck
                            and abs(m1data.position[3] - m2data.position[3]) < doMinDistCheck
                            then
                                if not m1data.adjacentList[2] and not m2data.adjacentList[2] then
                                    --It'll be an isolated marker in this instance.
                                    --and we don't want isolated markers
                                    markerlist[m1name] = nil
                                    markerlist[m2name] = nil
                                else
                                    local x, y = floor((m1data.position[1] + m2data.position[1]) / 2), floor((m1data.position[3] + m2data.position[3]) / 2)
                                    m1data.position[1] = x
                                    m1data.position[2] = GTH(x,y)
                                    m1data.position[3] = y
                                    for i, m3name in m1data.adjacentList do
                                        if table.removeByValue(markerlist[m3name].adjacentList, m2name) then
                                            markerlist[m3name].adjacentTo = nil --mark as blank for regenerating. Not going to do some gsub whatevers.
                                        end
                                    end
                                    for i, m3name in m2data.adjacentList do
                                        if table.removeByValue(markerlist[m3name].adjacentList, m2name) then
                                            markerlist[m3name].adjacentTo = nil
                                        end
                                        if not table.find(markerlist[m3name].adjacentList, m1name) then
                                            insert(markerlist[m3name].adjacentList, m1name)
                                            markerlist[m3name].adjacentTo = nil
                                        end
                                    end
                                    for i, m3name in m1data.adjacentList do
                                        if not markerlist[m3name].adjacentTo then
                                            markerlist[m3name].adjacentTo = ''
                                            if markerlist[m3name].adjacentTo == '' then
                                                markerlist[m3name].adjacentTo = markerlist[m3name].adjacentTo..m3name
                                            else
                                                markerlist[m3name].adjacentTo = markerlist[m3name].adjacentTo..' '..m3name
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end]]
                if doRemoveIsolatedMarkers and m1data.adjacentTo == '' then
                    markerlist[m1name] = nil
                end
            end
        end

        --if true then self.ConvertXYTableToYXTabDelim(markerlist) ; return end
        if true then self.PrintMarkerListFormatting(markerlist) ; return end


        --[[
        ------------------------------------------------------------------------
        -- generate potential marker locations by listing the distances to unpassable areas, and taking each area that has lower points either side of it
        -- Could get caugt up in alcoves
        do
            --this technically does 0 last, but it doesn't matter.
            --Done from the point of view of the impassible areas
            if false then

                 -- do block to limit MapDistance function existance
                local MapDistanceCoeff = function(map, xtarget, ytarget, maxdist, coefficient, xcoeff, ycoeff)
                    --Limit area to loop over to square around the circle that's going to change
                    --Could limit more with sin/cos? Would that be more compute than the vdist?
                    local xstart = max(xtarget-maxdist,1)
                    local xend = min(xtarget+maxdist, getn(map))
                    local ystart = max(ytarget-maxdist,1)
                    local yend = min(ytarget+maxdist, getn(map[1]))
                    --Within the caclulated bounds
                    for x = xstart, xend do
                        for y = ystart, yend do
                            if map[x][y] then
                                --Calculate the distance to origin
                                --maxdist is pre-polulated already, so no need to reference here
                                local dist = VDist2(x,y,xtarget+(xcoeff or 0),ytarget+(ycoeff or 0))
                                map[x][y] = min(dist + (coefficient or 0), map[x][y])
                            end
                        end
                    end
                end

                for x, ydata in passmap do
                    for y, pass in ydata do
                        --For each impassible square
                        if not pass
                        --That is cardinally adjacent to a passable square
                        -- (it's not going to be closeset to anything if it's not adjacent to any passable areas, so skip)
                        and (
                            passmap[x-1][y  ] or
                            passmap[x  ][y-1] or
                            passmap[x+1][y  ] or
                            passmap[x  ][y+1]
                        )
                        then
                            local coefficient = btb(not passmap[x-1][y  ] and passmap[x+1][y  ]) * 0.14 + btb(not passmap[x  ][y-1] and passmap[x  ][y+1]) * 0.28
                            local Xco = 0 - btb(not passmap[x-1][ y ]) * 0.41 + btb(not passmap[x+1][ y ]) * 0.41
                            local Yco = 0 - btb(not passmap[ x ][y-1]) * 0.41 + btb(not passmap[ x ][y+1]) * 0.41
                            --Do distance calculations to passable squares
                            MapDistanceCoeff(passmap, x, y, markerCheckDistance, coefficient, Xco, Yco)
                        end
                    end
                end
            end
        end

        if true then self.ConvertXYTableToYXTabDelim(voronoimap) ; return end
        ------------------------------------------------------------------------
        -- Generate a list of "highest" points
        local highpointsmap = table.deepcopy(passmap)
        local highpointlist = {}

        for x, ydata in passmap do
            for y, pass in ydata do
                --For each impassible square
                local c = 0--.35--.59
                if pass
                and passmap[x-1][y  ]
                and passmap[x  ][y-1]
                and passmap[x+1][y  ]
                and passmap[x  ][y+1]
                then
                    if (
                        pass > c + passmap[x-1][y  ] and pass > c + passmap[x+1][y  ]
                        or pass > c + passmap[x  ][y-1] and pass > c + passmap[x  ][y+1]
                    )
                    and btb(pass >= passmap[x-1][y-1]) + btb(pass >= passmap[x+1][y+1]) + btb(pass >= passmap[x+1][y-1]) + btb(pass >= passmap[x-1][y+1]) >= 3
                    then
                        --Check passmap, but affect highpointmap
                        highpointsmap[x][y] = passmap[x][y] + markerCheckDistance
                        insert(highpointlist, {x,y,highpointsmap[x][y]})
                    end
                end
            end
        end
        --if highpointsmap then self.ConvertXYTableToYXTabDelim(highpointsmap); return end

        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- Generate list of interesting places that we need to account for
        do
            --Do block so we can ditch the AI utilities after we're done
            -- Make list of locations to give special attention to
            local AIGetMarkerLocations = import('/lua/ai/aiutilities.lua').AIGetMarkerLocations
            --local floor = math.floor
            for i, markerType in pointOfInterestTypes do
                local markers = AIGetMarkerLocations(nil, markerType)
                for i, marker in markers do
                    insert(pointsOfInterest, {floor(marker.Position[1]), floor(marker.Position[3])})
                end
            end
        end


        --LOG(repr(pointsOfInterest))
        ------------------------------------------------------------------------
        -- psuedocode plan
        --for _, pos in pointsOfInterest do
            --local visibleSpots = {}
        --Loop thro PoI list
          --Check PoI doesn't have a highpoint
            --gather list of points within dist range of PoI
            --Cull list to locations with LoS (not crossing unpassable)
            --pick highpoint from passmap from remainder
                --gather list of points within dist range of chosen pos
                --cull list to locations with LoS
                  --save output to basic "path marker" list with all points pointing to chosen pos
            --go through "path marker" table for non-passmap-false locations without a pos and find nearest highpoint
              --link nearby nodes
                --check nodes within a distance of double marker distance for unconnected nodes that have LoS on eachother, no direct connection, and in cases of an indirect connectio, would have a 70% or shorter connection if directly connected

        ------------------------------------------------------------------------
        -- first pass marker locations
        do
            --Do block to drop LoS function when we're done with it
            --------------------------------------------------------------------
            -- "Line of sight" checker, returns an array of 2 point grid coords that have a direct path to the target
            -- if includefunc is defined then entries will be included based on the function output
            -- * it is expected to be {function, args}, and is executed as (pos, args)
            -- if returnpassmapval is true, each entry on the array has a 3st value, the passmap value for that grid
            -- if returndist is true, it each entry in the array has a 4th value, the distance to the target.
            local GetAreaInLoS = function(passmap, xtarget, ytarget, maxdist, includefunc, returnpassmapval, returndist)
                -- Quickly check this position ish't bad to begin with
                if not passmap[xtarget][ytarget] then return nil end
                --------------------------------------------------------------------
                -- some helper functions
                local posTabFind = function(array, a, b)
                    for i, v in array do
                        if v[1] == a and v[2] == b then
                            return true
                        end
                    end
                end
                --------------------------------------------------------------------
                --Limit area to loop over to square around the circle that's going to change
                local xstart = max(xtarget-maxdist,1)
                local xend = min(xtarget+maxdist, table.getn(passmap))
                local ystart = max(ytarget-maxdist,1)
                local yend = min(ytarget+maxdist, table.getn(passmap[1]))
                --------------------------------------------------------------------
                local validated = {}
                local invalidated = {}
                -- pre-emptively add this, since we don't check this later ---------
                if ( not includefunc or includefunc[1] and includefunc[1]({xtarget, ytarget}, includefunc[2]) ) then
                    validated[1] = {xtarget, ytarget, returnpassmapval and passmap[xtarget][ytarget], returndist and 0}
                end
                --------------------------------------------------------------------
                --Within the caclulated bounds
                for x = xstart, xend do
                    for y = ystart, yend do
                        --Don't bother if here is impassible and Only continue if we're in range
                        local dist = VDist2(x,y,xtarget,ytarget)
                        if passmap[x][y] and dist <= maxdist and not posTabFind(validated,x,y) and not posTabFind(invalidated,x,y) then
                            if debugmode then LOG("targat: "..xtarget..", "..ytarget) end
                            local path = {{x, y, dist}} --first value filled in; we are starting from here
                            local curpos = {x,y}
                            local xtravel = xtarget - x -- distance x we have to go to get to target +/-
                            local ytravel = ytarget - y -- distance y we have to go to get to target +/-
                            if debugmode then LOG("travel: "..xtravel..", "..ytravel) end
                            local ratio = abs(ytravel) / abs(xtravel)
                            local xtravd, ytravd = 0, 0
                            --number of steps to take is one less than (abs) travel distances for both -1 since the last would be the already verified origin
                            for pathi = 1, abs(xtravel) + abs(ytravel) - 1 do
                                --go xwards if it's not 0, and x travelled dist is less than y, or if y's 0
                                if xtravel ~= 0 and (
                                    (xtravd <= ytravd or ytravel == 0) and not (xtravd == 0 and ytravd == 0) -- non-first direction check
                                    or
                                    xtravd == 0 and ytravd == 0 and abs(xtravel) > abs(ytravel) --first direction check
                                ) then
                                    --go xwards
                                    if xtravel > 0 then
                                        curpos[1] = curpos[1] + 1
                                    else
                                        curpos[1] = curpos[1] - 1
                                    end
                                    xtravd = xtravd + ratio --Add ratio instead of 1 so that it goes in as close to straight diagonal as possible
                                elseif ytravel ~= 0 then --safety check, just in case
                                    --go ywards
                                    if ytravel > 0 then
                                        curpos[2] = curpos[2] + 1
                                    else
                                        curpos[2] = curpos[2] - 1
                                    end
                                    ytravd = ytravd + 1 -- add 1, while x goes up by the ratio between the two, which could be 1 or greater or less than to keep ratio
                                end

                                --So we're at the new square, what now?

                                -- if the new square's already validated, then we can stop this line of questioning
                                --[ [
                                --disabled to prevent creeping shadows
                                if posTabFind(validated,curpos[1],curpos[2]) then
                                    if debugmode then
                                        LOG("break for validated")
                                        LOG(repr(path))
                                        coroutine.yield(1)
                                    end
                                    break
                                end
                                ] ]
                                --Mark that we've been here
                                insert(path, {curpos[1], curpos[2]})

                                --if passmap says it's bad or we
                                if not passmap[curpos[1] ][curpos[2] ] then--or posTabFind(invalidated,curpos[1],curpos[2]) then --disabled to prevent creeping shadows
                                    --then yeet everything on the path
                                    for i, pos in path do --and the horse you rode in on
                                        insert(invalidated, {pos[1], pos[2]})
                                    end
                                    if debugmode then
                                        LOG("break for invalidated")
                                        LOG(repr(path))
                                        coroutine.yield(1)
                                    end
                                    path = nil
                                    break --and stop looking, we'll deal with things closer in when we get there
                                end
                            end
                            if debugmode then
                                LOG(repr(path))
                                coroutine.yield(1)
                            end
                            --if we made it here and have a path, and it's all valid
                            if path then
                                for i, pos in path do
                                    --LOG(includefunc, pos, includefunc[1](pos, includefunc[2]) )
                                    if ( not includefunc or includefunc[1] and includefunc[1](pos, includefunc[2]) ) then

                                        if returndist and not pos[3] then
                                            dist = VDist2(pos[1],pos[2],xtarget,ytarget)
                                        elseif not returndist and pos[3] then
                                            pos[3] = nil
                                        end
                                        if not posTabFind(validated,pos[1],pos[2]) then --Added 'cause without the posTabFind functions we can end up with dupes
                                            --the and opperator is basicaly "if the thing before is true, returm the thing after instead"
                                            insert(validated, {pos[1], pos[2], returnpassmapval and passmap[pos[1] ][pos[2] ], returndist and (pos[3] or dist)} )
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                return validated
            end
            --------------------------------------------------------------------
            --
            --[ [for i, PoIpos in pointsOfInterest do
                if markermap[PoIpos[1] ][PoIpos[2] ] == 0 then
                    local visarea = GetAreaInLoS(passmap, PoIpos[1], PoIpos[2], markerCheckDistance)
                    local highval, highdist, highpoint = 0
                    local type = type
                    for j, GridPos in visarea do
                        if passmap[GridPos[1] ][GridPos[2] ] >= highval and type(markermap[GridPos[1] ][GridPos[2] ]) == 'number' and markermap[GridPos[1] ][GridPos[2] ] == 0 then
                            local testdis = VDist2(PoIpos[1],PoIpos[2],GridPos[1],GridPos[2])
                            if passmap[GridPos[1] ][GridPos[2] ] > highval or passmap[GridPos[1] ][GridPos[2] ] == highval and testdis < highdist then
                                highpoint = GridPos
                                highval = passmap[GridPos[1] ][GridPos[2] ]
                                highdist = testdis
                            end
                        end
                    end
                    markermap[highpoint[1] ][highpoint[2] ] = "Marker"
                    for j, GridPos in GetAreaInLoS(passmap, highpoint[1], highpoint[2], markerCheckDistance) do
                        if type(markermap[GridPos[1] ][GridPos[2] ]) == 'number' then
                            markermap[GridPos[1] ][GridPos[2] ] = markermap[GridPos[1] ][GridPos[2] ] + 1
                        end
                    end
                end
            end] ]

            --------------------------------------------------------------------
            -- BRING IT ALL TOGETHER BOIS
            for i, PoIpos in pointsOfInterest do
                -- helper function to filter the args returned by GetAreaInLoS. Used to check against highpointmap for "good" places for markers
                local checkpos = function(pos, args)
                    return args[1][pos[1] ][pos[2] ] >= args[2]
                end
                --"Good" marker areas have markerCheckDistance added to their distance to unpassable in highpointsmap. Flat areas plateau at markerCheckDistance
                --So this will output the plateaus and the good marker areas
                local visarea = GetAreaInLoS(passmap, PoIpos[1], PoIpos[2], markerCheckDistance, {checkpos, {highpointsmap, markerCheckDistance}}, true, false)
                --{x,y,passmap value, distance from input target}
                -- Sort by passmap value. Highest first.
                table.sort(visarea, function(a,b) return a[3] > b[3] end)

                -- Helper function. Set down the marker on the marker list and map
                local CreateMarker = function(x, y)
                    local mnum = table.getn(markerlist)
                    local markername = 'MARKER_'..mnum
                    markermap[x][y] = markername
                    markerlist[markername] = {
                        adjacentTo = '',
                        type = 'Path Node',--'Land Path Node' - 'Amphibious Path Node',
                        position = { x, 0, y },
                    }
                    return markername
                end

                --Just take the first value at this point
                local markername = CreateMarker(visarea[1][1], visarea[1][2])

                visarea = GetAreaInLoS(passmap, markerlist[markername].position[1], markerlist[markername].position[3], markerCheckDistance, nil, true, true)
                -- Sort by highpointmap value. Highest first.
                table.sort(visarea, function(a,b) return highpointsmap[a[1] ][a[2] ] > highpointsmap[b[1] ][b[2] ] end)
                do
                    -- Loop through
                    local cuttoff
                    for i = 1, table.getn(visarea) do
                        -- If it's not a marker or impassible
                        if type(markermap[visarea[i][1] ][visarea[i][2] ]) == 'number' then
                            -- Mark it with maxdist-dist, as a system of prioritising areas. Lower numbers are better for placing a marker there.
                            markermap[visarea[i][1] ][visarea[i][2] ] = math.max(markermap[visarea[i][1] ][visarea[i][2] ], markerCheckDistance - visarea[i][4])
                            --If this area has previously been marked as not good enough for a merker
                            if not cuttoff and highpointsmap[visarea[i][1] ][visarea[i][2] ] < markerCheckDistance then
                                cuttoff = i
                            end
                        end
                    end
                    --Loop backwards down the list and remove everything from and after the cuttoff
                    if cuttoff then
                        LOG(cuttoff)
                        local i = table.getn(visarea)
                        LOG(i)
                        while i > cuttoff do
                            --YEET
                            table.remove(visarea, i)
                            i = i - 1
                        end
                    end
                end
                --Sort by distance to the marker
                table.sort(visarea, function(a,b) return a[4] > b[4] end)
                --for
                    --list points by angle atan2 ect, group them by angle, pick highpointmap highest from each group as a marker

                --local highval, highdist, highpoint = 0
                --local type = type
                LOG(repr(visarea))
                break
            end

        end


]]


        --self.ConvertXYTableToYXTabDelim(markermap)
        --return markermap
    end,


    PrintMarkerListFormatting = function(markers)
        local st = ''
        for name, marker in markers do
            st = st.."['"..name.."'] = {\n"
            for dnam, dat in marker do
                if dnam ~= 'zones' and dnam ~= 'adjacentList' then
                    st = st.."    ['"..dnam.."'] = "
                    if type(dat) == 'table' then
                        st = st..'VECTOR3( '..dat[1]..", "..dat[2]..", "..dat[3]..' ),\n'
                    elseif type(dat) == 'string' then
                        st = st.. "STRING( '"..dat.."' ),\n"
                    elseif type(dat) == 'number' then
                        st = st.. "FLOAT( "..dat.." ),\n"
                    else
                        st = st..string.upper(type(dat)).."( '"..tostring(dat).."' ),\n"
                    end
                end
            end
            st = st..'},\n'
        end
        LOG(st)
    end,


    ConvertXYTableToYXTabDelim = function(map)
        --Transpose the table
        local TYX = {}
        local getn = table.getn
        for i = 0, getn(map[1]) do
            TYX[i] = {}
            for j = 0, getn(map) do
                TYX[i][j] = map[j][i]
            end
        end
        --Format for logging
        for i = 0, getn(TYX) do
            local string = ''
            for j = 0, getn(TYX[i]) do
                if TYX[i][j] == nil then
                    string = string .. 'nil' ..','
                else
                    string = string .. tostring(TYX[i][j]) ..','
                end
            end
            LOG(string)
            coroutine.yield(1)
        end
    end,
}

TypeClass = ZZZ0004
