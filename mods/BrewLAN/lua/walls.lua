local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local TerrainUtils = import(BrewLANPath .. '/lua/TerrainUtils.lua')
local OffsetBoneToTerrain = TerrainUtils.OffsetBoneToTerrain
--------------------------------------------------------------------------------
-- Wall scripts
--------------------------------------------------------------------------------
function CardinalWallUnit(SuperClass)
    return Class(SuperClass) {
        OnCreate = function(self)
            local bp = self:GetBlueprint()
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
            for i, v in bp.Display.AdjacencyConnectionInfo.Bones do
                self.Info.bones[i] = {}
                for j, k in v do
                    self.Info.bones[i][j] = k
                end
            end
            if bp.Display.AdjacencyConnection then
                self.BeamEffectsBag = {}
            end
            if bp.Display.Tarmacs[1] and self:GetCurrentLayer() == 'Land' and not self:HasTarmac() then
                if self.TarmacBag then
                    self:CreateTarmac(true, true, true, self.TarmacBag.Orientation, self.TarmacBag.CurrentBP)
                else
                    self:CreateTarmac(true, true, true, false, false)
                end
            end
            if bp.General.FactionName != 'UEF' then
                self:BoneUpdate(self.Info.bones)
            end
            SuperClass.OnCreate(self)
        end,

        StopBeingBuiltEffects = function(self, builder, layer)
            SuperClass.StopBeingBuiltEffects(self, builder, layer)
            if self:GetBlueprint().General.FactionName == 'UEF' then
                self:BoneUpdate(self.Info.bones)
            end
        end,

        OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
            local dirs = { 'South', 'East', 'East', 'North', 'North', 'West', 'West', 'South'}
            local MyX, MyY, MyZ = unpack(self:GetPosition())
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
            if TowerCalc != 200 then
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
            self.Slider = CreateSlider(self, self:GetBlueprint().Display.GateEffects.GateSliderBone or 0)
            self.Trash:Add(self.Slider)
        end,

        OnStopBeingBuilt = function(self,builder,layer)
            SuperClass.OnStopBeingBuilt(self, builder, layer)
            self:ToggleGate('open')
        end,

        ToggleGate = function(self, order)
            local bp = self:GetBlueprint()
            local scale = 1 / bp.Display.UniformScale or 1
            local depth = bp.SizeY * scale * 0.95
            if order == 'open' then
                self.Slider:SetGoal(0, -depth, 0)
                self.Slider:SetSpeed(200)
                if self.blocker then
                   self.blocker:Destroy()
                   self.blocker = nil
                end
                if bp.AI.TargetBones then
                    for i, bone in bp.AI.TargetBones do
                        if not self.TerrainSlope[bone] then
                            OffsetBoneToTerrain(self, bone)
                        end
                    end
                end
                self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0, bp.CollisionOffsetY or 0, bp.CollisionOffsetZ or 0, bp.SizeX * 0.5, bp.SizeY * 0.1, bp.SizeZ * 0.5)
            end
            if order == 'close' then
                self.Slider:SetGoal(0, 0, 0)
                self.Slider:SetSpeed(200)
                if not self.blocker then
                   local pos = self:GetPosition()
                   self.blocker = CreateUnitHPR('ZZZ5301',self:GetArmy(),pos[1],pos[2],pos[3],0,0,0)
                   self.Trash:Add(self.blocker)
                end
                if bp.AI.TargetBones then
                    for i, bone in bp.AI.TargetBones do
                        if self.TerrainSlope[bone] then
                            self.TerrainSlope[bone]:Destroy()
                            self.TerrainSlope[bone] = nil
                        end
                    end
                end
                self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0, bp.CollisionOffsetY or 0, bp.CollisionOffsetZ or 0, bp.SizeX * 0.5, bp.SizeY, bp.SizeZ * 0.5)
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
