--------------------------------------------------------------------------------
--    Hook : /lua/defaultunits.lua
-- Summary : BrewLAN unit scripts used by multiple factions and multiple units
--  Author : Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- This prevents reference to Buff from causing errors on original SupCom.
-- It doesn't make it work, it just makes it not break.
--------------------------------------------------------------------------------
do
    local ver = string.sub(GetVersion(),1,3)
    if ver == '1.1' or ver == '1.0' then
        Buff = {
            ApplyBuff = function() end,
            RemoveBuff = function() end,
        }
    end
end

--------------------------------------------------------------------------------
-- This provides support for non-standard factions
--------------------------------------------------------------------------------
local FactionCategories = {}

for i, data in import('/lua/factions.lua').Factions do
    FactionCategories[data.Category] = false
end

--------------------------------------------------------------------------------
-- Experimental Factory class.
-- Ported from the util file /BrewLAN/lua/GantryUtils.lua
--------------------------------------------------------------------------------
local OldBrewLANExperimentalFactoryUnit = FactoryUnit

--------------------------------------------------------------------------------
-- This is so that it will load changes from the Hax modules even if they are loaded before BrewLAN.
--------------------------------------------------------------------------------
do
    local ok, retclass = pcall(function()
        --if BrewLANExperimentalFactoryUnit then
            return BrewLANExperimentalFactoryUnit
        --end
    end)

    if ok then
        OldBrewLANExperimentalFactoryUnit = retclass
        WARN("BrewLAN detects a Gantry Hax module was loaded first. Picking up module changes.")
    else
        SPEW('Everything is as expected.')
    end
end


