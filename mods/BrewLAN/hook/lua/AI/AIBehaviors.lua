do

CenturionBehaviorBrewLAN = function(self)
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
    
    local targetUnit, targetBase = FindExperimentalTargetSorian(self)
	
    local oldTargetUnit = nil		
    while aiBrain:PlatoonExists(self) do #not experimental:IsDead() do
		self:MergeWithNearbyPlatoonsSorian('ExperimentalAIHubSorian', 50, true)
		
        if (targetUnit and targetUnit != oldTargetUnit) or not self:IsCommandsActive(cmd) then			
			if targetUnit and VDist3( targetUnit:GetPosition(), self:GetPlatoonPosition() ) > 100 then #VDist3( targetUnit:GetPosition(), experimental:GetPosition() ) > 100 then
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
end

end