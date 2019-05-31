do
    local OldModBlueprints = ModBlueprints

    function ModBlueprints(all_blueprints)
        OldModBlueprints(all_blueprints)

        local all_bps = all_blueprints.Unit
        local UnitCodes = {
            UEF = {
                {},{},{},{},
            },
            CYBRAN = {
                {},{},{},{},
            },
            AEON = {
                {},{},{},{},
            },
            SERAPHIM = {
                {},{},{},{},
            },
        }

        local CalcAverages = {
            {0,0},
            {0,0},
            {0,0},
            {0,0},
        }

        ----------------------------------------------------------------
        -- Generate UnitCodes table
        ----------------------------------------------------------------
        for id, bp in all_blueprints.Unit do
            if bp.Categories then
                local factionbit = 0
                local bittingkey = {UEF = 1, CYBRAN = 10, AEON = 100, SERAPHIM = 1000}
                for faction, bit in bittingkey do
                    if table.find(bp.Categories, faction) then
                        factionbit = factionbit + bit
                    end
                end
                for faction, bit in bittingkey do
                    if factionbit == bit then
                        local techcats = {EXPERIMENTAL = 4, TECH3 = 3, TECH2 = 2, TECH1 = 1}
                        for cat, i in techcats do
                            if table.find(bp.Categories, cat) then
                                table.insert(UnitCodes[faction][i], id)
                                bp.OriginalTier = i

                                --averages
                                if type(bp.Economy.MaintenanceConsumptionPerSecondEnergy) == "number" and bp.Economy.MaintenanceConsumptionPerSecondEnergy ~= 0 then--and not table.find(bp.Categories, 'ENERGYSTORAGE') then
                                    CalcAverages[i][1] = CalcAverages[i][1] + bp.Economy.MaintenanceConsumptionPerSecondEnergy
                                    CalcAverages[i][2] = CalcAverages[i][2] + 1
                                end

                                --This bit is entirely because I hate it when other mods make units in more than 1 tier.
                                --Also means we don't have to remove them during swapping
                                --Any that don't get swapped will be then given them back
                                for cat, i in techcats do
                                    table.removeByValue(bp.Categories, cat)
                                end
                            end
                        end
                    end
                end
            end
        end

        for i, v in CalcAverages do
            local j = v[1]/v[2]
            CalcAverages[i] = j
        end
        WARN(repr(CalcAverages))

        --start swapping shit
        for faction, data in UnitCodes do
            local tiers = {'TECH1', 'TECH2', 'TECH3', 'EXPERIMENTAL'}
            while true do
                local Atier = 1 + math.random(0, 2) + math.random(0, 1)
                local tablesize = table.getn(UnitCodes[faction][Atier])
                if tablesize == 0 then
                    --A break here does no harm
                    break
                end
                local AunitI = math.random(1, tablesize)
                local AunitID = UnitCodes[faction][Atier][AunitI]
                if AunitID then
                    table.remove(UnitCodes[faction][Atier], AunitI)
                else
                    --A break here does no harm
                    break
                end

                local Btier = 1 + math.random(0, 2) + math.random(0, 1)
                tablesize = table.getn(UnitCodes[faction][Btier])
                if tablesize == 0 then
                    --A break here means unit A would never get a tier back.
                    table.insert(all_bps[AunitID].Categories, tiers[Atier])
                    break
                end
                local BunitI = math.random(1, tablesize)
                local BunitID = UnitCodes[faction][Btier][BunitI]
                if BunitID then
                    table.remove(UnitCodes[faction][Btier], BunitI)
                else
                    --A break here means unit A would never get a tier back.
                    table.insert(all_bps[AunitID].Categories, tiers[Atier])
                    break
                end

                if Atier == Btier then
                    --Same tier, do next to nothing.
                    table.insert(all_bps[AunitID].Categories, tiers[Atier])
                    table.insert(all_bps[BunitID].Categories, tiers[Btier])
                else
                    --DO THE THING!
                    local TechsChange = function(id, tier)

                        table.insert(all_bps[id].Categories, tiers[tier])

                        CleanBuiltByCategories(all_bps[id], tier)
                        BalanceToTier(all_bps[id], tier)

                        if all_bps[id].Economy.BuildableCategory then
                            for i, cat in all_bps[id].Economy.BuildableCategory do
                                all_bps[id].Economy.BuildableCategory[i] = string.gsub(cat, '%d', tostring(math.min(tier,3) ))
                            end
                        end
                        if tier == 4 then
                            all_bps[id].StrategicIconName = 'icon_experimental_generic'
                        end

                    end

                    TechsChange(AunitID, Btier)
                    TechsChange(BunitID, Atier)

                end
            end
            -- Return cats to any that haven't gotten any back already
            for i = 1, 4 do
                for j, id in UnitCodes[faction][i] do
                    table.insert(all_bps[id].Categories, tiers[i])
                end
            end
        end
    end

    function CleanBuiltByCategories(bp, tech)
        local unitcats = {}
        for i, cat in bp.Categories do
            if string.sub(cat, 1, 7) == 'BUILTBY' then
                table.insert(unitcats, cat)
            end
        end
        local sancats = {}
        for i, cat in unitcats do
            table.removeByValue(bp.Categories, cat)
            local sancat = string.gsub(cat, '%d', 'x', 1)
            if not table.find(sancats, sancat) then
                table.insert(sancats, sancat)
            end
        end
        for i, cat in sancats do
            for starttech = math.min(tech, 3), 3 do  --To Sprouto: Replace this with "for starttech = tech, 4 do" to stop tech 3 building experimentals.
                local cat = string.gsub(cat, 'x', tostring(starttech), 1)
                if cat == 'BUILTBYTIER1COMMANDER' then
                    table.insert(bp.Categories, 'BUILTBYCOMMANDER')
                elseif not (cat == 'BUILTBYCOMMANDER' and tech ~= 1) then
                    table.insert(bp.Categories, cat)
                end
            end
        end
    end

    function BalanceToTier(bp, tech)
        local ot = bp.OriginalTier
        local calA = function(Avgs, stat, tech, ot) return Avgs[stat][tech] / Avgs[stat][ot] end
        local calB = function(Avgs, stat, tech, ot) return {Avgs[stat][tech][1] / Avgs[stat][ot][1], Avgs[stat][tech][2] / Avgs[stat][ot][2]} end
        local setVal = function(val, mult) if type(val) == 'number' then return val * mult else return nil end end
        local mults
        local Avgs = {--these are the approx, rounded, avergaes
            Costs = { --Mass, energy
                {115, 175}, --TECH1
                {500, 800}, --TECH2
                {2500, 7500}, --TECH3
                {40000, 120000}, --EXPERIMENTAL
            },
            Produciton = { -- mass energy
                {2, 45},
                {3.5, 375},
                {14, 1975},
                {10000,1000000},
            },
            Storage = { --excluding dedicated storages. Energy is this including them { 737.5, 7470.3706054688, 839.28570556641, 8250 }
                {50, 110}, --30 including 0 value e-stores
                {100, 285}, --70 including 0 value e-stores
                {210, 840},
                {2350, 8250},
            },
            Health = { 1045, 2950, 8615, 40630 },
            Maintenance = { 35, 110, 1135, 2669 },
            Build = { 15, 30, 55, 195 }, --Build rate excluding silos
        }

        mults = calB(Avgs, 'Costs', tech, ot)
        bp.Economy.BuildCostMass = setVal(bp.Economy.BuildCostMass, mults[1])
        bp.Economy.BuildCostEnergy = setVal(bp.Economy.BuildCostEnergy, mults[2])
        bp.Economy.BuildTime = setVal(bp.Economy.BuildTime, ((mults[1] + mults[2]) / 2))

        mults = calB(Avgs, 'Produciton', tech, ot)
        bp.Economy.ProductionPerSecondMass = setVal(bp.Economy.ProductionPerSecondMass, mults[1])
        bp.Economy.ProductionPerSecondEnergy = setVal(bp.Economy.ProductionPerSecondEnergy, mults[2])
        bp.Economy.MaxMass = setVal(bp.Economy.MaxMass, mults[1])
        bp.Economy.MaxEnergy = setVal(bp.Economy.MaxEnergy, mults[2])

        mults = calB(Avgs, 'Storage', tech, ot)
        bp.Economy.StorageMass = setVal(bp.Economy.StorageMass, mults[1])
        bp.Economy.StorageEnergy = setVal(bp.Economy.StorageEnergy, mults[2])

        mults = calA(Avgs, 'Health', tech, ot)
        bp.Defense.Health = setVal(bp.Defense.Health, mults)
        bp.Defense.MaxHealth = setVal(bp.Defense.MaxHealth, mults)

        mults = calA(Avgs, 'Maintenance', tech, ot)
        bp.Economy.MaintenanceConsumptionPerSecondEnergy = setVal(bp.Economy.MaintenanceConsumptionPerSecondEnergy, mults)

        mults = calA(Avgs, 'Build', tech, ot)
        bp.Economy.BuildRate = setVal(bp.Economy.BuildRate, mults)

        --Intel

        --Size

        -- Weapons

        --speed
    end

end
