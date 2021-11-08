--------------------------------------------------------------------------------
-- Copyright : Sean 'Balthazar' Wheeldon
-- Gantry class experimental factory structures
--------------------------------------------------------------------------------
local FactoryUnit = import('/lua/defaultunits.lua').FactoryUnit
local EntityCategoryContains = EntityCategoryContains
local Buff

do -- Original SupCom error prevention
    local ver = string.sub(GetVersion(),1,3)
    if ver == '1.1' or ver == '1.0' then
        Buff = {
            ApplyBuff = function() end,
            RemoveBuff = function() end,
        }
    else
        Buff = import('/lua/sim/Buff.lua')
    end
end

local FactionCategories = {}
for i, data in import('/lua/factions.lua').Factions do
    FactionCategories[i] = data.Category
end

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

ExperimentalFactoryUnit = Class(FactoryUnit) {
    ----------------------------------------------------------------------------
    -- RefreshBuildList
    -- From GantryUtils, formerly named BuildModeChange
    ----------------------------------------------------------------------------
    RefreshBuildList = function(self)
        self:RestoreBuildRestrictions()
        ------------------------------------------------------------------------
        -- The "Stolen tech" clause
        ------------------------------------------------------------------------
        local function EntitiesCategoryContains(cat, ents)
            if ents[1] then
                for k, v in ents do
                    if EntityCategoryContains(cat, v) then
                        return true
                    end
                end
            end
        end

        local aiBrain = self:GetAIBrain()
        local sharetech = aiBrain:GetUnitsAroundPoint(
            categories.GANTRYSHARETECH
            or
            (categories.ENGINEER + categories.FACTORY) *
            (categories.TECH3 + categories.EXPERIMENTAL),
            self.CachePosition or self:GetPosition(), 30, 'Ally'
        )

        for i, race in FactionCategories do
            if not EntitiesCategoryContains(categories[race], sharetech) then
                self:AddBuildRestriction(categories[race])
            end
        end
        ------------------------------------------------------------------------
        -- Human UI air/other switch
        ------------------------------------------------------------------------
        local Layer = self:GetCurrentLayer()

        local land = categories.LAND - categories.ENGINEER - categories.NAVAL
        local naval = categories.NAVAL + categories.MOBILESONAR - categories.LAND
        local surface = categories.LAND - categories.ENGINEER + categories.NAVAL + categories.MOBILESONAR

        if aiBrain.BrainType == 'Human' then
            if Layer == 'Air' or self.BLFactoryAirMode then
                self:AddBuildRestriction(surface)

            elseif Layer == 'Land' then
                self:AddBuildRestriction(naval + categories.AIR)

            elseif Layer == 'Water' or Layer == 'Sub' or Layer == 'Seabed' then
                self:AddBuildRestriction(land + categories.AIR)

            end
        ------------------------------------------------------------------------
        -- AI functional restrictions (allows easier AI control)
        ------------------------------------------------------------------------
        elseif Layer == 'Air' then
            self:AddBuildRestriction(surface)

        elseif Layer == 'Land' then
            self:AddBuildRestriction(naval)

        elseif Layer == 'Water' or Layer == 'Sub' or Layer == 'Seabed' then
            self:AddBuildRestriction(land + categories.ues0401) --AI's can't handle the Atlantis

        end

        self:RequestRefreshUI()
    end,

    ----------------------------------------------------------------------------
    -- AI control
    -- From GantryUtils
    ----------------------------------------------------------------------------
    AIStartOrders = function(self)
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType ~= 'Human' then
            local BpId = self.BpId or self:GetUnitId()
            self.Time = GetGameTimeSeconds()
            aiBrain:BuildUnit(self, self:ChooseExpimental(), 1)
            pcall(function(self)
                local AINames = import('/mods/BrewLAN/lua/AI/AINames.lua').AINames
                if AINames[BpId] then
                    local num = Random(1, table.getn(AINames[BpId]))
                    self:SetCustomName(AINames[BpId][num])
                end
            end, self)
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
    end,

    ChooseExpimental = function(self)
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

        local bp = __blueprints[self.BpId] or self:GetBlueprint()
        local bpAirExp = bp.AI.Experimentals.Air
        local bpOtherExp = bp.AI.Experimentals.Other
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

        if self.Lastbuilt then
            return self.Lastbuilt
        end

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
                Buff.ApplyBuff(self, 'GantryAIxBaseBonus')
            else
                Buff.ApplyBuff(self, 'GantryAIBaseBonus')
            end
        end
    end,

    AICheats = function(self)
        --This is used by the Gantry Hax modules.
    end,

    ----------------------------------------------------------------------------
    -- Function hooks
    ----------------------------------------------------------------------------
    OnCreate = function(self)
        FactoryUnit.OnCreate(self)
        self:RefreshBuildList()
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        self:AIStartCheats()
        FactoryUnit.OnStopBeingBuilt(self, builder, layer)
        self:AIStartOrders()
        self:RefreshBuildList()
    end,

    OnLayerChange = function(self, new, old)
        FactoryUnit.OnLayerChange(self, new, old)
        self:RefreshBuildList()
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        self:AICheats()
        FactoryUnit.OnStartBuild(self, unitBeingBuilt, order)
        self:RefreshBuildList()
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        FactoryUnit.OnStopBuild(self, unitBeingBuilt)
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
        FactoryUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.BLFactoryAirMode = true
            self:RefreshBuildList()
        end
    end,

    OnScriptBitClear = function(self, bit)
        FactoryUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self.BLFactoryAirMode = nil
            self:RefreshBuildList()
        end
    end,

    OnPaused = function(self)
        FactoryUnit.OnPaused(self)
        self:StopBuildFx(self:GetFocusUnit())
    end,

    OnUnpaused = function(self)
        FactoryUnit.OnUnpaused(self)
        if self:IsUnitState('Building') then
            self:StartBuildFx(self:GetFocusUnit())
        end
    end,
}
