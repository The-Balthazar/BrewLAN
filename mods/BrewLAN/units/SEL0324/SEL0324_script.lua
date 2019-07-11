local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local RadarRestricted = type(ScenarioInfo.Options.RestrictedCategories) == 'table' and table.find(ScenarioInfo.Options.RestrictedCategories, 'INTEL')

SEL0324 = Class(TLandUnit) {
    Weapons = {
        MissileRack01 = Class(TSAMLauncher) {},
    },

    OnCreate = function(self)
        TLandUnit.OnCreate(self)
        if math.random(1,3) ~= 2 then
            self:HideBone('Neck', true)
            CreateSlider(self, 'AttachPoint', 0, -0.37, 0, 1, true)
            CreateSlider(self, 'Hat', -0.13, -0.31, 0, 1, true)
            CreateRotator(self, 'Hat', 'z', -40, 1000, 1000)
            --(self, 'Hat', 'y', nil, 0, 50, 0)
        end
        if RadarRestricted then
            self:HideBone('Satellite', true)
        end
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self, builder, layer)
        if RadarRestricted then
            self:RemoveToggleCap('RULEUTC_IntelToggle')
        else
            self.RadarEnabled = false
            self:ForkThread(self.RadarAnimation)
        end
        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_IntelToggle', true)
        self:RequestRefreshUI()
    end,

    OnIntelEnabled = function(self)
        TLandUnit.OnIntelEnabled(self)
        if not RadarRestricted then
            self.RadarEnabled = true
            self.RadarEffects = CreateAttachedEmitter(self,'Dish',self:GetArmy(),'/effects/emitters/radar_ambient_01_emit.bp')
        end
    end,

    OnIntelDisabled = function(self)
        TLandUnit.OnIntelDisabled(self)
        if not RadarRestricted then
            self.RadarEnabled = false
            self.RadarEffects:Destroy()
        end
    end,

    RadarAnimation = function(self)
        local manipulator = CreateRotator(self, 'Satellite', 'x')
        manipulator:SetSpeed(10)
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
