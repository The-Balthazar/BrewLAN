--------------------------------------------------------------------------------
-- Hook File: /lua/AI/AIBehaviours.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do
--------------------------------------------------------------------------------
-- UEF Experimental AA Gunship: Centurion script
--------------------------------------------------------------------------------
CenturionBehaviorBrewLAN = function(self)
    --remove 2888 from any log reference error line number
    local aiBrain = self:GetBrain()
    local platoonUnits = self:GetPlatoonUnits()
    local cmd
    if not aiBrain:PlatoonExists(self) then #not experimental then
        return
    end
    if not self:GatherUnitsSorian() then
        return
    end
    
    AssignExperimentalPrioritiesSorian(self)
    
    self:MergeWithNearbyPlatoonsSorian('ExperimentalAIHubSorian', 50, true)
    
    local targetUnit, targetBase = FindExperimentalTargetSorian(self)
    local centerOfMap = {ScenarioInfo.size[1]/2, 0, ScenarioInfo.size[2]/2}
    local crystal = {}
    if categories.zpc0001 then
        crystal = aiBrain:GetUnitsAroundPoint( categories.zpc0001 + categories.zpc0002, centerOfMap, 20)
    else
        crystal[1] = false
    end
    while aiBrain:PlatoonExists(self) do  
        if crystal[1] then
            crystal = aiBrain:GetUnitsAroundPoint( categories.zpc0001 + categories.zpc0002, centerOfMap, 20)
            while EntityCategoryContains(categories.zpc0002, crystal[1]) or not (IsAlly(aiBrain:GetArmyIndex(),crystal[1]:GetArmy() ) or true) do
                if VDist3(self:GetPlatoonPosition(), crystal[1]:GetPosition() ) > 40 then
                    LOG("THA CRYSTAL!")
                    IssueClearCommands(platoonUnits)
                    cmd = self:MoveToLocation(crystal[1]:GetPosition(), false)
                elseif VDist3(self:GetPlatoonPosition(), crystal[1]:GetPosition() ) < 40 and not self:IsCommandsActive(cmd) then
                    LOG("THA CRYSTAL!!")
                    IssueClearCommands(platoonUnits)
                    cmd = self:AggressiveMoveToLocation(crystal[1]:GetPosition() )
                end
                WaitSeconds(3)     
            end
        end
        local Paragons = aiBrain:GetUnitsAroundPoint(categories.EXPERIMENTAL * categories.ECONOMIC * categories.MASSPRODUCTION, self:GetPlatoonPosition(), 8000, 'Enemy' )
        local oldTargetUnit = nil		
        local TargetParagon = nil
        
        if Paragons[1] then--and not self:IsCommandsActive(cmd) then
            TargetParagon = ParagonAttackPicker(Paragons, platoonUnits)
        end
        if TargetParagon then
            if IsUnit(TargetParagon) and not TargetParagon:IsDead() then
                if GetClosestShieldProtectingTargetSorian(platoonUnits[1], TargetParagon) then 
                    for k, Pancake in platoonUnits do   
                        local AINames = import('/lua/AI/sorianlang.lua').AINames
                        LOG("THIS PARAGON HAS SHIELDS")
                        while not TargetParagon:IsDead() do
                            local distance = Utilities.XZDistanceTwoVectors(Pancake:GetPosition(), TargetParagon:GetPosition())
                            local hightdist = Pancake:GetPosition()[2] - TargetParagon:GetPosition()[2]   
                            
                            local SpeedBalanceMult = Pancake:GetBlueprint().Air.MaxAirspeed / 12
                            
                            if not Pancake.customname then    
                                Pancake.customname = true     
                                self:ForkThread(
                                    function()    
                                        WaitTicks(50)                
                                        if not Pancake:IsDead() then
                                            local num = Random(1, table.getn(AINames.sea0401pancake))
                                            Pancake:SetCustomName(AINames.sea0401pancake[num])
                                        end                                    
                                    end
                                )     
                            end      
                            if distance < hightdist * 1.66 * SpeedBalanceMult and distance > hightdist * 1.5 * SpeedBalanceMult and distance > 13 and not TargetParagon.KillAttempts.Pancake then   
                                if not TargetParagon.KillAttempts then TargetParagon.KillAttempts = {} end
                                TargetParagon.KillAttempts.Pancake = true   
                                Pancake:Kill()
                            elseif distance < 13 then
                                Pancake:SetSpeedMult(distance/20)
                                if distance < .5 and not Pancake.Killthread then
                                    Pancake.Killthread = true
                                    self:ForkThread(
                                        function()         
                                            WaitTicks(25)
                                            Pancake:Kill()
                                        end
                                    )
                                end
                            end    
                            IssueMove({Pancake}, TargetParagon:GetPosition())
                            WaitTicks(5)  
                            IssueClearCommands({Pancake})
                            ParagonAttackersAddTableCheck(TargetParagon, Pancake)
                        end   
                    end 
                else    
                    LOG("THIS PARAGON HAS NO SHIELDS")
                    IssueClearCommands(platoonUnits)
                    targetUnit = TargetParagon
                    cmd = self:AttackTarget(targetUnit)
                    for k, Pancake in platoonUnits do
                        ParagonAttackersAddTableCheck(TargetParagon, Pancake)
                    end
                end
            end
        else
            --This is the default behaviour for the CZAR. Might need some reworking for the Centurion 
            
            if (targetUnit and targetUnit != oldTargetUnit) or not self:IsCommandsActive(cmd) then			
                if targetUnit and VDist3( targetUnit:GetPosition(), self:GetPlatoonPosition() ) > 100 then
                    IssueClearCommands(platoonUnits)
                    WaitTicks(5)
                    cmd = ExpPathToLocation(aiBrain, self, 'Air', targetUnit:GetPosition(), false, 62500)
                    cmd = self:AttackTarget(targetUnit)
                else 
                    IssueClearCommands(platoonUnits)
                    WaitTicks(5)
                    cmd = self:AttackTarget(targetUnit) #IssueAttack(platoonUnits, targetUnit)
                end
            end
            
            local nearCommander = CommanderOverrideCheckSorian(self)
            local oldCommander = nil
            while nearCommander and aiBrain:PlatoonExists(self) and self:IsCommandsActive(cmd) do
                if nearCommander and nearCommander != oldCommander then
                    IssueClearCommands(platoonUnits)
                    WaitTicks(5)
                    cmd = self:AttackTarget(nearCommander)
                    targetUnit = nearCommander
                end
                
                WaitSeconds(1)
                oldCommander = nearCommander
                nearCommander = CommanderOverrideCheckSorian(self)
            end
            
            WaitSeconds(1)
            oldTargetUnit = targetUnit
            targetUnit, targetBase = FindExperimentalTarget(self)
        end
        WaitSeconds(1)
    end
