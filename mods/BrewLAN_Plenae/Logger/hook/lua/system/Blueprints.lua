--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    --ListAllUnitsNamesDescriptionsForRNN(all_blueprints.Unit)
    CheckLOCTags(all_blueprints.Unit)
    CheckAllUnitBackgroundImages(all_blueprints.Unit)
    CheckAllUnitThreatValues(all_blueprints.Unit)
    CheckCollisionSphereLargeEnoughForMaxSpeed(all_blueprints.Unit)
    CheckEvenFlowOutliers(all_blueprints.Unit)

    FindUnusedFiles(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Logs
--------------------------------------------------------------------------------
function CheckLOCTags(all_bps)
    for id, bp in all_bps do
        if ShouldWeLogThis(id, bp) then
            --[[
            bp.Description
            bp.General.UnitName
            ]]
            local loctable = import('/mods/brewlan/hook/loc/us/strings_db.lua')
            local name = LOC(bp.General.UnitName)
            local nameref = LOCref(bp.General.UnitName)
            local desc = LOC(bp.Description)
            local descref = LOCref(bp.Description)
            LOG(id, name, nameref, loctable[nameref], desc, descref, loctable[descref])
        end
    end
end

function EvenFlow(all_bps)
    local brm = 2
    for id, bp in all_bps do
        if bp.Categories and bp.Economy and bp.Economy.BuildCostEnergy and bp.Economy.BuildCostMass and bp.Economy.BuildTime then
            local DataTable = {
                STRUCTURE = {1, 0.1},
                EXPERIMENTAL = {1, 0.1},
                TECH1 = {2.5 * brm, brm * 0.125},
                TECH2 = {2.5 * brm, brm * 0.08928571428571428571428571428572},
                TECH3 = {2.5 * brm, brm * 0.06578947368421052631578947368421},
            }
            local newtime
            for i, cat in bp.Categories do
                for Ccat, data in DataTable do
                    if cat == Ccat then
                        newtime = math.ceil(math.max( 1, bp.Economy.BuildCostMass * data[1], bp.Economy.BuildCostEnergy * data[2]))
                        bp.Economy.BuildTime = newtime
                        if cat == 'STRUCTURE' and brm ~= 1 and bp.Economy.BuildRate and table.find(bp.Categories, 'FACTORY') then
                            bp.Economy.BuildRate = bp.Economy.BuildRate * brm
                            for j, catj in bp.Categories do
                                if catj == 'TECH2' or catj == 'TECH3' then
                                    bp.Economy.BuildTime = bp.Economy.BuildTime * brm
                                end
                            end
                        end
                        break
                    end
                end
                if newtime then
                    break
                end
            end
        end
    end
end

function CheckEvenFlowOutliers(all_bps)
    local Delta = {}
    local brm = 1
    for id, bp in all_bps do
        if bp.Categories and bp.Economy and bp.Economy.BuildCostEnergy and bp.Economy.BuildCostMass and bp.Economy.BuildTime and ShouldWeLogThis(id, bp) then
            local DataTable = {
                STRUCTURE = {1, 0.1},
                EXPERIMENTAL = {1, 0.1},
                TECH1 = {2.5 * brm, brm * 0.125},
                TECH2 = {2.5 * brm, brm * 0.08928571428571428571428571428572},
                TECH3 = {2.5 * brm, brm * 0.06578947368421052631578947368421},
            }
            local newtime
            for i, cat in bp.Categories do
                for Ccat, data in DataTable do
                    if cat == Ccat then
                        newtime = math.ceil(math.max( 1, bp.Economy.BuildCostMass * data[1], bp.Economy.BuildCostEnergy * data[2]))
                        table.insert(Delta, {id, math.abs(bp.Economy.BuildTime / newtime), bp.Economy.BuildTime, newtime} )
                        break
                    end
                end
                if newtime then
                    break
                end
            end
        end
    end
    table.sort(Delta, function(a, b) return a[2] > b[2] end)
    LOG(repr(Delta))
end

function ListAllUnitsNamesDescriptionsForRNN(all_bps)
    WARN("RNN LIST THING HERE   ------   SDFGKLHJBSDFLJKHSBDF")
    for id, bp in all_bps do
        if bp.Weapon and bp.Categories and table.find(bp.Categories, 'SERAPHIM') then
            local artillery = false
            for i, weapon in bp.Weapon do
                if weapon.ArtilleryShieldBlocks then
                    artillery = true
                    LOG(weapon.DisplayName)
                end
            end
            if artillery then
                LOG(bp.General.UnitName)
            end
        end
    end
    WARN("RNN LIST THING HERE   ------   SDFGKLHJBSDFLJKHSBDF")
    for tech, ptech in {['TECH1'] = 'Tech 1 ',['TECH2'] = 'Tech 2 ',['TECH3'] = 'Tech 3 ',['EXPERIMENTAL'] = ''} do
        for id, bp in all_bps do
            if bp.Categories and table.find(bp.Categories, tech) and table.find(bp.Categories, 'SERAPHIM') then
                if bp.General.UnitName and bp.Description then
                    LOG(LOC(bp.General.UnitName) .. ': ' .. ptech .. LOC(bp.Description))
                end
            end
        end
    end
end


function ShouldWeLogThis(id, bp)
    local units = {
        "xrl0005",
        "xec9003",
        "xec9011",
        "xec9007",
        "xsb5101",
        "xrl0004",
        "ueb5101",
        "xec9001",
        "xec9002",
        "xec9005",
        "xec9006",
        "xec9008",
        "xec9010",
        "urb5101",
        "xec9009",
        "uab5101",
        "xec9004",
        "xrl0002",
        "xrb0304",
        "xrb0204",
        "ssa0001",
        "xrl0003",
        "ueb0301",
        "xsb0301",
        "uab0301",
        "urb0301",
        "uam0004",
        "urm0004",
        "uem0006",
        "xsm0001",
        "xea0306",
        "xra0105",
        "uea0204",
        "xaa0202",
        "uea0107",
        "uea0102",
        "uea0001",
        "dea0202",
        "xsa0203",
        "uaa0102",
        "dra0202",
        "baa0309",
        "bra0309",
        "xaa0306",
        "xea3204",
        "xsa0204",
        "uea0305",
        "ura0203",
        "uea0003",
        "ura0102",
        "uaa0203",
        "xra0305",
        "xsa0202",
        "sel0320",
        "xsa0102",
        "xsa0107",
        "bsa0309",
        "ura0107",
        "uaa0107",
        "ura0204",
        "daa0206",
        "uea0203",
        "xaa0305",
        "uaa0204",
        "uaa0304",
        "xsa0304",
        "ura0304",
        "uea0304",
        "uea0303",
        "ura0303",
        "xsa0303",
        "uaa0303",
        "uea0104",
        "ura0104",
        "xsa0104",
        "uaa0103",
        "uea0103",
        "xsa0103",
        "ura0103",
        "ura0302",
        "xsa0302",
        "uaa0302",
        "uea0302",
        "uaa0101",
        "ura0101",
        "xsa0101",
        "uea0101",
        "ueb0201",
        "urb0201",
        "uab0201",
        "xsb0201",
        "xrb0104",
        "uel0308",
        "ual0308",
        "ues0304",
        "url0303",
        "ual0106",
        "xrl0302",
        "ual0111",
        "dal0310",
        "url0306",
        "ual0208",
        "uel0103",
        "drl0204",
        "uas0202",
        "xes0205",
        "urs0305",
        "xes0102",
        "ual0304",
        "ual0307",
        "uel0304",
        "xal0203",
        "xsl0208",
        "url0107",
        "url0104",
        "urs0303",
        "uas0302",
        "url0205",
        "xsl0305",
        "ues0203",
        "xsl0202",
        "xal0305",
        "xss0201",
        "xss0202",
        "url0101",
        "xss0203",
        "xss0302",
        "xss0303",
        "xss0103",
        "ues0202",
        "uas0201",
        "xel0306",
        "xsl0303",
        "url0307",
        "xsl0104",
        "xel0209",
        "xsl0111",
        "urs0202",
        "xss0305",
        "uel0301",
        "ual0301",
        "ues0103",
        "del0204",
        "urs0201",
        "ues0302",
        "xrs0204",
        "ual0101",
        "ual0104",
        "url0111",
        "xsl0103",
        "xrs0205",
        "uas0203",
        "xel0305",
        "xes0307",
        "urs0304",
        "xsl0307",
        "xrl0305",
        "url0208",
        "uel0205",
        "xss0304",
        "url0103",
        "uas0303",
        "uel0101",
        "ual0205",
        "xsl0203",
        "uel0208",
        "ues0305",
        "uel0104",
        "uel0111",
        "uas0103",
        "urs0203",
        "urs0103",
        "url0301",
        "uel0201",
        "uel0307",
        "uas0305",
        "url0304",
        "xas0204",
        "xsl0205",
        "uas0304",
        "urs0302",
        "xas0306",
        "ues0201",
        "xsl0304",
        "ual0303",
        "ual0103",
        "xsl0301",
        "xsl0309",
        "ual0309",
        "uel0309",
        "url0309",
        "url0203",
        "uel0303",
        "ual0202",
        "uel0203",
        "uel0202",
        "url0202",
        "uas0102",
        "xsl0201",
        "xsl0105",
        "uel0105",
        "url0105",
        "ual0105",
        "ual0201",
        "uel0106",
        "url0106",
        "urb4202",
        "xsl0101",
        "xeb0104",
        "sel0319",
        "ssl0319",
        "sal0319",
        "srl0319",
        "urb1102",
        "xsb1102",
        "ueb1102",
        "uab1102",
        "uab0203",
        "ueb0202",
        "xsb0202",
        "urb0202",
        "urb0203",
        "xsb0203",
        "ueb0203",
        "uab0202",
        "sel0119",
        "sal0324",
        "ssl0324",
        "sab5104",
        "uab1103",
        "xsb3202",
        "uab5202",
        "ssb5104",
        "urb5202",
        "uab1101",
        "ueb3201",
        "xsb5202",
        "urb1103",
        "srl0324",
        "ueb5202",
        "xsb3201",
        "urb3201",
        "xsb1101",
        "urb3202",
        "urb1101",
        "seb5104",
        "ueb1103",
        "uab3202",
        "ueb3202",
        "srb5104",
        "uab3201",
        "xsb1103",
        "ueb1101",
        "uab3105",
        "ueb3105",
        "urb3105",
        "xsb3105",
        "urb0303",
        "xsb0303",
        "uab0303",
        "ueb0303",
        "srl0316",
        "uab2104",
        "ueb0304",
        "xsb0304",
        "urb0304",
        "uab0304",
        "xsb1201",
        "uab1301",
        "uab1201",
        "xsb1301",
        "ueb1201",
        "ueb1301",
        "urb1301",
        "urb1201",
        "uab0302",
        "ueb0302",
        "xsb0302",
        "urb0302",
        "ueb3102",
        "urb2104",
        "uab3106",
        "xsb3102",
        "uab2106",
        "ueb2106",
        "ueb1106",
        "uab0101",
        "xsb1104",
        "ueb4201",
        "urb2106",
        "xsb3106",
        "uab4201",
        "urb3106",
        "uab2204",
        "uab3102",
        "ueb0102",
        "urb2204",
        "ueb1104",
        "ueb3106",
        "uab1104",
        "xsb0101",
        "urb0101",
        "urb1106",
        "xsb2204",
        "xsb2104",
        "ueb2204",
        "urb4201",
        "ueb2104",
        "urb3102",
        "uab0102",
        "xsb0102",
        "urb1104",
        "xsb4201",
        "xsb2106",
        "ueb0101",
        "urb0102",
        "uab1106",
        "xsb1106",
        "xeb0204",
        "sel0324",
        "uaa0310",
        "sab2103",
        "ura0401",
        "sal0209",
        "uab2303",
        "uab2301",
        "srb2103",
        "seb2103",
        "ssb2103",
        "uab3304",
        "ueb2105",
        "urb2109",
        "uab0103",
        "ueb2301",
        "urb2108",
        "urb0103",
        "xsb2301",
        "urb2303",
        "urb3304",
        "urb1202",
        "urb3101",
        "srb2311",
        "xsb2109",
        "xrl0403",
        "sab2308",
        "uab2108",
        "uab2101",
        "url0401",
        "zzz0001",
        "xsb2303",
        "ueb3304",
        "uab1202",
        "seb2308",
        "uab3101",
        "urb2105",
        "zzz0003",
        "ueb2108",
        "ssb2380",
        "uab2105",
        "xsb2101",
        "uel0401",
        "ueb3101",
        "ssb5401",
        "ueb2303",
        "srl0209",
        "ual0401",
        "srl0000",
        "xrb2308",
        "xsb3101",
        "uas0401",
        "srb2402",
        "xsb1202",
        "ueb0103",
        "urb2301",
        "ueb2101",
        "urb4203",
        "ssl0219",
        "urb2101",
        "xsb3304",
        "uab1105",
        "xsb2105",
        "xsb0103",
        "ueb1202",
        "xsl0401",
        "ues0401",
        "url0402",
        "xsa0402",
        "xsb1303",
        "urb1303",
        "uab1303",
        "ueb1303",
        "seb2311",
        "saa0106",
        "sea0106",
        "sra0106",
        "ssa0106",
        "seb5381",
        "srb5380",
        "xsb2304",
        "uab2304",
        "urb2304",
        "ueb2304",
        "srb2306",
        "ssb2311",
        "seb4303",
        "ssb2306",
        "sab2306",
        "seb2401",
        "seb2402",
        "xsb2108",
        "seb2211",
        "ses0319",
        "ssb5210",
        "ueb4203",
        "seb5210",
        "srb5210",
        "uab4203",
        "sab5210",
        "xeb2306",
        "sal0323",
        "xab1401",
        "ueb1105",
        "xsb1105",
        "urb1105",
        "sss0305",
        "ses0219",
        "seb4401",
        "sab2311",
        "xab3301",
        "seb2320",
        "xsb4203",
        "ueb4202",
        "ueb4301",
        "urb4206",
        "ssb3301",
        "xsb2305",
        "ueb2305",
        "urb2305",
        "uab2305",
        "uab4301",
        "sab4401",
        "xsb4302",
        "urb4302",
        "uab4302",
        "ueb4302",
        "urb4207",
        "xrb3301",
        "uab2302",
        "urb4205",
        "ueb1302",
        "uab1302",
        "urb1302",
        "xsb1302",
        "urb2302",
        "ueb2302",
        "xsb2302",
        "xsb4301",
        "ueb3104",
        "xsb3104",
        "urb3104",
        "uab3104",
        "srb4401",
        "urb4204",
        "srl0401",
        "xsb4202",
        "saa0201",
        "srs0319",
        "uab4202",
        "ssa0201",
        "sea0201",
        "urb2205",
        "sss0306",
        "uab2109",
        "xsb2205",
        "uab2205",
        "ueb2109",
        "srb2391",
        "ueb2205",
        "uaa0104",
        "seb2404",
        "sab5301",
        "seb3404",
        "srb4402",
        "ssb5301",
        "srs0219",
        "saa0306",
        "saa0211",
        "sea0310",
        "sra0211",
        "ssa0211",
        "sea0211",
        "ssa0307",
        "sea0307",
        "srb5311",
        "seb5310",
        "srb5312",
        "srb5310",
        "seb5311",
        "sra0201",
        "ssb0401",
        "seb0401",
        "sab0401",
        "srb0401",
        "sra0313",
        "sra0307",
        "sea0314",
        "ssa0314",
        "sra0314",
        "saa0314",
        "srl0320",
        "ssl0311",
        "sel0321",
        "sal0320",
        "sea0002",
        "ssl0320",
        "sra0306",
        "ssl0321",
        "sal0311",
        "srl0311",
        "ssa0306",
        "srl0321",
        "sal0321",
        "xsb2401",
        "seb3303",
        "ssb4401",
        "sal0401",
        "ssa0305",
        "xab2307",
        "ueb2401",
        "ssl0403",
        "ssb2404",
        "sea0401",
        "srb2221",
        "sab2221",
        "seb2221",
        "ssb2221",
        "srb2220",
        "sab2220",
        "ssb2220",
        "seb2220",
        "sab2222",
        "srb2222",
        "seb2222",
        "ssb2222",
    }
    return units and table.find(units, id)
    --return --[[table.find(bp.Categories, 'SELECTABLE') and]] (table.find(bp.Categories, 'PRODUCTBREWLAN') or table.find(bp.Categories, 'PRODUCTBREWLANTURRETS') or table.find(bp.Categories, 'PRODUCTBREWLANSHIELDS') or table.find(bp.Categories, 'PRODUCTBREWLANRND') or table.find(bp.Categories, 'PRODUCTSPOMENIKI'))
    --return table.find(bp.Categories, 'SELECTABLE') and (table.find(bp.Categories, 'TECH1') or table.find(bp.Categories, 'TECH2') or table.find(bp.Categories, 'TECH3') or table.find(bp.Categories, 'EXPERIMENTAL') )
end

function CheckAllUnitBackgroundImages(all_bps)
    for id, bp in all_bps do
        CheckUnitHasCorrectIconBackground(id, bp)
    end
end

function CheckCollisionSphereLargeEnoughForMaxSpeed(all_bps)
    for id, bp in all_bps do
    	if bp.SizeSphere and bp.Air.MaxAirspeed and ShouldWeLogThis(id, bp) then
            local correctMin = bp.Air.MaxAirspeed * 0.095
            if bp.SizeSphere < correctMin then
        		LOG(id ..  " has a size sphere of " .. bp.SizeSphere .. ", but needs at least " .. correctMin)
            elseif bp.SizeSphere > correctMin + 0.1 then
                LOG(id ..  " has a size sphere of " .. bp.SizeSphere .. ", but could have as low as " .. correctMin)
            end
    		--bp.SizeSphere = math.max( 0.9, bp.Air.MaxAirspeed * 0.095 )
    		--LOG("*AI DEBUG "..bp.Description.." has a new sphere of "..bp.SizeSphere)
    	end
    end
end

function FindUnusedFiles(all_bps)
    local models = DiskFindFiles('/units/', '*lod0.scm')
    local bps = DiskFindFiles('/units/', '*.bp')
    local modelsnobp = {}
    for i, path in models do
        if not table.find(bps, string.gsub(path, 'lod0.scm', 'unit.bp' )) then
            table.insert(modelsnobp, path)
        end
    end
    WARN("Potentially long list of unused lod0 models:")
    LOG(repr(modelsnobp))
end

function CheckAllUnitThreatValues(all_bps)
    local LOGOutput = {}
    for id, bp in all_bps do
    --for i, id in units do local bp = all_bps[id]
        if ShouldWeLogThis(id, bp) then
        --if table.find(bp.Categories, 'INDIRECTFIRE') and table.find(bp.Categories, 'UEF') then
            --Define output table
            LOGOutput[id] = {
                Description = LOC(bp.Description),
                Defense = {
                    AirThreatLevel = 0,
                    EconomyThreatLevel = 0,
                    SubThreatLevel = 0,
                    SurfaceThreatLevel = 0,
                    --These are temporary to be merged into the others after calculations
                    HealthThreat = 0,
                    PersonalShieldThreat = 0,
                    UnknownWeaponThreat = 0,
                }
            }
            LOG(id)--For checking what breaks it
            --define base health and shield values
            if bp.Defense.MaxHealth then
                LOGOutput[id].Defense.HealthThreat = bp.Defense.MaxHealth * 0.01
            end
            if bp.Defense.Shield then
                local shield = bp.Defense.Shield                                               --ShieldProjectionRadius entirely only for the Pillar of Prominence
                local shieldarea = (shield.ShieldProjectionRadius or shield.ShieldSize or 0) * (shield.ShieldProjectionRadius or shield.ShieldSize or 0) * math.pi
                local skirtarea = (bp.Physics.SkirtSizeX or 3) * (bp.Physics.SkirtSizeY or 3)                                                              -- Added so that transport shields dont count as personal shields.
                if (bp.Display.Abilities and table.find(bp.Display.Abilities,'<LOC ability_personalshield>Personal Shield') or shieldarea < skirtarea) and not table.find(bp.Categories, 'TRANSPORT') then
                    LOGOutput[id].Defense.PersonalShieldThreat = (shield.ShieldMaxHealth or 0) * 0.01
                else
                    LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + ((shieldarea - skirtarea) * (shield.ShieldMaxHealth or 0) * (shield.ShieldRegenRate or 1)) / 250000000
                end
            end

            --Define eco production values
            if bp.Economy.ProductionPerSecondMass then
                --Mass prod + 5% of health
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.ProductionPerSecondMass * 10 + (LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat) * 5
            end
            if bp.Economy.ProductionPerSecondEnergy then
                --Energy prod + 1% of health
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.ProductionPerSecondEnergy * 0.1 + LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat
            end
            --0 off the personal health values if we alreaady used them
            if bp.Economy.ProductionPerSecondMass or bp.Economy.ProductionPerSecondEnergy then
                LOGOutput[id].Defense.HealthThreat = 0
                LOGOutput[id].Defense.PersonalShieldThreat = 0
            end

            --Calculate for build rates, ignore things that only upgrade
            if ShouldWeCalculateBuildRate(bp) then
                --non-mass producing energy production units that can build get off easy on the health calculation. Engineering reactor, we're looking at you
                if bp.Physics.MotionType == 'RULEUMT_None' then
                    LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.BuildRate * 1 / (bp.Economy.BuilderDiscountMult or 1) * 2 + (LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat) * 2
                else
                    LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.BuildRate  + (LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat) * 3
                end
                --0 off the personal health values if we alreaady used them
                LOGOutput[id].Defense.HealthThreat = 0
                LOGOutput[id].Defense.PersonalShieldThreat = 0
            end

            --Calculate for storage values.
            if bp.Economy.StorageMass then
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.StorageMass * 0.001 + LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat
            end
            if bp.Economy.StorageEnergy then
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.StorageEnergy * 0.001 + LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat
            end
            --0 off the personal health values if we alreaady used them
            if bp.Economy.StorageMass or bp.Economy.StorageEnergy then
                LOGOutput[id].Defense.HealthThreat = 0
                LOGOutput[id].Defense.PersonalShieldThreat = 0
            end

            --Arbitrary high bonus threat for special high pri
            if table.find(bp.Categories, 'SPECIALHIGHPRI') then
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + 250
            end

            --No one really cares about air staging, well maybe a little bit.
            if bp.Transport.DockingSlots then
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Transport.DockingSlots
            end

            --Wepins
            if bp.Weapon then
                for i, weapon in bp.Weapon do
                    if weapon.RangeCategory == 'UWRC_AntiAir' or weapon.TargetRestrictOnlyAllow == 'AIR' or string.find(weapon.WeaponCategory or 'nope', 'Anti Air') then
                        LOGOutput[id].Defense.AirThreatLevel = LOGOutput[id].Defense.AirThreatLevel + CalculatedDPS(weapon) / 10
                    elseif weapon.RangeCategory == 'UWRC_AntiNavy' or string.find(weapon.WeaponCategory or 'nope', 'Anti Navy') then
                        if string.find(weapon.WeaponCategory or 'nope', 'Bomb') or string.find(weapon.Label or 'nope', 'Bomb') or weapon.NeedToComputeBombDrop or bp.Air.Winged then
                            LOG("Bomb drop damage value " .. CalculatedDamage(weapon))
                            LOGOutput[id].Defense.SubThreatLevel = LOGOutput[id].Defense.SubThreatLevel + CalculatedDamage(weapon) / 100
                        else
                            LOGOutput[id].Defense.SubThreatLevel = LOGOutput[id].Defense.SubThreatLevel + CalculatedDPS(weapon) / 10
                        end
                    elseif weapon.RangeCategory == 'UWRC_DirectFire' or string.find(weapon.WeaponCategory or 'nope', 'Direct Fire')
                    or weapon.RangeCategory == 'UWRC_IndirectFire' or string.find(weapon.WeaponCategory or 'nope', 'Artillery') then
                        --Range cutoff for artillery being considered eco and surface threat is 100
                        local wepDPS = CalculatedDPS(weapon)
                        local rangeCutoff = 50
                        local econMult = 1
                        local surfaceMult = 0.1
                        if weapon.MinRadius and weapon.MinRadius >= rangeCutoff then
                            LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + wepDPS * econMult
                        elseif weapon.MaxRadius and weapon.MaxRadius <= rangeCutoff then
                            LOGOutput[id].Defense.SurfaceThreatLevel = LOGOutput[id].Defense.SurfaceThreatLevel + wepDPS * surfaceMult
                        else
                            local distr = (rangeCutoff - (weapon.MinRadius or 0)) / (weapon.MaxRadius - (weapon.MinRadius or 0))
                            LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + wepDPS * (1 - distr) * econMult
                            LOGOutput[id].Defense.SurfaceThreatLevel = LOGOutput[id].Defense.SurfaceThreatLevel + wepDPS * distr * surfaceMult
                        end
                    elseif string.find(weapon.WeaponCategory or 'nope', 'Bomb') or string.find(weapon.Label or 'nope', 'Bomb') or weapon.NeedToComputeBombDrop then
                        LOG("Bomb drop damage value " .. CalculatedDamage(weapon))
                        LOGOutput[id].Defense.SurfaceThreatLevel = LOGOutput[id].Defense.SurfaceThreatLevel + CalculatedDamage(weapon) / 100
                    elseif string.find(weapon.WeaponCategory or 'nope', 'Death') then
                        LOGOutput[id].Defense.EconomyThreatLevel = math.floor(LOGOutput[id].Defense.EconomyThreatLevel + CalculatedDPS(weapon) / 200)
                    else
                        LOGOutput[id].Defense.UnknownWeaponThreat = LOGOutput[id].Defense.UnknownWeaponThreat + CalculatedDPS(weapon)
                        LOG(" * WARNING: Unknown weapon type on: " .. id .. " with the weapon label: " .. (weapon.Label or "nil") )
                        LOGOutput[id].Warnings = (LOGOutput[id].Warnings or 0) + 1
                    end
                    --LOG(id .. " - " .. LOC(bp.General.UnitName or bp.Description) .. ' -- ' .. (weapon.DisplayName or '<Unnamed weapon>') .. ' ' .. weapon.RangeCategory .. " DPS: " .. CalculatedDPS(weapon))
                end
            end

            --See if it has real threat yet
            local checkthreat = 0
            for k, v in { 'AirThreatLevel', 'EconomyThreatLevel', 'SubThreatLevel', 'SurfaceThreatLevel',} do
                checkthreat = checkthreat + LOGOutput[id].Defense[v]
            end

            --Last ditch attempt to give it some threat
            if checkthreat < 1 then
                if LOGOutput[id].Defense.UnknownWeaponThreat > 0 then
                    --If we have no idea what it is still, it has threat equal to its unkown weapon DPS.
                    LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.UnknownWeaponThreat
                    LOGOutput[id].Defense.UnknownWeaponThreat = 0
                elseif bp.Economy.MaintenanceConsumptionPerSecondEnergy > 0 then
                    --If we STILL have no idea what it's threat is, and it uses power, its obviously doing something fucky, so we'll use that.
                    LOGOutput[id].Defense.EconomyThreatLevel = bp.Economy.MaintenanceConsumptionPerSecondEnergy * 0.0175
                end
            end

            --Get rid of unused threat values
            for i, v in {'HealthThreat','PersonalShieldThreat', 'UnknownWeaponThreat'} do
                if LOGOutput[id].Defense[v] and LOGOutput[id].Defense[v] ~= 0 then
                    LOG("Unused " .. v .. " " .. LOGOutput[id].Defense[v])
                    LOGOutput[id].Defense[v] = nil
                end
            end

            --Sanitise the table
            checkthreat = 0
            for i, v in LOGOutput[id].Defense do
                --Round appropriately
                if v < 1 then
                    LOGOutput[id].Defense[i] = 0
                else
                    LOGOutput[id].Defense[i] = math.floor(v + 0.5)
                end
                --Only report numbers if they aren't the same as on file.
                if LOGOutput[id].Defense[i] == (bp.Defense[i] or 0) then
                    LOGOutput[id].Defense[i] = nil
                end
                if LOGOutput[id].Defense[i] then
                    checkthreat = checkthreat + LOGOutput[id].Defense[i]
                end
            end
            -- If we have nothing to tell, tell nothing.
            if checkthreat == 0 then
                LOGOutput[id] = nil
            end

        end
    end
    LOG(repr(LOGOutput))
end

function ShouldWeCalculateBuildRate(bp)
    if not bp.Economy.BuildRate then
        return false
    end
    if table.find(bp.Categories, 'HEAVYWALL') then
        return false
    end
    local TrueCats = {
        'FACTORY',
        'ENGINEER',
        'FIELDENGINEER',
        'CONSTRUCTION',
        'ENGINEERSTATION',
    }
    for i, v in TrueCats do
        if table.find(bp.Categories, v) then
            return true
        end
    end

    return not table.find(bp.Economy.BuildableCategory or {'nahh'}, bp.General.UpgradesTo or 'nope') and not bp.Economy.BuildableCategory[2]
end

function CalculatedDamage(weapon)
    local ProjectileCount = math.max(1, table.getn(weapon.RackBones[1].MuzzleBones or {'boop'} ), weapon.MuzzleSalvoSize or 1 )
    if weapon.RackFireTogether then
        ProjectileCount = ProjectileCount * math.max(1, table.getn(weapon.RackBones or {'boop'} ) )
    end
    return ((weapon.Damage or 0) + (weapon.NukeInnerRingDamage or 0)) * ProjectileCount * (weapon.DoTPulses or 1)
end

function CalculatedDPS(weapon)
    --Base values
    local ProjectileCount = math.max(1, table.getn(weapon.RackBones[1].MuzzleBones or {'boop'} ), weapon.MuzzleSalvoSize or 1 )
    if weapon.RackFireTogether then
        ProjectileCount = ProjectileCount * math.max(1, table.getn(weapon.RackBones or {'boop'} ) )
    end
    --Game logic rounds the timings to the nearest tick -- math.max(0.1, 1 / (weapon.RateOfFire or 1)) for unrounded values
    local DamageInterval = math.floor((math.max(0.1, 1 / (weapon.RateOfFire or 1)) * 10) + 0.5) / 10 + ProjectileCount * (math.max(weapon.MuzzleSalvoDelay or 0, weapon.MuzzleChargeDelay or 0) * (weapon.MuzzleSalvoSize or 1) )
    local Damage = ((weapon.Damage or 0) + (weapon.NukeInnerRingDamage or 0)) * ProjectileCount * (weapon.DoTPulses or 1)

    --Beam calculations.
    if weapon.BeamLifetime and weapon.BeamLifetime == 0 then
        --Unending beam. Interval is based on collision delay only.
        DamageInterval = 0.1 + (weapon.BeamCollisionDelay or 0)
    elseif weapon.BeamLifetime and weapon.BeamLifetime > 0 then
        --Uncontinuous beam. Interval from start to next start.
        DamageInterval = DamageInterval + weapon.BeamLifetime
        --Damage is calculated as a single glob
        Damage = Damage * (weapon.BeamLifetime / (0.1 + (weapon.BeamCollisionDelay or 0)))
    end

    return Damage * (1 / DamageInterval) or 0
end

function CheckUnitHasCorrectIconBackground(id, bp)
    local icon = string.lower(bp.General.Icon or 'land')
    local MT = bp.Physics.MotionType
    local BLC = bp.Physics.BuildOnLayerCaps -- LAYER_Air LAYER_Land
    local cats = bp.Categories
    local errorString = "unit: " .. id .. " (" .. LOC(bp.Description) .. ") has the wrong icon background (bp.General.Icon) reports: '" .. icon .. "' should be "

    if (
        MT == 'RULEUMT_Air' -- Fliers
        or MT == 'RULEUMT_None' and table.find(cats, 'FACTORY') and table.find(cats, 'AIR') --Aircraft factories
    ) then
        if icon ~= 'air' then
            LOG(errorString .. "'air'.")
            --LOG(repr(BLC))
        end
    elseif (
        MT == 'RULEUMT_Water' --Main two
        or MT == 'RULEUMT_SurfacingSub'
        or MT == 'RULEUMT_None' and not BLC.LAYER_Land and (BLC.LAYER_Seabed or BLC.LAYER_Sub or BLC.LAYER_Water) --buildings buildable in or on water, but not land
        or MT == 'RULEUMT_None' and table.find(cats, 'FACTORY') and table.find(cats, 'NAVAL') --Naval factories, if not specifically covered by the above, which they should be.
    ) then
        if icon ~= 'sea' then
            LOG(errorString .. "'sea'.")
            --LOG(repr(BLC))
        end
    elseif (
        (MT == 'RULEUMT_Hover' or MT == 'RULEUMT_AmphibiousFloating' or MT == 'RULEUMT_Amphibious' )
        or MT == 'RULEUMT_None' and BLC.LAYER_Land and (BLC.LAYER_Seabed or BLC.LAYER_Sub or BLC.LAYER_Water) --buildings buildable in or on water as well as on land.
    ) then
        if icon ~= 'amph' then
            LOG(errorString .. "'amph'.")
            --LOG(repr(BLC))
        end
    elseif (
        MT == 'RULEUMT_Land'
        or MT == 'RULEUMT_None' and BLC.LAYER_Land and not (BLC.LAYER_Seabed or BLC.LAYER_Sub or BLC.LAYER_Water) --buildings buildable on land, but not in or on the water.
    ) then
        if icon ~= 'land' then
            LOG(errorString .. "'land'.")
            --LOG(repr(BLC))
        end
    end
end

function LOC(s)
    if type(s) == 'string' and string.sub(s, 1, 4)=='<LOC' then
        local i = string.find(s,">")
        if i then
            s = string.sub(s, i+1)
        end
    end
    return s or 'nil'
end

function LOCref(s)
    if type(s) == 'string' and string.sub(s, 1, 4)=='<LOC' then
        local i = string.find(s,">")
        if i then
            s = string.sub(s, 6, i-1)
        end
    end
    return s or 'nil'
end


end
