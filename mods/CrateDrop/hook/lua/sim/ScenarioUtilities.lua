--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        if not ScenarioInfo.DodecahedronCrateThread then
            ScenarioInfo.DodecahedronCrateThread = ForkThread(
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
                        WaitTicks(100)
                        
                        local search = arbitraryBrain():GetUnitsAroundPoint( categories.ALLUNITS, crate:GetPosition(), 5)
                        if search[1] and IsUnit(search[1]) then
                            PhatLewt(search[1])
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
        local positionDummy = 'ueb0101' --need a big building that has no intel, doesn't flatten ground, and doesn't really care for evalation.      
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
       
    local lewt = {
        {
            function(Unit) Unit:GetAIBrain():GiveResource('Mass', 5000) end,
            function(Unit) Unit:SetMaxHealth(Unit:GetMaxHealth() * 2) Unit:SetHealth(Unit, Unit:GetMaxHealth()) end,
            function(Unit)
                local clone = CreateUnitHPR(Unit:GetBlueprint().BlueprintId, Unit:GetArmy(), Unit:GetPosition()[1] + math.random(-2, 2), Unit:GetPosition()[2], Unit:GetPosition()[3] + math.random(-2, 2), 0, math.random(0,360), 0)
                clone:SetMaxHealth(Unit:GetMaxHealth() )
                clone:SetHealth(Unit, Unit:GetHealth() )
            end,
            --function(Unit) CreateUnitHPR(__blueprints[math.random(1, table.getn(__blueprints) )], Unit:GetArmy(), Unit:GetPosition()[1] + math.random(-2, 2), Unit:GetPosition()[2], Unit:GetPosition()[3] + math.random(-2, 2), 0, math.random(0,360), 0) end,
        },
        --{
        --    function(Unit) LOG("YOU GET NOTHING. GOOD DAY.") end,
        --},
    }
    
    function PhatLewt(triggerUnit)
        local a = math.random(1, table.getn(lewt) )
        local b = math.random(1, table.getn(lewt[a]) )
        
        lewt[a][b](triggerUnit)
    end
end