end
--------------------------------------------------------------------------------
-- Paragon attackers table check for Centurion
--------------------------------------------------------------------------------
function ParagonAttackersAddTableCheck(TargetParagon, Pancake)
    local alreadyontable = false
    if TargetParagon.KillAttempts.Attackers then
        for k, Attacker in TargetParagon.KillAttempts.Attackers do
            if Attacker == Pancake then
                alreadyontable = true
                break
            end
        end 
    else
        if not TargetParagon.KillAttempts then TargetParagon.KillAttempts = {} end
        TargetParagon.KillAttempts.Attackers = {}
    end
    if not alreadyontable then
        table.insert(TargetParagon.KillAttempts.Attackers, Pancake )
    end
end 
--------------------------------------------------------------------------------
-- Paragon dangerous attack target check
-- Returns Paragon, or nil if too dangerous
--------------------------------------------------------------------------------
function ParagonAttackPicker(Paragons, platoonUnits)
    for i, Paragon in Paragons do   
        local deathcount = 0
        if Paragon.KillAttempts.Attackers then
            for i, Attacker in Paragon.KillAttempts.Attackers do
                if Attacker:IsDead() then
                    deathcount = deathcount + 1
                end
            end
        end
        if (deathcount < table.getn(platoonUnits) and Paragon:GetFractionComplete() > .9) or deathcount < Paragon:GetFractionComplete() * 2 then
            return Paragon
        end
    end
    return nil
end
--------------------------------------------------------------------------------
-- Sorian shield protecting target check.
-- Overwritten to allow for accurate checks with the 80 range Iron Curtain.
--------------------------------------------------------------------------------
function GetClosestShieldProtectingTargetSorian(attackingUnit, targetUnit)
    local aiBrain = attackingUnit:GetAIBrain()
	if not targetUnit or not attackingUnit then
		return false
	end
    local tPos = targetUnit:GetPosition()
    local aPos = attackingUnit:GetPosition()
    
    local blockingList = {}
    
    --If targetUnit is within the radius of any shields, the shields need to be destroyed.
    local shields = aiBrain:GetUnitsAroundPoint( categories.SHIELD * categories.STRUCTURE, targetUnit:GetPosition(), 80, 'Enemy' )
    for _,shield in shields do
        if not shield:IsDead() then
            local shieldPos = shield:GetPosition()
            local shieldSizeSq = GetShieldRadiusAboveGroundSquared(shield)
            
            if VDist2Sq(tPos[1], tPos[3], shieldPos[1], shieldPos[3]) < shieldSizeSq then
                table.insert(blockingList, shield)
            end
        end
    end

    --return the closest blocking shield
    local closest = false
    local closestDistSq = 999999
    for _,shield in blockingList do
        local shieldPos = shield:GetPosition()
        local distSq = VDist2Sq(aPos[1], aPos[3], shieldPos[1], shieldPos[3])
        
        if distSq < closestDistSq then
            closest = shield
            closestDistSq = distSq
        end
    end
    
    return closest
end

end