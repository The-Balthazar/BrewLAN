do
    ForkThread(function()
        for i=1, math.ceil(math.sqrt(math.sqrt(ScenarioInfo.size[1]))) do
            ForkThread(function()
                coroutine.yield(Random(1,10))
                local MeteorController = CreateUnitHPR('MET3012', table.getn(ArmyBrains), 0, 0, 0, 0, 0, 0)
                while true do
                    Warp(MeteorController, {
                        ScenarioInfo.size[1]*Random(), 256,
                        ScenarioInfo.size[2]*Random()
                    })
                    coroutine.yield(Random(10, 200))
                end
            end)
        end
    end)
end
