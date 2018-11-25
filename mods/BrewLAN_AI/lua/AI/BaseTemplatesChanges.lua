function ChangeBaseTemplate(group)
    local BaseTemplates = {
        All = {
            --[[Builders = {},
            NonCheatBuilders = {},
            BaseSettings = {
                EngineerCount = {
                    Tech1 = 0,
                    Tech2 = 0,
                    Tech3 = 0,
                    SCU = 0,
                },
                FactoryCount = {
                    Land = 0,
                    Air = 0,
                    Sea = 0,
                    Gate = 0,
                    Gantry = 3,
                },
            },]]
        },
        AllSorian = {
            Builders = {
                'SorianT1Shields',
                'BrewLANShieldUpgrades',
                'SorianCybranT4Shields',
                'SorianGantryConstruction',
                'SorianGantrySupport',
            },
        },
        AllVanilla = {
            Builders = {
                'GantryConstruction',
            },
        },
        ChallengeExpansion = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 1}}},
        ChallengeMain = {
            Builders = {
                'GantrySupport',
                'T1ShieldsBuilder',
                'BrewLANShieldUpgrades',
                'CybranT4Shields',
            },
            NonCheatBuilders = {
                'UEFOpticsEngineerBuilders',
                'SeraphimOpticsEngineerBuilders',
            },
            BaseSettings = {FactoryCount = {Gantry = 2}}
        },
        ChallengeNaval = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 1}}},
        NavalExpansionLarge = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 4}}},
        NavalExpansionSmall = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 2}}},
        NormalMain = {BaseSettings = {FactoryCount = {Gantry = 1}}},
        NormalNaval = {BaseSettings = {FactoryCount = {Gantry = 1}}},
        RushExpansionAirFull = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 2}}},
        RushExpansionAirSmall = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 3}}},
        RushExpansionBalancedFull = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 2}}},
        RushExpansionBalancedSmall = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 1}}},
        RushExpansionLandFull = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 1}}},
        RushExpansionLandSmall = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 0}}},
        RushExpansionNaval = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 0}}},
        RushMainAir = {
            Builders = {
                'GantrySupport',
                'T1ShieldsBuilder',
                'BrewLANShieldUpgrades',
                'CybranT4Shields',
            },
            NonCheatBuilders = {
                'UEFOpticsEngineerBuilders',
                'SeraphimOpticsEngineerBuilders',
            },
            BaseSettings = {FactoryCount = {Gantry = 5}}
        },
        RushMainBalanced = {
            Builders = {
                'GantrySupport',
                'T1ShieldsBuilder',
                'BrewLANShieldUpgrades',
                'CybranT4Shields',
            },
            NonCheatBuilders = {
                'UEFOpticsEngineerBuilders',
                'SeraphimOpticsEngineerBuilders',
            },
            BaseSettings = {FactoryCount = {Gantry = 4}}
        },
        RushMainLand = {
            Builders = {
                'GantrySupport',
                'T1ShieldsBuilder',
                'BrewLANShieldUpgrades',
                'CybranT4Shields',
            },
            NonCheatBuilders = {
                'UEFOpticsEngineerBuilders',
                'SeraphimOpticsEngineerBuilders',
            },
            BaseSettings = {FactoryCount = {Gantry = 3}}
        },
        RushMainNaval = {
            Builders = {
                'GantrySupport',
                'T1ShieldsBuilder',
                'BrewLANShieldUpgrades',
                'CybranT4Shields',
            },
            NonCheatBuilders = {
                'UEFOpticsEngineerBuilders',
                'SeraphimOpticsEngineerBuilders',
            },
            BaseSettings = {FactoryCount = {Gantry = 2}}
        },
        SorianExpansionAirFull = {BaseSettings = {FactoryCount = {Gantry = 2}}},
        SorianExpansionBalancedFull = {BaseSettings = {FactoryCount = {Gantry = 2}}},
        SorianExpansionBalancedSmall = {BaseSettings = {FactoryCount = {Gantry = 1}}},
        SorianExpansionTurtleFull = {BaseSettings = {FactoryCount = {Gantry = 1}}},
        SorianExpansionWaterFull = {BaseSettings = {FactoryCount = {Gantry = 3}}},
        SorianMainAir = {BaseSettings = {FactoryCount = {Gantry = 5}}},
        SorianMainBalanced = {BaseSettings = {FactoryCount = {Gantry = 5}}},
        SorianMainRush = {BaseSettings = {FactoryCount = {Gantry = 4}}},
        SorianMainTurtle = {BaseSettings = {FactoryCount = {Gantry = 2}}},
        SorianMainWater = {BaseSettings = {FactoryCount = {Gantry = 4}}},
        SorianNavalExpansionLarge = {BaseSettings = {FactoryCount = {Gantry = 3}}},
        SorianNavalExpansionSmall = {BaseSettings = {FactoryCount = {Gantry = 2}}},
        TechExpansion = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 3}}},
        TechExpansionSmall = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 2}}},
        TechMain = {
            Builders = {
                'GantrySupport',
                'T1ShieldsBuilder',
                'BrewLANShieldUpgrades',
                'CybranT4Shields',
            },
            NonCheatBuilders = {
                'UEFOpticsEngineerBuilders',
                'SeraphimOpticsEngineerBuilders',
            },
            BaseSettings = {FactoryCount = {Gantry = 3}}
        },
        TurtleExpansion = {Builders = {'GantrySupport'}, BaseSettings = {FactoryCount = {Gantry = 1}}},
        TurtleMain = {
            Builders = {
                'GantrySupport',
                'T1ShieldsBuilder',
                'BrewLANShieldUpgrades',
                'CybranT4Shields',
            },
            NonCheatBuilders = {
                'UEFOpticsEngineerBuilders',
                'SeraphimOpticsEngineerBuilders',
            },
            BaseSettings = {FactoryCount = {Gantry = 1}}
        },
        --FAF specific things:
        SetonsCustom = {
            Builders = {
                'GantrySupport',
                'T1ShieldsBuilder',
                'BrewLANShieldUpgrades',
                'CybranT4Shields',
            },
            BaseSettings = {FactoryCount = {Gantry = 4}}
        },
        TechSmallMap = {
            Builders = {
                'GantrySupport',
                'T1ShieldsBuilder',
                'BrewLANShieldUpgrades',
                'CybranT4Shields',
            },
            BaseSettings = {FactoryCount = {Gantry = 2}}
        },
    }

    for base, data in BaseBuilderTemplates do
        for i, set in {'All', (group or 'AllVanilla'), data.BaseTemplateName} do
            if not BaseTemplates[set] then
                WARN("No BrewLAN mod data for AI base template " .. set)
            end
            if BaseTemplates[set].Builders then
                for i, builder in BaseTemplates[set].Builders do
                    if not table.find(data.Builders, builder) then
                        table.insert(data.Builders, builder)
                    end
                end
            end
            if BaseTemplates[set].NonCheatBuilders then
                for i, builder in BaseTemplates[set].NonCheatBuilders do
                    if not table.find(data.NonCheatBuilders, builder) then
                        table.insert(data.NonCheatBuilders, builder)
                    end
                end
            end
            if BaseTemplates[set].BaseSettings then
                for tablekey, table in BaseTemplates[set].BaseSettings do
                    for k, val in table do
                        data.BaseSettings[tablekey][k] = val
                    end
                end
            end
        end
    end
end
