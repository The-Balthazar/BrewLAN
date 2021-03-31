--------------------------------------------------------------------------------
-- Description: Wall scripts
-- © 2015‒2020 Sean Wheeldon
--------------------------------------------------------------------------------
function CardinalWallUnit(SuperClass)
    return Class(SuperClass) {
        OnCreate = function(self)
            if not self.CachePosition then
                self.CachePosition = table.copy(moho.entity_methods.GetPosition(self))
            end
            self.BpId = self:GetBlueprint().BlueprintId
            self.Info = {
                ents = {
                    ['North'] = {
                        ent = {},
                        val = {false, 99 },
                    },
                    ['South'] = {
                        ent = {},
                        val = {false, 101},
                    },
                    ['East'] = {
                        ent = {},
                        val = {false, 97},
                    },
                    ['West'] = {
                        ent = {},
                        val = {false, 103},
                    },
                },
                bones = {}
            }
            for i, v in __blueprints[self.BpId].Display.AdjacencyConnectionInfo.Bones do
                self.Info.bones[i] = {}
                for j, k in v do
                    self.Info.bones[i][j] = k
                end
            end
            if __blueprints[self.BpId].Display.AdjacencyConnection then
                self.BeamEffectsBag = {}
            end
            if __blueprints[self.BpId].General.FactionName ~= 'UEF' then
                self:BoneUpdate(self.Info.bones)
            end
            SuperClass.OnCreate(self)
        end,

        StartBeingBuiltEffects = function(self, builder, layer)
            SuperClass.StartBeingBuiltEffects(self, builder, layer)
            if __blueprints[self.BpId].Display.Tarmacs[1] and self:GetCurrentLayer() == 'Land' and not self:HasTarmac() then
                if self.TarmacBag then
                    self:CreateTarmac(true, true, true, self.TarmacBag.Orientation, self.TarmacBag.CurrentBP)
                else
                    self:CreateTarmac(true, true, true, false, false)
                end
            end
        end,

        StopBeingBuiltEffects = function(self, builder, layer)
            SuperClass.StopBeingBuiltEffects(self, builder, layer)
            if self:GetBlueprint().General.FactionName == 'UEF' then
                self:BoneUpdate(self.Info.bones)
            end
        end,

        OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
            local dirs = { 'South', 'East', 'East', 'North', 'North', 'West', 'West', 'South'}
            local MyX, MyY, MyZ = unpack(self.CachePosition)
            local AX, AY, AZ = unpack(adjacentUnit:GetPosition())
            local cat = self:GetBlueprint().Display.AdjacencyConnection
            if EntityCategoryContains(categories[cat], adjacentUnit) then
                local dir = dirs[math.ceil(((math.atan2(MyX - AX, MyZ - AZ) * 180 / math.pi) + 180)/45)]
                self.Info.ents[dir].ent = adjacentUnit
                self.Info.ents[dir].val[1] = true
            end
            self:BoneCalculation()
            SuperClass.OnAdjacentTo(self, adjacentUnit, triggerUnit)
        end,

        BoneCalculation = function(self)
            local TowerCalc = 0
            --Show all the correct bones
            for i, v in self.Info.ents do
                if v.val[1] == true then
                    TowerCalc = TowerCalc + v.val[2]
                    self:SetAllBones('bonetype', i, 'show')
                else
                    self:SetAllBones('bonetype', i, 'hide')
                end
            end
            if TowerCalc == 200 then
                self:SetAllBones('bonetype', 'Tower', 'hide')
            else
                self:SetAllBones('bonetype', 'Tower', 'show')
            end
            --Hide all conflicting bones.
            for i, v in self.Info.ents do
                if v.val[1] == true then
                    self:SetAllBones('conflict', i, 'hide')
                end
            end
            if TowerCalc ~= 200 then
                self:SetAllBones('conflict', 'Tower', 'hide')
            end
            if self:GetBlueprint().Display.AdjacencyBeamConnections then
                for k1, v1 in self.Info.ents do
                    if v1.val[1] then
                        for k, v in self.Info.bones do
                            if v.bonetype == 'Beam' then
                                if self:IsValidBone(k) and not v1.ent:IsDead() and v1.ent:IsValidBone(k) and not v1.beams[k] then
                                    if not v1.beams then v1.beams = {} end
                                    v1.beams[k] = AttachBeamEntityToEntity(self, k, v1.ent, k, self:GetArmy(), v.beamtype)
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
                if v.visibility == 'show' then
                    if self:IsValidBone(k) then
                        self:ShowBone(k, true)
                    end
                else
                    if self:IsValidBone(k) then
                        self:HideBone(k, true)
                    end
                end
            end
        end,

        SetAllBones = function(self, check, bonetype, action)
            for k, v in self.Info.bones do
                if type(v[check]) == "table" then
                    for i, vn in v[check] do
                        if vn == bonetype then
                            v.visibility = action
                        end
                    end
                else
                    if v[check] == bonetype then
                        v.visibility = action
                    end
                end
            end
        end,
    }
end

function GateWallUnit(SuperClass)
    return Class(SuperClass) {
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            self.Slider = CreateSlider(self, __blueprints[self.BpId].Display.GateEffects.GateSliderBone or 0, 0, 0, 0, 10, true)
            self.Trash:Add(self.Slider)
        end,

        OnStopBeingBuilt = function(self,builder,layer)
            SuperClass.OnStopBeingBuilt(self, builder, layer)

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
            SuperClass.OnScriptBitSet(self, bit)
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
            SuperClass.OnScriptBitClear(self, bit)
            if bit == 1 then
                for k, v in self.Info.ents do
                    if v.val[1] then
                        v.ent:SetScriptBit('RULEUTC_WeaponToggle',false)
                    end
                end
            end
        end,

        OnKilled = function(self, instigator, type, overkillRatio)
            SuperClass.OnKilled(self, instigator, type, overkillRatio)
            if self.blocker then
               self.blocker:Destroy()
            end
        end,

        OnDestroy = function(self)
            if self.blocker then
               self.blocker:Destroy()
            end
            SuperClass.OnDestroy(self)
        end,
    }
end