BrewLANExperimentalFactoryUnit = Class(OldBrewLANExperimentalFactoryUnit) {

    ----------------------------------------------------------------------------
    -- RefreshBuildList
    -- From GantryUtils, formerly named BuildModeChange
    ----------------------------------------------------------------------------
    RefreshBuildList = function(self)
        self:RestoreBuildRestrictions()
        ------------------------------------------------------------------------
        -- The "Stolen tech" clause
        ------------------------------------------------------------------------
        local aiBrain = self:GetAIBrain()
        local pos = self.CachePosition or self:GetPosition()
        local ParseEntityCategory = ParseEntityCategory
        local EntityCategoryContains = EntityCategoryContains
        local engineers
        if pos and categories.GANTRYSHARETECH then
            engineers = aiBrain:GetUnitsAroundPoint(
                (categories.GANTRYSHARETECH),
                pos, 30, 'Ally'
            )
        elseif pos then
            engineers = aiBrain:GetUnitsAroundPoint(
                (categories.ENGINEER + categories.FACTORY) *
                (categories.TECH3 + categories.EXPERIMENTAL),
                pos, 30, 'Ally'
            )
        end
        local stolentech = table.copy(FactionCategories)

        for race, val in stolentech do
            if EntityCategoryContains(ParseEntityCategory(race), self) then
                stolentech[race] = true
            end
        end
        if type(engineers) == 'table' then
            for k, v in engineers do
                for race, val in stolentech do
                    if EntityCategoryContains(ParseEntityCategory(race), v) then
                        stolentech[race] = true
                        --a break here would be less checks, but would cause issues with units with multiple faction categories.
                    end
                end
            end
        end
        for race, val in stolentech do
            if not val then
                self:AddBuildRestriction(categories[race])
            end
        end
        ------------------------------------------------------------------------
        -- Human UI air/other switch
        ------------------------------------------------------------------------
        local Layer = self:GetCurrentLayer()
        if aiBrain.BrainType == 'Human' then
            if self.BLFactoryAirMode then
                self:AddBuildRestriction(categories.NAVAL)
                self:AddBuildRestriction(categories.MOBILESONAR)
                self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
            else
                if Layer == 'Land' then
                    self:AddBuildRestriction(categories.NAVAL - categories.LAND)
                    self:AddBuildRestriction(categories.MOBILESONAR)
                elseif Layer == 'Water' or Layer == 'Seabed' then
                    self:AddBuildRestriction(categories.LAND - categories.ENGINEER - categories.NAVAL)
                end
                self:AddBuildRestriction(categories.AIR)
            end
        ------------------------------------------------------------------------
        -- AI functional restrictions (allows easier AI control)
        ------------------------------------------------------------------------
        else
            if Layer == 'Land' then
                self:AddBuildRestriction(categories.NAVAL - categories.LAND)
                self:AddBuildRestriction(categories.MOBILESONAR)
            elseif Layer == 'Water' or Layer == 'Seabed' then
                self:AddBuildRestriction(categories.LAND - categories.ENGINEER - categories.NAVAL)
                --AI's can't handle the Atlantis
                self:AddBuildRestriction(categories.ues0401)
            end
        end
        self:RequestRefreshUI()

        if OldBrewLANExperimentalFactoryUnit.RefreshBuildList then
            OldBrewLANExperimentalFactoryUnit.RefreshBuildList(self)
        end
    end,

    ----------------------------------------------------------------------------
    -- AI control
    -- From GantryUtils
    ----------------------------------------------------------------------------
    AIStartOrders = function(self)
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType ~= 'Human' then
            local uID = self:GetUnitId()
            self.Time = GetGameTimeSeconds()
            self:RefreshBuildList()
            aiBrain:BuildUnit(self, self:ChooseExpimental(), 1)
            pcall(function(self)
                local AINames = import('/mods/BrewLAN/lua/AI/AINames.lua').AINames
                if AINames[uID] then
                    local num = Random(1, table.getn(AINames[uID]))
                    self:SetCustomName(AINames[uID][num])
                end
            end, self)
        end

        if OldBrewLANExperimentalFactoryUnit.AIStartOrders then
            OldBrewLANExperimentalFactoryUnit.AIStartOrders(self)
        end
    end,

    AIControl = function(self, unitBeingBuilt)
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType ~= 'Human' then
            if self.AIUnitControl then
                self.AIUnitControl(self, unitBeingBuilt, aiBrain)
            end
            aiBrain:BuildUnit(self, self:ChooseExpimental(), 1)
        end
        if OldBrewLANExperimentalFactoryUnit.AIControl then
            OldBrewLANExperimentalFactoryUnit.AIControl(self, unitBeingBuilt)
        end
    end,

    ChooseExpimental = function(self)
        if OldBrewLANExperimentalFactoryUnit.ChooseExpimental then
            OldBrewLANExperimentalFactoryUnit.ChooseExpimental(self)
        end
        if not self.RequestedUnits then self.RequestedUnits = {} end
        if not self.AcceptedRequests then self.AcceptedRequests = {} end
        if not self.BuiltUnitsCount then self.BuiltUnitsCount = 1 else self.BuiltUnitsCount = self.BuiltUnitsCount + 1 end
        local bp = self:GetBlueprint()
        local buildorder = bp.AI.BuildOrder

        if type(buildorder[self.BuiltUnitsCount]) == 'string' and self:CanBuild(buildorder[self.BuiltUnitsCount]) then
            return buildorder[self.BuiltUnitsCount]
        end

        if self.RequestedUnits[1] and math.mod(self.BuiltUnitsCount, 2) == 0 then
            local req = self.RequestedUnits[1][1]
            table.insert(self.AcceptedRequests,self.RequestedUnits[1])
            table.remove(self.RequestedUnits, 1)
            if type(req) == 'string' and self:CanBuild(req) then
                return req
            end
        end

        local BuildBackups = bp.AI.BuildBackups

        if self:GetAIBrain():GetNoRushTicks() > 1500 and type(BuildBackups.EarlyNoRush) == 'string' and self:CanBuild(BuildBackups.EarlyNoRush) then
            return BuildBackups.EarlyNoRush
        end

        local bpAirExp = self:GetBlueprint().AI.Experimentals.Air
        local bpOtherExp = self:GetBlueprint().AI.Experimentals.Other
        if not self.ExpIndex then self.ExpIndex = {math.random(1, table.getn(bpAirExp)),math.random(1, table.getn(bpOtherExp)),} end

        if not self.togglebuild then
            for i=1,2 do
                for i, v in bpAirExp do
                    if self.ExpIndex[1] <= i then
                        --LOG('Current cycle = ', v[1])
                        if not bpAirExp[i+1] then
                            self.ExpIndex[1] = 1
                        else
                            self.ExpIndex[1] = i + 1
                        end
                        if type(v[1]) == 'string' and self:CanBuild(v[1]) then
                            self.togglebuild = true
                            self.Lastbuilt = v[1]
                            --LOG('Returning air chosen = ', v[1])
                            return v[1]
                        end
                    end
                end
            end
            --only reaches here if it can't build any air experimentals
            self.togglebuild = true
            --LOG('Gantry failed to find experimental fliers')
        end
        if self.togglebuild then
            for i=1,2 do
                for i, v in bpOtherExp do
                    if self.ExpIndex[2] <= i then
                        --LOG('Current cycle = ', v[1])
                        if not bpOtherExp[i+1] then
                            self.ExpIndex[2] = 1
                        else
                            self.ExpIndex[2] = i + 1
                        end
                        if type(v[1]) == 'string' and self:CanBuild(v[1]) then
                            self.togglebuild = false
                            self.Lastbuilt = v[1]
                            --LOG('Returning land chosen= ', v[1])
                            return v[1]
                        end
                    end
                end
            end
            --Only reaches this if it can't build any non-fliers
            self.togglebuild = false
            --LOG('Gantry failed to find non-flying experimentals')
        end
        --Attempts last successfull experimental, probably air at this point
        if self.Lastbuilt then
            --LOG('Returning last built = ', self.Lastbuilt)
            return self.Lastbuilt
        --If nothing else works, flip a coin and build an ASF or a bomber
        end
        --LAST RESORT TABLE
        for i, v in BuildBackups.LastResorts do
            if type(v) == 'string' and self:CanBuild(v) then
                return v
            end
        end
    end,

    ----------------------------------------------------------------------------
    -- AI Cheats
    -- From GantryUtils
    ----------------------------------------------------------------------------
    AIStartCheats = function(self)
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType ~= 'Human' then
            if aiBrain.CheatEnabled then
                if not Buffs['GantryAIxBaseBonus'] then
                    BuffBlueprint {
                        Name = 'GantryAIxBaseBonus',
                        DisplayName = 'GantryAIxBaseBonus',
                        BuffType = 'GANTRYBASICBONUS',
                        Stacks = 'REPLACE',
                        Duration = -1,
                        Affects = {
                            BuildRate = {
                                Add = 0,
                                Mult = 2.5,
                            },
                            EnergyActive = {
                                Add = -0.5,
                                Mult = 1,
                            },
                            MassActive = {
                                Add = -0.5,
                                Mult = 1,
                            },
                        },
                    }
                end
                Buff.ApplyBuff(self, 'GantryAIxBaseBonus')
            else
                if not Buffs['GantryAIBaseBonus'] then
                    BuffBlueprint {
                        Name = 'GantryAIBaseBonus',
                        DisplayName = 'GantryAIBaseBonus',
                        BuffType = 'GANTRYBASICBONUS',
                        Stacks = 'REPLACE',
                        Duration = -1,
                        Affects = {
                            BuildRate = {
                                Add = 0,
                                Mult = 2.5,
                            },
                        },
                    }
                end
                Buff.ApplyBuff(self, 'GantryAIBaseBonus')
            end
        end
        if OldBrewLANExperimentalFactoryUnit.AIStartCheats then
            OldBrewLANExperimentalFactoryUnit.AIStartCheats(self)
        end
    end,

    AICheats = function(self)
        --This is used by the Gantry Hax modules.
        if OldBrewLANExperimentalFactoryUnit.AICheats then
            OldBrewLANExperimentalFactoryUnit.AICheats(self)
        end
    end,

    ----------------------------------------------------------------------------
    -- Function hooks
    ----------------------------------------------------------------------------
    OnCreate = function(self)
        OldBrewLANExperimentalFactoryUnit.OnCreate(self)
        self:RefreshBuildList()
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        self:AIStartCheats()
        OldBrewLANExperimentalFactoryUnit.OnStopBeingBuilt(self, builder, layer)
        self:AIStartOrders()
    end,

    OnLayerChange = function(self, new, old)
        OldBrewLANExperimentalFactoryUnit.OnLayerChange(self, new, old)
        self:RefreshBuildList()
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        self:AICheats()
        OldBrewLANExperimentalFactoryUnit.OnStartBuild(self, unitBeingBuilt, order)
        self:RefreshBuildList()
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        OldBrewLANExperimentalFactoryUnit.OnStopBuild(self, unitBeingBuilt)
        self:AIControl(unitBeingBuilt)
        self:RefreshBuildList()
        self:UnitControl(unitBeingBuilt)
    end,

    ----------------------------------------------------------------------------
    -- Unit control
    ----------------------------------------------------------------------------
    UnitControl = function(self, uBB)
        if uBB:GetFractionComplete() == 1
        and (__blueprints[uBB.BpId] or uBB:GetBlueprint()).Physics.MotionType =='RULEUMT_SurfacingSub'
        and EntityCategoryContains(categories.EXPERIMENTAL, uBB)
        then
            IssueDive({uBB})
        end
    end,

    ----------------------------------------------------------------------------
    -- Button hooks
    ----------------------------------------------------------------------------
    OnScriptBitSet = function(self, bit)
        OldBrewLANExperimentalFactoryUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.BLFactoryAirMode = true
            self:RefreshBuildList()
        end
    end,

    OnScriptBitClear = function(self, bit)
        OldBrewLANExperimentalFactoryUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self.BLFactoryAirMode = nil
            self:RefreshBuildList()
        end
    end,

    OnPaused = function(self)
        OldBrewLANExperimentalFactoryUnit.OnPaused(self)
        self:StopBuildFx(self:GetFocusUnit())
    end,

    OnUnpaused = function(self)
        OldBrewLANExperimentalFactoryUnit.OnUnpaused(self)
        if self:IsUnitState('Building') then
            self:StartBuildFx(self:GetFocusUnit())
        end
    end,

}

