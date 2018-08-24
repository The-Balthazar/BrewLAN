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
        local bp = self:GetBlueprint()
        self.PanopticonUpkeep = bp.Economy.MaintenanceConsumptionPerSecondEnergy
        self:SetScriptBit('RULEUTC_WeaponToggle', true)
        self:ForkThread(
            function()
                local army = self:GetArmy()
                local aiBrain = self:GetAIBrain()
                local maxrange = self:GetIntelRadius('radar') or bp.Intel.RadarRadius or 6000

                while true do
                    if self.Intel == true then
                        self:IntelSearch(bp, army, aiBrain, maxrange)
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
        local drawscale = bp.Display.UniformScale or 1
        local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
        for i, v in {Panopticon = 'Domes', Large_Dish = 'Dish_Scaffolds'} do
            local entity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
            entity:AttachBoneTo( -1, self, i )
            entity:SetMesh(BrewLANPath .. '/units/SEB3404/SEB3404_' .. v .. '_mesh')
            entity:SetDrawScale(drawscale)
            entity:SetVizToAllies('Intel')
            entity:SetVizToNeutrals('Intel')
            entity:SetVizToEnemies('Intel')
            self.Trash:Add(entity)
        end
    end,

    IntelSearch = function(self, bp, army, aiBrain, maxrange)
        local FindAllUnits = function(aiBrain, category, range, cloakcheck)
            local Ftable = {}
            for i, unit in aiBrain:GetUnitsAroundPoint(category, (self.CachePosition or self:GetPosition()), range, 'Enemy' ) do
                if cloakcheck and unit:IsIntelEnabled('Cloak') then
                    --LOG("Counterintel guy")
                else
                    table.insert(Ftable, unit)
                end
            end
            return Ftable
        end
        -- Find visible things to attach vis entities to
        local LocalUnits = FindAllUnits(aiBrain, categories.SELECTABLE - categories.COMMAND - categories.SUBCOMMANDER - categories.WALL - categories.HEAVYWALL - categories.MEDIUMWALL - categories.MINE, maxrange, true)
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
        local SpareEnergy = aiBrain:GetEconomyIncome( 'ENERGY' ) - aiBrain:GetEconomyRequested('ENERGY') + self.PanopticonUpkeep
        local SpyBlipRadius = self:GetBlueprint().Intel.SpyBlipRadius or 2
        local stringlower = string.lower
        local mathmin = math.min
        local mathmax = math.max
        for i, v in LocalUnits do

            --Calculate costs per unit as we go
            local ebp = v:GetBlueprint()
            local cost
            if stringlower(ebp.Physics.MotionType or 'NOPE') == stringlower('RULEUMT_None') then
                --If building cost
                cost = mathmin(mathmax((ebp.Economy.BuildCostEnergy or 10000) / 10000, 1), 100)
                LocalUnits[i].cost = cost
            else
                --If mobile cost
                cost = mathmin(mathmax((ebp.Economy.BuildCostEnergy or 10000) / 1000, 10), 1000)
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
        self:SetMaintenanceConsumptionActive()
        self:SetEnergyMaintenanceConsumptionOverride(self.PanopticonUpkeep)
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
