local oldAIBrain = AIBrain

AIBrain = Class(oldAIBrain) {
    OnCreateAI = function(self, planName)
        oldAIBrain.OnCreateAI(self, planName)
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
            coroutine.yield(10)


            local AIGetMarkerLocations = import('/lua/ai/aiutilities.lua').AIGetMarkerLocations

            local OpenStartZones = {}

            for i, army in AIGetMarkerLocations(nil, 'Start Location') do
                if not ScenarioInfo.ArmySetup[army.Name] then
                    OpenStartZones[army.Name] = army.Position
                end
            end

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
                        for i, dir in {{-10, 0}, {0, -10}, {10, 0}, {0, 10}} do
                            local postest = self:CreateUnitNearSpot('zzcityblock', refPos[1] + dir[1], refPos[3] + dir[2])
                            if postest and IsUnit(postest) then
                                local pos = postest:GetPosition()

                                if pos[1] == refPos[1] + dir[1] and pos[3] == refPos[3] + dir[2] then
                                    --LOG("SAFE!")
                                    if not cityI[refGrid[1] + dir[1] * 0.1] then
                                        cityI[refGrid[1] + dir[1] * 0.1] = {}
                                    end
                                    cityI[refGrid[1] + dir[1] * 0.1][refGrid[2] + dir[2] * 0.1] = postest
                                    if total < 10 then
                                        CrawlIntersections(pos, {refGrid[1] + dir[1] * 0.1, refGrid[2] + dir[2] * 0.1}, total + 1)
                                    end
                                else
                                    postest:Destroy()
                                end
                            end
                        end
                    end

                    CrawlIntersections(CityCentrePos, {0,0}, 0)

                    for x, xtable in cityI do
                        for y, sectionunit in xtable do
                            local army = self:GetArmyIndex()
                            local pos = sectionunit:GetPosition()
                            local CreateRoad = function(pos, rot, nom, army)
                                local path = '/mods/BrewLAN_Plenae/CityGeneration/env/UEF/Decals/UEF_Road_Black_'
                                local ds, lod = 10.66, 500 --decal size, lod cutoff
                                CreateDecal(pos, rot or 0, path .. nom .. '_Albedo.dds', '', 'Albedo', ds, ds, lod, 0, army, 0)
                                CreateDecal(pos, rot or 0, path .. nom .. '_Normals.dds', '', 'Alpha Normals', ds, ds, lod, 0, army, 0)
                            end

                            if false then
                            elseif not (cityI[x-1] and cityI[x-1][y]) and not (cityI[x+1] and cityI[x+1][y]) and cityI[x][y-1] and cityI[x][y+1] then
                                CreateRoad(pos, 1.57, '2WS_01',  army) --stright |
                            elseif (cityI[x-1] and cityI[x-1][y]) and (cityI[x+1] and cityI[x+1][y]) and not cityI[x][y-1] and not cityI[x][y+1] then
                                CreateRoad(pos, 0, '2WS_01',  army) --stright --

                            elseif not (cityI[x-1] and cityI[x-1][y]) and (cityI[x+1] and cityI[x+1][y]) and not cityI[x][y-1] and cityI[x][y+1] then
                                CreateRoad(pos, 0, '2WC_01',  army) --corner bottom right
                            elseif not (cityI[x-1] and cityI[x-1][y]) and (cityI[x+1] and cityI[x+1][y]) and cityI[x][y-1] and not cityI[x][y+1] then
                                CreateRoad(pos, 1.57, '2WC_01',  army) --corner
                            elseif (cityI[x-1] and cityI[x-1][y]) and not (cityI[x+1] and cityI[x+1][y]) and not cityI[x][y-1] and cityI[x][y+1] then
                                CreateRoad(pos, -1.57, '2WC_01',  army) --corner
                            elseif (cityI[x-1] and cityI[x-1][y]) and not (cityI[x+1] and cityI[x+1][y]) and cityI[x][y-1] and not cityI[x][y+1] then
                                CreateRoad(pos, math.pi, '2WC_01',  army) --corner top left

                            elseif not (cityI[x-1] and cityI[x-1][y]) and (cityI[x+1] and cityI[x+1][y]) and cityI[x][y-1] and cityI[x][y+1] then
                                CreateRoad(pos, 1.57, '3W_01',  army) --3 way right
                            elseif (cityI[x-1] and cityI[x-1][y]) and not (cityI[x+1] and cityI[x+1][y]) and cityI[x][y-1] and cityI[x][y+1] then
                                CreateRoad(pos, -1.57, '3W_01',  army) --3 way left
                            elseif (cityI[x-1] and cityI[x-1][y]) and (cityI[x+1] and cityI[x+1][y]) and not cityI[x][y-1] and cityI[x][y+1] then
                                CreateRoad(pos, 0, '3W_01',  army) --3 way down
                            elseif (cityI[x-1] and cityI[x-1][y]) and (cityI[x+1] and cityI[x+1][y]) and cityI[x][y-1] and not cityI[x][y+1] then
                                CreateRoad(pos, math.pi, '3W_01',  army) --3 way up

                            elseif (cityI[x-1] and cityI[x-1][y]) and not (cityI[x+1] and cityI[x+1][y]) and not cityI[x][y-1] and not cityI[x][y+1] then
                                CreateRoad(pos, -1.57, '1W_01',  army) --1 way left?
                            elseif not (cityI[x-1] and cityI[x-1][y]) and (cityI[x+1] and cityI[x+1][y]) and not cityI[x][y-1] and not cityI[x][y+1] then
                                CreateRoad(pos, 1.57, '1W_01',  army) --1 way right?
                            elseif not (cityI[x-1] and cityI[x-1][y]) and not (cityI[x+1] and cityI[x+1][y]) and cityI[x][y-1] and not cityI[x][y+1] then
                                CreateRoad(pos, math.pi, '1W_01',  army) --1 way up
                            elseif not (cityI[x-1] and cityI[x-1][y]) and not (cityI[x+1] and cityI[x+1][y]) and not cityI[x][y-1] and cityI[x][y+1] then
                                CreateRoad(pos, 0, '1W_01',  army) --1 way down

                            elseif (cityI[x-1] and cityI[x-1][y]) and (cityI[x+1] and cityI[x+1][y]) and cityI[x][y-1] and cityI[x][y+1] then
                                CreateRoad(pos, 0, '4W_01',  army)--4way

                            end
                            local Structures3x3 = {
                                {'uec1101', Weight = 7 },
                                {'uec1201', Weight = 2 },
                                {'uec1301', Weight = 2 },
                                {'uec1501', Weight = 2 },
                                {'xec1401', Weight = 1 },
                                {'xec1501', Weight = 0.25 },
                            }
                            ChooseWeightedBp = function(selection)
                                local totWeight = 0
                                for k, v in selection do if v.Weight then totWeight = totWeight + v.Weight end end
                                local val = 1
                                local num = Random(0, totWeight)
                                for k, v in selection do if v.Weight then val = val + v.Weight end if num < val then return v[1] end end
                            end

                            for i, v in { {-3,-3}, {-3,3}, {3,3}, {3,-3} } do
                                CreateUnitHPR(
                                    ChooseWeightedBp(Structures3x3), army,
                                     pos[1] + v[1], pos[2], pos[3] + v[2],
                                     0, Random(0,3) * 1.5707963267948966192313216916398, 0
                                )
                            end
                                --[[CreatePropHPR(
                                    '/env/UEF/Props/UEF_Bus_prop.bp',
                                    pos[1]+0.4, pos[2], pos[3]+0.4,
                                    Random(0,360), 0, 0
                                )]]
                        end
                    end
                end
            end

            --LOG(repr(OpenStartZones))

--[[
            local CityCentre = {(ScenarioInfo.size[1]/2)+0.5, (ScenarioInfo.size[2]/2)+0.5}--{math.random(1,ScenarioInfo.size[1]), math.random(1,ScenarioInfo.size[2])}

            local tableadd = function(t1, t2) return {t1[1] + t2[1], t1[2] + t2[2]} end
            local PosV2toV3 = function(t1) return {t1[1], GetTerrainHeight(t1[1], t1[2]), t1[2]} end

            for i, v in { {-5,-5}, {-5,5}, {5,5}, {5,-5} } do
            --for i, v in { {-12.8,-12.8}, {-12.8,12.8}, {12.8,12.8}, {12.8,-12.8} } do
                local army = self:GetArmyIndex()
                local pos = PosV2toV3(tableadd(CityCentre, v))
                --WARN(repr(PosV2toV3(tableadd(CityCentre, v))))
                CreateDecal(PosV2toV3(tableadd(CityCentre, v)), 0, '/mods/BrewLAN_Plenae/CityGeneration/env/UEF/Decals/UEF_Road_Black_4W_01_Albedo.dds', '', 'Albedo', 10.1, 10.1, 500, 0, army, 0)
                --local tarmacHndl = CreateDecal(self:GetPosition(), orient, tarmac.Glow .. GetTarmac(faction, terrainName), '', 'Glow', w, l, fadeout, lifeTime or 0, army, 0)

                CreatePropHPR(
                    '/env/UEF/Props/UEF_Bus_prop.bp',
                    pos[1]+0.4, pos[2], pos[3]+0.4,
                    Random(0,360), 0, 0
                )
                CreateUnitHPR(
                    'uec1101', army,
                     CityCentre[1] + v[1] * 0.4, 0, CityCentre[2] + v[2] * 0.4,
                     0, Random(0,3) * 1.5707963267948966192313216916398, 0
                )
            end]]
        end)
    end,

}
