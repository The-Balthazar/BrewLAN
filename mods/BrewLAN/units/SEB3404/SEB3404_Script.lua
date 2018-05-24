--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local AIUtils = import('/lua/ai/aiutilities.lua')
local AnimationThread = import('/lua/effectutilities.lua').IntelDishAnimationThread

SEB3404 = Class(TStructureUnit) {

    OnStopBeingBuilt = function(self, ...)
        TStructureUnit.OnStopBeingBuilt(self, unpack(arg) )
        self.PanopticonUpkeep = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy
        self:SetScriptBit('RULEUTC_WeaponToggle', true)
        self:ForkThread(
            function()
                while true do
                    if self.Intel == true then
                        self:IntelSearch()
                    end
                    WaitSeconds(1)
                end
            end
        )
        self:ForkThread(AnimationThread,{
            {
                'Xband_Base',
                'Xband_Dish',
                bounds = {-180,180,-90,0,},
                speed = 3,
            },
            {
                'Tiny_Dish_00',
                c = 2,
                cont = true
            },
            {
                'Small_XBand_Stand_00',
                'Small_XBand_Dish_00',
                c = 4,
                bounds = {-180,180,-90,0,},
            },
            {
                'Small_Dish_00',
                'Small_Dish_00',
                c = 4,
                bounds = {-180,180,-90,90,},
                speed = 20,
            },
            {
                'Med_Dish_Stand_00',
                'Med_Dish_00',
                c = 4,
                bounds = {-180,180,-90,90,},
                speed = 6,
            },
            {
                'Large_Dish_Base',
                'Large_Dish',
                bounds = {-180,180,-90,0,},
                speed = 2,
            },
        })
        for i, v in {{'Panopticon','Domes'},{'Large_Dish','Dish_Scaffolds'}} do
            local entity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
            entity:AttachBoneTo( -1, self, v[1] )
            entity:SetMesh(import( '/lua/game.lua' ).BrewLANPath() .. '/units/SEB3404/SEB3404_' .. v[2] .. '_mesh')
            entity:SetDrawScale(self:GetBlueprint().Display.UniformScale)
            entity:SetVizToAllies('Intel')
            entity:SetVizToNeutrals('Intel')
            entity:SetVizToEnemies('Intel')
            self.Trash:Add(entity)
        end
    end,

    IntelSearch = function(self)
        local aiBrain = self:GetAIBrain()
        local maxrange = self:GetIntelRadius('radar') or self:GetBlueprint().Intel.RadarRadius or 6000
        -- Find visible things to attach vis entities to
        local LocalUnits = self:FindAllUnits(categories.SELECTABLE - categories.COMMAND - categories.SUBCOMMANDER - categories.WALL - categories.HEAVYWALL - categories.MEDIUMWALL - categories.MINE, maxrange, true)
        ------------------------------------------------------------------------
        -- IF self.ActiveConsumptionRestriction Sort the table by distance
        ------------------------------------------------------------------------
        if self.ActiveConsumptionRestriction then
            local DistanceSortedLocalUnits = {}
            for i, v in LocalUnits do
                local uniqueDistanceKey = math.floor(VDist2Sq(v:GetPosition()[1], v:GetPosition()[3], self:GetPosition()[1], self:GetPosition()[3]) ) .. "." .. v:GetEntityId()
                DistanceSortedLocalUnits[uniqueDistanceKey] = v
                v = nil
            end
            LocalUnits = DistanceSortedLocalUnits
        end
        ------------------------------------------------------------------------
        -- Calculate the overall cost and cut off point for the energy restricted radius
        ------------------------------------------------------------------------
        local NewUpkeep = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy
        local SpareEnergy = self:GetAIBrain():GetEconomyIncome( 'ENERGY' ) - self:GetAIBrain():GetEconomyRequested('ENERGY') + self.PanopticonUpkeep
        for i, v in LocalUnits do

            --Calculate costs per unit as we go
            local ebp = v:GetBlueprint()
            local cost
            if string.lower(ebp.Physics.MotionType or 'NOPE') == string.lower('RULEUMT_None') then
                --If building cost
                cost = math.min(math.max((ebp.Economy.BuildCostEnergy or 10000) / 10000, 1), 100)
                LocalUnits[i].cost = cost
            else
                --If mobile cost
                cost = math.min(math.max((ebp.Economy.BuildCostEnergy or 10000) / 1000, 10), 1000)
                LocalUnits[i].cost = cost
            end

            --Do things with those calculated costs
            if self.ActiveConsumptionRestriction and NewUpkeep + cost > SpareEnergy then
                if i == 1 then
                    NewUpkeep = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy
                end

                break
            else
                NewUpkeep = NewUpkeep + cost
                self:AttachVisEntityToTargetUnit(v)

            end
        end
        self.PanopticonUpkeep = NewUpkeep
        self:SetMaintenanceConsumptionActive()
        self:SetEnergyMaintenanceConsumptionOverride(self.PanopticonUpkeep)
    end,

    AttachVisEntityToTargetUnit = function(self, unit)
        local location = unit:GetPosition()
        local spec = {
            X = location[1],
            Z = location[3],
            Radius = self:GetBlueprint().Intel.SpyBlipRadius or 2,
            LifeTime = 1,
            Omni = false,
            Radar = false,
            Vision = true,
            Army = self:GetAIBrain():GetArmyIndex(),
        }
        local visentity = VizMarker(spec)
        visentity:AttachTo(unit, -1)
    end,

    FindAllUnits = function(self, category, range, cloakcheck)
        local Ftable = {}
        for i, unit in self:GetAIBrain():GetUnitsAroundPoint(category, self:GetPosition(), range, 'Enemy' ) do
            if cloakcheck and unit:IsIntelEnabled('Cloak') then
                --LOG("Counterintel guy")
            else
                table.insert(Ftable, unit)
            end
        end
        return Ftable
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
