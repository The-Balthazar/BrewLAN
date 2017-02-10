
local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

SEL0324 = Class(TLandUnit) {
    Weapons = {
        MissileRack01 = Class(TSAMLauncher) {},
    },

    OnCreate = function(self)
        TLandUnit.OnCreate(self)
        --[[if math.random(1,10) != 10 then
            self:HideBone('Head',true)
        end]]--
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(self.RadarAnimation)
        self:SetMaintenanceConsumptionActive()
        self.RadarEnabled = true
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
        while IsUnit(self) do
            if self.RadarEnabled then
                manipulator:SetGoal(30)
                WaitFor(manipulator)
                manipulator:SetGoal(-45)
                WaitFor(manipulator)
            else
                WaitTicks(10)
            end
        end
    end,
}

TypeClass = SEL0324
