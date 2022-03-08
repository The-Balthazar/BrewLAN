--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local IsChristmas = false
    local HatsOnlyMode
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    local FindCreateDropPath = function()
        for i, mod in __active_mods do
            if mod.uid == "BREWLANS-a0a7-426d-88f2-CRATESZ00012" then
                return mod.location
            end
        end
    end
    local CreateDropPath = FindCreateDropPath()

    function CreateInitialArmyGroup(strArmy, createCommander)
        if not ScenarioInfo.DodecahedronCrate then
            HatsOnlyMode = ScenarioInfo.Options.CrateHatsOnly
            ScenarioInfo.DodecahedronCrate = { }
            ScenarioInfo.DodecahedronCrate.Threads = {}
            local crateNum = math.max(math.log(math.min(ScenarioInfo.size[1],ScenarioInfo.size[2]))/math.log(2) - 6, 1)
            LOG(crateNum .. " CRATES" .. " " .. ScenarioInfo.size[1] .. " " .. ScenarioInfo.size[2])
            for i = 1, crateNum do
                ScenarioInfo.DodecahedronCrate.Threads[i] = ForkThread(crateThread,crateNum)
            end
        end
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end

    local function RandomiseCrateMesh(crate)
        local crateTypes = IsChristmas and {
            'CRATE_Present_01',
            'CRATE_Present_02',
            'CRATE_Present_03',
            'CRATE_Present_04',
            'CRATE_Present_05',
        } or {
            'CRATE_Dodecahedron',
            'CRATE_Icosahedron',
            'CRATE_Truncated_Tetrahedron',
        }
        local crateType = crateTypes[math.random(1, table.getn(crateTypes) )]
        crate:SetMesh(CreateDropPath .. '/effects/entities/' .. crateType .. '/' .. crateType ..'_mesh')
        return crate
    end

    function crateThread(crateNum)
        local crate = import('/lua/sim/Entity.lua').Entity()
        local flash
        Warp(crate,getSafePos{-1,-1,-1})
        RandomiseCrateMesh(crate)
        crate:SetDrawScale(.08)
        crate:SetVizToAllies('Intel')
        crate:SetVizToNeutrals('Intel')
        crate:SetVizToEnemies('Intel')
        while true do
            coroutine.yield(2)
            local search = {}
            for index, brain in ArmyBrains do
                for i, unit in import('/lua/ai/aiutilities.lua').GetOwnUnitsAroundPoint(brain, categories.SELECTABLE, crate:GetPosition(), 1) do
                    if unit:GetCurrentLayer() == "Land" then
                        table.insert(search, unit)
                    end
                end
            end
            if search[1] and IsUnit(search[1]) then
                local UnitArmy = search[1]:GetArmy()
                local cratepos = crate:GetPosition()
                PhatLewt(search[1], cratepos )
                flash = CreateEmitterAtEntity(crate, UnitArmy, '/effects/emitters/flash_01_emit.bp'):ScaleEmitter(10)
                Warp(crate,{cratepos[1],cratepos[2]-20,cratepos[3]})
                coroutine.yield(5)
                RandomiseCrateMesh(crate)
                flash:Destroy()
                coroutine.yield(10*math.random(1,10*crateNum))
                Warp(crate,getSafePos(cratepos))
                flash = CreateEmitterAtEntity(crate, UnitArmy, '/effects/emitters/flash_01_emit.bp'):ScaleEmitter(4)
                coroutine.yield(5)
                flash:Destroy()
            end
        end
    end

    local Buff = import('/lua/sim/Buff.lua')
    --local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
    local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

    local lewt = {
        -- Free stuff.
        {
            --------------------------------------------------------------------
            --5000 mass
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Dat mass")
                local aiBrain = Unit:GetAIBrain()
                local mass = aiBrain:GetEconomyStored('MASS')
                local ratio = aiBrain:GetEconomyStoredRatio('MASS')
                local storagespace = (mass * (1/ratio) ) - mass
                if storagespace > 5000 then
                    if math.random(1,10) == 10 then
                        LOG("JACKPOT")
                        aiBrain:GiveResource('Mass', storagespace )
                        PhatLewt(Unit, pos,'HAT_Crown')--Bonus jackpot hat
                    else
                        aiBrain:GiveResource('Mass', math.max(5000, storagespace/10) )
                    end
                    notificationPingis(pos, Unit:GetArmy(), 'Mass', '<LOC tooltipui0245>Mass Collected' )
                else
                    WARN("Rolled for mass, but storage space is low. Rolling again.")
                    PhatLewt(Unit, pos)
                end
            end,
            --------------------------------------------------------------------
            --Clone at current health
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Clone")
                local clone = CreateUnitHPR(Unit.BpId or Unit:GetBlueprint().BlueprintId, Unit:GetArmy(), pos[1], pos[2], pos[3], 0, math.random(0,360), 0)
                for kbuff, vbuff in Unit.Buffs.BuffTable do
                    for k, v in vbuff do
                        Buff.ApplyBuff(clone, v.BuffName)
                    end
                end
                --clone:SetMaxHealth(Unit:GetMaxHealth() )
                clone:SetHealth(Unit, Unit:GetHealth() )
                if clone:GetBlueprint().Description then
                    notificationPingis(pos, Unit:GetArmy(), 'Clone', clone:GetBlueprint().Description )
                else
                    notificationPingis(pos, Unit:GetArmy(), 'Clone', '<LOC tooltips_0000>Give Units' )
                end
            end,
            --------------------------------------------------------------------
            --Random buildable unit
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Random dude")
                local clone = CreateUnitHPR(randomBuildable(gatedRandomBuildableType(Unit)), Unit:GetArmy(), pos[1], pos[2], pos[3], 0, math.random(0,360), 0)
                if clone:GetBlueprint().Description then
                    notificationPingis(pos, Unit:GetArmy(), 'Dude', clone:GetBlueprint().Description )
                else
                    notificationPingis(pos, Unit:GetArmy(), 'Dude', '<LOC tooltips_0000>Give Units' )
                end
            end,
            --------------------------------------------------------------------
            --Random buildable mobile engineer
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Engineer")
                local clone = CreateUnitHPR(randomBuildable('Engineers'), Unit:GetArmy(), pos[1], pos[2], pos[3], 0, math.random(0,360), 0)
                if clone:GetBlueprint().Description then
                    notificationPingis(pos, Unit:GetArmy(), 'EngineerDude', clone:GetBlueprint().Description )
                else
                    notificationPingis(pos, Unit:GetArmy(), 'EngineerDude', '<LOC tooltips_0000>Give Units' )
                end
            end,
            --------------------------------------------------------------------
        },
        -- Unit buffs
        {
            --------------------------------------------------------------------
            --Double health and heal
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Health buff")
                if not Buffs['CrateHealthBuff'] then
                    BuffBlueprint {
                        Name = 'CrateHealthBuff',
                        DisplayName = 'CrateHealthBuff',
                        BuffType = 'CrateHealthBuff',
                        Stacks = 'ALWAYS',
                        Duration = -1,
                        Affects = {
                            MaxHealth = {
                                Add = 0,
                                Mult = 1.5,
                            },
                            Health = {
                                Add = 0,
                                Mult = 1.5,
                            },
                        },
                    }
                    BuffBlueprint {
                        Name = 'CrayCrateHealthBuff',
                        DisplayName = 'CrayCrateHealthBuff',
                        BuffType = 'CrayCrateHealthBuff',
                        Stacks = 'ALWAYS',
                        Duration = -1,
                        Affects = {
                            MaxHealth = {
                                Add = 0,
                                Mult = 10,
                            },
                            Health = {
                                Add = 0,
                                Mult = 10,
                            },
                        },
                    }
                end
                if math.random(1,100) == 100 then
                    LOG("JACKPOT")
                    Buff.ApplyBuff(Unit, 'CrayCrateHealthBuff')
                    PhatLewt(Unit, pos,'HAT_Crown')--Bonus jackpot hat
                else
                    Buff.ApplyBuff(Unit, 'CrateHealthBuff')
                end
                notificationPingis(pos, Unit:GetArmy(), 'Health')
            end,
            --------------------------------------------------------------------
            --Give larger vis range
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Vision buff")
                if ScenarioInfo.Options.FogOfWar == 'none' then
                    WARN("Vision buff selected while fog of war disabled. Rolling again.")
                    PhatLewt(Unit, pos)
                else
                    if not Buffs['CrateVisBuff'] then
                        BuffBlueprint {
                            Name = 'CrateVisBuff',
                            DisplayName = 'CrateVisBuff',
                            BuffType = 'CrateVisBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                VisionRadius = {
                                    Add = 20,
                                    Mult = 1,
                                },
                            },
                        }
                        BuffBlueprint {
                            Name = 'CrayCrateVisBuff',
                            DisplayName = 'CrayCrateVisBuff',
                            BuffType = 'CrayCrateVisBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                VisionRadius = {
                                    Add = 0,
                                    Mult = 2,
                                },
                            },
                        }
                    end
                    if math.random(1,100) == 100 then
                        LOG("JACKPOT")
                        Buff.ApplyBuff(Unit, 'CrayCrateVisBuff')
                        PhatLewt(Unit, pos,'HAT_Crown')--Bonus jackpot hat
                    else
                        Buff.ApplyBuff(Unit, 'CrateVisBuff')
                    end
                    notificationPingis(pos, Unit:GetArmy(), 'Intel', '<LOC tooltipui0082>Intel')
                end
            end,
            --------------------------------------------------------------------
            --Give larger radar range
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Radar buff")
                if Unit:GetBlueprint().Intel.RadarRadius > 0 then
                    if not Buffs['CrateRadarBuff'] then
                        BuffBlueprint {
                            Name = 'CrateRadarBuff',
                            DisplayName = 'CrateRadarBuff',
                            BuffType = 'CrateRadarBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                RadarRadius = {
                                    Add = 0,
                                    Mult = 1.25,
                                },
                            },
                        }
                        BuffBlueprint {
                            Name = 'CrayCrateRadarBuff',
                            DisplayName = 'CrayCrateRadarBuff',
                            BuffType = 'CrayCrateRadarBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                RadarRadius = {
                                    Add = 1000,
                                    Mult = 1,
                                },
                            },
                        }
                    end
                    if math.random(1,100) == 100 then
                        LOG("JACKPOT")
                        Buff.ApplyBuff(Unit, 'CrayCrateRadarBuff')
                        PhatLewt(Unit, pos,'HAT_Crown')--Bonus jackpot hat
                    else
                        Buff.ApplyBuff(Unit, 'CrateRadarBuff')
                    end
                    notificationPingis(pos, Unit:GetArmy(), 'Intel', '<LOC tooltipui0082>Intel')
                else
                    WARN("Radar buff selected but unit has no radar to buff. Rolling again.")
                    PhatLewt(Unit, pos)
                end
            end,
            --------------------------------------------------------------------
            --Give more dakka
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Guns buff")
                local goodtogo = false
                if Unit:GetBlueprint().Weapon then
                    for i, v in Unit:GetBlueprint().Weapon do
                        if v.WeaponCategory ~= 'Death' and v.Damage > 0 then
                            goodtogo = true
                            break
                        end
                    end
                end

                if not goodtogo then
                    WARN("This unit lacks damage dealing non-death weapons. Rolling again.")
                    PhatLewt(Unit, pos)
                else
                    if not Buffs['CrateDamageBuff'] then
                        BuffBlueprint {
                            Name = 'CrateDamageBuff',
                            DisplayName = 'CrateDamageBuff',
                            BuffType = 'CrateDamageBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                Damage = {
                                    Add = 0,
                                    Mult = 1.1,
                                },
                                --DamageRadius = {
                                --    Add = 0,
                                --    Mult = 1.1,
                                --},
                                MaxRadius = {
                                    Add = 0,
                                    Mult = 1.15,
                                },
                            },
                        }
                        BuffBlueprint {
                            Name = 'CrayCrateDamageBuff',
                            DisplayName = 'CrayCrateDamageBuff',
                            BuffType = 'CrayCrateDamageBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                Damage = {
                                    Add = 0,
                                    Mult = 11,
                                },
                                --DamageRadius = {
                                --    Add = 0,
                                --    Mult = 11,
                                --},
                                MaxRadius = {
                                    Add = 0,
                                    Mult = 15,
                                },
                            },
                        }
                    end
                    if math.random(1,100) == 100 then
                        LOG("JACKPOT")
                        Buff.ApplyBuff(Unit, 'CrayCrateDamageBuff')
                        PhatLewt(Unit, pos,'HAT_Crown')--Bonus jackpot hat
                    else
                        Buff.ApplyBuff(Unit, 'CrateDamageBuff')
                    end
                    notificationPingis(pos, Unit:GetArmy(), 'Weapon')
                end
            end,
            --------------------------------------------------------------------
            --Give fasterness
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Speed buff")
                if Unit:GetBlueprint().Physics.MotionType == 'RULEUMT_None' then
                    WARN("Unit that can't move rolled speed buff. Rolling again.")
                    PhatLewt(Unit, pos)
                else
                    if not Buffs['CrateMoveBuff'] then
                        BuffBlueprint {
                            Name = 'CrateMoveBuff',
                            DisplayName = 'CrateMoveBuff',
                            BuffType = 'CrateMoveBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                MoveMult = {
                                    Add = 0,
                                    Mult = 1.2,
                                },
                            },
                        }
                        BuffBlueprint {
                            Name = 'CrayCrateMoveBuff',
                            DisplayName = 'CrayCrateMoveBuff',
                            BuffType = 'CrayCrateMoveBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                MoveMult = {
                                    Add = 0,
                                    Mult = 10,
                                },
                            },
                        }
                    end
                    if math.random(1,100) == 100 then
                        LOG("JACKPOT")
                        Buff.ApplyBuff(Unit, 'CrayCrateMoveBuff')
                        PhatLewt(Unit, pos,'HAT_Crown')--Bonus jackpot hat
                    else
                        Buff.ApplyBuff(Unit, 'CrateMoveBuff')
                    end
                    notificationPingis(pos, Unit:GetArmy(), 'Speed', '<LOC lobui_0262>Fast' )
                end
            end,
            --------------------------------------------------------------------
            --Give fasterness of building
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Build buff")
                if Unit:GetBlueprint().Economy.BuildRate > 0 then
                    if not Buffs['CrateEngiBuff'] then
                        BuffBlueprint {
                            Name = 'CrateEngiBuff',
                            DisplayName = 'CrateEngiBuff',
                            BuffType = 'CrateEngiBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                BuildRate = {
                                    Add = 0,
                                    Mult = 2,
                                },
                            },
                        }
                        BuffBlueprint {
                            Name = 'CrayCrateEngiBuff',
                            DisplayName = 'CrayCrateEngiBuff',
                            BuffType = 'CrayCrateEngiBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                BuildRate = {
                                    Add = 0,
                                    Mult = 20,
                                },
                            },
                        }
                    end
                    if math.random(1,100) == 100 then
                        LOG("JACKPOT")
                        Buff.ApplyBuff(Unit, 'CrayCrateEngiBuff')
                        PhatLewt(Unit, pos,'HAT_Crown')--Bonus jackpot hat
                    else
                        Buff.ApplyBuff(Unit, 'CrateEngiBuff')
                    end
                    notificationPingis(pos, Unit:GetArmy(), 'Engineering', '<LOC ability_engineeringsuite>Engineering Suite' )
                else
                    WARN("Unit rolled for engineering buffs, but can't engineering. Rolling again.")
                    PhatLewt(Unit, pos)
                end
            end,
            --------------------------------------------------------------------
            --Veterancy
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Kills")
                if Unit.SetVeterancy and Unit.GetVeteranLevel then
                    local vet = Unit:GetVeteranLevel() or 0
                    Unit:SetVeterancy(Random(vet+1, vet > 5 and vet+3 or 5) )
                    notificationPingis(pos, Unit:GetArmy(), 'Veterancy', '<LOC SCORE_0017>Kills' )
                else
                    WARN("Unit lacks SetVeterancy or GetVeteranLevel functions to give it kills. Rerolling.")
                    PhatLewt(Unit, pos)
                end
            end,
            --------------------------------------------------------------------
        },
        -- Hats
        {
            --------------------------------------------------------------------
            --------------------------------------------------------------------
            function(Unit, pos, noRerollFail)
                LOG("Hat")

                local function GetRandomHat()
                    local hat = import('/lua/sim/Entity.lua').Entity()
                    local hatTypes = {
                        'HAT_Crown',
                        'HAT_Tophat',
                        'HAT_Tophat_whiteband',
                        'HAT_Bowler_red',
                        'HAT_Boater',
                        'HAT_Cone_azn',
                        'HAT_Fedora',
                        'HAT_Fedora_Inquisitor',
                        'HAT_Derby',
                        'HAT_Pith_FR',
                        'HAT_Pith_VI',
                        'HAT_Brodie',
                        'HAT_Santa',
                    }
                    local hatType
                    if table.find(hatTypes, noRerollFail) and noRerollFail ~= 'Hat' then
                        hatType = hatTypes[table.find(hatTypes, noRerollFail)]
                    else
                        -- If it's Christmas, 69.44% chance of it being a santa hat unless they already have one, then it's 8.33%
                        -- If it's not Christmas, it's outside of the range.
                        hatType = IsChristmas and Random(1,3) ~= 3 and not Unit.SantaHat and 'HAT_Santa'
                        or hatTypes[math.random(2, table.getn(hatTypes) - (IsChristmas and 0 or -1) )]
                        Unit.SantaHat = Unit.SantaHat or hatType == 'HAT_Santa' or nil
                    end
                    Warp(hat,Unit:GetPosition() )
                    hat:SetMesh(CreateDropPath .. '/effects/entities/' .. hatType .. '/' .. hatType ..'_mesh')
                    return hat
                end

                local bones = {
                    'HatPoint',
                    'Hat',
                    'Head',
                    'Attachpoint',
                    'AttachPoint',
                }
                local attachHatTo = false

                if not Unit.Hats then
                    for i, bone in bones do
                        if Unit:IsValidBone(bone) then
                            attachHatTo = bone
                            break
                        end
                    end
                end
                if attachHatTo or Unit.Hats then
                    if not Unit.Hats then Unit.Hats = {} end

                    local hat = GetRandomHat()
                    table.insert(Unit.Hats, hat)

                    hat:SetDrawScale(
                        RandomFloat(0.925, 1.075) *
                        (
                            EntityCategoryContains(categories.EXPERIMENTAL , Unit) and 0.07 or
                            EntityCategoryContains(categories.STRUCTURE , Unit) and 0.055 or
                            0.03
                        )
                    )

                    hat:SetVizToAllies('Intel')
                    hat:SetVizToNeutrals('Intel')
                    hat:SetVizToEnemies('Intel')
                    if table.getn(Unit.Hats) == 1 then
                        hat:AttachTo(Unit, attachHatTo)
                    else
                        local no = table.getn(Unit.Hats) - 1
                        hat:AttachTo(Unit.Hats[no], 'Attachpoint')
                    end
                    Unit.Trash:Add(hat)
                    notificationPingis(pos, Unit:GetArmy(), 'Hat' )
                else
                    if HatsOnlyMode == 'true' or noRerollFail then
                        WARN("Unit with no noticable head attempted to pick up hats only crate.")
                    else
                        WARN("Unit has no noticable head or attachpoint to wear a hat.")
                        PhatLewt(Unit, pos)
                    end
                end
            end,
            --------------------------------------------------------------------
        },
        -- Bad stuff table
        {
            --------------------------------------------------------------------
            --Troll log
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("YOU GET NOTHING. YOU LOSE. GOOD DAY.")
                notificationPingis(pos, Unit:GetArmy(), 'Nothing', '<LOC SCORE_0039>Failed' )
            end,
            --------------------------------------------------------------------
            --Troll print
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Cheating message") print(Unit:GetAIBrain().Nickname .. " " .. LOC("<LOC cheating_fragment_0000>is") .. LOC("<LOC cheating_fragment_0002> cheating!")  )
                notificationPingis(pos, Unit:GetArmy(), 'Bad', '<LOC SCORE_0039>Failed' )
            end,
            --------------------------------------------------------------------
            --Troll bomb
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Explosion")
                if __blueprints.xrl0302 then
                    CreateUnitHPR('xrl0302', Unit:GetArmy(), pos[1], pos[2], pos[3], 0, math.random(0,360), 0):GetWeaponByLabel('Suicide'):FireWeapon()
                else
                    WARN("Can't spawn XRL0302 to create an explosion, because it doesn't seem to exist.")
                    PhatLewt(Unit, pos)
                end
                notificationPingis(pos, Unit:GetArmy(), 'Bad', '<LOC ability_suicideweapon>Suicide Weapon' )
            end,
            --------------------------------------------------------------------
            --Nemesis dupe
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Evil Twin")
                local clone = CreateUnitHPR(Unit.BpId or Unit:GetBlueprint().BlueprintId, randomEnemyBrain(Unit):GetArmyIndex(), pos[1], pos[2], pos[3], 0, math.random(0,360), 0)
                for kbuff, vbuff in Unit.Buffs.BuffTable do
                    for k, v in vbuff do
                        Buff.ApplyBuff(clone, v.BuffName)
                    end
                end
                clone:SetHealth(Unit, Unit:GetHealth() )
                if clone:GetBlueprint().Description then
                    notificationPingis(pos, Unit:GetArmy(), 'EvilClone', '<LOC lobui_0293>Enemy' .. ' ' .. clone:GetBlueprint().Description )
                else
                    notificationPingis(pos, Unit:GetArmy(), 'EvilClone', '<LOC lobui_0293>Enemy' )
                end
            end,
            --------------------------------------------------------------------
            --Random nemesis
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Random Nemesis")
                local clone = CreateUnitHPR(randomBuildable(gatedRandomBuildableType(Unit)), randomEnemyBrain(Unit):GetArmyIndex(), pos[1], pos[2], pos[3], 0, math.random(0,360), 0)
                if clone:GetBlueprint().Description then
                    notificationPingis(pos, Unit:GetArmy(), 'EvilDude', '<LOC lobui_0293>Enemy' .. ' ' .. clone:GetBlueprint().Description )
                else
                    notificationPingis(pos, Unit:GetArmy(), 'EvilDude', '<LOC lobui_0293>Enemy' )
                end
            end,
            --------------------------------------------------------------------
            --Random warping
            --------------------------------------------------------------------
            function(Unit, pos)
                LOG("Teleport")
                Warp(Unit,getSafePos(Unit:GetPosition()))
                notificationPingis(pos, Unit:GetArmy(), 'Bad', '<LOC tooltipui0024>Teleport' )
            end,
            --------------------------------------------------------------------
        },
        --{
        --    function(Unit, pos) LOG(repr(Unit) ) end,
        --},
    }
    ----------------------------------------------------------------------------
    -- Main lewt picker
    ----------------------------------------------------------------------------
    function PhatLewt(triggerUnit, pos, note)
        if string.lower(string.sub(note or "NOPE",1,3)) == 'hat' or HatsOnlyMode == 'true' then
            lewt[3][1](triggerUnit, pos, note or true)
        else
            local a = math.random(1, table.getn(lewt) )
            local b = math.random(1, table.getn(lewt[a]) )
            lewt[a][b](triggerUnit, pos)
        end
    end
    ----------------------------------------------------------------------------
    -- Utilities
    ----------------------------------------------------------------------------
    function TopLevelParent(Unit)
        if Unit.Parent then
            return TopLevelParent(Unit.Parent)
        else
            return Unit
        end
    end

    function arbitraryBrain()
        for i, brain in ArmyBrains do
            if not brain:IsDefeated() and not ArmyIsCivilian(brain:GetArmyIndex()) then
                --LOG(brain.Nickname)
                return brain
            end
        end
    end

    function notificationPingis(pos, army, ping, text)
        if type(pos) ~= 'table' or type(pos[1]) ~= 'number' then
            return
        end
        --Make sure we have a real ping name
        local pings = {
            'Nothing',
            'Bad',
            'Clone',
            'Dude',
            'Energy',
            'EngineerDude',
            'Engineering',
            'EvilClone',
            'EvilDude',
            'Good',
            'Hat',
            'Health',
            'Intel',
            'Mass',
            'Speed',
            'Veterancy',
            'Weapon',
        }
        --LOG(table.find(pings, ping))
        if type(ping) == 'string' and not table.find(pings, ping) or type(ping) ~= 'string' then
            ping = pings[1]
        end
        CreateUnitHPR(
            --Tests indicate we can't have sliders or animations on props, so they are staying units.
            --CreateDropPath .. '/effects/entities/PING_' .. ping .. '/PING_' .. ping .. '_prop.bp',
            'ping_' .. ping,
            army,
            pos[1], pos[2], pos[3],
            0, 0, 0
        )
        if text and false then --Currently disabled
            FloatingEntityText(Unit.Sync.id, text)
        end
    end

    function randomEnemyBrain(unit)
        local enemies = {}

        for i, brain in ArmyBrains do
            if not IsAlly(brain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) and not brain:IsDefeated() then
                table.insert(enemies, brain)
            end
        end
        if not enemies[1] then
            return unit:GetAIBrain()
        else
            return enemies[math.random(1, table.getn(enemies) )]
        end
    end

    function getSafePos(start, tries)
        if not tries then tries = 1 end
        local pos = {math.random(0+10,ScenarioInfo.size[1]-10), math.random(0+10,ScenarioInfo.size[2]-10)}
        local positionDummy = 'zzcrate' --need a big building that has no intel, doesn't flatten ground, and doesn't really care for evalation.
        positionDummy = arbitraryBrain():CreateUnitNearSpot(positionDummy, pos[1], pos[2])
        if positionDummy and IsUnit(positionDummy) then
            local pos = positionDummy:GetPosition()
            positionDummy:Destroy()
            LOG("Safe teleport location choice attempts " .. tries .. ". Lotation across: " .. pos[1] .. ", down: " .. pos[3] .. "." )
            return pos
        else
            if tries < 1000 then
                return getSafePos(start, tries + 1)
            else
                return start
            end
        end
    end

    function randomBuildable(thing)
        local buildable = 'RandomBuildable' .. tostring(thing)
        if not __blueprints.zzcrate[buildable] then
            if not __blueprints.zzcrate.RandomBuildableUnits then
                error("Random loot table refered to a random unit table that doesn't exist, and the default table also doesn't exist.")
            else
                WARN("Random loot table refered to a random unit table that doesn't exist. Returning value from all units table instead.")
                return __blueprints.zzcrate.RandomBuildableUnits[math.random(1,table.getn(__blueprints.zzcrate.RandomBuildableUnits) )]
            end
        else
            return __blueprints.zzcrate[buildable][math.random(1,table.getn(__blueprints.zzcrate[buildable]) )]
        end
    end

    function gatedRandomBuildableType(Unit)
        local unitTypes = {'UnitsT1','UnitsT2orLess','UnitsT3orLess','Units',}
        local chosen
        if EntityCategoryContains(categories.EXPERIMENTAL + categories.TECH3, Unit) then
            LOG("ANYTHING GOES")
            chosen = unitTypes[math.random(1, 4)]
        elseif EntityCategoryContains(categories.TECH2, Unit) then
            LOG("Tech 3 or less")
            chosen = unitTypes[math.random(1, 3)]
        elseif EntityCategoryContains(categories.TECH1, Unit) then
            LOG("Tech 2 or less")
            chosen = unitTypes[1]
        elseif EntityCategoryContains(categories.COMMAND, Unit) then
            LOG("Tech 3 or less")
            chosen = unitTypes[math.random(1, 3)]
        else
            LOG("ANYTHING GOES BITCHES")
            chosen = unitTypes[math.random(1, table.getn(unitTypes))]
        end
        return chosen
    end
end