local BrewLANGetSatFuelRatio = math.max(ScenarioInfo.size[1], ScenarioInfo.size[2]) / 4096

BrewLANGeoSatelliteUnit = Class(AirUnit) {

    OnStopBeingBuilt = function(self, ...)
        AirUnit.OnStopBeingBuilt(self, unpack(arg) )
        --Less fuel for smaller maps. Max fuel only on 81k.
        self:SetFuelRatio(BrewLANGetSatFuelRatio)
    end,

    OpenState = State() {
        Main = function(self)
            self.OpenAnim = CreateAnimator(self)
            self.Trash:Add( self.OpenAnim )

            local bp = __blueprints[self.BpId] or self:GetBlueprint()

            if bp.Display and bp.Display.AnimationOpenStage1 then
                self.OpenAnim:PlayAnim( bp.Display.AnimationOpenStage1 )
                WaitFor( self.OpenAnim )
            end

            if bp.Display and bp.Display.AnimationOpenHideBones then
                for k, v in bp.Display.AnimationOpenHideBones do
                    self:HideBone( v, true )
                end
            end

            if bp.Display and bp.Display.AnimationOpenStage2 then
                self.OpenAnim:PlayAnim( bp.Display.AnimationOpenStage2 )
                WaitFor( self.OpenAnim )
            end
        end,
    },

    StartUnguidedOrbitalDecay = function(self)
        if not self.UnguidedOrbitalDecay then
            self.UnguidedOrbitalDecay = self:ForkThread(
                function(self)
                    local pos = self:GetPosition()
                    while not self.Dead do
                        self:OnDamage(self, 2, pos, 'Decay')
                        coroutine.yield(2)
                    end
                end
            )
        end
    end,

    StopUnguidedOrbitalDecay = function(self)
        if self.UnguidedOrbitalDecay then
            KillThread(self.UnguidedOrbitalDecay)
            self.UnguidedOrbitalDecay = nil
        end
    end,

    OnRunOutOfFuel = function(self)
        AirUnit.OnRunOutOfFuel(self)
        self:SetSpeedMult(self:GetBlueprint().Physics.NoFuelSpeedMult)
        self:SetAccMult(1)
        self:SetTurnMult(1)
    end,

    OnLayerChange = function(self, new, old)
        AirUnit.OnLayerChange(self, new, old)
        if new == 'Air' and self:GetFractionComplete() == 1 then
            ChangeState( self, self.OpenState )
        end
    end,
}

