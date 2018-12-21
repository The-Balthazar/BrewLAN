do
    local OldModBlueprints = ModBlueprints

    function ModBlueprints(all_blueprints)
        OldModBlueprints(all_blueprints)
        DodecahedronRandumUnitSelector(all_blueprints.Unit)
    end

    function DodecahedronRandumUnitSelector(all_bps)
        if all_bps.zzcrate then
            for id, bp in all_bps do
                local buildThis = false
                if bp.Categories then
                    for i, cat in bp.Categories do
                        --Check it looks like it should be buildable.
                        if string.find(cat,'BUILTBY') then
                            buildThis = true
                            break
                        end
                    end
                end
                --Check its not a ship or a building. Not relying on categories means we can still get things like the Salem.
                if buildThis then
                    if bp.Physics.MotionType ~= 'RULEUMT_None' and bp.Physics.MotionType ~= 'RULEUMT_SurfacingSub' and bp.Physics.MotionType ~= "RULEUMT_Water" then
                        table.insert(all_bps.zzcrate.RandomBuildableUnits, id)
                        --Random engineers
                        if table.find(bp.Categories, 'ENGINEER') then
                            table.insert(all_bps.zzcrate.RandomBuildableEngineers, id)
                        end
                        --Random units of various tech levels
                        if not table.find(bp.Categories, 'EXPERIMENTAL') then
                            table.insert(all_bps.zzcrate.RandomBuildableUnitsT3orLess, id)
                            if not table.find(bp.Categories, 'TECH3') then
                                table.insert(all_bps.zzcrate.RandomBuildableUnitsT2orLess, id)
                                if not table.find(bp.Categories, 'TECH2') then
                                    table.insert(all_bps.zzcrate.RandomBuildableUnitsT1, id)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
