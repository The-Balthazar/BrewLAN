--------------------------------------------------------------------------------
-- Copyright : 2015‒2021 Sean 'Balthazar' Wheeldon
-- Wall, wall gates, and self-arming wall scripts
--------------------------------------------------------------------------------
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit

CardinalWallUnit = Class(StructureUnit) {
    OnCreate = function(self)
        self.CachePosition = self.CachePosition or table.copy(moho.entity_methods.GetPosition(self))
        self.BpId = self.BpId or self:GetBlueprint().BlueprintId

        self.Info = {
            ents = {
                ['North'] = { ent = {}, val = {false, 99 } },
                ['South'] = { ent = {}, val = {false, 101} },
                ['East'] = { ent = {}, val = {false, 97} },
                ['West'] = { ent = {}, val = {false, 103} },
            },
            bones = table.deepcopy(__blueprints[self.BpId].Display.AdjacencyConnectionInfo.Bones)
        }

        if __blueprints[self.BpId].Display.AdjacencyConnection then
            self.BeamEffectsBag = {}
        end
        self:BoneUpdate(self.Info.bones)
        StructureUnit.OnCreate(self)
    end,

    StartBeingBuiltEffects = function(self, builder, layer)
        StructureUnit.StartBeingBuiltEffects(self, builder, layer)
        if __blueprints[self.BpId].Display.Tarmacs[1] and self:GetCurrentLayer() == 'Land' and not self:HasTarmac() then
            self:CreateTarmac(true, true, true, self.TarmacBag and self.TarmacBag.Orientation, self.TarmacBag and self.TarmacBag.CurrentBP)
        end
    end,

    StopBeingBuiltEffects = function(self, builder, layer)
        StructureUnit.StopBeingBuiltEffects(self, builder, layer)
        self:BoneUpdate(self.Info.bones)
    end,

    OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
        local cat = categories[__blueprints[self.BpId].Display.AdjacencyConnection]

        if __blueprints[self.BpId].Display.AdjacencyExclusion then
            cat = cat - categories[__blueprints[self.BpId].Display.AdjacencyExclusion]
        end

        if EntityCategoryContains(cat, adjacentUnit) then
            local AX, AY, AZ = adjacentUnit:GetPositionXYZ()
            local dirs = { 'South', 'East', 'North', 'West', 'South' }
            local dir = dirs[math.floor(
                (
                    math.atan2(
                        self.CachePosition[1] - AX,
                        self.CachePosition[3] - AZ
                    ) * 0.63661977236758134307553505349006 -- 180 / pi / 90 -- 2 / pi
                ) + 3.5
            )]
            self.Info.ents[dir].ent = adjacentUnit
            self.Info.ents[dir].val[1] = true
        end
        self:BoneCalculation()
        StructureUnit.OnAdjacentTo(self, adjacentUnit, triggerUnit)
    end,

    BoneCalculation = function(self)
        local TowerCalc = 0
        --Show all the correct bones
        for i, v in self.Info.ents do
            if v.val[1] then
                TowerCalc = TowerCalc + v.val[2]
            end
            self:SetAllBones('BoneType', i, v.val[1])
        end
        self:SetAllBones('BoneType', 'Tower', TowerCalc ~= 200 )

        --Hide all conflicting bones.
        for i, v in self.Info.ents do
            if v.val[1] then
                self:SetAllBones('Conflict', i, false)
            end
        end
        if TowerCalc ~= 200 then
            self:SetAllBones('Conflict', 'Tower', false)
        end
        if self:GetBlueprint().Display.AdjacencyBeamConnections then
            for k1, v1 in self.Info.ents do
                if v1.val[1] then
                    for k, v in self.Info.bones do
                        if v.BoneType == 'Beam' then
                            if self:IsValidBone(k) and not v1.ent:IsDead() and v1.ent:IsValidBone(k) and not v1.beams[k] then
                                if not v1.beams then v1.beams = {} end
                                v1.beams[k] = AttachBeamEntityToEntity(self, k, v1.ent, k, self:GetArmy(), v.BeamType)
                                v1.ent.Trash:Add(v1.beams[k])
                            end
                        end
                    end
                end
            end
        end
        self:BoneUpdate(self.Info.bones)
    end,

    BoneUpdate = function(self, bones)
        for k, v in bones do
            if self:IsValidBone(k) then
                if v.Visibility then
                    self:ShowBone(k, true)
                else
                    self:HideBone(k, true)
                end
            end
        end
    end,

    SetAllBones = function(self, check, BoneType, action)
        for k, v in self.Info.bones do
            if type(v[check]) == "table" then
                for i, vn in v[check] do
                    if vn == BoneType then
                        v.Visibility = action
                    end
                end
            else
                if v[check] == BoneType then
                    v.Visibility = action
                end
            end
        end
    end,
}

