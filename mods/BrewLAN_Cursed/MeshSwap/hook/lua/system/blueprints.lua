do
    --abs * uniformscale = size
    --abs = size / uniformscale
    local OldModBlueprints = ModBlueprints
    function ModBlueprints(all_blueprints)
        local meshes = {}
        for id, bp in pairs(all_blueprints.Unit) do
            if bp.Display and bp.Display.Mesh and bp.Display.Mesh.LODs then
                local lods = table.deepcopy(bp.Display.Mesh.LODs)
                local path = string.gsub(bp.Source, '(%/.*%/).*', '%1')
                for i, lod in ipairs(lods) do
                    local ii = math.floor(i-0.5)
                    lod.MeshName = (string.sub(lod.MeshName or 'o',1,1)=='/') and lod.MeshName or path..(lod.MeshName or (id..'_lod'..ii..'.scm'))
                    lod.AlbedoName = (string.sub(lod.AlbedoName or 'o',1,1)=='/') and lod.AlbedoName or path..(lod.AlbedoName or (id..(i==1 and '' or '_lod'..ii)..'_albedo.dds'))
                    lod.NormalsName = (string.sub(lod.NormalsName or 'o',1,1)=='/') and lod.NormalsName or path..(lod.NormalsName or (id..(i==1 and '' or '_lod'..ii)..'_normalsts.dds'))
                    lod.SpecularName = (string.sub(lod.SpecularName or 'o',1,1)=='/') and lod.SpecularName or path..(lod.SpecularName or (id..(i==1 and '' or '_lod'..ii)..'_specteam.dds'))
                end
                table.insert(meshes, {
                    math.max(bp.SizeX or 1, bp.SizeZ or 1) / (bp.Display and bp.Display.UniformScale or 1),
                    lods
                })
            end
        end
        table.sort(meshes, function(a,b) return a[1]<b[1] end)
        for id, bp in pairs(all_blueprints.Unit) do
            if bp.Display and bp.Display.Mesh and bp.Display.Mesh.LODs then
                local absoluteSize = math.max(bp.SizeX or 1, bp.SizeZ or 1) / (bp.Display and bp.Display.UniformScale or 1)
                local min, max, own
                for i, data in ipairs(meshes) do
                    if not min and data[1] > (absoluteSize * 0.909) then min = i end
                    if not max and data[1] > (absoluteSize * 1.1) then max = i end
                    if not own and data[1] == absoluteSize then own = i end
                    if min and max then
                        break
                    end
                end
                local newstuff = meshes[math.random(min or own or 1, max or own or 1)][2]
                local newLODS = {{}}
                for k, v in pairs(bp.Display.Mesh.LODs[1]) do
                    newLODS[1][k] = v
                end
                newLODS[1].LODCutoff = 1
                for i, lod in ipairs(newstuff) do
                    table.insert(newLODS, lod)
                end
                bp.Display.Mesh.LODs = newLODS
                ExtractWreckageBlueprint(bp)
                ExtractBuildMeshBlueprint(bp)
            end
        end
        OldModBlueprints(all_blueprints)
    end
end
