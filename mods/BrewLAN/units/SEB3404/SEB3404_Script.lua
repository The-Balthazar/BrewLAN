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
        --self.PanopticonUpkeep = 0
        self.VisualMarkersBag = {}
        self:ForkThread(
            function()
                while true do 
                    if self.Intel == true then
                        self:IntelSearch()
                    else
                        self:IntelKill()
                    end      
                    WaitSeconds(3)
                end
            end
        )
    end,
    
    IntelSearch = function(self)
        local aiBrain = self:GetAIBrain()
        local maxrange = self:GetBlueprint().Intel.SpyRadius or 8000
        ------------------------------------------------------------------------
        -- Find local Darknesses
        ------------------------------------------------------------------------
        local LocalDarkness = {}
        for index, brain in ArmyBrains do
            if IsEnemy(brain:GetArmyIndex(), self:GetArmy() ) then
                for i, unit in AIUtils.GetOwnUnitsAroundPoint(brain, categories.srb4402, self:GetPosition(), maxrange) do
                    table.insert(LocalDarkness, unit)
                end
            end
        end
        ------------------------------------------------------------------------
        -- Find visible things to attach vis entities to
        ------------------------------------------------------------------------
        local LocalUnits = {} 
        for index, brain in ArmyBrains do
            if IsEnemy(brain:GetArmyIndex(), self:GetArmy() ) then
                for i, unit in AIUtils.GetOwnUnitsAroundPoint(brain, categories.SELECTABLE - categories.COMMAND - categories.WALL - categories.HEAVYWALL - categories.MEDIUMWALL - categories.MINE, self:GetPosition(), maxrange) do
                    if unit:IsIntelEnabled('Cloak') or unit.PanopticonMarker then
                        --LOG("Cloaked guy or guy with vis ent already attached")
                    else
                        table.insert(LocalUnits, unit)
                    end
                end
            end
        end   
        ------------------------------------------------------------------------
        -- Check things aren't near a darkness.
        ------------------------------------------------------------------------
        for i,v in LocalUnits do
            local DoTrack = true
            for j, dark in LocalDarkness do
                --LOG( "DarkRadius = " .. dark:GetIntelRadius('RadarStealthField') .. " Distance = " .. VDist2(dark:GetPosition()[1], dark:GetPosition()[3], v:GetPosition()[1], v:GetPosition()[3] ) )
                if VDist2(dark:GetPosition()[1], dark:GetPosition()[3], v:GetPosition()[1], v:GetPosition()[3] ) < dark:GetBlueprint().Intel.RadarStealthFieldRadius then   --dark:GetIntelRadius('RadarStealthField') then  -- This outputs 0 for some reason
                    DoTrack = false
                    break
                end
            end    
            if DoTrack then
                local location = v:GetPosition()
                local spec = {
                    X = location[1],
                    Z = location[3],
                    Radius = self:GetBlueprint().Intel.SpyBlipRadius or 2,
                    LifeTime = -1,
                    Omni = false,
                    Radar = false,
                    Vision = true,
                    Army = aiBrain:GetArmyIndex(),
                }
                local visentity = VizMarker(spec)
                visentity:AttachTo(v, -1)
                v.PanopticonMarker = visentity
                v.Trash:Add(visentity)
                --self.Trash:Add(visentity)
                table.insert(self.VisualMarkersBag, {visentity,v} )
            end
        end     
        ------------------------------------------------------------------------
        -- Calculate overall costs
        ------------------------------------------------------------------------
        local Upkeep = 0
        for i,v in self.VisualMarkersBag do
            if v[2].PanopticonMarker then
                local ebp = v[2]:GetBlueprint()
                --Make buildings cost a 10th of mobile units.
                if string.lower(ebp.Physics.MotionType or 'NOPE') == string.lower('RULEUMT_None') then
                    Upkeep = Upkeep + math.min(math.max((ebp.Economy.BuildCostEnergy or 10000) / 10000, 1), 100)
                else
                    Upkeep = Upkeep + math.min(math.max((ebp.Economy.BuildCostEnergy or 10000) / 1000, 10), 1000)
                end
            end
        end
        self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy + Upkeep)
        self:SetMaintenanceConsumptionActive() 
    end,

    IntelKill = function(self)
        for i, v in self.VisualMarkersBag do
            v[1]:Destroy()
            v[2].PanopticonMarker = nil
            v = nil
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
        self:IntelKill()
    end,
    
    OnCaptured = function(self, captor) 
        TStructureUnit.OnCaptured(self, captor)
    end,
}
TypeClass = SEB3404