CardinalWallGateUnit = Class(CardinalWallUnit) {
    OnCreate = function(self)
        CardinalWallUnit.OnCreate(self)
        self.Slider = CreateSlider(self, __blueprints[self.BpId].Display.GateEffects.GateSliderBone or 0, 0, 0, 0, 10, true)
        self.Trash:Add(self.Slider)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        CardinalWallUnit.OnStopBeingBuilt(self, builder, layer)
        self:ToggleGate('open')
    end,

    ToggleGate = function(self, order)
        local depth = __blueprints[self.BpId].SizeY * 0.95
        if order == 'open' then
            self:SetIntelRadius('vision', __blueprints[self.BpId].Intel.OpenVisionRadius or 0)
            self.Slider:SetGoal(0, -depth, 0)
            if self.blocker then
                self.blocker:Destroy()
                self.blocker = nil
            else
                --First time run
                self.blocker = CreateUnitHPR(__blueprints[self.BpId].FootprintDummyId,self:GetArmy(),self.CachePosition[1],self.CachePosition[2],self.CachePosition[3],0,0,0)
                self.blocker:Destroy()
                self.blocker = nil
            end
            if __blueprints[self.BpId].AI.TargetBones then
                for i, bone in __blueprints[self.BpId].AI.TargetBones do
                    if not self.TerrainSlope[bone] then
                        --hard coded version of OffsetBoneToTerrain(self, bone) from BrewLAN terrain utils file, for portablility.

                        if not self.TerrainSlope then self.TerrainSlope = {} end
                        --CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,

                        local GetBoneTerrainOffset = function(unit, bone)
                            local pos = unit:GetPosition(bone)
                            return GetTerrainHeight(pos[1],pos[3]) - pos[2]
                        end

                        self.TerrainSlope[bone] = CreateSlider(self, bone, 0, GetBoneTerrainOffset(self, bone) * (1 / (__blueprints[self.BpId].Display.UniformScale or 1)), 0, 1000)
                        ---
                    end
                end
            end
            self:SetCollisionShape( 'Box', __blueprints[self.BpId].CollisionOffsetX or 0, __blueprints[self.BpId].CollisionOffsetY or 0, __blueprints[self.BpId].CollisionOffsetZ or 0, __blueprints[self.BpId].SizeX * 0.5, __blueprints[self.BpId].SizeY * 0.1, __blueprints[self.BpId].SizeZ * 0.5)
        end
        if order == 'close' then
            self:SetIntelRadius('vision', __blueprints[self.BpId].Intel.VisionRadius or 5)
            self.Slider:SetGoal(0, 0, 0)
            if not self.blocker then
                self.blocker = CreateUnitHPR(__blueprints[self.BpId].FootprintDummyId,self:GetArmy(),self.CachePosition[1],self.CachePosition[2],self.CachePosition[3],0,0,0)
                self.Trash:Add(self.blocker)
            end
            if __blueprints[self.BpId].AI.TargetBones then
                for i, bone in __blueprints[self.BpId].AI.TargetBones do
                    if self.TerrainSlope[bone] then
                        self.TerrainSlope[bone]:Destroy()
                        self.TerrainSlope[bone] = nil
                    end
                end
            end
            self:RevertCollisionShape()
        end
    end,

    OnScriptBitSet = function(self, bit)
        if bit == 1 then
            self:ToggleGate('close')
        end
        CardinalWallUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            for k, v in self.Info.ents do
                if v.val[1] then
                    v.ent:SetScriptBit('RULEUTC_WeaponToggle',true)
                end
            end
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 1 then
            self:ToggleGate('open')
        end
        CardinalWallUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            for k, v in self.Info.ents do
                if v.val[1] then
                    v.ent:SetScriptBit('RULEUTC_WeaponToggle',false)
                end
            end
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        CardinalWallUnit.OnKilled(self, instigator, type, overkillRatio)
        if self.blocker then
           self.blocker:Destroy()
        end
    end,

    OnDestroy = function(self)
        if self.blocker then
           self.blocker:Destroy()
        end
        CardinalWallUnit.OnDestroy(self)
    end,
}

SelfDefendingCardinalWallUnit = Class(CardinalWallUnit) {
    CheckBuildRestriction = function(self, target_bp)
        return self:CanBuild(target_bp.BlueprintId)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        local function nilfun() end
        unitBeingBuilt.CreateTarmac = nilfun
        unitBeingBuilt.OnAdjacentTo = nilfun
        unitBeingBuilt.OnNotAdjacentTo = nilfun
        unitBeingBuilt.CreateAdjacentEffect = nilfun
        unitBeingBuilt.DestroyAdjacentEffects = nilfun

        CardinalWallUnit.OnStartBuild(self, unitBeingBuilt, order )
        if order ~= 'Upgrade' then
            if self:IsValidBone(self.BuildAttachBone) then
                unitBeingBuilt:AttachBoneTo(-2, self, self.BuildAttachBone)
            end
            self.AttachedUnit = unitBeingBuilt
        end
    end,

    OnScriptBitSet = function(self, bit)
        CardinalWallUnit.OnScriptBitSet(self, bit)
        if bit == 7 then
            if self.AttachedUnit then
                self.AttachedUnit:Destroy()
            end
            self:SetScriptBit('RULEUTC_SpecialToggle', false)
        end
    end,

    UpgradingState = State{
        -- Pass the built unit along
        OnStopBuild = function(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 then
                unitBuilding.AttachedUnit = self.AttachedUnit
                if unitBuilding:IsValidBone(unitBuilding.BuildAttachBone) then
                    self.AttachedUnit:AttachBoneTo(-2, unitBuilding, unitBuilding.BuildAttachBone)
                end
                self.AttachedUnit = nil
            end
            CardinalWallUnit.UpgradingState.OnStopBuild(self, unitBuilding)
        end,
    },
}
