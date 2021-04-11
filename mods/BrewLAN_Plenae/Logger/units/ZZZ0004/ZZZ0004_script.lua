local Unit = import('/lua/sim/unit.lua').Unit

ZZZ0004 = Class(Unit) {
    ----------------------------------------------------------------------------
    -- Implementation specific UI Hacks
    OnCreate = function(self)
        Unit.OnCreate(self)
        --self:ForkThread(self.TranslateAllMarkers)
        self:SetScriptBit('RULEUTC_IntelToggle', true)
        self:SetScriptBit('RULEUTC_ProductionToggle', true)
        self:SetScriptBit('RULEUTC_GenericToggle', true)
    end,

    --Some quick control buttons
    OnScriptBitSet = function(self, bit)
        Unit.OnScriptBitSet(self, bit)
        if bit == 1 then self:Destroy()
        elseif bit == 3 then self.Land = true; LOG("Land on")
        elseif bit == 4 then self.Amph = true; LOG("Amph on")
        elseif bit == 6 then self.Water = true; LOG("Water on")
        elseif bit == 8 then
            self:SetScriptBit('RULEUTC_CloakToggle', false)
            local waterratio = moho.aibrain_methods.GetMapWaterRatio(ArmyBrains[1])
            if self.Land and waterratio < 0.95 then
                self:ForkThread(self.MapTerrainDeltaTable,1) --Land
            end
            if self.Amph and waterratio < 0.95 and waterratio > 0.025 then
                self:ForkThread(self.MapTerrainDeltaTable,2) --Amph
            end
            if self.Water and waterratio > 0.1 then
                self:ForkThread(self.MapTerrainDeltaTable,3) --Water
            end
        end
    end,

    OnScriptBitClear = function(self, bit)
        Unit.OnScriptBitClear(self, bit)
            if bit == 3 then self.Land = false; LOG("Land off")
        elseif bit == 4 then self.Amph = false; LOG("Amph off")
        elseif bit == 6 then self.Water = false; LOG("Water off")
        end
    end,

    ----------------------------------------------------------------------------
    -- The beans. Give it
    --markerType expected to be a number from 1 to 3
    MapTerrainDeltaTable = function(self, markerType)
        coroutine.yield(1)
        ------------------------------------------------------------------------
        -- Marker data
        local markerTypes = {
            { type = 'Land Path Node',       color = 'ff00ff00', graph = 'DefaultLand',       name = 'LandPM',  land = true,  water = false,                    MaxSlope=0.75},
            { type = 'Amphibious Path Node', color = 'ff00ffff', graph = 'DefaultAmphibious', name = 'AmphPM',  land = true,  water = true, MaxWaterDepth = 25, MaxSlope=0.75},
            { type = 'Water Path Node',      color = 'ff0000ff', graph = 'DefaultWater',      name = 'WaterPM', land = false, water = true, MinWaterDepth = 1.5},
        }
        local maxGroundVariation = 0.75  -- This is only here because it pre-dates the markerTypes definitions, and it's uses are hard coded instead of based on markerType data.
        markerType = markerTypes[markerType]

        ------------------------------------------------------------------------
        -- Output settings -----------------------------------------------------
        local exportMarkersToLog = false --Produce copy-pasta-able log export
        local drawMarkersToMap = true    --Give a representation of the marker data
        local timeProfileOutput = true and GetSystemTimeSecondsOnlyForProfileUse() --Check how long this took
        local drawVoronoiToMap = false   --Debug view for seeing what the data is seeing.
        --local debugmode = false  -- This is only used by commented out sections

        ------------------------------------------------------------------------
        -- Unpassable areas map cleanup toggles --------------------------------
        local doQuickCleanup = true -- These are mostly obselete, but can potentially save time later
        local cleanupPasses = 1 -- Numbers greater than 1 only really have effect if doDeAlcove is on
        local doDespeckle = true -- removes single unconnected grids of unpassable (8 point check) --Obseleted by ignoreMinZones, but a much quicker function.
        local doDeIsland = false -- removes single unconnected grids of passable (4 point check) --Obselete by voronoi function
        local doDeAlcove = false -- removes single grids of passable with 3 unpassable grids cardinally adjacent (4 point check) --Obselete by voronoi function.

        ------------------------------------------------------------------------
        -- Voronoi input options -----------------------------------------------
        local voronoiGridsNumber = math.min(16, ScenarioInfo.size[1]/32) -- 16 is threat grid size, non-power 2 numbers looked bad on Theta. Non-16 numbers don't interact well with threat map. 16 can cause distance based marker checks to take longer on 5k maps. Geater than 16 isn't supported by the actual grid function because it takes names from a 16 length array
        local voronoiCheckDistance = math.min(128, ScenarioInfo.size[1]/(voronoiGridsNumber*2)--[[, 10]]) -- Less than a half a grid-width (a 32nd with 16ths grids) can cause ghost connections without doContiguousGridCheck true, and should come with a warning. Bermuda Locket land nodes look good with 8.
        local voronoiCheckDistanceSq = math.pow(voronoiCheckDistance, 2) --This is just for optimisation

        ------------------------------------------------------------------------
        -- Voronoi cleanup options ---------------------------------------------
        local minContigiousZoneArea = 30 -- size cuttoff for giving a shit about a blocking area
        local ignoreMinZones = true -- treat small zones as though they dont exist.
        local doEdgeCullLargestZones = false -- creates a gap between the two largest blocking zones that gets filled with grid. Can fix some issues on maps like Bermuda Locket without super agressive modofication to the voronoi. doContiguousGridCheck might be needed
        local doEdgeCullAllZones = false -- Agressively creates gaps between the any voronoi zone. Can fix concave areas, narrow paths, and other problem areas. doContiguousGridCheck probably essential.
        local voronoiEdgeCullOffset = 5 -- The distance that the edge cull should affect. Radius, square.
        local doContiguousGridCheck = true -- Slower grid generation that checks grid cells aren't cut up by terrain features, preventing grid-based ghost connections.
        --local incorporateMinZones = false -- unfinished (intended to have small zones count as their nearest zone large enough zone) Should be mutually exclusive with ignoreMinZones

        ------------------------------------------------------------------------
        -- Marker options ------------------------------------------------------
        --local pointOfInterestTypes = {'Start Location', 'Mass', 'Hydrocarbon'} --Voronoi based setup doesn't care.

        ------------------------------------------------------------------------
        -- Marker cleanup options ----------------------------------------------
        local MarkerMinDist = math.sqrt(ScenarioInfo.size[1]) -- sqrt of map size is usually a good default -- radius, square -- prevents creation of markers with other markers in this radius moves the other marker to halfway between the two. Opperation is very order dpenendant.
        local doRemoveIsolatedMarkers = true -- If a marker has no connections, YEET

        ------------------------------------------------------------------------
        -- Data storage --------------------------------------------------------
        local passmap = {}  --Populate with false for impassible or distance to nearest false
        local voronoimap = {} --Populate with zones around unpassable areas as a voronoi map
        local markerlist = {} --List of markers

        ------------------------------------------------------------------------
        -- Obselete stuff ------------------------------------------------------
        --local deltamap = {} --Populate with the local evalation differencees
        --local passmapMinCont = {}
        --local voronoiedgelist = {} --hashmap of voronoi zone IDs that touch the border; to prevent them from being ignored by the minContigiousZoneArea value
        --local markermap = {} --Map of markers
        --local pointsOfInterest = {} --Populated with an array of 2 point co-ords of interesting markers

        ------------------------------------------------------------------------
        -- Global functions called potentially over a million times (remove some overhead)
        local GTH, VDist2Sq = GetTerrainHeight, VDist2Sq
        local max, min, abs, floor = math.max, math.min, math.abs, math.floor
        local insert, remove, getn, copy, find, merged = table.insert, table.remove, table.getn, table.copy, table.find, table.merged

        ------------------------------------------------------------------------
        -- tiny generic helper functions I use, or might use in more than once place
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
        -- DO IT ---------------------------------------------------------------
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- Evaluate and store map data. ----------------------------------------
        for x = 0, ScenarioInfo.size[1]+1 do --Start one below and one above map size in order to;
            --deltamap[x] = {}
            passmap[x] = {}
            --passmapMinCont[x] = {}
            --markermap[x] = {}
            voronoimap[x] = {}
            for y = 0, ScenarioInfo.size[2]+1 do
                --Create a ring of unpassable around the outside
                if x == 0 or y == 0 or x == ScenarioInfo.size[1]+1 or y == ScenarioInfo.size[2]+1 then
                    --deltamap[x][y] = 255
                    passmap[x][y] = false
                    --markermap[x][y] = "border"
                    voronoimap[x][y] = "border"
                else
                    --Get heights around point
                    --Yes, these same points will be checked up to 4 times, but that's a lot to cache
                    local a, b, c, d -- If we don't care about land, dont bother.
                    if markerType.land then a, b, c, d = GTH(x-1,y-1), GTH(x-1,y), GTH(x,y), GTH(x,y-1) end
                    --This takes diagonal difference into account, which is inaccurate
                    --local delta = max(a,b,c,d) - min(a,b,c,d)
                    --This specifically ignores diagonal difference, which appears to be the way it's done in game
                    local delta -- If we don't care about land, dont bother.
                    if markerType.land then delta = max(abs(a-b), abs(b-c), abs(c-d), abs(d-a)) end

                    local terrainTypeCheck = function(x,y)
                        local tt = GetTerrainType(x,y)
                        return tt ~= 'Dirt09' and tt ~= 'Lava01'
                    end

                    local waterCheck = function(markerType, x, y, c)
                        if markerType.water and markerType.land then
                            return c + (markerType.MaxWaterDepth or 25) > GetSurfaceHeight(x, y)
                        end
                        local w = GetSurfaceHeight(x, y)
                        return (markerType.water and w > (GTH(x,y) + (markerType.MinWaterDepth or 1.5))) or (markerType.land and w <= c)
                    end
                    --deltamap[x][y] = delta
                    if (markerType.land and delta <= maxGroundVariation or not markerType.land) and terrainTypeCheck(x,y) and waterCheck(markerType, x, y, c) then
                        --previously `passmap[x][y] = delta <= maxGroundVariation`
                        --Set up for the vector check for min dist from false
                        passmap[x][y] = voronoiCheckDistanceSq
                        --markermap[x][y] = 0
                        voronoimap[x][y] = ''
                    else
                        passmap[x][y] = false
                        --markermap[x][y] = false
                        voronoimap[x][y] = false
                    end
                end
            end
        end

        ------------------------------------------------------------------------
        -- Heightmap data cleanup. Mostly obselete, mostly harmless. -----------
        if doQuickCleanup and cleanupPasses ~= 0 then
            for i = 1, cleanupPasses do
                for x, ydata in passmap do
                    for y, pass in ydata do
                        -- Despeckle; remove isolated single grid impassible areas with no orthoganally adjacent other impassible areas
                        if doDespeckle then
                            if not pass
                            and passmap[x][y-1] and passmap[x-1][y-1] and passmap[x-1][y] and passmap[x-1][y+1]
                            and passmap[x][y+1] and passmap[x+1][y-1] and passmap[x+1][y] and passmap[x+1][y+1]
                            --and deltamap[x][y] <= maxGroundVariation * 1.5
                            then
                                --remove isolated false sections unless they are hefty
                                passmap[x][y] = voronoiCheckDistanceSq
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
        -- Calculates content for passmap and voronoimap
        -- Passmap is distance to the nearest unpathable
        -- Voronoimap is which block of unpathable it's from
            -- Sweeps through all unpassable areas, walking through all contiguous areas and marking them as so,
            -- then mark off distances to high points, and which high point is closer
        do -- do block to limit locals

            local CrawlerPath = {}
            local ZoneSizes = {}
            local MapCrawler
            local MapDistanceVoronoi

            -- done from the perspective of the impassible area grid, and checking outwards for pathable areas to mark
            MapDistanceVoronoi = function(passmap, voronoimap, xtarget, ytarget, maxdist, blockid)--, smallOWMode)
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
                            local dist = VDist2Sq(x,y,xtarget,ytarget)
                            if dist < passmap[x][y] then
                                passmap[x][y] = dist
                                voronoimap[x][y] = blockid
                            end
                        --[[elseif smallOWMode and not passmap[x][y] and ZoneSizes[blockid] and ZoneSizes[blockid] < minContigiousZoneArea then
                            local dist = VDist2Sq(x,y,xtarget,ytarget)
                            if not passmapMinCont[x][y] or dist < passmapMinCont[x][y] then
                                --this way of reassigning the smaller zones cause issues for areas near to two larger zones, and is non-contiguous
                                passmapMinCont[x][y] = dist
                                voronoimap[x][y] = blockid
                            end]]
                        end
                    end
                end
            end

            --Crawler function for gathering contiguous areas.
            MapCrawler = function(passmap, voronoimap, x, y, voronoiCheckDistance, blockid, borderMode)
                for _, adj in {{0,0},{0,-1},{-1,0},{0,1},{1,0},{-1,1},{1,-1},{-1,-1},{1,1}} do

                    --Separate the border where it touches a zone, but dont crawl along it. 6 and greater are intercardinals.
                    if not borderMode and voronoimap[x+adj[1] ][y+adj[2] ] == 'border' and _ < 6 then

                        voronoimap[x+adj[1] ][y+adj[2] ] = blockid
                        ZoneSizes[blockid] = ZoneSizes[blockid] + 1 + (minContigiousZoneArea or 0) --Add this so we never ignore border zones, since that would be bad.

                        --voronoiedgelist[blockid] = true
                    end
                    if voronoimap[x+adj[1] ][y+adj[2] ] == false or borderMode and voronoimap[x+adj[1] ][y+adj[2] ] == 'border' then

                        voronoimap[x+adj[1] ][y+adj[2] ] = blockid
                        if not borderMode then
                            ZoneSizes[blockid] = ZoneSizes[blockid] + 1
                        end
                        insert(CrawlerPath, {x+adj[1], y+adj[2]})

                    end
                end
            end

            --Input data looks like:
