--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local AIUtils = import('/lua/ai/aiutilities.lua')
local AnimationThread = import('/lua/effectutilities.lua').IntelDishAnimationThread
--------------------------------------------------------------------------------
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath
local Buff = import(BrewLANPath .. '/lua/legacy/VersionCheck.lua').Buff
--------------------------------------------------------------------------------
SEB3404 = Class(TStructureUnit) {

    OnStopBeingBuilt = function(self, ...)
        TStructureUnit.OnStopBeingBuilt(self, unpack(arg) )

        local bpD = self:GetBlueprint().Display
        self:ForkThread(AnimationThread,bpD.DishAnimations)
        self:SetMaintenanceConsumptionActive()
        
        for i, v in {Panopticon = 'Domes', Large_Dish = 'Dish_Scaffolds'} do
            local entity = import('/lua/sim/Entity.lua').Entity({Owner = self})
            entity:AttachBoneTo( -1, self, i )
            entity:SetMesh(BrewLANPath .. '/units/SEB3404/SEB3404_' .. v .. '_mesh')
            entity:SetDrawScale(bpD.UniformScale)
            entity:SetVizToFocusPlayer('Always')
            entity:SetVizToAllies('Intel')
            entity:SetVizToNeutrals('Intel')
            entity:SetVizToEnemies('Intel')
            self.Trash:Add(entity)
        end
    end,

    SetDishActive = function(self, dish, active)
        if not self.Rotators then return end
        for i, v in self.Rotators do
            if v[5] == dish then
                v[6] = active
                break
            end
        end
    end,

    IntelSearch = function(self, bp, army, aiBrain)
        local FindAllUnits = function(aiBrain, category, range, cloakcheck)
            local tableinsert = table.insert
            local Ftable = {}
            for i, unit in aiBrain:GetUnitsAroundPoint(category, (self.CachePosition or self:GetPosition()), range, 'Enemy' ) do
                if cloakcheck and unit:IsIntelEnabled('Cloak') then
                    --LOG("Counterintel guy")
                else
                    tableinsert(Ftable, unit)
                end
            end
            return Ftable
        end
        -- Find visible things to attach vis entities to
        local LocalUnits = FindAllUnits(aiBrain, categories.SELECTABLE - categories.COMMAND - categories.SUBCOMMANDER - categories.WALL - categories.HEAVYWALL - categories.MEDIUMWALL - categories.MINE, self:GetIntelRadius('radar'), true)
        ------------------------------------------------------------------------
        -- IF self.ActiveConsumptionRestriction Sort the table by distance
        ------------------------------------------------------------------------
        if self.ActiveConsumptionRestriction then
            local DistanceSortedLocalUnits = {}
            local pos = self.CachePosition or self:GetPosition()
            --Local'd for performance.
            local mathfloor = math.floor
            local VDist2Sq = VDist2Sq
            for i, v in LocalUnits do
                local vpos = v.CachePosition or v:GetPosition()
                local uniqueDistanceKey = mathfloor(VDist2Sq(vpos[1], vpos[3], pos[1], pos[3]) ) .. "." .. v:GetEntityId()
                DistanceSortedLocalUnits[uniqueDistanceKey] = v
                v = nil
            end
            LocalUnits = DistanceSortedLocalUnits
        end
        ------------------------------------------------------------------------
        -- Calculate the overall cost and cut off point for the energy restricted radius
        ------------------------------------------------------------------------
        local NewUpkeep = bp.Economy.MaintenanceConsumptionPerSecondEnergy
        local Eco = bp.Economy.MaintenanceConcumptionVision
        local SpareEnergy = aiBrain:GetEconomyIncome( 'ENERGY' ) - aiBrain:GetEconomyRequested('ENERGY') + self.PanopticonUpkeep
        local SpyBlipRadius = bp.Intel.SpyBlipRadius or 2 --2 is the smallest that works.
        for i, v in LocalUnits do

            --Calculate costs per unit as we go
            local ebp = v:GetBlueprint()
            local cost
            if ebp.Physics.MotionType == 'RULEUMT_None' then
                --If building cost
                cost = (ebp.Economy.BuildCostEnergy or 10000) / Eco.BuildingFactor
                if     cost > Eco.BuildingMax then cost = Eco.BuildingMax --Removed the math.min and max calls to reduce function overhead
                elseif cost < Eco.BuildingMin then cost = Eco.BuildingMin end
                LocalUnits[i].cost = cost
            else
                --If mobile cost
                cost = (ebp.Economy.BuildCostEnergy or 10000) / Eco.MobileFactor
                if     cost > Eco.MobileMax then cost = Eco.MobileMax
                elseif cost < Eco.MobileMin then cost = Eco.MobileMin end
                LocalUnits[i].cost = cost
            end

            --Do things with those calculated costs
            if self.ActiveConsumptionRestriction and NewUpkeep + cost > SpareEnergy then
                if i == 1 then
                    NewUpkeep = bp.Economy.MaintenanceConsumptionPerSecondEnergy
                end

                break
            else
                NewUpkeep = NewUpkeep + cost
                self:AttachVisEntityToTargetUnit(v, SpyBlipRadius, army)

            end
        end
        self.PanopticonUpkeep = NewUpkeep
        self:SetEnergyMaintenanceConsumptionOverride(self.PanopticonUpkeep)
    end,

    CreateEnhancement = function(self, enh)
        TStructureUnit.CreateEnhancement(self, enh)

        local remove = string.find(enh, 'Remove') or 0
        if remove == 0 then
            --------------------------------------------------------------------
            -- Most of the enhancements happen here
            --------------------------------------------------------------------
            Buff.ApplyBuff(self, enh .. '_Buff')
            self:SetDishActive(enh, true)
            --------------------------------------------------------------------
            -- Final upgrade
            --------------------------------------------------------------------
            if enh == 'Xband_Dish' then
                self:AddToggleCap('RULEUTC_WeaponToggle')
                self:SetScriptBit('RULEUTC_WeaponToggle', true)

                local bp = self:GetBlueprint()
                self.PanopticonUpkeep = bp.Economy.MaintenanceConsumptionPerSecondEnergy
                self.IntelSearchThread = self:ForkThread(
                    function()
                        local army = self:GetArmy()
                        local aiBrain = self:GetAIBrain()

                        while true do
                            if self.Intel then
                                self:IntelSearch(bp, army, aiBrain)
                            end
                            WaitSeconds(1)
                        end
                    end
                )
            end

        else
            local dish = string.sub(enh, 1, remove - 1)
            local array = {
                'Xband_Dish',
                'Med_Dish_004',
                'Small_Dish_004',
                'Med_Dish_003',
                'Small_Dish_003',
                'Med_Dish_002',
                'Small_Dish_002',
                'Med_Dish_001',
                'Small_Dish_001',
            }
            for i = table.find(array, dish), table.getn(array) do
                ----------------------------------------------------------------
                -- Removal of all enhancements happens here
                ----------------------------------------------------------------
                Buff.RemoveBuff(self, array[i] .. '_Buff', true)
                self:SetDishActive(array[i], false)
            end

            --------------------------------------------------------------------
            -- Removal of all final enhancement happens here
            --------------------------------------------------------------------
            if enh == 'Xband_DishRemove' then
                --Remove active consumption button
                self:RemoveToggleCap('RULEUTC_WeaponToggle')
                --Kill the thread
                KillThread(self.IntelSearchThread)
                --Reset the consumption
                local bp = self:GetBlueprint()
                self.PanopticonUpkeep = bp.Economy.MaintenanceConsumptionPerSecondEnergy
                self:SetEnergyMaintenanceConsumptionOverride(self.PanopticonUpkeep)
            end
        end
    end,

    AttachVisEntityToTargetUnit = function(self, unit, radius, army)
        local location = unit.CachePosition or unit:GetPosition()
        local spec = {
            X = location[1],
            Z = location[3],
            Radius = radius,
            LifeTime = 1,
            Omni = false,
            Radar = false,
            Vision = true,
            WaterVision = true,
            Army = army,
        }
        local visentity = VizMarker(spec)
        visentity:AttachTo(unit, -1)
    end,

    OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.ActiveConsumptionRestriction = false
        end
    end,

    OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self.ActiveConsumptionRestriction = true
        end
    end,

    OnIntelDisabled = function(self)
        TStructureUnit.OnIntelDisabled(self)
        self.Intel = false
    end,

    OnIntelEnabled = function(self)
        TStructureUnit.OnIntelEnabled(self)
        self.Intel = true
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        TStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnDestroy = function(self)
        TStructureUnit.OnDestroy(self)
    end,

    OnCaptured = function(self, captor)
        TStructureUnit.OnCaptured(self, captor)
    end,
}

TypeClass = SEB3404
