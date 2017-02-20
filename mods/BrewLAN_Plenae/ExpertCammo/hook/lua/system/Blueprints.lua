--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints
local ModPath = function()
    for i, mod in __active_mods do
        if mod.uid == "2529ea71-93ef-41a6-b552-CAMMO000000001" then
            return mod.location
        end
    end
end


function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    ExtractExpertCammoTerrainMeshes(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Logs
--------------------------------------------------------------------------------

function ExtractExpertCammoTerrainMeshes(all_bps)
    --Get textures list
    local textures = DiskFindFiles(ModPath() .. '/terrainMeshes/', '*.dds')
    --{
    --  "/mods/brewlan_plenae/expertcammo/terrainmeshes/sea0401_redrock_albedo.dds",
    --  "/mods/brewlan_plenae/expertcammo/terrainmeshes/sea0401_redrock_lod1_albedo.dds"
    --}
    local units = {}
    --Known terrain type capitalisations
    local terrainTypes = {
        'Desert',
        'Evergreen',
        'Geothermal',
        'Lava',
        'RedRock',
        'Tropical',
        'Tundra',
    }
    --Asseble a table of unit ids and terrain types from texture list
    if type(textures[1]) == "string" then
        for i, tex in textures do
            --if not string.find(tex, "_lod") or string.find(tex, "_lod0") then
                --Find character indexes of bp and terrain type
                local bpFirstI = string.find(tex, '/terrainmeshes/') + 15
                local bpLastI = bpFirstI + string.find(string.sub(tex, bpFirstI), "_" ) - 2
                local ttLastI = bpLastI + string.find(string.sub(tex, bpLastI + 2), "_")
                --Extract substrings
                local bp = string.sub(tex, bpFirstI, bpLastI)
                local tt = string.sub(tex, bpLastI + 2, ttLastI)
                --Correct capitalisation on terrain type
                local knownCap = false
                for ti, TerrainString in terrainTypes do
                    if tt == string.lower(TerrainString) then
                        tt = TerrainString
                        knownCap = true
                        break
                    end
                end
                --We don't know what it should be, but it probably starts with a capital
                if not knownCap then
                    tt = string.gsub(tt,"^%l", string.upper("^%l"))
                end

                if not units[bp] then
                    units[bp] = {}
                end
                if not table.find(units[bp], tt) then
                    table.insert(units[bp], tt)
                end
            --end
        end
    end
    --Generate a terrain mesh per thing in assembled table
    for id, tts in units do
        local bp = all_bps[id]
        if bp then
            for ti, tt in tts do
                ExtractTerrainMeshBlueprint(bp, tt, textures)
            end
        end
    end
end

function ExtractTerrainMeshBlueprint(bp, tt, textures)
    local meshid = bp.Display.MeshBlueprint
    if not meshid then return end
    local meshbp = original_blueprints.Mesh[meshid]
    if not meshbp then return end

    local buildmeshbp = table.deepcopy(meshbp)

    if buildmeshbp.LODs then
        local tPath = ModPath() .. '/terrainmeshes/' .. bp.BlueprintId .. '_' .. string.lower(tt) .. '_'
        for i, lod in buildmeshbp.LODs do
            --Since we never searched out models, lets check if there is one.
            --Note this also means a model in the file without a corresponding texture won't get used
            local url = tPath .. 'lod' .. i - 1 .. '.scm'
            if DiskGetFileInfo(url) then
                lod.MeshName = url
            end
            local textureTypes = {
                AlbedoName = 'albedo',
                NormalsName = 'normalts',
                SpecularName = 'specteam',
            }
            if i == 1 then
                for texKey, texVal in textureTypes do
                    --Could also check DiskGetFileInfo(URL).SizeBytes to make sure it exists and isn't corrupt
                    url = tPath .. texVal .. '.dds'
                    --LOG(url)
                    if table.find(textures, url) then
                        lod[texKey] = url
                        --LOG("applied")
                    end
                end
            else
                for texKey, texVal in textureTypes do
                    --And then same again for the distance models
                    url = tPath .. 'lod' .. i - 1 .. '_' .. texVal .. '.dds'
                    --LOG(url)
                    if table.find(textures, url) then
                        lod[texKey] = url
                        --LOG("applied")
                    end
                end
            end
        end
    end
    buildmeshbp.BlueprintId = meshid .. '_' .. string.lower(tt)
    if not bp.Display.TerrainMeshes then bp.Display.TerrainMeshes = {} end
    bp.Display.TerrainMeshes[tt] = buildmeshbp.BlueprintId
    MeshBlueprint(buildmeshbp)
    LOG(repr(bp.Display.TerrainMeshes) )
end

end
