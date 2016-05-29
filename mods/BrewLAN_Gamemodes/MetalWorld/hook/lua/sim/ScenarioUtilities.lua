--------------------------------------------------------------------------------
--  Summary:  Overwrites the innitial prop spawning; removing mass points
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
function CreateProps()
    for i, tblData in pairs(Scenario['Props']) do   
        if tblData.type != "Mass" then
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
            if tblData.type != "Mass" then
                CreateResourceDeposit(
                    tblData.type,
                    tblData.position[1], tblData.position[2], tblData.position[3],
                    tblData.size
                )
    
                # fixme: texture names should come from editor
                local albedo, sx, sz, lod
                albedo = "/env/common/splats/hydrocarbon_marker.dds"
                sx = 6
                sz = 6
                lod = 200
                CreatePropHPR(
                    '/env/common/props/hydrocarbonDeposit01_prop.bp',
                    tblData.position[1], tblData.position[2], tblData.position[3],
                    Random(0,360), 0, 0
                )
                CreateSplat(
                    tblData.position,           # Position
                    0,                          # Heading (rotation)
                    albedo,                     # Texture name for albedo
                    sx, sz,                     # SizeX/Z
                    lod,                        # LOD
                    0,                          # Duration (0 == does not expire)
                    -1 ,                         # army (-1 == not owned by any single army)
                    0
                )
            end
        end
    end
end
