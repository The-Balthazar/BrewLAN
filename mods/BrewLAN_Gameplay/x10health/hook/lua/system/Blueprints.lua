do
    local OldModBlueprints = ModBlueprints

    function ModBlueprints(all_blueprints)
        OldModBlueprints(all_blueprints)
        for id, bp in all_blueprints.Unit do
            if type(bp.Defense.Health) == 'number' then
                bp.Defense.Health = bp.Defense.Health * 10
            end
            if type(bp.Defense.MaxHealth) == 'number' then
                bp.Defense.MaxHealth = bp.Defense.MaxHealth * 10
            end
            if type(bp.Defense.Shield.ShieldMaxHealth) == 'number' then
                bp.Defense.Shield.ShieldMaxHealth = bp.Defense.Shield.ShieldMaxHealth * 10
            end
        end
    end
end
