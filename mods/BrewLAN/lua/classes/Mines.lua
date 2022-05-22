--------------------------------------------------------------------------------
-- Copyright : Sean 'Balthazar' Wheeldon
-- Mine structure units
--------------------------------------------------------------------------------
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local BareBonesWeapon = import('/lua/sim/DefaultWeapons.lua').BareBonesWeapon
local CreateScorchMarkSplat = import('/lua/defaultexplosions.lua').CreateScorchMarkSplat
local DefaultHitExplosion01 = import('/lua/effecttemplates.lua').DefaultHitExplosion01
local DefaultProjectileWaterImpact = import('/lua/effecttemplates.lua').DefaultProjectileWaterImpact
local TableCat = import('/lua/utilities.lua').TableCat
local DamageArea = DamageArea

--------------------------------------------------------------------------------
-- Mine script
--------------------------------------------------------------------------------
MineStructureUnit = Class(StructureUnit) {
    Weapons = {
        Suicide = Class(BareBonesWeapon) {
            FxDeathLand = DefaultHitExplosion01,
            FxDeathWater = {
                '/effects/emitters/seraphim_rifter_artillery_hit_01w_emit.bp',
                '/effects/emitters/seraphim_rifter_artillery_hit_02w_emit.bp',
                '/effects/emitters/seraphim_rifter_artillery_hit_03w_emit.bp',
                '/effects/emitters/seraphim_rifter_artillery_hit_05w_emit.bp',
                '/effects/emitters/seraphim_rifter_artillery_hit_06w_emit.bp',
                '/effects/emitters/seraphim_rifter_artillery_hit_08w_emit.bp',
            },
            FxDeathSeabed = DefaultProjectileWaterImpact,

            OnFire = function(self)
                local bp = self:GetBlueprint()
                local radius = bp.DamageRadius
                local army = self.unit:GetArmy()

                -- Do explosion effects
                local FxDeath = {
                    Land = self.FxDeathLand,
                    Water = self.FxDeathWater,
                    Seabed = TableCat(self.FxDeathSeabed, self.FxDeathLand),
                }
                for layer, effects in FxDeath do
                    if layer == self.unit:GetCurrentLayer() then
                        for k, v in effects do
                            CreateEmitterAtBone(self.unit,-2,army,v)
                        end
                        break
                    end
                end

                -- Do decal splats
                if not self.SplatTexture then
                    CreateScorchMarkSplat( self.unit, bp.DamageRadius * 0.5, army)
                else
                    if self.SplatTexture.Albedo then                                                                                                                                                                                    --LOD          Lifetime
                        CreateDecal( self.unit.CachePosition, Random()*6.2831853, (self.SplatTexture.Albedo[1] or self.SplatTexture.Albedo), '', 'Albedo', radius * (self.SplatTexture.Albedo[2] or 4), radius * (self.SplatTexture.Albedo[2] or 4), radius * 60, bp.Damage * 15, army )
                    end
                    if self.SplatTexture.AlphaNormals then
                        CreateDecal( self.unit.CachePosition, Random()*6.2831853, (self.SplatTexture.AlphaNormals[1] or self.SplatTexture.AlphaNormals), '', 'Alpha Normals', radius * (self.SplatTexture.AlphaNormals[2] or 2), radius * (self.SplatTexture.AlphaNormals[2] or 2), radius * 30, bp.Damage * 15, army )
                    end
                end

                self.unit.DeathWeaponEnabled = false

                self.unit:CosmeticDamage(radius)
                DamageArea(self.unit, self.unit.CachePosition, radius, bp.Damage, bp.DamageType or 'Normal', bp.DamageFriendly or false)

                self.unit:PlayUnitSound('Destroyed')
                self.unit:Destroy()
            end,
        },
    },

    CosmeticDamage = function(self, radius)
        local halfr = radius * 0.5
        DamageArea(self, self.CachePosition, halfr, 1, 'Force', true)
        DamageArea(self, self.CachePosition, halfr, 1, 'Force', true)
        DamageRing(self, self.CachePosition, 0.1, radius, 10, 'Fire', false, false)
    end,

    OnCreate = function(self,builder,layer)
        StructureUnit.OnCreate(self)
        --enable cloaking and stealth
        self:EnableIntel'Cloak'
        self:EnableIntel'RadarStealth'
        self:EnableIntel'SonarStealth'
        if not self.CachePosition then
            self.CachePosition = {moho.entity_methods.GetPositionXYZ(self)}
        end
        self.blocker = CreateUnitHPR(self:GetBlueprint().FootprintDummyId,self:GetArmy(),self.CachePosition[1],self.CachePosition[2],self.CachePosition[3],0,0,0)
        self.Trash:Add(self.blocker)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
        if self:GetCurrentLayer() == 'Sub' then
            local bp = __blueprints[self.BpId]
            self.Trash:Add(CreateSlider(self, 0, 0, -1, 0, 5, true))
            self:SetCollisionShape('Box',
                bp.CollisionOffsetX or 0,
                (bp.CollisionOffsetY or 0) - 1 + bp.SizeY * 0.5,
                bp.CollisionOffsetZ or 0,
                bp.SizeX * 0.5,
                bp.SizeY * 0.5,
                bp.SizeZ * 0.5
            )
        end
        if self.blocker then
            --This tricks the engine into thinking the area is clear:
            --Removing a building with an overlapping footprint from the same layer.
            self.blocker:Destroy()
        end
        --Force update of the cloak effect if there is a cloak mesh.
        if __blueprints[self.BpId].Display.CloakMeshBlueprint then
            self:ForkThread(
                function()
                    coroutine.yield(1)
                    self:UpdateCloakEffect(true, 'Cloak')
                end
            )
        end
    end,

    OnScriptBitSet = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self:GetWeaponByLabel'Suicide':FireWeapon()
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        StructureUnit.OnKilled(self, instigator, type, 2)
    end,
}

