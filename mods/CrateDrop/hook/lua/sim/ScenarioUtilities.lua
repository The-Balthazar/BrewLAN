--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        if not ScenarioInfo.DodecahedronCrate then     
            ScenarioInfo.DodecahedronCrate = { }
            ScenarioInfo.DodecahedronCrate.Thread = ForkThread(
                function()
                    local crate = import('/lua/sim/Entity.lua').Entity()
                    local crateType = 'CRATE_Dodecahedron'
                    Warp(crate,getSafePos())
                    crate:SetMesh('/mods/cratedrop/effects/entities/' .. crateType .. '/' .. crateType ..'_mesh')
                    crate:SetDrawScale(.08)
                    crate:SetVizToAllies('Intel')
                    crate:SetVizToNeutrals('Intel')
                    crate:SetVizToEnemies('Intel')
                    while true do
                        WaitTicks(2)
                        
                        local search = arbitraryBrain():GetUnitsAroundPoint( categories.ALLUNITS, crate:GetPosition(), 1)
                        if search[1] and IsUnit(search[1]) then
                            PhatLewt(search[1], crate:GetPosition() )
                            Warp(crate,getSafePos())
                        end     
                    end 
                end
            )
        end
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end
    
    function arbitraryBrain()     
        for i, brain in ArmyBrains do
            if not brain:IsDefeated() and not ArmyIsCivilian(brain:GetArmyIndex()) then    
                --LOG(brain.Nickname)
                return brain
            end
        end
    end
    
    function getSafePos(tries) 
        if not tries then tries = 1 end
        local pos = {math.random(0+10,ScenarioInfo.size[1]-10), math.random(0+10,ScenarioInfo.size[2]-10)}
        local positionDummy = 'zzcrate' --need a big building that has no intel, doesn't flatten ground, and doesn't really care for evalation.      
        positionDummy = arbitraryBrain():CreateUnitNearSpot(positionDummy, pos[1], pos[2])
        if positionDummy and IsUnit(positionDummy) then    
            LOG("We tried " .. tries)
            local pos = positionDummy:GetPosition()
            positionDummy:Destroy()
            LOG(repr(pos))
            return pos 
        else   
            --return getSafePos(tries + 1)
            return getSafePos(tries + 1)  
        end
    end
    
    local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker   
    local lewt = {
        {
            --5000 mass
            function(Unit, pos) Unit:GetAIBrain():GiveResource('Mass', 5000) end,
            --Clone at current health
            function(Unit, pos)
                local clone = CreateUnitHPR(Unit:GetBlueprint().BlueprintId, Unit:GetArmy(), pos[1], pos[2], pos[3], 0, math.random(0,360), 0)
                clone:SetMaxHealth(Unit:GetMaxHealth() )
                clone:SetHealth(Unit, Unit:GetHealth() )
            end,
            --Random buildable unit
            function(Unit, pos) CreateUnitHPR(__blueprints.zzcrate.RandomBuildableUnits[math.random(1,table.getn(__blueprints.zzcrate.RandomBuildableUnits) )], Unit:GetArmy(), pos[1], pos[2], pos[3], 0, math.random(0,360), 0) end,
            --Random buildable mobile engineer
            function(Unit, pos) CreateUnitHPR(__blueprints.zzcrate.RandomBuildableEngineers[math.random(1,table.getn(__blueprints.zzcrate.RandomBuildableEngineers) )], Unit:GetArmy(), pos[1], pos[2], pos[3], 0, math.random(0,360), 0) end,
        },
        {
            --Double health and heal
            function(Unit, pos) Unit:SetMaxHealth(Unit:GetMaxHealth() * 2) Unit:SetHealth(Unit, Unit:GetMaxHealth()) end,
            --Give Omni doesn't seem to work at the moment
            --[[function(Unit, pos)
                if not Unit.OmniBuff then
                    local spec = {
                        X = pos[1],
                        Z = pos[3],
                        Radius = (Unit:GetIntelRadius('Omni') or 20) + 20,
                        LifeTime = -1,
                        Omni = true,
                        Radar = false,
                        Vision = false,
                        Army = Unit:GetAIBrain():GetArmyIndex(),
                    }
                    Unit.OmniBuff = VizMarker(spec) 
                    Unit.OmniBuff:AttachTo(Unit, -1)
                    Unit.Trash:Add(Unit.OmniBuff)
                else
                    Unit.OmniBuff:SetIntelRadius('Omni', Unit.OmniBuff:GetIntelRadius('Omni') + 20)
                    LOG("Omni + 20")
                end
            end,]]--
            --Give larger vis range
            function(Unit, pos)
                if not Unit.VisBuff then
                    local spec = {
                        X = pos[1],
                        Z = pos[3],
                        Radius = (Unit:GetIntelRadius('Vision') or 20) + 20,
                        LifeTime = -1,
                        Omni = false,
                        Radar = false,
                        Vision = true,
                        Army = Unit:GetAIBrain():GetArmyIndex(),
                    }
                    Unit.VisBuff = VizMarker(spec) 
                    Unit.VisBuff:AttachTo(Unit, -1)
                    Unit.Trash:Add(Unit.VisBuff)
                else
                    Unit.VisBuff:SetIntelRadius('Vision', Unit.VisBuff:GetIntelRadius('Vision') + 20)
                    LOG("Vis + 20")
                end
            end,
            -- Hat
            function(Unit, pos)
                local hatTypes = {
                    'HAT_Tophat',
                    'HAT_Tophat_whiteband',
                }
                
                if Unit:IsValidBone('Attachpoint') or Unit:IsValidBone('Head') or Unit:IsValidBone('AttachPoint') then
                    Unit.Hat = import('/lua/sim/Entity.lua').Entity()
                    local hatType = hatTypes[math.random(1, table.getn(hatTypes) )]
                    Warp(Unit.Hat,Unit:GetPosition() )
                    Unit.Hat:SetMesh('/mods/cratedrop/effects/entities/' .. hatType .. '/' .. hatType ..'_mesh')
                    Unit.Hat:SetDrawScale(.03)
                    Unit.Hat:SetVizToAllies('Intel')
                    Unit.Hat:SetVizToNeutrals('Intel')
                    Unit.Hat:SetVizToEnemies('Intel')
                    if Unit:IsValidBone('Head') then
                        Unit.Hat:AttachTo(Unit, 'Head')
                    elseif Unit:IsValidBone('Attachpoint') then
                        Unit.Hat:AttachTo(Unit, 'Attachpoint')
                    elseif Unit:IsValidBone('AttachPoint') then
                        Unit.Hat:AttachTo(Unit, 'AttachPoint')
                    end
                else
                    LOG("We can't find anywhere to attach the hat to.")
                end
            end,
        },
        {         
            --Troll log
            function(Unit, pos) LOG("YOU GET NOTHING. YOU LOSE. GOOD DAY.") end,
            --Troll print
            function(Unit, pos) print(Unit:GetAIBrain().Nickname .. " " .. LOC("<LOC cheating_fragment_0000>is") .. LOC("<LOC cheating_fragment_0002> cheating!")  ) end,
            --Troll bomb
            function(Unit, pos) CreateUnitHPR('xrl0302', Unit:GetArmy(), pos[1], pos[2], pos[3], 0, math.random(0,360), 0):GetWeaponByLabel('Suicide'):FireWeapon() end,
            --Nemesis dupe
            
            --random nemesis
        },
    }
    
    function PhatLewt(triggerUnit, pos)
        local a = math.random(1, table.getn(lewt) )
        local b = math.random(1, table.getn(lewt[a]) )
        --lewt[2][3](triggerUnit, pos) --HATS ONLY
        lewt[a][b](triggerUnit, pos)
    end
end