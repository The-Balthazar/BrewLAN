#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB1105/UAB1105_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Aeon Energy Storage
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SEnergyStorageUnit = import('/lua/seraphimunits.lua').SEnergyStorageUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

XSB1105 = Class(SEnergyStorageUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        SEnergyStorageUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateStorageManip(self, 'B01', 'ENERGY', 0, 0, -.88, 0, 0, 0))
    end,


    Weapons = {
        DeathWeapon0 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsSml01,
        },
        DeathWeapon1 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsSml01,
        },
        DeathWeapon2 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsMed01,
        },
        DeathWeapon3 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsMed01,
        },
        DeathWeapon4 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsLrg01,
        },
        DeathWeapon5 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsLrg01,
        },
        DeathWeapon6 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsLrg02,
        },
    },

    OnKilled = function(self, instigator, type, overkillRatio)


                local bp = self:GetBlueprint()
                local aiBrain = GetArmyBrain(self:GetArmy())
                local curEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')

                if self:IsBeingBuilt() then 
                else
                    if curEnergy < 0.2 then
                        self:GetWeaponByLabel('DeathWeapon0'):FireWeapon()
                        #LOG('Weapon0')
                    elseif curEnergy < 0.4 then
                        self:GetWeaponByLabel('DeathWeapon1'):FireWeapon()
                        #LOG('Weapon1')
                    elseif curEnergy < 0.6 then
                        self:GetWeaponByLabel('DeathWeapon2'):FireWeapon()
                        #LOG('Weapon2')
                    elseif curEnergy < 0.8 then
                        self:GetWeaponByLabel('DeathWeapon3'):FireWeapon()
                        #LOG('Weapon3')
                    elseif curEnergy < 0.9 then
                        self:GetWeaponByLabel('DeathWeapon4'):FireWeapon()
                        #LOG('Weapon4')
                    elseif curEnergy <= 1.0 then
                        self:GetWeaponByLabel('DeathWeapon5'):FireWeapon()
                        #LOG('Weapon5')
                    end
                end

        SEnergyStorageUnit.OnKilled(self)
    end,
}

TypeClass = XSB1105