--[[ voronoimap = (abridged) b = "border" f = false
b,f,f,f,f,f,f,f,f, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,f,f,f,f,f, , , , ,b,
b,f,f,f,f,f,f,f, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,f,f,f,f, , , ,b,
b, , , , ,f,f, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,f,f,f,f, , , , , , , , , , , , , ,f,f,f,f, , ,b,
b, , , , , , , , , , , , , , , , , , , , , , ,f,f, , , , , , , , , , , , , , , , , ,f,f,f,f,f, , , , , , , , , , , , , ,f,f,f,f,f,b,
b, , , , , , , , , , , , , , , , , , , , , ,f,f,f, , , , , , , ,f, , , , , , , , , , , , , ,f,f, , , , , , , , , , , , , ,f,f,f,f,b,
b, , , , , , , , , , , , , , , , , , , , , ,f,f,f, , , , , , ,f,f, , , , , , , , , , , , , ,f,f, , , , , , , , , , , , , , , ,f,f,b,
b, , , , , , , , , , , , , , , , , , , , ,f,f,f,f, , , , , , ,f,f, , , , , , , , , , , , , ,f,f, , , , , , , , , , , , , , , , ,f,b,
b, , , , , , , , , , , , , , , , , , , , ,f,f,f, , , , , , , ,f,f, , , , , , , , , , , , , ,f,f, , , , , , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , , , ,f,f,f,f,f, , , , , , , ,f,f,f, , , , , , , , , , , , ,f,f,f, , , , , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , , , ,f,f,f,f, , , , , , , , ,f,f,f, , , , , , , , , , , , ,f,f,f, , , , , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , , ,f,f,f,f, , , , , , , , , ,f,f,f, , , , , , , , , , , , , ,f,f, , , , , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,f,f,f,f, , , , , , , , , , ,f,f,f, , , , , , , , , , , , , ,f,f,f,f, , , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,f,f,f, , , , , , , , , , , ,f,f,f, , , , , , , , , , , , , ,f,f,f,f,f, , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,f,f, , , , , , , , , , , , ,f,f,f, , , , , , , , , , , , , , , ,f,f,f, , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,f,f,f, , , , , , , , , , , , ,f,f, , , , , , , , , , , , , , , , ,f,f, , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,f,f,f, , , , , , , , , , , , ,f,f, , , , , , , , , , , , , , , , ,f,f,f, , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,f,f,f, , , , , , , , , , , ,f,f,f, , , , , , , , , , , , , , , , ,f,f,f, , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,f,f, , , , , , , , , , , ,f,f,f,f, , , , , , , , , , , , , , , , ,f,f,f,f, , , , , , , , , , , ,b,
b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,
]]
            --if true then self.ConvertXYTableToYXCommaDelim(voronoimap); return end
            --------------------------------------------------------------------
            -- Map out contigious areas of unpathable areas, splitting border as we go
            local blockid = 0
            for x, ydata in passmap do
                for y, pass in ydata do
                    if not pass and not voronoimap[x][y] then
                        blockid = blockid + 1
                        if not ZoneSizes[blockid] then ZoneSizes[blockid] = 0 end
                        MapCrawler(passmap, voronoimap, x, y, voronoiCheckDistance, blockid)
                        while CrawlerPath[1] do
                            MapCrawler(passmap, voronoimap, CrawlerPath[1][1], CrawlerPath[1][2], voronoiCheckDistance, blockid)
                            remove(CrawlerPath, 1)
                        end
                    end
                end
            end
