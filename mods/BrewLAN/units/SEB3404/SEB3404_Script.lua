--****************************************************************************
--**
--**  File     :  /cdimage/units/XEB2402/XEB2402_script.lua
--**  Author(s):  Dru Staltman
--**
--**  Summary  :  UEF Sub Orbital Laser
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local AIUtils = import('/lua/ai/aiutilities.lua')

SEB3404 = Class(TStructureUnit) {   
    
    OnStopBeingBuilt = function(self)
        TStructureUnit.OnStopBeingBuilt(self)
        self.PanopticonUpkeep = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy
        self.VisualMarkersBag = {}
        self:SetScriptBit('RULEUTC_WeaponToggle', true)
        self:ForkThread(
            function()
                while true do 
                    if self.Intel == true then
                        self:IntelSearch()
                    else
                        self:IntelKill()
                    end      
                    WaitSeconds(1)
                end
            end
        )
    end,
    
    IntelSearch = function(self)
        local aiBrain = self:GetAIBrain()
        local maxrange = self:GetBlueprint().Intel.SpyRadius or 8000
        local VisualMarkersBag = {}
        -- Populate LocalDarkness with the an entity array of Darknesses.
        local LocalDarkness = self:FindAllUnits( categories.srb4402, maxrange + __blueprints['srb4402'].Intel.RadarStealthFieldRadius)
        -- Find visible things to attach vis entities to
        local LocalUnits = self:FindAllUnits(categories.SELECTABLE - categories.COMMAND - categories.WALL - categories.HEAVYWALL - categories.MEDIUMWALL - categories.MINE, maxrange, true)
        ------------------------------------------------------------------------
        -- Check things aren't near a darkness.
        ------------------------------------------------------------------------
        for i,v in LocalUnits do
            for j, dark in LocalDarkness do
                if VDist2(dark:GetPosition()[1], dark:GetPosition()[3], v:GetPosition()[1], v:GetPosition()[3] ) < dark:GetBlueprint().Intel.RadarStealthFieldRadius then   --dark:GetIntelRadius('RadarStealthField') then  -- This outputs 0 for some reason
                    LocalUnits[i] = nil
                    break
                end
            end  
        end
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
        if not unit.PanopticonMarker then
            unit.PanopticonMarker = {}
        end
        unit.PanopticonMarker[self:GetArmy()] = visentity
        unit.Trash:Add(visentity)
        table.insert(self.VisualMarkersBag, {visentity,unit} )
    end,
    
    FindAllUnits = function(self, category, range, cloakcheck)
        local Ftable = {}
        for index, brain in ArmyBrains do
            if IsEnemy(brain:GetArmyIndex(), self:GetArmy() ) then
                for i, unit in AIUtils.GetOwnUnitsAroundPoint(brain, category, self:GetPosition(), range or self:GetBlueprint().Intel.SpyRadius or 8000) do
                    if unit:IsIntelEnabled('Cloak') and cloakcheck then
                        --LOG("Cloaked guy")
                    else
                        table.insert(Ftable, unit)
                    end
                end
            end
        end
        return Ftable
    end,
    
    OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.ActiveConsumptionRestriction = false
            LOG(false)
        end
    end,
       

    OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self.ActiveConsumptionRestriction = true 
            LOG(true)
        end
    end,
    
    IntelKill = function(self)
        for i, v in self.VisualMarkersBag do
            v[1]:Destroy()
            v[2].PanopticonMarker[self:GetArmy()] = nil
            v = nil
        end
        self.PanopticonUpkeep = math.min(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy, self.PanopticonUpkeep)
        self:SetEnergyMaintenanceConsumptionOverride(self.PanopticonUpkeep)  
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
        self:IntelKill()
    end,
    
    OnCaptured = function(self, captor) 
        TStructureUnit.OnCaptured(self, captor)
    end,
}
TypeClass = SEB3404