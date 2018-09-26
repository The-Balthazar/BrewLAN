local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CDFParticleCannonWeapon = import('/lua/cybranweapons.lua').CDFParticleCannonWeapon
local Weapon = import('/lua/sim/Weapon.lua').Weapon
local EffectUtil = import('/lua/EffectUtilities.lua')

SRB2391 = Class(CStructureUnit) {
    Weapons = {
        MainGun = Class(CDFParticleCannonWeapon) {
            BeamType = import('/lua/defaultcollisionbeams.lua').UnstablePhasonLaserCollisionBeam,
            FxMuzzleFlash = {},--'/effects/emitters/particle_cannon_muzzle_02_emit.bp'},
            FxUpackingChargeEffects = import('/lua/EffectTemplates.lua').CMicrowaveLaserCharge01,
            FxUpackingChargeEffectScale = 1,
            DamageTickMultiplier = 2,

            OnCreate = function(self, ...)
                CDFParticleCannonWeapon.OnCreate(self, unpack(arg))
                self.DamageTickMultiplier = self:GetBlueprint().DamageTickMultiplier or self.DamageTickMultiplier
                self.unit.LastFiredTime = GetGameTick()
            end,

            CreateProjectileAtMuzzle = function(self, ...)
                local Gametick = GetGameTick()
                if not self.DamageModifiers then
                    self.DamageModifiers = {}
                end
                self.DamageModifiers.TeslaCharge = (Gametick - self.unit.LastFiredTime) * self.DamageTickMultiplier * (self.unit.EnergyMaintAdjMod or 1)
                local proj = CDFParticleCannonWeapon.CreateProjectileAtMuzzle(self, unpack(arg))
                self.unit.LastFiredTime = Gametick
                EffectUtil.CleanupEffectBag(self.unit,'TeslaEffectsBag')
                return proj
            end,
        },
        Dischage = Class(Weapon) {
            Effects = {
                '/effects/emitters/seraphim_othuy_hit_01_emit.bp',
                '/effects/emitters/seraphim_othuy_hit_02_emit.bp',
                '/effects/emitters/seraphim_othuy_hit_03_emit.bp',
                '/effects/emitters/seraphim_othuy_hit_04_emit.bp',
            },

            OnCreate = function(self)
                Weapon.OnCreate(self)
                self:SetWeaponEnabled(false)
            end,

            OnFire = function(self)
                local bp = self:GetBlueprint()
                local army = self.unit:GetArmy()
                self:PlaySound(bp.Audio.Fire)
                DamageArea(self.unit, self.unit:GetPosition(), bp.DamageRadius, bp.Damage * (GetGameTick() - self.unit.LastFiredTime), bp.DamageType, bp.DamageFriendly)
                for i, v in self.Effects do
                    CreateAttachedEmitter( self.unit, 0, army, v )
                end
            end,

        },
    },

    OnStopBeingBuilt = function(self, ...)
        CStructureUnit.OnStopBeingBuilt(self, unpack(arg))
        self:SetMaintenanceConsumptionActive()
        self:CreateOrbEntity()
        self.WeaponsActive = true
        self:CreateTeslaChargeEffects()
    end,

    OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
        if self:IsBeingBuilt() then return end
        if adjacentUnit:IsBeingBuilt() then return end
        for buffname, buff in self.Buffs.Affects.EnergyMaintenance or {} do
            if buff.Add < 0 then
                buff.Add = math.abs(buff.Add)
            end
        end
    end,

    CreateOrbEntity = function(self)
        --SphereEffectIdleMesh = '/effects/entities/cybranphalanxsphere01/cybranphalanxsphere01_mesh',
        self.SphereEffectEntity = import('/lua/sim/Entity.lua').Entity()
        self.SphereEffectEntity:AttachBoneTo( -1, self,'Orb' )
        self.SphereEffectEntity:SetMesh('/effects/entities/cybranphalanxsphere01/cybranphalanxsphere02_mesh')
        self.SphereEffectEntity:SetDrawScale(0.3)
        self.SphereEffectEntity:SetVizToAllies('Intel')
        self.SphereEffectEntity:SetVizToNeutrals('Intel')
        self.SphereEffectEntity:SetVizToEnemies('Intel')
        self.Trash:Add(self.SphereEffectEntity, CreateAttachedEmitter( self.SphereEffectEntity, 0, self:GetArmy(), '/effects/emitters/zapper_electricity_01_emit.bp' ):ScaleEmitter(0.5))
    end,

    DestroyOrbEntity = function(self)
        if self.SphereEffectEntity then
            self.SphereEffectEntity:Destroy()
        end
    end,

    CreateTeslaChargeEffects = function(self)
        self.TeslaEffectsBag = {}
        self:ForkThread(function()
            local gun = self:GetWeaponByLabel('MainGun')
            local gunbp = gun:GetBlueprint()
            while true do
                if self.WeaponsActive and self.LastFiredTime + (gunbp.Effects.ParticalStackIntervalTicks or 30) * (gunbp.Effects.ParticalStacksMax or 30) > GetGameTick() then
                    self.Trash:Add(table.insert(self.TeslaEffectsBag, CreateAttachedEmitter( self, 'Effect_00' .. math.random(1.5), self:GetArmy(), '/effects/emitters/cybran_t2power_ambient_01_emit.bp' ):OffsetEmitter(0,0.75,-.5):ScaleEmitter(math.random(10,15)*0.1 ) ) )
                end
                WaitTicks((gunbp.Effects.ParticalStackIntervalTicks or 30) + 1)
            end
        end)
    end,

    OnScriptBitSet = function(self, bit)
        CStructureUnit.OnScriptBitSet(self, bit)
        if bit == 4 then
            --DEACTIVATE
            self:SetWeaponEnabledByLabel('MainGun', false)
            self:DestroyOrbEntity()
            self:SetMaintenanceConsumptionInactive()
            self:StopUnitAmbientSound( 'ActiveLoop' )
            self.WeaponsActive = false
            EffectUtil.CleanupEffectBag(self,'TeslaEffectsBag')
        end
    end,

    OnScriptBitClear = function(self, bit)
        CStructureUnit.OnScriptBitClear(self, bit)
        if bit == 4 then
            --ACTIVATE
            self:SetWeaponEnabledByLabel('MainGun', true)
            self:CreateOrbEntity()
            self:SetMaintenanceConsumptionActive()
            self:PlayUnitAmbientSound( 'ActiveLoop' )
            self.WeaponsActive = true
            self.LastFiredTime = GetGameTick()
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
		if self.WeaponsActive then
            local discharge = self:GetWeaponByLabel('Dischage')
            discharge:SetWeaponEnabled(true)
            discharge:OnFire()
        end
        CStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
}

TypeClass = SRB2391
