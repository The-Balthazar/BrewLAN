
do
    for i = 1, 5 do
        if i ~= 4 then
            BuffBlueprint {
                Name = 'ResearchItemBuff' .. i, DisplayName = 'ResearchItemBuff' .. i,
                BuffType = 'RESEARCH', Stacks = 'ALWAYS', Duration = -1,
                Affects = {
                    BuildRate    = {Add = (i/100), Mult = 1},
                    EnergyActive = {Add = 0, Mult = 1-(i/100)},
                    MassActive   = {Add = 0, Mult = 1-(i/100)},
                },
            }
        end
    end
end

BuffBlueprint {
    Name = 'ResearchAIxBuff', DisplayName = 'ResearchAIxBuff',
    BuffType = 'RESEARCH', Stacks = 'ALWAYS', Duration = -1,
    Affects = {
        --Research buffs are passed on as upgrades, so the final upgrade gets 3 instances of these.
        BuildRate = {Add = 0, Mult = 1 + (0.25 / 3)},
        EnergyActive = {Add = -0.2, Mult = 1},
        MassActive = {Add = -0.2, Mult = 1},
    },
}

BuffBlueprint {
    Name = 'ResearchAIBuff', DisplayName = 'ResearchAIBuff',
    BuffType = 'RESEARCH', Stacks = 'ALWAYS', Duration = -1,
    Affects = {
        --Research buffs are passed on as upgrades, so the final upgrade gets 3 instances of these.
        EnergyActive = {Add = -0.1, Mult = 1},
        MassActive = {Add = -0.1, Mult = 1},
    },
}
