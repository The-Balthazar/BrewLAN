do
    local OldModBlueprints = ModBlueprints
 
    function ModBlueprints(all_blueprints)         
        OldModBlueprints(all_blueprints)
        DodecahedronRandumUnitSelector(all_blueprints.Unit)
    end
 
    function DodecahedronRandumUnitSelector(all_bps)
        for id, bp in all_bps do
            if bp.Categories then
                for i, cat in bp.Categories do
                    if string.find(cat,'BUILTBY') then  
                        table.insert(all_bps.zzcrate.RandomBuildableUnits, id)
                    end
                end
                if table.find(bp.Categories, 'ENGINEER') and table.find(bp.Categories, 'MOBILE') then
                    for i, cat in bp.Categories do
                        if string.find(cat,'BUILTBY') then  
                            table.insert(all_bps.zzcrate.RandomBuildableEngineers, id)
                        end
                    end 
                end
            end
        end
    end
end