local oldAIBrain = AIBrain

AIBrain = Class(oldAIBrain) {
    OnCreateAI = function(self, planName)
        oldAIBrain.OnCreateAI(self, planName)
        --this is Line 4947   --sub 4941
        local opt = ScenarioInfo.Options.CityscapesSpawn or 'EmptySpots' -- default if option isn't defined

        if opt ~= 'false' then
            local civilian = false
            for name,data in ScenarioInfo.ArmySetup do
                if name == self.Name then
                    civilian = data.Civilian
                    break
                end
            end
            if not civilian then return
            else
                if not ScenarioInfo.City then
                    ScenarioInfo.City = true
                else
                    return true
                end
            end

            local AIGetMarkerLocations = import('/lua/ai/aiutilities.lua').AIGetMarkerLocations
            local OpenStartZones = {}
            for i, army in AIGetMarkerLocations(nil, 'Start Location') do
                if (not ScenarioInfo.ArmySetup[army.Name] and opt == 'EmptySpots')
                or (ScenarioInfo.ArmySetup[army.Name] and opt == 'OccupiedSlots')
                or opt == 'AllSlots' then
                    OpenStartZones[army.Name] = army.Position
                end
            end
            if table.getsize(OpenStartZones) > 0 then
                for armyname, MarkerPos in OpenStartZones do
                    local CityFunction, CityData = import('/lua/sim/ScenarioUtilities.lua').GetRandomCityFactionGenerator()
                    if CityFunction and CityData then
                        self:ForkThread(CityFunction, CityData, table.copy(MarkerPos))
                    end
                end
            end
        end
    end,
}
