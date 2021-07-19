local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CIFMissileLoaWeapon = CybranWeaponsFile.CIFMissileLoaWeapon
local CDFProtonCannonWeapon = CybranWeaponsFile.CDFProtonCannonWeapon
local CAANanoDartWeapon = CybranWeaponsFile.CAANanoDartWeapon
local CIFSmartCharge = CybranWeaponsFile.CIFSmartCharge
CybranWeaponsFile = nil

SRL0312 = Class(CLandUnit) {
    Weapons = {
        MissileRack = Class(CIFMissileLoaWeapon) {},
        AntiAir = Class(CAANanoDartWeapon) {
            CreateProjectileForWeapon = function(self, bone)
                local projectile = CAANanoDartWeapon.CreateProjectileForWeapon(self, bone)
                projectile:SetMesh('/projectiles/cifmissiletactical01/cifmissiletactical01_mesh')
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
            --self:GetWeaponManipulatorByLabel('GroundGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('AAGun'):GetHeadingPitch() )
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
            --self:GetWeaponManipulatorByLabel('AAGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('GroundGun'):GetHeadingPitch() )
        end
    end,
}

TypeClass = SRL0312
