local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

SEL0324 = Class(TLandUnit) {
    Weapons = {
        MissileRack01 = Class(TSAMLauncher) {},
    },

    OnCreate = function(self)
        TLandUnit.OnCreate(self)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(self.RadarAnimation)
        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_IntelToggle', true)
        --self:DisableUnitIntel('Radar')
        --self:DisableUnitIntel('Omni')
        self:RequestRefreshUI()
        self.RadarEnabled = false
    end,

    OnIntelEnabled = function(self)
        TLandUnit.OnIntelEnabled(self)
        self.RadarEnabled = true
        self:CreateIdleEffects()
    end,

    OnIntelDisabled = function(self)
        TLandUnit.OnIntelDisabled(self)
        self.RadarEnabled = false
        self:DestroyIdleEffects()
    end,

    RadarAnimation = function(self)
        local manipulator = CreateRotator(self, 'Satellite', 'x')
        --local headmanip =  CreateRotator(self, 'Satellite', 'y')
        manipulator:SetSpeed(10)
        --headmanip:SetSpeed(10)
        manipulator:SetGoal(30)
        while IsUnit(self) do
            if self.RadarEnabled then
                WaitFor(manipulator)
                manipulator:SetGoal(-45)
                WaitFor(manipulator)
                manipulator:SetGoal(30)
                WaitFor(manipulator)
            else
                WaitTicks(10)
                self:DestroyIdleEffects()
            end
        end
    end,
}

TypeClass = SEL0324
