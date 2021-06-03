--------------------------------------------------------------------------------
--  Summary  :  Aeon Independence Engine script
--  Author   :  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local BrewLANExperimentalFactoryUnit = import('/lua/defaultunits.lua').BrewLANExperimentalFactoryUnit
--------------------------------------------------------------------------------
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
--------------------------------------------------------------------------------
SAB0401 = Class(BrewLANExperimentalFactoryUnit) {
--------------------------------------------------------------------------------
-- Function triggers
--------------------------------------------------------------------------------
    OnCreate = function(self)
        self.BLFactoryAirMode = true
        BrewLANExperimentalFactoryUnit.OnCreate(self)
        local bp = __blueprints.sab0401
        self:SetCollisionShape(
            'Sphere',
            bp.CollisionSphereOffsetX or 0,
            bp.CollisionSphereOffsetY or 0,
            bp.CollisionSphereOffsetZ or 0,
            bp.SizeSphere
        )
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        BrewLANExperimentalFactoryUnit.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(self.PlatformRaisingThread)
    end,

--------------------------------------------------------------------------------
-- Animations
--------------------------------------------------------------------------------
    StartBuildFx = function(self, unitBeingBuilt)
        if not unitBeingBuilt then
            unitBeingBuilt = self:GetFocusUnit()
        end
        local thread = self:ForkThread( self.CreateAeonFactoryBuildingEffects, unitBeingBuilt, __blueprints.sab0401.General.BuildBones.BuildEffectBones, 'Attachpoint', self.BuildEffectsBag )
        unitBeingBuilt.Trash:Add( thread )
    end,

    PlatformRaisingThread = function(self)
        --CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed, [worldspace]
        --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
        --local bRotator = CreateRotator(self, 'Builder_Node', 'y', 0, 1000, 100, 1000)

        -- Create the animation sliders
        local pSlider = CreateSlider(self, 'Platform', 0, 0, 0, 2.94, true)
        local nSliders = {}
        for i = 1, 8 do
            nSliders[i] = CreateSlider(self, 'Builder_00' .. i, 0, 0, 0, 14.7, true)
        end

        -- Define some mesh constants; the sliders are world-space so this is to measure clipping/floating
        -- Define outside of the only function that uses them so they only get calculated once, since it's ran a lot.
        local platformPos = 5 * __blueprints.sab0401.Display.UniformScale -- 1.47
        local pMaxHeight = 32 * __blueprints.sab0401.Display.UniformScale -- 9.408

        -- Quick function to avoid calling get blueprint if we can
        local GetBP = function(unitBeingBuilt)
            return (__blueprints[unitBeingBuilt.BpId] or unitBeingBuilt:GetBlueprint())
        end

        -- Quick calculation for the max height the platform could be at.
        local GetPMaxHeight = function(unitBeingBuilt)
            --Avoid global lookup
            local mmin = math.min
            local mmax = math.max
            return mmin(pMaxHeight, mmax(( GetBP(unitBeingBuilt).Physics.Elevation or 0), 0) - platformPos)
        end

        -- Variable storage
        local unitBeingBuilt
        local buildState = 'start'
        local uBBF
        local pSliderPos
        local bSliderPos

        -- Give me the lööps bröther
        while self do
            unitBeingBuilt = self:GetFocusUnit()
            if unitBeingBuilt then
                if buildState == 'start' or buildState == 'active' and GetBP(unitBeingBuilt).Physics.MotionType == 'RULEUMT_Air' then
                    uBBF = math.max(unitBeingBuilt:GetFractionComplete() - 0.8, 0) * 5
                    buildState = 'active'
                elseif GetBP(unitBeingBuilt).Physics.MotionType == 'RULEUMT_Air' then
                    uBBF = 1
                else
                    uBBF = 0
                end
                pSliderPos = uBBF * GetPMaxHeight(unitBeingBuilt)
                if math.random(1,15) == 10 then
                    --bRotator:SetGoal(math.random(1,3) * 22.5 - 22.5 )
                    for i, slider in nSliders do
                        if math.random(1,8) ~= 8 then
                            bSliderPos = GetPMaxHeight(unitBeingBuilt) * RandomFloat(0,1) * ((1 - uBBF) * .75)
                            slider:SetGoal(0, bSliderPos ,0)
                        end
                    end
                end
            else
                coroutine.yield(3) -- If there is something building after 3 ticks, then assume inf build and stay up.
                if (buildState == 'active' or buildState == 'repeat') and self:GetFocusUnit() then
                    buildState = 'repeat'
                else
                    buildState = 'start'
                    pSliderPos = 0
                end
            end
            pSlider:SetGoal(0,pSliderPos,0)
            coroutine.yield(1)
        end
    end,

    CreateAeonFactoryBuildingEffects = function( builder, unitBeingBuilt, BuildEffectBones, BuildBone, EffectsBag )
        local army = builder:GetArmy()
        for kBone, vBone in BuildEffectBones do
            EffectsBag:Add( CreateAttachedEmitter( builder, vBone, army, '/effects/emitters/aeon_build_03_emit.bp' ) )
            for kBeam, vBeam in EffectTemplate.AeonBuildBeams02 do
                local beamEffect = AttachBeamEntityToEntity(builder, vBone, builder, BuildBone, army, vBeam )
                EffectsBag:Add(beamEffect)
            end
        end
    end,

    FinishBuildThread = function(self, unitBeingBuilt, order)
        if EntityCategoryContains(categories.LAND * categories.EXPERIMENTAL, unitBeingBuilt) and self.PermOpenAnimManipulator then
            self:SetBusy(true)
            self:SetBlockCommandQueue(true)

            self.PermOpenAnimManipulator:SetRate(-1)
            coroutine.yield(1)
            WaitFor(self.PermOpenAnimManipulator)

            if unitBeingBuilt and not unitBeingBuilt.Dead then
                unitBeingBuilt:DetachFrom(true)
            end
            self:DetachAll(__blueprints.sab0401.Display.BuildAttachBone or 'Attachpoint')
            self:DestroyBuildRotator()

            ChangeState(self, self.RollingOffState)
        else
            BrewLANExperimentalFactoryUnit.FinishBuildThread(self, unitBeingBuilt, order)
        end
    end,

    PlayFxRollOffEnd = function(self)
        if self.PermOpenAnimManipulator then
            self.PermOpenAnimManipulator:SetRate(1)
            WaitFor(self.PermOpenAnimManipulator)
        end
    end,
}

TypeClass = SAB0401
