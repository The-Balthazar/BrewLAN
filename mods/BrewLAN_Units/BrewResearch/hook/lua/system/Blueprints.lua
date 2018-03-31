--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)
    GenerateResearchItemBPs(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Logs
--------------------------------------------------------------------------------
function GenerateResearchItemBPs(all_bps)
    for id, bp in all_bps do
        if bp.Categories then
            if table.find(bp.Categories, 'RESEARCHLOCKED') then
                local sizescale = ((bp.Physics.SkirtSizeX or bp.SizeX or 4) / 2)
                local newid = id .. 'rnd'
                all_bps[newid] = {
                    BlueprintId = newid,
                    ResearchId = id,
                    Categories = {
                        'PRODUCTBREWRD',
                        'BUILTBYTIER3RESEARCH',
                        -- Engine stuff?
                        'VISIBLETORECON',
                        'BENIGN',
                        -- And now some lies.
                        'SELECTABLE',
                        --'MOBILE',
                    },
                    Defense = {
                        ArmorType = 'Normal',
                        Health = 5000,
                        MaxHealth = 5000,
                    },
                    Description = bp.Description,
                    Display = {
                        Abilities = {
                            '<LOC ability_unlock>Research Unlock',
                        },
                        UniformScale = bp.Display.UniformScale / sizescale, --calculate properly based on footprint size
                    },
                    Footprint = {
                        SizeX = 2,
                        SizeZ = 2,
                    },
                    Economy = {
                        BuildCostEnergy = bp.Economy.BuildCostEnergy * (bp.Economy.ResearchMultEnergy or bp.Economy.ResearchMult or  1),
                        BuildCostMass = bp.Economy.BuildCostMass * (bp.Economy.ResearchMultMass or bp.Economy.ResearchMult or  1),
                        BuildTime = bp.Economy.BuildTime * 10 * (bp.Economy.ResearchMultTime or bp.Economy.ResearchMult or  1),
                    },
                    Interface = {
                        HelpText = bp.Description,
                    },
                    LifeBarHeight = 0.075,
                    LifeBarOffset = 1.25,
                    LifeBarSize = 2.5,
                    General = {
                        CapCost = 0,
                        FactionName = 'UEF',
                        Icon = 'land',
                        TechLevel = 'RULEUTL_Advanced',
                        UnitName = bp.General.UnitName,
                        UnitWeight = 1,
                    },
                    Physics = {
                        MeshExtentsX = 2,
                        MeshExtentsY = 1,
                        MeshExtentsZ = 2,
                        --And now some more lies.
                        MaxSpeed = 1,
                        MotionType = 'RULEUMT_Amphibious',
                    },
                    ScriptClass = 'ResearchItem',
                    ScriptModule = '/mods/brewlan_units/brewresearch/lua/research.lua',
                    SizeX = 2,
                    SizeY = 1,
                    SizeZ = 2,
                    Source = bp.Source,
                    StrategicIconName = bp.StrategicIconName,
                }
                for i, v in {'TECH1','TECH2','TECH3','EXPERIMENTAL', 'UEF', 'CYBRAN', 'SERAPHIM', 'AEON', 'SORTSTRATEGIC', 'SORTCONSTRUCTION', 'SORTDEFENSE', 'SORTECONOMY', 'SORTINTEL'} do
                    if table.find(bp.Categories, v) then
                        --This only runs to 2 because all things are buildable by tier 3, so that's predefined already.
                        for number = 1, 2 do
                            if number >= i then
                                table.insert(all_bps[newid].Categories, 'BUILTBYTIER' .. tostring(number) .. 'RESEARCH')
                            end
                        end
                        --If the source has the cat, the research item also needs it.
                        if table.find(bp.Categories, v) then
                            table.insert(all_bps[newid].Categories, v)
                        end
                        -- if I is less than 4 we are dealing with T1, T2, or T3
                        if i < 4 then
                            --If we haven't pre-defined a multiplier, the nultiplier is the tech level.
                            --Units will only exist in one of the first three cats, so this wont stack.
                            if not (bp.Economy.ResearchMultEnergy or bp.Economy.ResearchMult) then
                                all_bps[newid].Economy.BuildCostEnergy = all_bps[newid].Economy.BuildCostEnergy * i
                            end
                            if not (bp.Economy.ResearchMultMass or bp.Economy.ResearchMult) then
                                all_bps[newid].Economy.BuildCostMass = all_bps[newid].Economy.BuildCostMass * i
                            end
                            if not (bp.Economy.ResearchMultTime or bp.Economy.ResearchMult) then
                                all_bps[newid].Economy.BuildTime = all_bps[newid].Economy.BuildTime * i
                            end
                            --Experimentals escape this, because they cost stupid amounts already. Pay once is enough.
                        end
                    end
                end
                --Give units abilities listing what can build them
                GiveUniqueMeshBlueprints(all_bps[newid], bp)
            end
        end
    end
end

function GiveUniqueMeshBlueprints(bp, ref)
    for i, mesh in {'BuildMeshBlueprint', 'MeshBlueprint'} do
        local refid = ref.Display[mesh]
        local meshbp = original_blueprints.Mesh[refid]
        if meshbp then
            local dupebp = table.deepcopy(meshbp)
            dupebp.BlueprintId = refid .. 'rnd'
            bp.Display[mesh] = dupebp.BlueprintId
            MeshBlueprint(dupebp)
        end
    end
    bp.Display.Mesh = {
        BlueprintId = bp.Display.MeshBlueprint,
        IconFadeInZoom = 130,
        Source = ref.Display.Mesh.Source,
    }
end


end
