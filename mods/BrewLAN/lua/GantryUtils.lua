--------------------------------------------------------------------------------
-- UI buildmode change function
--------------------------------------------------------------------------------
function BuildModeChange(self, mode)
    self:RestoreBuildRestrictions()
    ------------------------------------------------------------------------
    -- The "Stolen tech" clause
    ------------------------------------------------------------------------
    local aiBrain = self:GetAIBrain()
    local pos = self.CachePosition or self:GetPosition()
    local engineers
    if pos then
        engineers = aiBrain:GetUnitsAroundPoint(categories.ENGINEER, self:GetPosition(), 30, 'Ally' )
    end
    local stolentech = {
        CYBRAN = false,
        AEON = false,
        SERAPHIM = false,
        UEF = false,
    }
    for race, val in stolentech do
        if EntityCategoryContains(ParseEntityCategory(race), self) then
            stolentech[race] = true
        end
    end
    if type(engineers) == 'table' then
        for k, v in engineers do
            if EntityCategoryContains(categories.TECH3, v) then
                for race, val in stolentech do
                    if EntityCategoryContains(ParseEntityCategory(race), v) then
                        stolentech[race] = true
                    end
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
        if self.airmode then
            self:AddBuildRestriction(categories.NAVAL)
            self:AddBuildRestriction(categories.MOBILESONAR)
            self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
        else
            if Layer == 'Land' then
                self:AddBuildRestriction(categories.NAVAL)
                self:AddBuildRestriction(categories.MOBILESONAR)
            elseif Layer == 'Water' or Layer == 'Seabed' then
                self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
            end
            self:AddBuildRestriction(categories.AIR)
        end
    ------------------------------------------------------------------------
    -- AI functional restrictions (allows easier AI control)
    ------------------------------------------------------------------------
    else
        if Layer == 'Land' then
            self:AddBuildRestriction(categories.NAVAL)
            self:AddBuildRestriction(categories.MOBILESONAR)
        elseif Layer == 'Water' or Layer == 'Seabed' then
            self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
            --AI's can't handle the Atlantis
            self:AddBuildRestriction(categories.ues0401)
        end
    end
    self:RequestRefreshUI()
end
--------------------------------------------------------------------------------
-- AI control
--------------------------------------------------------------------------------
function AIStartOrders(self)
    local aiBrain = self:GetAIBrain()
    if aiBrain.BrainType != 'Human' then
        local uID = self:GetUnitId()
        self.Time = GetGameTimeSeconds()
        BuildModeChange(self)
        aiBrain:BuildUnit(self, ChooseExpimental(self), 1)
        --This probably causes a crash without sorian ai.
        --Probably fine because regular AI can't build this
        --But it could happen with another custom AI.
        local AINames = import('/lua/AI/sorianlang.lua').AINames
        if AINames[uID] then
            local num = Random(1, table.getn(AINames[uID]))
            self:SetCustomName(AINames[uID][num])
        end
    end
end

function AIControl(self, unitBeingBuilt)
    local aiBrain = self:GetAIBrain()
    if aiBrain.BrainType != 'Human' then
        if self.AIUnitControl then
            self.AIUnitControl(self, unitBeingBuilt, aiBrain)
        end
        aiBrain:BuildUnit(self, ChooseExpimental(self), 1)
    end
end

function ChooseExpimental(self)
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
end
--------------------------------------------------------------------------------
-- AI Cheats
--------------------------------------------------------------------------------
function AIStartCheats(self, Buff)
    local aiBrain = self:GetAIBrain()
    if aiBrain.BrainType != 'Human' then
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
end

function AICheats(self, Buff)
    --This is used by the Gantry Hax modules.
end