--------------------------------------------------------------------------------
-- Nuke Mine script
--------------------------------------------------------------------------------
NukeMineStructureUnit = Class(MineStructureUnit) {
    Weapons = {
        Suicide = Class(BareBonesWeapon) {
            OnFire = function(self)
                local bp = self:GetBlueprint() -- Weapon blueprint

                local proj = self.unit:CreateProjectile(bp.ProjectileId, 0, 0, 0, nil, nil, nil):SetCollision(false)
                proj:ForkThread(proj.EffectThread)

                if __blueprints[bp.ProjectileId].Audio.NukeExplosion then
                    self:PlaySound(__blueprints[bp.ProjectileId].Audio.NukeExplosion)
                end

                self.unit.DeathWeaponEnabled = false
                DamageArea(self.unit, self.unit.CachePosition, bp.NukeInnerRingRadius, bp.NukeInnerRingDamage, 'Nuke', true, true)
                DamageArea(self.unit, self.unit.CachePosition, bp.NukeOuterRingRadius, bp.NukeOuterRingDamage, 'Nuke', true, true)

                self.unit:CosmeticDamage(bp.NukeInnerRingRadius)
                self.unit:Destroy()
            end,
        },

        DeathWeapon = Class(BareBonesWeapon) {
            OnFire = function(self) end,
            Fire = function(self)
                if self.unit.DeathWeaponEnabled ~= false then
                    local myBlueprint = self:GetBlueprint()
                    local myProjectile = self.unit:CreateProjectile(myBlueprint.ProjectileId, 0, 0, 0, nil, nil, nil):SetCollision(false)
                    myProjectile:PassDamageData(self:GetDamageTable())
                end
            end,
        },
    },

    OnCreate = function(self,builder,layer)
        MineStructureUnit.OnCreate(self,builder,layer)
        self:SetFireState(1) --0 return fire, 1 hold fire, 2 ground fire
    end,
}
