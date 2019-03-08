--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    function CreateProps()
        for i, tblData in pairs(ScenarioInfo.Env.Scenario['Props']) do
            if tblData.type ~= "Mass" then
                CreatePropHPR(
                    tblData.prop,
                    tblData.Position[1], tblData.Position[2], tblData.Position[3],
                    tblData.Orientation[1], tblData.Orientation[2], tblData.Orientation[3]
                )
            end
        end
    end

    function CreateResources()
        local markers = GetMarkers()
        for i, tblData in pairs(markers) do
            if tblData.resource then
                if tblData.type ~= "Mass" then
                    CreateSingleResource(tblData)
                else
                    local coordsTbl = {
                        {
                            {-2,-2},
                            {-2,2},
                            {2,-2},
                            {2,2}
                        },
                        {
                            {-2,0},
                            {0,-2},
                            {2,0},
                            {0,2}
                        },
                        {
                            {0,-2},
                            {-2,2},
                            {2,2}
                        },
                        {
                            {0,-2},
                            {0,2}
                        },
                        {
                            {-2,0},
                            {2,0}
                        },
                        {
                            {1,1},
                            {-1,-1}
                        },
                        {
                            {-1,1},
                            {1,-1}
                        },
                        {
                            {0,0}
                        },
                        {
                            {0,0}
                        },
                        {
                            --nope
                        },
                        {
                            --nope
                        },
                        {
                            --nope
                        },
                    }
                    for arrayi, coord in coordsTbl[math.random(1,table.getn(coordsTbl))] do
                        local newttblsData = table.deepcopy(tblData)
                        newttblsData.position[1] = tblData.position[1] + coord[1]
                        newttblsData.position[3] = tblData.position[3] + coord[2]
                        newttblsData.position[2] = GetTerrainHeight(tblData.position[1],tblData.position[3])
                        CreateSingleResource(newttblsData)
                    end
                end
            end
        end
    end

    function CreateSingleResource(tblData)
        CreateResourceDeposit(
            tblData.type,
            tblData.position[1], tblData.position[2], tblData.position[3],
            tblData.size
        )

        -- fixme: texture names should come from editor
        local albedo, bp, sx, sz, lod
        if tblData.type == "Mass" then
            albedo = "/env/common/splats/mass_marker.dds"
            bp = "/env/common/props/massDeposit01_prop.bp"
            sx = 2
            sz = 2
            lod = 100
        else
            albedo = "/env/common/splats/hydrocarbon_marker.dds"
            bp = "/env/common/props/hydrocarbonDeposit01_prop.bp"
            sx = 6
            sz = 6
            lod = 200
        end
        CreatePropHPR(
            bp,
            tblData.position[1], tblData.position[2], tblData.position[3],
            Random(0,360), 0, 0
        )
        CreateSplat(
            tblData.position,           -- Position
            0,                          -- Heading (rotation)
            albedo,                     -- Texture name for albedo
            sx, sz,                     -- SizeX/Z
            lod,                        -- LOD
            0,                          -- Duration (0 == does not expire)
            -1 ,                        -- army (-1 == not owned by any single army)
            0
        )
    end
end
