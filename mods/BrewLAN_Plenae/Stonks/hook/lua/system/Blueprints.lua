--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    STONKS(all_blueprints)
end

--------------------------------------------------------------------------------
-- Removing build restrictions on mass extractors.
--------------------------------------------------------------------------------

function STONKS(all_bps)

    local noTouchShaderHash = {
        MapImager = true,
        Cloud = true,
    }

    local scaledShaderHash = {
        UEFBuildCube = true,
        TMeshGlow = true,
        AlphaFade = true,
        AeonBuildPuddle = true,

        ShieldUEF = true,
        ShieldCybran = true,
        ShieldAeon = true,
        ShieldSeraphim = true,
        ShieldFill = true,
    }

    local buildShaderHash = {
        UEFBuild = true,
        AeonBuild = true,
        CybranBuild = true,
        SeraphimBuild = true,
    }

    local path = ''

    for i, mod in __active_mods do
        if mod.name == "Stonks" then
            path = mod.location
            break
        end
    end

    for id, bp in all_bps.Mesh do
        --if string.find(id, 'buildeffect') then-- == '/effects/entities/uefbuildeffect/uefbuildeffect02_mesh' then
        --    WARN(repr(bp))
        --end
        --WARN(id)
        if bp.LODs
        and bp.LODs[1]
        and not noTouchShaderHash[bp.LODs[1].ShaderName]
        --[[and bp.LODs[1].MeshName ~= '/meshes/generic/cube01_lod0.scm']] then
            if not bp.LODs[2] then
                bp.LODs[2] = table.copy(bp.LODs[1])
            end

            for i, lod in ipairs(bp.LODs) do
                if i == 1 then
                    lod.LODCutoff = 1
                else
                    if scaledShaderHash[lod.ShaderName] then
                        lod.MeshName = path .. '/mememan_1u.scm'
                        lod.AlbedoName = path .. '/mememan_spec2.dds'

                    elseif string.find(id, 'adjacencynode') then
                        lod.MeshName = path .. '/mememan_01u.scm'
                        lod.AlbedoName = path .. '/mememan_albedo.dds'
                        lod.SpecularName = path .. '/mememan_specteam.dds'

                    else
                        if lod.ShaderName ~= 'Wreckage' then
                            if not buildShaderHash[lod.ShaderName] then
                                lod.ShaderName = 'Unit'
                            end
                            lod.SpecularName = path .. '/mememan_specteam.dds'
                        end
                        local _, unitmesh = string.find(id, '/units/')
                        if unitmesh then
                            local unitID = string.sub(id, unitmesh+1, string.find(id, '/', unitmesh+1)-1)
                            local unitBP = all_bps.Unit[unitID]
                            local scale = (
                                unitBP and
                                unitBP.Display and
                                unitBP.Display.UniformScale or 1
                            )
                            local size = math.max(unitBP.SizeX or 1, unitBP.SizeY or 1, unitBP.SizeZ or 1)

                            local u = size / scale

                            if u < 0.5 then
                                lod.MeshName = path .. '/mememan_01u.scm'
                            elseif u < 3 then
                                lod.MeshName = path .. '/mememan_1u.scm'
                            elseif u < 8 then
                                lod.MeshName = path .. '/mememan_5u.scm'
                            elseif u < 11 then
                                lod.MeshName = path .. '/mememan_10u.scm'
                            elseif u < 14 then
                                lod.MeshName = path .. '/mememan_13u.scm'
                            elseif u < 18 then
                                lod.MeshName = path .. '/mememan_15u.scm'
                            elseif u < 30 then
                                lod.MeshName = path .. '/mememan_20u.scm'
                            elseif u < 80 then
                                lod.MeshName = path .. '/mememan_50u.scm'
                            elseif u < 160 then
                                lod.MeshName = path .. '/mememan_100u.scm'
                            else
                                lod.MeshName = path .. '/mememan_200u.scm'
                                --WARN(id.. " U substantially greater than 100: " .. u)
                            end
                        else
                            lod.MeshName = path .. '/mememan_13u.scm'
                        end
                        lod.AlbedoName = path .. '/mememan_albedo.dds'
                        lod.NormalsName = path .. '/mememan_normalsts.dds'
                    end
                end
            end
        end
    end
end

end
