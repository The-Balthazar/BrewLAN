--------------------------------------------------------------------------------
--  Summary:  The Gantry script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local TLandFactoryUnit = import('/lua/terranunits.lua').TLandFactoryUnit
--------------------------------------------------------------------------------
local explosion = import('/lua/defaultexplosions.lua')
local Utilities = import('/lua/utilities.lua')
--------------------------------------------------------------------------------
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local Buff = import(BrewLANPath .. '/lua/legacy/VersionCheck.lua').Buff
local GantryUtils = import(BrewLANPath .. '/lua/GantryUtils.lua')
local BuildModeChange = GantryUtils.BuildModeChange
local AIStartOrders = GantryUtils.AIStartOrders
local AIControl = GantryUtils.AIControl
local AIStartCheats = GantryUtils.AIStartCheats
local AICheats = GantryUtils.AICheats
--------------------------------------------------------------------------------
SEB0401 = Class(TLandFactoryUnit) {
--------------------------------------------------------------------------------
-- Function triggers
--------------------------------------------------------------------------------
    OnCreate = function(self)
        TLandFactoryUnit.OnCreate(self)
        BuildModeChange(self)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        AIStartCheats(self, Buff)
        TLandFactoryUnit.OnStopBeingBuilt(self, builder, layer)
        AIStartOrders(self)
    end,

    OnLayerChange = function(self, new, old)
        TLandFactoryUnit.OnLayerChange(self, new, old)
        BuildModeChange(self)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        AICheats(self, Buff)
        TLandFactoryUnit.OnStartBuild(self, unitBeingBuilt, order)
        BuildModeChange(self)
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        self.UnitControl(self, unitBeingBuilt)
        TLandFactoryUnit.OnStopBuild(self, unitBeingBuilt)
        AIControl(self, unitBeingBuilt)
        BuildModeChange(self)
    end,
--------------------------------------------------------------------------------
-- Button controls
--------------------------------------------------------------------------------
    OnScriptBitSet = function(self, bit)
        TLandFactoryUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.airmode = true
            BuildModeChange(self)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandFactoryUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self.airmode = false
            BuildModeChange(self)
        end
    end,

    OnPaused = function(self)
        TLandFactoryUnit.OnPaused(self)
        self:StopBuildFx(self:GetFocusUnit())
    end,

    OnUnpaused = function(self)
        TLandFactoryUnit.OnUnpaused(self)
        if self:IsUnitState('Building') then
            self:StartBuildFx(self:GetFocusUnit())
        end
    end,
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
        if uBB:GetUnitId() == 'uel0309' then
            self:ForkThread(
                function()
                    IssueClearCommands({uBB})
                    for i = 1, 40 do
                        if uBB:CanBuild('xeb0204') then
                            self.MookBuild(self, aiBrain, uBB, 'xeb0204')
                        elseif uBB:CanBuild('xeb0104') then
                            self.MookBuild(self, aiBrain, uBB, 'xeb0104')
                        else
                            break
                        end
                    end
                    IssueGuard({uBB}, self)
                end
            )
        elseif uBB:GetUnitId() == 'sel0319' then
            self:ForkThread(
                function()
                    IssueClearCommands({uBB})
                    self.MookBuild(self, aiBrain, uBB, 'ueb4301')
                    IssueGuard({uBB}, self)
                end
            )
        elseif uBB:GetUnitId() == self.AcceptedRequests[1][1] then
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

    --The AI ignores this bit when it is important. Or rather, cancels the orders.
    MookBuild = function(self, aiBrain, mook, building)
        local pos = self:GetPosition()
        local bp = self:GetBlueprint()

        local x = bp.Physics.SkirtSizeX / 2 + (math.random(1,5)*2)
        local z = bp.Physics.SkirtSizeZ / 2 + (math.random(1,5)*2)
        local sign = -1 + 2 * math.random(0, 1)
        local BuildGoalX = 0
        local BuildGoalZ = 0
        if math.random(0, 1) > 0 then
            BuildGoalX = sign * x
            BuildGoalZ = math.random(math.ceil(-z/2),math.ceil(z/2))*2
        else
            BuildGoalX = math.random(math.ceil(-x/2),math.ceil(x/2))*2
            BuildGoalZ = sign * z
        end
        aiBrain:BuildStructure(mook, building, {pos[1]+BuildGoalX, pos[3]+BuildGoalZ, 0})
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
        TLandFactoryUnit.DeathThread(self, overkillRatio, instigator)
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
