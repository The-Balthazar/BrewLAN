local Unit = import('/lua/sim/unit.lua').Unit

ZZZ0004 = Class(Unit) {
    ----------------------------------------------------------------------------
    -- Implementation specific UI Hacks
    OnCreate = function(self)
        Unit.OnCreate(self)
        self:SetScriptBit('RULEUTC_IntelToggle', true)
        self:SetScriptBit('RULEUTC_ProductionToggle', true)
        self:SetScriptBit('RULEUTC_GenericToggle', true)
    end,

    --Some quick control buttons
    OnScriptBitSet = function(self, bit)
        Unit.OnScriptBitSet(self, bit)
        if bit == 1 then
            local x,y,z = self:GetPositionXYZ()
            local replacement = CreateUnitHPR('zzz0004', self:GetArmy(), x, y, z, 0, 0, 0)
            if not self.Land then replacement:SetScriptBit('RULEUTC_IntelToggle', false) end
            if not self.Amph then replacement:SetScriptBit('RULEUTC_ProductionToggle', false) end
            if not self.Water then replacement:SetScriptBit('RULEUTC_GenericToggle', false) end
            self:Destroy()
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

        local MapSizeX = ScenarioInfo.size[1]
        local MapSizeZ = ScenarioInfo.size[2]
        local PlayRect = ScenarioInfo.MapData.PlayableRect or {0,0,MapSizeX,MapSizeZ}
        local Border = {x1=PlayRect[1],   z1=PlayRect[2],   x2=PlayRect[3]+1, z2=PlayRect[4]+1} -- We care about full grids not verts, and there's 1 more vert pos than grid
            PlayRect = {x1=PlayRect[1]+1, z1=PlayRect[2]+1, x2=PlayRect[3],   z2=PlayRect[4]  }

        ------------------------------------------------------------------------
        -- Marker data
        local markerTypes = {
            { type = 'Land Path Node',       color = 'ff00ff00', graph = 'DefaultLand',       name = 'LandPM',  land = true,                  MaxWaterDepth = 0.05, MaxSlope=0.75},
            { type = 'Amphibious Path Node', color = 'ff00ffff', graph = 'DefaultAmphibious', name = 'AmphPM',  land = true,  seabed = true,  MaxWaterDepth = 25,   MaxSlope=0.75},
            { type = 'Water Path Node',      color = 'ff0000ff', graph = 'DefaultWater',      name = 'WaterPM',               water = true,   MinWaterDepth = 1.5},
        }
        markerType = markerTypes[markerType]

        ------------------------------------------------------------------------
        -- Global functions called potentially over a million times (remove some overhead)
        local GTH, GetSurfaceHeight, VDist2Sq = GetTerrainHeight, GetSurfaceHeight, VDist2Sq
        local max, min, abs, floor = math.max, math.min, math.abs, math.floor
        local insert, remove, getn, copy, find, merged = table.insert, table.remove, table.getn, table.copy, table.find, table.merged

        ------------------------------------------------------------------------
        -- Output settings -----------------------------------------------------
        local exportMarkersToLog = false
        local drawMarkersToMap = true
        local drawVoronoiToMap = false
        local timeProfileOutput = true and GetSystemTimeSecondsOnlyForProfileUse()
        local timeProfileDetailed = true

        ------------------------------------------------------------------------
        -- Unpassable areas map cleanup toggles --------------------------------
        -- - These are functionally obsolete, but are fast and can speed up things
        local doQuickCleanupPasses = 1 -- 0 disables. Despeckle and DeIsland only done on first pass
        local doDespeckle = true -- removes single unconnected grids of unpassable (8 point check) --Obseleted by ignoreMinZones, but more efficient.
        local doDeIsland = true -- removes single unconnected grids of passable (4 point check) --Obselete by voronoi function, but saves a bunch of distance checks.
        local doDeAlcove = false -- removes single grids of passable with 3 unpassable grids cardinally adjacent (4 point check) --Obselete by voronoi function.

        ------------------------------------------------------------------------
        -- Voronoi input options -----------------------------------------------
        local voronoiGridsNumberByMapWidth = {
            [1024] = 16,
            [2048] = 32,
            [4096] = 32,
        }
        local voronoiGridsNumber = voronoiGridsNumberByMapWidth[MapSizeX] or min(32, MapSizeX/32)
        local doContiguousGridCheck = true -- Very slightly slower grid generation that checks grid cells aren't cut up by terrain features, preventing grid-based ghost connections.
        local voronoiCheckDistance = min(16, MapSizeX/(voronoiGridsNumber*2) + 1--[[, 10]]) -- Less than a half a grid-width (a 32nd with 16ths grids) can cause ghost connections without doContiguousGridCheck true, and should come with a warning. Bermuda Locket land nodes look good with 8.
        local voronoiCheckDistanceSq = math.pow(voronoiCheckDistance, 2) --This is just for optimisation

        ------------------------------------------------------------------------
        -- Voronoi cleanup options ---------------------------------------------
        local minContigiousZoneArea = 30 -- size cuttoff for giving a shit about a blocking area
        local ignoreMinZones = true -- treat small zones as though they dont exist.
        local doEdgeCullLargestZones = false -- Mostly obsolete with the improved doEdgeCullAllZones filter: creates a gap between the two largest blocking zones that gets filled with grid. Can fix issues on maps like Bermuda Locket. doContiguousGridCheck might be needed
        local doEdgeCullAllZones = true -- Creates gaps between any touching voronoi zone. Can potentially fix concave areas, narrow paths, and other problem areas. doContiguousGridCheck probably essential.
        local voronoiEdgeCullRadius = 3 -- The distance that the edge cull should affect. Radius, square.
        local EdgeCullAllBorderDistance = max(voronoiEdgeCullRadius*2, voronoiCheckDistance) -- Soft border protection distance for all-zones edge cull
        local EdgeCullAllBorderTaperRate = 0.2 --How fast the radius reduces when the centre is past the border edge

        ------------------------------------------------------------------------
        -- Marker cleanup options ----------------------------------------------
        local MarkerMinDist = math.sqrt(MapSizeX) * 0.5 -- sqrt of map size is usually a good default -- radius, square -- prevents creation of markers with other markers in this radius moves the other marker to halfway between the two. Opperation is very order dpenendant.
        local doRemoveIsolatedMarkers = false -- If a marker has no connections, YEET

        ------------------------------------------------------------------------
        -- Data storage --------------------------------------------------------
        local passMap = {}  --Populate with false for impassible or distance to nearest false
        local voronoiMap = {} --Populate with zones around unpassable areas as a voronoi map
        local markerlist = {} --List of markers

        ------------------------------------------------------------------------
        -- tiny generic helper functions I use, or might use in more than once place
        local function detailedTimeStart() timeProfileDetailed = timeProfileDetailed and GetSystemTimeSecondsOnlyForProfileUse() end
        local function detailedTimeEnd(section) if timeProfileDetailed then _ALERT( markerType.type, '', GetSystemTimeSecondsOnlyForProfileUse() - timeProfileDetailed, section ) end end
        local function round(n) return floor(n + 0.5) end
        local function btb(v) return v and 1 or 0 end --bool to binary
        local function truecount(...) local n=0 for i=1,arg.n do if arg[i] then n=n+1 end end return n end -- count the number of positive args
        local function tcount(t) local c=0; for i, j in t do c=c+1 end return c end --more reliable getn
        local function tintersect(t1,t2) local t3 = {} for i, v in t1 do t3[i] = t1[i] and t2[i] or nil end return t3 end --intersection of tables

        local function CardinalCount(grid,x,z) return btb(grid[x-1] and grid[x-1][z])+btb(grid[x+1] and grid[x+1][z])+btb(grid[x][z-1])+btb(grid[x][z+1]) end
        local function OrdinalCount(grid,x,z) return btb(grid[x-1] and grid[x-1][z-1])+btb(grid[x-1] and grid[x-1][z+1])+btb(grid[x+1] and grid[x+1][z-1])+btb(grid[x+1] and grid[x+1][z+1]) end

        local function outsidePlay(x,z) return PlayRect.x1>x or PlayRect.z1>z or PlayRect.x2<x or PlayRect.z2<z end
        local function outsideCorner(x,z) return 2 == truecount(PlayRect.x1>x, PlayRect.z1>z, PlayRect.x2<x, PlayRect.z2<z) end

        local function canPathSlope(x,z) local a,b,c,d = GTH(x-1,z-1),GTH(x-1,z),GTH(x,z),GTH(x,z-1) return max(abs(a-b), abs(b-c), abs(c-d), abs(d-a)) <= markerType.MaxSlope end
        local function canPathTerrain(x,z) local t = GetTerrainType(x,z) return t ~= 'Dirt09' and t ~= 'Lava01' end
        local function canAmphPathWater(surface,terrain) return terrain + (markerType.MaxWaterDepth or 0) > surface end
        local function canNavalPathWater(surface,terrain) return surface - (markerType.MinWaterDepth or 0) > terrain end

        local function canPath(x,z)
            local s,t = GetSurfaceHeight(x,z), GTH(x,z)

            if canPathTerrain(x,z) then
                if markerType.land and s==t then
                    return canPathSlope(x,z)
                elseif markerType.seabed then
                    return canAmphPathWater(s,t) and canPathSlope(x,z)
                elseif markerType.water then
                    return canNavalPathWater(s,t)
                end
            end
        end

        ------------------------------------------------------------------------
        -- DO IT ---------------------------------------------------------------
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- Evaluate and store map data. ----------------------------------------
        detailedTimeStart()
        for x = Border.x1, Border.x2 do
            passMap[x] = {}
            voronoiMap[x] = {}
            for z = Border.z1, Border.z2 do
                --Create a ring of unpassable around the outside
                if outsidePlay(x,z) then
                    passMap[x][z] = false
                    voronoiMap[x][z] = not outsideCorner(x,z) and "border" or nil
                else
                    if canPath(x,z) then
                        passMap[x][z] = voronoiCheckDistanceSq --Set up for the vector check for min dist from false
                        voronoiMap[x][z] = ''
                    else
                        passMap[x][z] = false
                        voronoiMap[x][z] = false
                    end
                end
            end
        end
        detailedTimeEnd("Get map data time")

        ------------------------------------------------------------------------
        -- Heightmap data cleanup. Mostly obselete, mostly harmless. -----------
        detailedTimeStart()
        if doQuickCleanupPasses ~= 0 then
            for i = 1, doQuickCleanupPasses do
                for x = PlayRect.x1, PlayRect.x2 do
                    for z = PlayRect.z1, PlayRect.z2 do
                        -- Despeckle; remove isolated single grid impassible areas with no orthoganally adjacent other impassible areas
                        if i==1 and doDespeckle then
                            if not passMap[x][z] and CardinalCount(passMap,x,z) + OrdinalCount(passMap,x,z) == 8 then
                                --remove isolated false sections unless they are hefty
                                passMap[x][z] = voronoiCheckDistanceSq
                                voronoiMap[x][z] = ''
                            end
                        end
                        -- Like despeckle but the other way round, and we don't need to care about intercardinals
                        if i==1 and doDeIsland then
                            if passMap[x][z] and CardinalCount(passMap,x,z) == 0 then
                                passMap[x][z] = false
                                voronoiMap[x][z] = false
                            end
                        end
                        -- remove alcoves
                        if doDeAlcove then
                            if passMap[x][z] and CardinalCount(passMap,x,z) == 1 then
                                passMap[x][z] = false
                                voronoiMap[x][z] = false
                            end
                        end
                    end
                end
            end
        end
        detailedTimeEnd("Quick cleanup time")
        ------------------------------------------------------------------------
        -- Calculates content for passMap and voronoiMap
        -- Passmap is distance to the nearest unpathable
        -- Voronoimap is which block of unpathable it's from
            -- Sweeps through all unpassable areas, walking through all contiguous areas and marking them as so,
            -- then mark off distances to high points, and which high point is closer
        do -- do block to limit locals

            local CrawlerPath = {}
            local pathLength = 0
            local MaxPathLength = 0

            local ZoneSizes = {}


            local function QueueGrid(path, length, x, z)
                insert(path, {x,z})
                length = length + 1
                MaxPathLength = max(length, MaxPathLength)
                return length
            end

            -- done from the perspective of the impassible area grid, and checking outwards for pathable areas to mark
            local function MapDistanceVoronoi (xtarget, ztarget, maxdist, blockid)
                --Limit area to loop over to square around the circle that's going to change
                --Could limit more with sin/cos? Would that be more compute than the vdist?
                local xstart = max(xtarget-maxdist, PlayRect.x1)
                local zstart = max(ztarget-maxdist, PlayRect.z1)
                local xend = min(xtarget+maxdist, PlayRect.x2)
                local zend = min(ztarget+maxdist, PlayRect.z2)
                --Within the caclulated bounds
                for x = xstart, xend do
                    for z = zstart, zend do
                        if passMap[x][z] then
                            --Calculate the distance to origin
                            --maxdist is pre-polulated already, so no need to reference here
                            local dist = VDist2Sq(x,z,xtarget,ztarget)
                            if dist < passMap[x][z] then
                                passMap[x][z] = dist
                                voronoiMap[x][z] = blockid
                            end
                        end
                    end
                end
            end

            --Crawler function for gathering contiguous areas.
            local function MapCrawler (data)
                local blockid = data.blockid

                if data.pathindex then
                    remove(CrawlerPath, data.pathindex)
                    pathLength = pathLength-1
                end

                for i, adj in {{0,-1},{-1,0},{0,1},{1,0},{-1,1},{1,-1},{-1,-1},{1,1}} do
                    local x = data.x+adj[1]
                    local z = data.z+adj[2]

                    --Separate the border where it touches a zone, but dont crawl along it. 5 and greater are intercardinals.
                    if (not data.borderMode and voronoiMap[x][z] == 'border' and i < 5) then

                        voronoiMap[x][z] = blockid
                        ZoneSizes[blockid] = minContigiousZoneArea+1 --Add this so we never ignore border zones, since that would be bad.

                    end
                    if (voronoiMap[x][z] == false or data.borderMode and voronoiMap[x][z] == 'border' and i < 5) then

                        voronoiMap[x][z] = blockid
                        if not data.borderMode then
                            ZoneSizes[blockid] = ZoneSizes[blockid] + 1
                        end

                        pathLength = QueueGrid(CrawlerPath, pathLength, x, z)

                    end
                end
            end

            --Input data looks like:
--[[ voronoiMap = (abridged) b = "border" f = false
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
 ,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b, ,
]]
            --if true then self.ConvertXYTableToYXCommaDelim(voronoiMap); return end
            --------------------------------------------------------------------
            -- Map out contigious areas of unpathable areas, splitting border as we go
            detailedTimeStart()
            local blockid = 0
            for x, zdata in passMap do
                for z, pass in zdata do
                    if not outsideCorner(x,z) and not pass and not voronoiMap[x][z] then
                        blockid = blockid + 1
                        if not ZoneSizes[blockid] then ZoneSizes[blockid] = 0 end
                        MapCrawler{
                            x = x,
                            z = z,
                            blockid = blockid
                        }
                        while CrawlerPath[1] do
                            MapCrawler{
                                x = CrawlerPath[pathLength][1],
                                z = CrawlerPath[pathLength][2],
                                blockid = blockid,
                                pathindex = pathLength
                            }
                        end
                    end
                end
            end
            detailedTimeEnd("Crawl blocking zones time. Max grid queue length : "..MaxPathLength )

--[[ voronoiMap = (abridged) b = "border" (leading 1's removed for visibility)
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
 ,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,5,5,b,b,b,b,b,b,b,b,b,b,b,7,7,7,7,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,0,0,0,0,b,b,b,b,b,b,b,b,b,b,b, ,
]]
            --if true then self.ConvertXYTableToYXCommaDelim(voronoiMap); return end
            --------------------------------------------------------------------
            -- Do the same for the border segments
            detailedTimeStart()
            for x = Border.x1, Border.x2 do
                for _, z in {Border.z1, Border.z2} do
                    if voronoiMap[x][z] == 'border' then
                        blockid = blockid + 1
                        MapCrawler{
                            x = x,
                            z = z,
                            blockid = blockid,
                            borderMode = true
                        }
                        while CrawlerPath[1] do
                            MapCrawler{
                                x = CrawlerPath[pathLength][1],
                                z = CrawlerPath[pathLength][2],
                                blockid = blockid,
                                borderMode = true,
                                pathindex = pathLength
                            }
                        end
                    end
                end
            end
            for z = Border.z1, Border.z2 do
                for _, x in {Border.x1, Border.x2} do
                    if voronoiMap[x][z] == 'border' then
                        blockid = blockid + 1
                        MapCrawler{
                            x = x,
                            z = z,
                            blockid = blockid,
                            borderMode = true
                        }
                        while CrawlerPath[1] do
                            MapCrawler{
                                x = CrawlerPath[pathLength][1],
                                z = CrawlerPath[pathLength][2],
                                blockid = blockid,
                                borderMode = true,
                                pathindex = pathLength
                            }
                        end
                    end
                end
            end
            detailedTimeEnd("Crawl borders time")

--[[ voronoiMap = (abridged) (1's removed for visibility)
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
 ,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,5,5,4,4,4,4,4,4,4,4,4,4,4,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,0,0,0,0,9,9,9,9,9,9,9,9,9,9,9, ,
]]  --if true then self.ConvertXYTableToYXCommaDelim(voronoiMap); return end
            --------------------------------------------------------------------

            --Check actions are required with the ignoreMinZones actions
            local smallZonesNum = 0
            detailedTimeStart()
            if ignoreMinZones then
                for zone, no in ZoneSizes do
                    if no <= minContigiousZoneArea then
                        smallZonesNum = smallZonesNum + 1
                        break
                    end
                end
            end

            --Just remove the zones rather than specifically ignoring them, simplify future actions
            if ignoreMinZones and smallZonesNum > 0 then
                for x, ydata in passMap do
                    for y, pass in ydata do
                        if not pass and voronoiMap[x][y] and ZoneSizes[voronoiMap[x][y] ] and ZoneSizes[voronoiMap[x][y] ] <= minContigiousZoneArea then
                            passMap[x][y] = voronoiCheckDistanceSq
                            voronoiMap[x][y] = ''
                        end
                    end
                end
            end
            detailedTimeEnd("Cull small zones time")

            -- Generate the voronoi areas
            detailedTimeStart()
            for x, ydata in passMap do
                for y, pass in ydata do
                    if not pass and (passMap[x-1][y] or passMap[x][y-1] or passMap[x+1][y] or passMap[x][y+1]) then
                        MapDistanceVoronoi(x, y, voronoiCheckDistance, voronoiMap[x][y])
                    end
                end
            end
            detailedTimeEnd("Generate voronoi map time")
--[[  voronoiMap =
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
]]          --if true then self.ConvertXYTableToYXCommaDelim(voronoiMap); return end
            --------------------------------------------------------------------
            --

            --This produces a gap between the two largest zones to be filled in with grid, so that maps with two large zones that touch at multiple places don't cause issues.
            --If this was done to the connections on every pair of zones that connect at more than one place, and every long winding connection, this would probably fix most of the concentric/concave path issues.
            if doEdgeCullLargestZones then
                detailedTimeStart()
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
                    local voronoiMapCopy = table.deepcopy(voronoiMap)
                    --LOG(largest..": "..ZoneSizes[largest].."; "..secondl..": "..ZoneSizes[secondl])
                    for x, ydata in voronoiMap do
                        for y, data in ydata do
                            local offset = voronoiEdgeCullRadius
                            if passMap[x][z] and
                            (voronoiMap[x-offset][y] == largest and voronoiMap[x+offset][y] == secondl
                            or voronoiMap[x][y-offset] == largest and voronoiMap[x][y+offset] == secondl
                            or voronoiMap[x-offset][y] == secondl and voronoiMap[x+offset][y] == largest
                            or voronoiMap[x][y-offset] == secondl and voronoiMap[x][y+offset] == largest

                            or voronoiMap[x-offset][y-offset] == largest and voronoiMap[x+offset][y+offset] == secondl
                            or voronoiMap[x+offset][y+offset] == largest and voronoiMap[x-offset][y-offset] == secondl
                            or voronoiMap[x-offset][y+offset] == secondl and voronoiMap[x+offset][y-offset] == largest
                            or voronoiMap[x+offset][y-offset] == secondl and voronoiMap[x-offset][y+offset] == largest) then
                                voronoiMapCopy[x][y] = ''
                            end
                        end
                    end
                    voronoiMap = voronoiMapCopy
                end
                detailedTimeEnd("Separate largest voronoi zones time")
            end

            --Culls the area between touching zones, tapers towards map edges, to allow grid in the middle
            if doEdgeCullAllZones then
                detailedTimeStart()

                local edgemax = EdgeCullAllBorderDistance or 0

                local function DistFromEdge(v, mapsize) return min(v, mapsize-v) end
                local function DistFromEdgeX(v) return DistFromEdge(v, MapSizeX) end
                local function DistFromEdgeZ(v) return DistFromEdge(v, MapSizeZ) end
                local function NearEdge(v, mapsize) return (v < edgemax or v > mapsize - edgemax) end
                local function NearEdgeX(v) return NearEdge(v, MapSizeX) end
                local function NearEdgeZ(v) return NearEdge(v, MapSizeZ) end
                local function Diag(v) return v * 0.765 end

                local function compare(x,z,x2,z2)
                    local g1, g2 = voronoiMap[x][z], voronoiMap[x2][z2]
                    return g1 and g2 and g1 ~= g2 and g1 ~= '' and g2 ~= ''
                end

                local voronoiMapCopy = table.deepcopy(voronoiMap)

                for x, zdata in voronoiMap do
                    for z, data in zdata do
                        local offset = voronoiEdgeCullRadius
                        local offsetDiag
                        if NearEdgeX(x) or NearEdgeZ(z) then
                            local rawOffset = offset - (( max(0, edgemax - DistFromEdgeX(x)) + max(0, edgemax - DistFromEdgeZ(z))) * EdgeCullAllBorderTaperRate)
                            offsetDiag = round(Diag(rawOffset))
                            offset = round(rawOffset)
                        else
                            offsetDiag = round(Diag(offset))
                        end

                        if offset > 0 and (
                            compare(x-offset,z, x+offset,z) or
                            compare(x,z-offset, x,z+offset) or
                            compare(x-offsetDiag,z-offsetDiag, x+offsetDiag,z+offsetDiag) or
                            compare(x+offsetDiag,z-offsetDiag, x-offsetDiag,z+offsetDiag)
                        ) and passMap[x][z] then
                            voronoiMapCopy[x][z] = ''
                        end
                    end
                end
                voronoiMap = voronoiMapCopy
                detailedTimeEnd("Separate touching voronoi zones time")
            end

            --After this point the voronoi map can have gaps in large flat areas voronoiCheckDistance away from blocking areas.
            --This fills those gaps with an offset 16x16 grid, technically 17x17 with smaller outsides, but 16x16 sized.
            --This can cause issues if voronoiCheckDistance is less than a 16th of the map.
            do
                detailedTimeStart()
                local GridContig, GridZoneI
                local GridCPath = {}

                local gs = MapSizeX / voronoiGridsNumber
                local ceil = math.ceil
                local char = string.char
                local function charCycle(n) return char(64+ceil((n + (gs/2))/gs)) end
                local function GetGridName(x,z) return charCycle(x)..charCycle(z) end

                if doContiguousGridCheck then
                    GridZoneI = 0
                    GridContig = function(map, x, z, blocki)
                        for _, v in {{0,1}, {1,0}, {0,-1}, {-1,0}} do

                            local x2, z2 = x+v[1], z+v[2]
                            local gridName = GetGridName(x2, z2)..blocki

                            if voronoiMap[x2][z2] == '' and voronoiMap[x][z] == gridName then
                                insert(GridCPath,{x2, z2})
                                voronoiMap[x2][z2] = gridName
                            end
                        end
                    end
                end
                for x, zdata in voronoiMap do
                    for z, data in zdata do
                        if data == '' then
                            if doContiguousGridCheck then
                                GridZoneI = GridZoneI +1
                                voronoiMap[x][z] = GetGridName(x,z)..GridZoneI
                                insert(GridCPath, {x,z})
                                while GridCPath[1] do
                                    GridContig(voronoiMap, GridCPath[1][1], GridCPath[1][2], GridZoneI)
                                    remove(GridCPath, 1)
                                end
                            else
                                voronoiMap[x][z] = GetGridName(x,z)
                            end
                        end
                    end
                end
                detailedTimeEnd("Grid infill time")
            end
        end

        if drawVoronoiToMap then self:DrawGridData(voronoiMap) end


        ------------------------------------------------------------------------
        -- Find all 2x2 areas containing 3 zones, and try to put a merker there
        do
            detailedTimeStart()
            for x = PlayRect.x1+1, PlayRect.x2 do
                for y = PlayRect.z1+1, PlayRect.z2 do
                    local zones = {
                        [voronoiMap[x][y] ] = true,
                        [voronoiMap[x][y-1] ] = true,
                        [voronoiMap[x-1][y-1] ] = true,
                        [voronoiMap[x-1][y] ] = true,
                    }
                    if tcount(zones) >= 3 then
                        local CreateMarker = function(x, y)

                            local mnum = tcount(markerlist)
                            local markername = markerType.name..mnum
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
                                    and tcount(tintersect(zones, m2data.zones)) > 1
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
                                    end
                                end
                            end
                            if test then
                                m1name, m1data = CreateMarker(x,y)

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

                                        markAdjacent(m2data, m1name)
                                        markAdjacent(m1data, m2name)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            detailedTimeEnd("Pick marker locations time")
        end

        detailedTimeStart()
        for name, marker in markerlist do
            for i, adjname in marker.adjacentList do
                if marker.adjacentTo == '' then
                    marker.adjacentTo = adjname
                else
                    marker.adjacentTo = marker.adjacentTo .. ' ' .. adjname
                end
            end
        end

        if MarkerMinDist or doRemoveIsolatedMarkers then
            for m1name, m1data in markerlist do
                if doRemoveIsolatedMarkers and m1data.adjacentTo == '' then
                    markerlist[m1name] = nil
                end
            end
        end
        detailedTimeEnd("Marker cleanup time")

        --if true then self.ConvertXYTableToYXCommaDelim(markerlist) ; return end
        if timeProfileOutput then
            LOG(markerType.type .. " generation time: " ..  GetSystemTimeSecondsOnlyForProfileUse() - timeProfileOutput .. " seconds with " .. tcount(markerlist) .. " markers")
        end
        if drawMarkersToMap then self:DrawMarkerPaths(markerlist) end
        if exportMarkersToLog then self.PrintMarkerListFormatting(markerlist); return end

        --return markerlist
    end,

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
        local logVoronoiColourKey = false
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
                        if not colours[key] then colours[key] = 'ff' .. rh() .. rh() .. rh() .. rh() .. rh() .. rh() if logVoronoiColourKey then LOG(key .. " : " .. colours[key]) end end
                        if grid[x-1][y] ~= grid[x+1][y] or grid[x][y-1] ~= grid[x][y+1] then
                            DrawCircle({x-.5,GTH(x-.5,y-.5),y-.5}, 0.35355, colours[key])
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
