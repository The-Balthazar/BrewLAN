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
        self.VisualMarkersBag = {}
        self:ForkThread(
            function()
                while true do 
                    self:IntelSearch()
                    WaitSeconds(3)
                end
            
            end
        )
    end,
    
    IntelSearch = function(self)
        local aiBrain = self:GetAIBrain()
        local maxrange = 8000
        local blip = {
            vis = 2,
            --radar = 50,
            --omni = 2,
        }
        local LocalDarkness = {}
        for index, brain in ArmyBrains do
            if IsEnemy(brain:GetArmyIndex(), self:GetArmy() ) then
                for i, unit in AIUtils.GetOwnUnitsAroundPoint(brain, categories.srb4402, self:GetPosition(), maxrange) do
                    table.insert(LocalDarkness, unit)
                end
            end
        end
        local LocalUnits = {} 
        for index, brain in ArmyBrains do
            if IsEnemy(brain:GetArmyIndex(), self:GetArmy() ) then
                for i, unit in AIUtils.GetOwnUnitsAroundPoint(brain, categories.SELECTABLE - categories.COUNTERINTELLIGENCE - categories.COMMAND - categories.WALL - categories.HEAVYWALL - categories.MEDIUMWALL - categories.MINE, self:GetPosition(), maxrange) do
                    table.insert(LocalUnits, unit)
                end
            end
        end
        for i,v in LocalUnits do
            local DoTrack = true
            for j, dark in LocalDarkness do
                --LOG( "DarkRadius = " .. dark:GetIntelRadius('RadarStealthField') .. " Distance = " .. VDist2(dark:GetPosition()[1], dark:GetPosition()[3], v:GetPosition()[1], v:GetPosition()[3] ) )
                if VDist2(dark:GetPosition()[1], dark:GetPosition()[3], v:GetPosition()[1], v:GetPosition()[3] ) < dark:GetBlueprint().Intel.RadarStealthFieldRadius then   --dark:GetIntelRadius('RadarStealthField') then  -- This outputs 0 for some reason
                    DoTrack = false
                    break
                end
            end
            if not v.PanopticonMarker and DoTrack then
                local location = v:GetPosition()
                local spec = {
                    X = location[1],
                    Z = location[3],
                    Radius = blip.vis,
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
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        TStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    
    OnDestroy = function(self)
        TStructureUnit.OnDestroy(self)
        for i, v in self.VisualMarkersBag do
            v[1]:Destroy()
            v[2].PanopticonMarker = nil
        end
    end,
    
    OnCaptured = function(self, captor) 
        TStructureUnit.OnCaptured(self, captor)
    end,
}
TypeClass = SEB3404