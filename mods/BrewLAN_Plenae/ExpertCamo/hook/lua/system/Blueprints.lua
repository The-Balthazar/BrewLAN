--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints
function ModBlueprints(all_blueprints)
    --Do everyone elses thing
    OldModBlueprints(all_blueprints)
    --Do the thing
    ExtractCustomUnitSkinMeshes(all_blueprints.Unit)
end
--------------------------------------------------------------------------------
-- Parent function. Overall generates mesh blueprint files from specific files
-- in mod folders.
--------------------------------------------------------------------------------
-- Usecase example: You have a file called 'UEL0303_Prime_Albedo.dds' in a
--   '/custommeshes' folder. That folder also has a 'ec_indexme.lua' so
--   Expert Camo has confirmation that it should work with the folder.
--   Within the script of uel0303 you could run
--     self:SetMesh(self:GetBlueprint().Display.CustomMeshes.Prime)
--   and it will use that mesh from the time that is called until something else
--   sets it.
--   Meshes generated from '/terrainmeshes' folders are automatically applied
--   when a unit is finished based on the map type. Official maps are either
--   'Desert', 'Evergreen', 'Geothermal', 'Lava', 'RedRock', 'Tropical', or
--   'Tundra'. Most custom maps are undefined and are 'Default'.
--
--   Any skin name that falls outside of name range will be capitalised Likeso
--   inside referential game files. So the only CamelCase name is ReckRock.
--------------------------------------------------------------------------------
function ExtractCustomUnitSkinMeshes(all_bps)
    ----------------------------------------------------------------------------
    -- innitialise texture lists
    ----------------------------------------------------------------------------
    -- Populate texture lists from mod folders
    -- Searches all mod folders for the folders TerrainMeshes or CustomMeshes
    ----------------------------------------------------------------------------
    local TmTextures, STextures = {}, {}
    ----------------------------------------------------------------------------
    for i, mod in __active_mods do
        AddDiskFindToTable(TmTextures, mod.location .. '/TerrainMeshes/', '*.dds')
        AddDiskFindToTable(STextures, mod.location .. '/CustomMeshes/', '*.dds')
        --Dumping models in as well, because the stystem works fine for both.
        AddDiskFindToTable(TmTextures, mod.location .. '/TerrainMeshes/', '*.scm')
        AddDiskFindToTable(STextures, mod.location .. '/CustomMeshes/', '*.scm')
    end
    --LOG(repr(STextures))
    --LOG(repr(TmTextures))
    ----------------------------------------------------------------------------
    -- initialise tables of textures by units
    ----------------------------------------------------------------------------
    -- Populate unit lists from found texture lists
    ----------------------------------------------------------------------------
    local TmUnits, SUnits = {}, {}
    ----------------------------------------------------------------------------
    TerrainAssembleWorkableUnitTable(TmUnits, TmTextures, '/TerrainMeshes/')
    AssembleWorkableUnitTable(SUnits, STextures, '/CustomMeshes/')
    --LOG(repr(TmUnits))
    --LOG(repr(SUnits))
    ----------------------------------------------------------------------------
    -- Run through the tables and generate a mesh bp per thing in them
    ----------------------------------------------------------------------------
    for id, tts in TmUnits do
        local bp = all_bps[id]
        if bp then
            for ti, tt in tts do
                ExtractCustomSkinMeshBlueprint(bp, tt, TmTextures, 'TerrainMeshes')
            end
        end
    end
    --LOG(table.getn(SUnits))
    for id, tts in SUnits do
        local bp = all_bps[id]
        if bp then
            for ti, tt in tts do
                ExtractCustomSkinMeshBlueprint(bp, tt, STextures, 'CustomMeshes')
            end
        end
    end
end
--------------------------------------------------------------------------------
-- AddDiskFindToTable function
--------------------------------------------------------------------------------
-- Inputs: output table, folder to search, optional search parameters
-- Outputs: inserts the found items to output table
-- Example = {
--   "/mods/brewlan_plenae/expertcammo/terrainmeshes/sea0401_redrock_albedo.dds",
--   "/mods/brewlan_plenae/expertcammo/terrainmeshes/sea0401_redrock_lod1_albedo.dds"
-- }
--------------------------------------------------------------------------------
function AddDiskFindToTable(tab, folder, pattern)
    local newTexs
    if DiskGetFileInfo(folder .. 'ec_indexme.lua') then
        if GetVersion() == '1.1.0' then
            --Original SupCom version 1.1.0
            --Other versions of original SupCom not supported because we aren't checking
            newTexs = DiskFindFiles(folder .. pattern)
        else
            --Forged Alliance and beyond
            newTexs = DiskFindFiles(folder, pattern)
        end
        for i, tex in newTexs do
            table.insert(tab, tex)
        end
    end
