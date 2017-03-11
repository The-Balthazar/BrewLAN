--------------------------------------------------------------------------------
--  Summary:  Cybran Mobile Radar script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local CUnitsDoc = import('/lua/cybranunits.lua')
local CLandUnit = CUnitsDoc.CLandUnit
local CRadarUnit = CUnitsDoc.CRadarUnit
local CDFElectronBolterWeapon = import('/lua/cybranweapons.lua').CDFElectronBolterWeapon

SRL0324 = Class(CLandUnit) {

    OnCreate = function(self)
        self.FxBlinkingLightsBag = {}
        CLandUnit.OnCreate(self)
    end,

    OnStopBeingBuilt = function(self, ...)
        self:SetMaintenanceConsumptionActive()
        CLandUnit.OnStopBeingBuilt(self, unpack(arg) )
        self:DisableUnitIntel('RadarStealth')
        self:DisableUnitIntel('Cloak')
        self.Cloaked = false
        ChangeState( self, self.InvisState )
    end,

    OnIntelDisabled = function(self)
        CLandUnit.OnIntelDisabled(self)
        if self.Threads and self.Threads[4][1] then
            self:DestroyIdleEffects()
            self:DestroyBlinkingLights()
            self:CreateBlinkingLights('Red')
        end
        if self.Threads then
            self.Threads[4][1] = false
            local bp = self:GetBlueprint()
            self.AnimManip:SetRate(-2)
            self:SetCollisionShape(
                'Box',
                bp.CollisionOffsetX or 0,
                bp.CollisionOffsetY or 0,
                bp.CollisionOffsetZ or 0,
                bp.SizeX,
                bp.SizeY,
                bp.SizeZ
            )
        end
    end,


    OnIntelEnabled = function(self)
        CLandUnit.OnIntelEnabled(self)
        if self.Threads and not self.Threads[4][1] then
            local bp = self:GetBlueprint()
            self.AnimManip:SetRate(2)
            self:SetCollisionShape(
                'Box',
                bp.CollisionOffsetX or 0,
                bp.CollisionOffsetY or 0,
                bp.CollisionOffsetZ or 0,
                bp.SizeX,
                bp.SizeY * 4,
                bp.SizeZ
            )
            self:DestroyBlinkingLights()
            self:CreateBlinkingLights('Green')
            --self:CreateIdleEffects()
        end
        if not self.Threads then
            self.Threads = {
                {'Sensor_D001'},
                {'Sensor_D002'},
                {'Sensor_D003'},
            }
            for i, v in self.Threads do
                --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
                self.Threads[i][2] = CreateRotator(self, v[1], 'z', 0, 10, 4, 10)
            end
            self.Threads[4] = {
                true,
                self:ForkThread(self.DishBehavior),
            }
            self.AnimManip = CreateAnimator(self)
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
        else
            self.Threads[4][1] = true
        end
    end,

    DishBehavior = function(self)
        while true do
            if self.Threads[4][1] then
                for i, v in self.Threads do
                    if i != 4 and math.random(1,3) == 3 then
                        WaitFor(self.Threads[i][2])
                        self.Threads[i][2]:SetGoal(math.random(0,45) )
                    end
                end
            end
            WaitTicks(math.random(4,8))
        end
    end,

    CreateBlinkingLights = function(self, color)
        CRadarUnit.CreateBlinkingLights(self, color)
    end,

    DestroyBlinkingLights = function(self)
        CRadarUnit.DestroyBlinkingLights(self)
    end,

    OnStartTransportBeamUp = function(self, transport, bone)
        CLandUnit.OnStartTransportBeamUp(self, transport, bone)
        ChangeState( self, self.VisibleState )
        self.LastTransportedTime = GetGameTimeSeconds()
    end,

    InvisState = State() {
        Main = function(self)
            self.Cloaked = false
            local bp = self:GetBlueprint()
            if bp.Intel.StealthWaitTime then
                WaitSeconds( bp.Intel.StealthWaitTime )
            end
            self:EnableUnitIntel('RadarStealth')
            self:EnableUnitIntel('Cloak')
            self:EnableUnitIntel('Omni')
            self:EnableUnitIntel('Radar')
            self.Cloaked = true
        end,

        OnMotionHorzEventChange = function(self, new, old)
            if new != 'Stopped' then
                ChangeState( self, self.VisibleState )
                LOG("OnMotionHorzEventChange become visible")
            end
            CLandUnit.OnMotionHorzEventChange(self, new, old)
        end,
    },

    VisibleState = State() {
        Main = function(self)
            if self.Cloaked then
                self:DisableUnitIntel('RadarStealth')
                self:DisableUnitIntel('Cloak')
                self:DisableUnitIntel('Omni')
                self:DisableUnitIntel('Radar')
            end
        end,

        OnMotionHorzEventChange = function(self, new, old)
            if new == 'Stopped' and (self.LastTransportedTime or 0) + 2 < GetGameTimeSeconds() then
                ChangeState( self, self.InvisState )
                LOG("OnMotionHorzEventChange become invisible", new, old)
            end
            CLandUnit.OnMotionHorzEventChange(self, new, old)
        end,
    },
}
TypeClass = SRL0324
