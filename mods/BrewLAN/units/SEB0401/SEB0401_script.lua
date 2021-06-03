--------------------------------------------------------------------------------
--  Summary:  The Gantry script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local BrewLANExperimentalFactoryUnit = import('/lua/defaultunits.lua').BrewLANExperimentalFactoryUnit
--------------------------------------------------------------------------------
local TLFCreateBuildEffects = import('/lua/terranunits.lua').TLandFactoryUnit.CreateBuildEffects
local explosion = import('/lua/defaultexplosions.lua')
--------------------------------------------------------------------------------
SEB0401 = Class(BrewLANExperimentalFactoryUnit) {
--------------------------------------------------------------------------------
-- Function triggers
--------------------------------------------------------------------------------
    OnCreate = function(self)
        BrewLANExperimentalFactoryUnit.OnCreate(self)
        self.AimBones = {}
        for i = 1, 8 do
            --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
            local m = math.abs(((math.mod(i-1,4)+1)*2)-5)
            --self.AimBones[i] = {CreateRotator(self, 'ArmA_00'..i, 'z', 0, 20 * m, 5 * m), 'ArmA_00'..i}
            self.AimBones[i] = CreateRotator(self, 'ArmA_00'..i, 'z', 0, 20 * m, 5 * m)
        end
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        BrewLANExperimentalFactoryUnit.OnStopBuild(self, unitBeingBuilt)
        self:UnitControl(unitBeingBuilt)
    end,

    CreateBuildEffects = TLFCreateBuildEffects,

--------------------------------------------------------------------------------
-- Unit control
--------------------------------------------------------------------------------
    UnitControl = function(self, uBB)
        local IDcheck = function(uBB, id) return uBB and uBB:GetUnitId() == id end
        if IDcheck(uBB,'ues0401') then
            IssueDive({uBB})
        end
    end,

--------------------------------------------------------------------------------
-- AI Unit control
--------------------------------------------------------------------------------
    --This is called by AI control if this exists
    --Which is called on stop build
    AIUnitControl = function(self, uBB, aiBrain)
        if uBB:GetUnitId() == self.AcceptedRequests[1][1] then
            if not self.AcceptedRequests[1][2]:IsDead() then
                IssueGuard({uBB}, self.AcceptedRequests[1][2])
            --Something for passing along the requested units here, and/or, for sharing them out.
            --else
            --    for i,v in self.AcceptedRequests do
            --        if not
            --    end
            end
            table.remove(self.AcceptedRequests, 1)
        end
    end,

--------------------------------------------------------------------------------
-- Animations
--------------------------------------------------------------------------------
    StartBuildFx = function(self, unitBeingBuilt)
        if not unitBeingBuilt then
            unitBeingBuilt = self:GetFocusUnit()
        end
        --Start build process
        if not self.BuildAnimManip then
            self.BuildAnimManip = CreateAnimator(self)
            self.BuildAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationBuild, true):SetRate(0)
            self.Trash:Add(self.BuildAnimManip)
        end
        self.BuildAnimManip:SetRate(1)

        local size = math.min(math.max((unitBeingBuilt:GetBlueprint().SizeZ or 1) * 0.5, 1), 10)--0.1666
        for i, ro in self.AimBones do
            --local tmin = function(t1, t2) return {t1[1]-t2[1], t1[2]-t2[2], t1[3]-t2[3]} end
            --local rel = tmin(self:GetPosition(), self:GetPosition(ro[2]))

            local m = (((math.mod(i-1,4)+1)*2)-5) -- * size -- -12.5 *
            ro:SetGoal(-2.5 * m * (5-size) )
            --LOG(repr(rel),math.atan(rel[3]/rel[1]) * -57.2958)
            --ro[1]:SetGoal(math.atan((size - rel[3])/rel[1]) * -57.2958)
        end
    end,

    StopBuildFx = function(self)
        if self.BuildAnimManip then
            self.BuildAnimManip:SetRate(0)
        end
    end,

    DeathThread = function(self, overkillRatio, instigator)
        for i = 1, 8 do
            local r = 1 - 2 * math.random(0,1)
            local a = 'ArmA_00' .. i
            local b = 'ArmB_00' .. i
            local c = 'ArmC_00' .. i
            local d = 'Nozzle_00' .. i
            self:ForkThread(self.Flailing, a, math.random(10,20), 'z', r)
            self:ForkThread(self.Flailing, b, math.random(25,45), 'x', r)
            self:ForkThread(self.Flailing, c, math.random(30,45), 'x', r)
            self:ForkThread(self.Flailing, d, math.random(35,45), 'x', r)
        end
        BrewLANExperimentalFactoryUnit.DeathThread(self, overkillRatio, instigator)
    end,

    Flailing = function(self, bone, a, d, r)
        local rotator = CreateRotator(self, bone, d)
        self.Trash:Add(rotator)
        rotator:SetGoal(a*r)
        local b = a*5
        local c = a*15
        rotator:SetSpeed(math.random(b,c))
        WaitFor(rotator)
        local m = 1
        local l = (a+a)*(r*-1)
        local i = (a+a)*r
        while true do
            local f = math.random(b*m,c*m)
            m = m + (math.random(1,2)/10)
            rotator:SetGoal(l)
            rotator:SetSpeed(f)
            WaitFor(rotator)
            rotator:SetGoal(i)
            rotator:SetSpeed(f)
            if f > 1000 then
                self.effects = {
                    '/effects/emitters/terran_bomber_bomb_explosion_06_emit.bp',
                    '/effects/emitters/flash_05_emit.bp',
                    '/effects/emitters/destruction_explosion_fire_01_emit.bp',
                    '/effects/emitters/destruction_explosion_fire_plume_01_emit.bp',
                }
                for k, v in self.effects do
                    CreateEmitterAtBone(self, bone, self:GetArmy(), v)
                end
                self:Fling(bone, f)
                f = 0
            end
            WaitFor(rotator)
        end
    end,

    Fling = function(self, bone)
        --[[
        local spinner = CreateRotator()
        self.detector = CreateCollisionDetector(self)
        self.Trash:Add(self.detector)
        self.detector:WatchBone(bone)
        self.detector:EnableTerrainCheck(true)
        self.detector:Enable()
        --]]
        self:HideBone(bone, true)
    end,

    --[[OnAnimTerrainCollision = function(self, bone,x,y,z)
        DamageArea(self, {x,y,z}, 1, 250, 'Default', true, false)
        explosion.CreateDefaultHitExplosionAtBone( self, bone, 1.0 )
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
    end,]]--
}

TypeClass = SEB0401