end
--------------------------------------------------------------------------------
-- AssembleWorkableUnitTable function
--------------------------------------------------------------------------------
-- Inputs: output table, texture list to work from
-- Outputs: populates the table with data from texture file names
-- Example = {
--   sea0401 = {
--     'RedRock',
--     'Desert',
--     'Bleeporwhatever',
--   },
-- }
--------------------------------------------------------------------------------
function AssembleWorkableUnitTable(units, Textures, directory)
    if type(Textures[1]) == "string" then
        --Known Capitalisations from terrain types
        --Unknown capitalisations that pass the bad check will have their first letter capitalised
        local terrainTypes = {
            'Default',
            'Desert',
            'Evergreen',
            'Geothermal',
            'Lava',
            'RedRock',
            'Tropical',
            'Tundra',
        }
        --A file that matches these doesn't have a skin name in the url and will be ignored
        --It wants things like sea0401_redrock_albedo not like sea0401_albedo
        local badTypes = {
             'albedo',
             'normalsts',
             'specteam',
             'secondary',
             'lod%d',
        }
        for i, tex in Textures do
            --Find character indexes of bp and terrain type
            local bpFirstI = string.find(tex, string.lower(directory)) + string.len(directory)
            local bpLastI = bpFirstI + string.find(string.sub(tex, bpFirstI), "_" ) - 2
            local ttLastI = bpLastI + string.find(string.sub(tex, bpLastI + 2), "_")
            --Extract substrings
            local bp = string.sub(tex, bpFirstI, bpLastI)
            local tt = string.sub(tex, bpLastI + 2, ttLastI)
            --local bp, tt = string.match(tex, "/terrainmeshes/([^_]+)_([^_]+)")
              -- Unfortunately for diggles code, match is a 5.1 function, and supcom uses 5.0.1 (SC and FA)
              -- And if it was a real function, it would need updating from /terrainmeshes/ to string.lower(directory)
            --Correct capitalisation on terrain type
            local knownCap = false
            for ti, TerrainString in terrainTypes do
                if tt == string.lower(TerrainString) then
                    tt = TerrainString
                    knownCap = true
                    break
                end
            end
            --We don't really know what it should be, but it probably starts with a capital
            if not knownCap then
                local bad = false
                for badi, badType in badTypes do
                    if string.find(tt, badType) then
                        bad = true
                        break
                    end
                end
                if not bad then
                    tt = string.gsub(tt,"^%l", string.upper)
                    knownCap = true
                end
            end
            --Only do the thing if we think we have a good name
            if knownCap then
                if not units[bp] then
                    units[bp] = {}
                end
                if not table.find(units[bp], tt) then
                    table.insert(units[bp], tt)
                end
            end
        end
    end
end
--------------------------------------------------------------------------------
-- Alternative version of AssembleWorkableUnitTable, with less error checking
-- that assumed everything ending 2 characters before the terrain type is ID.
--------------------------------------------------------------------------------
function TerrainAssembleWorkableUnitTable(units, Textures, directory)
    local terrainTypes = {
        'Default',
        'Desert',
        'Evergreen',
        'Geothermal',
        'Lava',
        'RedRock',
        'Tropical',
        'Tundra',
    }
    for i, tex in Textures do
        for i, ttype in terrainTypes do
            local filename = string.gsub(tex, '.+/', '')
            local tstart = string.find(filename, string.lower(ttype))
            if tstart then
                local uID = string.sub(filename, 1, tstart-2)
                if not units[uID] then units[uID] = {} end
                table.insert(units[uID], ttype)
            end
        end
    end
end
--------------------------------------------------------------------------------
-- ExtractCustomSkinMeshBlueprint function
--------------------------------------------------------------------------------
-- Input: blueprint ID, skin name, texture list, original directory name
-- Output: for the given id and skin name it creates a mesh blueprint from
--         guessing names on the texture list and seeing if they exist.
--         Directory is used both for texture string guess and for the
--         output link on the units blueprint:
--            bp.Display[directory][tt] = link to blueprint
--------------------------------------------------------------------------------
function ExtractCustomSkinMeshBlueprint(bp, tt, textures, directory)
    local meshid = bp.Display.MeshBlueprint
    if not meshid then return end
    local meshbp = original_blueprints.Mesh[meshid]
    if not meshbp then return end

    local buildmeshbp = table.deepcopy(meshbp)

    if buildmeshbp.LODs then
        local tPath = '/' .. string.lower(directory) .. '/' .. bp.BlueprintId .. '_' .. string.lower(tt) .. '_'
        for i, lod in buildmeshbp.LODs do
            --Models
            local url = tPath .. 'lod' .. i - 1 .. '.scm'
            if TableSubStringFind(textures, url) then
                lod.MeshName = textures[TableSubStringFind(textures, url)]
            end
            local textureTypes = {
                AlbedoName = 'albedo',
                NormalsName = 'normalsts',
                SpecularName = 'specteam',
            }
            if i == 1 then
                for texKey, texVal in textureTypes do
                    --Could also check DiskGetFileInfo(URL).SizeBytes to make sure it exists and isn't corrupt
                    url = tPath .. texVal .. '.dds'
                    --LOG(url)
                    --LOG(TableSubStringFind(textures,url))
                    if TableSubStringFind(textures, url) then
                        lod[texKey] = textures[TableSubStringFind(textures, url)]
                        --LOG("applied")
                    end
                end
            else
                for texKey, texVal in textureTypes do
                    --And then same again for the distance models
                    url = tPath .. 'lod' .. i - 1 .. '_' .. texVal .. '.dds'
                    --LOG(url)
                    if TableSubStringFind(textures, url) then
                        lod[texKey] = textures[TableSubStringFind(textures, url)]
                        --LOG("applied")
                    end
                end
            end
        end
    end
    buildmeshbp.BlueprintId = meshid .. '_' .. string.lower(tt)
    if not bp.Display[directory] then bp.Display[directory] = {} end
    bp.Display[directory][tt] = buildmeshbp.BlueprintId
    MeshBlueprint(buildmeshbp)
    SPEW("created mesh blueprint '" .. buildmeshbp.BlueprintId .. "'. Linked at " .. bp.BlueprintId .. ".Display." .. directory .. "." .. tt )
end
--------------------------------------------------------------------------------
-- like table.find, but checks substrings.
--------------------------------------------------------------------------------
function TableSubStringFind(tab, str)
    for i, v in tab do
        if string.find(v, str) then
            return i
        end
    end
end

end