ConstructionStructureUnit = Class(StructureUnit) {
    OnCreate = function(self)
        -- Structure stuff
        StructureUnit.OnCreate(self)

        --Construction stuff
        local bp = self:GetBlueprint()
        self.EffectsBag = {}
        if bp.General.BuildBones then
            self:SetupBuildBones()
        end

        -- Save build effect bones for faster access when creating build effects
        self.BuildEffectBones = bp.General.BuildBones.BuildEffectBones

        if bp.Display.AnimationOpen or bp.Display.AnimationBuild then
            self.BuildingOpenAnim = bp.Display.AnimationOpen or bp.Display.AnimationBuild
        end
        if self.BuildingOpenAnim then
            self.AnimationManipulator = CreateAnimator(self)
            self.AnimationManipulator:PlayAnim(self.BuildingOpenAnim, false):SetRate(0)
            self.Trash:Add(self.AnimationManipulator)
            if self.BuildArmManipulator then
                self.BuildArmManipulator:Disable()
            end
        end

        self.BuildingUnit = false
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order
        self.BuildingUnit = true
        if self.AnimationManipulator then
            self.AnimationManipulator:SetRate(1)
        end
        StructureUnit.OnStartBuild(self,unitBeingBuilt, order)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
        -- If created with F2 on land, then play the transform anim.
        if self:GetCurrentLayer() == 'Water' then
            self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, true)
        end
    end,

    -- This will only be called if not in StructureUnit's upgrade state
    OnStopBuild = function(self, unitBeingBuilt)
        StructureUnit.OnStopBuild(self, unitBeingBuilt)

        self.UnitBeingBuilt = nil
        self.UnitBuildOrder = nil

        if self.BuildingOpenAnimManip and self.BuildArmManipulator then
            self.StoppedBuilding = true
        elseif self.BuildingOpenAnimManip then
            self.AnimationManipulator:SetRate(-1)
        end

        self.BuildingUnit = false
    end,

    OnPaused = function(self)
        --When factory is paused take some action
        self:StopUnitAmbientSound( 'ConstructLoop' )
        StructureUnit.OnPaused(self)
        if self.BuildingUnit then
            self.StopBuildingEffects(self, self:GetUnitBeingBuilt())
        end
    end,

    OnUnpaused = function(self)
        if self.BuildingUnit then
            self:PlayUnitAmbientSound( 'ConstructLoop' )
            self.StartBuildingEffects(self, self:GetUnitBeingBuilt(), self.UnitBuildOrder)
        end
        StructureUnit.OnUnpaused(self)
    end,

    --[[OnProductionPaused = function(self)
        if self:IsUnitState('Building') then
            self:SetMaintenanceConsumptionInactive()
        end
        self:SetProductionActive(false)
    end,

    OnProductionUnpaused = function(self)
        if self:IsUnitState('Building') then
            self:SetMaintenanceConsumptionActive()
        end
        self:SetProductionActive(true)
    end,]]

    --[[StartBuildingEffects = function(self, unitBeingBuilt, order)
        StructureUnit.StartBuildingEffects(self, unitBeingBuilt, order)
    end,

    StopBuildingEffects = function(self, unitBeingBuilt)
        StructureUnit.StopBuildingEffects(self, unitBeingBuilt)
    end,]]

    WaitForBuildAnimation = function(self, enable)
        if self.BuildArmManipulator then
            WaitFor(self.BuildingOpenAnimManip)
            if enable then
                self.BuildArmManipulator:Enable()
            end
        end
    end,

    OnPrepareArmToBuild = function(self)
        StructureUnit.OnPrepareArmToBuild(self)

        if self.BuildingOpenAnimManip then
            self.BuildingOpenAnimManip:SetRate(self:GetBlueprint().Display.AnimationBuildRate or 1)
            if self.BuildArmManipulator then
                self.StoppedBuilding = nil
                ForkThread( self.WaitForBuildAnimation, self, true )
            end
        end
    end,

    OnStopBuilderTracking = function(self)
        StructureUnit.OnStopBuilderTracking(self)

        if self.StoppedBuilding then
            self.StoppedBuilding = nil
            self.BuildArmManipulator:Disable()
            self.BuildingOpenAnimManip:SetRate(-(self:GetBlueprint().Display.AnimationBuildRate or 1))
        end
    end,

    CheckBuildRestriction = function(self, target_bp)
        return self:CanBuild(target_bp.BlueprintId)
    end,

    CreateReclaimEffects = function( self, target )
		EffectUtil.PlayReclaimEffects( self, target, self.BuildEffectBones or {0,}, self.ReclaimEffectsBag )
    end,

    CreateReclaimEndEffects = function( self, target )
        EffectUtil.PlayReclaimEndEffects( self, target )
    end,

    CreateCaptureEffects = function( self, target )
		EffectUtil.PlayCaptureEffects( self, target, self.BuildEffectBones or {0,}, self.CaptureEffectsBag )
    end,
}

DirectionalWalkingLandUnit = Class(WalkingLandUnit) {
    OnMotionHorzEventChange = function( self, new, old )
        WalkingLandUnit.OnMotionHorzEventChange(self, new, old)
        if ( old == 'Stopped' ) and self.Animator then
            self.Animator:SetDirectionalAnim(true)
        end
    end,
}

FootprintDummyUnit = Class(StructureUnit) {
    OnAdjacentTo = function(self, AdjUnit, TriggerUnit)
        if not self.AdjacentData then self.AdjacentData = {} end
        table.insert(self.AdjacentData, AdjUnit)
        StructureUnit.OnAdjacentTo(self, AdjUnit, TriggerUnit)
    end,

    OnNotAdjacentTo = function(self, AdjUnit)
        if self.Parent then
            self.Parent.OnNotAdjacentTo(self.Parent, AdjUnit)
            AdjUnit:OnNotAdjacentTo(self.Parent)
            self.ForceDestroyAdjacentEffects({self.Parent, AdjUnit})
        end
        StructureUnit.OnNotAdjacentTo(self, AdjUnit)
    end,
}
