local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local CleanupEffectBag = import('/lua/EffectUtilities.lua').CleanupEffectBag

SEL3401 = Class(TLandUnit) {

    BpId = 'sel3401',

    TreadAnimController = function(self, open)
        if not self.TreadOpenAnimator then
            self.TreadOpenAnimator = CreateAnimator(self):PlayAnim(__blueprints[self.BpId].Display.AnimationTreadsOpen):SetRate(0)
        end
        if self.TreadThread then
            KillThread(self.TreadThread)
            self.TreadThread = nil
        end
        self.TreadThread = self:ForkThread(function(self, open)
            self.TreadOpenAnimator:SetRate(open and 1 or -1)
            self:SetImmobile(true)
            WaitFor(self.TreadOpenAnimator)
            self:SetImmobile(false)
            --self.Treads = open
        end, open)
    end,

    IntelController = function(self, target)
        self.IntelTarget = target

        if not self.IntEnts then self.IntEnts = {} end
        for i, v in self.IntEnts do
            if v.Destroy then v:Destroy(); v = nil end
        end

        if not self.DishOpenAnimator then
            self.DishOpenAnimator = CreateAnimator(self):PlayAnim(__blueprints[self.BpId].Display.AnimationDishOpen):SetRate(0)
        end

        if self.IntelThread then
            KillThread(self.IntelThread)
            self.IntelThread = nil
        end

        self.IntelThread = self:ForkThread(function(self, target)

            self:SetMaintenanceConsumptionInactive()
            self:DestroyIntelEffects()
            self:DestroyBlinkingLights()
            self:CreateBlinkingLights('Red')
            --Actually disabling at this point causes threading issues, so just turn the maintenance again.
            --self:SetScriptBit('RULEUTC_IntelToggle', true)
            --self:RemoveToggleCap('RULEUTC_IntelToggle')

            if not target and self.DishAimRotator then
                self.DishAimRotator:SetGoal(0):SetSpeed(50)
                self.DishAimRotator2:SetGoal(0):SetSpeed(50)
                WaitFor(self.DishAimRotator)
                WaitFor(self.DishAimRotator2)
            end
            self.DishOpenAnimator:SetRate(target and 1 or -1)

            WaitFor(self.DishOpenAnimator)

            if not target then
                self:SetScriptBit('RULEUTC_IntelToggle', true)
                self:RemoveToggleCap('RULEUTC_IntelToggle')
                self:DestroyBlinkingLights()
            else

                local bpInt = self:GetBlueprint().Intel
                local army = self:GetArmy()

                local pos = self:GetPosition()
                local relloc = {target[1]-pos[1], target[3]-pos[3]}
                local aimdir = math.atan2(relloc[1], relloc[2])
                local targetdist = VDist2(0,0,relloc[1],relloc[2])

                local rScale = bpInt.BlipRadarRadius / targetdist
                local oScale = bpInt.BlipOmniRadius / targetdist
                local vScale = bpInt.BlipVisionRadius / targetdist
                local sScale = bpInt.BlipSonarRadius / targetdist

                local heading = self:GetHeading()
                if not self.DishAimRotator then
                    --(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
                    self.DishAimRotator = CreateRotator(self, 'Small_Dish_Yaw', 'y', aimdir * 57.296, __blueprints[self.BpId].Physics.DishTurnSpeed, __blueprints[self.BpId].Physics.DishTurnSpeed)
                    self.DishAimRotator2 = CreateRotator(self, 'Large_Dish_Tower_Yaw', 'y', aimdir * 57.296, __blueprints[self.BpId].Physics.DishTurnSpeed, __blueprints[self.BpId].Physics.DishTurnSpeed)
                else
                    self.DishAimRotator:SetGoal((aimdir-heading) * 57.296):SetSpeed(__blueprints[self.BpId].Physics.DishTurnSpeed)
                    self.DishAimRotator2:SetGoal((aimdir-heading) * 57.296):SetSpeed(__blueprints[self.BpId].Physics.DishTurnSpeed)
                end
                WaitFor(self.DishAimRotator)
                WaitFor(self.DishAimRotator2)

                self:SetMaintenanceConsumptionActive()
                self:CreateIntelEffects()
                self:DestroyBlinkingLights()
                self:CreateBlinkingLights('Green')
                self:AddToggleCap('RULEUTC_IntelToggle')
                self:SetScriptBit('RULEUTC_IntelToggle', false)
                for int, rad in { Radar = bpInt.BlipRadarRadius, Sonar = bpInt.BlipSonarRadius, Vision = bpInt.BlipVisionRadius, Omni = bpInt.BlipOmbiRadius} do
                    local scale = rad/targetdist
                    if (int ~= 'Sonar' and int ~= 'WaterVision') or (int == 'Sonar' or int == 'WaterVision') and self:GetCurrentLayer() == 'Water' then
                        self.IntEnts[int] = VizMarker({
                            X = pos[1] + relloc[1]*scale,
                            Z = pos[3] + relloc[2]*scale,
                            Radius = rad,
                            LifeTime = -1,
                            Omni = (int == 'Omni'),
                            Radar = (int == 'Radar'),
                            Vision = (int == 'Vision'),
                            WaterVision = (int == 'WaterVision'),
                            Sonar = (int == 'Sonar'),
                            Army = army,
                        })
                    end
                end
            end
        end, target)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetMaintenanceConsumptionInactive()
        self.Sync.Abilities = self:GetBlueprint().Abilities
        self:SetScriptBit('RULEUTC_IntelToggle', true)
        self:RemoveToggleCap('RULEUTC_IntelToggle')
        self:RequestRefreshUI()
        if self:GetCurrentLayer() == 'Land' then
            self:TreadAnimController(true)
        end
    end,

    OnLayerChange = function(self, new, old)
        TLandUnit.OnLayerChange(self, new, old)
        if not self.WaterSlider then self.WaterSlider = CreateSlider(self, 0, 0, 0, 0, 1, true) end
        self.WaterSlider:SetGoal(0,new == 'Water' and -0.3 or 0, 0)
        if old ~= 'None' then
            self:TreadAnimController(new == 'Land')
        end
    end,

    OnMotionHorzEventChange = function(self, new, old)
        TLandUnit.OnMotionHorzEventChange(self, new, old)
        if new ~= 'Stopped' then
            if new ~= 'Stopping' then
                self:IntelController()
            end
            if self:GetCurrentLayer() == 'Land' and not self.IntelTarget then
                self:TreadAnimController(true)
            end
        end
    end,

    --[[OnIntelEnabled = function(self)
        TLandUnit.OnIntelEnabled(self)
    end,]]

    OnIntelDisabled = function(self)
        TLandUnit.OnIntelDisabled(self)
        self:IntelController()
        --self:DestroyIdleEffects()
    end,

    OnTargetLocation = function(self, target)
        self:TreadAnimController()
        self:IntelController(target)
    end,

    CreateBlinkingLights = function(self, color)
        self:DestroyBlinkingLights()
        local bp = self:GetBlueprint().Display.BlinkingLights
        local bpEmitters = self:GetBlueprint().Display.BlinkingLightsFx
        if bp then
            local fxbp = bpEmitters[color]
            for k, v in bp do
                if type(v) == 'table' then
                    local fx = CreateAttachedEmitter(self, v.BLBone, self:GetArmy(), fxbp)
                    fx:OffsetEmitter(v.BLOffsetX or 0, v.BLOffsetY or 0, v.BLOffsetZ or 0)
                    fx:ScaleEmitter(v.BLScale or 1)
                    table.insert(self.FxBlinkingLightsBag, fx)
                    self.Trash:Add(fx)
                end
            end
        end
    end,

    DestroyBlinkingLights = function(self)
        if self.FxBlinkingLightsBag then
            for k, v in self.FxBlinkingLightsBag do
                v:Destroy()
            end
        end
        self.FxBlinkingLightsBag = {}
    end,

    CreateIntelEffects = function( self )
        local layer = self:GetCurrentLayer()
        local bpTable = self:GetBlueprint().Display.IntelEffects
        if bpTable[layer] and bpTable[layer].Effects then
            self:CreateTerrainTypeEffects( bpTable[layer].Effects, 'FXIdle', layer, nil, self.IntelEffectsBag )
        end
    end,

    DestroyIntelEffects = function( self )
        if self.IntelEffectsBag then
            CleanupEffectBag(self,'IntelEffectsBag')
        end
        self.IntelEffectsBag = {}
    end,
}

TypeClass = SEL3401
