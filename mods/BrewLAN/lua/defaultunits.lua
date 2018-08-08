--------------------------------------------------------------------------------
-- Summary  :  BrewLAN multi-unit scripts.
--------------------------------------------------------------------------------
local DefaultUnits = import('/lua/defaultunits.lua')
local StructureUnit = DefaultUnits.StructureUnit
local FactoryUnit = DefaultUnits.FactoryUnit
local EnergyStorageUnit = DefaultUnits.EnergyStorageUnit
--------------------------------------------------------------------------------
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local DefaultWeapons = import('/lua/sim/DefaultWeapons.lua')
local DeathNukeWeapon = import(BrewLANPath .. '/lua/sim/defaultweapons.lua').DeathNukeWeapon
local EnergyStorageVariableDeathWeapon = import(BrewLANPath .. '/lua/weapons.lua').EnergyStorageVariableDeathWeapon
local GetTerrainAngles = import(BrewLANPath .. '/lua/TerrainUtils.lua').GetTerrainSlopeAnglesDegrees
--------------------------------------------------------------------------------
local EffectTemplates = import('/lua/effecttemplates.lua')
local CreateScorchMarkSplat = import('/lua/defaultexplosions.lua').CreateScorchMarkSplat
local GetRandomFloat = import('/lua/utilities.lua').GetRandomFloat
local TableCat = import('/lua/utilities.lua').TableCat
local EBPSRA = '/effects/emitters/seraphim_rifter_artillery_hit_'
--------------------------------------------------------------------------------
-- Mine script
--------------------------------------------------------------------------------

MineStructureUnit = Class(StructureUnit) {
    Weapons = {
        Suicide = Class(DefaultWeapons.KamikazeWeapon) {

            FxDeathLand = EffectTemplates.DefaultHitExplosion01,
            FxDeathWater = {
                EBPSRA .. '01w_emit.bp',
                EBPSRA .. '02w_emit.bp',
                EBPSRA .. '03w_emit.bp',
                EBPSRA .. '05w_emit.bp',
                EBPSRA .. '06w_emit.bp',
                EBPSRA .. '08w_emit.bp',
            },
            FxDeathSeabed = EffectTemplates.DefaultProjectileWaterImpact,

            OnFire = function(self)
                local bp = self:GetBlueprint()
                local radius = bp.DamageRadius
                local army = self.unit:GetArmy()
                local pos = self.unit:GetPosition()
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
                    end
                end
                if not self.SplatTexture then
                    CreateScorchMarkSplat( self.unit, bp.DamageRadius * 0.5, army)
                else
                    if self.SplatTexture.Albedo then                                                                                                                                                                                    --LOD          Lifetime
                        CreateDecal( pos, GetRandomFloat(0,2*math.pi), (self.SplatTexture.Albedo[1] or self.SplatTexture.Albedo), '', 'Albedo', radius * (self.SplatTexture.Albedo[2] or 4), radius * (self.SplatTexture.Albedo[2] or 4), radius * 60, bp.Damage * 15, army )
                    end
                    if self.SplatTexture.AlphaNormals then
                        CreateDecal( pos, GetRandomFloat(0,2*math.pi), (self.SplatTexture.AlphaNormals[1] or self.SplatTexture.AlphaNormals), '', 'Alpha Normals', radius * (self.SplatTexture.AlphaNormals[2] or 2), radius * (self.SplatTexture.AlphaNormals[2] or 2), radius * 30, bp.Damage * 15, army )
                    end
                end
                DamageArea(self.unit, pos, radius * 0.5, 1, 'Force', true)
                DamageArea(self.unit, pos, radius * 0.5, 1, 'Force', true)
                DamageRing(self.unit, pos, 0.1, radius, 10, 'Fire', false, false)
                self.unit.DeathWeaponEnabled = false
                DefaultWeapons.KamikazeWeapon.OnFire(self)
            end,
        },
    },

    OnCreate = function(self,builder,layer)
        StructureUnit.OnCreate(self)
        --enable cloaking and stealth
        self:EnableIntel('Cloak')
        self:EnableIntel('RadarStealth')
        self:EnableIntel('SonarStealth')
        local pos = self:GetPosition()
        self.blocker = CreateUnitHPR('ZZZ2220',self:GetArmy(),pos[1],pos[2],pos[3],0,0,0)
        self.Trash:Add(self.blocker)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
        local bp = self:GetBlueprint()
        if self:GetCurrentLayer() == 'Water' then
            self.Trash:Add(CreateSlider(self, 0, 0, -1 * 1 / bp.Display.UniformScale, 0, 5))
        end
        if self.blocker then
            --This tricks the engine into thinking the area is clear:
            --Removing a building with an overlapping footprint from the same layer.
            self.blocker:Destroy()
        end
        --Force update of the cloak effect if there is a cloak mesh. For FAF graphics
        if self:GetBlueprint().Display.CloakMeshBlueprint then
            self:ForkThread(
                function()
                    WaitTicks(1)
                    self:UpdateCloakEffect(true, 'Cloak')
                end
            )
        end
    end,

    OnScriptBitSet = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self:GetWeaponByLabel('Suicide'):FireWeapon()
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
        DeathWeapon = Class(DefaultWeapons.BareBonesWeapon) {
            OnFire = function(self)
            end,

            Fire = function(self)
                local myBlueprint = self:GetBlueprint()
                local myProjectile = self.unit:CreateProjectile(myBlueprint.ProjectileId, 0, 0, 0, nil, nil, nil):SetCollision(false)
                myProjectile:PassDamageData(self:GetDamageTable())
            end,
        },
        Suicide = Class(DeathNukeWeapon) {
            Fire = function(self, ...)
                local radius = self:GetBlueprint().NukeInnerRingRadius or self:GetBlueprint().DamageRadius
                local pos = self.unit:GetPosition()
                DamageArea(self.unit, pos, radius * 0.5, 1, 'Force', true)
                DamageArea(self.unit, pos, radius * 0.5, 1, 'Force', true)
                DamageRing(self.unit, pos, 0.1, radius, 10, 'Fire', false, false)
                self.unit.DeathWeaponEnabled = false
                DeathNukeWeapon.Fire(self, unpack(arg) )
            end,
        },
    },
}

