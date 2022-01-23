local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local cWeapons = import('/lua/cybranweapons.lua')
local CDFElectronBolterWeapon = cWeapons.CDFElectronBolterWeapon
local CANTorpedoLauncherWeapon = cWeapons.CANTorpedoLauncherWeapon
local CAMZapperWeapon02 = cWeapons.CAMZapperWeapon02
local CAAAutocannon = cWeapons.CAAAutocannon
local CDFProtonCannonWeapon = cWeapons.CDFProtonCannonWeapon
local CIFArtilleryWeapon = cWeapons.CIFArtilleryWeapon

SRL0403 = Class(CLandUnit) {
    Weapons = {
        Turret = Class(CDFElectronBolterWeapon) {},
        Torpedo = Class(CANTorpedoLauncherWeapon) {},
        Cannon = Class(CDFProtonCannonWeapon) {},
        AA = Class(CAAAutocannon) {},
        Zapper = Class(CAMZapperWeapon02) {},
        MainGun = Class(CIFArtilleryWeapon) {
            FxMuzzleFlashScale = 0.6,
            FxGroundEffect = EffectTemplate.CDisruptorGroundEffect,
	        FxVentEffect = EffectTemplate.CDisruptorVentEffect,
	        FxMuzzleEffect = EffectTemplate.CElectronBolterMuzzleFlash01,
	        FxCoolDownEffect = EffectTemplate.CDisruptorCoolDownEffect,

	        PlayFxMuzzleSequence = function(self, muzzle)
		        local army = self.unit:GetArmy()
		        DefaultProjectileWeapon.PlayFxMuzzleSequence(self, muzzle)
	            for k, v in self.FxGroundEffect do
                    CreateAttachedEmitter(self.unit, 'URB2302', army, v)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'Exhaust_Left', army, v)
                    CreateAttachedEmitter(self.unit, 'Exhaust_Right', army, v)
                end
  	            for k, v in self.FxMuzzleEffect do
                    CreateAttachedEmitter(self.unit, 'Turret_Muzzle', army, v)
                end
  	            for k, v in self.FxCoolDownEffect do
                    CreateAttachedEmitter(self.unit, 'Barrel_B01', army, v)
                end
            end,
        }
    },

	OnLayerChange = function(self, new, old)
		CLandUnit.OnLayerChange(self, new, old)
		if new == 'Land' then
            self:SetSpeedMult(1)
		elseif new == 'Seabed' then
            self:SetSpeedMult(self:GetBlueprint().Physics.WaterSpeedMultiplier)
		end
	end,

    OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        self:EnableUnitIntel('RadarStealth')
        self:EnableUnitIntel('SonarStealth')
        self:RequestRefreshUI()
    end,

    OnScriptBitSet = function(self, bit)
        CLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self:SetWeaponEnabledByLabel('MainGun', false)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self:SetWeaponEnabledByLabel('MainGun', true)
        end
    end,
}

TypeClass = SRL0403
