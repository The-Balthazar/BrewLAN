local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit
--------------------------------------------------------------------------------
local WeaponsFile = import('/lua/seraphimweapons.lua')
local SDFSinnuntheWeapon = WeaponsFile.SDFSinnuntheWeapon
local SAAOlarisCannonWeapon = WeaponsFile.SAAOlarisCannonWeapon
local SDFThauCannon = WeaponsFile.SDFThauCannon
local SANUallCavitationTorpedo = WeaponsFile.SANUallCavitationTorpedo
local SDFAjelluAntiTorpedoDefense = WeaponsFile.SDFAjelluAntiTorpedoDefense
local SDFGapingMaw = WeaponsFile.SDFGapingMaw
local SMeleeBladeBeamWeapon = WeaponsFile.SMeleeBladeBeamWeapon
--------------------------------------------------------------------------------
--local utilities = import('/lua/utilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
--local explosion = import('/lua/defaultexplosions.lua')
--------------------------------------------------------------------------------
SSL0405 = Class(SLandUnit) {

    BpId = 'ssl0405',

    Weapons = {
        BigGun = Class(SDFSinnuntheWeapon) {
            PlayFxMuzzleChargeSequence = function(self, muzzle)
                if not self.WeaponFXBag then
                    self.WeaponFXBag = {}
                end
                EffectUtil.CleanupEffectBag(self,'WeaponFXBag')
                for k, v in self.FxChargeMuzzleFlash do
                    table.insert(self.WeaponFXBag, CreateAttachedEmitter(self.unit, string.sub(muzzle, 1, 9), self.unit:GetArmy(), v):ScaleEmitter(self.FxChargeMuzzleFlashScale) )
                end
            end,
        },
        SmallGun = Class(SAAOlarisCannonWeapon) {},
        FaceGuns = Class(SDFThauCannon) {},
        Torpedo = Class(SANUallCavitationTorpedo) {},
        AntiTorpedo = Class(SDFAjelluAntiTorpedoDefense) {},
        GapingMaw = Class(SDFGapingMaw) {},
        ClawMelee = Class(SMeleeBladeBeamWeapon) {
            OnFire = function(self)
                if not self.unit.TallStance and not self.unit.AnimationManipulator then
                    SMeleeBladeBeamWeapon.OnFire(self)
                end
            end,
        },
    },

    OnStartBeingBuilt = function(self, builder, layer)
        SLandUnit.OnStartBeingBuilt(self, builder, layer)
        local layer = self:GetCurrentLayer()
        if layer == 'Land' then
            --This animator is trashed after finishing building once it's animated
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
            self.AnimationManipulator:PlayAnim(__blueprints[self.BpId].Display.AnimationActivate, false):SetRate(0)
        elseif layer == 'Water' then
            --This animator is kept around and could eventyally be used for the water/land transitions
            self.TransformAnimator = CreateAnimator(self)
            self.TransformAnimator:PlayAnim(__blueprints[self.BpId].Display.AnimationTransformLandWater):SetRate(0):SetAnimationFraction(1)
        end
        ---Collision box partially in the water/land
        local bp = __blueprints[self.BpId]
        self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0, bp.CollisionOffsetYSwim or 1, bp.CollisionOffsetZ or 0, bp.SizeX * 0.5, bp.SizeY * 0.5, bp.SizeZ * 0.5)
    end,

    StartBeingBuiltEffects = function(self, builder, layer)
		SLandUnit.StartBeingBuiltEffects(self, builder, layer)
		self:ForkThread( EffectUtil.CreateSeraphimExperimentalBuildBaseThread, builder, self.OnBeingBuiltEffectsBag )
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        SLandUnit.OnStopBeingBuilt(self, builder, layer)
        if self.AnimationManipulator then
            self:SetUnSelectable(true)
            self:SetImmobile(true)
            self.AnimationManipulator:SetRate(1)
            self:RevertCollisionShape()
            self:ForkThread(function()
                coroutine.yield(self.AnimationManipulator:GetAnimationDuration()/self.AnimationManipulator:GetRate() * 10)
                self:SetUnSelectable(false)
                self:SetImmobile(false)
                self.AnimationManipulator:Destroy()
                self.AnimationManipulator = nil
            end)
        elseif self:GetCurrentLayer() == 'Water' then
            if not self.TransformAnimator then
                --Copy pasted from 'OnStartBeingBuilt' because it still needs to happen
                self.TransformAnimator = CreateAnimator(self)
                self.Trash:Add(self.TransformAnimator)
                self.TransformAnimator:PlayAnim(__blueprints[self.BpId].Display.AnimationTransformLandWater):SetRate(0):SetAnimationFraction(1)
                ---Collision box partially in the water/land
                local bp = __blueprints[self.BpId]
                self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0, bp.CollisionOffsetYSwim or 1, bp.CollisionOffsetZ or 0, bp.SizeX * 0.5, bp.SizeY * 0.5, bp.SizeZ * 0.5)
            end
            self:SetSpeedMult(__blueprints[self.BpId].Physics.WaterSpeedMultiplier)
            self:RemoveToggleCap('RULEUTC_WeaponToggle')
        end
        self.LastActive = GetGameTimeSeconds()
        --[[for i = 1, self:GetWeaponCount() do
            local wep = self:GetWeapon(i)
            local bp = wep:GetBlueprint()
            if bp.Label ~= 'GapingMaw' then
                wep:SetWeaponEnabled(false)
            end
        end]]
    end,

    OnAnimCollision = function(self, bone, x, y, z)
        SLandUnit.OnAnimCollision(self, bone, x, y, z)
    end,

    OnScriptBitSet = function(self, bit)
        SLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 and self:GetCurrentLayer() == 'Land' then
            self:SetWeaponStance(true)
        elseif bit == 1 and self:GetCurrentLayer() ~= 'Land' then
            self:SetScriptBit('RULEUTC_WeaponToggle', false)
        end
    end,

    OnScriptBitClear = function(self, bit)
        SLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self:SetWeaponStance(nil)
        end
    end,

    GetBlueprint = function(self)
        if self.Dead then
            local layer = moho.unit_methods.GetCurrentLayer(self)
            if layer == 'Water' or layer == 'Land' then
                local bp = __blueprints[self.BpId] -- moho.entity_methods.GetBlueprint(self)
                bp.Display.AnimationDeath = bp.Display[layer..'AnimationDeath']
                return bp
            else
                return __blueprints[self.BpId] -- moho.entity_methods.GetBlueprint(self)
            end
        else
            return __blueprints[self.BpId] -- moho.entity_methods.GetBlueprint(self)
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.ShallSink then self.ShallSink = function() return true end end
        for i, v in {'Animator', 'TransformAnimator'} do
            if self[v] then
                self[v]:Destroy()
                self[v] = nil
            end
        end
        SLandUnit.OnKilled(self, instigator, type, overkillRatio)
        if self.TallStance then
            self:SetScriptBit('RULEUTC_WeaponToggle', false)
            self.TallStanceAnimator:SetRate(-3)
        end
    end,

    DeathThread = function(self, overkillRatio, instigator)
        if self.DestructionExplosionWaitDelayMax and self.DestructionExplosionWaitDelayMin then
            coroutine.yield((math.random() * (self.DestructionExplosionWaitDelayMax - self.DestructionExplosionWaitDelayMin) + self.DestructionExplosionWaitDelayMin + 1 ) * 10)
        end
        self:DestroyAllDamageEffects()
        self:CreateDestructionEffects(overkillRatio)
        self.CreateUnitDestructionDebris(self, true, true, overkillRatio > 2)

        if not self.BagsDestroyed then
            local TrashEffectBag = function( self, EffectBag )
                for k, v in self[EffectBag] do
                    v:Destroy()
                end
            end
            for i, v in {'OnBeingBuiltEffectsBag', 'TallSteamEffectBag'} do
                if self[v] then
                    TrashEffectBag(self, v)
                end
            end
            local wep
            for i = 1, self:GetWeaponCount() do
                wep = self:GetWeapon(i)
                if wep.WeaponFXBag then
                    TrashEffectBag(wep, 'WeaponFXBag')
                end
            end
            for i, v in {'IdleAnimator'} do
                self:GracefullyKillSpecAnim(v)
            end
            self.BagsDestroyed = true
        end

        local layer = self:GetCurrentLayer()
        if layer == 'Water' then
            self:StopUnitAmbientSound('AmbientMoveWater')

            self.DisallowCollisions = true
            self.overkillRatio = overkillRatio

            if self.SinkDestructionEffects and self.SeabedWatcher then
                self:ForkThread(self.SinkDestructionEffects)
                if self:GetFractionComplete() > 0.5 then
                    self:SeabedWatcher()
                else
                    self:DestroyUnit(self.overkillRatio)
                end
            end
        end
        if layer == 'Land' or not self.SeabedWatcher then
            if self.DeathAnimManip then
                WaitFor(self.DeathAnimManip)
            end
        end

        self:CreateDestructionEffects(overkillRatio)
        self:CreateWreckage( overkillRatio )
        coroutine.yield(1)
        self:Destroy()
    end,

    ----------------------------------------------------------------------------
    -- Transition handlers
    ----------------------------------------------------------------------------
    OnMotionHorzEventChange = function(self, new, old)
        --LOG(new)
        SLandUnit.OnMotionHorzEventChange(self, new, old)
        if new == 'Stopped' then
            self.LastActive = GetGameTimeSeconds()
            self:UpdateMovementAnimation(new, old, true)
            self:UpdateMovementAnimation(new, old)
            if (not self.DeathAnim or not self.Dead) and not self.FinishMovementLoop then
                if self.Animator then
                    self.Animator:Destroy()
                end
                self.Animator = nil
            end

        elseif new ~= 'Stopped' and old == 'Stopped' and not self.TallStance --Check state
        and GetGameTimeSeconds() - self.LastActive > math.random(60,300) and math.random(1,5) ~= 5 --Check RNG and time
        and self:GetHealth() > 48980 and self:GetCurrentLayer() == 'Land' then --Check self, before wreck self

            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
            self.AnimationManipulator:PlayAnim(__blueprints[self.BpId].Display.AnimationsIdle.Stretch, false):SetRate(1+(math.random() * 0.5))
            self:SetImmobile(true)
            self:ForkThread(function()
                coroutine.yield(self.AnimationManipulator:GetAnimationDuration() / self.AnimationManipulator:GetRate() * 10)
                self:SetImmobile(false)
                self.AnimationManipulator:Destroy()
                self.AnimationManipulator = nil
                self:UpdateMovementAnimation(new, old)
            end)
        elseif new ~= 'Stopped' then
            self:UpdateMovementAnimation(new, old)
        end
    end,

    OnLayerChange = function(self, new, old)
        SLandUnit.OnLayerChange(self, new, old)
        if old ~= 'None' then --Prevent this from triggering imediately
            if self.TransformThread and (new == 'Land' or new == 'Water') then
                KillThread(self.TransformThread)
                self.TransformThread = nil
            end
            if new == 'Water' and old == 'Land' then
                self.TransformThread = self:ForkThread(self.LayerTransform, false)
            elseif new == 'Land' and old == 'Water' then
                self.TransformThread = self:ForkThread(self.LayerTransform, true)
            end
            if self:GetFractionComplete() ~= 1 or not self:IsMoving() then
                self:UpdateMovementAnimation('Stopped')
            else
                self:UpdateMovementAnimation()
            end
        end
    end,

    StartSpecAnim = function(self, anim, rate, handler, tracker, unlooped)
        --Data for other functions
        if tracker then
            self[tracker] = unlooped
        end
        --Kill the thread that will kill us, since if we're starting a new one, we don't want it killed any more
        if self['Grace'..handler] then KillThread(self['Grace'..handler]) end
        --Do the thing
        if not self[handler] then
            if handler == 'Animator' then
                self.Animator = CreateAnimator(self, true) --This makes movement speed modify the rate
            else
                self[handler] = CreateAnimator(self)
            end
        end
        local animT
        if not self.TransformThread then -- This prevents it from snapping to the middle of the swim animation from a walk animation.
            animT = self[handler]:GetAnimationTime()
        end
        self[handler]:PlayAnim(anim, not unlooped)
        if not self.TransformThread then
            self[handler]:SetAnimationTime(animT)
        end
        self[handler]:SetDirectionalAnim(handler ~= 'IdleAnimator')
        self[handler]:SetRate(rate)
        --self.Animator:SetBoneEnabled('Leg_Upper_001', false, true)
    end,

    GracefullyKillSpecAnim = function(self, handler, tracker)
        ---CleanGarbage
        if self['Grace'..handler] then KillThread(self['Grace'..handler]) end
        if self[handler] then
            self['Grace'..handler] = self:ForkThread(function()
                coroutine.yield(
                    self[handler]:GetAnimationDuration()
                    / self[handler]:GetRate()
                    * (1 - self[handler]:GetAnimationFraction())
                    * 10
                 )
                self[handler]:Destroy()
                self[handler] = nil
                if tracker then
                    self[tracker] = nil
                end
            end)
        end
    end,

    UpdateMovementAnimation = function(self, new, old, idle)
        local CheckHeadingForwards = function(self)
            --Returns true if heading forwards
            local vx, vy, vz = self:GetVelocity()
            local head = self:GetHeading()
            if vx == 0 then
                local ahead = math.abs(head)
                if vy < 0 and ahead > 1.57 then
                    return true
                elseif vy > 0 and ahead < 1.57 then
                    return true
                else
                    return false
                end
            elseif vx < 0 and head < 0 then
                return true
            elseif vx > 0 and head > 0 then
                return true
            else
                return false
            end
        end

        local layer = self:GetCurrentLayer()
        local bpDisplay = __blueprints[self.BpId].Display

        if not idle then
            if layer == 'Land' then
                if self.TallStance then
                    self:StartSpecAnim(bpDisplay.AnimationsMove.WalkTall, bpDisplay.AnimationWalkRateTall, 'Animator', 'FinishMovementLoop')
                --elseif new == 'Cruise' then
                    --self:StartSpecAnim(bpDisplay.AnimationsMove.WalkSlow, bpDisplay.AnimationWalkRate, 'Animator', 'FinishMovementLoop')
                elseif new == 'TopSpeed' or new == 'Cruise' then
                    self:StartSpecAnim(bpDisplay.AnimationsMove.Walk, bpDisplay.AnimationWalkRate, 'Animator', 'FinishMovementLoop')
                elseif new == 'Stopped' then-- new == 'Stopping' and (old == 'TopSpeed' or old == 'Cruise') then
                    self:StartSpecAnim(bpDisplay.AnimationsIdle.WalkEnd, bpDisplay.AnimationWalkRate, 'Animator', 'FinishMovementLoop', true)
                end
            elseif layer == 'Water' then
                if new ~= 'Stopped' and new ~= 'Stopping' then
                    self:StartSpecAnim(bpDisplay.AnimationsMove.Swim, bpDisplay.AnimationSwimRate, 'Animator', 'FinishMovementLoop')
                elseif new == 'Stopping' or new == 'Stopped' then
                    self:StartSpecAnim(bpDisplay.AnimationsMove.Swim, bpDisplay.AnimationSwimRate, 'Animator', 'FinishMovementLoop', true)
                end
            end
        else
            if self.TallStance then
                self:StartSpecAnim(bpDisplay.AnimationsIdle.Wag.Animation, bpDisplay.AnimationsIdle.Wag.Rate, 'IdleAnimator', 'FinishIdleLoop')
            else
                self:StartSpecAnim(bpDisplay.AnimationsIdle.Bob.Animation, bpDisplay.AnimationsIdle.Bob.Rate, 'IdleAnimator', 'FinishIdleLoop')
            end
        end
    end,

    LayerTransform = function(self, land)
        if not self.TransformAnimator then
            self.TransformAnimator = CreateAnimator(self)
        end

        if land then
            self:AddToggleCap('RULEUTC_WeaponToggle')
            self:SetSpeedMult(1)
            self:SetImmobile(true)
            local dur = __blueprints[self.BpId].Physics.LayerTransitionDuration
            self.TransformAnimator:PlayAnim(__blueprints[self.BpId].Display.AnimationTransformWaterLand):SetRate(-self.TransformAnimator:GetAnimationDuration() / dur):SetAnimationFraction(1)
            coroutine.yield(dur * 10)
            self:SetImmobile(false)
            self:RevertCollisionShape()
        else
            if self.TallStance then
                self:SetScriptBit('RULEUTC_WeaponToggle', false)
            end
            self:RemoveToggleCap('RULEUTC_WeaponToggle')
            self:SetSpeedMult(__blueprints[self.BpId].Physics.WaterSpeedMultiplier)
            self:SetImmobile(true)
            local dur = __blueprints[self.BpId].Physics.LayerTransitionDuration
            self.TransformAnimator:PlayAnim(__blueprints[self.BpId].Display.AnimationTransformLandWater):SetRate(self.TransformAnimator:GetAnimationDuration() / dur):SetAnimationFraction(0)
            coroutine.yield(dur * 10)
            self:SetImmobile(false)
            ---Collision box partially in the water
            local bp = __blueprints[self.BpId]
            self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0, bp.CollisionOffsetYSwim or 1, bp.CollisionOffsetZ or 0, bp.SizeX * 0.5, bp.SizeY * 0.5, bp.SizeZ * 0.5)
        end
        KillThread(self.TransformThread)
        self.TransformThread = nil
    end,

    ----------------------------------------------------------------------------
    -- Ability handlers
    ----------------------------------------------------------------------------
    SetExoskeleton = function(self, active)
        local bones = {
            'Carapace',
            'Tergum_001',
            'Tergum_002',
            'Tergum_003',
            'Telson',
        }
        for i, bone in bones do
            if active then
                self:ShowBone(bone, true)
            else
                self:HideBone(bone, true)
            end
        end
        local wep
        for i = 1, self:GetWeaponCount() do
            wep = self:GetWeapon(i)
            if (wep:GetBlueprint().Label == 'SmallGun') then
                wep:SetWeaponEnabled(active)
                wep:AimManipulatorSetEnabled(active)
            end
        end
        if active then
            self:AlterArmor('Normal', 1)
        else
            self:AlterArmor('Normal', 1.2)
        end
    end,

    SetWeaponStance = function(self, tall)
        if tall == nil then tall = self:GetScriptBit('RULEUTC_WeaponToggle') end
        if tall ~= self.TallStance then
            --------------------------------------------------------------------
            -- Setup
            --------------------------------------------------------------------
            if not self.TallStanceAnimator then
                self.TallStanceAnimator = CreateAnimator(self):PlayAnim(__blueprints[self.BpId].Display.AnimationTallStance):SetRate(0)
            end
            self.TallStance = tall
            --Psudo buff function
            local ChangeWeaponRadii = function(self, Key)
                for i = 1, self:GetWeaponCount() do
                    local wep = self:GetWeapon(i)
                    wep:ChangeMaxRadius(wep:GetBlueprint()[Key or 'MaxRadius'])
                end
            end
            --------------------------------------------------------------------
            -- Getting taller stuff
            --------------------------------------------------------------------
            if self.TallStance then
                self.TallStanceAnimator:SetRate(1)
                self:GracefullyKillSpecAnim('IdleAnimator', 'FinishIdleLoop')
                ----------------------------------------------------------------
                -- Kill anything waiting to happen from shrinking
                if self.ShortBuffWaitThread then
                    KillThread(self.ShortBuffWaitThread)
                end

                ----------------------------------------------------------------
                -- Do stuff we want to happen at the start of the animation
                local bp = __blueprints[self.BpId]
                self:SetSpeedMult(bp.Physics.TallSpeedMultiplier)
                -- Large box that coveres top and bottom positions
                self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0, (bp.CollisionOffsetY or 0) + bp.SizeY, bp.CollisionOffsetZ or 0,
                bp.SizeX * 0.5, (bp.SizeY + (bp.CollisionOffsetYTall or 0) - (bp.CollisionOffsetY or 0) ) * 0.5, bp.SizeZ * 0.5)

                self:SetMaintenanceConsumptionActive()
                ----------------------------------------------------------------
                -- Effects thread, also resource monitor
                if not self.TallEffectThread then
                    self.TallEffectThread = self:ForkThread(function()

                        if not self.TallSteamEffectBag then
                            self.TallSteamEffectBag = {}
                        end

                        local bones = {'Leg_Upper_001', 'Leg_Upper_002', 'Leg_Upper_003', 'Leg_Upper_004', 'Leg_Upper_005',
                                           'Leg_Upper_006', 'Leg_Upper_007', 'Leg_Upper_008', 'Leg_Upper_009', 'Leg_Upper_010'}
                        while not self.Dead do
                            EffectUtil.CleanupEffectBag(self, 'TallSteamEffectBag')
                            for i, b in bones do
                                table.insert(self.TallSteamEffectBag, CreateAttachedEmitter(self, b, self:GetArmy(), '/effects/emitters/dirty_exhaust_smoke_01_emit.bp'))
                            end
                            --Check everything is being paid for while we wait for the next effect time.
                            for i = 1, 4 do
                                coroutine.yield(10)
                                if self:GetResourceConsumed() ~= 1 then
                                    self:SetScriptBit('RULEUTC_WeaponToggle', false)
                                end
                            end
                        end
                    end)
                end
                ----------------------------------------------------------------
                -- Set up the when-tall effects
                self.TallBuffWaitThread = self:ForkThread(function()
                    coroutine.yield(
                        self.TallStanceAnimator:GetAnimationDuration()
                        / self.TallStanceAnimator:GetRate()
                        * (1 - self.TallStanceAnimator:GetAnimationFraction())
                        * 10
                     )
                    ChangeWeaponRadii(self, 'MaxRadiusTall')
                    local bp = __blueprints[self.BpId]
                    --High up box that covers the body and all target bones at the top position
                    self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0, (bp.CollisionOffsetYTall or 0) + bp.SizeY * 0.5, bp.CollisionOffsetZ or 0, bp.SizeX * 0.5, bp.SizeY * 0.5, bp.SizeZ * 0.5)
                end)
            --------------------------------------------------------------------
            -- Getting shorter stuff
            --------------------------------------------------------------------
            else
                self.TallStanceAnimator:SetRate(-1)
                ----------------------------------------------------------------
                -- Kill anything waiting to happen from growing
                if self.TallBuffWaitThread then
                    KillThread(self.TallBuffWaitThread)
                end

                ----------------------------------------------------------------
                -- Do stuff we want to happen at the start of the animation
                ChangeWeaponRadii(self, 'MaxRadius')
                if self:GetCurrentLayer() ~= 'Water' then
                    --Water layer change will set it to the water mult, so don't touch here.
                    self:SetSpeedMult(1)
                end
               local bp = __blueprints[self.BpId]
                -- Large box that coveres top and bottom positions
                self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0, (bp.CollisionOffsetY or 0) + bp.SizeY, bp.CollisionOffsetZ or 0,
                bp.SizeX * 0.5, (bp.SizeY + (bp.CollisionOffsetYTall or 0) - (bp.CollisionOffsetY or 0) ) * 0.5, bp.SizeZ * 0.5)

                ----------------------------------------------------------------
                -- Set up the when-short again effects
                self.ShortBuffWaitThread = self:ForkThread(function()
                    coroutine.yield(math.max(1,
                        self.TallStanceAnimator:GetAnimationDuration()
                        / math.abs(self.TallStanceAnimator:GetRate())
                        * self.TallStanceAnimator:GetAnimationFraction()
                        * 10
                    ))
                    self:RevertCollisionShape()
                    if self.TallEffectThread then
                        KillThread(self.TallEffectThread)
                        self.TallEffectThread = nil
                    end
                    self:SetMaintenanceConsumptionInactive()
                end)
            end
        end
    end,
}

TypeClass = SSL0405
