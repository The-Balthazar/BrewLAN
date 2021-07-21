local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CIFMissileLoaWeapon = CybranWeaponsFile.CIFMissileLoaWeapon
local CDFProtonCannonWeapon = CybranWeaponsFile.CDFProtonCannonWeapon
local CAANanoDartWeapon = CybranWeaponsFile.CAANanoDartWeapon
local CIFSmartCharge = CybranWeaponsFile.CIFSmartCharge
CybranWeaponsFile = nil
local meshfile = string.gsub(__blueprints.srl0312.Source, 'units/srl0312/srl0312_unit.bp', '') .. 'projectiles/ciftoxmissiletactical01/ciftoxmissiletactical01_mesh'

SRL0312 = Class(CLandUnit) {
    Weapons = {
        MissileRack = Class(CIFMissileLoaWeapon) {},
        AntiAir = Class(CAANanoDartWeapon) {
            CreateProjectileForWeapon = function(self, bone)
                local projectile = CAANanoDartWeapon.CreateProjectileForWeapon(self, bone)
                projectile:SetMesh(meshfile)
                projectile:SetScale(__blueprints.srl0312.Display.UniformScale)
                return projectile
            end,
        },
        Proton = Class(CDFProtonCannonWeapon) {},
        AntiTorpedo = Class(CIFSmartCharge) {},
    },

    OnCreate = function(self)
        CLandUnit.OnCreate(self)
        self:SetScriptBit('RULEUTC_WeaponToggle', true)
    end,

    OnScriptBitSet = function(self, bit)
        CLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            local Rack = self:GetWeaponByLabel('MissileRack')
            Rack:ChangeMaxRadius(__blueprints.srl0312.Weapon[1].MaxRadius)
            Rack:SetWeaponEnabled(true)
            --self:SetWeaponEnabledByLabel('MissileRack', true)
            self:SetWeaponEnabledByLabel('AntiAir', false)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            local Rack = self:GetWeaponByLabel('MissileRack')
            Rack:ChangeMaxRadius(__blueprints.srl0312.Weapon[2].MaxRadius)
            Rack:SetWeaponEnabled(false)
            --self:SetWeaponEnabledByLabel('MissileRack', false)
            self:SetWeaponEnabledByLabel('AntiAir', true)
        end
    end,
}

TypeClass = SRL0312
