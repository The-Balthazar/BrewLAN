local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CDFParticleCannonWeapon = import('/lua/cybranweapons.lua').CDFParticleCannonWeapon
local Weapon = import('/lua/sim/Weapon.lua').Weapon

local EMPDeathWeapon = Class(Weapon) {
    OnCreate = function(self)
        Weapon.OnCreate(self)
        self:SetWeaponEnabled(false)
    end,

    OnFire = function(self)
        local blueprint = self:GetBlueprint()
        DamageArea(self.unit, self.unit:GetPosition(), blueprint.DamageRadius, blueprint.Damage, blueprint.DamageType, blueprint.DamageFriendly)
    end,
}

SRB2391 = Class(CStructureUnit) {
    Weapons = {
        MainGun = Class(CDFParticleCannonWeapon) {
            BeamType = import('/lua/defaultcollisionbeams.lua').UnstablePhasonLaserCollisionBeam,
            FxMuzzleFlash = {},--'/effects/emitters/particle_cannon_muzzle_02_emit.bp'},
            FxUpackingChargeEffects = import('/lua/EffectTemplates.lua').CMicrowaveLaserCharge01,
            FxUpackingChargeEffectScale = 1,
            OnCreate = function(self, ...)
                CDFParticleCannonWeapon.OnCreate(self, unpack(arg))
                self.LastFiredTime = GetGameTick()
                --self.DamageMod = GetGameTick()
            end,

            CreateProjectileAtMuzzle = function(self, ...)
                local Gametick = GetGameTick()
                if not self.DamageModifiers then self.DamageModifiers = {} end
                self.DamageModifiers.TeslaCharge = (Gametick - self.LastFiredTime) * 2
                local proj = CDFParticleCannonWeapon.CreateProjectileAtMuzzle(self, unpack(arg))
                self.LastFiredTime = Gametick
                for i, v in self.unit.TeslaEffectsBag do
                    v:Destroy()
                end
                return proj
            end,
        },
        EMP = Class(EMPDeathWeapon) {},
    },

    OnStopBeingBuilt = function(self, ...)
        CStructureUnit.OnStopBeingBuilt(self, unpack(arg))
        --SphereEffectIdleMesh = '/effects/entities/cybranphalanxsphere01/cybranphalanxsphere01_mesh',
        self.SphereEffectEntity = import('/lua/sim/Entity.lua').Entity()
        self.SphereEffectEntity:AttachBoneTo( -1, self,'Orb' )
        self.SphereEffectEntity:SetMesh('/effects/entities/cybranphalanxsphere01/cybranphalanxsphere02_mesh')
        self.SphereEffectEntity:SetDrawScale(0.3)
        self.SphereEffectEntity:SetVizToAllies('Intel')
        self.SphereEffectEntity:SetVizToNeutrals('Intel')
        self.SphereEffectEntity:SetVizToEnemies('Intel')
        local emit = CreateAttachedEmitter( self, 'Orb', self:GetArmy(), '/effects/emitters/zapper_electricity_01_emit.bp' ):ScaleEmitter(0.5)
        self.Trash:Add(self.SphereEffectEntity)
        self.Trash:Add(emit)
        self:SetMaintenanceConsumptionActive()
        self.TeslaEffectsBag = {}
        self:ForkThread(function()
            local gun = self:GetWeaponByLabel('MainGun')
            while true do
                if gun.LastFiredTime + 900 > GetGameTick() then
                    self.Trash:Add(table.insert(self.TeslaEffectsBag, CreateAttachedEmitter( self, 'Effect_00' .. math.random(1.5), self:GetArmy(), '/effects/emitters/cybran_t2power_ambient_01_emit.bp' ):OffsetEmitter(0,0.75,-.5):ScaleEmitter(math.random(10,15)*0.1 ) ) )
                end
                WaitTicks(30)
            end
        end)
        self.UnitComplete = true
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        local emp = self:GetWeaponByLabel('EMP')
        local bp
        for k, v in self:GetBlueprint().Buffs do
            if v.Add.OnDeath then
                bp = v
            end
        end
        --if we could find a blueprint with v.Add.OnDeath, then add the buff
        if bp != nil then
            --Apply Buff
			self:AddBuff(bp)
        end
        --otherwise, we should finish killing the unit
		if self.UnitComplete then
            -- Play EMP Effect
            CreateLightParticle( self, -1, -1, 24, 62, 'flare_lens_add_02', 'ramp_red_10' )
            -- Fire EMP weapon
            emp:SetWeaponEnabled(true)
            emp:OnFire()
        end
        CStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
}

TypeClass = SRB2391
