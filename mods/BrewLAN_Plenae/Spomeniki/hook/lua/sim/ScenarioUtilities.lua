--------------------------------------------------------------------------------
-- For inserting spom's into cities
if rawget(_G, 'CityData') then
    for i, citybp in CityData do
        if citybp.BlueprintId == 'UEF_SquareBlockCity' then
            for j, s7data in citybp.Structures7x7 do
                if s7data[1] == 'xec1501' then
                    local spom = '/mods/brewlan_plenae/spomeniki/env/spomeniki/props/spomenik_'
                    local monu = '/mods/brewlan_plenae/spomeniki/env/spomeniki/props/monument_'
                    CityData[i].Structures7x7[j][i] = {
                        {'xec1501', Weight = 1},
                        {spom..'naroda_prop.bp', Weight = 1 },
                        {spom..'mramor_prop.bp', Weight = 1 },
                        {spom..'rojah_prop.bp', Weight = 1 },
                        { {
                            {spom..'fist_a_prop.bp', Weight = 1 },
                            {spom..'fist_b_prop.bp', Weight = 1 },
                            {spom..'fist_c_prop.bp', Weight = 1 },
                        }, Weight = 1 },
                        {monu..'torii_001_prop.bp', Weight = 1},
                    }
                    break
                end
            end
            break
        end
    end
end


--Vanilla spom code.
do
    local OldCreateProps = CreateProps
    function CreateProps()
        local path = '/mods/brewlan_plenae/spomeniki/env/spomeniki/props/'
        local spath = path..'spomenik_'
        local mpath = path..'monument_'

        local monuments = {
            {
                spath..'fist_a_prop.bp',
                spath..'fist_b_prop.bp',
                spath..'fist_c_prop.bp',
            },
            {
                spath..'naroda_prop.bp',
            },
            {
                spath..'mramor_prop.bp',
            },
            {
                spath..'rojah_prop.bp',
            },
            {
                mpath..'mer1_prop.bp',
                mpath..'mer2_prop.bp',
            },
            {
                mpath..'torii_001_prop.bp',
            },
        }
        local mapsize = ScenarioInfo.size
        local usedpositions = {}
        local groupcount = math.max(mapsize[1], mapsize[2]) / 128
        for i = 1, groupcount do
            local group = monuments[math.random(1, table.getn(monuments))]
            local grouppos = FilteredRandWithinBounds(15, usedpositions)
            local groupangle = math.random(0,360)
            local start = math.random()
            for i = 1, 10 do -- Try to not be in the water, but not very hard
                if GetTerrainHeight(unpack(grouppos)) < GetSurfaceHeight(unpack(grouppos)) then
                    grouppos = FilteredRandWithinBounds(15, usedpositions)
                end
            end
            for i = 1, 10 do -- Try to be on higher ground, but not very hard
                local newpos = FilteredRandWithinBounds(15, usedpositions)
                if GetTerrainHeight(unpack(newpos)) > GetTerrainHeight(unpack(grouppos)) then
                    grouppos = newpos
                end
            end

            table.insert(usedpositions, grouppos)
            for i, prop in group do
                local groupsize = table.getn(group)
                local itempos = {unpack(grouppos)}
                if groupsize > 1 then
                    local radius = (math.max(__blueprints[prop].SizeX, __blueprints[prop].SizeY, __blueprints[prop].SizeZ) * groupsize) / math.pi
                    local pi2 = math.pi * 2
                    itempos = {
                        grouppos[1] + (radius * ( math.sin((pi2 / groupsize) * start + (pi2 / groupsize) * i))),
                        grouppos[2] + (radius * ( math.cos((pi2 / groupsize) * start + (pi2 / groupsize) * i))),
                    }
                end
                local itempos3 = {itempos[1], GetTerrainHeight(itempos[1],itempos[2]), itempos[2]}
                local itemangle = groupangle + math.random(-20,20)
                CreatePropHPR(
                    prop,
                    itempos3[1], itempos3[2], itempos3[3],
                    itemangle, 0, 0
                )
                local tarmac = __blueprints[prop].Display.Tarmacs[1]
                if tarmac then
                    CreateDecal(itempos3, itemangle, tarmac.Albedo, '', 'Albedo', tarmac.Width, tarmac.Length, tarmac.FadeOut, 0, 1, 0)
                    if tarmac.Normal then
                        CreateDecal(itempos3, itemangle, tarmac.Normal, '', 'Alpha Normals', tarmac.Width, tarmac.Length, tarmac.FadeOut, 0, 1, 0)
                    end
                end
            end
        end
        OldCreateProps()
    end

    function RandWithinBounds(bounds)
        return math.random((bounds or 15), ScenarioInfo.size[1] -(bounds or 15)), math.random((bounds or 15), ScenarioInfo.size[2] -(bounds or 15))
    end

    function FilteredRandWithinBounds(bounds, usedpositions)
        local minDistanceSq = 400
        local posX, posY = RandWithinBounds(bounds)

        local distanceCheck = function(posX, posY, usedpositions, minDistanceSq)
            for i, pos in usedpositions do
                if VDist2Sq(pos[1], pos[2], posX, posY) < minDistanceSq then
                    return false
                end
            end
            return true
        end

        while not distanceCheck(posX, posY, usedpositions, minDistanceSq) do
            posX, posY = RandWithinBounds(bounds)
        end

        return {posX, posY}
    end
end