--------------------------------------------------------------------------------
-- Wall scripts
--------------------------------------------------------------------------------

StackingBuilderUnit = Class(FactoryUnit) {

    BuildAttachBone = 'WallNode',

    OnCreate = function(self,builder,layer)
        self:AddBuildRestriction(categories.ANTINAVY)
        self:AddBuildRestriction(categories.HYDROCARBON)
        FactoryUnit.OnCreate(self,builder,layer)
    end,

    CreateBlinkingLights = function(self, color)
    end,

    FinishBuildThread = function(self, unitBeingBuilt, order )
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationFinishBuildLand
        --self:DestroyBuildRotator()
        if order != 'Upgrade' then
            ChangeState(self, self.RollingOffState)
        else
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
        end
        self.AttachedUnit = unitBeingBuilt
    end,

    StartBuildFx = function(self, unitBeingBuilt)
    end,

    OnDamage = function(self, instigator, amount, vector, damageType)
        FactoryUnit.OnDamage(self, instigator, amount, vector, damageType)
        if self.AttachedUnit and not self.AttachedUnit:IsDead() then
            self.AttachedUnit:OnDamage(instigator, amount * 0.5, vector, damageType)
        end
    end,

    OnScriptBitSet = function(self, bit)
        FactoryUnit.OnScriptBitSet(self, bit)
        if bit == 7 then
            if self.AttachedUnit then
                self.AttachedUnit:Destroy()
            end
            self:SetScriptBit('RULEUTC_SpecialToggle',false)
            IssueClearCommands({self})
        end
    end,

    UpgradingState = State(FactoryUnit.UpgradingState) {
        Main = function(self)
            FactoryUnit.UpgradingState.Main(self)
        end,

        OnStopBuild = function(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 then
                if self.AttachedUnit then
                    self.AttachedUnit:Destroy()
                end
            end
            FactoryUnit.UpgradingState.OnStopBuild(self, unitBuilding)
        end,
    }
}

--------------------------------------------------------------------------------
-- Energy storage variable explosion scripts
--------------------------------------------------------------------------------

BrewLANEnergyStorageUnit = Class(EnergyStorageUnit) {

    Weapons = {
        DeathWeapon = Class(EnergyStorageVariableDeathWeapon) {},
    },

    OnKilled = function(self, instigator, type, overkillRatio)
        local curEnergy = GetArmyBrain(self:GetArmy()):GetEconomyStoredRatio('ENERGY')
        local ReductionMult = 1 - curEnergy

        local weapon = self:GetWeaponByLabel('DeathWeapon')
        local weaponbp = weapon:GetBlueprint()
        local damage = weaponbp.Damage - 1000
        local radius = weaponbp.DamageRadius - 3
        --LOG( - radius * ReductionMult)
        --LOG( - damage * ReductionMult)
        weapon.DamageRadiusMod = - radius * ReductionMult
        weapon.DamageMod = - damage * ReductionMult

        if curEnergy < 0.2 then
            weapon.FxDeath = EffectTemplates.ExplosionEffectsSml01
        elseif curEnergy < 0.4 then
            weapon.FxDeath = EffectTemplates.ExplosionEffectsSml01
        elseif curEnergy < 0.6 then
            weapon.FxDeath = EffectTemplates.ExplosionEffectsMed01
        elseif curEnergy < 0.8 then
            weapon.FxDeath = EffectTemplates.ExplosionEffectsLrg01
        elseif curEnergy < 0.9 then
            weapon.FxDeath = EffectTemplates.ExplosionEffectsLrg01
        elseif curEnergy <= 1.0 then
            weapon.FxDeath = EffectTemplates.ExplosionEffectsLrg02
        end

        EnergyStorageUnit.OnKilled(self)
    end,
}
