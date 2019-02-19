--------------------------------------------------------------------------------
--  Summary:  Initial Crystal Spawner, and AI interest in said Crystal
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
AIBrain = Class(AIBrain) {
    SpawnCrystal = function(self)
        --Define default positions
        local posX = ScenarioInfo.size[1]/2
        local posY = 0
        local posZ = ScenarioInfo.size[2]/2
        --Look for some pre-defined positions
        local predefinedpos = false
        local objectivemarkers = import('/lua/ai/AIUtilities.lua').AIGetMarkersAroundLocation( self, 'Objective', {posX, posY, posZ}, ScenarioInfo.size[1] * 0.7071 )
        if objectivemarkers[1] then
            posX = objectivemarkers[1].Position[1]
            posZ = objectivemarkers[1].Position[3]
            predefinedpos = true
            LOG("Using map-defined crystal location.")
        end
        --Set up to spawn the thing
        self:ForkThread(function()
            --Wait a second so starting units are there.
            WaitTicks(1)
            --If we don't have a pre-defined position, then steal the pos of a civilian structure near where we want, if available
            if not predefinedpos then
                local civs = self:GetUnitsAroundPoint(categories.STRUCTURE, Vector(posX, 0, posZ), 5)
                if civs[1] then
                    for i, v in civs do
                        --LOG(v:GetAIBrain().Nickname)
                        if v:GetAIBrain().Nickname == "civilian" then
                            if i == 1 then
                                posX, posY, posZ = unpack(v:GetPosition())
                                LOG("Using central positioned civilian building as crystal location.")
                            end
                            v:Destroy()
                        end
                    end
                end
            end
            --Where ever we decided, spawn it there.
            local HillUnit = CreateUnitHPR('ZPC0002', self:GetArmyIndex(), posX, posY, posZ, 0, 0, 0)
            HillUnit:CreateTarmac(true,true,true,false,false)
            --If we didn't have a pre-defined thing, assume there are no markers for this and make a bunch.
            if not predefinedpos then
                local pos = HillUnit:GetPosition()
                for i, v in {'Objective', 'Combat Zone', 'Defensive Point', 'Expansion Area'} do
                    ScenarioInfo.Env.Scenario.MasterChain._MASTERCHAIN_.Markers[v .. ' Crystal Hill'] = {
                        --[[color = 'ff800000',
                        hint = true,
                        prop = '/env/common/props/markers/M_CombatZone_prop.bp',
                        orientation = {0, 0, 0},]]
                        type = v,
                        position = pos,
                    }
                end
            end
        end)
        --self.PreBuilt = true
    end,
}
end