--[[ voronoimap = (abridged) b = "border" (leading 1's removed for visibility)
3,3,3,3,3,3,3,3,3, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,2,2,2,2,2, , , , ,b,
3,3,3,3,3,3,3,3, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,2,2,2,2, , , ,b,
b, , , , ,3,3, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,0,0,0,0, , , , , , , , , , , , , ,2,2,2,2, , ,b,
b, , , , , , , , , , , , , , , , , , , , , , ,5,5, , , , , , , , , , , , , , , , , ,0,0,0,0,0, , , , , , , , , , , , , ,2,2,2,2,2,2,
b, , , , , , , , , , , , , , , , , , , , , ,5,5,5, , , , , , , ,7, , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , ,2,2,2,2,2,
b, , , , , , , , , , , , , , , , , , , , , ,5,5,5, , , , , , ,7,7, , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , , , ,2,2,2,
b, , , , , , , , , , , , , , , , , , , , ,5,5,5,5, , , , , , ,7,7, , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , , , , ,2,2,
b, , , , , , , , , , , , , , , , , , , , ,5,5,5, , , , , , , ,7,7, , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , , , ,5,5,5,5,5, , , , , , , ,7,7,7, , , , , , , , , , , , ,0,0,0, , , , , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , , , ,5,5,5,5, , , , , , , , ,7,7,7, , , , , , , , , , , , ,0,0,0, , , , , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , , ,5,5,5,5, , , , , , , , , ,7,7,7, , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,5,5,5,5, , , , , , , , , , ,7,7,7, , , , , , , , , , , , , ,0,0,0,0, , , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,5,5,5, , , , , , , , , , , ,7,7,7, , , , , , , , , , , , , ,0,0,0,0,0, , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,5,5, , , , , , , , , , , , ,7,7,7, , , , , , , , , , , , , , , ,0,0,0, , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,5,5,5, , , , , , , , , , , , ,7,7, , , , , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,5,5,5, , , , , , , , , , , , ,7,7, , , , , , , , , , , , , , , , ,0,0,0, , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,5,5,5, , , , , , , , , , , ,7,7,7, , , , , , , , , , , , , , , , ,0,0,0, , , , , , , , , , , , ,b,
b, , , , , , , , , , , , , , , , ,5,5, , , , , , , , , , , ,7,7,7,7, , , , , , , , , , , , , , , , ,0,0,0,0, , , , , , , , , , , ,b,
b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,5,5,b,b,b,b,b,b,b,b,b,b,b,7,7,7,7,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,0,0,0,0,b,b,b,b,b,b,b,b,b,b,b,b,
]]
            --if true then self.ConvertXYTableToYXCommaDelim(voronoimap); return end
            --------------------------------------------------------------------
            -- Do the same for the border segments
            local xmax, ymax = getn(passmap), getn(passmap[1])
            for x = 0, xmax do
                for _, y in {0, ymax} do
                    if voronoimap[x][y] == 'border' then
                        blockid = blockid + 1
                        MapCrawler(passmap, voronoimap, x, y, voronoiCheckDistance, blockid, true)
                        while CrawlerPath[1] do
                            MapCrawler(passmap, voronoimap, CrawlerPath[1][1], CrawlerPath[1][2], voronoiCheckDistance, blockid, true)
                            remove(CrawlerPath, 1)
                        end
                    end
                end
            end
            for y = 0, xmax do
                for _, x in {0, ymax} do
                    if voronoimap[x][y] == 'border' then
                        blockid = blockid + 1
                        MapCrawler(passmap, voronoimap, x, y, voronoiCheckDistance, blockid, true)
                        while CrawlerPath[1] do
                            MapCrawler(passmap, voronoimap, CrawlerPath[1][1], CrawlerPath[1][2], voronoiCheckDistance, blockid, true)
                            remove(CrawlerPath, 1)
                        end
                    end
                end
            end

--[[ voronoimap = (abridged) (1's removed for visibility)
3,3,3,3,3,3,3,3,3, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,2,2,2,2,2, , , , ,24,
3,3,3,3,3,3,3,3, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,2,2,2,2, , , ,24,
5, , , , ,3,3, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,0,0,0,0, , , , , , , , , , , , , ,2,2,2,2, , ,24,
5, , , , , , , , , , , , , , , , , , , , , , ,5,5, , , , , , , , , , , , , , , , , ,0,0,0,0,0, , , , , , , , , , , , , ,2,2,2,2,2,2,
5, , , , , , , , , , , , , , , , , , , , , ,5,5,5, , , , , , , ,7, , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , ,2,2,2,2,2,
5, , , , , , , , , , , , , , , , , , , , , ,5,5,5, , , , , , ,7,7, , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , , , ,2,2,2,
5, , , , , , , , , , , , , , , , , , , , ,5,5,5,5, , , , , , ,7,7, , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , , , , ,2,2,
5, , , , , , , , , , , , , , , , , , , , ,5,5,5, , , , , , , ,7,7, , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , , , , , ,2,
5, , , , , , , , , , , , , , , , , , ,5,5,5,5,5, , , , , , , ,7,7,7, , , , , , , , , , , , ,0,0,0, , , , , , , , , , , , , , , , ,2,
5, , , , , , , , , , , , , , , , , , ,5,5,5,5, , , , , , , , ,7,7,7, , , , , , , , , , , , ,0,0,0, , , , , , , , , , , , , , , , ,2,
5, , , , , , , , , , , , , , , , , ,5,5,5,5, , , , , , , , , ,7,7,7, , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , , , , ,2,
5, , , , , , , , , , , , , , , , ,5,5,5,5, , , , , , , , , , ,7,7,7, , , , , , , , , , , , , ,0,0,0,0, , , , , , , , , , , , , , ,2,
5, , , , , , , , , , , , , , , , ,5,5,5, , , , , , , , , , , ,7,7,7, , , , , , , , , , , , , ,0,0,0,0,0, , , , , , , , , , , , , ,2,
5, , , , , , , , , , , , , , , , ,5,5, , , , , , , , , , , , ,7,7,7, , , , , , , , , , , , , , , ,0,0,0, , , , , , , , , , , , , ,2,
5, , , , , , , , , , , , , , , , ,5,5,5, , , , , , , , , , , , ,7,7, , , , , , , , , , , , , , , , ,0,0, , , , , , , , , , , , , ,2,
5, , , , , , , , , , , , , , , , ,5,5,5, , , , , , , , , , , , ,7,7, , , , , , , , , , , , , , , , ,0,0,0, , , , , , , , , , , , ,2,
5, , , , , , , , , , , , , , , , ,5,5,5, , , , , , , , , , , ,7,7,7, , , , , , , , , , , , , , , , ,0,0,0, , , , , , , , , , , , ,2,
5, , , , , , , , , , , , , , , , ,5,5, , , , , , , , , , , ,7,7,7,7, , , , , , , , , , , , , , , , ,0,0,0,0, , , , , , , , , , , ,2,
5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,0,0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,
]]  --if true then self.ConvertXYTableToYXCommaDelim(voronoimap); return end
            --------------------------------------------------------------------

            --Check actions are required with the incorporateMinZones or ignoreMinZones actions
            local smallZonesNum = 0
            if --[[incorporateMinZones or]] ignoreMinZones then
                for zone, no in ZoneSizes do
                    if no <= minContigiousZoneArea then
                        smallZonesNum = smallZonesNum + 1
                        break
                    end
                end
            end

            --Just remove the zones rather than specifically ignoring them, simplify future actions
            if ignoreMinZones and smallZonesNum > 0 then
                for x, ydata in passmap do
                    for y, pass in ydata do
                        if not pass and voronoimap[x][y] and ZoneSizes[voronoimap[x][y] ] and ZoneSizes[voronoimap[x][y] ] <= minContigiousZoneArea then
                            passmap[x][y] = voronoiCheckDistanceSq
                            voronoimap[x][y] = ''
                        end
                    end
                end
            end

            -- find the nearest zones to the small zones, and merge them
            -- Dont bother if ignore is on. There are none.
            --[[if incorporateMinZones and not ignoreMinZones and smallZonesNum > 0 then
                --[ [for x, ydata in passmap do
                    for y, pass in ydata do
                        if passmapMinCont[x][y]
                        and (passmap[x-1][y  ] or passmap[x  ][y-1] or passmap[x+1][y  ] or passmap[x  ][y+1])
                        then
                            MapDistanceVoronoi(passmap, voronoimap, x, y, voronoiCheckDistance, blockid)
                        end
                    end
                end] ]
            end]]

            -- Generate the voronoi areas
            for x, ydata in passmap do
                for y, pass in ydata do
                    if not pass
                    --and voronoimap[x][y] ~= ''
                    --and (not ZoneSizes[voronoimap[x][y] ] or ZoneSizes[voronoimap[x][y] ] >= minContigiousZoneArea)
                    and (passmap[x-1][y  ] or passmap[x  ][y-1] or passmap[x+1][y  ] or passmap[x  ][y+1])
                    then
                        MapDistanceVoronoi(passmap, voronoimap, x, y, voronoiCheckDistance, voronoimap[x][y])--, true)
                    end
                end
            end
--[[  voronoimap =
INFO: 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,6,10,10,10,10,10,10,10,10,10,10,10,10,12,12,12,12,12,12,12,12,12,12,12,12,12,12,24,24,24,
INFO: 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,12,12,12,12,12,12,12,12,12,12,12,12,12,12,24,24,
INFO: 15,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12,12,12,12,12,12,12,12,12,12,12,12,12,12,24,
INFO: 15,15,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
INFO: 15,15,15,3,3,3,3,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12,12,12,12,12,12,12,12,12,12,12,12,12,
INFO: 15,15,15,15,3,3,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12,12,12,12,12,12,12,12,12,12,12,12,
INFO: 15,15,15,15,15,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12,12,12,12,12,12,12,12,12,12,12,
INFO: 15,15,15,15,15,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12,12,12,12,12,12,12,12,12,21,
INFO: 15,15,15,15,15,15,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12,12,12,12,12,12,21,21,21,
INFO: 15,15,15,15,15,15,15,15,3,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12,12,12,12,21,21,21,21,21,
INFO: 15,15,15,15,15,15,15,15,15,15,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,12,21,21,21,21,21,21,21,
INFO: 15,15,15,15,15,15,15,15,15,15,15,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,21,21,21,21,21,21,21,21,
INFO: 15,15,15,15,15,15,15,15,15,15,15,15,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,18,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,21,21,21,21,21,21,21,21,
INFO: 15,15,15,15,15,15,15,15,15,15,15,15,15,5,5,5,5,5,5,5,5,5,5,5,5,5,17,7,7,7,7,7,7,7,7,7,7,7,7,18,18,18,18,10,10,10,10,10,10,10,10,10,10,10,10,10,10,21,21,21,21,21,21,21,21,21,
INFO: 15,15,15,15,15,15,15,15,15,15,15,15,15,15,5,5,5,5,5,5,5,5,5,5,17,17,17,17,7,7,7,7,7,7,7,7,7,7,18,18,18,18,18,18,10,10,10,10,10,10,10,10,10,10,10,10,21,21,21,21,21,21,21,21,21,21,
INFO: 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,5,5,5,5,5,5,5,5,17,17,17,17,17,7,7,7,7,7,7,7,7,7,18,18,18,18,18,18,18,18,18,18,10,10,10,10,10,10,10,10,10,21,21,21,21,21,21,21,21,21,21,
INFO: 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,5,5,5,5,5,5,17,17,17,17,17,17,17,7,7,7,7,7,7,7,18,18,18,18,18,18,18,18,18,18,18,18,18,10,10,10,10,10,10,21,21,21,21,21,21,21,21,21,21,21,
INFO: 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,5,5,5,17,17,17,17,17,17,17,17,17,17,7,7,7,7,7,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,10,10,10,10,10,21,21,21,21,21,21,21,21,21,21,21,
INFO: 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,5,5,17,17,17,17,17,17,17,17,17,17,17,7,7,7,7,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,10,10,10,10,21,21,21,21,21,21,21,21,21,21,21,21,
]]          --if true then self.ConvertXYTableToYXCommaDelim(voronoimap); return end
            --------------------------------------------------------------------
            --

            --This produces a gap between the two largest zones to be filled in with grid, so that maps with two large zones that touch at multiple places don't cause issues.
            --If this was done to the connections on every pair of zones that connect at more than one place, and every long winding connection, this would probably fix most of the concentric/concave path issues.
            if doEdgeCullLargestZones then
                local largest, secondl
                for k, v in ZoneSizes do
                    if not largest or ZoneSizes[largest] < v then
                        largest = k
                    end
                    if not secondl and k ~= largest or secondl and k ~= largest and ZoneSizes[secondl] < v then
                        secondl = k
                    end
                end
                if largest and secondl and largest ~= secondl then
                    local voronoimapCopy = table.deepcopy(voronoimap)
                    --LOG(largest..": "..ZoneSizes[largest].."; "..secondl..": "..ZoneSizes[secondl])
                    for x, ydata in voronoimap do
                        for y, data in ydata do
                            local offset = voronoiEdgeCullOffset
                            if voronoimap[x-offset][y] == largest and voronoimap[x+offset][y] == secondl
                            or voronoimap[x][y-offset] == largest and voronoimap[x][y+offset] == secondl
                            or voronoimap[x-offset][y] == secondl and voronoimap[x+offset][y] == largest
                            or voronoimap[x][y-offset] == secondl and voronoimap[x][y+offset] == largest

                            or voronoimap[x-offset][y-offset] == largest and voronoimap[x+offset][y+offset] == secondl
                            or voronoimap[x+offset][y+offset] == largest and voronoimap[x-offset][y-offset] == secondl
                            or voronoimap[x-offset][y+offset] == secondl and voronoimap[x+offset][y-offset] == largest
                            or voronoimap[x+offset][y-offset] == secondl and voronoimap[x-offset][y+offset] == largest then
                                voronoimapCopy[x][y] = ''
                            end
                        end
                    end
                    voronoimap = voronoimapCopy
                end
            end

            --Experimental feature that culls the area between any
            if doEdgeCullAllZones then
                local voronoimapCopy = table.deepcopy(voronoimap)
                for x, ydata in voronoimap do
                    for y, data in ydata do
                        local offset = voronoiEdgeCullOffset
                        if voronoimap[x-offset][y] and voronoimap[x+offset][y] and voronoimap[x][y-offset] and voronoimap[x][y+offset]

                        and (voronoimap[x-offset][y] ~= voronoimap[x+offset][y]
                        or voronoimap[x][y-offset] ~= voronoimap[x][y+offset]

                        or voronoimap[x-offset][y-offset] ~= voronoimap[x+offset][y+offset]
                        or voronoimap[x+offset][y-offset] ~= voronoimap[x-offset][y+offset]) then
                            voronoimapCopy[x][y] = ''
                        end
                    end
                end
                voronoimap = voronoimapCopy
            end

            --After this point the voronoi map can have gaps in large flat areas voronoiCheckDistance away from blocking areas.
            --This fills those gaps with an offset 16x16 grid, technically 17x17 with smaller outsides, but 16x16 sized.
            --This can cause issues if voronoiCheckDistance is less than a 16th of the map.
            do
                --if doContiguousGridCheck then
                local GridContig, GridZoneI
                local GridCPath = {}

                local gs = getn(voronoimap) / voronoiGridsNumber
                local ceil = math.ceil
                local hex = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q'}

                if doContiguousGridCheck then
                    GridZoneI = 0
                    GridContig = function(map, x, z, blocki)
                        --voronoimap[x][z] = hex[ceil((x + (gs/2))/gs)]..hex[ceil((z + (gs/2))/gs)]..i
                        for _, v in {{0,1}, {1,0}, {0,-1}, {-1,0}} do

                            local hexci = hex[ceil((x+v[1] + (gs/2))/gs)]..hex[ceil((z+v[2] + (gs/2))/gs)]..blocki

                            if voronoimap[x+v[1] ][z+v[2] ] == '' and voronoimap[x][z] == hexci then
                                insert(GridCPath,{x+v[1], z+v[2]})
                                voronoimap[x+v[1] ][z+v[2] ] = hexci
                            end
                        end
                    end
                end
                for x, zdata in voronoimap do
                    for z, data in zdata do
                        if data == '' then
                            if doContiguousGridCheck then
                                GridZoneI = GridZoneI +1
                                --GridContig(voronoimap, x, z, GridZoneI)
                                voronoimap[x][z] = hex[ceil((x + (gs/2))/gs)]..hex[ceil((z + (gs/2))/gs)]..GridZoneI
                                insert(GridCPath, {x,z})
                                while GridCPath[1] do
                                    GridContig(voronoimap, GridCPath[1][1], GridCPath[1][2], GridZoneI)
                                    remove(GridCPath, 1)
                                end
                            else
                                voronoimap[x][z] = hex[ceil((x + (gs/2))/gs)]..hex[ceil((z + (gs/2))/gs)]
                            end
                        end
                    end
                end

                --[[local gs = getn(voronoimap) / voronoiGridsNumber
                local ceil = math.ceil
                local hex = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q'}
                for x, ydata in voronoimap do
                    for y, data in ydata do
                        if data == '' then
                            voronoimap[x][y] = hex[ceil((x + (gs/2))/gs)]..hex[ceil((y + (gs/2))/gs)]
                        end
                    end
                end]]
            end
        end
        --LOG(repr(voronoiedgelist))

        if drawVoronoiToMap then self:DrawGridData(voronoimap) end


        ------------------------------------------------------------------------
        -- Find all 2x2 areas containing 3 zones, and try to put a merker there
        do
            --Start at 2 so we don't ever find 'border' with this, only nearborder
            for x = 2, getn(voronoimap) - 1 do
                for y = 2, getn(voronoimap[1]) - 1 do
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

                            --[[local markerTypes = {
                                { type = 'Land Path Node',       color = 'ff00ff00', graph = 'DefaultLand',       name = 'LandPM',  land = true,  water = false },
                                { type = 'Amphibious Path Node', color = 'ff00ffff', graph = 'DefaultAmphibious', name = 'AmphPM',  land = true,  water = true  },
                                { type = 'Water Path Node',      color = 'ff0000ff', graph = 'DefaultWater',      name = 'WaterPM', land = false, water = true  },
                            }
                            local markerType = markerTypes[1] ]]

                            local mnum = tcount(markerlist)
                            local markername = markerType.name..mnum
                            --markermap[x][y] = markername
                            markerlist[markername] = {
                                color = markerType.color,
                                hint = true,
                                graph = markerType.graph,
                                adjacentTo = '',
                                zones = copy(zones),
                                type = markerType.type,
                                position = { x, GTH(x,y), y },
                                orientation = { 0, 0, 0 },
                                prop = '/env/common/props/markers/M_Blank_prop.bp',
                                adjacentList = {},
                            }

                            return markername, markerlist[markername]
                        end

                        --Filter for nearby markers, like, really near, and move the nearby markers
                        local m1name, m1data
                        if MarkerMinDist and MarkerMinDist > 0 then
                            local test = true
                            if tcount(markerlist) > 1 then
                                for m2name, m2data in markerlist do
                                    -- Square distance check to make it quicker
                                    if abs(x - m2data.position[1]) < MarkerMinDist
                                    and abs(y - m2data.position[3]) < MarkerMinDist
                                    then
                                        --Move to the average of what the two points would have been
                                        markerlist[m2name].position[1] = floor((x + m2data.position[1]) / 2)
                                        markerlist[m2name].position[3] = floor((y + m2data.position[3]) / 2)
                                        markerlist[m2name].position[2] = GTH(markerlist[m2name].position[1], markerlist[m2name].position[3])
                                        --merge the adjacency zones list
                                        markerlist[m2name].zones = merged(m2data.zones, zones)
                                        --set this marker as the active so it's passed through the connections checks again.
                                        m1name = m2name
                                        m1data = m2data
                                        test = false
                                        break
                                    --elseif m2data.positionsMerged then
                                        --for i, mpos in m2data.positionsMerged

                                        --The plan with this bit was to make order of opperations not matter for merging nodes
                                        --so instead of the current system:
                                          --go through the voronoi for good marker locations,
                                          --cross reference position for existing markers that are too close
                                          --move the first chosen too close marker to the average between the two
                                          --add adj data to the existing marker
                                          -- do adj stuff
                                        --the plan was;
                                          --instead of move there and then, add the pos to an extra array and average them all later
                                          --and to check against each pos in the array when doing the dist check
                                          --The issue with that is, in a situation where two nodes weren't too close,
                                          --but then a third that wants to be right between both, and is too close to both
                                          --------example-----
                                          --yx2345 --(an example of when this could happen)
                                          --2 #1#  --marker 1 at 3,2, marker 2 at 4,5, marker 3 at 5,3 suddenly fucks shit up
                                          --3 ###3
                                          --4  ###
                                          --5  #2#
                                          --------
                                          --suddenly we're in a situation where order matters again,
                                          --since I want to minimise removing nodes
                                          --this means all collisions need listing first, before any would be made.
                                          --Or at very least, adj data needs setting up after all that, since that's the part that's fuck to redo
                                    end
                                end
                            end
                            if test then
                                m1name, m1data = CreateMarker(x,y)
                            --else

                            end
                        else
                            m1name, m1data = CreateMarker(x,y)
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

                                        --voronoiedgelist was made redundant by splitting up the border.
                                        --[[local test = true
                                        if zonetest.nearborder then
                                            for z, b in zonetest do
                                                if z ~= 'nearborder' and voronoiedgelist[z] then
                                                    --This check can fail if there is a single path blocking area in the centre, that's adjacent to the border
                                                    test = false
                                                    break
                                                end
                                            end
                                        end
                                        if test then]]
                                            markAdjacent(m2data, m1name)
                                            markAdjacent(m1data, m2name)
                                        --end
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

        if MarkerMinDist or doRemoveIsolatedMarkers then--the whole thing shit the bed when I tried to have this done before/during the marker production
            for m1name, m1data in markerlist do--[[
                if false and MarkerMinDist then
                    if m1data.adjacentList[1] then
                        for i, m2name in m1data.adjacentList do
                            local m2data = markerlist[m2name]
                            if markerlist[m2name] and markerlist[m1name]
                            and abs(m1data.position[1] - m2data.position[1]) < MarkerMinDist
                            and abs(m1data.position[3] - m2data.position[3]) < MarkerMinDist
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

        --if true then self.ConvertXYTableToYXCommaDelim(markerlist) ; return end
        if timeProfileOutput then
            LOG(markerType.type .. " generation time: " ..  GetSystemTimeSecondsOnlyForProfileUse() - timeProfileOutput .. " seconds with " .. tcount(markerlist) .. " markers")
        end
        if drawMarkersToMap then self:DrawMarkerPaths(markerlist) end
        if exportMarkersToLog then self.PrintMarkerListFormatting(markerlist); return end


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
                            MapDistanceCoeff(passmap, x, y, voronoiCheckDistance, coefficient, Xco, Yco)
                        end
                    end
                end
            end
        end

        if true then self.ConvertXYTableToYXCommaDelim(voronoimap) ; return end
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
                        highpointsmap[x][y] = passmap[x][y] + voronoiCheckDistance
                        insert(highpointlist, {x,y,highpointsmap[x][y]})
                    end
                end
            end
        end
        --if highpointsmap then self.ConvertXYTableToYXCommaDelim(highpointsmap); return end

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
                                    --_ALERT(includefunc, pos, includefunc[1](pos, includefunc[2]) )
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
                    local visarea = GetAreaInLoS(passmap, PoIpos[1], PoIpos[2], voronoiCheckDistance)
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
                    for j, GridPos in GetAreaInLoS(passmap, highpoint[1], highpoint[2], voronoiCheckDistance) do
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
                --"Good" marker areas have voronoiCheckDistance added to their distance to unpassable in highpointsmap. Flat areas plateau at voronoiCheckDistance
                --So this will output the plateaus and the good marker areas
                local visarea = GetAreaInLoS(passmap, PoIpos[1], PoIpos[2], voronoiCheckDistance, {checkpos, {highpointsmap, voronoiCheckDistance}}, true, false)
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

                visarea = GetAreaInLoS(passmap, markerlist[markername].position[1], markerlist[markername].position[3], voronoiCheckDistance, nil, true, true)
                -- Sort by highpointmap value. Highest first.
                table.sort(visarea, function(a,b) return highpointsmap[a[1] ][a[2] ] > highpointsmap[b[1] ][b[2] ] end)
                do
                    -- Loop through
                    local cuttoff
                    for i = 1, table.getn(visarea) do
                        -- If it's not a marker or impassible
                        if type(markermap[visarea[i][1] ][visarea[i][2] ]) == 'number' then
                            -- Mark it with maxdist-dist, as a system of prioritising areas. Lower numbers are better for placing a marker there.
                            markermap[visarea[i][1] ][visarea[i][2] ] = math.max(markermap[visarea[i][1] ][visarea[i][2] ], voronoiCheckDistance - visarea[i][4])
                            --If this area has previously been marked as not good enough for a merker
                            if not cuttoff and highpointsmap[visarea[i][1] ][visarea[i][2] ] < voronoiCheckDistance then
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


        --self.ConvertXYTableToYXCommaDelim(markermap)
        --return markermap
    end,

    ----------------------------------------------------------------------------
    -- Function I used once for that 40k setons that was the 20k with more stuff around it
    --[[TranslateAllMarkers = function(self, xtran, ytran)
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
        self.PrintMarkerListFormatting(newmarkers)
    end,]]

    ----------------------------------------------------------------------------
    -- Format basic table data of markers as a string just the way maps like it
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

    DrawMarkerPaths = function(self, markers)
        self:ForkThread(function(self, markers)
            while self and not self.Dead do
                for name, marker in markers do
                    DrawCircle(marker.position, 5, marker.color)
                    for i, n2 in marker.adjacentList do
                        DrawLinePop(marker.position, markers[n2].position, marker.color)
                    end
                end
                coroutine.yield(2)
            end
        end, markers)
        --LOG("End")
        --LOG(GetSystemTimeSecondsOnlyForProfileUse())
    end,

    DrawGridData = function(self, grid)
        self:ForkThread(function(self, grid)
            local rh = function()
                local hex = {0,1,2,3,4,5,6,7,8,9,'a','b','c','d','e','f'}
                return hex[math.random(1,16)]
            end
            --local profile = GetSystemTimeSecondsOnlyForProfileUse()
            --local profile2
            local colours = {}
            local GTH = GetTerrainHeight
            while self and not self.Dead do
                for x, xdata in grid do
                    for y, data in xdata do
                        local key = tostring(data)
                        if not colours[key] then colours[key] = 'ff' .. rh() .. rh() .. rh() .. rh() .. rh() .. rh() LOG(key .. " : " .. colours[key]) end
                        if grid[x-1][y] ~= grid[x+1][y] or grid[x][y-1] ~= grid[x][y+1] then
                            DrawCircle({x,GTH(x,y),y}, 0.7071/2, colours[key])
                        end
                    end
                end
                --if not profile2 then
                --    profile2 = GetSystemTimeSecondsOnlyForProfileUse()
                --    LOG(profile2-profile)
                --end
                coroutine.yield(2)
            end
        end, grid)
    end,

    ----------------------------------------------------------------------------
    -- Logging one of the data tables as CSV data
    ConvertXYTableToYXCommaDelim = function(map)
        --Transpose the table so it's the correct way round for a spreadsheet view
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
