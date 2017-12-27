--------------------------------------------------------------------------------
--  Summary:  Aeon Mobile Radar script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local CUnitsDoc = import('/lua/aeonunits.lua')
local CLandUnit = CUnitsDoc.ALandUnit
local CRadarUnit = CUnitsDoc.ARadarUnit
local Manipulators = {
    Rotator1 = {'B03', 'y', 30},
    Rotator2 = {'B02', 'y', 60},
    Rotator3 = {'B01', 'y', 120},
}

SAL0324 = Class(CLandUnit) {

    OnStopBeingBuilt = function(self, builder, layer)
        CLandUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetMaintenanceConsumptionActive()
    end,
    
    OnIntelDisabled = function(self)
        CLandUnit.OnIntelDisabled(self)
        self.Rotator1:SetSpinDown(true)
        self.Rotator2:SetSpinDown(true)
        self.Rotator3:SetSpinDown(true)
    end,

    OnIntelEnabled = function(self)
        CLandUnit.OnIntelEnabled(self)
        for rot, data in Manipulators do
            if not self[rot] then
                self[rot] = CreateRotator(self, data[1], data[2])
                self.Trash:Add(self[rot])
            end
            self[rot]:SetSpinDown(false)
            self[rot]:SetTargetSpeed(data[3])
            self[rot]:SetAccel(20)
        end
    end,

    CreateBlinkingLights = function(self, color)
        CRadarUnit.CreateBlinkingLights(self, color)
    end,

    DestroyBlinkingLights = function(self)
        CRadarUnit.DestroyBlinkingLights(self)
    end,

    DeathThread = function(self, overkillRatio, instigator)
        for i, v in Manipulators do
            self[i]:Destroy()
            self[i] = nil
        end
        CLandUnit.DeathThread(self, overkillRatio, instigator)
    end,
}

TypeClass = SAL0324
