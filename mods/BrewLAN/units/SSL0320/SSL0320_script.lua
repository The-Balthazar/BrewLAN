--------------------------------------------------------------------------------
--  Summary  :  Seraphim Mobile AA/TMD
--------------------------------------------------------------------------------
local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit
local SAALosaareAutoCannonWeapon = import('/lua/seraphimweapons.lua').SAALosaareAutoCannonWeapon
local SAMElectrumMissileDefense = import('/lua/seraphimweapons.lua').SAMElectrumMissileDefense
--------------------------------------------------------------------------------
SSL0320 = Class(SLandUnit) {
    Weapons = {
        AntiMissile = Class(SAMElectrumMissileDefense) {
            --[[OnLostTarget = function(self)
                LOG("AA ON")
                self.unit:SetWeaponEnabledByLabel('AntiAirMissiles', true)
                SAMElectrumMissileDefense.OnLostTarget(self)
            end,

            IdleState = State {
                OnGotTarget = function(self)
                    if self.unit.WeaponPriority == 'TMD' then
                        LOG("AA OFF")
                        self.unit:SetWeaponEnabledByLabel('AntiAirMissiles', false)
                    end
                    LOG("TMD OnGotTarget")
                    SAMElectrumMissileDefense.IdleState.OnGotTarget(self)
                end,
            },]]
        },
        AntiAirMissiles = Class(SAALosaareAutoCannonWeapon) {
            --[[OnLostTarget = function(self)
                LOG("TMD ON")
                self.unit:SetWeaponEnabledByLabel('AntiMissile', true)
                SAALosaareAutoCannonWeapon.OnLostTarget(self)
            end,

            IdleState = State {
                OnGotTarget = function(self)
                    if self.unit.WeaponPriority == 'AA' then
                        LOG("TMD OFF")
                        self.unit:SetWeaponEnabledByLabel('AntiMissile', false)
                    end
                    LOG("AA OnGotTarget")
                    SAALosaareAutoCannonWeapon.IdleState.OnGotTarget(self)
                end,
            },]]
        },
    },
--[[
    OnStopBeingBuilt = function(self, ...)
        SLandUnit.OnScriptBitSet(self, unpack(arg))
        self.WeaponPriority = 'AA'
    end,

    OnScriptBitSet = function(self, bit)
        SLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.WeaponPriority = 'TMD'
            self:SetWeaponEnabledByLabel('AntiMissile', true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        SLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self.WeaponPriority = 'AA'
            self:SetWeaponEnabledByLabel('AntiAirMissiles', true)
        end
    end,]]
}

TypeClass = SSL0320
