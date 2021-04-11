local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit

SAB5401 = Class(AStructureUnit) {

    OnTeleportUnit = function(self, teleporter, location, orientation)
        if not self.TeleportThread then
            for i = 1, 3 do
                location[i] = math.floor(location[i] + 0.5) - 0.5
            end
            --Check the target is good for the teleporter before proceding
            if self:WarpTargetCheck(self, self:GetBlueprint(), location, self:GetPosition()) then
                self:RemoveCommandCap('RULEUCC_Teleport')
                self.TeleportThread = self:ForkThread(self.InitiateTeleportThread, location)
            end
        end
    end,

    OnFailedTeleport = function(self)
        if self.TeleportDrain then
            RemoveEconomyEvent( self, self.TeleportDrain)
            self.TeleportDrain = nil
        end
        self:StopUnitAmbientSound('TeleportLoop')
        self:CleanupTeleportChargeEffects()
        if not self.Dead then
            self:ForkThread(self.CooldownThread)
        end
        local AIBrain = self:GetAIBrain()
        local nearby = AIBrain:GetUnitsAroundPoint(categories.SELECTABLE, self:GetPosition(), 20)
        for i, unit in nearby do
            if unit.TeleportTargetPos then
                unit:SetImmobile(false)
                unit.TeleportTargetPos = nil
            end
        end
    end,

    InitiateTeleportThread = function(self, location)
        local oldpos = table.copy(self:GetPosition())

        --Gather info
        local AIBrain = self:GetAIBrain()
        local nearby = AIBrain:GetUnitsAroundPoint(categories.SELECTABLE, oldpos, 20)

        table.sort(nearby,function(a, b)
            local apos = a:GetPosition()
            local bpos = b:GetPosition()
            --This should probably have an extra clause so self is always first, if something else manages to share the exact XZ pos
            return VDist2Sq(oldpos[1], oldpos[3], apos[1], apos[3] ) < VDist2Sq(oldpos[1], oldpos[3], bpos[1], bpos[3] )
        end)

        local energycost = 0
        local timecost = 0

        --Check what can warp
        for i, unit in nearby do
            local unitbp = unit:GetBlueprint()
            --Check this unit
            if self:WarpUnitCheck(unit, unitbp) then
                --calculate target position
                local unitpos = unit:GetPosition()
                local x = location[1] + (unitpos[1] - oldpos[1])
                local z = location[3] + (unitpos[3] - oldpos[3])
                local y = GetTerrainHeight(x, z)
                local target = {x, y, z}

                --check target area
                if self:WarpTargetCheck(unit,  unitbp, target, unitpos, location) then
                    unit.TeleportTargetPos = target
                    unit.TeleportOldPos = table.copy(unit:GetPosition())
                    local cost = (unitbp.Economy.BuildCostMass * (unitbp.Economy.TeleportMassMod or 0.01)) + (unitbp.Economy.BuildCostEnergy * (unitbp.Economy.TeleportEnergyMod or 0.01))
                    energycost = energycost + cost
                    timecost = math.max(timecost, cost * (unitbp.Economy.TeleportTimeMod or 0.01) * 0.1)
                    unit:SetImmobile(true)
                else
                    nearby[i] = false
                end
            end
        end
        self.CooldownTime = timecost
        self.TeleportDrain = CreateEconomyEvent(self, energycost or 100, 0, timecost or 5, self.UpdateTeleportProgress)

        --EFFECTS, TO EDIT
        self:PlayTeleportChargeEffects()
        self:PlayUnitSound('TeleportStart')
        self:PlayUnitAmbientSound('TeleportLoop')

        WaitFor(self.TeleportDrain)

        --MORE EFFECTS, TO EDIT
        self:StopUnitAmbientSound('TeleportLoop')
        self:PlayUnitSound('TeleportEnd')
        self:PlayTeleportOutEffects()
        self:CleanupTeleportChargeEffects()

        for i, unit in nearby do
            if unit and not unit.Dead then
                self:WarpUnit(unit)
            end
        end
        --Adjacency effects can only be done after everything has been teleported
        --Adjacency data is easiest to get as part of the path blocking code, so that is also done now.
        for i, unit in nearby do
            if unit and not unit.Dead then
                self:UpdateAdjacencyPathBlocking(unit, unit:GetBlueprint(), unit.TeleportTargetPos, unit.TeleportOldPos, nearby)
                unit.TeleportTargetPos = nil
                unit.TeleportOldPos = nil
            end
        end

        self:ForkThread(self.CooldownThread)
    end,

    CooldownThread = function(self)
        if self.TeleportThread then
            KillThread(self.TeleportThread)
            self.TeleportThread = nil
        end
        self.OccupancyCheck = nil
        local Interval = 1 -- number of ticks between each cooldown update
        local CooldownPerInterval = 1 / ((self.CooldownTime * 10) / Interval)
        local cooldownProgress = self:GetWorkProgress()
        while cooldownProgress ~= 0 do
            cooldownProgress = math.max(cooldownProgress - CooldownPerInterval, 0)
            self:SetWorkProgress(cooldownProgress)
            WaitTicks(Interval)
        end
        self:SetWorkProgress(0.0)
        self:AddCommandCap('RULEUCC_Teleport')
    end,

    WarpUnitCheck = function(self, unit, unitbp)
        --Should the chosen unit be able to warp?

        --If someone wanted to check team, that would go here. I don't though.
        --Prevent moving exractors and hydrocarbons. That's a can of exploitable worms right there.
        return unitbp.Physics.BuildRestriction == "RULEUBR_None" -- alternatives are RULEUBR_OnHydrocarbonDeposit and RULEUBR_OnMassDeposit
    end,

    WarpTargetCheck = function(self, unit, unitbp, target, oldpos, location)

        if target[1] <= 0 or target[1] >= ScenarioInfo.size[1] or target[3] <= 0 or target[3] >= ScenarioInfo.size[2] then
            LOG("Position out side of map boundaries.")
            return false
        end


        --TODO: Layer check here

        -- Mobile unit check and not self check
        if unitbp.FootprintDummyId and unit ~= self then -- These are wasted checks on self since these are dealt wih by the target function
            -- I Feel there is probably a c-function for all of this.

            -- Get a list of places we aren't alowed to be
            if not self.OccupancyCheck then
                -- Pre-occupancy check
                self.OccupancyCheck = {}
                local GetBrainUnitsAroundPoint = import('/lua/ai/aiutilities.lua').GetBrainUnitsAroundPoint
                for num, brain in ArmyBrains do
                    --Check radius = radius + skirt of largest structure that fits * 0.70710625 + skirt of largest structure * 0.70710625
                    -- Should probably dyncamically calculate this at game launch
                    local radius = 20 + 12.7279125 + 21.2131875
                    --Do I try to filter out unit getting teleported from this check?
                    -- At thos point we don't even know if they are getting teleported to know if they should be excluded from this pre-occupancy check
                    -- I guess this is functionally a minimum range for teleport distance as well
                    for i, v in GetBrainUnitsAroundPoint( brain, categories.STRUCTURE, location, radius, brain ) do
                        table.insert(self.OccupancyCheck, v)
                    end
                end
                local coordarray = {}

                local AddCoOrdsToArray = function(OccUnitpos, OccUnitBp)
                    local posGS = {OccUnitpos[1] - (OccUnitBp.SkirtSizeX * 0.5) + 0.5, OccUnitpos[3] - (OccUnitBp.SkirtSizeZ * 0.5) + 0.5}
                    for x = 0, (OccUnitBp.SkirtSizeX - 1) * 2 do
                        for z = 0, (OccUnitBp.SkirtSizeZ - 1) * 2 do
                            if not coordarray[posGS[1] + (x * 0.5)] then
                                coordarray[posGS[1] + (x * 0.5)] = {}
                            end
                            coordarray[posGS[1] + (x * 0.5)][posGS[2] + (z * 0.5)] = true
                        end
                    end
                end

                for i, OccUnit in self.OccupancyCheck do
                    local OccUnitpos = OccUnit:GetPosition()
                    local OccUnitBp = OccUnit:GetBlueprint()
                    AddCoOrdsToArray(OccUnitpos, OccUnitBp.Physics)
                end

                --Add mass points and hydrocarbons to banned location list.
                local AIGetMarkerLocations = import('/lua/ai/aiutilities.lua').AIGetMarkerLocations
                for groupi, group in {AIGetMarkerLocations(nil, 'Hydrocarbon'), AIGetMarkerLocations(nil, 'Mass')} do
                    for i, marker in group do
                        if string.sub(marker.Name,1,1) == 'M' then
                            AddCoOrdsToArray(marker.Position, {SkirtSizeX = 2, SkirtSizeZ = 2})
                        elseif string.sub(marker.Name,1,1) == 'H' then
                            AddCoOrdsToArray(marker.Position, {SkirtSizeX = 6, SkirtSizeZ = 6})
                        end
                    end
                end

                self.OccupancyCheck = coordarray
            end

            --Ground variation check
            -- also cross reference co-ord banned list
            -- TODO: Extend this to check to exclude coastlines
            local minH, maxH
            local posGS = {target[1] - (unitbp.Physics.SkirtSizeX * 0.5), target[3] - (unitbp.Physics.SkirtSizeZ * 0.5)}
            for x = 0, unitbp.Physics.SkirtSizeX do
                for z = 0, unitbp.Physics.SkirtSizeZ do
                    if self.OccupancyCheck[posGS[1] + x][posGS[2] + z] then
                        _ALERT("Position "..posGS[1] + x..", "..posGS[2] + z.. " blocked")
                        return false
                    end
                    local H = GetTerrainHeight(posGS[1] + x, posGS[2] + z)
                    minH = math.min(minH or H, H)
                    maxH = math.max(maxH or H, H)
                end
            end
            if maxH - minH > (unitbp.Physics.MaxGroundVariation or 1) then
                LOG("Ground is too lumpy")
                return false
            end
        end

        -- anti-teleport check, done last because this isn't a cheap calculation
        if categories.ANTITELEPORT then
    		for num, brain in ArmyBrains do
    			local unitlist = brain:GetListOfUnits(categories.ANTITELEPORT, false)
    			for i, ATunit in unitlist do
    				if IsEnemy(unit.Sync.army, ATunit.Sync.army) then
                        local noTeleDistance = ATunit:GetBlueprint().Defense.NoTeleDistance
    					local ATunitpos = ATunit:GetPosition()

        				if noTeleDistance and noTeleDistance > VDist2(target[1], target[3], ATunitpos[1], ATunitpos[3]) then
        					FloatingEntityText(GetEntityId(unit),'Teleport Destination Scrambled')
        					return false
        				-- if start point is within a jammer radius --
        				elseif noTeleDistance and noTeleDistance > VDist2(oldpos[1], oldpos[3], ATunitpos[1], ATunitpos[3]) then
        					FloatingEntityText(GetEntityId(unit),'Teleport Source Scrambled')
        					return false
        				end
    				end
                end
            end
        end

        return true
    end,

    WarpUnit = function(self, unit)
        Warp(unit, unit.TeleportTargetPos)
        unit:SetImmobile(false)
        local unitbp = unit:GetBlueprint()

            --TODO: (in blueprint.lua) Set up a separate footprint unit for each factory, and also work out what sets them appart pathing-wise.

            --TODO: deal with the build effects of warped factories

        if unitbp.FootprintDummyId then
            --Remove tarmac so we can move it
            unit:DestroyTarmac()
            --Recreate tarmac and area flatenning in new area
            if unit:GetCurrentLayer() == 'Land' and unitbp.Physics.FlattenSkirt then unit:FlattenSkirt() unit:CreateTarmac(true,true,true,false,false) end
            --cached position
            if unit.CachePosition then unit.CachePosition = table.copy(unit.TeleportTargetPos) end
        end
    end,

    UpdateAdjacencyPathBlocking = function(self, unit, unitbp, newpos, oldpos, warpedunits)
        if unitbp.FootprintDummyId then
            --Update path blocking with dummy trick, and get the adjacency data while we're at it.
            local dummyunit = CreateUnitHPR(unitbp.FootprintDummyId, self:GetArmy(), newpos[1], newpos[2], newpos[3], 0, 0, 0)
            Warp(dummyunit, oldpos)
            local AdjacencyData = dummyunit.AdjacentData

            local CheckUnitInTable = function(unittable, AdjUnit)
                for i, unit in unittable do
                    if unit:GetEntityId() == AdjUnit:GetEntityId() then
                        return true
                    end
                end
                return false
            end

            local DestroyAdjacentEffects = function(units, recreate)
                --Cleaning the visual crap up, because the DestroyAdjacentEffects method doesn't care if both are still alive.
                for _, unit in units do
                    if unit.AdjacencyBeamsBag then
                        for i, info in unit.AdjacencyBeamsBag do
                            --LOUD data structure check
                            local infounit = info.Unit
                            if type(infounit) == "number" then infounit = GetEntityById(infounit) end

                            if CheckUnitInTable(units, infounit) then
                                info.Trash:Destroy()
                                unit.AdjacencyBeamsBag[i] = nil
                                if recreate then
                                    unit:CreateAdjacentEffect(infounit)
                                end
                            end
                        end
                    end
                end
            end

            --Remove the old adjac
            if AdjacencyData then
                for i, AdjUnit in AdjacencyData do

                    if CheckUnitInTable(warpedunits, AdjUnit) then
                        LOG("Fellow warped unit " .. AdjUnit:GetBlueprint().Description)
                        --If both warped then just update the adjacency effects
                        DestroyAdjacentEffects({unit, AdjUnit}, true)
                    else
                        --If the new one didn't then it's a new adjacency

                        unit:OnAdjacentTo(AdjUnit, unit)
                        AdjUnit:OnAdjacentTo(unit, unit)
                    end
                end
            end

            --Easier to handle OnNotAdjacentTo at the footprint dummy, since passing the data back is a farce.
            dummyunit.ForceDestroyAdjacentEffects = DestroyAdjacentEffects
            dummyunit.Parent = unit
            dummyunit:Destroy()
        end
    end,
}

TypeClass = SAB5401
